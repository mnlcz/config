return {
  cmd = { "serve-d" },
  filetypes = { "d" },
  root_markers = {
    "dub.json",
    "dub.sdl",
    ".git"
  },
  settings = {
    d = {
      dubPath = vim.fn.exepath("dub") or "dub",  -- explicit path to dub
      dubCompiler = "ldc2",
      enableLinting = true,
      enableAutoComplete = true,
      enableDubLinting = true,
      stdlibPath = "auto",  -- let serve-d auto-detect stdlib
    }
  }
}
