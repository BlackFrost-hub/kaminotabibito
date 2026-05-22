--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["英雄闪避音效配置表"] = {
    ["永远17岁的少女"] = {["名称"] = "永远17岁的少女", ["音效列表"] = {gg_snd_YakumoYukariMiss1, gg_snd_YakumoYukariMiss2}},
    ["妖怪の贤者"] = {["名称"] = "妖怪の贤者", ["音效列表"] = {gg_snd_YakumoYukariMiss1, gg_snd_YakumoYukariMiss2}},
    ["欧尔贝克"] = {["名称"] = "欧尔贝克", ["音效列表"] = {gg_snd_OebkMiss1_1, gg_snd_OebkMiss2_1}},
    ["刚剑骑士"] = {["名称"] = "刚剑骑士", ["音效列表"] = {gg_snd_OebkMiss1_1, gg_snd_OebkMiss2_1}},
    ["欧菲莉亚"] = {["名称"] = "欧菲莉亚", ["音效列表"] = {gg_snd_OflyMiss1_1, gg_snd_OflyMiss2_1}},
    ["神官"] = {["名称"] = "神官", ["音效列表"] = {gg_snd_OflyMiss1_1, gg_snd_OflyMiss2_1}},
    ["普里姆萝洁"] = {["名称"] = "普里姆萝洁", ["音效列表"] = {gg_snd_PlmljMiss1_1, gg_snd_PlmljMiss2_1}},
    ["舞者"] = {["名称"] = "舞者", ["音效列表"] = {gg_snd_PlmljMiss1_1, gg_snd_PlmljMiss2_1}},
    ["塞拉斯"] = {["名称"] = "塞拉斯", ["音效列表"] = {gg_snd_SLSMiss1_1, gg_snd_SLSMiss2_1}},
    ["学者"] = {["名称"] = "学者", ["音效列表"] = {gg_snd_SLSMiss1_1, gg_snd_SLSMiss2_1}},
    ["特蕾莎"] = {["名称"] = "特蕾莎", ["音效列表"] = {gg_snd_TlsMiss1_1, gg_snd_TlsMiss2_1}},
    ["商人"] = {["名称"] = "商人", ["音效列表"] = {gg_snd_TlsMiss1_1, gg_snd_TlsMiss2_1}},
    ["泰里翁"] = {["名称"] = "泰里翁", ["音效列表"] = {gg_snd_TlwMiss1_1, gg_snd_TlwMiss2_1}},
    ["盗贼"] = {["名称"] = "盗贼", ["音效列表"] = {gg_snd_TlwMiss1_1, gg_snd_TlwMiss2_1}}
}
____exports["英雄闪避音效冷却"] = 6
____exports["取英雄闪避音效配置"] = function(_____82F1_96C4_540D)
    if _____82F1_96C4_540D == nil or _____82F1_96C4_540D == "" then
        return nil
    end
    return ____exports["英雄闪避音效配置表"][_____82F1_96C4_540D] or nil
end
return ____exports
