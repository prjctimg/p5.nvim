"""Tests for CDPClient and CDP HTTP handlers in server.py."""
import asyncio
import json
import os
import sys
import tempfile
import unittest
from collections import deque
from unittest.mock import AsyncMock, MagicMock, patch

import websockets

sys.argv = ['server.py', '8000']
sys.path.insert(0, '.')

from server import CDPClient, FileWatcher, HTTPServer, LiveReloadServer, \
    CONFIG, _parse_config, read_inject_script, INJECT_CONSOLE, INJECT_LIVERELOAD


class TestCDPClientInit(unittest.TestCase):
    def test_init_defaults(self):
        c = CDPClient(9222)
        self.assertEqual(c.cdp_port, 9222)
        self.assertIsNone(c.ws)
        self.assertEqual(c.page_url, '')
        self.assertFalse(c.connected)
        self.assertEqual(c._msg_id, 0)
        self.assertEqual(c._pending, {})
        self.assertIsNone(c._recv_task)
        self.assertIsInstance(c.event_buffer, deque)
        self.assertEqual(c.event_buffer.maxlen, 2000)
        self.assertEqual(c.pending_requests, {})
        self.assertIsInstance(c.completed_requests, deque)
        self.assertEqual(c.completed_requests.maxlen, 500)

    def test_next_id_increments(self):
        c = CDPClient(9222)
        self.assertEqual(c._next_id(), 1)
        self.assertEqual(c._next_id(), 2)
        self.assertEqual(c._next_id(), 3)

    def test_emit_and_drain_events(self):
        c = CDPClient(9222)
        c._emit('console', {'level': 'log', 'message': 'hello'})
        c._emit('network', {'url': '/test.js'})
        self.assertEqual(len(c.event_buffer), 2)
        events = c.drain_events()
        self.assertEqual(len(events), 2)
        self.assertEqual(events[0], ('console', {'level': 'log', 'message': 'hello'}))
        self.assertEqual(len(c.event_buffer), 0)

    def test_get_and_clear_network_log(self):
        c = CDPClient(9222)
        c.completed_requests.append({'url': '/a.js', 'status': 200})
        c.completed_requests.append({'url': '/b.js', 'status': 404})
        self.assertEqual(len(c.get_network_log()), 2)
        c.clear_network_log()
        self.assertEqual(len(c.get_network_log()), 0)


