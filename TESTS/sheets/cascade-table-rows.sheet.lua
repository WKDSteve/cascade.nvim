-- Live check: o and O on a Markdown table row hand the row to markdown.nvim (docs/integrations.md). markdown.nvim is
-- no dependency of this suite: its `markdown.core.table_mode` is a stand-in that records the call and inserts a bare
-- row, so the sheet checks cascade's side (which line goes to it, in which direction, and that a list line or a plain
-- line does not). The row markdown.nvim itself builds is checked by markdown.nvim's own specs.
return {
  id = "cascade.table-rows",
  feature = "cascade.table-rows",
  title = "cascade.nvim: o and O on a Markdown table row go to markdown.nvim, a list item still continues",
  task = "cascade.nvim/performance-pruefung-luecken-schliessen-katalog-feature-shee",
  steps = {
    {
      lua = [[dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua")
        _G.rows = {}
        package.loaded["markdown.core.table_mode"] = {
          insert_row = function(bufnr, row0, direction)
            local line = vim.api.nvim_buf_get_lines(bufnr, row0, row0 + 1, false)[1] or ""
            if not line:match("^%s*|") or line:match("^%s*|[%s%-:|]+$") then
              return false
            end
            _G.rows[#_G.rows + 1] = { row0, direction }
            local at = direction == "below" and row0 + 1 or row0
            vim.api.nvim_buf_set_lines(bufnr, at, at, false, { "|  |  |" })
            return true
          end,
        }
        _G.setup()]],
    },

    { lua = [[_G.fresh("markdown", "| a | b |", "|---|---|", "| 1 | 2 |"); vim.api.nvim_win_set_cursor(0, { 3, 0 })]] },
    { keys = "o<Esc>" },
    { expect = [[#_G.rows == 1 and _G.rows[1][1] == 2 and _G.rows[1][2] == "below"]], note = "o on a data row" },
    { expect = [[_G.text() == "| a | b |\n|---|---|\n| 1 | 2 |\n|  |  |"]], note = "the new row lands below" },
    { lua = [[vim.api.nvim_win_set_cursor(0, { 3, 0 })]] },
    { keys = "O<Esc>" },
    { expect = [[#_G.rows == 2 and _G.rows[2][1] == 2 and _G.rows[2][2] == "above"]], note = "O on a data row" },

    { lua = [[_G.fresh("markdown", "- item")]] },
    { keys = "onext<Esc>" },
    { expect = [[_G.text() == "- item\n- next" and #_G.rows == 2]], note = "a list item continues, no table call" },

    { lua = [[_G.fresh("lua", "| a | b |")]] },
    { keys = "ox<Esc>" },
    { expect = [[_G.text() == "| a | b |\nx" and #_G.rows == 2]], note = "outside Markdown o stays native" },
  },
}
