-- Live check: rotate, sort, reverse, strip, on the block and on a selection (task
-- cascade.nvim/testblatt-bindings-checkliste; section 8 of ALL/manual-test-checklists/cascade.md).
return {
  id = "cascade.forms",
  title = "cascade.nvim: <leader>cl, <leader>cL, :Cascade! rotate, <leader>cS, <leader>cv, <leader>cX",
  task = "cascade.nvim/testblatt-bindings-checkliste",
  steps = {
    { lua = [[dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua"); _G.setup()]] },

    { lua = [[_G.fresh("markdown", "1. a", "2. b")]] },
    { keys = "<leader>cl" },
    { expect = [[_G.text() == "1. [ ] a\n2. [ ] b"]], note = "1. to 1. [ ]" },
    { lua = [[vim.api.nvim_buf_set_lines(0, 0, 1, false, { "1. [x] a" })]], note = "a state to keep" },
    { keys = "<leader>cl" },
    { expect = [[_G.text() == "- [x] a\n- [ ] b"]], note = "to - [ ], the [x] kept" },
    { keys = "<leader>cl" },
    { expect = [[_G.text() == "- a\n- b"]], note = "to -" },
    { keys = "<leader>cl" },
    { expect = [[_G.text() == "1. a\n2. b"]], note = "and round, numbered" },
    { keys = "<leader>cL" },
    { expect = [[_G.text() == "- a\n- b"]], note = "<leader>cL backward" },
    { keys = ":Cascade rotate<CR>" },
    { expect = [[_G.text() == "1. a\n2. b"]], note = ":Cascade rotate forward" },
    { keys = ":Cascade! rotate<CR>" },
    { expect = [[_G.text() == "- a\n- b"]], note = ":Cascade! rotate backward, like <leader>cL" },
    {
      expect = [[vim.fn.maparg("<leader>cf", "n") == "" and vim.fn.maparg("<leader>cF", "n") == ""]],
      note = "<leader>cf and <leader>cF do not rotate any more",
    },
    { keys = ":Cascade rotate!<CR>", ignore_errmsg = true, note = "the bang on the subcommand" },
    { expect = [[_G.noted("rotate!") and _G.text() == "- a\n- b"]], note = "is refused by name, not a rotation" },

    { lua = [[_G.fresh("markdown", "3. pear", "1. apple", "2. fig")]] },
    { keys = "<leader>cS" },
    { expect = [[_G.text() == "1. apple\n2. fig\n3. pear"]], note = "<leader>cS sorts A-Z and renumbers" },
    { keys = ":Cascade! sort<CR>" },
    { expect = [[_G.text() == "1. pear\n2. fig\n3. apple"]], note = ":Cascade! sort is Z-A" },
    { expect = [[vim.fn.maparg("<leader>cs", "n") == ""]], note = "the default <leader>cs is free in this config" },

    { lua = [[_G.fresh("markdown", "1. a", "2. b", "3. c")]] },
    { keys = "<leader>cv" },
    { expect = [[_G.text() == "1. c\n2. b\n3. a"]], note = "<leader>cv reverses and renumbers" },

    { lua = [[_G.fresh("markdown", "- [ ] a", "- [x] b", "1. [~] c")]] },
    { keys = "<leader>cX" },
    { expect = [[_G.text() == "- a\n- b\n1. c"]], note = "<leader>cX strips, the markers stay" },

    { lua = [[_G.fresh("markdown", "- a", "- b", "- c", "- d")]] },
    { keys = "jVj<leader>cl<Esc>" },
    { expect = [[_G.text() == "- a\n1. b\n2. c\n- d"]], note = "<leader>cl on a selection: only those lines" },
    { keys = "gv<leader>cL<Esc>" },
    { expect = [[_G.text() == "- a\n- b\n- c\n- d"]], note = "<leader>cL on a selection" },

    { lua = [[_G.fresh("markdown", "- z", "- c", "- b", "- a")]] },
    { keys = "jVj<leader>cS<Esc>" },
    { expect = [[_G.text() == "- z\n- b\n- c\n- a"]], note = "<leader>cS on a selection" },
    { lua = [[_G.fresh("markdown", "- z", "- b", "- c", "- a")]] },
    { keys = "jVj<leader>cv<Esc>" },
    { expect = [[_G.text() == "- z\n- c\n- b\n- a"]], note = "<leader>cv on a selection" },
    { lua = [[_G.fresh("markdown", "- [ ] a", "- [ ] b", "- [ ] c")]] },
    { keys = "Vj<leader>cX<Esc>" },
    { expect = [[_G.text() == "- a\n- b\n- [ ] c"]], note = "<leader>cX on a selection" },
  },
}