class TestCDPClientHandleMessage(unittest.TestCase):
    def setUp(self):
        self.c = CDPClient(9222)

    def test_message_with_id_resolves_future(self):
        loop = asyncio.new_event_loop()
        future = loop.create_future()
        self.c._pending[1] = future
        loop.run_until_complete(self.c._handle_message({'id': 1, 'result': {'value': 42}}))
        self.assertTrue(future.done())
        self.assertEqual(future.result(), {'value': 42})
        loop.close()

    def test_message_with_id_and_error_rejects_future(self):
        loop = asyncio.new_event_loop()
        future = loop.create_future()
        self.c._pending[1] = future
        loop.run_until_complete(self.c._handle_message({'id': 1, 'error': {'message': 'nope'}}))
        self.assertTrue(future.done())
        with self.assertRaises(Exception) as ctx:
            future.result()
        self.assertIn('nope', str(ctx.exception))
        loop.close()

    def test_message_with_unknown_id_is_ignored(self):
        asyncio.run(self.c._handle_message({'id': 999, 'result': {}}))

    def test_console_api_event(self):
        params = {
            'level': 'warning',
            'args': [{'type': 'string', 'value': 'hello'}],
        }
        asyncio.run(self.c._handle_message({'method': 'Runtime.consoleAPICalled', 'params': params}))
        events = self.c.drain_events()
        self.assertEqual(len(events), 1)
        etype, data = events[0]
        self.assertEqual(etype, 'console')
        self.assertEqual(data['level'], 'warn')
        self.assertEqual(data['message'], 'hello')

    def test_console_api_with_stack(self):
        params = {
            'level': 'error',
            'args': [{'type': 'string', 'value': 'fail'}],
            'stackTrace': {
                'callFrames': [
                    {'functionName': 'foo', 'url': 'test.js', 'lineNumber': 5, 'columnNumber': 3},
                ]
            },
        }
        asyncio.run(self.c._handle_message({'method': 'Runtime.consoleAPICalled', 'params': params}))
        events = self.c.drain_events()
        self.assertEqual(len(events), 1)
        stack = events[0][1]['stack']
        self.assertEqual(len(stack), 1)
        self.assertEqual(stack[0]['function'], 'foo')

    def test_exception_thrown(self):
        params = {
            'exceptionDetails': {
                'exception': {'description': 'TypeError: x is not a function'},
                'stackTrace': {'callFrames': []},
            }
        }
        asyncio.run(self.c._handle_message({'method': 'Runtime.exceptionThrown', 'params': params}))
        events = self.c.drain_events()
        self.assertEqual(len(events), 1)
        self.assertEqual(events[0][0], 'console')
        self.assertEqual(events[0][1]['level'], 'error')

    def test_request_will_be_sent(self):
        params = {
            'requestId': 'req1',
            'request': {'method': 'POST', 'url': 'http://example.com/api'},
        }
        asyncio.run(self.c._handle_message({'method': 'Network.requestWillBeSent', 'params': params}))
        self.assertIn('req1', self.c.pending_requests)
        self.assertEqual(self.c.pending_requests['req1']['method'], 'POST')
        self.assertEqual(len(self.c.drain_events()), 0)

    def test_response_received(self):
        self.c.pending_requests['req1'] = {
            'method': 'GET', 'url': '/test.js',
            'start_time': 1000, 'status': None,
            'status_text': None, 'size': None, 'error': None,
        }
        params = {
            'requestId': 'req1',
            'response': {'status': 200, 'statusText': 'OK', 'transferSize': 1500},
        }
        asyncio.run(self.c._handle_message({'method': 'Network.responseReceived', 'params': params}))
        self.assertNotIn('req1', self.c.pending_requests)
        self.assertEqual(len(self.c.completed_requests), 1)
        events = self.c.drain_events()
        self.assertEqual(len(events), 1)
        self.assertEqual(events[0][0], 'network')
        self.assertEqual(events[0][1]['status'], 200)

    def test_loading_failed(self):
        self.c.pending_requests['req1'] = {
            'method': 'GET', 'url': '/broken.js',
            'start_time': 1000, 'status': None,
            'status_text': None, 'size': None, 'error': None,
        }
        params = {'requestId': 'req1', 'errorText': 'Connection refused'}
        asyncio.run(self.c._handle_message({'method': 'Network.loadingFailed', 'params': params}))
        self.assertNotIn('req1', self.c.pending_requests)
        self.assertEqual(len(self.c.completed_requests), 1)
        events = self.c.drain_events()
        self.assertEqual(events[0][1]['error'], 'Connection refused')

    def test_debugger_paused(self):
        params = {
            'callFrames': [
                {
                    'functionName': 'draw',
                    'url': 'sketch.js',
                    'location': {'lineNumber': 10, 'columnNumber': 5},
                }
            ],
            'reason': 'breakpoint',
        }
        asyncio.run(self.c._handle_message({'method': 'Debugger.paused', 'params': params}))
        events = self.c.drain_events()
        self.assertEqual(len(events), 1)
        self.assertEqual(events[0][1]['event'], 'paused')
        self.assertEqual(events[0][1]['reason'], 'breakpoint')
        self.assertEqual(len(events[0][1]['callFrames']), 1)

    def test_debugger_resumed(self):
        asyncio.run(self.c._handle_message({'method': 'Debugger.resumed', 'params': {}}))
        events = self.c.drain_events()
        self.assertEqual(len(events), 1)
        self.assertEqual(events[0][1]['event'], 'resumed')

    def test_debugger_resumed_clears_paused_frame(self):
        self.c._paused_frame_id = 'frame-1'
        asyncio.run(self.c._handle_message({'method': 'Debugger.resumed', 'params': {}}))
        self.assertIsNone(self.c._paused_frame_id)

    def test_debugger_paused_tracks_frame_id(self):
        params = {
            'callFrames': [
                {'callFrameId': 'frame-1', 'functionName': 'draw',
                 'url': 'sketch.js', 'location': {'lineNumber': 3, 'columnNumber': 0}},
            ],
            'reason': 'breakpoint',
        }
        asyncio.run(self.c._handle_message({'method': 'Debugger.paused', 'params': params}))
        self.assertEqual(self.c._paused_frame_id, 'frame-1')

    def test_perf_metrics_real_names_and_fps_delta(self):
        def metrics_event(frames, nodes, listeners, heap):
            return {
                'method': 'Performance.metrics',
                'params': {'metrics': [
                    {'name': 'Frames', 'value': frames},
                    {'name': 'Nodes', 'value': nodes},
                    {'name': 'JSEventListeners', 'value': listeners},
                    {'name': 'JSHeapUsedSize', 'value': heap},
                ]},
            }
        asyncio.run(self.c._handle_message(metrics_event(1000, 42, 7, 1048576)))
        events = self.c.drain_events()
        self.assertEqual(len(events), 1)
        self.assertEqual(events[0][1]['fps'], 0, "first sample has no Frames delta")
        asyncio.run(self.c._handle_message(metrics_event(1060, 44, 8, 2097152)))
        events = self.c.drain_events()
        etype, data = events[0]
        self.assertEqual(etype, 'perf')
        self.assertEqual(data['fps'], 60)
        self.assertEqual(data['nodes'], 44)
        self.assertEqual(data['listeners'], 8)
        self.assertEqual(data['heap'], 2097152)

    def test_unknown_method_is_ignored(self):
        asyncio.run(self.c._handle_message({'method': 'Unknown.method', 'params': {}}))
        self.assertEqual(len(self.c.drain_events()), 0)


class TestCDPClientSetBreakpoint(unittest.TestCase):
    def setUp(self):
        self.c = CDPClient(9222)

    def test_set_breakpoint_unmatched_url(self):
        self.c._scripts = {}
        with patch.object(self.c, 'send_command', new_callable=AsyncMock) as mock_send:
            mock_send.return_value = {'breakpointId': '1', 'locations': []}
            result = asyncio.run(self.c.set_breakpoint('sketch.js:42'))
            mock_send.assert_called_once_with(
                'Debugger.setBreakpointByUrl',
                {'url': 'sketch.js', 'lineNumber': 41},
            )
            self.assertEqual(result['resolved'], 0)

    def test_set_breakpoint_resolves_exact_script(self):
        self.c._scripts = {'http://localhost:8000/sketch.js': 'script-1'}
        with patch.object(self.c, 'send_command', new_callable=AsyncMock) as mock_send:
            mock_send.return_value = {'breakpointId': '1', 'actualLocation': {'lineNumber': 41}}
            result = asyncio.run(self.c.set_breakpoint('http://localhost:8000/sketch.js:42'))
            mock_send.assert_called_once_with(
                'Debugger.setBreakpoint',
                {'location': {'scriptId': 'script-1', 'lineNumber': 41}},
            )
            self.assertEqual(result['resolved'], 1)

    def test_set_breakpoint_resolves_by_basename(self):
        self.c._scripts = {'http://localhost:8000/sketch.js': 'script-1'}
        with patch.object(self.c, 'send_command', new_callable=AsyncMock) as mock_send:
            mock_send.return_value = {'breakpointId': '1', 'actualLocation': {'lineNumber': 41}}
            asyncio.run(self.c.set_breakpoint('sketch.js:42'))
            mock_send.assert_called_once_with(
                'Debugger.setBreakpoint',
                {'location': {'scriptId': 'script-1', 'lineNumber': 41}},
            )

    def test_resolve_script_matches_basename(self):
        self.c._scripts = {
            'http://localhost:8000/sketch.js': 's1',
            'http://localhost:8000/assets/libs/p5.js': 's2',
        }
        self.assertEqual(self.c._resolve_script('sketch.js'), 's1')
        self.assertEqual(self.c._resolve_script('p5.js'), 's2')
        self.assertIsNone(self.c._resolve_script('missing.js'))

    def test_set_breakpoint_raises_on_bad_format(self):
        with self.assertRaises(ValueError):
            asyncio.run(self.c.set_breakpoint('invalid-location'))


