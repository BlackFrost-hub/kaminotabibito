local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____6E05_9664_6D88_8017_53CD_51FB_72B6_6001, _____64AD_653E_9632_5FA1_59FF_6001_7279_6548, _____5C1D_8BD5_64AD_653E_6811_9B54_9996_9886_5173_952E_602A_53EB, ____on_6811_9B54_9996_9886_6D88_8017_53CD_51FB_751F_6548, GetUnitTypeId, GetUnitX, GetUnitY, GetHandleId, addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback, getServerTime, _____5F00_59CB_786C_76F4, _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B, createTimedEffect, _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID, _____6D88_8017_53CD_51FB_6280_80FDID, _____6D88_8017_53CD_51FB_72B6_6001_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.00．配置")
local _____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["树魔首领单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建树魔首领上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.02．数值与表现配置")
local _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔首领数值与表现配置"]
local _____6811_9B54_9996_9886_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔首领音效配置"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.08．台词播放")
local _____64AD_653E_6811_9B54_9996_9886_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放树魔首领台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60 = ____00_FF0EBoss_97F3_6548_64AD_653E["尝试播放Boss拟声池"]
local ____08_FF0E_65B9_4F4D_5224_5B9A_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.08．方位判定工具")
local _____4E24_70B9_65B9_5411_89D2 = ____08_FF0E_65B9_4F4D_5224_5B9A_5DE5_5177["两点方向角"]
local _____5355_4F4D_662F_5426_5728_6765_6E90_6B63_9762_6247_533A = ____08_FF0E_65B9_4F4D_5224_5B9A_5DE5_5177["单位是否在来源正面扇区"]
local _____5355_4F4D_662F_5426_5728_6765_6E90_80CC_540E_6247_533A = ____08_FF0E_65B9_4F4D_5224_5B9A_5DE5_5177["单位是否在来源背后扇区"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____63D0_4EA4_9884_8BA1_7B97BossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["提交预计算BossAOE技能伤害"]
function _____6E05_9664_6D88_8017_53CD_51FB_72B6_6001(boss)
    local hid = GetHandleId(boss) or 0
    local state = _____6D88_8017_53CD_51FB_72B6_6001_8868[hid]
    if state == nil then
        return
    end
    if state["特效回调ID"] ~= 0 then
        removePeriodicCallback(state["特效回调ID"])
    end
    if state["结束回调ID"] ~= 0 then
        removeDelayedCallback(state["结束回调ID"])
    end
    __TS__Delete(_____6D88_8017_53CD_51FB_72B6_6001_8868, hid)
    if _____5355_4F4D_6709_6548(boss) then
        _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({
            ["单位"] = boss,
            ["动画编号"] = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]["恢复动画编号"],
            ["动画速度"] = 1,
            ["持续秒"] = 0,
            ["恢复动画编号"] = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]["恢复动画编号"]
        })
    end
end
function _____64AD_653E_9632_5FA1_59FF_6001_7279_6548(boss)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]
    createTimedEffect(
        cfg["防御特效路径"],
        GetUnitX(boss),
        GetUnitY(boss),
        0,
        cfg["防御特效持续秒"]
    )
end
function _____5C1D_8BD5_64AD_653E_6811_9B54_9996_9886_5173_952E_602A_53EB(boss)
    local soundCfg = _____6811_9B54_9996_9886_97F3_6548_914D_7F6E
    _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60({
        ["标识"] = soundCfg["怪物拟声"]["标识"],
        ["音效路径列表"] = soundCfg["怪物拟声"]["音效路径列表"],
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["裁断距离"] = soundCfg["默认裁断距离"],
        ["冷却Ms"] = soundCfg["怪物拟声"]["冷却Ms"],
        ["触发概率百分比"] = soundCfg["怪物拟声"]["关键机制触发概率百分比"]
    })
