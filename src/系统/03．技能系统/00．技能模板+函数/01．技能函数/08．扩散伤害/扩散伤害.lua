--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 扩散伤害
-- 
-- 对主目标造成全额伤害，对范围内其他敌方单位造成百分比伤害。
-- 常用于溅射、分裂、连锁等技能效果。
-- 
-- 使用示例：
--   扩散伤害({ 来源单位, 主目标, 伤害值: 500, 扩散半径: 300, 扩散百分比: 0.5 });
--   // 主目标受到500伤害，300范围内所有其他敌人受到250伤害
local jass = require("jass.common")
local UnitDamageTarget = jass.UnitDamageTarget
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local GetHandleId = jass.GetHandleId
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_0.getUnitsInRange
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_1.isUnitEnemy
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.index")
local debugLogForce = ____require_result_2.debugLogForce
____exports["扩散伤害"] = function(_____53C2_6570)
    local ____53C2_6570_3 = _____53C2_6570
    local _____6765_6E90_5355_4F4D = ____53C2_6570_3["来源单位"]
    local _____4E3B_76EE_6807 = ____53C2_6570_3["主目标"]
    local _____4F24_5BB3_503C = ____53C2_6570_3["伤害值"]
    local _____6269_6563_534A_5F84 = ____53C2_6570_3["扩散半径"]
    local _____6269_6563_767E_5206_6BD4 = ____53C2_6570_3["扩散百分比"]
    local _____653B_51FB_7C7B_578B = ____53C2_6570_3["攻击类型"]
    if _____653B_51FB_7C7B_578B == nil then
        _____653B_51FB_7C7B_578B = ATTACK_TYPE_NORMAL
    end
    local _____4F24_5BB3_7C7B_578B = ____53C2_6570_3["伤害类型"]
    if _____4F24_5BB3_7C7B_578B == nil then
        _____4F24_5BB3_7C7B_578B = DAMAGE_TYPE_NORMAL
    end
    local _____6B66_5668_7C7B_578B = ____53C2_6570_3["武器类型"]
    if _____6B66_5668_7C7B_578B == nil then
        _____6B66_5668_7C7B_578B = nil
    end
    if not _____6765_6E90_5355_4F4D or not _____4E3B_76EE_6807 or _____4F24_5BB3_503C <= 0 then
        return
    end
    debugLogForce(
        "扩散伤害",
        "开始 主目标hid=",
        GetHandleId(_____4E3B_76EE_6807),
        "伤害=",
        _____4F24_5BB3_503C
    )
    local _____4E3B_76EE_6807_521D_59CB_8840_91CF = GetUnitState(_____4E3B_76EE_6807, UNIT_STATE_LIFE)
    UnitDamageTarget(
        _____6765_6E90_5355_4F4D,
        _____4E3B_76EE_6807,
        _____4F24_5BB3_503C,
        false,
        false,
        _____653B_51FB_7C7B_578B,
        _____4F24_5BB3_7C7B_578B,
        _____6B66_5668_7C7B_578B
    )
    local _____4E3B_76EE_6807_5269_4F59_8840_91CF = GetUnitState(_____4E3B_76EE_6807, UNIT_STATE_LIFE)
    debugLogForce(
        "扩散伤害",
        "主目标 初始血量=",
        _____4E3B_76EE_6807_521D_59CB_8840_91CF,
        "剩余血量=",
        _____4E3B_76EE_6807_5269_4F59_8840_91CF
    )
    if _____6269_6563_534A_5F84 <= 0 or _____6269_6563_767E_5206_6BD4 <= 0 then
        debugLogForce(
            "扩散伤害",
            "跳过扩散 半径=",
            _____6269_6563_534A_5F84,
            "百分比=",
            _____6269_6563_767E_5206_6BD4
        )
        return
    end
    local x = GetUnitX(_____4E3B_76EE_6807)
    local y = GetUnitY(_____4E3B_76EE_6807)
    debugLogForce(
        "扩散伤害",
        "主目标坐标 x=",
        x,
        "y=",
        y,
        "扩散半径=",
        _____6269_6563_534A_5F84
    )
    local _____526F_76EE_6807_5217_8868 = getUnitsInRange(x, y, _____6269_6563_534A_5F84)
    debugLogForce("扩散伤害", "getUnitsInRange返回", #_____526F_76EE_6807_5217_8868, "个单位")
    local _____6269_6563_4F24_5BB3_503C = _____4F24_5BB3_503C * _____6269_6563_767E_5206_6BD4
    debugLogForce("扩散伤害", "扩散伤害值=", _____6269_6563_4F24_5BB3_503C)
    for ____, _____526F_76EE_6807 in ipairs(_____526F_76EE_6807_5217_8868) do
        do
            local _____526F_76EE_6807hid = GetHandleId(_____526F_76EE_6807)
            if _____526F_76EE_6807 == _____4E3B_76EE_6807 then
                debugLogForce("扩散伤害", "跳过主目标 hid=", _____526F_76EE_6807hid)
                goto __continue5
            end
            local _____662F_654C_4EBA = isUnitEnemy(_____526F_76EE_6807, _____6765_6E90_5355_4F4D)
            debugLogForce(
                "扩散伤害",
                "副目标 hid=",
                _____526F_76EE_6807hid,
                "是敌人=",
                _____662F_654C_4EBA
            )
            if not _____662F_654C_4EBA then
                goto __continue5
            end
            local _____526F_76EE_6807_521D_59CB_8840_91CF = GetUnitState(_____526F_76EE_6807, UNIT_STATE_LIFE)
            UnitDamageTarget(
                _____6765_6E90_5355_4F4D,
                _____526F_76EE_6807,
                _____6269_6563_4F24_5BB3_503C,
                false,
                false,
                _____653B_51FB_7C7B_578B,
                _____4F24_5BB3_7C7B_578B,
                _____6B66_5668_7C7B_578B
            )
            local _____526F_76EE_6807_5269_4F59_8840_91CF = GetUnitState(_____526F_76EE_6807, UNIT_STATE_LIFE)
            debugLogForce(
                "扩散伤害",
                "副目标 hid=",
                _____526F_76EE_6807hid,
                "初始血量=",
                _____526F_76EE_6807_521D_59CB_8840_91CF,
                "剩余血量=",
                _____526F_76EE_6807_5269_4F59_8840_91CF
            )
        end
        ::__continue5::
    end
    debugLogForce("扩散伤害", "结束")
end
return ____exports
