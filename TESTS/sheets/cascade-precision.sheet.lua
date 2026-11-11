-- Live check: Tree-sitter precision (task cascade.nvim/testblatt-bindings-checkliste; section 11 of
-- ALL/manual-test-checklists/cascade.md). Neovim bundles the markdown parser, so this runs everywhere.
return {
  id = "cascade.precision",
  feature = "cascade.list-precision",
  title = 'cascade.nvim: lists.precision = "treesitter" skips a fenced block; no parser falls back',
  task = "cascade.nvim/manual-checklist-run",
  steps = {
    { lua = [[dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua"); _G.setup()]], note = 'first the default, "off"' },

    { lua = [[_G.fresh("markdown", "```sh", "- flag", "```"); vim.api.nvim_win_set_cursor(0, { 2, 0 })]] },
    { keys = "A<CR>x<Esc>" },
    { expect = [[_G.text() == "```sh\n- flag\n- x\n```"]], note = '"off" is blind to the fence: it continues' },

    { lua = [[_G.setup({ lists = { precision = "treesitter" } })]], note = "the opt-in" },
    {
      lua = [[_G.fresh("markdown", "- out", "", "```sh", "- flag", "```"); vim.treesitter.get_parser(0):parse()
      vim.api.nvim_win_set_cursor(0, { 4, 0 })]],
    },
    { keys = "A<CR>x<Esc>" },
    { expect = [[_G.text() == "- out\n\n```sh\n- flag\nx\n```"]], note = "<CR> in the fence: a plain newline" },
    { keys = "<A-->" },
    { expect = [[_G.text() == "- out\n\n```sh\n- flag\nx\n```"]], note = "the quick toggle in the fence: nothing" },
    { lua = [[vim.api.nvim_win_set_cursor(0, { 1, 0 })]] },
    { keys = "A<CR>y<Esc>" },
    { expect = [[_G.text() == "- out\n- y\n\n```sh\n- flag\nx\n```"]], note = "outside the fence the list goes on" },

    { lua = [[_G.fresh("text", "- a")]], note = "a list filetype with no parser" },
    { keys = "A<CR>b<Esc>" },
    { expect = [[_G.text() == "- a\n- b"]], note = 'no parser: as "off", not an error' },
    { lua = [[_G.fresh("text", "plain")]] },
    { keys = "<A-->" },
    { expect = [[_G.text() == "- plain"]], note = "the quick toggle too" },
  },
}
