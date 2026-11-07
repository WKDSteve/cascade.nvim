-- Live check: the :Cascade surface (task cascade.nvim/testblatt-bindings-checkliste; section 9 of
-- ALL/manual-test-checklists/cascade.md).
return {
  id = "cascade.command",
  title = "cascade.nvim: :Cascade completes, takes levels and a range, ignores a bang it has no use for",
  task = "cascade.nvim/testblatt-bindings-checkliste",
  steps = {
    { lua = [[dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua"); _G.setup()]] },

    {
      expect = [[(function()
        local got = vim.fn.getcompletion("Cascade ", "cmdline")
        for _, want in ipairs({ "cycle", "rotate", "sort", "reverse", "strip", "indent", "dedent", "renumber", "strings" }) do
          if not vim.tbl_contains(got, want) then
            return false
          end
        end
        return true
      end)()]],
      note = "the subcommands are completed",
    },
    {
      keys = [[:Cascade st<Tab><C-\>e[execute('let g:typed = getcmdline()'), ''][1]<CR><C-c>]],
      ignore_errmsg = true,
      note = "<Tab> on the command line itself, read back from there",
    },
    { expect = [[vim.g.typed == "Cascade strip" or vim.g.typed == "Cascade strings"]], note = "<Tab> fills in a subcommand" },

    { lua = [[_G.fresh("markdown", "1. a", "2. b", "3. c")]] },
    { keys = "VG:Cascade indent 2<CR>" },
    {
      expect = [[_G.text() == "        1. a\n        2. b\n        3. c"]],
      note = ":Cascade indent 2 on a Visual range: 2 levels",
    },
    { keys = "VG:Cascade dedent 2<CR>" },
    { expect = [[_G.text() == "1. a\n2. b\n3. c"]], note = ":Cascade dedent 2" },

    { lua = [[_G.fresh("markdown", "- [ ] a", "- [x] b")]] },
    { keys = ":Cascade! strip<CR>" },
    { expect = [[_G.text() == "- a\n- b"]], note = "a bang on strip is ignored, no error" },
    { lua = [[_G.fresh("markdown", "- a", "- b")]] },
    { keys = ":Cascade! indent<CR>" },
    { expect = [[_G.text() == "    - a\n- b"]], note = "a bang on indent too" },
  },
}