end
____exports["释放树魔首领消耗反击"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]
    local hid = GetHandleId(boss) or 0
    if hid == 0 then
        return
    end
    _____6E05_9664_6D88_8017_53CD_51FB_72B6_6001(boss)
    _____64AD_653E_6811_9B54_9996_9886_53F0_8BCD(boss, "消耗反击")
    _____5C1D_8BD5_64AD_653E_6811_9B54_9996_9886_5173_952E_602A_53EB(boss)
    _____5F00_59CB_786C_76F4(boss, cfg["持续秒"])
    _____64AD_653E_9632_5FA1_59FF_6001_7279_6548(boss)
    local state = {
        Boss = boss,
        ["上下文"] = context,
        ["到期Ms"] = getServerTime() + cfg["持续秒"] * 1000,
        ["结束回调ID"] = 0,
        ["特效回调ID"] = 0
    }
    _____6D88_8017_53CD_51FB_72B6_6001_8868[hid] = state
    local ____self_10 = context["清理"]
    ____self_10["登记清理"](____self_10, "树魔首领-消耗反击状态", _____6E05_9664_6D88_8017_53CD_51FB_72B6_6001, boss)
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({
        ["单位"] = boss,
        ["动画编号"] = cfg["起手动画编号"],
        ["动画速度"] = cfg["动画速度"],
        ["持续秒"] = cfg["起手动画原始时长秒"],
        ["恢复动画编号"] = cfg["维持动画编号"],
        ["完成回调"] = function()
            if _____6D88_8017_53CD_51FB_72B6_6001_8868[hid] ~= state then
                return
            end
            _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({
                ["单位"] = boss,
                ["动画编号"] = cfg["维持动画编号"],
                ["动画速度"] = cfg["动画速度"],
                ["持续秒"] = cfg["持续秒"] - cfg["起手动画原始时长秒"],
                ["恢复动画编号"] = cfg["恢复动画编号"]
            })
        end
    })
    state["特效回调ID"] = addPeriodicCallback(
        cfg["防御特效刷新毫秒"],
        function()
            if not _____5355_4F4D_6709_6548(boss) or getServerTime() >= state["到期Ms"] then
                return
            end
            _____64AD_653E_9632_5FA1_59FF_6001_7279_6548(boss)
        end
    )
    state["结束回调ID"] = addDelayedCallback(
        cfg["持续秒"] * 1000,
        function()
            _____6E05_9664_6D88_8017_53CD_51FB_72B6_6001(boss)
        end
    )
end
function ____on_6811_9B54_9996_9886_6D88_8017_53CD_51FB_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____6D88_8017_53CD_51FB_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放树魔首领消耗反击"](context)
end
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____521B_5EFA_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_0["创建技能伤害实例"]
local _____7ED3_675F_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_0["结束技能伤害实例"]
local jass = require("jass.common")
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetHandleId = jass.GetHandleId
local SetUnitFacing = jass.SetUnitFacing
local IsUnitType = jass.IsUnitType
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local AddLightning = jass.AddLightning
local DestroyLightning = jass.DestroyLightning
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_1["读取单位攻击力"]
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.06．魔法恢复")
local _____9B54_6CD5_589E_51CF = ____require_result_2["魔法增减"]
local ____require_result_3 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_3.registerDamageModifier
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_4.addDelayedCallback
removeDelayedCallback = ____require_result_4.removeDelayedCallback
addPeriodicCallback = ____require_result_4.addPeriodicCallback
removePeriodicCallback = ____require_result_4.removePeriodicCallback
getServerTime = ____require_result_4.getServerTime
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
_____5F00_59CB_786C_76F4 = ____require_result_5["开始硬直"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
_____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____require_result_6["播放限时单位动画"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_7["创建原生弹幕"]
local _____9500_6BC1_539F_751F_5F39_5E55 = ____require_result_7["销毁原生弹幕"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
createTimedEffect = ____require_result_8.createTimedEffect
local createTimedUnitEffect = ____require_result_8.createTimedUnitEffect
_____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID = stringToFourCC(_____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____6D88_8017_53CD_51FB_6280_80FDID = stringToFourCC(_____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]["技能槽位"])
_____6D88_8017_53CD_51FB_72B6_6001_8868 = {}
local _____53CD_51FB_51B2_51FB_6CE2_72B6_6001_8868 = {}
local _____6D88_8017_53CD_51FB_5DF2_6CE8_518C = false
local function _____53D6_65B9_5411_89D2(from, to)
    return _____4E24_70B9_65B9_5411_89D2(
        GetUnitX(from),
        GetUnitY(from),
        GetUnitX(to),
        GetUnitY(to)
    )
end
local function _____662F_80CC_540E_7834_62DB_89D2_5EA6(boss, attacker)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]
    return _____5355_4F4D_662F_5426_5728_6765_6E90_80CC_540E_6247_533A(boss, attacker, cfg["背后判定角度"])
end
local function _____662F_6B63_9762_53CD_51FB_89D2_5EA6(boss, attacker)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]
    return _____5355_4F4D_662F_5426_5728_6765_6E90_6B63_9762_6247_533A(boss, attacker, cfg["正面判定角度"])
end
local function _____64AD_653E_62BD_9B54_7279_6548(target)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]
    createTimedUnitEffect(target, "origin", cfg["抽魔特效路径"], 1)
