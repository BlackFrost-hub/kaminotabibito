local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local _____53D6_53E5_67C4ID, _____5355_4F4D_6EE1_8DB3_5F71_54CD_76EE_6807, _____5355_4F4D_53EF_4F5C_4E3A_8DF3_94FE_76EE_6807, _____67E5_627E_4E0B_4E00_8DF3_76EE_6807, _____521B_5EFA_8DF3_94FE_95EA_7535, _____7ED3_675F_8DF3_94FE_5B9E_4F8B, _____6267_884C_5F53_524D_4E00_8DF3, ____on_7EAF_8DF3_94FE_4E0B_4E00_8DF3_5230_65F6, CreateTimer, GetExpiredTimer, GetHandleId, GetUnitX, GetUnitY, UnitDamageTarget, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS, safeTimerStart, safeDestroyTimer, isUnitEnemy, isUnitAlly, isValidUnit, doHeal, _____9009_62E9_8303_56F4_5185_6700_8FD1_76EE_6807, _____9ED8_8BA4_95EA_7535_6548_679C_4EE3_7801, _____6D3B_8DC3_8DF3_94FE_6620_5C04, _____5B9A_65F6_5668_8DF3_94FE_6620_5C04
local _____5355_4F4D_7ED1_5B9A_95EA_7535 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电")
local _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535 = _____5355_4F4D_7ED1_5B9A_95EA_7535["创建单位绑定闪电"]
function _____53D6_53E5_67C4ID(handle)
    return handle ~= nil and handle ~= 0 and (GetHandleId(handle) or 0) or 0
end
function _____5355_4F4D_6EE1_8DB3_5F71_54CD_76EE_6807(_____5355_4F4D, _____6765_6E90_5355_4F4D, _____5F71_54CD_76EE_6807)
    if _____5F71_54CD_76EE_6807 == "全部" then
        return true
    end
    if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 then
        return true
    end
    if _____5F71_54CD_76EE_6807 == "敌方" then
        return isUnitEnemy(_____5355_4F4D, _____6765_6E90_5355_4F4D)
    end
    return isUnitAlly(_____5355_4F4D, _____6765_6E90_5355_4F4D)
end
function _____5355_4F4D_53EF_4F5C_4E3A_8DF3_94FE_76EE_6807(_____5B9E_4F8B, _____5355_4F4D, _____5F53_524D_76EE_6807)
    if not isValidUnit(_____5355_4F4D) then
        return false
    end
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    if _____5355_4F4D == _____5F53_524D_76EE_6807 then
        return false
    end
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID <= 0 then
        return false
    end
    if _____5B9E_4F8B["参数"]["允许重复命中"] ~= true and _____5B9E_4F8B["已命中单位"][_____5355_4F4DID] == true then
        return false
    end
    local _____6A21_5F0F = _____5B9E_4F8B["参数"]["模式"] or "伤害"
    local _____5F71_54CD_76EE_6807 = _____5B9E_4F8B["参数"]["影响目标"] or (_____6A21_5F0F == "治疗" and "友方" or "敌方")
    if not _____5355_4F4D_6EE1_8DB3_5F71_54CD_76EE_6807(_____5355_4F4D, _____5B9E_4F8B["参数"]["来源单位"], _____5F71_54CD_76EE_6807) then
        return false
    end
    local _____76EE_6807_7B5B_9009 = _____5B9E_4F8B["参数"]["目标筛选"]
    if _____76EE_6807_7B5B_9009 ~= nil and not _____76EE_6807_7B5B_9009(_____5355_4F4D, _____5F53_524D_76EE_6807, _____5B9E_4F8B["已完成跳数"]) then
        return false
    end
    return true
