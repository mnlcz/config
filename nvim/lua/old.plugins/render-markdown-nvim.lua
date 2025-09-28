return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },
  opts = {
    completions = {
      lsp = {
        enabled = true,
      },
    },
    code = {
      style = 'language',
    },
  },
}
