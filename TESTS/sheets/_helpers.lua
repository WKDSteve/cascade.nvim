-- TESTS/sheets/_helpers.lua -- what the cascade.nvim test sheets need in their child editor. Not a sheet
-- (`testing.sheet` only reads *.sheet.lua); a sheet's first step runs it with `dofile`, the child's cwd is the
-- project root. The directory is in the spec's @cache-inputs, so a change here re-runs the sheets.

vim.opt.shortmess:append("I")
vim.o.swapfile = false
vim.o.hidden = true
-- As in the real config: a leader the checklist's keys can be read with.
vim.g.mapleader = " "

-- Every notification, for the steps that look at the wording.
_G.notes = {}
vim.notify = function(msg)
  _G.notes[#_G.notes + 1] = tostring(msg)
end

---Whether a notification so far holds `text` (plain).
---@param text string
---@return boolean
function _G.noted(text)
  return table.concat(_G.notes, "\n"):find(text, 1, true) ~= nil
end

---cascade.nvim with the options of the real config (lua/plugins/personal/specs/edit.lua of the nvim config).
---@param extra? table
function _G.setup(extra)
  local opts = { keymaps = { preset = true, globals = { cycle_pick = "<leader>cP" }, list = { sort = "<leader>cS" } } }
  require("cascade").setup(vim.tbl_deep_extend("force", opts, extra or {}))
end

---The current buffer as one string, lines joined by a newline.
---@return string
function _G.text()
  return table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
end

---A new unnamed buffer of filetype `ft` holding the given lines, the cursor on the first one.
---@param ft string
---@param ... string
function _G.fresh(ft, ...)
  vim.cmd("enew!")
  vim.bo.filetype = ft
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { ... })
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
end

---A new real file (below the child's sandboxed temp dir) with the extension `ext`, holding `line`, saved, the cursor
---on the first occurrence of `at` in it.
---@param ext string
---@param line string
---@param at? string
function _G.file(ext, line, at)
  vim.cmd("edit " .. vim.fn.fnameescape(vim.fn.tempname() .. "." .. ext))
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { line })
  vim.cmd("silent write")
  vim.api.nvim_win_set_cursor(0, { 1, at and (line:find(at, 1, true) - 1) or 0 })
end

---Puts the parser of `lang` on the runtimepath of this child when the machine has one installed: the child's stdpath
---is a sandbox, so nothing of the real editor's data directory is visible by itself. Neovim bundles no parser for
---JavaScript or Python, so without an installed one a sheet of the strings domain is a reported skip.
---@param lang string
---@return boolean
function _G.parser(lang)
  local home = vim.fs.normalize(vim.uv.os_homedir())
  for _, site in ipairs({ home .. "/AppData/Local/nvim-data/site", home .. "/.local/share/nvim/site" }) do
    if #vim.fn.glob(site .. "/parser/" .. lang .. ".*", true, true) > 0 then
      vim.opt.rtp:append(site)
    end
  end
  return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) > 0
end
