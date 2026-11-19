-- Live check: custom markers per filetype (lists.per_filetype_patterns) and the hanging indent of gq
-- (lists.continue.hanging_indent; docs/FEATURES/LISTS.md, "Custom per-filetype markers", "Hanging-indent formatting").
return {
  id = "cascade.markers",
  feature = "cascade.list-markers",
  title = "cascade.nvim: LaTeX's \\item continues like a bullet, and gq hangs a wrapped list item under its text",
  task = "cascade.nvim/performance-pruefung-luecken-schliessen-katalog-feature-shee",
  steps = {
    {
      lua = [[dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua")
        _G.setup({ lists = { per_filetype_patterns = { tex = { "^(\\item)%s+(.*)$" } } } })]],
    },

    { lua = [[_G.fresh("tex", "\\item first")]] },
    { keys = "A<CR>second<Esc>" },
    { expect = [[_G.text() == "\\item first\n\\item second"]], note = "<CR> continues a \\item" },
    { keys = "othird<Esc>" },
    { expect = [[_G.text() == "\\item first\n\\item second\n\\item third"]], note = "o continues it too" },
    { keys = "A<CR><CR><Esc>" },
    {
      expect = [[_G.text() == "\\item first\n\\item second\n\\item third\n"]],
      note = "<CR> on an empty \\item ends the list",
    },

    {
      lua = [[_G.fresh("markdown", "- " .. string.rep("word ", 12))
        vim.bo.textwidth = 30]],
    },
    { expect = [[vim.bo.formatoptions:find("n", 1, true) ~= nil]], note = "'formatoptions' has n in a list filetype" },
    { keys = "gqq" },
    {
      expect = [[(function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        if #lines < 2 or lines[1]:sub(1, 2) ~= "- " then
          return false
        end
        for i = 2, #lines do
          if lines[i]:sub(1, 2) ~= "  " or lines[i]:sub(3, 3) == " " then
            return false
          end
        end
        return true
      end)()]],
      note = "gq hangs the wrapped lines under the text, not back at the margin",
    },
  },
}
