local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local function template(_, _, filename)
  local path = vim.fn.stdpath "config" .. "/lua/custom/lua_snippets/templates/" .. filename .. ".template"
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

ls.add_snippets("tex", {
  -- Templates
  s({
    trig = "personaltemplate",
    name = "Tex file skeleton",
    dscr = "Skeleton ready for code snippets and general editing",
  }, {
    f(template, {}, {
      user_args = { "tex" },
    }),
  }),
  s({
    trig = "simpletemplate",
    name = "Tex file basic skeleton",
    dscr = "Skeleton with only the basics",
  }, {
    f(template, {}, {
      user_args = { "simple.tex" },
    }),
  }),

  -- Blocks
  s(
    {
      trig = "inlinecode",
      name = "Lstinline command",
      dscr = "Insert code inline",
    },
    fmt(
      [[
    \lstinline|{}|
    ]],
      { i(1, "some code") }
    )
  ),
  s(
    {
      trig = "inlinecodelang",
      name = "Lstinline command with language",
      dscr = "Insert code inline with language specification",
    },
    fmt(
      [[
    \lstinline[language={}]|{}|
    ]],
      { i(1), i(2, "some code") }
    )
  ),
  s(
    {
      trig = "bigcode",
      name = "Lstlisting block",
      dscr = "Insert code snippet with caption",
    },
    fmt(
      [[
    \begin{{lstlisting}}[caption={}]
        {}
    \end{{lstlisting}}
    ]],
      { i(1), i(2) }
    )
  ),
  s(
    {
      trig = "bigcodelangnocap",
      name = "Lstlisting block without caption",
      dscr = "Insert code snippet with language",
    },
    fmt(
      [[
    \begin{{lstlisting}}[language={}]
        {}
    \end{{lstlisting}}
    ]],
      { i(1), i(2) }
    )
  ),
  s(
    {
      trig = "bigcodelang",
      name = "Lstlisting block with language",
      dscr = "Insert code snippet with caption and language",
    },
    fmt(
      [[
    \begin{{lstlisting}}[language={}, caption={}]
        {}
    \end{{lstlisting}}
    ]],
      { i(1), i(2), i(3) }
    )
  ),
  s({
    trig = "box",
    name = "Boxed block",
    dscr = "Insert a boxed block",
  }, {
    t "\\boxed{",
    i(1),
    t "}",
  }),

  -- Media
  s(
    {
      trig = "img",
      name = "Insert image",
      dscr = "Figure with graphic and caption",
    },
    fmt(
      [[
    \begin{{figure}}[h]
        \centering
        \includegraphics[width={}\textwidth]{{{}}}
        \caption{{{}}}
    \end{{figure}}
    ]],
      { i(1), i(2), i(3) }
    )
  ),

  -- Math
  s({
    trig = "E",
    name = "Times 10 to the power of",
    dscr = "Some number times 10 to the power of another number",
  }, {
    t "\\cdot 10^",
    i(1),
  }),
  s({
    trig = ".",
    name = "Multiplication",
    dscr = "Insert cdot command",
  }, {
    t "\\cdot ",
    i(1),
  }),
  s(
    {
      trig = "dv",
      name = "Derivative",
      dscr = "Insert frac for derivative",
    },
    fmt(
      [[
    \frac{{d{}}}{{d{}}}
    ]],
      { i(1), i(2) }
    )
  ),

  -- Text
  s({
    trig = "mrm",
    name = "Mathrm block",
    dscr = "Text block in math mode",
  }, {
    t "\\mathrm{",
    i(1),
    t "}",
  }),
  s({
    trig = "u",
    name = "Unit of measurement",
    dscr = "Insert mathrm block for unit of measurement",
  }, {
    t "\\mathrm{",
    i(1),
    t "}",
  }),
  s({
    trig = "arg",
    name = "Complex number argument",
    dscr = "Insert mathrm block for complex number argument",
  }, {
    t "\\mathrm{arg}(",
    i(1),
    t ")",
  }),
  s({
    trig = "real",
    name = "Complex number real part",
    dscr = "Insert mathrm block for complex number real part",
  }, {
    t "\\mathrm{Re}(",
    i(1),
    t ")",
  }),
  s({
    trig = "imag",
    name = "Complex number imaginary part",
    dscr = "Insert mathrm block for complex number imaginary part",
  }, {
    t "\\mathrm{Im}(",
    i(1),
    t ")",
  }),
  s({
    trig = "deg",
    name = "Degree symbol",
    dscr = "Insert circ command for replicating the degree symbol",
  }, {
    t "^\\circ",
  }),
})
