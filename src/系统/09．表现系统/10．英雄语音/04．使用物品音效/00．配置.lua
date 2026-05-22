--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jassGlobals = require("jass.globals")
local gg_snd_IzayoiSakuya_Use = jassGlobals.gg_snd_IzayoiSakuya_Use
local gg_snd_IzayoiSakuya_Use2 = jassGlobals.gg_snd_IzayoiSakuya_Use2
local gg_snd_YakumoYukariUse = jassGlobals.gg_snd_YakumoYukariUse
local gg_snd_OebkUse_1 = jassGlobals.gg_snd_OebkUse_1
local gg_snd_OflyUse_1 = jassGlobals.gg_snd_OflyUse_1
local gg_snd_PlmljUse_1 = jassGlobals.gg_snd_PlmljUse_1
local gg_snd_SlsUse_1 = jassGlobals.gg_snd_SlsUse_1
local gg_snd_TlsUse_1 = jassGlobals.gg_snd_TlsUse_1
local gg_snd_TlwUse_1 = jassGlobals.gg_snd_TlwUse_1
____exports["英雄使用物品音效配置列表"] = {
    {["英雄名"] = "十六夜咲夜", ["是否3D"] = false, ["音效列表"] = {gg_snd_IzayoiSakuya_Use, gg_snd_IzayoiSakuya_Use2}},
    {["英雄名"] = "八云紫", ["是否3D"] = false, ["音效列表"] = {gg_snd_YakumoYukariUse}},
    {["英雄名"] = "欧尔贝克", ["是否3D"] = true, ["音效列表"] = {gg_snd_OebkUse_1}},
    {["英雄名"] = "欧菲莉亚", ["是否3D"] = true, ["音效列表"] = {gg_snd_OflyUse_1}},
    {["英雄名"] = "普里姆萝洁", ["是否3D"] = true, ["音效列表"] = {gg_snd_PlmljUse_1}},
    {["英雄名"] = "塞拉斯", ["是否3D"] = true, ["音效列表"] = {gg_snd_SlsUse_1}},
    {["英雄名"] = "特蕾莎", ["是否3D"] = true, ["音效列表"] = {gg_snd_TlsUse_1}},
    {["英雄名"] = "泰里翁", ["是否3D"] = true, ["音效列表"] = {gg_snd_TlwUse_1}}
}
____exports["英雄使用物品音效配置表"] = {
    ["十六夜咲夜"] = ____exports["英雄使用物品音效配置列表"][1],
    ["八云紫"] = ____exports["英雄使用物品音效配置列表"][2],
    ["欧尔贝克"] = ____exports["英雄使用物品音效配置列表"][3],
    ["欧菲莉亚"] = ____exports["英雄使用物品音效配置列表"][4],
    ["普里姆萝洁"] = ____exports["英雄使用物品音效配置列表"][5],
    ["塞拉斯"] = ____exports["英雄使用物品音效配置列表"][6],
    ["特蕾莎"] = ____exports["英雄使用物品音效配置列表"][7],
    ["泰里翁"] = ____exports["英雄使用物品音效配置列表"][8]
}
____exports["英雄使用物品音效冷却"] = 15
____exports["英雄使用物品命令最小"] = 852008
____exports["英雄使用物品命令最大"] = 852013
____exports["取英雄使用物品音效配置"] = function(_____82F1_96C4_540D)
    if _____82F1_96C4_540D == nil or _____82F1_96C4_540D == "" then
        return nil
    end
    return ____exports["英雄使用物品音效配置表"][_____82F1_96C4_540D] or nil
end
return ____exports
