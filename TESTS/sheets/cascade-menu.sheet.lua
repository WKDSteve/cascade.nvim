-- Live check: the real right-click menu of ui.nvim (ui.menu) with cascade's fly-out (task
-- cascade.nvim/testblatt-bindings-checkliste; section 11 of ALL/manual-test-checklists/cascade.md).
return {
  id = "cascade.menu",
  feature = "cascade.menu",
  title = "cascade.nvim: the Cascade fly-out in ui.menu fires the actions; absent in .lua and with ui_menu = false",
  task = "cascade.nvim/manual-checklist-run",
  steps = {
    {
      lua = [[dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua"); _G.setup()
      -- As in the real config (lua/config/ui_statusline/init.lua): <RightMouse> at the pointer, a key at the cursor.
      require("ui").setup({ menu = { key = "<A-b>", prewarm = false } })
      _G.in_menu = function()
        return vim.api.nvim_win_get_config(0).relative ~= ""
      end
      ---The lines of the menu's window.
      _G.rows = function()
        return table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
      end
      ---Walks the menu's selection down to the row that holds `label`.
      _G.to = function(label)
        local rows = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        for _ = 1, #rows do
          local line = vim.api.nvim_get_current_line()
          if line:find(label, 1, true) then
            return true
          end
          vim.api.nvim_feedkeys("j", "mtx", false)
        end
        return false
      end]],
    },

    { lua = [[_G.fresh("markdown", "1. a", "5. b")]] },
    { lua = [[vim.api.nvim_input_mouse("right", "press", "", 0, 1, 2)]], note = "on the second row, on the list" },
    { wait = [[_G.in_menu() and _G.rows():find("Cascade", 1, true)]], note = "a real right click in a list buffer: the fly-out" },
    { keys = "<Esc>" },
    { wait = [[not _G.in_menu()]], note = "it closes" },

    { lua = [[_G.fresh("markdown", "- [ ] a")]] },
    { keys = "<A-b>" },
    { wait = [[_G.in_menu() and _G.to("Cascade")]] },
    { keys = "<CR>" },
    { wait = [[_G.in_menu() and _G.to("Toggle checkbox")]], note = "the drill-down holds the entry" },
    { keys = "<CR>" },
    { wait = [[not _G.in_menu() and _G.text() == "- [x] a"]], note = "Toggle checkbox: the action of its key" },

    { lua = [[_G.fresh("markdown", "* a")]] },
    { keys = "<A-b>" },
    { wait = [[_G.in_menu() and _G.to("Cascade")]] },
    { keys = "<CR>" },
    { wait = [[_G.in_menu() and _G.to("Cycle list marker type back")]], note = "the drill-down holds the entry" },
    { keys = "<CR>" },
    { wait = [[not _G.in_menu() and _G.text() == "- a"]], note = "Cycle list marker type back: the action of its key" },

    { lua = [[_G.fresh("markdown", "- a")]] },
    { keys = "<A-b>" },
    { wait = [[_G.in_menu() and _G.to("Cascade")]] },
    { keys = "<CR>" },
    { wait = [[_G.in_menu() and _G.to("Cycle list marker type")]], note = "the drill-down holds the entry" },
    { keys = "<CR>" },
    { wait = [[not _G.in_menu() and _G.text() == "* a"]], note = "Cycle list marker type: the action of its key" },

    { lua = [[_G.fresh("markdown", "1. a", "5. b")]] },
    { keys = "<A-b>" },
    { wait = [[_G.in_menu() and _G.to("Cascade")]] },
    { keys = "<CR>" },
    { wait = [[_G.in_menu() and _G.to("Renumber list")]], note = "the drill-down holds the entry" },
    { keys = "<CR>" },
    { wait = [[not _G.in_menu() and _G.text() == "1. a\n2. b"]], note = "Renumber list: the action of its key" },

    { lua = [[_G.fresh("markdown", "1. a")]] },
    { keys = "<A-b>" },
    { wait = [[_G.in_menu() and _G.to("Cascade")]] },
    { keys = "<CR>" },
    { wait = [[_G.in_menu() and _G.to("Rotate list form")]], note = "the drill-down holds the entry" },
    { keys = "<CR>" },
    { wait = [[not _G.in_menu() and _G.text() == "1. [ ] a"]], note = "Rotate list form: the action of its key" },

    { lua = [[_G.fresh("markdown", "- b", "- a")]] },
    { keys = "<A-b>" },
    { wait = [[_G.in_menu() and _G.to("Cascade")]] },
    { keys = "<CR>" },
    { wait = [[_G.in_menu() and _G.to("Sort list A-Z")]], note = "the drill-down holds the entry" },
    { keys = "<CR>" },
    { wait = [[not _G.in_menu() and _G.text() == "- a\n- b"]], note = "Sort list A-Z: the action of its key" },

    { lua = [[_G.fresh("markdown", "- a", "- b")]] },
    { keys = "<A-b>" },
    { wait = [[_G.in_menu() and _G.to("Cascade")]] },
    { keys = "<CR>" },
    { wait = [[_G.in_menu() and _G.to("Reverse list order")]], note = "the drill-down holds the entry" },
    { keys = "<CR>" },
    { wait = [[not _G.in_menu() and _G.text() == "- b\n- a"]], note = "Reverse list order: the action of its key" },

    { lua = [[_G.fresh("markdown", "- [ ] a")]] },
    { keys = "<A-b>" },
    { wait = [[_G.in_menu() and _G.to("Cascade")]] },
    { keys = "<CR>" },
    { wait = [[_G.in_menu() and _G.to("Strip checkboxes")]], note = "the drill-down holds the entry" },
    { keys = "<CR>" },
    { wait = [[not _G.in_menu() and _G.text() == "- a"]], note = "Strip checkboxes: the action of its key" },

    { lua = [[_G.fresh("lua", "local a")]] },
    { keys = "<A-b>" },
    { wait = [[_G.in_menu()]] },
    { expect = [[not _G.rows():find("Cascade", 1, true)]], note = "no fly-out in a .lua buffer" },
    { keys = "<Esc>" },
    { wait = [[not _G.in_menu()]] },

    { lua = [[_G.setup({ integrations = { ui_menu = false } }); _G.fresh("markdown", "- a")]], note = "the opt-out" },
    { keys = "<A-b>" },
    { wait = [[_G.in_menu()]] },
    { expect = [[not _G.rows():find("Cascade", 1, true)]], note = "integrations.ui_menu = false: no fly-out" },
    { keys = "<Esc>" },
    { wait = [[not _G.in_menu()]] },
    { expect = [[require("cascade.integrations.menu").enabled() == false]], note = "enabled() says so" },
    { expect = [[#require("cascade.integrations.menu").items() > 0]], note = "items() stays for any other host" },
  },
}
