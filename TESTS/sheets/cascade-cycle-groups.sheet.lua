-- Live check: :Cascade cycle add, list and remove change the cycle groups of the running session
-- (docs/FEATURES/CYCLE.md, "Runtime groups").
return {
  id = "cascade.cycle-groups",
  feature = "cascade.cycle-groups",
  title = "cascade.nvim: :Cascade cycle add, list and remove change what <C-y> cycles, for the running session",
  task = "cascade.nvim/performance-pruefung-luecken-schliessen-katalog-feature-shee",
  steps = {
    { lua = [[dofile(vim.fn.getcwd() .. "/TESTS/sheets/_helpers.lua"); _G.setup()]] },

    { lua = [[_G.fresh("lua", "zzalpha")]] },
    { keys = "<C-y>" },
    { expect = [[_G.text() == "zzalpha"]], note = "an unknown word does not cycle yet" },

    { keys = ":Cascade cycle add zzalpha,zzbeta,zzgamma<CR>" },
    { keys = "<C-y>" },
    { expect = [[_G.text() == "zzbeta"]], note = "after :Cascade cycle add the word advances" },
    { keys = "<C-y>" },
    { expect = [[_G.text() == "zzgamma"]], note = "and on to the third value" },
    { keys = "<C-y>" },
    { expect = [[_G.text() == "zzalpha"]], note = "and wraps around" },

    { keys = ":Cascade cycle add TODO, IN PROGRESS ,DONE<CR>" },
    { lua = [[_G.fresh("lua", "TODO")]] },
    { keys = "<C-y>" },
    { expect = [[_G.text() == "IN PROGRESS"]], note = "a value with a space, trimmed" },

    { keys = ":Cascade cycle list<CR>" },
    { expect = [[_G.noted("zzalpha -> zzbeta -> zzgamma")]], note = ":Cascade cycle list shows the added group" },
    { expect = [[_G.noted("TODO -> IN PROGRESS -> DONE")]], note = "and the one with spaces" },

    { keys = ":Cascade cycle remove zzbeta<CR>" },
    { lua = [[_G.fresh("lua", "zzalpha")]] },
    { keys = "<C-y>" },
    { expect = [[_G.text() == "zzalpha"]], note = "after :Cascade cycle remove the group is gone" },
  },
}
