-- TESTS/config_unknown_spec.lua — an unknown option is reported with a did-you-mean hint
-- (the hint comes from lib.lua.config.schema.describe_unknown).

return function(H)
  local config = require("cascade.config")

  config.setup({ lists = { checkbox = { staets = true } }, debgu = true })
  local text = table.concat(config.issues(), "\n")
  H.ok(text:find("unknown option 'debgu' (did you mean 'debug'?)", 1, true), "root typo: " .. text)
  H.ok(
    text:find("unknown option 'lists.checkbox.staets' (did you mean 'lists.checkbox.states'?)", 1, true),
    "nested typo keeps its full path: " .. text
  )

  config.setup({ zzzzzzzzzz = 1 })
  H.eq(config.issues()[1], "unknown option 'zzzzzzzzzz'", "a key with no near neighbour gets no hint")

  config.setup({})
  H.eq(#config.issues(), 0, "a clean setup() clears the issues")
end
