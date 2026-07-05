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
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local GetHandleId = jass.GetHandleId
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_0["造成单体技能伤害"]
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_0["造成AOE技能伤害"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_1.getUnitsInRange
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_2.isUnitEnemy
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.index")
local debugLogForce = ____require_result_3.debugLogForce
____exports["扩散伤害"] = function(_____53C2_6570)
    local ____53C2_6570_4 = _____53C2_6570
    local _____6765_6E90_5355_4F4D = ____53C2_6570_4["来源单位"]
    local _____4E3B_76EE_6807 = ____53C2_6570_4["主目标"]
    local _____4F24_5BB3_503C = ____53C2_6570_4["伤害值"]
    local _____6269_6563_534A_5F84 = ____53C2_6570_4["扩散半径"]
    local _____6269_6563_767E_5206_6BD4 = ____53C2_6570_4["扩散百分比"]
    local _____662F_5426_5305_542B_4E3B_76EE_6807 = ____53C2_6570_4["是否包含主目标"]
    if _____662F_5426_5305_542B_4E3B_76EE_6807 == nil then
        _____662F_5426_5305_542B_4E3B_76EE_6807 = true
    end
    local _____653B_51FB_7C7B_578B = ____53C2_6570_4["攻击类型"]
    if _____653B_51FB_7C7B_578B == nil then
        _____653B_51FB_7C7B_578B = ATTACK_TYPE_NORMAL
    end
    local _____4F24_5BB3_7C7B_578B = ____53C2_6570_4["伤害类型"]
    if _____4F24_5BB3_7C7B_578B == nil then
        _____4F24_5BB3_7C7B_578B = DAMAGE_TYPE_NORMAL
    end
    local _____6B66_5668_7C7B_578B = ____53C2_6570_4["武器类型"]
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
    if _____662F_5426_5305_542B_4E3B_76EE_6807 then
        _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
            ["来源"] = _____6765_6E90_5355_4F4D,
            ["目标"] = _____4E3B_76EE_6807,
            ["伤害"] = _____4F24_5BB3_503C,
            ["伤害类型"] = _____4F24_5BB3_7C7B_578B,
            ranged = false,
            attackType = _____653B_51FB_7C7B_578B,
            weaponType = _____6B66_5668_7C7B_578B,
            ["来源类型"] = _____53C2_6570["来源类型"] or "单位技能",
            ["技能ID"] = _____53C2_6570["技能ID"],
            ["技能实例ID"] = _____53C2_6570["技能实例ID"],
            ["标签"] = _____53C2_6570["技能标签"],
            ["参与技能伤害加成"] = _____53C2_6570["参与技能伤害加成"]
        })
        local _____4E3B_76EE_6807_5269_4F59_8840_91CF = GetUnitState(_____4E3B_76EE_6807, UNIT_STATE_LIFE)
        debugLogForce(
            "扩散伤害",
            "主目标 初始血量=",
            _____4E3B_76EE_6807_521D_59CB_8840_91CF,
            "剩余血量=",
            _____4E3B_76EE_6807_5269_4F59_8840_91CF
        )
    else
        debugLogForce("扩散伤害", "跳过主目标", "初始血量=", _____4E3B_76EE_6807_521D_59CB_8840_91CF)
    end
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
                goto __continue7
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
                goto __continue7
            end
            local _____526F_76EE_6807_521D_59CB_8840_91CF = GetUnitState(_____526F_76EE_6807, UNIT_STATE_LIFE)
            _____9020_6210AOE_6280_80FD_4F24_5BB3({
                ["来源"] = _____6765_6E90_5355_4F4D,
                ["目标"] = _____526F_76EE_6807,
                ["伤害"] = _____6269_6563_4F24_5BB3_503C,
                ["伤害类型"] = _____4F24_5BB3_7C7B_578B,
                ranged = false,
                attackType = _____653B_51FB_7C7B_578B,
                weaponType = _____6B66_5668_7C7B_578B,
                ["来源类型"] = _____53C2_6570["来源类型"] or "单位技能",
                ["技能ID"] = _____53C2_6570["技能ID"],
                ["技能实例ID"] = _____53C2_6570["技能实例ID"],
                ["标签"] = _____53C2_6570["技能标签"],
                ["参与技能伤害加成"] = _____53C2_6570["参与技能伤害加成"]
            })
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
        ::__continue7::
    end
    debugLogForce("扩散伤害", "结束")
end
return ____exports