class TestCDPClientConnect(unittest.IsolatedAsyncioTestCase):
    async def asyncSetUp(self):
        self.c = CDPClient(9222)

    @patch('server.http_get', new_callable=AsyncMock)
    @patch('server.websockets.connect', new_callable=AsyncMock)
    async def test_connect_discovery(self, mock_ws_connect, mock_http_get):
        mock_http_get.return_value = json.dumps([
            {'type': 'page', 'url': 'http://localhost:8000/', 'webSocketDebuggerUrl': 'ws://localhost:9222/page'}
        ])
        mock_ws = AsyncMock()
        mock_ws.__aiter__.return_value = iter([])
        mock_ws_connect.return_value = mock_ws
        with patch.object(self.c, 'send_command', new_callable=AsyncMock) as mock_send:
            await self.c.connect()
            self.assertTrue(self.c.connected)
            self.assertEqual(self.c.page_url, 'http://localhost:8000/')
            self.assertIsNotNone(self.c._recv_task)
            mock_send.assert_has_calls([
                unittest.mock.call('Runtime.enable'),
                unittest.mock.call('Network.enable'),
                unittest.mock.call('Debugger.enable'),
            ])

    @patch('server.http_get', new_callable=AsyncMock)
    async def test_connect_no_pages(self, mock_http_get):
        mock_http_get.return_value = json.dumps([
            {'type': 'background_page', 'url': 'about:blank', 'webSocketDebuggerUrl': ''}
        ])
        with self.assertRaises(ConnectionError):
            await self.c.connect()

    @patch('server.http_get', new_callable=AsyncMock)
    async def test_connect_http_fail(self, mock_http_get):
        mock_http_get.return_value = None
        with self.assertRaises(ConnectionError):
            await self.c.connect()

    async def test_send_command_not_connected(self):
        with self.assertRaises(RuntimeError):
            await self.c.send_command('Runtime.evaluate')


class TestCDPClientEvaluate(unittest.TestCase):
    def setUp(self):
        self.c = CDPClient(9222)

    def test_evaluate(self):
        with patch.object(self.c, 'send_command', new_callable=AsyncMock) as mock_send:
            mock_send.return_value = {'result': {'type': 'number', 'value': 42}}
            result = asyncio.run(self.c.evaluate('2 + 2'))
            mock_send.assert_called_once_with(
                'Runtime.evaluate',
                {'expression': '2 + 2', 'returnByValue': True, 'includeCommandLineAPI': True},
            )
            self.assertEqual(result, {'result': {'type': 'number', 'value': 42}})


class TestCDPClientEvaluateRouting(unittest.TestCase):
    def setUp(self):
        self.c = CDPClient(9222)

    def test_evaluate_uses_runtime_when_not_paused(self):
        with patch.object(self.c, 'send_command', new_callable=AsyncMock) as mock_send:
            asyncio.run(self.c.evaluate('2 + 2'))
            mock_send.assert_called_once_with(
                'Runtime.evaluate',
                {'expression': '2 + 2', 'returnByValue': True, 'includeCommandLineAPI': True},
            )

    def test_evaluate_uses_call_frame_when_paused(self):
        self.c._paused_frame_id = 'frame-1'
        with patch.object(self.c, 'send_command', new_callable=AsyncMock) as mock_send:
            asyncio.run(self.c.evaluate('x'))
            mock_send.assert_called_once_with(
                'Debugger.evaluateOnCallFrame',
                {'callFrameId': 'frame-1', 'expression': 'x',
                 'returnByValue': True, 'includeCommandLineAPI': True},
            )


class TestCDPClientStepCommands(unittest.TestCase):
    def setUp(self):
        self.c = CDPClient(9222)

    def _test_step(self, method, cdp_method):
        with patch.object(self.c, 'send_command', new_callable=AsyncMock) as mock_send:
            asyncio.run(method())
            mock_send.assert_called_once_with(cdp_method)

    def test_resume(self):
        self._test_step(self.c.resume, 'Debugger.resume')

    def test_step_over(self):
        self._test_step(self.c.step_over, 'Debugger.stepOver')

    def test_step_into(self):
        self._test_step(self.c.step_into, 'Debugger.stepInto')

    def test_step_out(self):
        self._test_step(self.c.step_out, 'Debugger.stepOut')

    def test_pause(self):
        self._test_step(self.c.pause, 'Debugger.pause')

    def test_reload_page(self):
        self._test_step(self.c.reload_page, 'Page.reload')

    def test_set_pause_on_exceptions(self):
        with patch.object(self.c, 'send_command', new_callable=AsyncMock) as mock_send:
            asyncio.run(self.c.set_pause_on_exceptions('uncaught'))
            mock_send.assert_called_once_with(
                'Debugger.setPauseOnExceptions', {'state': 'uncaught'})

    def test_capture_screenshot(self):
        with patch.object(self.c, 'send_command', new_callable=AsyncMock) as mock_send:
            mock_send.return_value = {'data': 'aGVsbG8='}
            result = asyncio.run(self.c.capture_screenshot())
            mock_send.assert_called_once_with('Page.captureScreenshot', {'format': 'png'})
            self.assertEqual(result, {'data': 'aGVsbG8='})


