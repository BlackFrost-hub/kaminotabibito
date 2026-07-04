--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_0["按名字反查物品ID"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_2.UnitHasItemOfTypeBJ
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_3.getServerTime
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统")
local _____88C5_5907_89E6_53D1_6982_7387_901A_8FC7 = ____require_result_4["装备触发概率通过"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听")
local _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03 = ____require_result_5["监听指定物品获取丢弃"]
local GetHandleId = jass.GetHandleId
local _____88C5_5907_7269_54C1ID_7F13_5B58 = {}
local _____88C5_5907_51B7_5374_8868 = {}
____exports["取装备物品ID"] = function(_____88C5_5907_540D)
    local cached = _____88C5_5907_7269_54C1ID_7F13_5B58[_____88C5_5907_540D]
    if cached ~= nil then
        return cached
    end
    local id = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____88C5_5907_540D))
    _____88C5_5907_7269_54C1ID_7F13_5B58[_____88C5_5907_540D] = id
    return id
end
____exports["单位持有装备"] = function(unit, _____88C5_5907_540D)
    if unit == nil or unit == 0 then
        return false
    end
    local itemId = ____exports["取装备物品ID"](_____88C5_5907_540D)
    return itemId ~= 0 and UnitHasItemOfTypeBJ(unit, itemId) == true
end
____exports["取装备冷却键"] = function(unit, tag, _____524D_7F00)
    if _____524D_7F00 == nil then
        _____524D_7F00 = "装备"
    end
    if unit == nil or unit == 0 or tag == "" then
        return ""
    end
    return (((_____524D_7F00 .. ":") .. tag) .. ":") .. tostring(GetHandleId(unit))
end
____exports["取单位对单位冷却键"] = function(source, target, tag, _____524D_7F00)
    if _____524D_7F00 == nil then
        _____524D_7F00 = "装备单位对单位"
    end
    if source == nil or source == 0 or target == nil or target == 0 or tag == "" then
        return ""
    end
    return (((((_____524D_7F00 .. ":") .. tag) .. ":") .. tostring(GetHandleId(source))) .. ":") .. tostring(GetHandleId(target))
end
____exports["装备冷却就绪"] = function(key)
    return key ~= "" and (_____88C5_5907_51B7_5374_8868[key] or 0) <= getServerTime()
end
____exports["装备冷却中"] = function(key)
    return key == "" or (_____88C5_5907_51B7_5374_8868[key] or 0) > getServerTime()
end
____exports["进入装备冷却"] = function(key, _____79D2_6570)
    if key == "" then
        return
    end
    _____88C5_5907_51B7_5374_8868[key] = getServerTime() + _____79D2_6570 * 1000
end
____exports["装备概率通过"] = function(unit, chance)
    return chance >= 1 or chance > 0 and _____88C5_5907_89E6_53D1_6982_7387_901A_8FC7(chance, unit) == true
end
____exports["取第二章后段Boss战利品ID"] = function(_____88C5_5907_540D)
    return ____exports["取装备物品ID"](_____88C5_5907_540D)
end
____exports["单位持有第二章后段Boss战利品"] = function(unit, _____88C5_5907_540D)
    return ____exports["单位持有装备"](unit, _____88C5_5907_540D)
end
____exports["取冷却键"] = function(unit, tag)
    return ____exports["取装备冷却键"](unit, tag, "第二章后段Boss战利品")
end
____exports["冷却就绪"] = function(key)
    return ____exports["装备冷却就绪"](key)
end
____exports["进入冷却"] = function(key, _____79D2_6570)
    ____exports["进入装备冷却"](key, _____79D2_6570)
end
____exports["概率通过"] = function(unit, chance)
    return ____exports["装备概率通过"](unit, chance)
end
____exports["监听装备丢弃清理"] = function(_____88C5_5907_540D, _____6E05_7406_56DE_8C03)
    local itemId = ____exports["取装备物品ID"](_____88C5_5907_540D)
    if itemId == 0 then
        return
    end
    _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03(
        itemId,
        nil,
        function(unit)
            _____6E05_7406_56DE_8C03(unit)
        end
    )
end
return ____exports
