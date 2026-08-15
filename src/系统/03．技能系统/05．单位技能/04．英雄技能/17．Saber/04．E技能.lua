local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.17．Saber.00．配置")
local ____Saber_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["Saber技能配置"]
local ____08_FF0ESaber = require("系统.05．Buff系统.03．Buff表.02．英雄.08．Saber")
local SaberBuffID = ____08_FF0ESaber.SaberBuffID
local ____01_FF0E_72B6_6001_8868 = require("系统.03．技能系统.05．单位技能.04．英雄技能.17．Saber.01．状态表")
local ____Saber_5F00_542FE = ____01_FF0E_72B6_6001_8868["Saber开启E"]
local ____Saber_5173_95EDE = ____01_FF0E_72B6_6001_8868["Saber关闭E"]
local ____Saber_662F_5426E_5F00_542F = ____01_FF0E_72B6_6001_8868["Saber是否E开启"]
local _____8BFB_53D6SaberE_653B_51FB_52A0_6210_503C = ____01_FF0E_72B6_6001_8868["读取SaberE攻击加成值"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____4E34_65F6_8C03_6574_653B_51FB = ____require_result_1["临时调整攻击"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_2["造成单体技能伤害"]
local ____require_result_3 = require("系统.04．伤害系统.01．伤害事件")
local registerDamageCallback = ____require_result_3.registerDamageCallback
local ____require_result_4 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_4.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_4["移除单位指定Buff"]
local getBuffRuntime = ____require_result_4.getBuffRuntime
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createUnitEffect = ____require_result_5.createUnitEffect
local destroyUnitEffect = ____require_result_5.destroyUnitEffect
local createTimedUnitEffect = ____require_result_5.createTimedUnitEffect
local ____require_result_6 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_6.registerDeathListener
local GetUnitTypeId = jass.GetUnitTypeId
local GetHandleId = jass.GetHandleId
local IsUnitPaused = jass.IsUnitPaused
local GetSpellAbilityId = jass.GetSpellAbilityId
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local stringToFourCC = stringToFourCCSafe
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____914D_7F6E = ____Saber_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local ____E_7C7B_578BID = stringToFourCC(_____914D_7F6E.E["技能ID"])
local ____E_6B66_5668_7279_6548_952E = "Saber-E-武器强化"
local ____E_8FD0_884C_65F6_8868 = {}
--- 结束 E：撤销攻击力加成、销毁武器特效、移除 Buff、关闭状态。所有结束路径共用。
local function _____7ED3_675FSaberE_72B6_6001(caster)
    if caster == nil or caster == 0 then
        return
    end
    local runtime = ____E_8FD0_884C_65F6_8868[GetHandleId(caster)]
    ____Saber_5173_95EDE(caster)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(caster, SaberBuffID["魔力放出"])
    destroyUnitEffect(caster, ____E_6B66_5668_7279_6548_952E)
    if runtime == nil then
        return
    end
    if runtime["周期回调ID"] ~= 0 then
        removePeriodicCallback(runtime["周期回调ID"])
    end
    runtime["周期回调ID"] = 0
    if runtime["攻击加成值"] ~= 0 then
        _____4E34_65F6_8C03_6574_653B_51FB(caster, -runtime["攻击加成值"])
        runtime["攻击加成值"] = 0
    end
    runtime["已启动"] = false
    __TS__Delete(
        ____E_8FD0_884C_65F6_8868,
        GetHandleId(caster)
    )
end
--- W 地面 E 联动消耗入口：立即结束魔力放出。
____exports["消耗SaberE"] = function(caster)
    if not ____Saber_662F_5426E_5F00_542F(caster) then
        return
    end
    _____7ED3_675FSaberE_72B6_6001(caster)
end
____exports["Saber是否E开启"] = ____Saber_662F_5426E_5F00_542F
local function _____63A8_8FDBE_5468_671F(variable)
    local runtime = variable
    if runtime == nil then
        return
    end
    local caster = runtime.caster
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) or runtime["计数"] >= _____914D_7F6E.E["最大计数"] then
        _____7ED3_675FSaberE_72B6_6001(caster)
        return
    end
    if not ____Saber_662F_5426E_5F00_542F(caster) or getBuffRuntime(caster, SaberBuffID["魔力放出"]) == nil then
        _____7ED3_675FSaberE_72B6_6001(caster)
        return
    end
    if not IsUnitPaused(caster) then
        runtime["计数"] = runtime["计数"] + 1
    end
    createTimedUnitEffect(caster, _____914D_7F6E.E["周期特效"]["挂点"], _____914D_7F6E.E["周期特效"]["模型路径"], _____914D_7F6E.E["周期特效"]["持续秒"])
end
local ____E_4E0A_4E0B_6587_8868 = {}
local function _____83B7_53D6_6216_521B_5EFAE_4E0A_4E0B_6587(caster)
    local id = GetHandleId(caster)
    local record = ____E_4E0A_4E0B_6587_8868[id]
    if record == nil then
        record = {["施法者"] = caster}
        ____E_4E0A_4E0B_6587_8868[id] = record
    end
    return record
end
local function _____91CA_653EE_6280_80FD(_context, caster, ______6280_80FD_5B9E_4F8BID)
    if not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    if ____Saber_662F_5426E_5F00_542F(caster) then
        _____7ED3_675FSaberE_72B6_6001(caster)
    end
    local _____52A0_6210 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * _____914D_7F6E.E["攻击力加成比例"]
    _____4E34_65F6_8C03_6574_653B_51FB(caster, _____52A0_6210)
    ____Saber_5F00_542FE(caster, _____52A0_6210)
    registerManualBuff(
        caster,
        SaberBuffID["魔力放出"],
        _____914D_7F6E.E["持续秒"],
        _____914D_7F6E.E["攻击力加成比例"],
        {["来源"] = caster, ["标签"] = "Saber-E-魔力放出"}
    )
    createUnitEffect(
        caster,
        _____914D_7F6E.E["武器特效"]["挂点"],
        _____914D_7F6E.E["武器特效"]["模型路径"],
        nil,
        ____E_6B66_5668_7279_6548_952E
    )
    local runtime = {
        caster = caster,
        ["周期回调ID"] = 0,
        ["计数"] = 0,
        ["攻击加成值"] = _____52A0_6210,
        ["已启动"] = true
    }
    ____E_8FD0_884C_65F6_8868[GetHandleId(caster)] = runtime
    runtime["周期回调ID"] = addPeriodicCallback(
        math.floor(_____914D_7F6E.E["周期间隔秒"] * 1000 + 0.5),
        _____63A8_8FDBE_5468_671F,
        runtime
    )
end
local function _____5904_7406E_666E_653B_9644_52A0_4F24_5BB3(target, damage, _damageType, _fromDotTickBatch, source, isNormalAttack)
    if source == nil or source == 0 then
        return
    end
    if not isNormalAttack then
        return
    end
    if GetUnitTypeId(source) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(source) then
        return
    end
    if not ____Saber_662F_5426E_5F00_542F(source) then
        return
    end
    if target == nil or target == 0 or not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    if damage <= 0 then
        return
    end
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = source,
        ["目标"] = target,
        ["伤害"] = damage * _____914D_7F6E.E["普攻附加"]["伤害比例"],
        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "普攻强化",
        ["标签"] = "Saber-E-普攻附加",
        ["技能ID"] = ____E_7C7B_578BID
    })
end
local ____E_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function ____E_5355_4F4D_6B7B_4EA1_6E05_7406(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    if GetUnitTypeId(dyingUnit) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    if ____Saber_662F_5426E_5F00_542F(dyingUnit) or ____E_8FD0_884C_65F6_8868[GetHandleId(dyingUnit)] ~= nil then
        _____7ED3_675FSaberE_72B6_6001(dyingUnit)
    end
end
____exports["注册SaberE"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "Saber-魔力放出（E）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E.E["技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAE_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653EE_6280_80FD,
        ["创建独立技能实例"] = false
    })
    registerDamageCallback(_____5904_7406E_666E_653B_9644_52A0_4F24_5BB3)
    if not ____E_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        ____E_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(____E_5355_4F4D_6B7B_4EA1_6E05_7406)
    end
end
____exports["注册SaberE"]()
local ____ = GetSpellAbilityId
local ____ = _____8BFB_53D6SaberE_653B_51FB_52A0_6210_503C
return ____exports