class TestCDPClientHandleConsoleApi(unittest.TestCase):
    def setUp(self):
        self.c = CDPClient(9222)

    def test_level_mapping(self):
        cases = [
            ('warning', 'warn'),
            ('error', 'error'),
            ('debug', 'log'),
            ('info', 'info'),
            ('log', 'log'),
            ('unknown', 'log'),
        ]
        for cdp_level, expected in cases:
            with self.subTest(level=cdp_level):
                params = {'level': cdp_level, 'args': [{'type': 'string', 'value': 'test'}]}
                asyncio.run(self.c._handle_console_api(params))
                events = self.c.drain_events()
                self.assertEqual(events[0][1]['level'], expected)

    def test_multiple_args(self):
        params = {
            'level': 'log',
            'args': [
                {'type': 'string', 'value': 'count:'},
                {'type': 'number', 'value': 42},
                {'type': 'object', 'description': '{x: 1}'},
            ],
        }
        asyncio.run(self.c._handle_console_api(params))
        events = self.c.drain_events()
        self.assertEqual(events[0][1]['message'], 'count: 42 {x: 1}')


class TestCDPClientEventBufferCap(unittest.TestCase):
    def test_event_buffer_maxlen(self):
        c = CDPClient(9222)
        for i in range(2500):
            c._emit('console', {'i': i})
        self.assertEqual(len(c.event_buffer), 2000)

    def test_completed_requests_maxlen(self):
        c = CDPClient(9222)
        for i in range(700):
            c.completed_requests.append({'i': i})
        self.assertEqual(len(c.completed_requests), 500)


class TestCDPClientDisconnect(unittest.TestCase):
    def setUp(self):
        self.c = CDPClient(9222)
        self.c.connected = True

    def test_disconnect_cleanup(self):
        mock_ws = AsyncMock()
        self.c.ws = mock_ws
        async def run_test():
            async def noop(): pass
            self.c._recv_task = asyncio.ensure_future(noop())
            await self.c.disconnect()
            self.assertFalse(self.c.connected)
            self.assertTrue(self.c._recv_task.cancelled())
            mock_ws.close.assert_called_once()
        asyncio.run(run_test())

    def test_disconnect_no_ws(self):
        asyncio.run(self.c.disconnect())
        self.assertFalse(self.c.connected)


class TestCDPClientSendCommand(unittest.IsolatedAsyncioTestCase):
    async def asyncSetUp(self):
        self.c = CDPClient(9222)
        self.mock_ws = AsyncMock()
        self.c.ws = self.mock_ws
        self.c.connected = True

    async def test_send_command_sends_json(self):
        send_task = asyncio.create_task(self.c.send_command('Test.method', {'key': 'val'}))
        await asyncio.sleep(0)
        sent = self.mock_ws.send.call_args[0][0]
        msg = json.loads(sent)
        self.assertEqual(msg['method'], 'Test.method')
        self.assertEqual(msg['params'], {'key': 'val'})
        await self.c._handle_message({'id': msg['id'], 'result': {'ok': True}})
        result = await send_task
        self.assertEqual(result, {'ok': True})


class TestCDPHTTPServerHandlers(unittest.TestCase):
    def setUp(self):
        self.server = HTTPServer(8000, '/tmp', MagicMock(), MagicMock())
        self.server.running = True
        self.server.cdp_client = None

    def _make_writer(self):
        w = AsyncMock()
        w.write = MagicMock()
        return w

    def test_handle_cdp_status_no_client(self):
        w = self._make_writer()
        asyncio.run(self.server.handle_cdp_status(w))
        written = b''.join(c[0][0] for c in w.write.call_args_list if isinstance(c[0][0], bytes))
        self.assertIn(b'"connected": false', written)

    def test_handle_cdp_status_with_client(self):
        self.server.cdp_client = MagicMock()
        self.server.cdp_client.connected = True
        self.server.cdp_client.page_url = 'http://test.com/'
        w = self._make_writer()
        asyncio.run(self.server.handle_cdp_status(w))
        written = b''.join(c[0][0] for c in w.write.call_args_list if isinstance(c[0][0], bytes))
        self.assertIn(b'"connected": true', written)

    def test_handle_cdp_disconnect_no_client(self):
        w = self._make_writer()
        asyncio.run(self.server.handle_cdp_disconnect(w))
        last_write = w.write.call_args_list[-1][0][0]
        self.assertIn(b'"status": "not_connected"', last_write)

    def test_handle_cdp_network_clear_no_client(self):
        w = self._make_writer()
        asyncio.run(self.server.handle_cdp_network_clear(w))
        written = b''.join(c[0][0] for c in w.write.call_args_list if isinstance(c[0][0], bytes))
        self.assertIn(b'"status": "cleared"', written)


