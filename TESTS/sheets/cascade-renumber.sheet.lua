-- Live check: renumbering on save, by key, by command, inside a selection (task
-- cascade.nvim/testblatt-bindings-checkliste; section 2 of ALL/manual-test-checklists/cascade.md, the bindings
-- checklist's <leader>cR).
return {
  id = "cascade.renumber",
  title = "cascade.nvim: renumber on :w, <leader>cr, <leader>cR and :Cascade renumber all",
  task = "cascade.nvim/testblatt-bindings-checkliste",
  steps = {
    { lua = [[dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua"); _G.setup()]] },

    { lua = [[_G.file("md", "1. a")
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "1. a", "1. b", "1. c" })]] },
    { keys = ":w<CR>" },
    { expect = [[_G.text() == "1. a\n2. b\n3. c"]], note = "typed by hand, all 1.: the save renumbers" },
    {
      expect = [[table.concat(vim.fn.readfile(vim.api.nvim_buf_get_name(0)), "\n") == "1. a\n2. b\n3. c"]],
      note = "and the file has it",
    },

    { lua = [[_G.fresh("markdown", "1. a", "5. b", "9. c")]] },
    { keys = "<leader>cr" },
    { expect = [[_G.text() == "1. a\n2. b\n3. c"]], note = "<leader>cr renumbers at once, no save" },

    { lua = [[_G.fresh("markdown", "1. a", "5. b", "", "5. x", "9. y")]] },
    { keys = "<leader>cr" },
    { expect = [[_G.text() == "1. a\n2. b\n\n5. x\n9. y"]], note = "a blank line ends the block: the next list stays" },
    { keys = "Gk<leader>cr" },
    { expect = [[_G.text() == "1. a\n2. b\n\n5. x\n6. y"]], note = "the next list keeps its own offset" },

    { lua = [[_G.fresh("markdown", "1. a", "   note", "7. b")]] },
    { keys = "<leader>cr" },
    { expect = [[_G.text() == "1. a\n   note\n2. b"]], note = "a continuation line does not break the sequence" },

    { lua = [[_G.fresh("lua", "-- see 5. one, 8. two, 2. three, 9. four")]] },
    { keys = "f5vf2<leader>cR<Esc>", note = "from the first ordinal to the third, in a .lua buffer" },
    { expect = [[_G.text() == "-- see 5. one, 6. two, 2. three, 9. four"]], note = "a token needs its delimiter inside" },
    { lua = [[_G.fresh("lua", "-- see 5. one, 8. two, 2. three, 9. four")]] },
    { keys = "f5vf9l<leader>cR<Esc>", note = "up to the delimiter of the last one" },
    { expect = [[_G.text() == "-- see 5. one, 6. two, 7. three, 8. four"]], note = "the ordinals mid-prose, any filetype" },

    { lua = [[_G.fresh("markdown", "1. a", "1. b", "", "text", "", "4. c", "9. d")]] },
    { keys = ":Cascade renumber all<CR>" },
    {
      expect = [[_G.text() == "1. a\n2. b\n\ntext\n\n4. c\n5. d"]],
      note = "every list in the buffer, not only the one at the cursor",
    },
  },
}
