local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("php", {
  s({
    trig = "vd",
    name = "Var dump",
    dscr = "Dump a variable",
  }, {
    t "var_dump(",
    i(1),
    t ");",
  }),

  s({
    trig = "vdd",
    name = "Var dump and die",
    dscr = "Dump a variable and end execution",
  }, {
    t "die(var_dump(",
    i(1),
    t "));",
  }),

  s({
    trig = "measure_s",
    name = "Setup benchmark",
    dscr = "Starts timer and sets a lambda for checking constraints",
  }, {
    t {
      "$start_time = microtime(true);",
      "$time_exceeded = fn($current_time) => $current_time - $start_time > $time_limit;",
    },
  }),

  s({
    trig = "measure_t",
    name = "Check benchmark",
    dscr = "Checks if the execution exceeded the time limit",
  }, {
    t {
      "if ($time_exceeded(microtime(true)))",
      '    return "Execution paused. Time limit exceeded.";',
    },
  }),
})