end
local function _____64AD_653E_53CD_51FB_8FDE_7EBF(boss, target)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]
    local lightning = AddLightning(
        cfg["抽魔连线代码"],
        false,
        GetUnitX(boss),
        GetUnitY(boss),
        GetUnitX(target),
        GetUnitY(target)
    )
    if lightning == nil or lightning == 0 then
        return
    end
    addDelayedCallback(
        600,
        function()
            DestroyLightning(lightning)
        end
    )
end
local function ____on_6811_9B54_9996_9886_53CD_51FB_51B2_51FB_6CE2_547D_4E2D(target, _____5F39_5E55ID)
    local state = _____53CD_51FB_51B2_51FB_6CE2_72B6_6001_8868[_____5F39_5E55ID]
    if state == nil or not _____5355_4F4D_6709_6548(state.Boss) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    _____63D0_4EA4_9884_8BA1_7B97BossAOE_6280_80FD_4F24_5BB3({
        ["技能ID"] = _____6D88_8017_53CD_51FB_6280_80FDID,
        ["技能实例ID"] = state["技能实例ID"],
        ["来源"] = state.Boss,
        ["目标"] = target,
        ["伤害"] = state["伤害"],
        attack = true,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE
    })
end
local function ____on_6811_9B54_9996_9886_53CD_51FB_51B2_51FB_6CE2_7ED3_675F(______539F_56E0, _____5F39_5E55ID)
    local state = _____53CD_51FB_51B2_51FB_6CE2_72B6_6001_8868[_____5F39_5E55ID]
    __TS__Delete(_____53CD_51FB_51B2_51FB_6CE2_72B6_6001_8868, _____5F39_5E55ID)
    if state ~= nil then
        _____7ED3_675F_6280_80FD_4F24_5BB3_5B9E_4F8B(state["技能实例ID"])
    end
end
local function _____6E05_7406_6811_9B54_9996_9886_53CD_51FB_51B2_51FB_6CE2(_____5F39_5E55ID)
    if _____5F39_5E55ID == nil or _____5F39_5E55ID <= 0 then
        return
    end
    _____9500_6BC1_539F_751F_5F39_5E55(_____5F39_5E55ID, "手动销毁")
end
local function _____53D1_5C04_6811_9B54_9996_9886_53CD_51FB_51B2_51FB_6CE2(context, boss, angle)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]
    local _____4F24_5BB3 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["反击Boss攻击力比例"]
    local _____6280_80FD_5B9E_4F8BID = _____521B_5EFA_6280_80FD_4F24_5BB3_5B9E_4F8B({["技能ID"] = _____6D88_8017_53CD_51FB_6280_80FDID, ["来源类型"] = "Boss技能", ["标签"] = "树魔首领-消耗反击冲击波", ["持续时间秒"] = cfg["反击射程"] / cfg["反击弹道速度"] + 1})
    local _____5F39_5E55 = _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = boss,
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["方向角"] = angle,
        ["速度"] = cfg["反击弹道速度"],
        ["最大距离"] = cfg["反击射程"],
        ["命中半径"] = cfg["反击弹道命中半径"],
        ["影响目标"] = "敌方",
        ["碰撞消失"] = false,
        ["每单位最大命中次数"] = 1,
        ["不可阻挡"] = true,
        ["禁用碰撞"] = true,
        ["显式改向后锁定方向"] = true,
        ["伤害值"] = 0,
        ["伤害形态"] = "AOE",
        ["模型"] = cfg["反击弹道特效路径"],
        ["缩放"] = cfg["反击弹道特效缩放"],
        ["飞行高度"] = cfg["反击弹道飞行高度"],
        ["on命中"] = ____on_6811_9B54_9996_9886_53CD_51FB_51B2_51FB_6CE2_547D_4E2D,
        ["on结束"] = ____on_6811_9B54_9996_9886_53CD_51FB_51B2_51FB_6CE2_7ED3_675F
    })
    if _____5F39_5E55 == nil or _____5F39_5E55["弹幕ID"] == nil or _____5F39_5E55["弹幕ID"] <= 0 then
        _____7ED3_675F_6280_80FD_4F24_5BB3_5B9E_4F8B(_____6280_80FD_5B9E_4F8BID)
        return
    end
    _____53CD_51FB_51B2_51FB_6CE2_72B6_6001_8868[_____5F39_5E55["弹幕ID"]] = {Boss = boss, ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID, ["伤害"] = _____4F24_5BB3}
    local ____self_9 = context["清理"]
    ____self_9["登记清理"](____self_9, "树魔首领-消耗反击冲击波", _____6E05_7406_6811_9B54_9996_9886_53CD_51FB_51B2_51FB_6CE2, _____5F39_5E55["弹幕ID"])
