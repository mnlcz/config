-- IGNORED IN lsp.lua, USING vimtex PLUGIN INSTEAD
return {
  cmd = {
    "texlab",
  },
  filetypes = { 'tex', 'plaintex', 'bib' },
  root_markers = { '.git', '.latexmkrc', 'latexmkrc', '.texlabroot', 'texlabroot', 'Tectonic.toml' },
}
