local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.00．配置")
local _____7231_871C_8389_96C5_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["爱蜜莉雅技能配置"]
local _____7231_871C_8389_96C5_666E_653B_914D_7F6E = ____00_FF0E_914D_7F6E["爱蜜莉雅普攻配置"]
local ____20_FF0E_7231_871C_8389_96C5 = require("系统.05．Buff系统.03．Buff表.02．英雄.20．爱蜜莉雅")
local _____7231_871C_8389_96C5BuffID = ____20_FF0E_7231_871C_8389_96C5["爱蜜莉雅BuffID"]
local ____02_FF0E_516C_5171_72B6_6001_4E0E_51B0_6676 = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.02．公共状态与冰晶")
local _____67E5_8BE2_7231_871C_8389_96C5_51B0_6676 = ____02_FF0E_516C_5171_72B6_6001_4E0E_51B0_6676["查询爱蜜莉雅冰晶"]
local ____03_FF0E_88AB_52A8_6548_679C = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.03．被动效果")
local _____662F_7231_871C_8389_96C5 = ____03_FF0E_88AB_52A8_6548_679C["是爱蜜莉雅"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local stringToFourCC = jass.FourCC
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["移除单位指定Buff"]
local _____83B7_53D6_5355_4F4DBuff_5C42_6570 = ____require_result_0["获取单位Buff层数"]
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_2["造成技能伤害"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_3["读取单位攻击力"]
local _____8DDD_79BB_5E73_65B9XY = ____require_result_3["距离平方XY"]
local ____require_result_4 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_4.registerDeathListener
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.09．复杂战斗模板.05．弹道编排工厂")
local _____53D1_5C04_5F39_9053 = ____require_result_5["发射弹道"]
local platformAbilityApi = require("平台扩展API取值")
local platformAbilityAction = require("平台扩展API动作")
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCC(_____7231_871C_8389_96C5_6280_80FD_914D_7F6E["单位类型ID"])
local ____Q_6280_80FDID = stringToFourCC(_____7231_871C_8389_96C5_6280_80FD_914D_7F6E.Q["技能ID"])
local ____W_6280_80FDID = stringToFourCC(_____7231_871C_8389_96C5_6280_80FD_914D_7F6E.W["技能ID"])
local ____E_6280_80FDID = stringToFourCC(_____7231_871C_8389_96C5_6280_80FD_914D_7F6E.E["技能ID"])
local ____R_6280_80FDID = stringToFourCC(_____7231_871C_8389_96C5_6280_80FD_914D_7F6E.R["技能ID"])
local ____D_6280_80FDID = stringToFourCC(_____7231_871C_8389_96C5_6280_80FD_914D_7F6E.D["技能ID"])
--- 爱蜜莉雅区域目标计数表：目标句柄 → 覆盖区域数（W/R 区域进入/离开维护）
local _____533A_57DF_76EE_6807_8BA1_6570_8868 = {}
--- W/R 区域进入时调用（目标进入冰花/领域判定）
____exports["标记目标在爱蜜莉雅区域"] = function(_____76EE_6807)
    if _____76EE_6807 == nil or _____76EE_6807 == 0 then
        return
    end
    local id = GetHandleId(_____76EE_6807)
    _____533A_57DF_76EE_6807_8BA1_6570_8868[id] = (_____533A_57DF_76EE_6807_8BA1_6570_8868[id] or 0) + 1
end
--- W/R 区域离开时调用
____exports["取消标记目标在爱蜜莉雅区域"] = function(_____76EE_6807)
    if _____76EE_6807 == nil or _____76EE_6807 == 0 then
        return
    end
    local id = GetHandleId(_____76EE_6807)
    local _____8BA1_6570 = _____533A_57DF_76EE_6807_8BA1_6570_8868[id]
    if _____8BA1_6570 == nil then
        return
    end
    if _____8BA1_6570 <= 1 then
        __TS__Delete(_____533A_57DF_76EE_6807_8BA1_6570_8868, id)
    else
        _____533A_57DF_76EE_6807_8BA1_6570_8868[id] = _____8BA1_6570 - 1
    end
end
--- 目标当前是否位于任意爱蜜莉雅区域（W/R）内
____exports["目标在爱蜜莉雅区域"] = function(_____76EE_6807)
    if _____76EE_6807 == nil or _____76EE_6807 == 0 then
        return false
    end
    return (_____533A_57DF_76EE_6807_8BA1_6570_8868[GetHandleId(_____76EE_6807)] or 0) > 0
end
--- 冰晶附近判定（普攻命中点与任一冰晶距离 ≤ 配置值）
local function _____76EE_6807_5728_51B0_6676_9644_8FD1(_____82F1_96C4, _____76EE_6807)
    local _____5217_8868 = _____67E5_8BE2_7231_871C_8389_96C5_51B0_6676(_____82F1_96C4)
    local x = GetUnitX(_____76EE_6807)
    local y = GetUnitY(_____76EE_6807)
    local _____5224_5B9A_8DDD_79BB_5E73_65B9 = 180 * 180
    do
        local i = 0
        while i < #_____5217_8868 do
            if _____8DDD_79BB_5E73_65B9XY(_____5217_8868[i + 1].X, _____5217_8868[i + 1].Y, x, y) <= _____5224_5B9A_8DDD_79BB_5E73_65B9 then
                return true
            end
            i = i + 1
        end
    end
    return false
end
--- 目标是否带寒意（Buff 层数 > 0）
local function _____76EE_6807_5E26_5BD2_610F(_____76EE_6807)
    return _____83B7_53D6_5355_4F4DBuff_5C42_6570(_____76EE_6807, _____7231_871C_8389_96C5BuffID["寒意"]) > 0
end
--- 判定一次普攻是否"有效"（规划 3.3 条件之一即可）
local function _____666E_653B_662F_5426_6709_6548(_____82F1_96C4, _____76EE_6807)
    if _____76EE_6807_5E26_5BD2_610F(_____76EE_6807) then
        return true
    end
    if _____76EE_6807_5728_51B0_6676_9644_8FD1(_____82F1_96C4, _____76EE_6807) then
        return true
    end
    if ____exports["目标在爱蜜莉雅区域"](_____76EE_6807) then
        return true
    end
    return false
end
local function _____51CF_5C11_6700_957FQWE_51B7_5374(_____82F1_96C4)
    local _____6280_80FD_8868 = {
        {
            id = ____Q_6280_80FDID,
            ["当前"] = platformAbilityApi["技能_获取技能当前冷却时间"](_____82F1_96C4, ____Q_6280_80FDID)
        },
        {
            id = ____W_6280_80FDID,
            ["当前"] = platformAbilityApi["技能_获取技能当前冷却时间"](_____82F1_96C4, ____W_6280_80FDID)
        },
        {
            id = ____E_6280_80FDID,
            ["当前"] = platformAbilityApi["技能_获取技能当前冷却时间"](_____82F1_96C4, ____E_6280_80FDID)
        }
    }
    local _____6700_957F_7D22_5F15 = -1
    local _____6700_957F_51B7_5374 = 0
    do
        local i = 0
        while i < #_____6280_80FD_8868 do
            if _____6280_80FD_8868[i + 1]["当前"] > _____6700_957F_51B7_5374 then
                _____6700_957F_51B7_5374 = _____6280_80FD_8868[i + 1]["当前"]
                _____6700_957F_7D22_5F15 = i
            end
            i = i + 1
        end
    end
    if _____6700_957F_7D22_5F15 < 0 or _____6700_957F_51B7_5374 <= 0 then
        return
    end
    local _____76EE_6807_6280_80FD = _____6280_80FD_8868[_____6700_957F_7D22_5F15 + 1]
    local _____5269_4F59 = _____76EE_6807_6280_80FD["当前"] - _____7231_871C_8389_96C5_666E_653B_914D_7F6E["帕克追击冷却缩减秒"]
    local _____65B0_51B7_5374 = _____5269_4F59 > 0 and _____5269_4F59 or 0
    local _____6700_5927_51B7_5374 = platformAbilityApi["技能_获取技能最大冷却时间"](_____82F1_96C4, _____76EE_6807_6280_80FD.id)
    platformAbilityAction["技能_设置技能冷却时间"](_____82F1_96C4, _____76EE_6807_6280_80FD.id, _____65B0_51B7_5374, _____6700_5927_51B7_5374)
end
local function _____53D1_5C04_5E15_514B_8FFD_51FB_51B0_5F39(_____82F1_96C4, _____76EE_6807)
    if _____82F1_96C4 == nil or _____76EE_6807 == nil or _____76EE_6807 == 0 then
        return
    end
    local _____4F24_5BB3 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____82F1_96C4) * _____7231_871C_8389_96C5_666E_653B_914D_7F6E["帕克追击伤害攻击力倍率"]
    local _____8FFD_8E2A_5F39 = _____53D1_5C04_5F39_9053({
        ["名称"] = "爱蜜莉雅-帕克追击",
        ["所有者"] = _____82F1_96C4,
        ["发射方向角"] = GetUnitFacing(_____82F1_96C4),
        ["速度"] = _____7231_871C_8389_96C5_666E_653B_914D_7F6E["帕克追击速度"],
        ["轨迹"] = {["类型"] = "追踪", ["目标"] = _____76EE_6807, ["追踪转向速度"] = 540},
        ["最大距离"] = 900,
        ["命中半径"] = _____7231_871C_8389_96C5_666E_653B_914D_7F6E["帕克追击命中半径"],
        ["影响目标"] = "敌方",
        ["碰撞消失"] = true,
        ["每单位最大命中次数"] = 1,
        ["伤害值"] = _____4F24_5BB3,
        ["伤害类型"] = DAMAGE_TYPE_COLD,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = 0,
        ["技能标签"] = "爱蜜莉雅-帕克追击",
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = false,
        ["模型"] = _____7231_871C_8389_96C5_666E_653B_914D_7F6E["帕克追击模型"],
        ["缩放"] = _____7231_871C_8389_96C5_666E_653B_914D_7F6E["表现"]["缩放"]
    })
    local ____ = _____8FFD_8E2A_5F39
end
local function _____5904_7406_7231_871C_8389_96C5_9020_6210_4F24_5BB3(target, attacker, _applied, snapshot)
    if attacker == nil or attacker == 0 or not _____662F_7231_871C_8389_96C5(attacker) then
        return
    end
    local ____opt_result_8
    if snapshot ~= nil then
        ____opt_result_8 = snapshot.isNormalAttack
    end
    if ____opt_result_8 ~= true then
        return
    end
    local ____opt_result_11
    if snapshot ~= nil then
        ____opt_result_11 = snapshot.isWrappedSkillDamage
    end
    if ____opt_result_11 == true then
        return
    end
    local ____opt_result_14
    if snapshot ~= nil then
        ____opt_result_14 = snapshot.originalAttacker
    end
    if ____opt_result_14 ~= nil and snapshot.originalAttacker ~= attacker then
        return
    end
    if target == nil or target == 0 then
        return
    end
    if not _____666E_653B_662F_5426_6709_6548(attacker, target) then
        return
    end
    local _____5F53_524D_5C42_6570 = _____83B7_53D6_5355_4F4DBuff_5C42_6570(attacker, _____7231_871C_8389_96C5BuffID["契约应和"])
    local _____65B0_5C42_6570 = _____5F53_524D_5C42_6570 + 1
    if _____65B0_5C42_6570 >= _____7231_871C_8389_96C5_666E_653B_914D_7F6E["契约应和上限"] then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(attacker, _____7231_871C_8389_96C5BuffID["契约应和"])
        _____53D1_5C04_5E15_514B_8FFD_51FB_51B0_5F39(attacker, target)
        _____51CF_5C11_6700_957FQWE_51B7_5374(attacker)
        return
    end
    registerManualBuff(
        attacker,
        _____7231_871C_8389_96C5BuffID["契约应和"],
        _____7231_871C_8389_96C5_666E_653B_914D_7F6E["契约应和持续秒"],
        _____65B0_5C42_6570,
        {stack = _____65B0_5C42_6570}
    )
end
local _____5DF2_6CE8_518C = false
local _____6B7B_4EA1_6E05_7406_5DF2_6CE8_518C = false
local function _____786E_4FDD_533A_57DF_6807_8BB0_6B7B_4EA1_6E05_7406()
    if _____6B7B_4EA1_6E05_7406_5DF2_6CE8_518C then
        return
    end
    _____6B7B_4EA1_6E05_7406_5DF2_6CE8_518C = true
    registerDeathListener(function(dyingUnit, _killingUnit)
        if dyingUnit == nil or dyingUnit == 0 then
            return
        end
        __TS__Delete(
            _____533A_57DF_76EE_6807_8BA1_6570_8868,
            GetHandleId(dyingUnit)
        )
    end)
end
____exports["注册爱蜜莉雅普攻联动"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____786E_4FDD_533A_57DF_6807_8BB0_6B7B_4EA1_6E05_7406()
    registerAppliedFinalDamageListener(_____5904_7406_7231_871C_8389_96C5_9020_6210_4F24_5BB3)
end
return ____exports
