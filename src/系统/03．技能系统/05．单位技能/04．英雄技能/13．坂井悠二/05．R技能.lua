local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____53D6_5355_4F4D_53E5_67C4ID, _____6E05_7406R_4E0A_4E0B_6587, _____7ED3_7B97R_5355_6B21_4F24_5BB3, _____6E05_7406R_5230_671F, jass, _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3, _____83B7_53D6_8303_56F4_654C_519B, removeDelayedCallback, removePeriodicCallback, GetHandleId, GetOwningPlayer, RemoveUnit, stringToFourCC, UnitRemoveAbility, SetPlayerAbilityAvailable, _____914D_7F6E, ____R_6280_80FDID_5B57_7B26_4E32, ____R_65E5_5FD7_6A21_5757, _____4E0A_4E0B_6587_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.13．坂井悠二.00．配置")
local _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["坂井悠二技能配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local ____04_FF0E_8C03_8BD5_8F93_51FA = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.04．调试输出")
local _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA = ____04_FF0E_8C03_8BD5_8F93_51FA["技能强制调试输出"]
function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
function _____6E05_7406R_4E0A_4E0B_6587(context)
    if context["周期回调ID"] ~= 0 then
        removePeriodicCallback(context["周期回调ID"])
        context["周期回调ID"] = 0
    end
    if context["清理回调ID"] ~= 0 then
        removeDelayedCallback(context["清理回调ID"])
        context["清理回调ID"] = 0
    end
    if context["神门单位"] ~= nil and context["神门单位"] ~= 0 then
        RemoveUnit(context["神门单位"])
        context["神门单位"] = nil
    end
    local caster = context["施法者"]
    if context["已切二段"] and caster ~= nil and caster ~= 0 and _____5355_4F4D_5B58_6D3B(caster) then
        UnitRemoveAbility(caster, _____914D_7F6E["二段"]["技能类型ID"])
        SetPlayerAbilityAvailable(
            GetOwningPlayer(caster),
            _____914D_7F6E["技能类型ID"],
            true
        )
    end
    context["已切二段"] = false
    context["已启动"] = false
    local id = _____53D6_5355_4F4D_53E5_67C4ID(context["施法者"])
    if id ~= 0 and _____4E0A_4E0B_6587_8868[id] == context then
        __TS__Delete(_____4E0A_4E0B_6587_8868, id)
    end
end
function _____7ED3_7B97R_5355_6B21_4F24_5BB3(payload)
    if payload == nil then
        return
    end
    local ctx = payload.ctx
    local _____843D_70B9X = payload["落点X"]
    local _____843D_70B9Y = payload["落点Y"]
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(____R_65E5_5FD7_6A21_5757, "结算跳过：施法者无效/死亡")
        return
    end
    local _____5355_6B21_4F24_5BB3 = ctx["伤害攻击力快照"] * _____914D_7F6E["周期"]["单次伤害攻击力倍率"]
    if _____5355_6B21_4F24_5BB3 <= 0 then
        _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
            ____R_65E5_5FD7_6A21_5757,
            "结算跳过：伤害<=0",
            "快照",
            ctx["伤害攻击力快照"],
            "倍率",
            _____914D_7F6E["周期"]["单次伤害攻击力倍率"]
        )
        return
    end
    local _____654C_519B_5217_8868 = _____83B7_53D6_8303_56F4_654C_519B(caster, _____843D_70B9X, _____843D_70B9Y, _____914D_7F6E["周期"]["伤害判定半径"])
    _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
        ____R_65E5_5FD7_6A21_5757,
        "结算伤害",
        "落点",
        _____843D_70B9X,
        _____843D_70B9Y,
        "伤害",
        _____5355_6B21_4F24_5BB3,
        "命中数",
        #_____654C_519B_5217_8868
    )
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标列表"] = _____654C_519B_5217_8868,
        ["伤害"] = _____5355_6B21_4F24_5BB3,
        ["伤害类型"] = jass.DAMAGE_TYPE_MAGIC,
        attackType = jass.ATTACK_TYPE_NORMAL,
        weaponType = jass.WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["标签"] = "坂井悠二-R-神门-制裁",
        ["技能ID"] = stringToFourCC(____R_6280_80FDID_5B57_7B26_4E32),
        ["技能实例ID"] = ctx["技能实例ID"]
    })
