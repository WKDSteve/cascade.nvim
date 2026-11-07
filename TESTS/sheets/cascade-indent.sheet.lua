-- Live check: indent and dedent, the count meanings (task cascade.nvim/testblatt-bindings-checkliste; section 3 of
-- ALL/manual-test-checklists/cascade.md, the bindings checklist's <A-Right>/<A-Left> in Insert mode).
return {
  id = "cascade.indent",
  title = "cascade.nvim: <A-Right>, <A-Left>, the count of lines against the count of levels",
  task = "cascade.nvim/manual-checklist-run",
  steps = {
    { lua = [[dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua"); _G.setup()]] },

    { lua = [[_G.fresh("markdown", "1. a", "2. b", "3. c", "4. d")]] },
    { keys = "j<A-Right>" },
    { expect = [[_G.text() == "1. a\n    1. b\n2. c\n3. d"]], note = "one line, one level: every level renumbers" },
    { keys = "<A-Left>" },
    { expect = [[_G.text() == "1. a\n2. b\n3. c\n4. d"]], note = "<A-Left> back" },

    { lua = [[_G.fresh("markdown", "1. a", "2. b", "3. c", "4. d")]] },
    { keys = "j2<A-Right>" },
    { expect = [[_G.text() == "1. a\n    1. b\n    2. c\n2. d"]], note = "the count is 2 lines, one level each" },

    { lua = [[_G.fresh("markdown", "1. a", "    1. b", "2. c")]] },
    { keys = "j2<leader><A-Right>" },
    { expect = [[_G.text() == "1. a\n            1. b\n2. c"]], note = "<leader>: the count is 2 levels, one line" },
    { keys = "2<leader><A-Left>" },
    { expect = [[_G.text() == "1. a\n    1. b\n2. c"]], note = "<leader><A-Left>: 2 levels back" },

    { lua = [[_G.fresh("markdown", "1. a", "2. b", "    1. child", "    wrapped", "3. c")]] },
    { keys = "j<A-Right>" },
    { expect = [[_G.text() == "1. a\n    1. b\n        1. child\n        wrapped\n2. c"]], note = "the subtree goes along" },

    { lua = [[_G.fresh("markdown", "- a")]] },
    {
      expect = [[vim.fn.maparg("<Tab>", "n") == "" and vim.fn.maparg("<S-Tab>", "n") == ""
        and vim.fn.maparg("<Tab>", "x") == "" and vim.fn.maparg("<S-Tab>", "x") == ""]],
      note = "<Tab> and <S-Tab> are not in the preset",
    },

    { lua = [[_G.fresh("lua", "1. a", "1. b"); vim.bo.expandtab = true; vim.bo.shiftwidth = 2]] },
    { keys = "<A-Right>" },
    { expect = [[_G.text() == "  1. a\n1. b"]], note = "outside a list filetype a plain >>" },
    { keys = "<A-Left>" },
    { expect = [[_G.text() == "1. a\n1. b"]], note = "and a plain <<, no renumbering" },

    { lua = [[_G.fresh("lua", "x"); vim.bo.expandtab = true; vim.bo.shiftwidth = 2]] },
    { keys = "A<A-Right><Esc>" },
    { expect = [[_G.text() == "  x"]], note = "<A-Right> in Insert mode is <C-t>" },
    { keys = "A<A-Left><Esc>" },
    { expect = [[_G.text() == "x"]], note = "<A-Left> in Insert mode is <C-d>" },
  },
}