class TestCDPHTTPServerEvalAndDebugHandlers(unittest.TestCase):
    def setUp(self):
        self.server = HTTPServer(8000, '/tmp', MagicMock(), MagicMock())
        self.server.running = True
        self.server.cdp_client = None

    def _make_writer(self):
        w = AsyncMock()
        w.write = MagicMock()
        return w

    def test_handle_cdp_evaluate_no_client(self):
        w = self._make_writer()
        reader = AsyncMock()
        asyncio.run(self.server.handle_cdp_evaluate(reader, w, {'content-length': '0'}))
        written = b''.join(c[0][0] for c in w.write.call_args_list if isinstance(c[0][0], bytes))
        self.assertIn(b'"error"', written)
        self.assertIn(b'503', written)

    def test_handle_cdp_evaluate_rejects_dangerous_patterns(self):
        self.server.cdp_client = MagicMock()
        self.server.cdp_client.connected = True
        w = self._make_writer()
        body = json.dumps({'expression': 'file:///etc/passwd'})
        headers = {'content-length': str(len(body))}
        reader = AsyncMock()
        reader.read.return_value = body.encode()
        asyncio.run(self.server.handle_cdp_evaluate(reader, w, headers))
        written = b''.join(c[0][0] for c in w.write.call_args_list if isinstance(c[0][0], bytes))
        self.assertIn(b'Rejected', written)

    def test_handle_cdp_evaluate_rejects_require(self):
        self.server.cdp_client = MagicMock()
        self.server.cdp_client.connected = True
        w = self._make_writer()
        body = json.dumps({'expression': ' require("fs")'})
        headers = {'content-length': str(len(body))}
        reader = AsyncMock()
        reader.read.return_value = body.encode()
        asyncio.run(self.server.handle_cdp_evaluate(reader, w, headers))
        written = b''.join(c[0][0] for c in w.write.call_args_list if isinstance(c[0][0], bytes))
        self.assertIn(b'Rejected', written)

    def test_handle_cdp_evaluate_rejects_process_env(self):
        self.server.cdp_client = MagicMock()
        self.server.cdp_client.connected = True
        w = self._make_writer()
        body = json.dumps({'expression': 'process.env.HOME'})
        headers = {'content-length': str(len(body))}
        reader = AsyncMock()
        reader.read.return_value = body.encode()
        asyncio.run(self.server.handle_cdp_evaluate(reader, w, headers))
        written = b''.join(c[0][0] for c in w.write.call_args_list if isinstance(c[0][0], bytes))
        self.assertIn(b'Rejected', written)

    def test_handle_cdp_debug_break_no_client(self):
        w = self._make_writer()
        reader = AsyncMock()
        asyncio.run(self.server.handle_cdp_debug_break(reader, w, {'content-length': '0'}))
        written = b''.join(c[0][0] for c in w.write.call_args_list if isinstance(c[0][0], bytes))
        self.assertIn(b'503', written)

    def test_handle_cdp_debug_continue_no_client(self):
        w = self._make_writer()
        asyncio.run(self.server.handle_cdp_debug_continue(w))
        written = b''.join(c[0][0] for c in w.write.call_args_list if isinstance(c[0][0], bytes))
        self.assertIn(b'503', written)

    def test_handle_cdp_debug_step_no_client(self):
        w = self._make_writer()
        asyncio.run(self.server.handle_cdp_debug_step(w))
        written = b''.join(c[0][0] for c in w.write.call_args_list if isinstance(c[0][0], bytes))
        self.assertIn(b'503', written)

    def test_handle_cdp_debug_step_in_no_client(self):
        w = self._make_writer()
        asyncio.run(self.server.handle_cdp_debug_step_in(w))
        written = b''.join(c[0][0] for c in w.write.call_args_list if isinstance(c[0][0], bytes))
        self.assertIn(b'503', written)

    def test_handle_cdp_debug_step_out_no_client(self):
        w = self._make_writer()
        asyncio.run(self.server.handle_cdp_debug_step_out(w))
        written = b''.join(c[0][0] for c in w.write.call_args_list if isinstance(c[0][0], bytes))
        self.assertIn(b'503', written)

    def test_handle_cdp_debug_pause_no_client(self):
        w = self._make_writer()
        asyncio.run(self.server.handle_cdp_debug_pause(w))
        written = b''.join(c[0][0] for c in w.write.call_args_list if isinstance(c[0][0], bytes))
        self.assertIn(b'503', written)

    def test_handle_cdp_debug_pause_with_client(self):
        self.server.cdp_client = MagicMock()
        self.server.cdp_client.connected = True
        self.server.cdp_client.pause = AsyncMock()
        w = self._make_writer()
        asyncio.run(self.server.handle_cdp_debug_pause(w))
        self.server.cdp_client.pause.assert_called_once()

    def test_handle_cdp_debug_pause_exceptions_no_client(self):
        w = self._make_writer()
        reader = AsyncMock()
        asyncio.run(self.server.handle_cdp_debug_pause_exceptions(reader, w, {'content-length': '0'}))
        written = b''.join(c[0][0] for c in w.write.call_args_list if isinstance(c[0][0], bytes))
        self.assertIn(b'503', written)

    def test_handle_cdp_debug_pause_exceptions_with_client(self):
        self.server.cdp_client = MagicMock()
        self.server.cdp_client.connected = True
        self.server.cdp_client.set_pause_on_exceptions = AsyncMock()
        w = self._make_writer()
        body = json.dumps({'state': 'uncaught'})
        headers = {'content-length': str(len(body))}
        reader = AsyncMock()
        reader.read.return_value = body.encode()
        asyncio.run(self.server.handle_cdp_debug_pause_exceptions(reader, w, headers))
        self.server.cdp_client.set_pause_on_exceptions.assert_called_once_with('uncaught')

    def test_handle_cdp_page_reload_no_client(self):
        w = self._make_writer()
        asyncio.run(self.server.handle_cdp_page_reload(w))
        written = b''.join(c[0][0] for c in w.write.call_args_list if isinstance(c[0][0], bytes))
        self.assertIn(b'503', written)

    def test_handle_cdp_page_reload_with_client(self):
        self.server.cdp_client = MagicMock()
        self.server.cdp_client.connected = True
        self.server.cdp_client.reload_page = AsyncMock()
        w = self._make_writer()
        asyncio.run(self.server.handle_cdp_page_reload(w))
        self.server.cdp_client.reload_page.assert_called_once()

    def test_handle_cdp_page_screenshot_no_client(self):
        w = self._make_writer()
        asyncio.run(self.server.handle_cdp_page_screenshot(w))
        written = b''.join(c[0][0] for c in w.write.call_args_list if isinstance(c[0][0], bytes))
        self.assertIn(b'503', written)

    def test_handle_cdp_page_screenshot_with_client(self):
        self.server.cdp_client = MagicMock()
        self.server.cdp_client.connected = True
        self.server.cdp_client.capture_screenshot = AsyncMock(return_value={'data': 'aGVsbG8='})
        w = self._make_writer()
        asyncio.run(self.server.handle_cdp_page_screenshot(w))
        self.server.cdp_client.capture_screenshot.assert_called_once()

    def test_handle_cdp_routes_network_clear(self):
        self.server.cdp_client = MagicMock()
        self.server.cdp_client.connected = True
        self.server.cdp_client.clear_network_log = MagicMock()
        w = self._make_writer()
        reader = AsyncMock()
        asyncio.run(self.server.handle_cdp('DELETE', '/api/cdp/network', reader, w, {}))
        self.server.cdp_client.clear_network_log.assert_called_once()

    def test_handle_cdp_routes_pause(self):
        self.server.cdp_client = MagicMock()
        self.server.cdp_client.connected = True
        self.server.cdp_client.pause = AsyncMock()
        w = self._make_writer()
        reader = AsyncMock()
        asyncio.run(self.server.handle_cdp('POST', '/api/cdp/debug/pause', reader, w, {}))
        self.server.cdp_client.pause.assert_called_once()

    def test_handle_cdp_evaluate_with_client(self):
        self.server.cdp_client = MagicMock()
        self.server.cdp_client.connected = True
        self.server.cdp_client.evaluate = AsyncMock(
            return_value={'result': {'type': 'number', 'value': 42}}
        )
        w = self._make_writer()
        body = json.dumps({'expression': '2 + 2'})
        headers = {'content-length': str(len(body))}
        reader = AsyncMock()
        reader.read.return_value = body.encode()
        asyncio.run(self.server.handle_cdp_evaluate(reader, w, headers))
        written = b''.join(c[0][0] for c in w.write.call_args_list if isinstance(c[0][0], bytes))
        self.assertIn(b'"result"', written)
        self.server.cdp_client.evaluate.assert_called_once_with('2 + 2')

    def test_handle_cdp_debug_break_with_client(self):
        self.server.cdp_client = MagicMock()
        self.server.cdp_client.connected = True
        self.server.cdp_client.set_breakpoint = AsyncMock(
            return_value={'breakpointId': '1'}
        )
        w = self._make_writer()
        body = json.dumps({'location': 'sketch.js:42'})
        headers = {'content-length': str(len(body))}
        reader = AsyncMock()
        reader.read.return_value = body.encode()
        asyncio.run(self.server.handle_cdp_debug_break(reader, w, headers))
        self.server.cdp_client.set_breakpoint.assert_called_once_with('sketch.js:42')

    def test_handle_cdp_debug_continue_with_client(self):
        self.server.cdp_client = MagicMock()
        self.server.cdp_client.connected = True
        self.server.cdp_client.resume = AsyncMock()
        w = self._make_writer()
        asyncio.run(self.server.handle_cdp_debug_continue(w))
        self.server.cdp_client.resume.assert_called_once()

    def test_handle_cdp_debug_step_with_client(self):
        self.server.cdp_client = MagicMock()
        self.server.cdp_client.connected = True
        self.server.cdp_client.step_over = AsyncMock()
        w = self._make_writer()
        asyncio.run(self.server.handle_cdp_debug_step(w))
        self.server.cdp_client.step_over.assert_called_once()

    def test_handle_cdp_debug_step_in_with_client(self):
        self.server.cdp_client = MagicMock()
        self.server.cdp_client.connected = True
        self.server.cdp_client.step_into = AsyncMock()
        w = self._make_writer()
        asyncio.run(self.server.handle_cdp_debug_step_in(w))
        self.server.cdp_client.step_into.assert_called_once()

    def test_handle_cdp_debug_step_out_with_client(self):
        self.server.cdp_client = MagicMock()
        self.server.cdp_client.connected = True
        self.server.cdp_client.step_out = AsyncMock()
        w = self._make_writer()
        asyncio.run(self.server.handle_cdp_debug_step_out(w))
        self.server.cdp_client.step_out.assert_called_once()

    def test_handle_cdp_network_clear_with_client(self):
        self.server.cdp_client = MagicMock()
        asyncio.run(self.server.handle_cdp_network_clear(self._make_writer()))
        self.server.cdp_client.clear_network_log.assert_called_once()


