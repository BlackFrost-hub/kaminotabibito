local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.08．提米诺斯.00．配置")
local _____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["提米诺斯单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.08．提米诺斯.00A．表现工具")
local _____64AD_653E_63D0_7C73_8BFA_65AF_5355_4F4D_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放提米诺斯单位音效"]
local _____64AD_653E_63D0_7C73_8BFA_65AF_914D_7F6E_52A8_4F5C = ____00A_FF0E_8868_73B0_5DE5_5177["播放提米诺斯配置动作"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_2["开始硬直"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_3["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_3["单位存活"]
local _____6781_5750_6807X = ____require_result_3["极坐标X"]
local _____6781_5750_6807Y = ____require_result_3["极坐标Y"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807 = ____require_result_4["执行战斗自身传送到坐标"]
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_5["造成批量AOE技能伤害"]
local _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_5["创建独立技能伤害实例"]
local _____7ED1_5B9A_5355_4F4D_5F53_524D_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_5["绑定单位当前独立技能伤害实例"]
local _____6CE8_518C_6280_80FD_4F24_5BB3_5B9E_4F8B_7ED3_675F_76D1_542C = ____require_result_5["注册技能伤害实例结束监听"]
local ____require_result_6 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_6.registerAppliedFinalDamageListener
local ____require_result_7 = require("系统.04．伤害系统.00．伤害计算.03．吸血吸魔")
local applyManaSteal = ____require_result_7.applyManaSteal
local ____require_result_8 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_8.getEnemyUnitsInRange
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_9["创建点特效"]
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_10.stringToFourCCSafe
local ____D_6280_80FDID = stringToFourCCSafe(_____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E["D技能ID"])
local _____63D0_7C73_8BFA_65AF_5355_4F4DID = stringToFourCCSafe(_____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local EXSetUnitMoveType = japi.EXSetUnitMoveType
local SetUnitAnimation = jass.SetUnitAnimation
local _____63D0_7C73_8BFA_65AFD_6280_80FD_5B9E_4F8B_8868 = {}
local function ____on_63D0_7C73_8BFA_65AFD_6700_7EC8_4F24_5BB3(_target, attacker, applied, snapshot)
    local ____opt_result_13
    if snapshot ~= nil then
        ____opt_result_13 = snapshot.skillInstanceId
    end
    local skillInstanceId = ____opt_result_13
    local ____temp_17 = not (applied > 0) or attacker == nil
    if not ____temp_17 then
        local ____opt_result_16
        if snapshot ~= nil then
            ____opt_result_16 = snapshot.abilityId
        end
        ____temp_17 = ____opt_result_16 ~= ____D_6280_80FDID
    end
    if ____temp_17 or skillInstanceId == nil then
        return
    end
    if _____63D0_7C73_8BFA_65AFD_6280_80FD_5B9E_4F8B_8868[skillInstanceId] ~= true or jass.GetUnitTypeId(attacker) ~= _____63D0_7C73_8BFA_65AF_5355_4F4DID then
        return
    end
    applyManaSteal(attacker, applied * _____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E.D["实际伤害回魔比例"], true)
end
local function ____on_63D0_7C73_8BFA_65AFD_6280_80FD_5B9E_4F8B_7ED3_675F(skillInstanceId)
    if _____63D0_7C73_8BFA_65AFD_6280_80FD_5B9E_4F8B_8868[skillInstanceId] == true then
        __TS__Delete(_____63D0_7C73_8BFA_65AFD_6280_80FD_5B9E_4F8B_8868, skillInstanceId)
    end
end
local function _____63D0_7C73_8BFA_65AFD_64AD_653E_52A8_4F5C(variable)
    local record = variable
    if record == nil or not _____5355_4F4D_5B58_6D3B(record.caster) then
        return
    end
    jass.SetUnitFacing(record.caster, record.facing)
    japi.EXSetUnitFacing(record.caster, record.facing)
    _____64AD_653E_63D0_7C73_8BFA_65AF_914D_7F6E_52A8_4F5C(record.caster, _____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E.D["动作编号"], _____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E.D["动作速度"])
end
local function _____63D0_7C73_8BFA_65AFD_7ED3_7B97(variable)
    local record = variable
    if record == nil or not _____5355_4F4D_5B58_6D3B(record.caster) then
        return
    end
    local cfg = _____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E.D
    local ____temp_18
    if record.target ~= nil and record.target ~= 0 then
        ____temp_18 = jass.GetUnitX(record.target)
    else
        ____temp_18 = jass.GetUnitX(record.caster)
    end
    local centerX = ____temp_18
    local ____temp_19
    if record.target ~= nil and record.target ~= 0 then
        ____temp_19 = jass.GetUnitY(record.target)
    else
        ____temp_19 = jass.GetUnitY(record.caster)
    end
    local centerY = ____temp_19
    local targets = getEnemyUnitsInRange(record.caster, centerX, centerY, cfg["伤害范围"])
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = record.caster,
        ["目标列表"] = targets,
        ["伤害"] = record.damage,
        ["伤害类型"] = jass.DAMAGE_TYPE_NORMAL,
        attack = true,
        ranged = false,
        attackType = jass.ATTACK_TYPE_NORMAL,
        weaponType = jass.WEAPON_TYPE_METAL_HEAVY_SLICE,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____D_6280_80FDID,
        ["技能实例ID"] = record.skillInstanceId,
        ["标签"] = "提米诺斯-吸魔权杖",
        ["参与技能伤害加成"] = true
    })
    _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807(record.caster, record.originX, record.originY)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["返回特效模型"],
        X = jass.GetUnitX(record.caster),
        Y = jass.GetUnitY(record.caster),
        Z = cfg["返回特效Z"],
        ["Z轴角度"] = cfg["返回特效Z轴角度"],
        ["缩放"] = cfg["返回特效缩放"],
        ["持续秒"] = cfg["返回特效持续秒"]
    })
    EXSetUnitMoveType(record.caster, 2)
    jass.SetUnitTimeScale(record.caster, 1)
end
local function ____on_63D0_7C73_8BFA_65AFD(caster, abilityId)
    if abilityId ~= ____D_6280_80FDID or jass.GetUnitTypeId(caster) ~= _____63D0_7C73_8BFA_65AF_5355_4F4DID then
        return
    end
    local target = jass.GetSpellTargetUnit()
    if not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    local cfg = _____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E.D
    local targetFacing = jass.GetUnitFacing(target)
    local skillInstanceId = _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B({["技能ID"] = ____D_6280_80FDID, ["来源类型"] = "单位技能", ["标签"] = "提米诺斯-吸魔权杖", ["持续时间秒"] = 1})
    _____63D0_7C73_8BFA_65AFD_6280_80FD_5B9E_4F8B_8868[skillInstanceId] = true
    _____7ED1_5B9A_5355_4F4D_5F53_524D_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(caster, skillInstanceId)
    local record = {
        caster = caster,
        target = target,
        originX = jass.GetUnitX(caster),
        originY = jass.GetUnitY(caster),
        facing = targetFacing + 180,
        damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * cfg["攻击力倍率"],
        skillInstanceId = skillInstanceId
    }
    _____5F00_59CB_786C_76F4(caster, cfg["硬直秒"])
    EXSetUnitMoveType(caster, 4)
    SetUnitAnimation(caster, "stand")
    jass.SetUnitTimeScale(caster, cfg["动作速度"])
    _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807(
        caster,
        _____6781_5750_6807X(
            jass.GetUnitX(target),
            targetFacing,
            cfg["目标偏移距离"]
        ),
        _____6781_5750_6807Y(
            jass.GetUnitY(target),
            targetFacing,
            cfg["目标偏移距离"]
        )
    )
    _____64AD_653E_63D0_7C73_8BFA_65AF_5355_4F4D_97F3_6548(caster, cfg["全局音效键"])
    addDelayedCallback(cfg["动作延迟秒"] * 1000, _____63D0_7C73_8BFA_65AFD_64AD_653E_52A8_4F5C, record)
    addDelayedCallback((cfg["动作延迟秒"] + cfg["伤害延迟秒"]) * 1000, _____63D0_7C73_8BFA_65AFD_7ED3_7B97, record)
end
registerSpellEffectListener(____on_63D0_7C73_8BFA_65AFD)
registerAppliedFinalDamageListener(____on_63D0_7C73_8BFA_65AFD_6700_7EC8_4F24_5BB3)
_____6CE8_518C_6280_80FD_4F24_5BB3_5B9E_4F8B_7ED3_675F_76D1_542C(____on_63D0_7C73_8BFA_65AFD_6280_80FD_5B9E_4F8B_7ED3_675F)
return ____exports
