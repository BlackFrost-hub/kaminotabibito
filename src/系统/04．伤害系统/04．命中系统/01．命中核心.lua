local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.01A．玩家英雄判定")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_1["是玩家英雄组单位"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统")
local _____547D_4E2D_6982_7387_901A_8FC7 = ____require_result_2["命中概率通过"]
local ____require_result_3 = require("lib.扩展函数.封装函数.03．漂浮文字.03．创建漂浮文字")
local CreateFloatTextOnUnit = ____require_result_3.CreateFloatTextOnUnit
local ____require_result_4 = require("系统.04．伤害系统.04．命中系统.00．命中配置")
local _____547D_4E2D_7CFB_7EDF_914D_7F6E = ____require_result_4["命中系统配置"]
local GetOwningPlayer = jass.GetOwningPlayer
local function _____8C03_7528_73A9_5BB6_82F1_96C4_5224_5B9A(unit)
    return _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(unit) == true
end
local function _____9650_5236_6982_7387(value)
    if value <= 0 then
        return 0
    end
    if value >= 1 then
        return 1
    end
    return value
end
local function _____8BFB_53D6_5355_4F4D_5B9E_6570(unit, _____5C5E_6027_540D)
    if unit == nil or unit == 0 then
        return 0
    end
    return __TS__Number(YDUserDataGetSafe("unit", unit, _____5C5E_6027_540D, "real")) or 0
end
local function _____8BFB_53D6_73A9_5BB6_5B9E_6570(player, _____5C5E_6027_540D)
    if player == nil or player == 0 then
        return 0
    end
    return __TS__Number(YDUserDataGetSafe("player", player, _____5C5E_6027_540D, "real")) or 0
end
____exports["读取单位命中率偏移"] = function(unit)
    return _____8BFB_53D6_5355_4F4D_5B9E_6570(unit, "命中率")
end
____exports["读取玩家命中率偏移"] = function(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return _____8BFB_53D6_73A9_5BB6_5B9E_6570(
        GetOwningPlayer(unit),
        "命中率"
    )
end
--- 正向命中只用于抵消目标闪避，或被装备特例转化为额外暴击率。
____exports["读取正向命中率偏移"] = function(unit)
    local _____5355_4F4D_547D_4E2D = ____exports["读取单位命中率偏移"](unit)
    local _____73A9_5BB6_547D_4E2D = ____exports["读取玩家命中率偏移"](unit)
    local _____6B63_5411_547D_4E2D = 0
    if _____5355_4F4D_547D_4E2D > _____6B63_5411_547D_4E2D then
        _____6B63_5411_547D_4E2D = _____5355_4F4D_547D_4E2D
    end
    if _____73A9_5BB6_547D_4E2D > _____6B63_5411_547D_4E2D then
        _____6B63_5411_547D_4E2D = _____73A9_5BB6_547D_4E2D
    end
    return _____6B63_5411_547D_4E2D
end
--- 负向命中才会让攻击落空。
-- 语义：-0.10 表示 90% 命中，-0.50 表示 50% 命中；正向命中不在这里判定。
local function _____8BFB_53D6_8D1F_5411_547D_4E2D_7387_504F_79FB(unit)
    local _____5355_4F4D_547D_4E2D = ____exports["读取单位命中率偏移"](unit)
    local _____73A9_5BB6_547D_4E2D = ____exports["读取玩家命中率偏移"](unit)
    if not _____8C03_7528_73A9_5BB6_82F1_96C4_5224_5B9A(unit) and _____5355_4F4D_547D_4E2D < 0 then
        return _____5355_4F4D_547D_4E2D
    end
    if _____73A9_5BB6_547D_4E2D < 0 then
        return _____73A9_5BB6_547D_4E2D
    end
    return 0
end
local function _____663E_793A_672A_547D_4E2D(target)
    CreateFloatTextOnUnit(target, _____547D_4E2D_7CFB_7EDF_914D_7F6E["未命中文本"], _____547D_4E2D_7CFB_7EDF_914D_7F6E["漂浮文字"])
end
____exports["执行命中判定"] = function(attacker, target, currentDamage)
    if attacker == nil or attacker == 0 or target == nil or target == 0 then
        return {["结束链路"] = false, ["伤害"] = currentDamage, ["命中概率"] = _____547D_4E2D_7CFB_7EDF_914D_7F6E["默认命中概率"]}
    end
    if currentDamage < _____547D_4E2D_7CFB_7EDF_914D_7F6E["生效最低伤害"] then
        return {["结束链路"] = false, ["伤害"] = currentDamage, ["命中概率"] = _____547D_4E2D_7CFB_7EDF_914D_7F6E["默认命中概率"]}
    end
    local _____547D_4E2D_7387_504F_79FB = _____8BFB_53D6_8D1F_5411_547D_4E2D_7387_504F_79FB(attacker)
    if _____547D_4E2D_7387_504F_79FB >= 0 then
        return {["结束链路"] = false, ["伤害"] = currentDamage, ["命中概率"] = _____547D_4E2D_7CFB_7EDF_914D_7F6E["默认命中概率"]}
    end
    local _____57FA_7840_547D_4E2D_6982_7387 = _____9650_5236_6982_7387(_____547D_4E2D_7CFB_7EDF_914D_7F6E["默认命中概率"] + _____547D_4E2D_7387_504F_79FB)
    if _____547D_4E2D_6982_7387_901A_8FC7(_____57FA_7840_547D_4E2D_6982_7387, attacker) then
        return {["结束链路"] = false, ["伤害"] = currentDamage, ["命中概率"] = _____57FA_7840_547D_4E2D_6982_7387}
    end
    _____663E_793A_672A_547D_4E2D(target)
    return {["结束链路"] = true, ["伤害"] = 0, ["命中概率"] = _____57FA_7840_547D_4E2D_6982_7387}
end
return ____exports
