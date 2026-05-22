--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jassGlobals = require("jass.globals")
local gg_snd_YakumoYukariDeath1 = jassGlobals.gg_snd_YakumoYukariDeath1
local gg_snd_YakumoYukariDeath2 = jassGlobals.gg_snd_YakumoYukariDeath2
local gg_snd_HeroMoonPriestessDeath1 = jassGlobals.gg_snd_HeroMoonPriestessDeath1
local gg_snd_OebkDeath1 = jassGlobals.gg_snd_OebkDeath1
local gg_snd_OebkDeath2 = jassGlobals.gg_snd_OebkDeath2
local gg_snd_OlfyDeath1 = jassGlobals.gg_snd_OlfyDeath1
local gg_snd_OlfyDeath2 = jassGlobals.gg_snd_OlfyDeath2
local gg_snd_PlmljDeath1 = jassGlobals.gg_snd_PlmljDeath1
local gg_snd_PlmljDeath2 = jassGlobals.gg_snd_PlmljDeath2
local gg_snd_SlsDeath1 = jassGlobals.gg_snd_SlsDeath1
local gg_snd_SlsDeath2 = jassGlobals.gg_snd_SlsDeath2
local gg_snd_TlsDeath1 = jassGlobals.gg_snd_TlsDeath1
local gg_snd_TlsDeath2 = jassGlobals.gg_snd_TlsDeath2
local gg_snd_TlwDeath1 = jassGlobals.gg_snd_TlwDeath1
local gg_snd_TlwDeath2 = jassGlobals.gg_snd_TlwDeath2
____exports["英雄死亡音效配置表"] = {
    ["女仆"] = {["英雄名"] = "女仆", ["音效列表"] = {gg_snd_HeroMoonPriestessDeath1}},
    ["十六夜咲夜"] = {["英雄名"] = "十六夜咲夜", ["音效列表"] = {gg_snd_HeroMoonPriestessDeath1}},
    ["永远17岁的少女"] = {["英雄名"] = "永远17岁的少女", ["音效列表"] = {gg_snd_YakumoYukariDeath1, gg_snd_YakumoYukariDeath2}},
    ["妖怪の贤者"] = {["英雄名"] = "妖怪の贤者", ["音效列表"] = {gg_snd_YakumoYukariDeath1, gg_snd_YakumoYukariDeath2}},
    ["八云紫"] = {["英雄名"] = "八云紫", ["音效列表"] = {gg_snd_YakumoYukariDeath1, gg_snd_YakumoYukariDeath2}},
    ["欧尔贝克"] = {["英雄名"] = "欧尔贝克", ["音效列表"] = {gg_snd_OebkDeath1, gg_snd_OebkDeath2}},
    ["刚剑骑士"] = {["英雄名"] = "刚剑骑士", ["音效列表"] = {gg_snd_OebkDeath1, gg_snd_OebkDeath2}},
    ["欧菲莉亚"] = {["英雄名"] = "欧菲莉亚", ["音效列表"] = {gg_snd_OlfyDeath1, gg_snd_OlfyDeath2}},
    ["神官"] = {["英雄名"] = "神官", ["音效列表"] = {gg_snd_OlfyDeath1, gg_snd_OlfyDeath2}},
    ["普里姆萝洁"] = {["英雄名"] = "普里姆萝洁", ["音效列表"] = {gg_snd_PlmljDeath1, gg_snd_PlmljDeath2}},
    ["舞者"] = {["英雄名"] = "舞者", ["音效列表"] = {gg_snd_PlmljDeath1, gg_snd_PlmljDeath2}},
    ["塞拉斯"] = {["英雄名"] = "塞拉斯", ["音效列表"] = {gg_snd_SlsDeath1, gg_snd_SlsDeath2}},
    ["学者"] = {["英雄名"] = "学者", ["音效列表"] = {gg_snd_SlsDeath1, gg_snd_SlsDeath2}},
    ["特蕾莎"] = {["英雄名"] = "特蕾莎", ["音效列表"] = {gg_snd_TlsDeath1, gg_snd_TlsDeath2}},
    ["商人"] = {["英雄名"] = "商人", ["音效列表"] = {gg_snd_TlsDeath1, gg_snd_TlsDeath2}},
    ["泰里翁"] = {["英雄名"] = "泰里翁", ["音效列表"] = {gg_snd_TlwDeath1, gg_snd_TlwDeath2}},
    ["盗贼"] = {["英雄名"] = "盗贼", ["音效列表"] = {gg_snd_TlwDeath1, gg_snd_TlwDeath2}},
    ["铃仙"] = {["英雄名"] = "铃仙", ["音效列表"] = {gg_snd_HeroMoonPriestessDeath1}},
    ["月兔"] = {["英雄名"] = "月兔", ["音效列表"] = {gg_snd_HeroMoonPriestessDeath1}},
    ["狂气の月兔"] = {["英雄名"] = "狂气の月兔", ["音效列表"] = {gg_snd_HeroMoonPriestessDeath1}}
}
____exports["英雄死亡音效冷却"] = 8
____exports["取英雄死亡音效配置"] = function(_____82F1_96C4_540D)
    if _____82F1_96C4_540D == nil or _____82F1_96C4_540D == "" then
        return nil
    end
    return ____exports["英雄死亡音效配置表"][_____82F1_96C4_540D] or nil
end
return ____exports
