-- Live check: list continuation (task cascade.nvim/testblatt-bindings-checkliste; section 1 of
-- ALL/manual-test-checklists/cascade.md). The keys are typed in a real child editor; the buffer is the verdict.
return {
  id = "cascade.continue",
  title = "cascade.nvim: <CR>, <M-CR>, o and O continue a list, only in a list filetype",
  task = "cascade.nvim/testblatt-bindings-checkliste",
  steps = {
    { lua = [[dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua"); _G.setup()]], note = "the options of the real config" },

    { lua = [[_G.fresh("markdown", "- one")]] },
    { keys = "A<CR>two<Esc>" },
    { expect = [[_G.text() == "- one\n- two"]], note = "<CR> continues the bullet" },

    { lua = [[_G.fresh("markdown", "1. one")]] },
    { keys = "A<CR>two<Esc>" },
    { expect = [[_G.text() == "1. one\n2. two"]], note = "<CR> increments the number" },

    { lua = [[_G.fresh("markdown", "- one", "- ")]] },
    { keys = "GA<CR><Esc>" },
    { expect = [[_G.text() == "- one\n"]], note = "<CR> on an empty bullet deletes the marker and ends the list" },

    { lua = [[_G.fresh("markdown", "- one")]] },
    { keys = "A<M-CR>two<Esc>" },
    { expect = [[_G.text() == "- one\ntwo"]], note = "<M-CR> is a plain newline" },

    { lua = [[_G.fresh("markdown", "- one")]] },
    { keys = "otwo<Esc>" },
    { expect = [[_G.text() == "- one\n- two"]], note = "o opens an item below" },
    { lua = [[_G.fresh("markdown", "- one")]] },
    { keys = "Ozero<Esc>" },
    { expect = [[_G.text() == "- zero\n- one"]], note = "O opens an item above" },
    { lua = [[_G.fresh("markdown", "- one", "prose")]] },
    { keys = "jOnew<Esc>" },
    { expect = [[_G.text() == "- one\n- new\nprose"]], note = "O directly below a bullet, on a non-list line, opens an item" },

    { lua = [[_G.fresh("markdown", "prose")]] },
    { keys = "otwo<Esc>" },
    { expect = [[_G.text() == "prose\ntwo"]], note = "o on a non-list line: the native o, before the keys after it" },
    { lua = [[_G.fresh("markdown", "prose")]] },
    { keys = "A<CR>two<Esc>" },
    { expect = [[_G.text() == "prose\ntwo"]], note = "<CR> on a non-list line: the native <CR>, before the keys after it" },

    { lua = [[_G.fresh("lua", "-- - note")]] },
    {
      expect = [[vim.fn.maparg("<CR>", "i") == "" and vim.fn.maparg("o", "n") == ""]],
      note = "nothing bound outside a list filetype",
    },
    { keys = "A<CR>x<Esc>" },
    {
      expect = [[vim.api.nvim_buf_get_lines(0, 1, 2, false)[1]:find("- x", 1, true) ~= 1]],
      note = "no bullet in a code comment",
    },
  },
}
