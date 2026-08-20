local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____6E05_7406R2_4E0A_4E0B_6587, _____6E05_7406R2_5230_671F, removeDelayedCallback, removePeriodicCallback, ____R2_65E5_5FD7_6A21_5757, _____4E0A_4E0B_6587_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.13．坂井悠二.00．配置")
local _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["坂井悠二技能配置"]
local ____05_FF0E_5742_4E95_60A0_4E8C = require("系统.05．Buff系统.03．Buff表.02．英雄.05．坂井悠二")
local _____5742_4E95_60A0_4E8CBuffID = ____05_FF0E_5742_4E95_60A0_4E8C["坂井悠二BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____53D6_5355_4F4DID = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["取单位ID"]
local _____6781_5750_6807X = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标Y"]
local ____04_FF0E_8C03_8BD5_8F93_51FA = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.04．调试输出")
local _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA = ____04_FF0E_8C03_8BD5_8F93_51FA["技能强制调试输出"]
local ____05_FF0ER_6280_80FD = require("系统.03．技能系统.05．单位技能.04．英雄技能.13．坂井悠二.05．R技能")
local _____83B7_53D6_5F53_524DR_795E_95E8_4E2D_5FC3 = ____05_FF0ER_6280_80FD["获取当前R神门中心"]
function _____6E05_7406R2_4E0A_4E0B_6587(context)
    if context["周期回调ID"] ~= 0 then
        removePeriodicCallback(context["周期回调ID"])
        context["周期回调ID"] = 0
    end
    if context["冲击回调ID"] ~= 0 then
        removePeriodicCallback(context["冲击回调ID"])
        context["冲击回调ID"] = 0
    end
    if context["清理回调ID"] ~= 0 then
        removeDelayedCallback(context["清理回调ID"])
        context["清理回调ID"] = 0
    end
    context["已启动"] = false
    local id = _____53D6_5355_4F4DID(context["施法者"])
    if id ~= 0 and _____4E0A_4E0B_6587_8868[id] == context then
        __TS__Delete(_____4E0A_4E0B_6587_8868, id)
    end
    _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(____R2_65E5_5FD7_6A21_5757, "清理R2上下文完成")
end
function _____6E05_7406R2_5230_671F(context)
    local ctx = context
    if ctx ~= nil then
        _____6E05_7406R2_4E0A_4E0B_6587(ctx)
    end
end
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_51CF_901F = ____require_result_0["施加减速"]
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_2["造成批量AOE技能伤害"]
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_3["获取范围敌军"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_4.createTimedEffect
local ____require_result_5 = require("lib.扩展函数.封装函数.02．音效系统.04．MP3音效播放")
local Sound3DII_Mp3Play = ____require_result_5.Sound3DII_Mp3Play
local ____require_result_6 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_6.addDelayedCallback
removeDelayedCallback = ____require_result_6.removeDelayedCallback
local addPeriodicCallback = ____require_result_6.addPeriodicCallback
removePeriodicCallback = ____require_result_6.removePeriodicCallback
local ____require_result_7 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_7.registerDeathListener
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local GetHeroLevel = jass.GetHeroLevel
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local ____ = GetUnitState
local ____ = SetUnitState
local GetRandomReal = jass.GetRandomReal
local ____jass_GetUnitFlyHeight_8 = jass.GetUnitFlyHeight
if ____jass_GetUnitFlyHeight_8 == nil then
    ____jass_GetUnitFlyHeight_8 = function(_u) return 0 end
end
local GetUnitFlyHeight = ____jass_GetUnitFlyHeight_8
local ____japi_EXEffectMatRotateX_9 = japi.EXEffectMatRotateX
if ____japi_EXEffectMatRotateX_9 == nil then
    ____japi_EXEffectMatRotateX_9 = nil
end
local EXEffectMatRotateX = ____japi_EXEffectMatRotateX_9
local ____japi_EXSetEffectSize_10 = japi.EXSetEffectSize
if ____japi_EXSetEffectSize_10 == nil then
    ____japi_EXSetEffectSize_10 = nil
end
local EXSetEffectSize = ____japi_EXSetEffectSize_10
local ____require_result_11 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_11.stringToFourCCSafe
local stringToFourCC = stringToFourCCSafe
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local ____ = UNIT_STATE_LIFE
____R2_65E5_5FD7_6A21_5757 = "坂井悠二R2排查"
local _____914D_7F6E = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E.R["二段"]
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E["单位类型ID"]
local ____R_4E8C_6BB5_6280_80FDID_5B57_7B26_4E32 = _____914D_7F6E["技能ID"]
_____4E0A_4E0B_6587_8868 = {}
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____83B7_53D6R2_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4DID(unit)
    if id == 0 then
        return nil
    end
    return _____4E0A_4E0B_6587_8868[id]
end
local function _____83B7_53D6_6216_521B_5EFAR2_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4DID(unit)
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
        ["冲击回调ID"] = 0,
        ["清理回调ID"] = 0,
        ["伤害攻击力快照"] = 0,
        ["冲击累计次数"] = 0,
        ["周期累计次数"] = 0,
        ["中心X"] = 0,
        ["中心Y"] = 0,
        ["飞行高度"] = 0
    }
    _____4E0A_4E0B_6587_8868[id] = created
    return created
end
local function ____R2_547D_4E2D_51CF_901F_5904_7406(target, ______7D22_5F15, ______6210_529F, _____53D8_91CF)
    if target == nil or target == 0 then
        return
    end
    local caster = _____53D8_91CF
    if caster == nil or caster == 0 then
        return
    end
    _____65BD_52A0_51CF_901F(
        caster,
        target,
        _____914D_7F6E["减速比例"],
        _____914D_7F6E["减速控制秒"],
        _____5742_4E95_60A0_4E8CBuffID["R2减速"],
        "技能"
    )
end
local function _____63A8_8FDBR2_5468_671F(context)
    local ctx = context
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(____R2_65E5_5FD7_6A21_5757, "周期终止：施法者无效/死亡")
        _____6E05_7406R2_4E0A_4E0B_6587(ctx)
        return
    end
    ctx["周期累计次数"] = ctx["周期累计次数"] + 1
    Sound3DII_Mp3Play(_____914D_7F6E["音效"]["路径"])
    local _____8303_56F4 = _____914D_7F6E["范围"]
    local _____5355_6B21_4F24_5BB3 = ctx["伤害攻击力快照"] * _____914D_7F6E["单次伤害攻击力倍率"]
    local _____654C_519B_5217_8868 = _____83B7_53D6_8303_56F4_654C_519B(caster, ctx["中心X"], ctx["中心Y"], _____8303_56F4)
    if _____5355_6B21_4F24_5BB3 > 0 then
        _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
            ["来源"] = caster,
            ["目标列表"] = _____654C_519B_5217_8868,
            ["伤害"] = _____5355_6B21_4F24_5BB3,
            ["伤害类型"] = jass.DAMAGE_TYPE_MAGIC,
            attackType = jass.ATTACK_TYPE_NORMAL,
            weaponType = jass.WEAPON_TYPE_WHOKNOWS,
            ["来源类型"] = "单位技能",
            ["标签"] = "坂井悠二-R2-胧天震-周期",
            ["技能ID"] = stringToFourCC(____R_4E8C_6BB5_6280_80FDID_5B57_7B26_4E32),
            ["技能实例ID"] = ctx["技能实例ID"],
            ["变量"] = caster,
            ["每目标结算后处理器"] = ____R2_547D_4E2D_51CF_901F_5904_7406
        })
    end
    _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
        ____R2_65E5_5FD7_6A21_5757,
        "R2周期 tick",
        "次数",
        ctx["周期累计次数"],
        "中心",
        ctx["中心X"],
        ctx["中心Y"],
        "伤害",
        _____5355_6B21_4F24_5BB3,
        "命中数",
        #_____654C_519B_5217_8868
    )
