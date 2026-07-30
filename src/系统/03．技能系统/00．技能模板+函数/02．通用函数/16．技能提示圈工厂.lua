local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
--- 技能提示圈工厂
-- 
-- 目标：
-- 1. 调用方可以显式指定圆形、矩形、扇形、安全圆等提示圈。
-- 2. 调用方也可以传 `类型: "自动"`，由常见字段推断提示圈类型。
-- 3. 这里只负责创建提示表现，不承担伤害、筛选、命中、吟唱条等技能逻辑。
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效")
local _____521B_5EFA_77E9_5F62_63D0_793A_5708 = ____require_result_0["创建矩形提示圈"]
local _____521B_5EFA_65B9_5411_76F4_7EBF_63D0_793A_5708 = ____require_result_0["创建方向直线提示圈"]
local _____521B_5EFA_7EA2_8272_6247_5F62_63D0_793A_5708 = ____require_result_0["创建红色扇形提示圈"]
local _____521B_5EFA_8584_5706_5F62_63D0_793A_5708 = ____require_result_0["创建薄圆形提示圈"]
local _____521B_5EFA_767D_8272_5706_5F62_63D0_793A_5708 = ____require_result_0["创建白色圆形提示圈"]
local _____521B_5EFA_6E10_53D8_5706_5F62_63D0_793A_5708 = ____require_result_0["创建渐变圆形提示圈"]
local _____521B_5EFA_53CC_73AF_63D0_793A_5708 = ____require_result_0["创建双环提示圈"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.11．技能属性修正.index")
local _____6309_82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63_4E0A_4E0B_6587_4FEE_6B63_8DDD_79BB = ____require_result_1["按英雄技能距离修正上下文修正距离"]
local function _____8F6C_6570_5B57(value, _____9ED8_8BA4_503C)
    if value == nil or value == false or value == "" then
        return _____9ED8_8BA4_503C
    end
    local n = type(value) == "number" and value or __TS__Number(value)
    return n == n and n or _____9ED8_8BA4_503C
end
local function _____53D6_951A_70B9_5355_4F4D(_____914D_7F6E)
    if _____914D_7F6E["锚点单位"] ~= nil and _____914D_7F6E["锚点单位"] ~= 0 then
        return _____914D_7F6E["锚点单位"]
    end
    if _____914D_7F6E["来源单位"] ~= nil and _____914D_7F6E["来源单位"] ~= 0 then
        return _____914D_7F6E["来源单位"]
    end
    return nil
end
local function _____53D6X(_____914D_7F6E)
    local unit = _____53D6_951A_70B9_5355_4F4D(_____914D_7F6E)
    if _____914D_7F6E.X ~= nil then
        return _____8F6C_6570_5B57(_____914D_7F6E.X, 0)
    end
    if _____914D_7F6E.x ~= nil then
        return _____8F6C_6570_5B57(_____914D_7F6E.x, 0)
    end
    return unit ~= nil and GetUnitX(unit) or 0
end
local function _____53D6Y(_____914D_7F6E)
    local unit = _____53D6_951A_70B9_5355_4F4D(_____914D_7F6E)
    if _____914D_7F6E.Y ~= nil then
        return _____8F6C_6570_5B57(_____914D_7F6E.Y, 0)
    end
    if _____914D_7F6E.y ~= nil then
        return _____8F6C_6570_5B57(_____914D_7F6E.y, 0)
    end
    return unit ~= nil and GetUnitY(unit) or 0
end
local function _____53D6_671D_5411(_____914D_7F6E)
    local unit = _____53D6_951A_70B9_5355_4F4D(_____914D_7F6E)
    if _____914D_7F6E["朝向"] ~= nil then
        return _____8F6C_6570_5B57(_____914D_7F6E["朝向"], 0)
    end
    if _____914D_7F6E["方向角"] ~= nil then
        return _____8F6C_6570_5B57(_____914D_7F6E["方向角"], 0)
    end
    return unit ~= nil and GetUnitFacing(unit) or 0
end
local function _____53D6_6301_7EED_65F6_95F4(_____914D_7F6E)
    if _____914D_7F6E["持续时间"] ~= nil then
        return _____8F6C_6570_5B57(_____914D_7F6E["持续时间"], 1)
    end
    if _____914D_7F6E["预警秒"] ~= nil then
        return _____8F6C_6570_5B57(_____914D_7F6E["预警秒"], 1)
    end
    if _____914D_7F6E["延迟时间"] ~= nil then
        return _____8F6C_6570_5B57(_____914D_7F6E["延迟时间"], 1)
    end
    return 1
end
local function _____4FEE_6B63_63D0_793A_8DDD_79BB(_____914D_7F6E, _____57FA_7840_8DDD_79BB, _____9ED8_8BA4_7528_9014)
    return _____6309_82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63_4E0A_4E0B_6587_4FEE_6B63_8DDD_79BB(_____57FA_7840_8DDD_79BB, _____914D_7F6E["英雄技能距离修正"], _____9ED8_8BA4_7528_9014)
end
local function _____53D6_534A_5F84(_____914D_7F6E, _____9ED8_8BA4_7528_9014)
    if _____9ED8_8BA4_7528_9014 == nil then
        _____9ED8_8BA4_7528_9014 = "效果半径"
    end
    local _____534A_5F84 = 0
    if _____914D_7F6E["半径"] ~= nil then
        _____534A_5F84 = _____8F6C_6570_5B57(_____914D_7F6E["半径"], 0)
    elseif _____914D_7F6E["提示半径"] ~= nil then
        _____534A_5F84 = _____8F6C_6570_5B57(_____914D_7F6E["提示半径"], 0)
    elseif _____914D_7F6E["伤害半径"] ~= nil then
        _____534A_5F84 = _____8F6C_6570_5B57(_____914D_7F6E["伤害半径"], 0)
    elseif _____914D_7F6E["安全区半径"] ~= nil then
        _____534A_5F84 = _____8F6C_6570_5B57(_____914D_7F6E["安全区半径"], 0)
    elseif _____914D_7F6E["外圈半径"] ~= nil then
        _____534A_5F84 = _____8F6C_6570_5B57(_____914D_7F6E["外圈半径"], 0)
    end
    return _____4FEE_6B63_63D0_793A_8DDD_79BB(_____914D_7F6E, _____534A_5F84, _____9ED8_8BA4_7528_9014)
end
local function _____53D6_6247_5F62_5C3A_5BF8(_____914D_7F6E)
    if _____914D_7F6E["扇形模型尺寸"] ~= nil then
        return _____8F6C_6570_5B57(_____914D_7F6E["扇形模型尺寸"], 0.01)
    end
    local _____534A_5F84 = _____53D6_534A_5F84(_____914D_7F6E, "扇形半径")
    if _____534A_5F84 <= 0 then
        return 0.01
    end
    return _____534A_5F84 / 512
end
____exports["推断技能提示圈类型"] = function(_____914D_7F6E)
    local _____7C7B_578B = _____914D_7F6E["类型"] or "自动"
    if _____7C7B_578B ~= "自动" then
        return _____7C7B_578B
    end
    if _____914D_7F6E["安全区半径"] ~= nil then
        return "白色安全圆"
    end
    if _____914D_7F6E["宽度"] ~= nil and _____914D_7F6E["长度"] ~= nil then
        return "矩形"
    end
    if _____914D_7F6E["扇形角度"] ~= nil or _____914D_7F6E["扇形模型尺寸"] ~= nil then
        return "红色扇形"
    end
    if _____914D_7F6E["外圈半径"] ~= nil then
        return "双环"
    end
    return "渐变圆形"
end
--- 创建技能提示圈。
-- 【重要】当类型为“矩形”“直线”“方向直线”时，X/Y 必须传路径起点；底层会自动前移半个长度到模型中点。
____exports["创建技能提示圈"] = function(_____914D_7F6E)
    local _____7C7B_578B = ____exports["推断技能提示圈类型"](_____914D_7F6E)
    if _____7C7B_578B == "无" then
        return nil
    end
    local x = _____53D6X(_____914D_7F6E)
    local y = _____53D6Y(_____914D_7F6E)
    local _____6301_7EED_65F6_95F4 = _____53D6_6301_7EED_65F6_95F4(_____914D_7F6E)
    local _____52A8_753B_901F_5EA6 = _____914D_7F6E["动画速度"]
    local ____914D_7F6E__6765_6E90_5355_4F4D_2 = _____914D_7F6E["来源单位"]
    if ____914D_7F6E__6765_6E90_5355_4F4D_2 == nil then
        ____914D_7F6E__6765_6E90_5355_4F4D_2 = _____914D_7F6E["锚点单位"]
    end
    local _____6765_6E90_5355_4F4D = ____914D_7F6E__6765_6E90_5355_4F4D_2
    if _____7C7B_578B == "矩形" then
        local _____5BBD_5EA6 = _____8F6C_6570_5B57(_____914D_7F6E["宽度"], 0)
        local _____957F_5EA6 = _____4FEE_6B63_63D0_793A_8DDD_79BB(
            _____914D_7F6E,
            _____8F6C_6570_5B57(_____914D_7F6E["长度"], 0),
            "矩形长度"
        )
        if _____5BBD_5EA6 <= 0 or _____957F_5EA6 <= 0 then
            return nil
        end
        _____521B_5EFA_77E9_5F62_63D0_793A_5708(
            x,
            y,
            _____5BBD_5EA6,
            _____957F_5EA6,
            _____53D6_671D_5411(_____914D_7F6E),
            _____6301_7EED_65F6_95F4,
            _____52A8_753B_901F_5EA6,
            _____6765_6E90_5355_4F4D
        )
        return nil
    end
    if _____7C7B_578B == "直线" or _____7C7B_578B == "方向直线" then
        local _____5BBD_5EA6 = _____8F6C_6570_5B57(_____914D_7F6E["宽度"], 0)
        local _____957F_5EA6 = _____4FEE_6B63_63D0_793A_8DDD_79BB(
            _____914D_7F6E,
            _____8F6C_6570_5B57(_____914D_7F6E["长度"], 0),
            "矩形长度"
        )
        if _____5BBD_5EA6 <= 0 or _____957F_5EA6 <= 0 then
            return nil
        end
        _____521B_5EFA_65B9_5411_76F4_7EBF_63D0_793A_5708(
            x,
            y,
            _____5BBD_5EA6,
            _____957F_5EA6,
            _____53D6_671D_5411(_____914D_7F6E),
            _____6301_7EED_65F6_95F4,
            _____52A8_753B_901F_5EA6,
            _____6765_6E90_5355_4F4D
        )
        return nil
    end
    if _____7C7B_578B == "扇形" or _____7C7B_578B == "红色扇形" then
        _____521B_5EFA_7EA2_8272_6247_5F62_63D0_793A_5708(
            x,
            y,
            _____53D6_671D_5411(_____914D_7F6E),
            _____53D6_6247_5F62_5C3A_5BF8(_____914D_7F6E),
            _____6301_7EED_65F6_95F4,
            _____52A8_753B_901F_5EA6,
            _____6765_6E90_5355_4F4D
        )
        return nil
    end
    local _____534A_5F84 = _____53D6_534A_5F84(_____914D_7F6E)
    if _____534A_5F84 <= 0 then
        return nil
    end
    if _____7C7B_578B == "圆形" or _____7C7B_578B == "敌方圆形" then
        _____521B_5EFA_8584_5706_5F62_63D0_793A_5708(
            x,
            y,
            _____534A_5F84,
            _____6301_7EED_65F6_95F4,
            _____52A8_753B_901F_5EA6,
            _____6765_6E90_5355_4F4D
        )
        return nil
    end
    if _____7C7B_578B == "白色安全圆" then
        _____521B_5EFA_767D_8272_5706_5F62_63D0_793A_5708(
            x,
            y,
            _____534A_5F84,
            _____6301_7EED_65F6_95F4,
            _____52A8_753B_901F_5EA6,
            _____6765_6E90_5355_4F4D
        )
        return nil
    end
    if _____7C7B_578B == "双环" then
        return _____521B_5EFA_53CC_73AF_63D0_793A_5708(
            x,
            y,
            _____534A_5F84,
            _____6301_7EED_65F6_95F4,
            _____52A8_753B_901F_5EA6,
            _____6765_6E90_5355_4F4D
        )
    end
    return _____521B_5EFA_6E10_53D8_5706_5F62_63D0_793A_5708(
        x,
        y,
        _____534A_5F84,
        _____6301_7EED_65F6_95F4,
        _____52A8_753B_901F_5EA6,
        _____6765_6E90_5355_4F4D
    )
end
return ____exports