class TestFileWatcherShouldWatch(unittest.TestCase):
    def test_js_file_is_watched(self):
        fw = FileWatcher('/tmp', ['.js'], ['.git'], 300)
        self.assertTrue(fw.should_watch('/tmp/sketch.js'))

    def test_excluded_dir_not_watched(self):
        fw = FileWatcher('/tmp', ['.js'], ['.git'], 300)
        self.assertFalse(fw.should_watch('/tmp/.git/sketch.js'))

    def test_nested_excluded_dir_not_watched(self):
        fw = FileWatcher('/tmp', ['.js'], ['node_modules'], 300)
        self.assertFalse(fw.should_watch('/tmp/project/node_modules/pkg/lib.js'))

    def test_unmatched_extension_not_watched(self):
        fw = FileWatcher('/tmp', ['.js'], ['.git'], 300)
        self.assertFalse(fw.should_watch('/tmp/data.txt'))

    def test_multiple_extensions_all_watched(self):
        fw = FileWatcher('/tmp', ['.js', '.css', '.html'], ['.git'], 300)
        self.assertTrue(fw.should_watch('/tmp/style.css'))
        self.assertTrue(fw.should_watch('/tmp/index.html'))
        self.assertTrue(fw.should_watch('/tmp/sketch.js'))
        self.assertFalse(fw.should_watch('/tmp/data.json'))

    def test_empty_extensions_watches_nothing(self):
        fw = FileWatcher('/tmp', [], ['.git'], 300)
        self.assertFalse(fw.should_watch('/tmp/sketch.js'))

    def test_multiple_exclude_dirs(self):
        fw = FileWatcher('/tmp', ['.js'], ['.git', 'node_modules', 'dist'], 300)
        self.assertFalse(fw.should_watch('/tmp/node_modules/pkg/index.js'))
        self.assertFalse(fw.should_watch('/tmp/dist/bundle.js'))
        self.assertTrue(fw.should_watch('/tmp/src/app.js'))