end
local function _____63A8_8FDBR2_51B2_51FB_7279_6548(context)
    local ctx = context
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        _____6E05_7406R2_4E0A_4E0B_6587(ctx)
        return
    end
    local _____968F_673A_89D2_5EA6 = GetRandomReal(0, 360)
    local _____534A_5F84 = GetRandomReal(_____914D_7F6E["冲击"]["随机半径最小"], _____914D_7F6E["冲击"]["随机半径最大"])
    local _____843D_70B9X = _____6781_5750_6807X(ctx["中心X"], _____968F_673A_89D2_5EA6, _____534A_5F84)
    local _____843D_70B9Y = _____6781_5750_6807Y(ctx["中心Y"], _____968F_673A_89D2_5EA6, _____534A_5F84)
    local _____65CB_8F6C_89D2 = GetRandomReal(_____914D_7F6E["冲击"]["冲击特效"]["随机角度最小"], _____914D_7F6E["冲击"]["冲击特效"]["随机角度最大"]) * (180 / 3.14159265358979)
    local _____51B2_51FB = createTimedEffect(
        _____914D_7F6E["冲击"]["冲击特效"]["模型路径"],
        _____843D_70B9X,
        _____843D_70B9Y,
        ctx["飞行高度"],
        _____914D_7F6E["冲击"]["冲击特效"]["持续秒"]
    )
    if _____51B2_51FB ~= nil and _____51B2_51FB ~= 0 then
        if EXEffectMatRotateX ~= nil then
            EXEffectMatRotateX(_____51B2_51FB, _____65CB_8F6C_89D2)
        end
        if EXSetEffectSize ~= nil then
            EXSetEffectSize(_____51B2_51FB, _____914D_7F6E["冲击"]["冲击特效"]["缩放"])
        end
    end
    local _____9707_8361 = createTimedEffect(
        _____914D_7F6E["冲击"]["冲击震荡特效"]["模型路径"],
        ctx["中心X"],
        ctx["中心Y"],
        ctx["飞行高度"],
        _____914D_7F6E["冲击"]["冲击震荡特效"]["持续秒"]
    )
    if _____9707_8361 ~= nil and _____9707_8361 ~= 0 then
        if EXEffectMatRotateX ~= nil then
            EXEffectMatRotateX(_____9707_8361, _____65CB_8F6C_89D2)
        end
        if EXSetEffectSize ~= nil then
            EXSetEffectSize(_____9707_8361, _____914D_7F6E["冲击"]["冲击震荡特效"]["缩放"])
        end
    end
    local _____5730_5F62 = createTimedEffect(
        _____914D_7F6E["冲击"]["地形特效"]["模型路径"],
        ctx["中心X"],
        ctx["中心Y"],
        ctx["飞行高度"],
        _____914D_7F6E["冲击"]["地形特效"]["持续秒"]
    )
    if _____5730_5F62 ~= nil and _____5730_5F62 ~= 0 then
        if EXSetEffectSize ~= nil then
            EXSetEffectSize(_____5730_5F62, _____914D_7F6E["冲击"]["地形特效"]["缩放"])
        end
    end
    ctx["冲击累计次数"] = ctx["冲击累计次数"] + 1
