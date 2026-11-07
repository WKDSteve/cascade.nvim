-- Live check: stepping list numbers, letters and Roman numerals, and what is not a marker (task
-- cascade.nvim/testblatt-bindings-checkliste; section 8 of ALL/manual-test-checklists/cascade.md).
-- The keys are fed below the terminal's decoder: whether a terminal sends <C-S-y> at all is in `manual`.
return {
  id = "cascade.shift",
  title = "cascade.nvim: <C-y>, <C-x> on a marker, <C-S-y>, <leader>c+, letters, Roman numerals, bare markers",
  task = "cascade.nvim/manual-checklist-run",
  steps = {
    { lua = [[dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua"); _G.setup()]] },

    { lua = [[_G.fresh("markdown", "1. a", "2. b", "3. c")]] },
    { keys = "j<C-x>" },
    { expect = [[_G.text() == "1. a\n1. b\n2. c"]], note = "on the marker: the item and the later siblings" },

    { lua = [[_G.fresh("markdown", "  2. a", "  3. b")]] },
    { keys = "<C-x>", note = "the cursor before the marker" },
    { expect = [[_G.text() == "  1. a\n  2. b"]], note = "counts as on it" },

    { lua = [[_G.fresh("markdown", "5. a", "9. b", "12. c")]] },
    { keys = "j<C-x>" },
    { expect = [[_G.text() == "5. a\n8. b\n11. c"]], note = "no full renumber" },
    { keys = "3<C-y>" },
    { expect = [[_G.text() == "5. a\n11. b\n14. c"]], note = "the count steps by 3" },
    { keys = "." },
    { expect = [[_G.text() == "5. a\n14. b\n17. c"]], note = ". repeats it" },

    { lua = [[_G.fresh("markdown", "1. a", "2. b", "   wrapped", "   1. child", "3. c")]] },
    { keys = "j<C-y>" },
    {
      expect = [[_G.text() == "1. a\n3. b\n   wrapped\n   1. child\n4. c"]],
      note = "deeper children and continuation lines stay",
    },

    { lua = [[_G.fresh("markdown", "1. x", "2. Buy 3 apples"); vim.api.nvim_win_set_cursor(0, { 2, 7 })]] },
    { keys = "<C-y>" },
    { expect = [[_G.text() == "1. x\n2. Buy 4 apples"]], note = "in the item text: the number there, not the marker" },
    { keys = "<C-x>" },
    { expect = [[_G.text() == "1. x\n2. Buy 3 apples"]] },

    { lua = [[_G.fresh("markdown", "2. a", "3. b", "4. c"); vim.api.nvim_win_set_cursor(0, { 2, 4 })]] },
    { keys = "<C-S-y>" },
    { expect = [[_G.text() == "3. a\n4. b\n5. c"]], note = "<C-S-y> anywhere on an item: the whole level" },
    { keys = "<C-S-x>" },
    { expect = [[_G.text() == "2. a\n3. b\n4. c"]], note = "<C-S-x>" },
    { keys = "<leader>c+" },
    { expect = [[_G.text() == "3. a\n4. b\n5. c"]], note = "the portable <leader>c+" },
    { keys = "<leader>c-" },
    { expect = [[_G.text() == "2. a\n3. b\n4. c"]], note = "the portable <leader>c-" },

    { lua = [[_G.fresh("markdown", "a) x")]] },
    { keys = "<C-y>" },
    { expect = [[_G.text() == "b) x"]], note = "letters step through their own sequence" },
    { lua = [[_G.fresh("markdown", "iii. x")]] },
    { keys = "<C-y>" },
    { expect = [[_G.text() == "iv. x"]], note = "Roman numerals too" },
    { lua = [[_G.fresh("markdown", "III. x")]] },
    { keys = "<C-y>" },
    { expect = [[_G.text() == "IV. x"]], note = "the case kept" },
    { lua = [[_G.fresh("markdown", "B) x")]] },
    { keys = "<C-y>" },
    { expect = [[_G.text() == "C) x"]], note = "for letters too" },

    { lua = [[_G.fresh("markdown", "z) x"); _G.notes = {}]] },
    { keys = "<C-y>" },
    { expect = [[_G.text() == "z) x" and #_G.notes > 0]], note = "z) is refused with a message, no aa)" },
    { lua = [[_G.fresh("markdown", "a) x"); _G.notes = {}]] },
    { keys = "<C-x>" },
    { expect = [[_G.text() == "a) x" and #_G.notes > 0]], note = "refused below a" },
    { lua = [[_G.fresh("markdown", "i. x"); _G.notes = {}]] },
    { keys = "<C-x>" },
    { expect = [[_G.text() == "i. x" and #_G.notes > 0]], note = "refused below i" },
    { lua = [[_G.fresh("markdown", "0. x"); _G.notes = {}]] },
    { keys = "<C-x>" },
    { expect = [[_G.text() == "0. x" and #_G.notes > 0]], note = "refused below 0" },

    { lua = [[_G.fresh("markdown", "1. a", "5.", "9. c")]] },
    { keys = "<leader>cr" },
    { expect = [[_G.text() == "1. a\n2. \n3. c"]], note = "a bare 5. with no space is an empty item, in sequence" },

    { lua = [[_G.fresh("markdown", "1. a", "1. b", "Mix.")]] },
    { keys = "<leader>cr" },
    { expect = [[_G.text() == "1. a\n2. b\nMix."]], note = "the prose line Mix. is no Roman marker, <leader>cr" },
    { lua = [[_G.file("md", "1. a")
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "1. a", "1. b", "Civ.", "1. c" })]] },
    { keys = ":w<CR>" },
    { expect = [[_G.text() == "1. a\n2. b\nCiv.\n3. c"]], note = "Civ. neither, on :w, and the numbering goes on" },
  },
  manual = {
    "In a real terminal with the kitty keyboard protocol or modifyOtherKeys, <C-S-y> and <C-S-x> arrive as keys of their own",
  },
}
