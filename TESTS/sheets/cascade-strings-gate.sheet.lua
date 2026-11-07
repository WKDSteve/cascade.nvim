-- Live check: where the strings domain does not act, with what a machine has by default (task
-- cascade.nvim/testblatt-bindings-checkliste; section 12 of ALL/manual-test-checklists/cascade.md).
return {
  id = "cascade.strings-gate",
  title = "cascade.nvim: no conversion in a .lua or Markdown file",
  task = "cascade.nvim/testblatt-bindings-checkliste",
  steps = {
    { lua = [[dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua"); _G.setup()]] },

    { lua = [[_G.file("lua", 'local s = "%s ${x} {y}"', "%s")]] },
    { keys = "ix<Esc>" },
    { settle = 200 },
    { expect = [[_G.text() == 'local s = "x%s ${x} {y}"']], note = "a .lua file: lua_format is off by default" },

    { lua = [[_G.file("md", 'a "%s ${x} {y}" b', "%s")]] },
    { keys = "ix<Esc>" },
    { settle = 200 },
    { expect = [[_G.text() == 'a "x%s ${x} {y}" b']], note = "a Markdown file" },
  },
}