end
function _____6E05_7406R_5230_671F(context)
    local ctx = context
    if ctx ~= nil then
        _____6E05_7406R_4E0A_4E0B_6587(ctx)
    end
end
jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_51CF_901F = ____require_result_0["施加减速"]
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_2["造成批量AOE技能伤害"]
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____83B7_53D6_8303_56F4_654C_519B = ____require_result_3["获取范围敌军"]
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWESetUnitAbilityStateSafe = ____require_result_4.YDWESetUnitAbilityStateSafe
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_5.createTimedEffect
local createTimedUnitEffect = ____require_result_5.createTimedUnitEffect
local ____require_result_6 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_6.Sound3DII_UnitPlayReuse
local ____ = Sound3DII_UnitPlayReuse
local ____require_result_7 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_7.addDelayedCallback
removeDelayedCallback = ____require_result_7.removeDelayedCallback
local addPeriodicCallback = ____require_result_7.addPeriodicCallback
removePeriodicCallback = ____require_result_7.removePeriodicCallback
local ____require_result_8 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_8.registerDeathListener
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
GetOwningPlayer = jass.GetOwningPlayer
local GetHeroLevel = jass.GetHeroLevel
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local CreateUnit = jass.CreateUnit
RemoveUnit = jass.RemoveUnit
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local ____jass_GetUnitFlyHeight_9 = jass.GetUnitFlyHeight
if ____jass_GetUnitFlyHeight_9 == nil then
    ____jass_GetUnitFlyHeight_9 = function(_u) return 0 end
end
local GetUnitFlyHeight = ____jass_GetUnitFlyHeight_9
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_10.stringToFourCCSafe
stringToFourCC = stringToFourCCSafe
local GetRandomReal = jass.GetRandomReal
local GetRandomInt = jass.GetRandomInt
local UnitAddAbility = jass.UnitAddAbility
UnitRemoveAbility = jass.UnitRemoveAbility
SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable
local AttachSoundToUnit = jass.AttachSoundToUnit
local SetSoundVolume = jass.SetSoundVolume
local StartSound = jass.StartSound
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local function _____64AD_653E_5168_5C40_97F3_6548(unit, soundKey)
    local soundHandle = jglobals[soundKey]
    if soundHandle == nil or soundHandle == 0 then
        return
    end
    if unit ~= nil and unit ~= 0 then
        AttachSoundToUnit(soundHandle, unit)
    end
    SetSoundVolume(soundHandle, 127)
    StartSound(soundHandle)
end
_____914D_7F6E = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E.R
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E["单位类型ID"]
____R_6280_80FDID_5B57_7B26_4E32 = _____914D_7F6E["技能ID"]
local ____E_6280_80FD_7C7B_578BID = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E.E["技能类型ID"]
____R_65E5_5FD7_6A21_5757 = "坂井悠二R排查"
_____4E0A_4E0B_6587_8868 = {}
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____83B7_53D6R_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if id == 0 then
        return nil
    end
    return _____4E0A_4E0B_6587_8868[id]
end
local function _____83B7_53D6_6216_521B_5EFAR_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if id == 0 then
        return nil
    end
    local current = _____4E0A_4E0B_6587_8868[id]
    if current ~= nil then
        return current
    end
    local created = {
        ["施法者"] = unit,
        ["已启动"] = false,
        ["周期回调ID"] = 0,
        ["清理回调ID"] = 0,
        ["神门单位"] = nil,
        ["伤害攻击力快照"] = 0,
        ["累计次数"] = 0,
        ["飞行高度"] = 0,
        ["已切二段"] = false
    }
    _____4E0A_4E0B_6587_8868[id] = created
    return created