end
function _____67E5_627E_4E0B_4E00_8DF3_76EE_6807(_____5B9E_4F8B, _____5F53_524D_76EE_6807)
    local x = GetUnitX(_____5F53_524D_76EE_6807)
    local y = GetUnitY(_____5F53_524D_76EE_6807)
    local _____6A21_5F0F = _____5B9E_4F8B["参数"]["模式"] or "伤害"
    local _____5F71_54CD_76EE_6807 = _____5B9E_4F8B["参数"]["影响目标"] or (_____6A21_5F0F == "治疗" and "友方" or "敌方")
    return _____9009_62E9_8303_56F4_5185_6700_8FD1_76EE_6807({
        X = x,
        Y = y,
        ["半径"] = _____5B9E_4F8B["参数"]["每跳最大距离"],
        ["来源单位"] = _____5B9E_4F8B["参数"]["来源单位"],
        ["影响目标"] = _____5F71_54CD_76EE_6807,
        ["自定义条件"] = function(_____5355_4F4D)
            return _____5355_4F4D_53EF_4F5C_4E3A_8DF3_94FE_76EE_6807(_____5B9E_4F8B, _____5355_4F4D, _____5F53_524D_76EE_6807)
        end
    })
end
function _____521B_5EFA_8DF3_94FE_95EA_7535(_____8D77_70B9_5355_4F4D, _____7EC8_70B9_5355_4F4D, _____6548_679C_4EE3_7801, _____6301_7EED_65F6_95F4)
    _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535({
        ["效果代码"] = _____6548_679C_4EE3_7801,
        ["起点单位"] = _____8D77_70B9_5355_4F4D,
        ["终点单位"] = _____7EC8_70B9_5355_4F4D,
        ["持续时间"] = _____6301_7EED_65F6_95F4,
        ["起点高度偏移"] = 60,
        ["终点高度偏移"] = 60,
        ["任一死亡时销毁"] = true
    })
end
function _____7ED3_675F_8DF3_94FE_5B9E_4F8B(_____5B9E_4F8B, _____539F_56E0)
    if _____5B9E_4F8B["已结束"] then
        return
    end
    _____5B9E_4F8B["已结束"] = true
    if _____5B9E_4F8B["下一跳定时器"] ~= nil and _____5B9E_4F8B["下一跳定时器"] ~= 0 then
        local _____5B9A_65F6_5668ID = _____53D6_53E5_67C4ID(_____5B9E_4F8B["下一跳定时器"])
        if _____5B9A_65F6_5668ID > 0 then
            __TS__Delete(_____5B9A_65F6_5668_8DF3_94FE_6620_5C04, _____5B9A_65F6_5668ID)
        end
        safeDestroyTimer(_____5B9E_4F8B["下一跳定时器"])
        _____5B9E_4F8B["下一跳定时器"] = nil
    end
    __TS__Delete(_____6D3B_8DC3_8DF3_94FE_6620_5C04, _____5B9E_4F8B.id)
    local _____7ED3_675F_56DE_8C03 = _____5B9E_4F8B["参数"]["结束回调"]
    if _____7ED3_675F_56DE_8C03 ~= nil then
        _____7ED3_675F_56DE_8C03(_____539F_56E0, _____5B9E_4F8B["已完成跳数"], _____5B9E_4F8B.id)
    end
