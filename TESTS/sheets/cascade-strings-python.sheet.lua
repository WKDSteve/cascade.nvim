-- Live check: the strings domain in a Python file (task cascade.nvim/testblatt-bindings-checkliste; section 12 of
-- ALL/manual-test-checklists/cascade.md). Neovim bundles no Python parser: runs where one is installed (the private
-- machine), a reported skip elsewhere (CI).
return {
  id = "cascade.strings-python",
  title = "cascade.nvim: a Python literal follows its contents",
  task = "cascade.nvim/testblatt-bindings-checkliste",
  requires = {
    {
      lua = [[(function()
        dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua")
        return _G.parser("python")
      end)()]],
      reason = "no Tree-sitter parser for python installed",
    },
  },
  steps = {
    { lua = [[_G.setup()]] },

    { lua = [[_G.file("py", 'msg = "hello "', '"')]] },
    { keys = "f a{name}<Esc>" },
    { wait = [[_G.text() == 'msg = f"hello {name}"']], note = "the literal gets its f" },

    { keys = "u" },
    { expect = [[_G.text() == 'msg = "hello "']], note = "u takes back the edit and the conversion in one step" },

    { keys = "<C-r>" },
    { wait = [[_G.text() == 'msg = f"hello {name}"']] },
    { lua = [[vim.api.nvim_win_set_cursor(0, { 1, _G.text():find("{", 1, true) - 1 })]] },
    { keys = "df}" },
    { wait = [[_G.text() == 'msg = "hello "']], note = "the last placeholder gone: the f goes" },

    { lua = [[_G.file("py", 'a = "a"', 'a"')]] },
    { keys = "a{}<Esc>" },
    { settle = 200 },
    { expect = [[_G.text() == 'a = "a{}"']], note = '"{}" does not convert' },
    { lua = [[_G.file("py", 'a = "a"', 'a"')]] },
    { keys = "a{0}<Esc>" },
    { settle = 200 },
    { expect = [[_G.text() == 'a = "a{0}"']], note = '"{0}" does not convert' },
    { lua = [[_G.file("py", 'a = "a"', 'a"')]] },
    { keys = "a{, }<Esc>" },
    { settle = 200 },
    { expect = [[_G.text() == 'a = "a{, }"']], note = '"{, }" does not convert' },
    { lua = [[_G.file("py", 'a = t"hello "', "o ")]] },
    { keys = "a{name}<Esc>" },
    { settle = 200 },
    { expect = [[_G.text() == 'a = t"hello{name} "']], note = 't"..." is left alone' },
  },
}
