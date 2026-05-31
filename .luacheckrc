globals = {
  "vim",
}

-- Don't warn about unused arguments
ignore = {
  "212",
  "411",
}

-- Max line length
max_line_length = 120

-- Paths to include
include_paths = {
  "lua/",
  "plugin/",
}

-- Exclude test files from certain checks
files["tests/"] = {
  ignore = {
    "212",
    "411",
    "421",
  },
}