end
function _____6267_884C_5F53_524D_4E00_8DF3(_____5B9E_4F8B)
    if _____5B9E_4F8B["已结束"] then
        return
    end
    local _____5F53_524D_76EE_6807 = _____5B9E_4F8B["当前目标"]
    if not isValidUnit(_____5F53_524D_76EE_6807) then
        _____7ED3_675F_8DF3_94FE_5B9E_4F8B(_____5B9E_4F8B, _____5B9E_4F8B["已完成跳数"] > 0 and "完成" or "初始目标无效")
        return
    end
    if _____5B9E_4F8B["上一跳目标"] ~= nil then
        _____521B_5EFA_8DF3_94FE_95EA_7535(_____5B9E_4F8B["上一跳目标"], _____5F53_524D_76EE_6807, _____5B9E_4F8B["参数"]["闪电效果代码"] or _____9ED8_8BA4_95EA_7535_6548_679C_4EE3_7801, _____5B9E_4F8B["参数"]["闪电持续时间"] ~= nil and _____5B9E_4F8B["参数"]["闪电持续时间"] > 0 and _____5B9E_4F8B["参数"]["闪电持续时间"] or 0.8)
    elseif _____5B9E_4F8B["参数"]["来源单位"] ~= nil and _____5B9E_4F8B["参数"]["来源单位"] ~= 0 then
        _____521B_5EFA_8DF3_94FE_95EA_7535(_____5B9E_4F8B["参数"]["来源单位"], _____5F53_524D_76EE_6807, _____5B9E_4F8B["参数"]["闪电效果代码"] or _____9ED8_8BA4_95EA_7535_6548_679C_4EE3_7801, _____5B9E_4F8B["参数"]["闪电持续时间"] ~= nil and _____5B9E_4F8B["参数"]["闪电持续时间"] > 0 and _____5B9E_4F8B["参数"]["闪电持续时间"] or 0.8)
    end
    local _____6A21_5F0F = _____5B9E_4F8B["参数"]["模式"] or "伤害"
    if _____6A21_5F0F == "治疗" then
        local ____doHeal_5 = doHeal
        local ____5B9E_4F8B__53C2_6570__6765_6E90_5355_4F4D_4 = _____5B9E_4F8B["参数"]["来源单位"]
        if ____5B9E_4F8B__53C2_6570__6765_6E90_5355_4F4D_4 == nil then
            ____5B9E_4F8B__53C2_6570__6765_6E90_5355_4F4D_4 = _____5F53_524D_76EE_6807
        end
        ____doHeal_5({
            HealSource = ____5B9E_4F8B__53C2_6570__6765_6E90_5355_4F4D_4,
            HealTarget = _____5F53_524D_76EE_6807,
            HealAmount = _____5B9E_4F8B["当前数值"],
            ItemHeal = false,
            HealEffect = false,
            HealEffectPath = _____5B9E_4F8B["参数"]["治疗特效路径"]
        })
    else
        local ____5B9E_4F8B__53C2_6570__6765_6E90_5355_4F4D_6 = _____5B9E_4F8B["参数"]["来源单位"]
        if ____5B9E_4F8B__53C2_6570__6765_6E90_5355_4F4D_6 == nil then
            ____5B9E_4F8B__53C2_6570__6765_6E90_5355_4F4D_6 = _____5F53_524D_76EE_6807
        end
        UnitDamageTarget(
            ____5B9E_4F8B__53C2_6570__6765_6E90_5355_4F4D_6,
            _____5F53_524D_76EE_6807,
            _____5B9E_4F8B["当前数值"],
            false,
            false,
            ATTACK_TYPE_NORMAL,
            DAMAGE_TYPE_NORMAL,
            WEAPON_TYPE_WHOKNOWS
        )
    end
    local _____5F53_524D_76EE_6807ID = _____53D6_53E5_67C4ID(_____5F53_524D_76EE_6807)
    if _____5F53_524D_76EE_6807ID > 0 then
        _____5B9E_4F8B["已命中单位"][_____5F53_524D_76EE_6807ID] = true
    end
    _____5B9E_4F8B["已完成跳数"] = _____5B9E_4F8B["已完成跳数"] + 1
    local _____6BCF_8DF3_56DE_8C03 = _____5B9E_4F8B["参数"]["每跳回调"]
    if _____6BCF_8DF3_56DE_8C03 ~= nil then
        _____6BCF_8DF3_56DE_8C03(_____5F53_524D_76EE_6807, _____5B9E_4F8B["当前数值"], _____5B9E_4F8B["已完成跳数"], _____5B9E_4F8B.id)
    end
    if _____5B9E_4F8B["已完成跳数"] >= _____5B9E_4F8B["参数"]["最大跳数"] then
        _____7ED3_675F_8DF3_94FE_5B9E_4F8B(_____5B9E_4F8B, "完成")
        return
    end
    local _____4E0B_4E00_76EE_6807 = _____67E5_627E_4E0B_4E00_8DF3_76EE_6807(_____5B9E_4F8B, _____5F53_524D_76EE_6807)
    if _____4E0B_4E00_76EE_6807 == nil or _____4E0B_4E00_76EE_6807 == 0 then
        _____7ED3_675F_8DF3_94FE_5B9E_4F8B(_____5B9E_4F8B, _____5B9E_4F8B["已完成跳数"] > 0 and "完成" or "无有效目标")
        return
    end
    local _____8870_51CF = _____5B9E_4F8B["参数"]["每跳衰减系数"] ~= nil and _____5B9E_4F8B["参数"]["每跳衰减系数"] > 0 and _____5B9E_4F8B["参数"]["每跳衰减系数"] or 1
    _____5B9E_4F8B["上一跳目标"] = _____5F53_524D_76EE_6807
    _____5B9E_4F8B["当前目标"] = _____4E0B_4E00_76EE_6807
    _____5B9E_4F8B["当前数值"] = _____5B9E_4F8B["当前数值"] * _____8870_51CF
    local _____8DF3_8DC3_95F4_9694 = _____5B9E_4F8B["参数"]["跳跃间隔"] ~= nil and _____5B9E_4F8B["参数"]["跳跃间隔"] > 0 and _____5B9E_4F8B["参数"]["跳跃间隔"] or 0
    if _____8DF3_8DC3_95F4_9694 <= 0 then
        _____6267_884C_5F53_524D_4E00_8DF3(_____5B9E_4F8B)
        return
    end
    local timer = CreateTimer()
    if timer == nil or timer == 0 then
        _____6267_884C_5F53_524D_4E00_8DF3(_____5B9E_4F8B)
        return
    end
    local _____5B9A_65F6_5668ID = _____53D6_53E5_67C4ID(timer)
    if _____5B9A_65F6_5668ID <= 0 then
        safeDestroyTimer(timer)
        _____6267_884C_5F53_524D_4E00_8DF3(_____5B9E_4F8B)
        return
    end
    _____5B9E_4F8B["下一跳定时器"] = timer
    _____5B9A_65F6_5668_8DF3_94FE_6620_5C04[_____5B9A_65F6_5668ID] = _____5B9E_4F8B.id
    safeTimerStart(timer, _____8DF3_8DC3_95F4_9694, false, ____on_7EAF_8DF3_94FE_4E0B_4E00_8DF3_5230_65F6)