end
local function _____63A8_8FDBR_5468_671F_4F24_5BB3(context)
    local ctx = context
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(____R_65E5_5FD7_6A21_5757, "周期终止：施法者无效/死亡")
        _____6E05_7406R_4E0A_4E0B_6587(ctx)
        return
    end
    local _____795E_95E8 = ctx["神门单位"]
    if _____795E_95E8 == nil or _____795E_95E8 == 0 then
        _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(____R_65E5_5FD7_6A21_5757, "周期终止：神门单位无效")
        _____6E05_7406R_4E0A_4E0B_6587(ctx)
        return
    end
    local _____4E2D_5FC3X = GetUnitX(_____795E_95E8)
    local _____4E2D_5FC3Y = GetUnitY(_____795E_95E8)
    local _____843D_70B9_534A_5F84 = _____914D_7F6E["周期"]["随机落点半径"]
    local _____89D2_5EA6 = GetRandomReal(0, 360) * (3.14159265358979 / 180)
    local _____534A_5F84 = GetRandomReal(0, _____843D_70B9_534A_5F84)
    local _____843D_70B9X = _____4E2D_5FC3X + _____534A_5F84 * math.cos(_____89D2_5EA6)
    local _____843D_70B9Y = _____4E2D_5FC3Y + _____534A_5F84 * math.sin(_____89D2_5EA6)
    do
        local i = 0
        while i < #_____914D_7F6E["周期"]["制裁特效"] do
            local _____7279_6548_914D_7F6E = _____914D_7F6E["周期"]["制裁特效"][i + 1]
            createTimedEffect(
                _____7279_6548_914D_7F6E["模型路径"],
                _____843D_70B9X,
                _____843D_70B9Y,
                ctx["飞行高度"],
                _____7279_6548_914D_7F6E["持续秒"]
            )
            i = i + 1
        end
    end
    _____64AD_653E_5168_5C40_97F3_6548(caster, _____914D_7F6E["周期"]["落点音效"]["全局音效键"])
    addDelayedCallback(_____914D_7F6E["周期"]["伤害延迟结算秒"] * 1000, _____7ED3_7B97R_5355_6B21_4F24_5BB3, {ctx = ctx, ["落点X"] = _____843D_70B9X, ["落点Y"] = _____843D_70B9Y})
    ctx["累计次数"] = ctx["累计次数"] + 1
    if ctx["累计次数"] % 4 == 1 then
        _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
            ____R_65E5_5FD7_6A21_5757,
            "周期伤害 tick",
            "累计次数",
            ctx["累计次数"],
            "神门位置",
            _____4E2D_5FC3X,
            _____4E2D_5FC3Y,
            "落点",
            _____843D_70B9X,
            _____843D_70B9Y
        )
    end
