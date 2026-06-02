"""Tests for CDPClient and CDP HTTP handlers in server.py."""
import asyncio
import json
import sys
import unittest
from collections import deque
from unittest.mock import AsyncMock, MagicMock, patch

sys.argv = ['server.py', '8000']
sys.path.insert(0, '.')

from server import CDPClient, HTTPServer, CONFIG


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

    def test_unknown_method_is_ignored(self):
        asyncio.run(self.c._handle_message({'method': 'Unknown.method', 'params': {}}))
        self.assertEqual(len(self.c.drain_events()), 0)


class TestCDPClientSetBreakpoint(unittest.TestCase):
    def setUp(self):
        self.c = CDPClient(9222)

    def test_set_breakpoint_parses_location(self):
        with patch.object(self.c, 'send_command', new_callable=AsyncMock) as mock_send:
            mock_send.return_value = {'breakpointId': '1'}
            result = asyncio.run(self.c.set_breakpoint('sketch.js:42'))
            mock_send.assert_called_once_with(
                'Debugger.setBreakpointByUrl',
                {'url': 'sketch.js', 'lineNumber': 41},
            )
            self.assertEqual(result, {'breakpointId': '1'})

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


if __name__ == '__main__':
    unittest.main()
