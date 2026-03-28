-- Function to get the current operating system
-- Returns: "windows", "macos", "linux", or "unknown"
function Get_current_os()
  local os_name = "unknown"

  -- Check if we're on Windows
  if package.config:sub(1, 1) == '\\' then
    os_name = "windows"
  else
    -- For Unix-like systems, we need to check further
    local handle = io.popen("uname -s")
    if handle then
      local uname_output = handle:read("*a")
      handle:close()

      if uname_output then
        uname_output = uname_output:lower():gsub("%s+", "")

        if uname_output:find("darwin") then
          os_name = "macos"
        elseif uname_output:find("linux") then
          os_name = "linux"
        end
      end
    end
  end

  return os_name
end

-- Simple usage example
if arg and arg[0] then
  -- Only run if script is executed directly
  local current_os = Get_current_os()
  print("Current OS: " .. current_os)
end

-- Return the module for require usage
return {
  get_current_os = Get_current_os,
}
