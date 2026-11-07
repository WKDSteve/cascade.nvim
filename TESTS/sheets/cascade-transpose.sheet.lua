-- Live check: swapping characters, words and selections (task cascade.nvim/testblatt-bindings-checkliste; section 7 of
-- ALL/manual-test-checklists/cascade.md, the bindings checklist's <leader><C-Left>).
return {
  id = "cascade.transpose",
  title = "cascade.nvim: <leader><Right>, <leader><Left>, <leader><C-Right>, <leader><C-Left>",
  task = "cascade.nvim/manual-checklist-run",
  steps = {
    {
      lua = [[dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua"); _G.setup()
      _G.selected = function()
        return table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() }), "\n")
      end]],
    },

    { lua = [[_G.fresh("lua", "aéz")]] },
    { keys = "<leader><Right>" },
    { expect = [[_G.text() == "éaz"]], note = "a multi-byte neighbor stays whole" },
    { keys = "<leader><Left>" },
    { expect = [[_G.text() == "aéz"]], note = "<leader><Left> back" },
    { lua = [[_G.fresh("lua", "a🚀z")]] },
    { keys = "l<leader><Right>" },
    { expect = [[_G.text() == "az🚀"]], note = "an emoji moves whole" },

    { lua = [[_G.fresh("lua", "abcde")]] },
    { keys = "3<leader><Right>" },
    { expect = [[_G.text() == "bcdae"]], note = "the count is 3 swaps in a row" },
    { lua = [[_G.fresh("lua", "ab")]] },
    { keys = "9<leader><Right>" },
    { expect = [[_G.text() == "ba"]], note = "stops at the line end" },

    { lua = [[_G.fresh("lua", "one two three")]] },
    { keys = "<leader><C-Right>" },
    { expect = [[_G.text() == "two one three"]], note = "the word with its right neighbor" },
    { lua = [[_G.fresh("lua", "one two three"); vim.api.nvim_win_set_cursor(0, { 1, 8 })]] },
    { keys = "<leader><C-Left>" },
    { expect = [[_G.text() == "one three two"]], note = "the word with its left neighbor" },

    { lua = [[_G.fresh("lua", "abXYcd"); vim.api.nvim_win_set_cursor(0, { 1, 2 })]] },
    { keys = "vl<leader><Right>" },
    { expect = [[_G.text() == "abcXYd"]], note = "a selection with its right neighbor character, as a block" },
    { expect = [[_G.selected() == "XY"]], note = "the swapped text stays selected" },
    { keys = "<leader><Left>" },
    { expect = [[_G.text() == "abXYcd"]], note = "and with its left one" },
    { keys = "<Esc>" },
    { lua = [[_G.fresh("lua", "one two three"); vim.api.nvim_win_set_cursor(0, { 1, 0 })]] },
    { keys = "viw<leader><C-Right>" },
    { expect = [[_G.text() == "two one three"]], note = "a selection with its right neighbor word" },
    { expect = [[_G.selected() == "one"]], note = "the swapped word stays selected" },
    { keys = "<leader><C-Left>" },
    { expect = [[_G.text() == "one two three"]], note = "and with its left one" },
    { keys = "<Esc>" },
  },
}
