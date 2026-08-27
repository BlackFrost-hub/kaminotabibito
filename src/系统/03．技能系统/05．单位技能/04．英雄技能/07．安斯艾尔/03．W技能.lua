--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.07．安斯艾尔.00．配置")
local _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["安斯艾尔单位技能配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51FB_9000 = ____require_result_1["开始击退"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_2["造成单体技能伤害"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_51CF_901F = ____require_result_3["施加减速"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_4["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_4["单位存活"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_5["创建点特效"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_6.stringToFourCCSafe
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC
local ____W_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E["W技能ID"])
local function _____83B7_53D6W_4E0A_4E0B_6587(unit)
    return {unit = unit}
end
local function _____64AD_653EW_914D_7F6E_8868_73B0(unit)
    local cfg = _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E.W
    if cfg["动作编号"] >= 0 then
        SetUnitTimeScale(unit, cfg["动作速度"])
        SetUnitAnimationByIndex(unit, cfg["动作编号"])
    end
    if cfg["全局音效键"] == "" then
        return
    end
    local sound = jglobals[cfg["全局音效键"]]
    if sound == nil or sound == 0 then
        return
    end
    jass:AttachSoundToUnit(sound, unit)
    jass:SetSoundVolume(sound, 127)
    jass:StartSound(sound)
end
local function _____64AD_653E_957F_67AA_88C1_51B3_8FDE_7EED_7279_6548(target)
    local cfg = _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E.W
    local count = 0
    local callbackId = 0
    local function ____on_8FDE_7EED_7279_6548Tick()
        count = count + 1
        if target ~= nil and target ~= 0 then
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = cfg["连续特效模型"],
                X = GetUnitX(target),
                Y = GetUnitY(target),
                Z = cfg["连续特效Z"],
                ["Z轴角度"] = cfg["连续特效Z轴角度"],
                ["缩放"] = cfg["连续特效缩放"],
                ["动画速度"] = cfg["连续特效动画速度"],
                ["持续秒"] = cfg["连续特效持续秒"]
            })
        end
        if count >= cfg["连续特效次数"] then
            removePeriodicCallback(callbackId)
        end
    end
    callbackId = addPeriodicCallback(cfg["连续特效间隔毫秒"], ____on_8FDE_7EED_7279_6548Tick)
end
local function _____91CA_653E_957F_67AA_88C1_51B3(_context, unit, _____6280_80FD_5B9E_4F8BID)
    local target = GetSpellTargetUnit()
    if not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    local cfg = _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E.W
    local level = GetUnitAbilityLevel(unit, ____W_6280_80FD_7C7B_578BID)
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(unit) * (cfg["基础攻击力倍率"] + cfg["每级攻击力倍率"] * level)
    _____64AD_653EW_914D_7F6E_8868_73B0(unit)
    local function ____on_51FB_9000_7ED3_675F()
        if _____5355_4F4D_5B58_6D3B(target) then
            _____65BD_52A0_51CF_901F(
                unit,
                target,
                cfg["减速比例"],
                cfg["减速持续秒"],
                "长枪裁决",
                "技能"
            )
        end
    end
    _____5F00_59CB_51FB_9000(target, {
        ["来源单位"] = unit,
        ["距离"] = cfg["击退距离"],
        ["持续时间"] = cfg["击退持续秒"],
        ["检查地形"] = true,
        ["暂停单位"] = false,
        ["禁用碰撞"] = true,
        ["结束回调"] = ____on_51FB_9000_7ED3_675F
    })
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = unit,
        ["目标"] = target,
        ["伤害"] = damage,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        attack = true,
        ranged = false,
        attackType = ATTACK_TYPE_MAGIC,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____W_6280_80FD_7C7B_578BID,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["参与技能伤害加成"] = true,
        ["标签"] = "安斯艾尔-长枪裁决"
    })
    _____64AD_653E_957F_67AA_88C1_51B3_8FDE_7EED_7279_6548(target)
end
____exports["注册安斯艾尔W"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "安斯艾尔-长枪裁决",
        ["单位类型ID"] = _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"],
        ["技能ID"] = _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E["W技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6W_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_957F_67AA_88C1_51B3,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能"
    })
end
____exports["注册安斯艾尔W"]()
return ____exports
