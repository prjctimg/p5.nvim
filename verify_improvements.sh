#!/bin/bash

# Verification script for p5.nvim improvements
# This script verifies that all improvements have been implemented

echo "🔍 Verifying p5.nvim improvements..."
echo "======================================"

PASSED=0
TOTAL=0

# Function to check if a file contains specific content
check_content() {
	local file=$1
	local pattern=$2
	local description=$3

	TOTAL=$((TOTAL + 1))
	echo -n "Checking $description... "

	if grep -q "$pattern" "$file"; then
		echo "✅"
		PASSED=$((PASSED + 1))
		return 0
	else
		echo "❌"
		echo "  Missing: $pattern"
		return 1
	fi
}

echo ""
echo "📁 Checking file structure..."
files=(
	"lua/p5/project.lua"
	"lua/p5/server.lua"
	"lua/p5/console.lua"
	"servers/python.py"
	"plugin/p5.lua"
)

for file in "${files[@]}"; do
	if [ -f "$file" ]; then
		echo "✅ $file exists"
	else
		echo "❌ $file missing"
	fi
done

echo ""
echo "🚀 Checking project creation improvements..."
check_content "lua/p5/project.lua" "Creating p5.js project:" "Project creation start notification"
check_content "lua/p5/project.lua" "Assets copied successfully" "Asset copying success notification"
check_content "lua/p5/project.lua" "Changed directory to:" "CWD change notification"

echo ""
echo "🔌 Checking server port improvements..."
check_content "lua/p5/server.lua" "find_available_port" "Port finding function"
check_content "lua/p5/server.lua" "requires root privileges" "Privileged port validation"
check_content "lua/p5/server.lua" "Port.*in use, using.*instead" "Port conflict notification"
check_content "lua/p5/server.lua" "Server stopped on port" "Server stop notification with port"

echo ""
echo "📺 Checking console improvements..."
check_content "lua/p5/console.lua" "/api/console/stream" "New streaming endpoint"
check_content "lua/p5/console.lua" "console_batch" "Batch log processing"
check_content "lua/p5/console.lua" "debounce" "Debouncing logic"
check_content "lua/p5/console.lua" "beforeunload" "Page unload handling"

echo ""
echo "🐍 Checking Python server enhancements..."
check_content "servers/python.py" "ANSI_COLORS" "ANSI color definitions"
check_content "servers/python.py" "format_log_entry" "Log formatting function"
check_content "servers/python.py" "/api/console/stream" "Streaming endpoint"
check_content "servers/python.py" "console_batch" "Batch log handling"

echo ""
echo "⌨️  Checking user commands..."
check_content "plugin/p5.lua" "P5CreateProject" "Project creation command"

echo ""
echo "======================================"
echo "✅ Verification Summary: $PASSED/$TOTAL checks passed"

if [ $PASSED -eq $TOTAL ]; then
	echo "🎉 All improvements implemented successfully!"
	exit 0
else
	echo "⚠️  Some improvements may be incomplete"
	exit 1
fi