end
local function _____91CA_653ER2_6280_80FD(context, caster, _____6280_80FD_5B9E_4F8BID)
    _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
        ____R2_65E5_5FD7_6A21_5757,
        "释放R2入口",
        "施法者",
        caster,
        "实例ID",
        _____6280_80FD_5B9E_4F8BID,
        "已启动",
        context["已启动"]
    )
    if context["已启动"] then
        _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(____R2_65E5_5FD7_6A21_5757, "释放R2被拒：已启动")
        return
    end
    local _____7B49_7EA7 = GetHeroLevel(caster)
    if _____7B49_7EA7 < _____914D_7F6E["解锁英雄等级"] then
        _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
            ____R2_65E5_5FD7_6A21_5757,
            "释放R2被拒：等级不足",
            "等级",
            _____7B49_7EA7,
            "需要",
            _____914D_7F6E["解锁英雄等级"]
        )
        return
    end
    context["已启动"] = true
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    context["伤害攻击力快照"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster)
    context["冲击累计次数"] = 0
    context["飞行高度"] = GetUnitFlyHeight(caster)
    local _____795E_95E8_4E2D_5FC3 = _____83B7_53D6_5F53_524DR_795E_95E8_4E2D_5FC3(caster)
    if _____795E_95E8_4E2D_5FC3 ~= nil then
        context["中心X"] = _____795E_95E8_4E2D_5FC3.X
        context["中心Y"] = _____795E_95E8_4E2D_5FC3.Y
    else
        context["中心X"] = GetUnitX(caster)
        context["中心Y"] = GetUnitY(caster)
        _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(____R2_65E5_5FD7_6A21_5757, "无神门兜底：用施法者位置")
    end
    createTimedEffect(
        _____914D_7F6E["区域特效"]["模型路径"],
        context["中心X"],
        context["中心Y"],
        context["飞行高度"],
        _____914D_7F6E["区域特效"]["持续秒"]
    )
    context["周期回调ID"] = addPeriodicCallback(_____914D_7F6E["周期间隔秒"] * 1000, _____63A8_8FDBR2_5468_671F, context)
    context["冲击回调ID"] = addPeriodicCallback(_____914D_7F6E["持续秒"] / (_____914D_7F6E["冲击"]["每秒数量"] * _____914D_7F6E["持续秒"]) * 1000, _____63A8_8FDBR2_51B2_51FB_7279_6548, context)
    context["清理回调ID"] = addDelayedCallback(_____914D_7F6E["持续秒"] * 1000, _____6E05_7406R2_5230_671F, context)
    _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
        ____R2_65E5_5FD7_6A21_5757,
        "R2启动成功",
        "中心",
        context["中心X"],
        context["中心Y"],
        "攻击力快照",
        context["伤害攻击力快照"],
        "周期ID",
        context["周期回调ID"],
        "冲击ID",
        context["冲击回调ID"],
        "清理ID",
        context["清理回调ID"]
    )
