--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____6C6D_51A5_8840_6756_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["汭冥血杖物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____6C6D_51A5_8840_6756_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["汭冥血杖配置"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围")
local _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA = ____require_result_1["获取坐标范围敌人"]
local _____5355_4F4D_662F_5426_6709_6548_4E14_654C_5BF9 = ____require_result_1["单位是否有效且敌对"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createUnitEffect = ____require_result_2.createUnitEffect
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local getObjectPropertyRealSafe = ____require_result_3.getObjectPropertyRealSafe
local ObjectType = ____require_result_3.ObjectType
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.01．持续恢复生命魔法")
local _____65BD_52A0_6301_7EED_6062_590D_751F_547D_9B54_6CD5 = ____require_result_4["施加持续恢复生命魔法"]
local GetItemTypeId = jass.GetItemTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitLevel = jass.GetUnitLevel
local IsUnitRace = jass.IsUnitRace
local IsHeroUnitId = jass.IsHeroUnitId
local KillUnit = jass.KillUnit
local UnitDamageTarget = jass.UnitDamageTarget
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local RACE_DEMON = jass.RACE_DEMON
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local EXSetEffectSize = japi.EXSetEffectSize
local function _____662F_5426_4E3A_6C6D_51A5_8840_6756(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____6C6D_51A5_8840_6756_7269_54C1ID
end
local function _____76EE_6807_53EF_732E_796D(_____76EE_6807_5355_4F4D, _____7B49_7EA7_4E0A_9650)
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return false
    end
    if IsUnitRace(_____76EE_6807_5355_4F4D, RACE_DEMON) then
        return false
    end
    if IsHeroUnitId(GetUnitTypeId(_____76EE_6807_5355_4F4D)) then
        return false
    end
    return GetUnitLevel(_____76EE_6807_5355_4F4D) <= _____7B49_7EA7_4E0A_9650
end
local function _____65BD_52A0_6C6D_51A5_8840_6756_6062_590D(_____65BD_6CD5_5355_4F4D, _____751F_547D_6062_590D_503C, _____9B54_6CD5_6062_590D_503C)
    _____65BD_52A0_6301_7EED_6062_590D_751F_547D_9B54_6CD5(_____65BD_6CD5_5355_4F4D, _____65BD_6CD5_5355_4F4D, {
        BuffID = _____6C6D_51A5_8840_6756_914D_7F6E.BuffID,
        ["图标路径"] = _____6C6D_51A5_8840_6756_914D_7F6E["图标路径"],
        ["特效路径"] = _____6C6D_51A5_8840_6756_914D_7F6E["恢复特效路径"],
        ["特效挂点"] = _____6C6D_51A5_8840_6756_914D_7F6E["恢复特效挂点"],
        ["特效键"] = _____6C6D_51A5_8840_6756_914D_7F6E["恢复特效键"],
        ["持续时间"] = _____6C6D_51A5_8840_6756_914D_7F6E["恢复持续时间"],
        ["间隔"] = _____6C6D_51A5_8840_6756_914D_7F6E["恢复间隔"],
        ["每跳生命恢复"] = _____751F_547D_6062_590D_503C,
        ["每跳魔法恢复"] = _____9B54_6CD5_6062_590D_503C
    })
end
____exports["执行汭冥血杖献祭"] = function(_____4E0A_4E0B_6587, _____662F_5426_5F3A_5316)
    debugLogForce("19．汭冥血杖", "进入", "执行汭冥血杖献祭")
    local _____65BD_6CD5_5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    local _____76EE_6807_5355_4F4D = _____4E0A_4E0B_6587["目标单位"]
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 or _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return
    end
    local _____7B49_7EA7_4E0A_9650 = _____662F_5426_5F3A_5316 and _____6C6D_51A5_8840_6756_914D_7F6E["强化等级上限"] or _____6C6D_51A5_8840_6756_914D_7F6E["普通等级上限"]
    if not _____76EE_6807_53EF_732E_796D(_____76EE_6807_5355_4F4D, _____7B49_7EA7_4E0A_9650) then
        return
    end
    local _____76EE_6807_6700_5927_751F_547D = GetUnitState(_____76EE_6807_5355_4F4D, UNIT_STATE_MAX_LIFE)
    local _____751F_547D_6062_590D_503C = _____76EE_6807_6700_5927_751F_547D * (_____662F_5426_5F3A_5316 and _____6C6D_51A5_8840_6756_914D_7F6E["强化生命恢复比例"] or _____6C6D_51A5_8840_6756_914D_7F6E["普通生命恢复比例"])
    local _____9B54_6CD5_6062_590D_503C = _____662F_5426_5F3A_5316 and GetUnitState(_____65BD_6CD5_5355_4F4D, UNIT_STATE_MAX_MANA) * _____6C6D_51A5_8840_6756_914D_7F6E["强化魔法恢复比例"] or 0
    local _____76EE_6807X = GetUnitX(_____76EE_6807_5355_4F4D)
    local _____76EE_6807Y = GetUnitY(_____76EE_6807_5355_4F4D)
    local _____7279_6548 = createUnitEffect(
        _____76EE_6807_5355_4F4D,
        _____6C6D_51A5_8840_6756_914D_7F6E["特效挂点"],
        _____6C6D_51A5_8840_6756_914D_7F6E["特效路径"],
        _____6C6D_51A5_8840_6756_914D_7F6E["特效持续时间"],
        "汭冥血杖"
    )
    if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
        EXSetEffectSize(
            _____7279_6548,
            getObjectPropertyRealSafe(
                ObjectType.UNIT,
                GetUnitTypeId(_____76EE_6807_5355_4F4D),
                "modelScale"
            )
        )
    end
    local _____654C_4EBA_5217_8868 = _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA(_____65BD_6CD5_5355_4F4D, _____76EE_6807X, _____76EE_6807Y, _____6C6D_51A5_8840_6756_914D_7F6E["作用范围"])
    do
        local i = 0
        while i < #_____654C_4EBA_5217_8868 do
            do
                local _____654C_4EBA = _____654C_4EBA_5217_8868[i + 1]
                if not _____5355_4F4D_662F_5426_6709_6548_4E14_654C_5BF9(_____654C_4EBA, _____65BD_6CD5_5355_4F4D) then
                    goto __continue14
                end
                UnitDamageTarget(
                    _____65BD_6CD5_5355_4F4D,
                    _____654C_4EBA,
                    _____76EE_6807_6700_5927_751F_547D * _____6C6D_51A5_8840_6756_914D_7F6E["伤害生命系数"],
                    false,
                    true,
                    ATTACK_TYPE_NORMAL,
                    DAMAGE_TYPE_MAGIC,
                    WEAPON_TYPE_WHOKNOWS
                )
            end
            ::__continue14::
            i = i + 1
        end
    end
    KillUnit(_____76EE_6807_5355_4F4D)
    _____65BD_52A0_6C6D_51A5_8840_6756_6062_590D(_____65BD_6CD5_5355_4F4D, _____751F_547D_6062_590D_503C, _____9B54_6CD5_6062_590D_503C)
end
____exports["处理汭冥血杖使用"] = function(_____4E0A_4E0B_6587)
    debugLogForce("19．汭冥血杖", "进入", "处理汭冥血杖使用")
    if not _____662F_5426_4E3A_6C6D_51A5_8840_6756(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    ____exports["执行汭冥血杖献祭"](_____4E0A_4E0B_6587, false)
end
return ____exports
