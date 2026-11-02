-- TESTS/kinds_spec.lua — `lists/kinds.lua`, the codec table behind marker
-- parsing, advancing, shape values and sequence renumbering. The behaviour of
-- the callers is pinned by lists_spec / shape_cycle_type_spec / sequence_spec;
-- this file pins the table itself, so a new kind's entry is checked on its own.

return function(H)
  local eq = H.eq
  local kinds = require("cascade.lists.kinds")

  -- every ordered kind has a complete codec ----------------------------------
  for _, name in ipairs({ "digit", "ascii", "roman" }) do
    local c = kinds.get(name)
    H.ok(c ~= nil, name .. ": has a codec")
    eq(type(c.token_pat), "string", name .. ": token_pat")
    eq(type(c.to_int), "function", name .. ": to_int")
    eq(type(c.to_token), "function", name .. ": to_token")
    eq(type(c.fallback), "string", name .. ": fallback")
    -- the round trip the callers rely on
    eq(c.to_int(c.to_token(4)), 4, name .. ": to_int(to_token(4)) == 4")
  end
  eq(kinds.get("unordered"), nil, "unordered has no codec")
  eq(kinds.get("nonsense"), nil, "an unknown kind has no codec")

  -- bare-marker policy: roman must not parse a bare "Mix." ------------------
  eq(kinds.get("digit").bare, true, "digit may be bare")
  eq(kinds.get("ascii").bare, true, "ascii may be bare")
  eq(kinds.get("roman").bare, false, "roman may not be bare")

  -- case: only letter kinds carry one ---------------------------------------
  eq(kinds.get("digit").cased, false, "digit is uncased")
  eq(kinds.get("ascii").cased, true, "ascii is cased")
  eq(kinds.get("roman").cased, true, "roman is cased")

  -- parse_token: whole-token shape plus validation ---------------------------
  eq(kinds.parse_token("digit", "12"), 12, "digit: 12")
  eq(kinds.parse_token("digit", "1a"), nil, "digit: mixed token rejected")
  eq(kinds.parse_token("ascii", "c"), 3, "ascii: c")
  eq(kinds.parse_token("ascii", "C"), 3, "ascii: C (any case)")
  eq(kinds.parse_token("ascii", "ab"), nil, "ascii: single letter only")
  eq(kinds.parse_token("roman", "iv"), 4, "roman: iv")
  eq(kinds.parse_token("roman", "IV"), 4, "roman: IV")
  eq(kinds.parse_token("roman", "so"), nil, "roman: a word that is no numeral")
  eq(kinds.parse_token("roman", "4"), nil, "roman: digits rejected")
  eq(kinds.parse_token("unordered", "-"), nil, "unordered: no parse")

  -- spelling ------------------------------------------------------------------
  eq(kinds.get("roman").to_token(9):lower(), "ix", "roman: 9 -> ix (case is the caller's concern)")
  eq(kinds.get("ascii").to_token(27), "aa", "ascii: 27 -> aa")
  eq(kinds.get("digit").to_token(10), "10", "digit: 10")
  eq(kinds.get("roman").to_token(0), nil, "roman: 0 has no spelling")
end