end
function ____on_7EAF_8DF3_94FE_4E0B_4E00_8DF3_5230_65F6()
    local timer = GetExpiredTimer()
    if timer == nil or timer == 0 then
        return
    end
    local _____5B9A_65F6_5668ID = _____53D6_53E5_67C4ID(timer)
    local _____8DF3_94FEID = _____5B9A_65F6_5668_8DF3_94FE_6620_5C04[_____5B9A_65F6_5668ID]
    __TS__Delete(_____5B9A_65F6_5668_8DF3_94FE_6620_5C04, _____5B9A_65F6_5668ID)
    safeDestroyTimer(timer)
    if _____8DF3_94FEID == nil or _____8DF3_94FEID <= 0 then
        return
    end
    local _____5B9E_4F8B = _____6D3B_8DC3_8DF3_94FE_6620_5C04[_____8DF3_94FEID]
    if _____5B9E_4F8B == nil or _____5B9E_4F8B["已结束"] then
        return
    end
    _____5B9E_4F8B["下一跳定时器"] = nil
    _____6267_884C_5F53_524D_4E00_8DF3(_____5B9E_4F8B)
end
--- 纯跳链系统
-- 
-- 说明：
-- 1. 用于闪电链、治疗波、跳火等“不需要飞行物”的链式技能。
-- 2. 核心职责是：命中当前目标、查找下一跳、控制跳数/距离/衰减。
-- 3. 闪电表现独立于弹幕系统，不依赖飞行轨迹。
local jass = require("jass.common")
CreateTimer = jass.CreateTimer
GetExpiredTimer = jass.GetExpiredTimer
GetHandleId = jass.GetHandleId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
UnitDamageTarget = jass.UnitDamageTarget
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
safeTimerStart = ____require_result_0.safeTimerStart
safeDestroyTimer = ____require_result_0.safeDestroyTimer
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
isUnitEnemy = ____require_result_1.isUnitEnemy
isUnitAlly = ____require_result_1.isUnitAlly
isValidUnit = ____require_result_1.isValidUnit
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
doHeal = ____require_result_2.doHeal
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.02．选目标模板.00．目标筛选模板")
_____9009_62E9_8303_56F4_5185_6700_8FD1_76EE_6807 = ____require_result_3["选择范围内最近目标"]
_____9ED8_8BA4_95EA_7535_6548_679C_4EE3_7801 = "CLPB"
_____6D3B_8DC3_8DF3_94FE_6620_5C04 = {}
_____5B9A_65F6_5668_8DF3_94FE_6620_5C04 = {}
local _____4E0B_4E00_4E2A_8DF3_94FEID = 0
local _____7EAF_8DF3_94FE_5B9E_4F8B_5B9E_73B0 = __TS__Class()
_____7EAF_8DF3_94FE_5B9E_4F8B_5B9E_73B0.name = "纯跳链实例实现"
function _____7EAF_8DF3_94FE_5B9E_4F8B_5B9E_73B0.prototype.____constructor(self, _____8DF3_94FEID)
    self["跳链ID"] = _____8DF3_94FEID
