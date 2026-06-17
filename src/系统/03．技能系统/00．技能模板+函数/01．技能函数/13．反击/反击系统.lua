local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____8BA1_7B97_4E24_70B9_8DDD_79BB, _____8DDD_79BB_6EE1_8DB3_6761_4EF6, _____8BA1_7B97_53CD_51FB_4F24_5BB3, _____6267_884C_53CD_51FB_4F24_5BB3, _____64AD_653E_53CD_51FB_7279_6548, _____8BA1_7B97_8DDD_79BB_5E76_68C0_67E5, _____6267_884C_5355_6B21_53CD_51FB, _____6267_884CAOE_53CD_51FB, jass, GetUnitX, GetUnitY, GetHandleId, UnitDamageTarget, AddSpecialEffectTarget, DestroyEffect, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, getEnemyUnitsInRange, getGameTime, debugLogForce, _____53CD_51FB_9ED1_540D_5355
function _____8BA1_7B97_4E24_70B9_8DDD_79BB(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return jass.SquareRoot(dx * dx + dy * dy)
end
function _____8DDD_79BB_6EE1_8DB3_6761_4EF6(_____8DDD_79BB, _____6761_4EF6)
    if _____6761_4EF6["最小距离"] ~= nil and _____8DDD_79BB < _____6761_4EF6["最小距离"] then
        return false
    end
    if _____6761_4EF6["最大距离"] ~= nil and _____8DDD_79BB > _____6761_4EF6["最大距离"] then
        return false
    end
    return true
end
function _____8BA1_7B97_53CD_51FB_4F24_5BB3(_____5B9E_4F8B, _____53D7_5230_4F24_5BB3)
    if _____5B9E_4F8B["参数"]["伤害计算方式"] == ____exports["反击伤害类型"]["百分比"] then
        return _____53D7_5230_4F24_5BB3 * _____5B9E_4F8B["参数"]["伤害值"]
    end
    return _____5B9E_4F8B["参数"]["伤害值"]
end
function _____6267_884C_53CD_51FB_4F24_5BB3(_____53CD_51FB_6765_6E90, _____76EE_6807_5355_4F4D, _____4F24_5BB3_503C, _____53C2_6570)
    if not _____53CD_51FB_6765_6E90 or not _____76EE_6807_5355_4F4D or _____4F24_5BB3_503C <= 0 then
        return
    end
    local _____6765_6E90hid = GetHandleId(_____53CD_51FB_6765_6E90)
    _____53CD_51FB_9ED1_540D_5355[_____6765_6E90hid] = true
    do
        local ____try, ____error = pcall(function()
            local ____array_8 = __TS__SparseArrayNew(
                _____53CD_51FB_6765_6E90,
                _____76EE_6807_5355_4F4D,
                _____4F24_5BB3_503C,
                false,
                false
            )
            local ____53C2_6570__653B_51FB_7C7B_578B_5 = _____53C2_6570["攻击类型"]
            if ____53C2_6570__653B_51FB_7C7B_578B_5 == nil then
                ____53C2_6570__653B_51FB_7C7B_578B_5 = ATTACK_TYPE_NORMAL
            end
            __TS__SparseArrayPush(____array_8, ____53C2_6570__653B_51FB_7C7B_578B_5)
            local ____53C2_6570__4F24_5BB3_7C7B_578B_6 = _____53C2_6570["伤害类型"]
            if ____53C2_6570__4F24_5BB3_7C7B_578B_6 == nil then
                ____53C2_6570__4F24_5BB3_7C7B_578B_6 = DAMAGE_TYPE_NORMAL
            end
            __TS__SparseArrayPush(____array_8, ____53C2_6570__4F24_5BB3_7C7B_578B_6)
            local ____53C2_6570__6B66_5668_7C7B_578B_7 = _____53C2_6570["武器类型"]
            if ____53C2_6570__6B66_5668_7C7B_578B_7 == nil then
                ____53C2_6570__6B66_5668_7C7B_578B_7 = nil
            end
            __TS__SparseArrayPush(____array_8, ____53C2_6570__6B66_5668_7C7B_578B_7)
            UnitDamageTarget(__TS__SparseArraySpread(____array_8))
        end)
        do
            _____53CD_51FB_9ED1_540D_5355[_____6765_6E90hid] = false
        end
        if not ____try then
            error(____error, 0)
        end
    end
end
function _____64AD_653E_53CD_51FB_7279_6548(_____76EE_6807_5355_4F4D, _____7279_6548_8DEF_5F84, _____9644_7740_70B9)
    if not _____7279_6548_8DEF_5F84 or not _____76EE_6807_5355_4F4D then
        return
    end
    local _____5B9E_9645_9644_7740_70B9 = _____9644_7740_70B9 or "origin"
    local eff = AddSpecialEffectTarget(_____7279_6548_8DEF_5F84, _____76EE_6807_5355_4F4D, _____5B9E_9645_9644_7740_70B9)
    if eff ~= nil then
        DestroyEffect(eff)
    end
end
function _____8BA1_7B97_8DDD_79BB_5E76_68C0_67E5(_____5B9E_4F8B, _____53D7_4F24_5355_4F4D, _____4F24_5BB3_6765_6E90)
    local x1 = GetUnitX(_____53D7_4F24_5355_4F4D)
    local y1 = GetUnitY(_____53D7_4F24_5355_4F4D)
    local x2 = GetUnitX(_____4F24_5BB3_6765_6E90)
    local y2 = GetUnitY(_____4F24_5BB3_6765_6E90)
    local _____8DDD_79BB = _____8BA1_7B97_4E24_70B9_8DDD_79BB(x1, y1, x2, y2)
    return _____8DDD_79BB_6EE1_8DB3_6761_4EF6(_____8DDD_79BB, _____5B9E_4F8B["参数"]["距离条件"])
end
function _____6267_884C_5355_6B21_53CD_51FB(_____5B9E_4F8B, _____76EE_6807, _____53D7_5230_4F24_5BB3)
    local _____4F24_5BB3_503C = _____8BA1_7B97_53CD_51FB_4F24_5BB3(_____5B9E_4F8B, _____53D7_5230_4F24_5BB3)
    local _____5F53_524D_65F6_95F4 = getGameTime()
    _____5B9E_4F8B["上次反击时间"] = _____5F53_524D_65F6_95F4
    _____6267_884C_53CD_51FB_4F24_5BB3(_____5B9E_4F8B["参数"]["反击来源"], _____76EE_6807, _____4F24_5BB3_503C, _____5B9E_4F8B["参数"])
    if _____5B9E_4F8B["参数"]["反击特效"] then
        _____64AD_653E_53CD_51FB_7279_6548(_____76EE_6807, _____5B9E_4F8B["参数"]["反击特效"], _____5B9E_4F8B["参数"]["特效附着点"])
    end
    debugLogForce(
        "反击系统",
        "单次反击 目标hid=",
        GetHandleId(_____76EE_6807),
        "伤害=",
        _____4F24_5BB3_503C
    )
end
function _____6267_884CAOE_53CD_51FB(_____5B9E_4F8B, _____53D7_4F24_5355_4F4D, _____4F24_5BB3_6765_6E90, _____53D7_5230_4F24_5BB3)
    if not _____5B9E_4F8B["参数"]["AOE半径"] or _____5B9E_4F8B["参数"]["AOE半径"] <= 0 then
        return
    end
    local x = GetUnitX(_____53D7_4F24_5355_4F4D)
    local y = GetUnitY(_____53D7_4F24_5355_4F4D)
    local _____534A_5F84 = _____5B9E_4F8B["参数"]["AOE半径"]
    debugLogForce(
        "反击系统",
        "AOE反击 中心x=",
        x,
        "y=",
        y,
        "半径=",
        _____534A_5F84
    )
    local _____76EE_6807_5217_8868 = getEnemyUnitsInRange(_____53D7_4F24_5355_4F4D, x, y, _____534A_5F84)
    if not _____76EE_6807_5217_8868 or #_____76EE_6807_5217_8868 == 0 then
        return
    end
    local _____4F24_5BB3_503C = _____8BA1_7B97_53CD_51FB_4F24_5BB3(_____5B9E_4F8B, _____53D7_5230_4F24_5BB3)
    local _____5F53_524D_65F6_95F4 = getGameTime()
    _____5B9E_4F8B["上次反击时间"] = _____5F53_524D_65F6_95F4
    for ____, _____76EE_6807 in ipairs(_____76EE_6807_5217_8868) do
        do
            if _____76EE_6807 == _____53D7_4F24_5355_4F4D then
                goto __continue42
            end
            if not _____8BA1_7B97_8DDD_79BB_5E76_68C0_67E5(_____5B9E_4F8B, _____53D7_4F24_5355_4F4D, _____76EE_6807) then
                goto __continue42
            end
            _____6267_884C_53CD_51FB_4F24_5BB3(_____5B9E_4F8B["参数"]["反击来源"], _____76EE_6807, _____4F24_5BB3_503C, _____5B9E_4F8B["参数"])
            if _____5B9E_4F8B["参数"]["反击特效"] then
                _____64AD_653E_53CD_51FB_7279_6548(_____76EE_6807, _____5B9E_4F8B["参数"]["反击特效"], _____5B9E_4F8B["参数"]["特效附着点"])
            end
            debugLogForce(
                "反击系统",
                "AOE反击目标 hid=",
                GetHandleId(_____76EE_6807),
                "伤害=",
                _____4F24_5BB3_503C
            )
        end
        ::__continue42::
    end
end
jass = require("jass.common")
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
UnitDamageTarget = jass.UnitDamageTarget
AddSpecialEffectTarget = jass.AddSpecialEffectTarget
DestroyEffect = jass.DestroyEffect
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
getEnemyUnitsInRange = ____require_result_1.getEnemyUnitsInRange
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
getGameTime = ____require_result_2.getGameTime
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.08．同类伤害类型")
local _____83B7_53D6_540C_7C7B_4F24_5BB3_7C7B_578B = ____require_result_3["获取同类伤害类型"]
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.index")
debugLogForce = ____require_result_4.debugLogForce
--- 反击类型
____exports["反击类型"] = ____exports["反击类型"] or ({})
____exports["反击类型"]["任意伤害"] = 0
____exports["反击类型"][____exports["反击类型"]["任意伤害"]] = "任意伤害"
____exports["反击类型"]["仅攻击"] = 1
____exports["反击类型"][____exports["反击类型"]["仅攻击"]] = "仅攻击"
--- 伤害计算方式
____exports["反击伤害类型"] = ____exports["反击伤害类型"] or ({})
____exports["反击伤害类型"]["固定值"] = 0
____exports["反击伤害类型"][____exports["反击伤害类型"]["固定值"]] = "固定值"
____exports["反击伤害类型"]["百分比"] = 1
____exports["反击伤害类型"][____exports["反击伤害类型"]["百分比"]] = "百分比"
--- 反击实例映射：单位handleId -> 反击实例数组
local _____53CD_51FB_5B9E_4F8B_6620_5C04 = {}
_____53CD_51FB_9ED1_540D_5355 = {}
--- 系统是否已初始化
local _____7CFB_7EDF_5DF2_521D_59CB_5316 = false
--- 当前正在处理的伤害事件（用于同类伤害检测）
local _____5F53_524D_4F24_5BB3_7C7B_578B_5FEB_7167 = nil
--- 检查单位是否在冷却中
local function _____5728_51B7_5374_4E2D(_____5B9E_4F8B)
    if _____5B9E_4F8B["参数"]["冷却时间"] == nil or _____5B9E_4F8B["参数"]["冷却时间"] <= 0 then
        return false
    end
    local _____5F53_524D_65F6_95F4 = getGameTime()
    return _____5F53_524D_65F6_95F4 - _____5B9E_4F8B["上次反击时间"] < _____5B9E_4F8B["参数"]["冷却时间"]
end
--- 判断是否应该触发反击
local function _____5E94_8BE5_89E6_53D1_53CD_51FB(_____5B9E_4F8B, _____662F_5426_666E_653B)
    if _____5B9E_4F8B["参数"]["反击类型"] == ____exports["反击类型"]["仅攻击"] then
        return _____662F_5426_666E_653B == true
    end
    return true
end
--- 伤害事件回调 - 在最终伤害应用后触发
-- 使用 registerAppliedFinalDamageListener 确保捕获所有伤害
local function onFinalDamageApplied(target, attacker, applied, snapshot)
    if not target or applied <= 0 then
        return
    end
    local targetHid = GetHandleId(target)
    local _____5B9E_4F8B_5217_8868 = _____53CD_51FB_5B9E_4F8B_6620_5C04[targetHid]
    if not _____5B9E_4F8B_5217_8868 or #_____5B9E_4F8B_5217_8868 == 0 then
        return
    end
    debugLogForce(
        "反击系统",
        "伤害回调触发 targetHid=",
        targetHid,
        "attackerHid=",
        attacker and GetHandleId(attacker) or 0,
        "applied=",
        applied
    )
    if attacker then
        local attackerHid = GetHandleId(attacker)
        if _____53CD_51FB_9ED1_540D_5355[attackerHid] == true then
            debugLogForce("反击系统", "跳过黑名单单位 hid=", attackerHid)
            return
        end
    end
    local _____5F53_524D_4F24_5BB3_7C7B_578B = _____83B7_53D6_540C_7C7B_4F24_5BB3_7C7B_578B(snapshot)
    local isNormalAtk = snapshot.isNormalAttack == true
    for ____, _____5B9E_4F8B in ipairs(_____5B9E_4F8B_5217_8868) do
        do
            local _____53C2_6570 = _____5B9E_4F8B["参数"]
            if not _____5E94_8BE5_89E6_53D1_53CD_51FB(_____5B9E_4F8B, isNormalAtk) then
                goto __continue24
            end
            if _____5728_51B7_5374_4E2D(_____5B9E_4F8B) then
                goto __continue24
            end
            if _____53C2_6570["伤害类型"] ~= nil then
                local _____53CD_51FB_4F24_5BB3_7C7B_578B = _____83B7_53D6_540C_7C7B_4F24_5BB3_7C7B_578B(snapshot)
                if _____53CD_51FB_4F24_5BB3_7C7B_578B["伤害类型"] == _____53C2_6570["伤害类型"] then
                    debugLogForce("反击系统", "同类伤害类型，跳过")
                    goto __continue24
                end
            end
            if _____53C2_6570["只反击来源"] then
                if not attacker then
                    goto __continue24
                end
                if not _____8BA1_7B97_8DDD_79BB_5E76_68C0_67E5(_____5B9E_4F8B, target, attacker) then
                    goto __continue24
                end
                _____6267_884C_5355_6B21_53CD_51FB(_____5B9E_4F8B, attacker, applied)
                goto __continue24
            end
            if _____53C2_6570["是否AOE"] and _____53C2_6570["AOE半径"] ~= nil and _____53C2_6570["AOE半径"] > 0 then
                _____6267_884CAOE_53CD_51FB(_____5B9E_4F8B, target, attacker, applied)
                goto __continue24
            end
            if attacker then
                if not _____8BA1_7B97_8DDD_79BB_5E76_68C0_67E5(_____5B9E_4F8B, target, attacker) then
                    goto __continue24
                end
                _____6267_884C_5355_6B21_53CD_51FB(_____5B9E_4F8B, attacker, applied)
            end
        end
        ::__continue24::
    end
end
--- 初始化系统（注册回调）
local function _____521D_59CB_5316_7CFB_7EDF()
    if _____7CFB_7EDF_5DF2_521D_59CB_5316 then
        return
    end
    _____7CFB_7EDF_5DF2_521D_59CB_5316 = true
    registerAppliedFinalDamageListener(onFinalDamageApplied)
    debugLogForce("反击系统", "系统已初始化")
end
--- 注册反击
-- 
-- @param 参数 反击参数
-- @returns 反击实例ID（单位handleId），失败返回0
____exports["注册反击"] = function(_____53C2_6570)
    if not _____53C2_6570["反击来源"] then
        debugLogForce("反击系统", "错误：反击来源为空")
        return 0
    end
    _____521D_59CB_5316_7CFB_7EDF()
    local _____53CD_51FB_6765_6E90 = _____53C2_6570["反击来源"]
    local hid = GetHandleId(_____53CD_51FB_6765_6E90)
    if not _____53CD_51FB_5B9E_4F8B_6620_5C04[hid] then
        _____53CD_51FB_5B9E_4F8B_6620_5C04[hid] = {}
    end
    local ____53C2_6570_11 = _____53C2_6570
    local ____temp_12 = _____53C2_6570["反击类型"] or ____exports["反击类型"]["任意伤害"]
    local ____temp_13 = _____53C2_6570["伤害计算方式"] or ____exports["反击伤害类型"]["固定值"]
    local ____temp_14 = _____53C2_6570["距离条件"] or ({})
    local ____53C2_6570__662F_5426AOE_9 = _____53C2_6570["是否AOE"]
    if ____53C2_6570__662F_5426AOE_9 == nil then
        ____53C2_6570__662F_5426AOE_9 = false
    end
    local ____53C2_6570__53EA_53CD_51FB_6765_6E90_10 = _____53C2_6570["只反击来源"]
    if ____53C2_6570__53EA_53CD_51FB_6765_6E90_10 == nil then
        ____53C2_6570__53EA_53CD_51FB_6765_6E90_10 = true
    end
    local _____5B9E_4F8B = {
        ["参数"] = __TS__ObjectAssign({}, ____53C2_6570_11, {
            ["反击类型"] = ____temp_12,
            ["伤害计算方式"] = ____temp_13,
            ["距离条件"] = ____temp_14,
            ["是否AOE"] = ____53C2_6570__662F_5426AOE_9,
            ["只反击来源"] = ____53C2_6570__53EA_53CD_51FB_6765_6E90_10
        }),
        ["上次反击时间"] = 0
    }
    local ____53CD_51FB_5B9E_4F8B_6620_5C04_hid_15 = _____53CD_51FB_5B9E_4F8B_6620_5C04[hid]
    ____53CD_51FB_5B9E_4F8B_6620_5C04_hid_15[#____53CD_51FB_5B9E_4F8B_6620_5C04_hid_15 + 1] = _____5B9E_4F8B
    debugLogForce(
        "反击系统",
        "注册成功 单位hid=",
        hid,
        "伤害值=",
        _____53C2_6570["伤害值"],
        "是否AOE=",
        _____53C2_6570["是否AOE"]
    )
    return hid
end
--- 移除单位的所有反击
-- 
-- @param 单位 反击来源单位
____exports["移除反击"] = function(_____5355_4F4D)
    if not _____5355_4F4D then
        return
    end
    local hid = GetHandleId(_____5355_4F4D)
    _____53CD_51FB_5B9E_4F8B_6620_5C04[hid] = {}
    debugLogForce("反击系统", "移除反击 单位hid=", hid)
end
--- 移除单位的特定反击（根据索引）
-- 
-- @param 单位 反击来源单位
-- @param 索引 反击实例索引
____exports["移除特定反击"] = function(_____5355_4F4D, _____7D22_5F15)
    if not _____5355_4F4D then
        return
    end
    local hid = GetHandleId(_____5355_4F4D)
    local _____5217_8868 = _____53CD_51FB_5B9E_4F8B_6620_5C04[hid]
    if not _____5217_8868 or #_____5217_8868 <= _____7D22_5F15 then
        return
    end
    __TS__ArraySplice(_____5217_8868, _____7D22_5F15, 1)
    debugLogForce(
        "反击系统",
        "移除特定反击 单位hid=",
        hid,
        "索引=",
        _____7D22_5F15
    )
end
--- 获取单位的反击数量
-- 
-- @param 单位 反击来源单位
-- @returns 反击实例数量
____exports["获取反击数量"] = function(_____5355_4F4D)
    if not _____5355_4F4D then
        return 0
    end
    local hid = GetHandleId(_____5355_4F4D)
    local _____5217_8868 = _____53CD_51FB_5B9E_4F8B_6620_5C04[hid]
    return _____5217_8868 ~= nil and #_____5217_8868 or 0
end
return ____exports
