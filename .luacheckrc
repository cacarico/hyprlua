std = "lua54"  -- Adjust based on your Lua version
max_line_length = 130

globals = {
  "vim",
  "use",
  "hyprlua",  -- Add your global variable here
}

ignore = {
  "211", -- Example: Ignore unused variable warnings
}

ignore_files = { "examples/**" }
