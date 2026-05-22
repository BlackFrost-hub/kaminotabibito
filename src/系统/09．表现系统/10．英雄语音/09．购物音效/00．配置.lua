--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jassGlobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local stringToFourCC = ____require_result_0.stringToFourCC
local gg_snd_IzayoiSakuya_buy1 = jassGlobals.gg_snd_IzayoiSakuya_buy1
local gg_snd_IzayoiSakuya_buy2 = jassGlobals.gg_snd_IzayoiSakuya_buy2
local gg_snd_YakumoYukariBuy1 = jassGlobals.gg_snd_YakumoYukariBuy1
local gg_snd_YakumoYukariBuy2 = jassGlobals.gg_snd_YakumoYukariBuy2
____exports["英雄购物音效配置列表"] = {{["英雄名"] = "十六夜咲夜", ["音效列表"] = {gg_snd_IzayoiSakuya_buy1, gg_snd_IzayoiSakuya_buy2}}, {["英雄名"] = "八云紫", ["音效列表"] = {gg_snd_YakumoYukariBuy1, gg_snd_YakumoYukariBuy2}}}
____exports["英雄购物音效范围"] = 650
____exports["英雄购物音效冷却"] = 10
____exports["购物商店判定能力Id"] = stringToFourCC("Apit")
return ____exports