class TestFileWatcherDetection(unittest.IsolatedAsyncioTestCase):
    async def test_watch_detects_file_change(self):
        fw = FileWatcher('/tmp', ['.js'], ['.git'], 50)
        fw.running = True

        with patch('server.os.walk') as mock_walk, \
             patch('server.os.path.getmtime') as mock_mtime:
            mock_walk.return_value = [('/tmp', [], ['sketch.js'])]
            # Iter 1: 1000.0 (baseline), Iter 2: 1001.0 (change), Iter 3: 1001.0 (stable)
            mock_mtime.side_effect = [1000.0, 1001.0, 1001.0]
            gen = fw.watch()
            result = await asyncio.wait_for(anext(gen), timeout=5.0)
            self.assertEqual(result, '/tmp/sketch.js')
            fw.running = False

    async def test_watch_ignores_unchanged_files(self):
        fw = FileWatcher('/tmp', ['.js'], ['.git'], 50)
        fw.running = True

        with patch('server.os.walk') as mock_walk, \
             patch('server.os.path.getmtime') as mock_mtime:
            mock_walk.return_value = [('/tmp', [], ['sketch.js'])]
            # mtime never changes
            mock_mtime.return_value = 1000.0
            gen = fw.watch()
            with self.assertRaises(asyncio.TimeoutError):
                await asyncio.wait_for(anext(gen), timeout=0.5)
            fw.running = False


class TestLiveReloadServerIntegration(unittest.IsolatedAsyncioTestCase):
    async def asyncTearDown(self):
        if hasattr(self, 'server') and self.server:
            await self.server.close()

    async def test_start_and_close(self):
        self.server = LiveReloadServer(port=0, directory='/tmp', file_watcher=None)
        await self.server.start()
        self.assertIsNotNone(self.server.server)
        self.assertGreater(self.server.port, 0)

    async def test_client_connects_and_receives_message(self):
        self.server = LiveReloadServer(port=0, directory='/tmp', file_watcher=None)
        await self.server.start()
        async with websockets.connect(f'ws://localhost:{self.server.port}') as ws:
            msg = await asyncio.wait_for(ws.recv(), timeout=5.0)
            data = json.loads(msg)
            self.assertEqual(data['type'], 'connected')

    async def test_broadcast_to_connected_client(self):
        self.server = LiveReloadServer(port=0, directory='/tmp', file_watcher=None)
        await self.server.start()
        async with websockets.connect(f'ws://localhost:{self.server.port}') as ws:
            # Consume the 'connected' message first
            connected = await asyncio.wait_for(ws.recv(), timeout=5.0)
            self.assertEqual(json.loads(connected)['type'], 'connected')
            await self.server.broadcast({'type': 'reload', 'file': 'test.js'})
            msg = await asyncio.wait_for(ws.recv(), timeout=5.0)
            data = json.loads(msg)
            self.assertEqual(data['type'], 'reload')
            self.assertEqual(data['file'], 'test.js')

    async def test_broadcast_to_multiple_clients(self):
        self.server = LiveReloadServer(port=0, directory='/tmp', file_watcher=None)
        await self.server.start()
        async with websockets.connect(f'ws://localhost:{self.server.port}') as ws1, \
                    websockets.connect(f'ws://localhost:{self.server.port}') as ws2:
            # Consume the 'connected' messages
            await ws1.recv()
            await ws2.recv()
            await self.server.broadcast({'type': 'reload'})
            msg1 = await asyncio.wait_for(ws1.recv(), timeout=5.0)
            msg2 = await asyncio.wait_for(ws2.recv(), timeout=5.0)
            self.assertEqual(json.loads(msg1)['type'], 'reload')
            self.assertEqual(json.loads(msg2)['type'], 'reload')

    async def test_disconnected_client_is_removed(self):
        self.server = LiveReloadServer(port=0, directory='/tmp', file_watcher=None)
        await self.server.start()
        async with websockets.connect(f'ws://localhost:{self.server.port}') as ws:
            await asyncio.sleep(0.1)
            self.assertEqual(len(self.server.clients), 1)
        # Client is now disconnected
        await asyncio.sleep(0.1)
        self.assertEqual(len(self.server.clients), 0)


