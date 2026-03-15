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
      dubPath = vim.fn.exepath("dub") or "dub",
      dubCompiler = "ldc2",
      enableLinting = true,
      enableAutoComplete = true,
      enableDubLinting = true,
      stdlibPath = {
        "/usr/lib/ldc/x86_64-redhat-linux-gnu/include/d",
        "/home/mnlcz/dlang/dmd-2.112.0/src/druntime/import",
        "/home/mnlcz/dlang/dmd-2.112.0/src/phobos",
      },
    }
  }
}
