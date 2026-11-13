-- TESTS/run.lua — headless test runner for cascade.nvim.
--
-- Run from the repo root:
--   nvim -n -i NONE --headless -u NONE -c "set rtp+=." -c "luafile TESTS/run.lua" -c "qa!"
-- or:
--   nvim -n -i NONE --headless -u NONE -c "set rtp+=." -l TESTS/run.lua
--
-- Legacy runner: the suite is run by testing.nvim (`bash scripts/test.sh`),
-- which discovers the specs itself and reads the list below only as an order
-- hint and for the sentinel. This file runs only the specs in that fixed list
-- (not sheets_spec.lua, which is busted style), each against the shared
-- harness, prints a per-spec result and exits non-zero if any spec failed.

local dir = debug.getinfo(1, "S").source:sub(2):match("(.*[/\\])") or "./"
local H = dofile(dir .. "harness.lua")

-- Ordered so failures point at the smallest layer first: pure units, then the
-- feature modules, then the facade, then the wiring (bindings/commands/menu)
-- and finally health, which reads the config every layer above it wrote.
local specs = {
  "units_spec.lua",
  "kinds_spec.lua",
  "shift_spec.lua",
  "lib_fallbacks_spec.lua",
  "packs_spec.lua",
  "shape_cycle_type_spec.lua",
  "dispatch_move_spec.lua",
  "lists_spec.lua",
  "cycle_spec.lua",
  "transpose_spec.lua",
  "sequence_spec.lua",
  "strings_spec.lua",
  "multibyte_spec.lua",
  "facade_spec.lua",
  "commands_spec.lua",
  "bindings_spec.lua",
  "usrcmds_spec.lua",
  "usrcmds_help_spec.lua",
  "menu_spec.lua",
  "lib_util_spec.lua",
  "health_spec.lua",
}

local failed = 0
for _, name in ipairs(specs) do
  -- A spec that fails to LOAD (syntax error, a top-level require of a moved
  -- module) must count as a failure exactly like one that fails to assert --
  -- dofile() itself needs the same pcall as running it, or the whole loop
  -- aborts uncaught and `-c "qa!"` still exits 0 with nothing having run.
  local ok, run_or_err = pcall(dofile, dir .. name)
  if ok then
    ok, run_or_err = pcall(run_or_err, H)
  end
  if ok then
    print(("ok    %s"):format(name))
  else
    failed = failed + 1
    print(("FAIL  %s\n      %s"):format(name, tostring(run_or_err)))
  end
end

if failed > 0 then
  print(("\n%d spec(s) failed"):format(failed))
  os.exit(1)
end

print("\nCASCADE_TESTS_OK")
