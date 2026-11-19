-- Live check: o and O on a Markdown table row together with the real markdown.nvim (docs/integrations.md); the
-- stand-in version of this is cascade-table-rows.sheet.lua. markdown.nvim is no dependency of the suite: runs where a
-- checkout is found ($MARKDOWN_NVIM_DIR, beside $LIB_NVIM_DIR, ../markdown.nvim; the child sees only the *_DIR of the
-- environment), a reported skip elsewhere (CI).
return {
  id = "cascade.table-rows-markdown",
  title = "cascade.nvim: o and O on a Markdown table row insert a row through the real markdown.nvim",
  task = "cascade.nvim/performance-pruefung-luecken-schliessen-katalog-feature-shee",
  requires = {
    {
      lua = [[(function()
        dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua")
        local lib = vim.env.LIB_NVIM_DIR
        local candidates = {
          vim.env.MARKDOWN_NVIM_DIR or "",
          lib and (vim.fs.dirname(vim.fs.normalize(lib)) .. "/markdown.nvim") or "",
          vim.fn.getcwd() .. "/../markdown.nvim",
        }
        for _, dir in ipairs(candidates) do
          if dir ~= "" and vim.uv.fs_stat(dir .. "/lua/markdown/core/table_mode.lua") then
            vim.opt.rtp:append(vim.fs.normalize(dir))
            return pcall(require, "markdown.core.table_mode")
          end
        end
        return false
      end)()]],
      reason = "no markdown.nvim checkout found",
    },
  },
  steps = {
    { lua = [[_G.setup()]] },

    { lua = [[_G.fresh("markdown", "| a | b |", "|---|---|", "| 1 | 2 |"); vim.api.nvim_win_set_cursor(0, { 3, 0 })]] },
    { keys = "o<Esc>" },
    {
      expect = [[(function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        return #lines == 4 and lines[3] == "| 1 | 2 |" and lines[4]:match("^|.*|.*|%s*$") ~= nil
      end)()]],
      note = "o on a data row: markdown.nvim inserts an empty row below",
    },
    { lua = [[vim.api.nvim_win_set_cursor(0, { 3, 0 })]] },
    { keys = "O<Esc>" },
    {
      expect = [[(function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        return #lines == 5 and lines[3]:match("^|.*|.*|%s*$") ~= nil and lines[4] == "| 1 | 2 |"
      end)()]],
      note = "O on a data row: an empty row above",
    },

    { lua = [[_G.fresh("markdown", "- item")]] },
    { keys = "onext<Esc>" },
    { expect = [[_G.text() == "- item\n- next"]], note = "a list item still continues as a list item" },
  },
}
