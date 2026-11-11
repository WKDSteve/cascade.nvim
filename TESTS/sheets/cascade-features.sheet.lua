-- Live check: feature switches and what :checkhealth says about them (task
-- cascade.nvim/testblatt-bindings-checkliste; section 10 and the setup of ALL/manual-test-checklists/cascade.md).
return {
  id = "cascade.features",
  feature = "cascade.switches",
  title = "cascade.nvim: a switched-off feature refuses its action; :checkhealth reports the domains",
  task = "cascade.nvim/manual-checklist-run",
  steps = {
    {
      lua = [[dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua")
      _G.setup({ lists = { features = { rotate = false } }, cycle = { features = { word = false } } })]],
      note = "rotate and the word cycle off, as in a scratch config",
    },

    { lua = [[_G.fresh("markdown", "1. a", "2. b")]] },
    { expect = [[vim.fn.maparg("<leader>cl", "n") == ""]], note = "the preset does not bind the key of a feature that is off" },
    {
      lua = [[vim.keymap.set("n", "<leader>cl", require("cascade").rotate_form_next, { buffer = true })]],
      note = "bound by hand",
    },
    { keys = "<leader>cl" },
    { expect = [[_G.text() == "1. a\n2. b"]], note = "the action itself refuses" },

    { lua = [[_G.fresh("lua", "true", "x", "x", "x")]] },
    {
      expect = [[vim.fn.maparg("<C-y>", "n") == "" and vim.fn.maparg("<C-x>", "n") == ""]],
      note = "<C-y> and <C-x> are not taken",
    },
    { keys = "<C-y>" },
    { expect = [[_G.text() == "true\nx\nx\nx"]], note = "<C-y> is native again: no word cycled" },
    { keys = "<C-x>" },
    { expect = [[_G.text() == "true\nx\nx\nx"]], note = "<C-x> on a word without a number: native, nothing" },

    { keys = ":checkhealth cascade<CR>" },
    { wait = [[_G.text():find("lib.nvim detected", 1, true)]], note = "lib.nvim, a required dependency" },
    { expect = [[_G.text():find("Neovim ", 1, true)]], note = "the Neovim version" },
    { expect = [[_G.text():find("lists", 1, true) and _G.text():find("cycle", 1, true)]], note = "the domains" },
    { expect = [[_G.text():find("sequence", 1, true) and _G.text():find("transpose", 1, true)]] },
    { expect = [[_G.text():find("strings: enabled for", 1, true)]], note = "the strings block" },
    { expect = [[_G.text():find("strings: converts on InsertLeave, TextChanged", 1, true)]], note = "and its triggers" },
    { expect = [[not _G.text():find("rotate", 1, true)]], note = "no line per feature: the documented limit still holds" },
    {
      expect = [[#vim.tbl_filter(function(l)
        return l:find("ERROR", 1, true) ~= nil
      end, vim.api.nvim_buf_get_lines(0, 0, -1, false)) == 0]],
      note = "no error line in a healthy setup",
    },
  },
}
