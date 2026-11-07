-- Live check: the global cycle in a code buffer (task cascade.nvim/testblatt-bindings-checkliste; section 6 of
-- ALL/manual-test-checklists/cascade.md, the bindings checklist's <C-y>, <C-x>, +, -, <leader>cP, <C-M-y>, <C-M-x>).
-- The keys are fed below the terminal's decoder: whether a terminal sends <C-M-y> at all is a question for a person.
return {
  id = "cascade.cycle",
  title = "cascade.nvim: <C-y>, <C-x>, +, -, <C-M-y>, <leader>cP on words, numbers, dates and operators",
  task = "cascade.nvim/manual-checklist-run",
  steps = {
    { lua = [[dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua"); _G.setup()]] },

    { lua = [[_G.fresh("lua", "true")]] },
    { keys = "<C-y>" },
    { expect = [[_G.text() == "false"]], note = "<C-y> in a .lua buffer" },
    { keys = "<C-x>" },
    { expect = [[_G.text() == "true"]], note = "<C-x>" },
    { lua = [[_G.fresh("lua", "On")]] },
    { keys = "<C-y>" },
    { expect = [[_G.text() == "Off"]], note = "the case is kept" },
    { lua = [[_G.fresh("lua", "TRUE")]] },
    { keys = "+" },
    { expect = [[_G.text() == "FALSE"]], note = "+ does the same, the case kept" },
    { keys = "-" },
    { expect = [[_G.text() == "TRUE"]], note = "- does the same" },

    { lua = [[_G.fresh("lua", "  zzq one", "    zzq two")]] },
    { keys = "+" },
    { expect = [[vim.fn.line(".") == 2 and vim.fn.col(".") == 5]], note = "nothing cyclable: native + (first non-blank below)" },
    { keys = "-" },
    { expect = [[vim.fn.line(".") == 1 and vim.fn.col(".") == 3]], note = "native -" },
    { expect = [[_G.text() == "  zzq one\n    zzq two"]], note = "and no edit" },

    { lua = [[_G.fresh("lua", "41")]] },
    { keys = "+" },
    { expect = [[_G.text() == "42"]], note = "+ on an integer is <C-a>" },
    { keys = "-" },
    { expect = [[_G.text() == "41"]], note = "- on an integer is <C-x>" },
    { keys = "3+" },
    { expect = [[_G.text() == "44"]], note = "the count is re-emitted" },
    { keys = "3<C-y>" },
    { expect = [[_G.text() == "47"]], note = "<C-y> on an integer too" },

    { lua = [[_G.fresh("lua", "2026-08-30"); vim.api.nvim_win_set_cursor(0, { 1, 8 })]] },
    { keys = "3<C-y>" },
    { expect = [[_G.text() == "2026-09-02"]], note = "the day rolls over the month, not day 33" },
    { lua = [[vim.api.nvim_win_set_cursor(0, { 1, 5 })]] },
    { keys = "+" },
    { expect = [[_G.text() == "2026-10-02"]], note = "+ on the month segment" },
    { lua = [[vim.api.nvim_win_set_cursor(0, { 1, 0 })]] },
    { keys = "-" },
    { expect = [[_G.text() == "2025-10-02"]], note = "- on the year segment" },

    {
      lua = [[_G.ops = function(line, col, key, want)
        _G.fresh("lua", line)
        vim.api.nvim_win_set_cursor(0, { 1, col })
        vim.api.nvim_feedkeys(vim.keycode(key), "mtx", false)
        return _G.text() == want
      end]],
    },
    { expect = [[_G.ops("a == b", 2, "<C-y>", "a != b")]], note = "== at its first character" },
    { expect = [[_G.ops("a == b", 3, "<C-y>", "a != b")]], note = "== mid-operator: by position, not iskeyword" },
    { expect = [[_G.ops("a && b", 3, "+", "a || b")]], note = "&&" },
    { expect = [[_G.ops("a < b", 2, "<C-y>", "a > b")]], note = "<" },
    { expect = [[_G.ops("a + b", 2, "+", "a - b")]], note = "+" },

    { lua = [[_G.fresh("lua", "cat"); vim.api.nvim_win_set_cursor(0, { 1, 1 })]] },
    { keys = "<C-M-y>" },
    { expect = [[_G.text() == "cbt"]], note = "<C-M-y>: the character, inside a word" },
    { keys = "<C-M-x>" },
    { expect = [[_G.text() == "cat"]], note = "<C-M-x> back" },
    { keys = "3<C-M-y>" },
    { expect = [[_G.text() == "cdt"]], note = "the count jumps" },
    { keys = "<leader>cy" },
    { expect = [[_G.text() == "cet"]], note = "the portable alias <leader>cy" },
    { keys = "<leader>cY" },
    { expect = [[_G.text() == "cdt"]], note = "and <leader>cY" },

    { lua = [[_G.fresh("lua", "true")]] },
    { keys = "<leader>cP" },
    { wait = [[vim.api.nvim_win_get_config(0).relative ~= ""]], note = "<leader>cP opens the themed chooser of ui.kit" },
    { expect = [[_G.text():find("true", 1, true) and _G.text():find("false", 1, true)]], note = "it lists the group's values" },
    { keys = "j<CR>" },
    { wait = [[vim.api.nvim_win_get_config(0).relative == "" and _G.text() == "false"]], note = "and the pick lands" },

    {
      lua = [[_G.fresh("lua", "true")
      _G.asked = nil
      vim.ui.select = function(items, _, on_choice)
        _G.asked = items
        on_choice("false")
      end]],
      note = "a vim.ui.select someone registered, as telescope-ui-select does; it answers by itself",
    },
    { keys = "<leader>cP" },
    { wait = [[_G.asked ~= nil]], note = "<leader>cP respects it" },
    { expect = [[vim.deep_equal(_G.asked, { "true", "false" })]], note = "with the values of the group" },
    { expect = [[_G.text() == "false"]], note = "and the pick lands" },
    { expect = [[vim.fn.maparg("<leader>cp", "n") == ""]], note = "the default <leader>cp is free in this config" },
  },
  manual = {
    "In a real terminal, with the real keyboard layout, <C-M-y> and <C-M-x> arrive as keys (AltGr may swallow them)",
  },
}
