-- Live check: <leader>cR renumbers the ordinals inside a selection, whatever precedes them
-- (docs/FEATURES/SEQUENCE.md).
return {
  id = "cascade.sequence",
  feature = "cascade.sequence",
  title = "cascade.nvim: <leader>cR renumbers numbered headlines and ordinals in prose, only inside the selection",
  task = "cascade.nvim/performance-pruefung-luecken-schliessen-katalog-feature-shee",
  steps = {
    { lua = [[dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua"); _G.setup()]] },

    {
      lua = [[_G.fresh("markdown", "### 7. keep me", "### 2. two", "prose in between", "### 3. sad", "### 9. more",
        "### 4. keep me too")
        vim.api.nvim_win_set_cursor(0, { 2, 0 })]],
    },
    { keys = "Vjjj<leader>cR" },
    {
      expect = [[_G.text() == "### 7. keep me\n### 2. two\nprose in between\n### 3. sad\n### 4. more\n### 4. keep me too"]],
      note = "numbered headlines: the first hit sets the start, the lines outside stay",
    },

    { lua = [[_G.fresh("text", "text with only a 4. item and a 5. sample and 9. more")]] },
    { keys = "V<leader>cR" },
    {
      expect = [[_G.text() == "text with only a 4. item and a 5. sample and 6. more"]],
      note = "ordinals in the middle of prose",
    },

    { lua = [[_G.fresh("lua", "-- 3. one, 3.14 is pi, e.g. this, 8. two")]] },
    { keys = "V<leader>cR" },
    {
      expect = [[_G.text() == "-- 3. one, 3.14 is pi, e.g. this, 4. two"]],
      note = "in any filetype; decimals and abbreviations are no ordinals",
    },
  },
}
