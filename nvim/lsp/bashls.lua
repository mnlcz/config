return {
  cmd = { "bash-language-server", "start" },
  filetypes = { "bash", "sh" },
  root_markers = { ".git", ".bashrc" },
  settings = {
    bashIde = {
      globPattern = "*@(.sh|.inc|.bash|.command)"
    }
  }
}
