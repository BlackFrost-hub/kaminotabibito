local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.16．塞拉斯.00．配置")
local _____585E_62C9_65AF_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["塞拉斯技能配置"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local _____9B54_6CD5_72B6_6001_8868 = {}
local _____653B_51FB_6807_8BB0_8868 = {}
____exports["取塞拉斯句柄ID"] = function(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
____exports["获取塞拉斯魔法状态"] = function(unit)
    local id = ____exports["取塞拉斯句柄ID"](unit)
    if id == 0 then
        return nil
    end
    return _____9B54_6CD5_72B6_6001_8868[id]
end
____exports["获取或创建塞拉斯魔法状态"] = function(unit)
    local id = ____exports["取塞拉斯句柄ID"](unit)
    if id == 0 then
        return nil
    end
    local current = _____9B54_6CD5_72B6_6001_8868[id]
    if current ~= nil then
        return current
    end
    local created = {
        ["英雄句柄ID"] = id,
        ["普通魔法已开启"] = false,
        ["大魔法化"] = false,
        ["当前元素"] = "",
        ["普通魔法技能等级"] = 0,
        ["开启回调ID"] = 0,
        ["关闭回调ID"] = 0
    }
    _____9B54_6CD5_72B6_6001_8868[id] = created
    return created
end
____exports["清理塞拉斯魔法状态"] = function(unit)
    local id = ____exports["取塞拉斯句柄ID"](unit)
    if id == 0 then
        return
    end
    __TS__Delete(_____9B54_6CD5_72B6_6001_8868, id)
    __TS__Delete(_____653B_51FB_6807_8BB0_8868, id)
end
____exports["消费塞拉斯大魔法化"] = function(unit)
    local state = ____exports["获取塞拉斯魔法状态"](unit)
    if state == nil then
        return false
    end
    if not state["大魔法化"] then
        return false
    end
    state["大魔法化"] = false
    return true
end
____exports["设置塞拉斯攻击标记"] = function(unit, _____5143_7D20)
    if _____5143_7D20 == "" then
        return
    end
    local id = ____exports["取塞拉斯句柄ID"](unit)
    if id == 0 then
        return
    end
    local marks = _____653B_51FB_6807_8BB0_8868[id]
    if marks == nil then
        marks = {["火"] = false, ["冰"] = false, ["雷"] = false}
        _____653B_51FB_6807_8BB0_8868[id] = marks
    end
    if _____5143_7D20 == "火" then
        marks["火"] = true
    end
    if _____5143_7D20 == "冰" then
        marks["冰"] = true
    end
    if _____5143_7D20 == "雷" then
        marks["雷"] = true
    end
end
--- 一次性取走全部有效攻击标记并清空（源 JASS 被动消费行为）。
-- 返回的布尔按 火/冰/雷 表示；同时返回优先级最高的元素（火 > 雷 > 冰，与源 JASS 分支顺序一致）。
____exports["消费塞拉斯攻击标记"] = function(unit)
    local id = ____exports["取塞拉斯句柄ID"](unit)
    local empty = {["火"] = false, ["冰"] = false, ["雷"] = false, ["优先元素"] = ""}
    if id == 0 then
        return empty
    end
    local marks = _____653B_51FB_6807_8BB0_8868[id]
    if marks == nil then
        return empty
    end
    local result = {["火"] = marks["火"], ["冰"] = marks["冰"], ["雷"] = marks["雷"], ["优先元素"] = ""}
    if marks["火"] then
        result["优先元素"] = "火"
    elseif marks["雷"] then
        result["优先元素"] = "雷"
    elseif marks["冰"] then
        result["优先元素"] = "冰"
    end
    marks["火"] = false
    marks["冰"] = false
    marks["雷"] = false
    return result
end
____exports["塞拉斯拥有任意攻击标记"] = function(unit)
    local id = ____exports["取塞拉斯句柄ID"](unit)
    if id == 0 then
        return false
    end
    local marks = _____653B_51FB_6807_8BB0_8868[id]
    if marks == nil then
        return false
    end
    return marks["火"] or marks["冰"] or marks["雷"]
end
--- E 属性提升统一增幅入口（塞拉斯专用）。
-- 增幅 = (10 + 3 × A0JX等级)%；只用于塞拉斯火冰雷魔法技能伤害，
-- 不修正普攻与灼烧周期伤害。项目统一魔法伤害修正入口落地后迁移本函数。
____exports["塞拉斯魔法技能增幅倍率"] = function(unit)
    if unit == nil or unit == 0 then
        return 1
    end
    local level = GetUnitAbilityLevel(unit, _____585E_62C9_65AF_6280_80FD_914D_7F6E.E["技能类型ID"])
    if level <= 0 then
        return 1
    end
    local _____589E_5E45_767E_5206_6BD4 = _____585E_62C9_65AF_6280_80FD_914D_7F6E.E["每级魔法伤害基础增幅百分比"] + _____585E_62C9_65AF_6280_80FD_914D_7F6E.E["每级魔法伤害成长百分比"] * level
    return 1 + _____589E_5E45_767E_5206_6BD4 / 100
end
return ____exports
