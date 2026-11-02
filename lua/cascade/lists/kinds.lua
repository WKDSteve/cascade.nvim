---@module 'cascade.lists.kinds'
--- Codec table of the ordered marker kinds (`digit`, `ascii`, `roman`).
---
--- One place that knows how a kind spells its token (`token_pat`), reads it as
--- an integer (`to_int`), writes an integer back (`to_token`) and whether its
--- letters carry a case. `lists/marker` (parse, advance), `lists/shape`
--- (value_of, token_for) and `sequence/renumber` (value_of, render) all go
--- through it, so a new ordered kind is one entry here instead of an
--- `if kind == ...` chain in each of them.
---
--- Pure: no Neovim API, no buffer access.

local roman = require("cascade.lists.roman")
local alpha = require("cascade.lists.alpha")

local M = {}

---@class CascadeKindCodec
---@field token_pat string                    # Lua pattern of one token, unanchored (`%d+`, `%a`, `%a+`)
---@field bare boolean                        # a bare marker (no space/text after the delimiter) still parses as this kind
---@field cased boolean                       # letters: lower/UPPER follows the reference token
---@field fallback string                     # token written when `to_token` has no spelling for the value
---@field to_int fun(tok: string): integer|nil  # validating read of a token (after `token_pat` matched)
---@field to_token fun(value: integer): string|nil  # spelling of a value (case is the caller's concern), nil when out of range

---Roman has no bare fallback: `%a+` would turn ordinary words that happen to
---be valid numerals ("Mix.", "Civ.") into list markers (see `marker.try_kind`).
---@type table<string, CascadeKindCodec>
M.CODECS = {
  digit = {
    token_pat = "%d+",
    bare = true,
    cased = false,
    fallback = "1",
    to_int = function(tok)
      return tonumber(tok)
    end,
    to_token = function(value)
      return tostring(value)
    end,
  },
  ascii = {
    token_pat = "%a",
    bare = true,
    cased = true,
    fallback = "a",
    to_int = alpha.to_int,
    to_token = alpha.to_alpha,
  },
  roman = {
    token_pat = "%a+",
    bare = false,
    cased = true,
    fallback = "i",
    to_int = roman.to_int,
    to_token = roman.to_roman,
  },
}

---The codec of `kind`, or nil for `unordered` and unknown kinds.
---@param kind string
---@return CascadeKindCodec|nil
function M.get(kind)
  return M.CODECS[kind]
end

---Integer value of `tok` read strictly as `kind`: the whole token has to have
---the kind's shape and (for roman) survive the round-trip validation.
---@param kind string
---@param tok string
---@return integer|nil
function M.parse_token(kind, tok)
  local codec = M.CODECS[kind]
  if codec and tok:match("^" .. codec.token_pat .. "$") then
    return codec.to_int(tok)
  end
  return nil
end

return M
