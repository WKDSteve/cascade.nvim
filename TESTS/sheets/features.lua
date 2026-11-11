-- TESTS/sheets/features.lua -- the functionalities of cascade.nvim as its user meets them; `testing sheets report`
-- says which ones have a feature sheet (`feature = "<id>"`) and in which state, and K16 warns about a sheet that names
-- an id not listed here. Data: read with an empty environment like a sheet (testing.nvim docs/SHEETS.md).
-- The list follows docs/FEATURES/ (README.md and its five domains) and ALL/manual-test-checklists/cascade.md.
return {
  {
    id = "cascade.list-continue",
    title = "<CR>, o and O continue a list item with the next marker, only in a list filetype",
    surface = { "binding:<CR>", "binding:o", "binding:O", "config:lists.filetypes" },
    docs = "docs/FEATURES/LISTS.md",
  },
  {
    id = "cascade.list-renumber",
    title = "A numbered list renumbers itself on an edit or a save, and by hand with <leader>cr",
    surface = { "binding:<leader>cr", "command:Cascade renumber" },
    docs = "docs/FEATURES/LISTS.md",
  },
  {
    id = "cascade.list-indent",
    title = "<A-Right> and <A-Left> indent and dedent a list item by level and renumber both levels",
    surface = { "binding:<A-Right>", "binding:<A-Left>", "command:Cascade indent", "command:Cascade dedent" },
    docs = "docs/FEATURES/LISTS.md",
  },
  {
    id = "cascade.list-move",
    title = "<A-Up> and <A-Down> move list lines and renumber the list they leave and enter",
    surface = { "binding:<A-Up>", "binding:<A-Down>" },
    docs = "docs/FEATURES/LISTS.md",
  },
  {
    id = "cascade.list-toggles",
    title = "One key adds or removes a bullet, a number or a checkbox, and ticks a checkbox, without a marker first",
    surface = { "binding:<A-->", "binding:<A-*>", "binding:<A-0>", "binding:<A-c>", "binding:<leader>cx" },
    docs = "docs/FEATURES/LISTS.md",
  },
  {
    id = "cascade.list-step",
    title = "<C-y> and <C-x> on a list marker step its number, letter or Roman numeral and the siblings after it",
    surface = { "binding:<C-y>", "binding:<C-x>", "config:lists.types" },
    docs = "docs/FEATURES/LISTS.md",
  },
  {
    id = "cascade.list-forms",
    title = "A list block or a selection changes its marker form, is sorted, reversed or stripped of its checkboxes",
    surface = { "command:Cascade rotate", "command:Cascade sort", "command:Cascade reverse", "command:Cascade strip" },
    docs = "docs/FEATURES/LISTS.md",
  },
  {
    id = "cascade.list-precision",
    title = 'With lists.precision = "treesitter" a list marker inside a code block is left alone',
    surface = { "config:lists.precision" },
    docs = "docs/FEATURES/LISTS.md",
  },
  {
    id = "cascade.list-markers",
    title = "Custom markers per filetype (LaTeX's \\item) continue like a bullet, and gq hangs a wrapped item",
    surface = { "config:lists.per_filetype_patterns", "config:lists.continue.hanging_indent" },
    docs = "docs/FEATURES/LISTS.md",
  },
  {
    id = "cascade.cycle",
    title = "<C-y>, <C-x>, + and - advance the word, boolean, number, date or operator under the cursor",
    surface = { "binding:<C-y>", "binding:<C-x>", "binding:+", "binding:-", "binding:<leader>cP" },
    docs = "docs/FEATURES/CYCLE.md",
  },
  {
    id = "cascade.cycle-groups",
    title = ":Cascade cycle add, list and remove change the cycle groups for the running session",
    surface = { "command:Cascade cycle", "config:cycle.groups" },
    docs = "docs/FEATURES/CYCLE.md",
  },
  {
    id = "cascade.sequence",
    title = "<leader>cR on a selection renumbers the ordinals in it, whatever precedes them (headlines, prose)",
    surface = { "binding:<leader>cR" },
    docs = "docs/FEATURES/SEQUENCE.md",
  },
  {
    id = "cascade.transpose",
    title = "A character, a word or a same-line selection swaps with its neighbour, UTF-8 safe",
    surface = { "binding:<leader><Right>", "binding:<leader><Left>", "binding:<leader><C-Right>" },
    docs = "docs/FEATURES/TRANSPOSE.md",
  },
  {
    id = "cascade.strings",
    title = "A string literal becomes a template string or an f-string when its contents ask for it, and back",
    surface = { "command:Cascade strings", "config:strings" },
    docs = "docs/FEATURES/STRINGS.md",
  },
  {
    id = "cascade.switches",
    title = "Every domain and feature switches off on its own, and :checkhealth says which are on",
    surface = { "config:lists.features" },
    docs = "docs/health.md",
  },
  {
    id = "cascade.menu",
    title = "The right-click menu has a Cascade fly-out with the list actions, only where lists apply",
    surface = { "config:integrations.ui_menu" },
    docs = "docs/integrations.md",
  },
  {
    id = "cascade.table-rows",
    title = "o and O on a Markdown table row insert a row through markdown.nvim instead of a bare line",
    docs = "docs/integrations.md",
  },
}
