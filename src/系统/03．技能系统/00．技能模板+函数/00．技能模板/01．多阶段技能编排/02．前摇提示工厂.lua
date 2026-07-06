local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
--- 前摇提示工厂
-- 
-- 给 `开始技能前摇(...)` 提供可直接复用的 `创建提示特效 / 销毁提示特效` 回调组。
-- 保持手写显式组合，但减少重复样板。
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效")
local _____521B_5EFA_77E9_5F62_63D0_793A_5708_7279_6548 = ____require_result_0["创建矩形提示圈特效"]
local _____521B_5EFA_7EA2_8272_6247_5F62_63D0_793A_5708_7279_6548 = ____require_result_0["创建红色扇形提示圈特效"]
local _____521B_5EFA_8584_5706_5F62_63D0_793A_5708_7279_6548 = ____require_result_0["创建薄圆形提示圈特效"]
local _____7ACB_5373_9500_6BC1_63D0_793A_5708_7279_6548 = ____require_result_0["立即销毁提示圈特效"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.11．技能属性修正.index")
local _____6309_82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63_4E0A_4E0B_6587_4FEE_6B63_8DDD_79BB = ____require_result_1["按英雄技能距离修正上下文修正距离"]
local function _____9ED8_8BA4_9500_6BC1_524D_6447_63D0_793A_7279_6548(_____7279_6548_53E5_67C4)
    _____7ACB_5373_9500_6BC1_63D0_793A_5708_7279_6548(_____7279_6548_53E5_67C4)
end
local function _____53D6_6247_5F62_63D0_793A_5708_5C3A_5BF8(_____534A_5F84)
    if _____534A_5F84 <= 0 then
        return 0.01
    end
    return _____534A_5F84 / 512
end
local function _____4FEE_6B63_524D_6447_8DDD_79BB(_____57FA_7840_8DDD_79BB, _____4E0A_4E0B_6587, _____9ED8_8BA4_7528_9014)
    return _____6309_82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63_4E0A_4E0B_6587_4FEE_6B63_8DDD_79BB(_____57FA_7840_8DDD_79BB, _____4E0A_4E0B_6587, _____9ED8_8BA4_7528_9014)
end
____exports["创建圆形前摇提示"] = function(_____534A_5F84, _____6301_7EED_65F6_95F4, _____6765_6E90_5355_4F4D, _____82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63)
    return {
        ["创建提示特效"] = function(_____5355_4F4D)
            local _____4FEE_6B63_534A_5F84 = _____4FEE_6B63_524D_6447_8DDD_79BB(_____534A_5F84, _____82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63, "效果半径")
            local ____521B_5EFA_8584_5706_5F62_63D0_793A_5708_7279_6548_4 = _____521B_5EFA_8584_5706_5F62_63D0_793A_5708_7279_6548
            local ____array_3 = __TS__SparseArrayNew(
                GetUnitX(_____5355_4F4D),
                GetUnitY(_____5355_4F4D),
                _____4FEE_6B63_534A_5F84,
                _____6301_7EED_65F6_95F4 > 0 and 1 / _____6301_7EED_65F6_95F4 or 1
            )
            local ____6765_6E90_5355_4F4D_2 = _____6765_6E90_5355_4F4D
            if ____6765_6E90_5355_4F4D_2 == nil then
                ____6765_6E90_5355_4F4D_2 = _____5355_4F4D
            end
            __TS__SparseArrayPush(____array_3, ____6765_6E90_5355_4F4D_2)
            return ____521B_5EFA_8584_5706_5F62_63D0_793A_5708_7279_6548_4(__TS__SparseArraySpread(____array_3))
        end,
        ["销毁提示特效"] = _____9ED8_8BA4_9500_6BC1_524D_6447_63D0_793A_7279_6548
    }
end
____exports["创建矩形前摇提示"] = function(_____5BBD_5EA6, _____957F_5EA6, _____6301_7EED_65F6_95F4, _____82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63)
    return {
        ["创建提示特效"] = function(_____5355_4F4D)
            local _____4FEE_6B63_957F_5EA6 = _____4FEE_6B63_524D_6447_8DDD_79BB(_____957F_5EA6, _____82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63, "矩形长度")
            return _____521B_5EFA_77E9_5F62_63D0_793A_5708_7279_6548(
                GetUnitX(_____5355_4F4D),
                GetUnitY(_____5355_4F4D),
                _____5BBD_5EA6,
                _____4FEE_6B63_957F_5EA6,
                GetUnitFacing(_____5355_4F4D),
                _____6301_7EED_65F6_95F4 > 0 and 1 / _____6301_7EED_65F6_95F4 or 1
            )
        end,
        ["销毁提示特效"] = _____9ED8_8BA4_9500_6BC1_524D_6447_63D0_793A_7279_6548
    }
end
____exports["创建冲锋路径前摇提示"] = function(_____8DEF_5F84_957F_5EA6, _____8DEF_5F84_5BBD_5EA6, _____6301_7EED_65F6_95F4, _____82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63)
    return ____exports["创建矩形前摇提示"](_____8DEF_5F84_5BBD_5EA6, _____8DEF_5F84_957F_5EA6, _____6301_7EED_65F6_95F4, _____82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63)
end
____exports["创建扇形前摇提示"] = function(_____534A_5F84, _____6301_7EED_65F6_95F4, _____82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63)
    return {
        ["创建提示特效"] = function(_____5355_4F4D)
            local _____4FEE_6B63_534A_5F84 = _____4FEE_6B63_524D_6447_8DDD_79BB(_____534A_5F84, _____82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63, "扇形半径")
            return _____521B_5EFA_7EA2_8272_6247_5F62_63D0_793A_5708_7279_6548(
                GetUnitX(_____5355_4F4D),
                GetUnitY(_____5355_4F4D),
                GetUnitFacing(_____5355_4F4D),
                _____53D6_6247_5F62_63D0_793A_5708_5C3A_5BF8(_____4FEE_6B63_534A_5F84),
                _____6301_7EED_65F6_95F4 > 0 and 1 / _____6301_7EED_65F6_95F4 or 1
            )
        end,
        ["销毁提示特效"] = _____9ED8_8BA4_9500_6BC1_524D_6447_63D0_793A_7279_6548
    }
end
return ____exports
