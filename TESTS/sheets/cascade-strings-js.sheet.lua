-- Live check: the strings domain in a JavaScript file (task cascade.nvim/testblatt-bindings-checkliste; section 12 of
-- ALL/manual-test-checklists/cascade.md and :Cascade strings of the bindings checklist). Neovim bundles no JavaScript
-- parser: runs where one is installed (the private machine), a reported skip elsewhere (CI).
return {
  id = "cascade.strings-js",
  title = "cascade.nvim: a JavaScript literal follows its contents, :Cascade strings switches it",
  task = "cascade.nvim/testblatt-bindings-checkliste",
  requires = {
    {
      lua = [[(function()
        dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua")
        return _G.parser("javascript")
      end)()]],
      reason = "no Tree-sitter parser for javascript installed",
    },
  },
  steps = {
    { lua = [[_G.setup()]] },

    { lua = [[_G.file("js", 'const s = "hi "', '"')]] },
    { keys = "f a${name}<Esc>", note = "typed inside the quotes" },
    { wait = [[_G.text() == "const s = `hi ${name}`"]], note = "the quotes become backticks" },

    { keys = "u" },
    { expect = [[_G.text() == 'const s = "hi "']], note = "u takes back the edit and the conversion in one step" },

    { keys = "<C-r>" },
    { wait = [[_G.text() == "const s = `hi ${name}`"]] },
    { lua = [[vim.api.nvim_win_set_cursor(0, { 1, _G.text():find("$", 1, true) - 1 })]] },
    { keys = "df}" },
    { wait = [[_G.text() == 'const s = "hi "']], note = "the placeholder gone: the template turns back" },

    { lua = [[_G.file("js", 'const s = html`ab`', "b`")]] },
    { keys = "x" },
    { settle = 200 },
    { expect = [[_G.text() == "const s = html`a`"]], note = "a tagged template never turns back" },

    { lua = [[_G.file("js", 'const s = "ab"', "b")]] },
    { keys = "i<CR><Esc>", note = "a quoted string gains a newline" },
    { wait = [[_G.text() == "const s = `a\nb`"]], note = "and converts" },

    { lua = [[_G.file("js", 'const s = ""', '"')]] },
    { keys = "<Cmd>Cascade strings now<CR>" },
    { settle = 100 },
    { expect = [[_G.text() == 'const s = ""']], note = "an empty literal is left alone" },

    { lua = [[_G.file("js", 'const s = "' .. string.rep("a", 201) .. '"', "a")]] },
    { keys = "i${x}<Esc>" },
    { settle = 200 },
    { expect = [[_G.text():sub(11, 11) == '"']], note = "a literal over 200 characters is left alone" },

    {
      lua = [[_G.fresh("javascript", 'const s = "hi "'); vim.bo.buftype = "nofile"
      vim.api.nvim_win_set_cursor(0, { 1, 13 })]],
      note = "buftype=nofile, a scratch buffer",
    },
    { keys = "i${x}<Esc>" },
    { settle = 200 },
    { expect = [[_G.text():find('"', 1, true)]], note = "a scratch buffer never converts" },

    {
      lua = [[_G.other = (function()
        _G.file("js", 'const o = "hi "', '"')
        return vim.api.nvim_get_current_buf()
      end)()
      _G.file("js", 'const s = "hi "', '"')]],
    },
    { keys = ":Cascade strings off<CR>" },
    { keys = "f a${x}<Esc>" },
    { settle = 200 },
    { expect = [[_G.text() == 'const s = "hi ${x}"']], note = "off: typing no longer converts" },
    { keys = ":Cascade strings now<CR>" },
    { settle = 200 },
    { expect = [[_G.text() == 'const s = "hi ${x}"']], note = "and now is a no-op while off" },
    { lua = [[_G.this = vim.api.nvim_get_current_buf(); vim.api.nvim_set_current_buf(_G.other)]] },
    { keys = "f a${y}<Esc>" },
    { wait = [[_G.text() == "const o = `hi ${y}`"]], note = "other buffers still convert" },
    { lua = [[vim.api.nvim_set_current_buf(_G.this)]] },
    { keys = ":Cascade strings on<CR>" },
    { lua = [[vim.api.nvim_win_set_cursor(0, { 1, 12 })]] },
    { keys = ":Cascade strings now<CR>" },
    { wait = [[_G.text() == "const s = `hi ${x}`"]], note = "on, then now converts the literal at the cursor once" },

    { lua = [[_G.file("js", 'const t = "a"', 'a"')]] },
    { keys = ":Cascade strings toggle<CR>", note = "toggle: off" },
    { keys = "a${z}<Esc>" },
    { settle = 200 },
    { expect = [[_G.text() == 'const t = "a${z}"']], note = "typing does not convert" },
    { keys = ":Cascade strings toggle<CR>", note = "toggle: on again" },
    { keys = ":Cascade strings now<CR>" },
    { wait = [[_G.text() == "const t = `a${z}`"]], note = "now converts" },

    {
      lua = [[_G.setup({ strings = { on = {} } })
      _G.file("js", 'const m = "a"', 'a"')]],
      note = "strings.on = {}: the manual path",
    },
    { keys = "a${m}<Esc>" },
    { settle = 200 },
    { expect = [[_G.text() == 'const m = "a${m}"']], note = "no autocmd converts" },
    { keys = ":Cascade strings now<CR>" },
    { wait = [[_G.text() == "const m = `a${m}`"]], note = "only now does" },
  },
}
