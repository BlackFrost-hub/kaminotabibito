--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 通用函数 - 技能表现预设
-- 
-- 说明：
-- 1. 这里只提供高频可复用的技能表现预设，不承担技能逻辑。
-- 2. 预设分两类：区域预警预设、结果反馈预设。
-- 3. 目标是减少后续技能里反复手写“常见提示圈 + 常见命中/成功/中断特效”。
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_0.createTimedEffect
local createUnitEffect = ____require_result_0.createUnitEffect
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效")
local _____521B_5EFA_8584_5706_5F62_63D0_793A_5708 = ____require_result_1["创建薄圆形提示圈"]
local _____521B_5EFA_767D_8272_5706_5F62_63D0_793A_5708 = ____require_result_1["创建白色圆形提示圈"]
local _____521B_5EFA_6E10_53D8_5706_5F62_63D0_793A_5708 = ____require_result_1["创建渐变圆形提示圈"]
local _____521B_5EFA_53CC_73AF_63D0_793A_5708 = ____require_result_1["创建双环提示圈"]
local _____547D_4E2D_53CD_9988_7279_6548 = "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl"
local _____6210_529F_53CD_9988_7279_6548 = "Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl"
local _____4E2D_65AD_53CD_9988_7279_6548 = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
local _____5931_8D25_53CD_9988_7279_6548 = "Abilities\\Spells\\Other\\GeneralAuraTarget\\GeneralAuraTarget.mdl"
____exports["创建敌方危险圆圈预设"] = function(x, y, _____534A_5F84, _____6301_7EED_65F6_95F4, speed)
    _____521B_5EFA_8584_5706_5F62_63D0_793A_5708(
        x,
        y,
        _____534A_5F84,
        _____6301_7EED_65F6_95F4,
        speed
    )
end
____exports["创建友方安全圆圈预设"] = function(x, y, _____534A_5F84, _____6301_7EED_65F6_95F4, speed)
    _____521B_5EFA_767D_8272_5706_5F62_63D0_793A_5708(
        x,
        y,
        _____534A_5F84,
        _____6301_7EED_65F6_95F4,
        speed
    )
end
____exports["创建敌方渐变圆圈预设"] = function(x, y, _____534A_5F84, _____6301_7EED_65F6_95F4, speed)
    return _____521B_5EFA_6E10_53D8_5706_5F62_63D0_793A_5708(
        x,
        y,
        _____534A_5F84,
        _____6301_7EED_65F6_95F4,
        speed
    )
end
____exports["创建双环区域预设"] = function(x, y, _____5916_5708_534A_5F84, _____6301_7EED_65F6_95F4, speed)
    return _____521B_5EFA_53CC_73AF_63D0_793A_5708(
        x,
        y,
        _____5916_5708_534A_5F84,
        _____6301_7EED_65F6_95F4,
        speed
    )
end
____exports["播放命中反馈预设"] = function(x, y, _____6301_7EED_65F6_95F4)
    if _____6301_7EED_65F6_95F4 == nil then
        _____6301_7EED_65F6_95F4 = 1
    end
    return createTimedEffect(
        _____547D_4E2D_53CD_9988_7279_6548,
        x,
        y,
        0,
        _____6301_7EED_65F6_95F4
    )
end
____exports["播放单位命中反馈预设"] = function(_____5355_4F4D, _____6301_7EED_65F6_95F4, _____6302_70B9)
    if _____6301_7EED_65F6_95F4 == nil then
        _____6301_7EED_65F6_95F4 = 0.8
    end
    if _____6302_70B9 == nil then
        _____6302_70B9 = "origin"
    end
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    return createUnitEffect(
        _____5355_4F4D,
        _____6302_70B9,
        _____547D_4E2D_53CD_9988_7279_6548,
        _____6301_7EED_65F6_95F4,
        "skill_hit_feedback"
    )
end
____exports["播放成功反馈预设"] = function(_____5355_4F4D, _____6301_7EED_65F6_95F4, _____6302_70B9)
    if _____6301_7EED_65F6_95F4 == nil then
        _____6301_7EED_65F6_95F4 = 1
    end
    if _____6302_70B9 == nil then
        _____6302_70B9 = "origin"
    end
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    return createUnitEffect(
        _____5355_4F4D,
        _____6302_70B9,
        _____6210_529F_53CD_9988_7279_6548,
        _____6301_7EED_65F6_95F4,
        "skill_success_feedback"
    )
end
____exports["播放中断反馈预设"] = function(_____5355_4F4D, _____6301_7EED_65F6_95F4, _____6302_70B9)
    if _____6301_7EED_65F6_95F4 == nil then
        _____6301_7EED_65F6_95F4 = 0.8
    end
    if _____6302_70B9 == nil then
        _____6302_70B9 = "origin"
    end
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    return createUnitEffect(
        _____5355_4F4D,
        _____6302_70B9,
        _____4E2D_65AD_53CD_9988_7279_6548,
        _____6301_7EED_65F6_95F4,
        "skill_interrupt_feedback"
    )
end
____exports["播放失败反馈预设"] = function(_____5355_4F4D, _____6301_7EED_65F6_95F4, _____6302_70B9)
    if _____6301_7EED_65F6_95F4 == nil then
        _____6301_7EED_65F6_95F4 = 1
    end
    if _____6302_70B9 == nil then
        _____6302_70B9 = "overhead"
    end
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    return createUnitEffect(
        _____5355_4F4D,
        _____6302_70B9,
        _____5931_8D25_53CD_9988_7279_6548,
        _____6301_7EED_65F6_95F4,
        "skill_fail_feedback"
    )
end
____exports["播放坐标命中反馈预设"] = function(X, Y, _____6301_7EED_65F6_95F4)
    if _____6301_7EED_65F6_95F4 == nil then
        _____6301_7EED_65F6_95F4 = 1
    end
    return ____exports["播放命中反馈预设"](X, Y, _____6301_7EED_65F6_95F4)
end
____exports["播放单位脚下命中反馈预设"] = function(_____5355_4F4D, _____6301_7EED_65F6_95F4)
    if _____6301_7EED_65F6_95F4 == nil then
        _____6301_7EED_65F6_95F4 = 1
    end
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    return ____exports["播放命中反馈预设"](
        GetUnitX(_____5355_4F4D),
        GetUnitY(_____5355_4F4D),
        _____6301_7EED_65F6_95F4
    )
end
return ____exports