end
local function _____6267_884C_53CD_51FB(state, attacker, _____89E6_53D1_4F24_5BB3)
    local boss = state.Boss
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(attacker) then
        return
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]
    local angle = _____53D6_65B9_5411_89D2(boss, attacker)
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____6811_9B54_9996_9886_97F3_6548_914D_7F6E["消耗反击"]["正面反击"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____6811_9B54_9996_9886_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    SetUnitFacing(boss, angle)
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({
        ["单位"] = boss,
        ["动画编号"] = cfg["反击动画编号"],
        ["动画速度"] = cfg["动画速度"],
        ["持续秒"] = cfg["反击动画原始时长秒"],
        ["恢复动画编号"] = cfg["恢复动画编号"]
    })
    _____64AD_653E_62BD_9B54_7279_6548(attacker)
    _____64AD_653E_53CD_51FB_8FDE_7EBF(boss, attacker)
    _____9B54_6CD5_589E_51CF(attacker, -_____89E6_53D1_4F24_5BB3 * cfg["抽魔伤害比例"], false, false)
    _____53D1_5C04_6811_9B54_9996_9886_53CD_51FB_51B2_51FB_6CE2(state["上下文"], boss, angle)
end
local function _____6811_9B54_9996_9886_6D88_8017_53CD_51FB_4F24_5BB3_4FEE_6B63(damageContext)
    local target = damageContext.target
    local attacker = damageContext.attacker
    if not _____5355_4F4D_6709_6548(target) or not _____5355_4F4D_6709_6548(attacker) then
        return damageContext.currentDamage
    end
    if GetUnitTypeId(target) ~= _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID then
        return damageContext.currentDamage
    end
    local state = _____6D88_8017_53CD_51FB_72B6_6001_8868[GetHandleId(target) or 0]
    if state == nil then
        return damageContext.currentDamage
    end
    if getServerTime() >= state["到期Ms"] then
        _____6E05_9664_6D88_8017_53CD_51FB_72B6_6001(target)
        return damageContext.currentDamage
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["消耗反击"]
    if _____662F_80CC_540E_7834_62DB_89D2_5EA6(target, attacker) then
        _____6E05_9664_6D88_8017_53CD_51FB_72B6_6001(target)
        _____64AD_653EBoss_5750_6807_97F3_6548(
            _____6811_9B54_9996_9886_97F3_6548_914D_7F6E["消耗反击"]["背后破招"],
            GetUnitX(target),
            GetUnitY(target),
            _____6811_9B54_9996_9886_97F3_6548_914D_7F6E["默认裁断距离"]
        )
        _____5F00_59CB_786C_76F4(target, cfg["硬直秒"])
        return damageContext.currentDamage * (1 + cfg["背后增伤比例"])
    end
    if not _____662F_6B63_9762_53CD_51FB_89D2_5EA6(target, attacker) then
        return damageContext.currentDamage
    end
    _____6E05_9664_6D88_8017_53CD_51FB_72B6_6001(target)
    _____6267_884C_53CD_51FB(state, attacker, damageContext.currentDamage)
    return damageContext.currentDamage * (1 - cfg["正面减伤比例"])
end
____exports["注册树魔首领消耗反击"] = function()
    if _____6D88_8017_53CD_51FB_5DF2_6CE8_518C then
        return
    end
    _____6D88_8017_53CD_51FB_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "树魔首领-消耗反击",
        ["单位类型ID"] = _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____6D88_8017_53CD_51FB_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_6811_9B54_9996_9886_6D88_8017_53CD_51FB_751F_6548(boss, _____6D88_8017_53CD_51FB_6280_80FDID)
        end
    })
    registerDamageModifier(_____6811_9B54_9996_9886_6D88_8017_53CD_51FB_4F24_5BB3_4FEE_6B63, 65)
end
return ____exports
