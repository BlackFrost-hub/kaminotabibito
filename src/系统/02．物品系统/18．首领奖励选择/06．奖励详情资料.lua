--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_88C5_5907_6570_636E = require("系统.02．物品系统.01．装备数据")
local items = ____01_FF0E_88C5_5907_6570_636E.items
local ____13_FF0E_7269_54C1_540D_53CD_67E5 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____13_FF0E_7269_54C1_540D_53CD_67E5["按名字反查物品ID"]
local _____88C5_5907_6570_636E_67E5_8BE2 = require("lib.扩展函数.物品相关函数.装备数据查询")
local _____751F_6210_88C5_5907_5C5E_6027_6587_672C = _____88C5_5907_6570_636E_67E5_8BE2["生成装备属性文本"]
local _____9ED8_8BA4_5956_52B1_56FE_6807 = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"
____exports["获取首领奖励装备详情"] = function(_____9009_9879)
    local _____7269_54C1ID = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____9009_9879["装备名"])
    local _____6570_636E = _____7269_54C1ID ~= nil and items[_____7269_54C1ID] or nil
    return {
        ["分类"] = _____6570_636E and _____6570_636E.type or "装备",
        ["等级"] = _____6570_636E and _____6570_636E.level or "",
        ["评分"] = (_____6570_636E and _____6570_636E.score) ~= nil and "" .. tostring(_____6570_636E.score) or "",
        ["描述"] = _____9009_9879["描述"],
        ["属性"] = _____6570_636E ~= nil and _____751F_6210_88C5_5907_5C5E_6027_6587_672C(_____6570_636E) or "",
        ["特效"] = _____9009_9879["特效"],
        ["图标"] = _____9009_9879["图标"] or _____9ED8_8BA4_5956_52B1_56FE_6807
    }
end
return ____exports
