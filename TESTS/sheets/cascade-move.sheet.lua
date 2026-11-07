-- Live check: moving lines (task cascade.nvim/testblatt-bindings-checkliste; section 4 of
-- ALL/manual-test-checklists/cascade.md, the bindings checklist's <A-Up>/<A-Down> in all three modes).
return {
  id = "cascade.move",
  title = "cascade.nvim: <A-Up> and <A-Down> move and renumber, with a count, a selection, in Insert mode",
  task = "cascade.nvim/manual-checklist-run",
  steps = {
    { lua = [[dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua"); _G.setup()]] },

    { lua = [[_G.fresh("markdown", "1. a", "2. b", "3. c")]] },
    { keys = "<A-Down>" },
    { expect = [[_G.text() == "1. b\n2. a\n3. c"]], note = "the line moves and the list renumbers in one step" },
    { expect = [[vim.fn.line(".") == 2]], note = "the cursor goes along" },
    { keys = "<A-Up>" },
    { expect = [[_G.text() == "1. a\n2. b\n3. c"]], note = "<A-Up> back" },

    { lua = [[_G.fresh("markdown", "1. a", "2. b", "3. c", "4. d", "5. e")]] },
    { keys = "3<A-Down>" },
    { expect = [[_G.text() == "1. b\n2. c\n3. d\n4. a\n5. e"]], note = "3 lines, one at a time, clean numbers" },
    { keys = "9<A-Down>" },
    { expect = [[_G.text() == "1. b\n2. c\n3. d\n4. e\n5. a"]], note = "stops at the buffer edge, no error" },
    { expect = [[vim.fn.line(".") == 5]] },

    { lua = [[_G.fresh("markdown", "1. a", "2. b", "3. c", "4. d")]] },
    { keys = "Vj<A-Down><Esc>" },
    { expect = [[_G.text() == "1. c\n2. a\n3. b\n4. d"]], note = "Visual: the block moves together" },
    { keys = "GkVk<A-Up><Esc>" },
    { expect = [[_G.text() == "1. a\n2. b\n3. c\n4. d"]], note = "and up again" },
    { keys = "ggVj<A-Up><Esc>", note = "a selection at the top: nothing above it" },
    { expect = [[_G.text() == "1. a\n2. b\n3. c\n4. d"]] },

    { lua = [[_G.fresh("lua", "local a", "local b", "local c")]] },
    { keys = "<A-Down>" },
    { expect = [[_G.text() == "local b\nlocal a\nlocal c"]], note = "outside a list a plain :move" },
    { lua = [[_G.fresh("markdown", "prose a", "prose b")]] },
    { keys = "<A-Down>" },
    { expect = [[_G.text() == "prose b\nprose a"]], note = "plain prose in a list filetype too" },

    { lua = [[_G.fresh("lua", "local a", "local b", "local c")]] },
    { keys = "jA<A-Up><Esc>" },
    { expect = [[_G.text() == "local b\nlocal a\nlocal c"]], note = "<A-Up> in Insert mode" },
    { keys = "A<A-Down><Esc>" },
    { expect = [[_G.text() == "local a\nlocal b\nlocal c"]], note = "<A-Down> in Insert mode" },
  },
}