end
_____7EAF_8DF3_94FE_5B9E_4F8B_5B9E_73B0.prototype["中断"] = function(self)
    local _____5B9E_4F8B = _____6D3B_8DC3_8DF3_94FE_6620_5C04[self["跳链ID"]]
    if _____5B9E_4F8B == nil then
        return
    end
    _____7ED3_675F_8DF3_94FE_5B9E_4F8B(_____5B9E_4F8B, "中断")
end
____exports["开始纯跳链"] = function(_____53C2_6570)
    if _____53C2_6570["起始目标"] == nil or _____53C2_6570["起始目标"] == 0 then
        return nil
    end
    if _____53C2_6570["最大跳数"] <= 0 then
        return nil
    end
    if _____53C2_6570["每跳最大距离"] <= 0 then
        return nil
    end
    if _____53C2_6570["初始数值"] <= 0 then
        return nil
    end
    if not isValidUnit(_____53C2_6570["起始目标"]) then
        return nil
    end
    local _____6A21_5F0F = _____53C2_6570["模式"] or "伤害"
    local _____5F71_54CD_76EE_6807 = _____53C2_6570["影响目标"] or (_____6A21_5F0F == "治疗" and "友方" or "敌方")
    if not _____5355_4F4D_6EE1_8DB3_5F71_54CD_76EE_6807(_____53C2_6570["起始目标"], _____53C2_6570["来源单位"], _____5F71_54CD_76EE_6807) then
        return nil
    end
    if _____53C2_6570["目标筛选"] ~= nil and not _____53C2_6570["目标筛选"](_____53C2_6570["起始目标"], _____53C2_6570["起始目标"], 0) then
        return nil
    end
    _____4E0B_4E00_4E2A_8DF3_94FEID = _____4E0B_4E00_4E2A_8DF3_94FEID + 1
    local _____8DF3_94FEID = _____4E0B_4E00_4E2A_8DF3_94FEID
    local _____5B9E_4F8B = {
        id = _____8DF3_94FEID,
        ["参数"] = _____53C2_6570,
        ["当前目标"] = _____53C2_6570["起始目标"],
        ["上一跳目标"] = nil,
        ["当前数值"] = _____53C2_6570["初始数值"],
        ["已完成跳数"] = 0,
        ["已命中单位"] = {},
        ["下一跳定时器"] = nil,
        ["待执行下一目标"] = nil,
        ["已结束"] = false
    }
    _____6D3B_8DC3_8DF3_94FE_6620_5C04[_____8DF3_94FEID] = _____5B9E_4F8B
    _____6267_884C_5F53_524D_4E00_8DF3(_____5B9E_4F8B)
    return _____6D3B_8DC3_8DF3_94FE_6620_5C04[_____8DF3_94FEID] ~= nil and __TS__New(_____7EAF_8DF3_94FE_5B9E_4F8B_5B9E_73B0, _____8DF3_94FEID) or nil
end
____exports["停止纯跳链"] = function(_____8DF3_94FEID)
    local _____5B9E_4F8B = _____6D3B_8DC3_8DF3_94FE_6620_5C04[_____8DF3_94FEID]
    if _____5B9E_4F8B == nil then
        return false
    end
    _____7ED3_675F_8DF3_94FE_5B9E_4F8B(_____5B9E_4F8B, "中断")
    return true
end
return ____exports
