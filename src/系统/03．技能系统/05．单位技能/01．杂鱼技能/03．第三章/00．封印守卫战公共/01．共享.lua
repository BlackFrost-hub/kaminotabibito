local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local ____exports = {}
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local IsUnitAliveBJ = ____require_result_1.IsUnitAliveBJ
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_2.getRegisteredPlayerHero
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.02．GS单位属性")
local GS_LoadUintProperty = ____require_result_3.GS_LoadUintProperty
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5355_4F4D_662F_5426_5904_4E8E_786C_63A7_5236_6548_679C_5408_96C6 = ____require_result_4["单位是否处于硬控制效果合集"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_5["创建点特效"]
local createTimedUnitEffect = ____require_result_5.createTimedUnitEffect
local createUnitEffect = ____require_result_5.createUnitEffect
local destroyUnitEffect = ____require_result_5.destroyUnitEffect
local Player = jass.Player
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetUnitState = jass.GetUnitState
local IssueTargetOrder = jass.IssueTargetOrder
local IssuePointOrder = jass.IssuePointOrder
local IssueImmediateOrder = jass.IssueImmediateOrder
local DestroyEffect = jass.DestroyEffect
local Atan2 = jass.Atan2
local SquareRoot = jass.SquareRoot
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local _____5F27_5EA6_8F6C_89D2_5EA6 = 57.29577951308232
local _____5141_8BB8_73A9_5BB6_82F1_96C4_6570_91CF = 6
____exports["封印守卫战第三章敌人单位ID"] = {
    ["失控英灵"] = stringToFourCCSafe("n06B"),
    ["夺灵祭司"] = stringToFourCCSafe("n06A"),
    ["锚蚀兽"] = stringToFourCCSafe("n06C"),
    ["断誓猎手"] = stringToFourCCSafe("n06D"),
    ["黑暗残响"] = stringToFourCCSafe("n069"),
    ["裂誓重卫"] = stringToFourCCSafe("n06E"),
    ["失律号令者"] = stringToFourCCSafe("n06F"),
    ["潮蚀巡鳞者"] = stringToFourCCSafe("n056"),
    ["碎礁投石手"] = stringToFourCCSafe("h00Y"),
    ["灵潮祭司"] = stringToFourCCSafe("n054"),
    ["金鳞执刑官"] = stringToFourCCSafe("n052"),
    ["深渊鳞将"] = stringToFourCCSafe("n055")
}
local _____72B6_6001 = {["运行中"] = false, ["敌人列表"] = {}, ["敌人映射"] = {}, ["锚点压制数量"] = {0, 0, 0}}
____exports["设置封印守卫战第三章技能环境"] = function(_____73AF_5883)
    _____72B6_6001["环境"] = _____73AF_5883
    _____72B6_6001["运行中"] = _____73AF_5883 ~= nil
end
____exports["读取封印守卫战第三章技能状态"] = function()
    return _____72B6_6001
end
____exports["封印守卫战单位存活"] = function(unit)
    return unit ~= nil and unit ~= 0 and IsUnitAliveBJ(unit) == true
end
____exports["取封印守卫战单位句柄ID"] = function(unit)
    return unit ~= nil and unit ~= 0 and (GetHandleId(unit) or 0) or 0
end
____exports["创建封印守卫战敌人记录"] = function(unit, _____7C7B_578B, _____5F53_524D_6BEB_79D2)
    local _____53E5_67C4ID = ____exports["取封印守卫战单位句柄ID"](unit)
    if _____53E5_67C4ID == 0 or not ____exports["封印守卫战单位存活"](unit) then
        return nil
    end
    local _____5DF2_6709 = _____72B6_6001["敌人映射"][_____53E5_67C4ID]
    if _____5DF2_6709 ~= nil then
        return _____5DF2_6709
    end
    local record = {
        ["单位"] = unit,
        ["句柄ID"] = _____53E5_67C4ID,
        ["类型"] = _____7C7B_578B,
        ["下次AI毫秒"] = _____5F53_524D_6BEB_79D2,
        ["下次技能毫秒"] = _____5F53_524D_6BEB_79D2,
        ["充能ID"] = 0,
        ["锚点编号"] = 0,
        ["正在压制锚点"] = false,
        ["普攻计数"] = 0,
        ["上次被动毫秒"] = 0,
        ["号令结束毫秒"] = 0,
        ["号令属性已施加"] = false,
        ["号令移动速度增量"] = 0
    }
    local ____72B6_6001__654C_4EBA_5217_8868_6 = _____72B6_6001["敌人列表"]
    ____72B6_6001__654C_4EBA_5217_8868_6[#____72B6_6001__654C_4EBA_5217_8868_6 + 1] = record
    _____72B6_6001["敌人映射"][_____53E5_67C4ID] = record
    return record
end
____exports["读取封印守卫战敌人记录"] = function(unit)
    local id = ____exports["取封印守卫战单位句柄ID"](unit)
    local ____temp_7
    if id > 0 then
        ____temp_7 = _____72B6_6001["敌人映射"][id]
    else
        ____temp_7 = nil
    end
    return ____temp_7
end
____exports["读取封印守卫战敌人列表"] = function()
    return _____72B6_6001["敌人列表"]
end
____exports["移除封印守卫战敌人记录引用"] = function(record)
    if _____72B6_6001["敌人映射"][record["句柄ID"]] == record then
        __TS__Delete(_____72B6_6001["敌人映射"], record["句柄ID"])
    end
    local index = __TS__ArrayIndexOf(_____72B6_6001["敌人列表"], record)
    if index >= 0 then
        __TS__ArraySplice(_____72B6_6001["敌人列表"], index, 1)
    end
end
____exports["清空封印守卫战敌人记录"] = function()
    __TS__ArraySetLength(_____72B6_6001["敌人列表"], 0)
    _____72B6_6001["敌人映射"] = {}
    _____72B6_6001["锚点压制数量"][1] = 0
    _____72B6_6001["锚点压制数量"][2] = 0
    _____72B6_6001["锚点压制数量"][3] = 0
end
____exports["读取封印守卫战核心"] = function()
    local ____opt_8 = _____72B6_6001["环境"]
    local ____temp_10 = ____opt_8 and ____opt_8["读取能量核心"]()
    if ____temp_10 == nil then
        ____temp_10 = nil
    end
    return ____temp_10
end
____exports["读取封印守卫战锚点状态"] = function(_____951A_70B9_7F16_53F7)
    local ____opt_11 = _____72B6_6001["环境"]
    return ____opt_11 and ____opt_11["读取锚点状态"](_____951A_70B9_7F16_53F7)
end
____exports["读取封印守卫战玩家英雄列表"] = function()
    local ____opt_13 = _____72B6_6001["环境"]
    local fromContext = ____opt_13 and ____opt_13["读取玩家英雄列表"]()
    if fromContext ~= nil then
        return fromContext
    end
    local result = {}
    do
        local i = 0
        while i < _____5141_8BB8_73A9_5BB6_82F1_96C4_6570_91CF do
            local hero = getRegisteredPlayerHero(Player(i))
            if ____exports["封印守卫战单位存活"](hero) then
                result[#result + 1] = hero
            end
            i = i + 1
        end
    end
    return result
end
____exports["读取正在修复封印锚点的英雄列表"] = function()
    local ____opt_15 = _____72B6_6001["环境"]
    return ____opt_15 and ____opt_15["读取正在修复锚点的英雄列表"]() or ({})
end
____exports["是封印守卫战玩家英雄"] = function(unit)
    if not ____exports["封印守卫战单位存活"](unit) then
        return false
    end
    local list = ____exports["读取封印守卫战玩家英雄列表"]()
    do
        local i = 0
        while i < #list do
            if list[i + 1] == unit then
                return true
            end
            i = i + 1
        end
    end
    return false
end
____exports["取单位X"] = function(unit)
    return GetUnitX(unit)
end
____exports["取单位Y"] = function(unit)
    return GetUnitY(unit)
end
____exports["取单位面向"] = function(unit)
    return GetUnitFacing(unit)
end
____exports["取两点距离平方"] = function(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return dx * dx + dy * dy
end
____exports["取单位距离平方"] = function(first, second)
    if not ____exports["封印守卫战单位存活"](first) or not ____exports["封印守卫战单位存活"](second) then
        return 999999999
    end
    return ____exports["取两点距离平方"](
        GetUnitX(first),
        GetUnitY(first),
        GetUnitX(second),
        GetUnitY(second)
    )
end
____exports["取两点距离"] = function(x1, y1, x2, y2)
    return SquareRoot(____exports["取两点距离平方"](x1, y1, x2, y2))
end
____exports["取两点方向角"] = function(x1, y1, x2, y2)
    local angle = Atan2(y2 - y1, x2 - x1) * _____5F27_5EA6_8F6C_89D2_5EA6
    if angle < 0 then
        angle = angle + 360
    end
    return angle
end
____exports["取最近玩家英雄"] = function(unit, _____6700_5927_8303_56F4)
    local list = ____exports["读取封印守卫战玩家英雄列表"]()
    local x = GetUnitX(unit)
    local y = GetUnitY(unit)
    local limit = _____6700_5927_8303_56F4 ~= nil and _____6700_5927_8303_56F4 > 0 and _____6700_5927_8303_56F4 * _____6700_5927_8303_56F4 or 999999999
    local nearest = nil
    local best = limit
    do
        local i = 0
        while i < #list do
            do
                local hero = list[i + 1]
                if not ____exports["封印守卫战单位存活"](hero) then
                    goto __continue39
                end
                local distance = ____exports["取两点距离平方"](
                    x,
                    y,
                    GetUnitX(hero),
                    GetUnitY(hero)
                )
                if distance > best then
                    goto __continue39
                end
                best = distance
                nearest = hero
            end
            ::__continue39::
            i = i + 1
        end
    end
    return nearest
end
____exports["取最近单位"] = function(source, candidates, _____6700_5927_8303_56F4)
    local x = GetUnitX(source)
    local y = GetUnitY(source)
    local limit = _____6700_5927_8303_56F4 ~= nil and _____6700_5927_8303_56F4 > 0 and _____6700_5927_8303_56F4 * _____6700_5927_8303_56F4 or 999999999
    local nearest = nil
    local best = limit
    do
        local i = 0
        while i < #candidates do
            do
                local target = candidates[i + 1]
                if not ____exports["封印守卫战单位存活"](target) then
                    goto __continue44
                end
                local distance = ____exports["取两点距离平方"](
                    x,
                    y,
                    GetUnitX(target),
                    GetUnitY(target)
                )
                if distance > best then
                    goto __continue44
                end
                best = distance
                nearest = target
            end
            ::__continue44::
            i = i + 1
        end
    end
    return nearest
end
____exports["读取单位攻击力"] = function(unit)
    return GS_LoadUintProperty(unit, 2)
end
____exports["读取单位最大生命"] = function(unit)
    return GetUnitState(unit, UNIT_STATE_MAX_LIFE) or 0
end
____exports["读取单位生命"] = function(unit)
    return GetUnitState(unit, jass.UNIT_STATE_LIFE) or 0
end
____exports["单位处于硬控制"] = function(unit)
    return ____exports["封印守卫战单位存活"](unit) and _____5355_4F4D_662F_5426_5904_4E8E_786C_63A7_5236_6548_679C_5408_96C6(unit) == true
end
____exports["命令攻击目标"] = function(unit, target)
    return ____exports["封印守卫战单位存活"](unit) and ____exports["封印守卫战单位存活"](target) and IssueTargetOrder(unit, "attack", target)
end
____exports["命令移动到点"] = function(unit, x, y)
    return ____exports["封印守卫战单位存活"](unit) and IssuePointOrder(unit, "move", x, y)
end
____exports["命令停止"] = function(unit)
    return ____exports["封印守卫战单位存活"](unit) and IssueImmediateOrder(unit, "stop")
end
____exports["播放封印守卫战单位临时特效"] = function(unit, model, duration)
    return createTimedUnitEffect(unit, "origin", model, duration)
end
____exports["创建封印守卫战单位常驻特效"] = function(unit, model, key)
    return createUnitEffect(
        unit,
        "origin",
        model,
        nil,
        key
    )
end
____exports["销毁封印守卫战单位常驻特效"] = function(unit, key)
    destroyUnitEffect(unit, key)
end
____exports["创建封印守卫战点特效"] = function(params)
    return _____521B_5EFA_70B9_7279_6548(params)
end
____exports["销毁封印守卫战特效"] = function(effect)
    if effect ~= nil and effect ~= 0 then
        DestroyEffect(effect)
    end
end
____exports["设置记录锚点压制"] = function(record, enabled)
    if record["锚点编号"] < 1 or record["锚点编号"] > #_____72B6_6001["锚点压制数量"] then
        return
    end
    if record["正在压制锚点"] == enabled then
        return
    end
    local index = record["锚点编号"] - 1
    local before = _____72B6_6001["锚点压制数量"][index + 1] or 0
    local after = enabled and before + 1 or (before > 0 and before - 1 or 0)
    _____72B6_6001["锚点压制数量"][index + 1] = after
    record["正在压制锚点"] = enabled
    if before == 0 ~= (after == 0) then
        local ____opt_17 = _____72B6_6001["环境"]
        if ____opt_17 ~= nil then
            ____opt_17["设置锚点压制"](record["锚点编号"], after > 0)
        end
    end
end
____exports["清理记录锚点压制"] = function(record)
    ____exports["设置记录锚点压制"](record, false)
    ____exports["销毁封印守卫战特效"](record["压制特效"])
    record["压制特效"] = nil
    record["锚点编号"] = 0
end
return ____exports
