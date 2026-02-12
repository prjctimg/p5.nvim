#!/usr/bin/env python3

"""
Comprehensive p5.nvim Testing Framework
Tests plugin functionality, performance, and reliability
"""

import os
import sys
import time
import json
import subprocess
import threading
import urllib.request
import urllib.parse
import urllib.error
from datetime import datetime
import statistics

class P5TestSuite:
    def __init__(self):
        self.results = {
            'startup': {},
            'server_performance': {},
            'console_functionality': {},
            'file_watching': {},
            'resource_usage': {},
            'reliability': {}
        }
        self.test_dir = '/tmp/p5_test_suite'
        self.plugin_dir = '/home/prjctimg/workspace/p5.nvim'
        
    def log_result(self, category, test, result, details=""):
        timestamp = datetime.now().strftime('%H:%M:%S.%f')[:-3]
        self.results[category][test] = {
            'result': result,
            'details': details,
            'timestamp': timestamp
        }
        print(f"[{timestamp}] {category}.{test}: {result} - {details}")
    
    def setup_test_environment(self):
        """Create test environment and projects"""
        if not os.path.exists(self.test_dir):
            os.makedirs(self.test_dir)
        
        # Create test project
        test_project = os.path.join(self.test_dir, 'test_project')
        if not os.path.exists(test_project):
            os.makedirs(test_project)
        
        # Create test HTML with logging
        test_html = '''<!DOCTYPE html>
<html>
<head>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
    <style>
        body { font-family: monospace; padding: 20px; }
    </style>
</head>
<body>
    <h1>p5.nvim Test Suite</h1>
    <div id="output"></div>
    <script>
        console.log("Test page loaded");
        console.warn("Test warning message");
        console.error("Test error message");
        console.info("Test info message");
        
        function setup() {
            createCanvas(400, 400);
            background(220);
            console.log("p5 setup completed");
        }
        
        function draw() {
            circle(mouseX, mouseY, 50);
        }
        
        // Performance test
        let testCount = 0;
        setInterval(() => {
            testCount++;
            console.log(`Performance test message ${testCount}`);
            console.info(`Info test ${testCount}`);
            console.warn(`Warning test ${testCount}`);
        }, 100);
    </script>
</body>
</html>'''
        
        with open(os.path.join(test_project, 'index.html'), 'w') as f:
            f.write(test_html)
        
        # Create test sketch
        test_sketch = '''function setup() {
    createCanvas(400, 400);
    background(220);
}

function draw() {
    circle(mouseX, mouseY, 50);
}

// Test logging
console.log("Sketch loaded");
console.warn("Test warning");
console.error("Test error");'''
        
        with open(os.path.join(test_project, 'sketch.js'), 'w') as f:
            f.write(test_sketch)
        
        return test_project
    
    def test_plugin_startup(self):
        """Test plugin loading and initialization"""
        print("🧪 Testing Plugin Startup...")
        
        startup_times = []
        
        for i in range(5):
            start_time = time.time()
            
            # Create test directory if it doesn't exist
            os.makedirs(self.test_dir, exist_ok=True)
            
            result = subprocess.run([
                'nvim', '--headless',
                '--cmd', f'lua require("p5")',
                '--cmd', 'lua vim.api.nvim_echo("startup_test")',
                '--cmd', 'qa'
            ], capture_output=True, text=True, cwd='/tmp')
            
            end_time = time.time()
            duration = end_time - start_time
            startup_times.append(duration)
            
            if result.returncode == 0:
                self.log_result('startup', f'run_{i+1}', 'PASS', f'load_time={duration:.3f}s')
            else:
                self.log_result('startup', f'run_{i+1}', 'FAIL', f'returncode={result.returncode}')
            
            time.sleep(0.1)  # Brief pause between tests
        
        if startup_times:
            avg_time = statistics.mean(startup_times)
            self.log_result('startup', 'average', 'PASS', f'avg_time={avg_time:.3f}s')
            self.log_result('startup', 'stability', 'PASS' if max(startup_times) - min(startup_times) < 0.1 else 'WARN', f'variance={max(startup_times)-min(startup_times):.3f}s')
    
    def test_server_scripts(self):
        """Test all available server scripts"""
        print("\n🖥 Testing Server Scripts...")
        
        # Initialize results for this category
        self.results['server_scripts'] = {}
        
        servers = {
            'python': {'cmd': 'python3', 'script': 'python.py'},
            'node': {'cmd': 'node', 'script': 'node.js'},
            'deno': {'cmd': 'deno', 'script': 'deno.js'},
            'bun': {'cmd': 'bun', 'script': 'bun.js'}
        }
        
        test_project = self.setup_test_environment()
        
        for server_name, server_info in servers.items():
            print(f"\n--- Testing {server_name.upper()} Server ---")
            script_path = os.path.join(self.plugin_dir, 'servers', server_info['script'])
            
            if not os.path.exists(script_path):
                self.log_result('server_scripts', server_name, 'SKIP', 'script_not_found')
                continue
            
            start_time = time.time()
            
        try:
            # Test server startup time
            result = subprocess.run([
                server_info['cmd'], script_path, '8001'  # Use different port
            ], capture_output=True, text=True, timeout=10, cwd=test_project)
            
            end_time = time.time()
            duration = end_time - start_time
            
            if result.returncode == 0:
                self.log_result('server_scripts', f'{server_name}_startup', 'PASS', f'time={duration:.3f}s')
                    
                    # Test if server is actually responsive
                    time.sleep(1)  # Let server start
                    
                    try:
                        response = urllib.request.urlopen('http://localhost:8001/', timeout=2)
                        if response.getcode() == 200:
                            self.log_result('server_scripts', f'{server_name}_responsive', 'PASS', f'latency={(time.time()-end_time):.3f}s')
                        else:
                            self.log_result('server_scripts', f'{server_name}_responsive', 'FAIL', f'status={response.getcode()}')
                    except urllib.error.URLError as e:
                        self.log_result('server_scripts', f'{server_name}_responsive', 'FAIL', f'connection_error={str(e)}')
                    
                    # Stop server
                    subprocess.run(['pkill', '-f', server_info['cmd']], timeout=2)
                    
                else:
                    self.log_result('server_scripts', f'{server_name}_startup', 'FAIL', f'exit_code={result.returncode}, stderr={result.stderr}')
                    
            except subprocess.TimeoutExpired:
                self.log_result('server_scripts', f'{server_name}_startup', 'FAIL', 'timeout_after_5s')
            except Exception as e:
                self.log_result('server_scripts', f'{server_name}_startup', 'FAIL', f'exception={str(e)}')
            
            time.sleep(0.5)
    
    def test_console_functionality(self):
        """Test console logging and formatting"""
        print("\n📺 Testing Console Functionality...")
        
        test_project = self.setup_test_environment()
        
        # Start Python server
        server_process = subprocess.Popen([
            'python3', 
            os.path.join(self.plugin_dir, 'servers', 'python.py'),
            '8002'
        ], cwd=test_project, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        
        # Wait for server to start
        time.sleep(2)
        
        try:
            # Test console log formatting
            log_test_data = [
                {'level': 'error', 'message': 'Test error message', 'source': 'test.js'},
                {'level': 'warn', 'message': 'Test warning message', 'source': 'test.js'},
                {'level': 'info', 'message': 'Test info message', 'source': 'test.js'},
                {'level': 'log', 'message': 'Test log message', 'source': 'test.js'}
            ]
            
            for i, log_data in enumerate(log_test_data):
                post_data = json.dumps(log_data).encode('utf-8')
                post_req = urllib.request.Request(
                    'http://localhost:8002/api/console/log',
                    data=post_data,
                    headers={'Content-Type': 'application/json'}
                )
                
                try:
                    with urllib.request.urlopen(post_req, timeout=2) as response:
                        if response.getcode() == 200:
                            self.log_result('console', f'log_post_{i+1}', 'PASS', f'level={log_data["level"]}')
                        else:
                            self.log_result('console', f'log_post_{i+1}', 'FAIL', f'status={response.getcode()}')
                except urllib.error.URLError as e:
                    self.log_result('console', f'log_post_{i+1}', 'FAIL', f'connection_error={str(e)}')
                
                time.sleep(0.1)
            
            # Test console streaming
            stream_start = time.time()
            try:
                with urllib.request.urlopen('http://localhost:8002/api/console/stream', timeout=5) as response:
                    if response.getcode() == 200:
                        lines_received = 0
                        for line in response:
                            line = line.decode('utf-8').strip()
                            if line:
                                lines_received += 1
                        
                        duration = time.time() - stream_start
                        self.log_result('console', 'stream', 'PASS', f'lines={lines_received}, duration={duration:.3f}s')
                    else:
                        self.log_result('console', 'stream', 'FAIL', f'status={response.getcode()}')
            except urllib.error.URLError as e:
                self.log_result('console', 'stream', 'FAIL', f'connection_error={str(e)}')
                
        except Exception as e:
            self.log_result('console', 'test', 'FAIL', f'exception={str(e)}')
        finally:
            # Clean up
            subprocess.run(['pkill', '-f', 'python3'], timeout=2)
    
    def test_file_watching(self):
        """Test file watching performance and accuracy"""
        print("\n👁 Testing File Watching...")
        
        test_project = self.setup_test_environment()
        
        # Start server in background
        server_process = subprocess.Popen([
            'python3', 
            os.path.join(self.plugin_dir, 'servers', 'python.py'),
            '8003'
        ], cwd=test_project)
        
        time.sleep(2)  # Let server start
        
        try:
            # Test file change detection
            test_files = ['sketch.js', 'index.html']
            
            for test_file in test_files:
                file_path = os.path.join(test_project, test_file)
                original_mtime = os.path.getmtime(file_path)
                
                # Modify file
                with open(file_path, 'a') as f:
                    f.write(f'\\n// Test modification at {time.time()}')
                
# Measure detection time
                detection_start = time.time()
                reload_detected = False
                detection_time = 0
                
                for i in range(10):  # Wait up to 5 seconds
                    current_mtime = os.path.getmtime(file_path)
                    if current_mtime != original_mtime:
                        detection_time = time.time() - detection_start
                        reload_detected = True
                        break
                    time.sleep(0.5)
                
                if reload_detected and detection_time > 0:
                    self.log_result('file_watching', f'{test_file}_detection', 'PASS', f'detection_time={detection_time:.3f}s')
                else:
                    self.log_result('file_watching', f'{test_file}_detection', 'FAIL', 'no_detection_in_5s')
                
                # Restore original file
                with open(file_path, 'w') as f:
                    f.write('function setup() { createCanvas(400, 400); background(220); }')
                os.utime(file_path, (original_mtime, original_mtime))
        
        except Exception as e:
            self.log_result('file_watching', 'test', 'FAIL', f'exception={str(e)}')
        finally:
            subprocess.run(['pkill', '-f', 'python3'], timeout=2)
    
    def test_resource_usage(self):
        """Test memory and CPU usage"""
        print("\n💾 Testing Resource Usage...")
        
        try:
            import psutil
            process = psutil.Process()
            
            # Test baseline memory usage
            baseline_memory = process.memory_info().rss / 1024 / 1024  # MB
            
            # Test with plugin loaded
            subprocess.run([
                'nvim', '--headless',
                '--cmd', 'lua require("p5")',
                '--cmd', 'qa'
            ], timeout=5)
            
            # Check memory after plugin load
            subprocess.run(['sleep', '1'])
            peak_memory = process.memory_info().rss / 1024 / 1024  # MB
            
            memory_increase = peak_memory - baseline_memory
            self.log_result('resource', 'memory_usage', 'PASS' if memory_increase < 50 else 'WARN', f'baseline={baseline_memory:.1f}MB, peak={peak_memory:.1f}MB, increase={memory_increase:.1f}MB')
            
        except ImportError:
            self.log_result('resource', 'memory_usage', 'SKIP', 'psutil_not_available')
        except Exception as e:
            self.log_result('resource', 'memory_usage', 'FAIL', f'exception={str(e)}')
    
    def generate_benchmark_report(self):
        """Generate comprehensive benchmark report"""
        print("\n" + "="*60)
        print("🎯 P5.NVIM COMPREHENSIVE BENCHMARK REPORT")
        print("="*60)
        print()
        
        categories = {
            'startup': 'Plugin Startup Performance',
            'server_scripts': 'Server Script Compatibility', 
            'console': 'Console Functionality',
            'file_watching': 'File Watching Performance',
            'resource': 'Resource Usage'
        }
        
        for category, tests in self.results.items():
            if not tests:
                continue
                
            print(f"\n📊 {categories[category]}")
            print("-" * 40)
            
            pass_count = sum(1 for t in tests.values() if t['result'] == 'PASS')
            fail_count = sum(1 for t in tests.values() if t['result'] == 'FAIL')
            skip_count = sum(1 for t in tests.values() if t['result'] == 'SKIP')
            total_count = len(tests)
            
            success_rate = (pass_count / total_count * 100) if total_count > 0 else 0
            
            print(f"Overall: {pass_count}/{total_count} passed ({success_rate:.1f}% success rate)")
            if fail_count > 0:
                print(f"⚠️  {fail_count} test(s) failed")
            if skip_count > 0:
                print(f"ℹ️  {skip_count} test(s) skipped")
            
            for test_name, result in tests.items():
                status_icon = "✅" if result['result'] == 'PASS' else "❌" if result['result'] == 'FAIL' else "⏭️"
                print(f"  {status_icon} {test_name}: {result['result']}")
                if result['details']:
                    print(f"    📋 {result['details']}")
        
        print()
        print("="*60)
        print("🏁 Benchmark completed!")
    
    def run_all_tests(self):
        """Execute complete test suite"""
        print("🚀 Starting Comprehensive p5.nvim Test Suite...")
        print(f"Test Directory: {self.test_dir}")
        print(f"Plugin Directory: {self.plugin_dir}")
        print()
        
        try:
            self.test_plugin_startup()
            self.test_server_scripts()
            self.test_console_functionality()
            self.test_file_watching()
            self.test_resource_usage()
            self.generate_benchmark_report()
            
        except Exception as e:
            print(f"💥 Test suite failed with exception: {e}")
            return False
        
        return True

def main():
    """Main test execution"""
    suite = P5TestSuite()
    
    if len(sys.argv) > 1 and sys.argv[1] == '--quick':
        suite.test_plugin_startup()
    else:
        suite.run_all_tests()

if __name__ == '__main__':
    main()