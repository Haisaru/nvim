local ls_status_ok, ls = pcall(require, "luasnip")
if not ls_status_ok then
  return
end
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet

ls.add_snippets("tex", {
  s({
    trig = "mk",
    namr = "Math Inline",
    dscr = "Inline mathmode",
  }, {
        t("$"), i(1, ""), t("$"), i(0)
  }),
  s({
    trig = "pd",
    namr = "Partial Derivative",
    dscr = "Partial Derivative of of a function",
  }, {
        t("\\frac{\\partial "), i(1, "f"), t("}{\\partial "), i(2, "x"), t("}"), i(0)
  }),
  s({
    trig = "// ",
    namr = "fraction",
    dscr = "write a fraction",
  }, {
        t("\\frac{"), i(1, "a"), t("}{"), i(2, "b"), t("}"), i(0)
  }),
})