end
local function ____R2_53EF_91CA_653E(context)
    local _____53EF_91CA_653E = not context["已启动"] and context["周期回调ID"] == 0
    if not _____53EF_91CA_653E then
        _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
            ____R2_65E5_5FD7_6A21_5757,
            "R2可释放检查被拦",
            "已启动",
            context["已启动"],
            "周期回调ID",
            context["周期回调ID"]
        )
    end
    return _____53EF_91CA_653E
end
local function ____R2_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local context = _____83B7_53D6R2_4E0A_4E0B_6587(dyingUnit)
    if context ~= nil then
        _____6E05_7406R2_4E0A_4E0B_6587(context)
    end
end
____exports["注册坂井悠二R2"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "坂井悠二-胧天震（R二段）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = ____R_4E8C_6BB5_6280_80FDID_5B57_7B26_4E32,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAR2_4E0A_4E0B_6587,
        ["可释放"] = ____R2_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653ER2_6280_80FD,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = _____914D_7F6E["持续秒"] + 1
    })
    if not _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(____R2_5355_4F4D_6B7B_4EA1)
    end
end
____exports["注册坂井悠二R2"]()
____exports["坂井悠二R2技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["伤害形态"] = "AOE 周期伤害 + 减速",
    ["伤害"] = "每 0.5秒 50% 攻击力，持续 5秒，30% 减速 0.6秒",
    ["解锁条件"] = "英雄等级 ≥ 20，魔法值 ≥ 20% max + 300"
}
return ____exports
