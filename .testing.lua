-- .testing.lua -- configuration of testing.nvim for this project.
-- Written by `testing migrate`; edit freely (it is never overwritten). Every key is optional; the
-- keys are documented in testing.nvim's docs/CONFIG.md. Loading this file executes it (same trust
-- as running the specs).
return {
  -- Lua module root of the project.
  plugin = "cascade",
  -- How the spec files are run: "auto" = sniffed per file, "h" = on the project's own TESTS/harness.lua,
  -- "script" = a self-running script in its own process.
  dialect = { ["TESTS/sheets_spec.lua"] = "busted", ["*"] = "h" },
  -- Dependencies (directory names) put on the runtimepath: $<NAME>_DIR, .deps/<name>, ../<name>,
  -- stdpath('data')/lazy/<name>.
  deps = { "lib.nvim", "ui.nvim" },
  -- "none" = all specs in one nvim, "file" = one nvim per spec file
  -- (nothing leaks from one file into the next). "file" here because setup() leaves plugin-global
  -- state (autocmd groups, :Cascade, keymaps, 'operatorfunc') and the specs leave scratch buffers
  -- behind; in a one-case child that dies with the process instead of being a state finding.
  isolated = "file",
  -- All test sheets run in one spec file, one child editor each: the defaults of 10 s per case and 60 s per
  -- file are reached under load (fileops, 2026-11-07).
  timeouts = { case_ms = 30000, file_ms = 300000 },
  -- Guards (safety nets, see testing.nvim docs/GUARDS.md). The suite passes all of them cleanly
  -- (no file writes outside the temp dir, no processes, no network, no prompts), so all are errors.
  guards = {
    fs = "error",
    state = "error",
    scheduled_error = "error",
    prompt = "error",
    deprecation = "error",
    process_net = "error",
  },
  -- What the child editor of the test sheets needs; cascade.nvim itself neither writes files, starts processes nor
  -- opens connections.
  guard_allow = {
    fs = {},
    -- sheets_spec.lua: every test sheet (TESTS/sheets/) runs in a child editor.
    spawn = { "nvim" },
    network = {},
  },
  -- The runner counts which commands, keymaps and autocommands the specs exercise (docs/SURFACE.md of testing.nvim);
  -- `scripts/test.sh surface` compares that with surface.baseline.json (a regression gate, not a percentage).
  surface = { track = true },
  -- gated: a failed conformance check makes `scripts/test.sh conformance` exit 1 (docs/CONFORMANCE.md of testing.nvim)
  conformance = { gate = true },
  -- The pipeline is derived (`scripts/test.sh ci list`). The GitHub workflow is generated from `workflow`:
  -- `testing init --workflow=public --force` writes it (testing.nvim docs/WORKFLOW-CI.md), the step
  -- workflow-in-sync checks it.
  ci = {
    workflow = {
      name = "cascade.nvim",
      layout = "hosted",
      -- the steps that depend on the platform: the windows and macOS legs run only these
      platform = { "suite", "conformance" },
    },
    steps = {
      ["workflow-in-sync"] = { preset = "workflow-in-sync" },
    },
  },
}