end
local function _____91CA_653ER_6280_80FD(context, caster, _____6280_80FD_5B9E_4F8BID)
    _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
        ____R_65E5_5FD7_6A21_5757,
        "释放R入口",
        "施法者",
        caster,
        "实例ID",
        _____6280_80FD_5B9E_4F8BID,
        "已启动",
        context["已启动"]
    )
    if context["已启动"] then
        _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(____R_65E5_5FD7_6A21_5757, "释放R被拒：已启动")
        return
    end
    context["已启动"] = true
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    context["伤害攻击力快照"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster)
    context["飞行高度"] = GetUnitFlyHeight(caster)
    YDWESetUnitAbilityStateSafe(caster, ____E_6280_80FD_7C7B_578BID, 1, 0)
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    local _____795E_95E8_56DBCC = stringToFourCC(_____914D_7F6E["神门单位"]["单位ID"])
    local _____795E_95E8_5355_4F4D = CreateUnit(
        GetOwningPlayer(caster),
        _____795E_95E8_56DBCC,
        _____76EE_6807X,
        _____76EE_6807Y,
        0
    )
    context["神门单位"] = _____795E_95E8_5355_4F4D
    _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
        ____R_65E5_5FD7_6A21_5757,
        "创建神门",
        "目标点",
        _____76EE_6807X,
        _____76EE_6807Y,
        "四CC",
        _____795E_95E8_56DBCC,
        "单位ID字符串",
        _____914D_7F6E["神门单位"]["单位ID"],
        "创建结果",
        _____795E_95E8_5355_4F4D
    )
    if _____795E_95E8_5355_4F4D ~= nil and _____795E_95E8_5355_4F4D ~= 0 then
        SetUnitFlyHeight(_____795E_95E8_5355_4F4D, context["飞行高度"] + _____914D_7F6E["神门单位"]["飞行高度增量"], 0)
    end
    if GetHeroLevel(caster) > _____914D_7F6E["二段"]["解锁英雄等级"] then
        SetPlayerAbilityAvailable(
            GetOwningPlayer(caster),
            _____914D_7F6E["技能类型ID"],
            false
        )
        UnitAddAbility(caster, _____914D_7F6E["二段"]["技能类型ID"])
        context["已切二段"] = true
        _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(____R_65E5_5FD7_6A21_5757, "切换二段", "已添加", _____914D_7F6E["二段"]["技能ID"])
    end
    context["周期回调ID"] = addPeriodicCallback(_____914D_7F6E["周期"]["周期间隔秒"] * 1000, _____63A8_8FDBR_5468_671F_4F24_5BB3, context)
    context["清理回调ID"] = addDelayedCallback(_____914D_7F6E["持续秒"] * 1000, _____6E05_7406R_5230_671F, context)
    _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
        ____R_65E5_5FD7_6A21_5757,
        "启动完成",
        "周期回调ID",
        context["周期回调ID"],
        "清理回调ID",
        context["清理回调ID"],
        "攻击力快照",
        context["伤害攻击力快照"],
        "周期间隔",
        _____914D_7F6E["周期"]["周期间隔秒"],
        "持续",
        _____914D_7F6E["持续秒"]
    )
end
local function ____R_53EF_91CA_653E(context)
    local _____53EF_91CA_653E = not context["已启动"] and context["周期回调ID"] == 0
    if not _____53EF_91CA_653E then
        _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
            ____R_65E5_5FD7_6A21_5757,
            "可释放检查被拦",
            "已启动",
            context["已启动"],
            "周期回调ID",
            context["周期回调ID"]
        )
    end
    return _____53EF_91CA_653E
end
local function ____R_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local context = _____83B7_53D6R_4E0A_4E0B_6587(dyingUnit)
    if context ~= nil then
        _____6E05_7406R_4E0A_4E0B_6587(context)
    end
end
____exports["获取当前R神门中心"] = function(caster)
    local ctx = _____83B7_53D6R_4E0A_4E0B_6587(caster)
    if ctx == nil then
        return nil
    end
    local _____795E_95E8 = ctx["神门单位"]
    if _____795E_95E8 == nil or _____795E_95E8 == 0 or not _____5355_4F4D_5B58_6D3B(_____795E_95E8) then
        return nil
    end
    return {
        X = GetUnitX(_____795E_95E8),
        Y = GetUnitY(_____795E_95E8)
    }
end
____exports["注册坂井悠二R"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "坂井悠二-神门（R）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = ____R_6280_80FDID_5B57_7B26_4E32,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAR_4E0A_4E0B_6587,
        ["可释放"] = ____R_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653ER_6280_80FD,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = _____914D_7F6E["持续秒"] + 1
    })
    if not _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(____R_5355_4F4D_6B7B_4EA1)
    end
end
____exports["注册坂井悠二R"]()
____exports["坂井悠二R技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["伤害形态"] = "一段：AOE 周期随机落点伤害；二段（胧天震）：无目标技能，以一段神门为中心 5秒 持续 AOE + 减速",
    ["伤害"] = "一段每 0.25秒 50% 攻击力（半径400落点/判定250）；二段每 0.5秒 50% 攻击力（以神门为中心半径400）+ 30%减速 0.6秒",
    ["持续"] = "一段 7秒（刷新E冷却，等级>20 切二段）；二段 5秒（无目标技能，魔耗检查 20% 最大魔法）"
}
return ____exports