class TestInjectScripts(unittest.TestCase):
    def setUp(self):
        self.lr_mock = MagicMock()
        self.lr_mock.port = 12002
        self.server = HTTPServer(8000, '/tmp', MagicMock(), self.lr_mock)

    def test_injects_livereload_before_body(self):
        html = b'<html><head></head><body><p>hello</p></body></html>'
        result = self.server.inject_scripts(html).decode()
        self.assertIn('ws://localhost:12002', result)
        self.assertTrue(
            result.index('ws://localhost:12002') < result.index('</body>')
        )

    def test_injects_console_script(self):
        html = b'<html><body></body></html>'
        result = self.server.inject_scripts(html).decode()
        self.assertIn('console.log', result)
        self.assertIn('fetch', result)

    def test_injects_cdp_active_flag_disconnected(self):
        self.server.cdp_client = None
        html = b'<html><body></body></html>'
        result = self.server.inject_scripts(html).decode()
        self.assertIn('window.__P5_CDP_ACTIVE = false', result)

    def test_injects_cdp_active_flag_connected(self):
        self.server.cdp_client = MagicMock()
        self.server.cdp_client.connected = True
        html = b'<html><body></body></html>'
        result = self.server.inject_scripts(html).decode()
        self.assertIn('window.__P5_CDP_ACTIVE = true', result)

    def test_injects_both_scripts(self):
        html = b'<html><body></body></html>'
        result = self.server.inject_scripts(html).decode()
        self.assertNotIn('__LR_PORT__', result)  # Port placeholder was replaced
        # Verify both script blocks are present
        script_count = result.count('<script>')
        self.assertGreaterEqual(script_count, 2, "Should inject at least 2 scripts")

    def test_appends_when_no_body_tag(self):
        html = b'<html><p>no body tag</p></html>'
        result = self.server.inject_scripts(html).decode()
        self.assertIn('ws://localhost:12002', result)

    def test_livereload_uses_correct_port(self):
        self.lr_mock.port = 9999
        html = b'<html><body></body></html>'
        result = self.server.inject_scripts(html).decode()
        self.assertIn('ws://localhost:9999', result)

    def test_console_included_when_livereload_disabled(self):
        original_enabled = CONFIG['live_reload']['enabled']
        CONFIG['live_reload']['enabled'] = False
        try:
            html = b'<html><body></body></html>'
            result = self.server.inject_scripts(html).decode()
            self.assertIn('console.log', result)
            self.assertNotIn('ws://localhost', result)
        finally:
            CONFIG['live_reload']['enabled'] = original_enabled


class TestParseConfig(unittest.TestCase):
    def test_defaults(self):
        cfg = _parse_config(['8000'])
        self.assertEqual(cfg['port'], 8000)
        self.assertTrue(cfg['live_reload']['enabled'])
        self.assertEqual(cfg['live_reload']['port'], 12002)
        self.assertEqual(cfg['live_reload']['debounce_ms'], 300)
        self.assertEqual(cfg['live_reload']['watch_extensions'], ['.js', '.css', '.html', '.json'])
        self.assertEqual(cfg['live_reload']['exclude_dirs'], ['.git', 'node_modules', 'dist', 'build'])

    def test_empty_args(self):
        cfg = _parse_config([])
        self.assertEqual(cfg['port'], 8000)

    def test_port_arg(self):
        cfg = _parse_config(['9090'])
        self.assertEqual(cfg['port'], 9090)

    def test_lr_port_flag(self):
        cfg = _parse_config(['8000', '--lr-port', '13000'])
        self.assertEqual(cfg['live_reload']['port'], 13000)

    def test_lr_debounce_flag(self):
        cfg = _parse_config(['8000', '--lr-debounce', '500'])
        self.assertEqual(cfg['live_reload']['debounce_ms'], 500)

    def test_lr_extensions_flag(self):
        cfg = _parse_config(['8000', '--lr-extensions', '.js,.ts,.mjs'])
        self.assertEqual(cfg['live_reload']['watch_extensions'], ['.js', '.ts', '.mjs'])

    def test_lr_exclude_flag(self):
        cfg = _parse_config(['8000', '--lr-exclude', '.git,dist,__pycache__'])
        self.assertEqual(cfg['live_reload']['exclude_dirs'], ['.git', 'dist', '__pycache__'])

    def test_lr_disabled_flag(self):
        cfg = _parse_config(['8000', '--lr-disabled'])
        self.assertFalse(cfg['live_reload']['enabled'])

    def test_cdp_port_flag(self):
        cfg = _parse_config(['8000', '--cdp-port', '9333'])
        self.assertEqual(cfg['cdp']['remote_debugging_port'], 9333)

    def test_cdp_port_default(self):
        cfg = _parse_config(['8000'])
        self.assertEqual(cfg['cdp']['remote_debugging_port'], 9222)

    def test_multiple_flags(self):
        cfg = _parse_config([
            '8888', '--lr-port', '13001', '--lr-debounce', '600',
            '--lr-extensions', '.js,.css', '--lr-exclude', '.git,tmp',
            '--lr-disabled'
        ])
        self.assertEqual(cfg['port'], 8888)
        self.assertEqual(cfg['live_reload']['port'], 13001)
        self.assertEqual(cfg['live_reload']['debounce_ms'], 600)
        self.assertEqual(cfg['live_reload']['watch_extensions'], ['.js', '.css'])
        self.assertEqual(cfg['live_reload']['exclude_dirs'], ['.git', 'tmp'])
        self.assertFalse(cfg['live_reload']['enabled'])

    def test_unknown_flag_is_skipped(self):
        cfg = _parse_config(['8000', '--unknown-flag'])
        self.assertEqual(cfg['port'], 8000)

    def test_lr_port_without_value_uses_default(self):
        cfg = _parse_config(['8000', '--lr-port'])
        self.assertEqual(cfg['live_reload']['port'], 12002)

    def test_config_matches_CONFIG_defaults(self):
        self.assertEqual(CONFIG['port'], 8000)
        self.assertEqual(CONFIG['live_reload']['port'], 12002)
        self.assertTrue(CONFIG['live_reload']['enabled'])


if __name__ == '__main__':
    unittest.main()
