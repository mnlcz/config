return {
  "lervag/vimtex",
  lazy = false,
  ft = "plaintex",
  config = function()
    -- Viewer
    vim.g.vimtex_view_method = "zathura"
    -- vim.g.vimtex_view_general_viewer = "sioyek"

    -- Compilation
    vim.g.vimtex_compiler_latexmk = {
      out_dir = "build",
      aux_dir = "./aux",
    }

    -- Disable `K` as it conflicts with LSP hover
    vim.g.vimtex_mappings_disable = { ["n"] = { "K" } }
  end,
}
