local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function template(_, _, filename)
  local path = "./templates/" .. filename .. ".template"
  local file = io.open(path, "r")

  if not file then
    return nil
  end

  local content = file:read "*a"
  file:close()

  -- Create a text node for each line of the file content
  local nodes = {}
  for line in content:gmatch "[^\n]+" do
    table.insert(nodes, line)
  end

  return nodes
end

ls.add_snippets("plaintex", {
  s("personaltemplate", {
    f(template, {}, {
      user_args = { "tex" },
    }),
  }),
})
