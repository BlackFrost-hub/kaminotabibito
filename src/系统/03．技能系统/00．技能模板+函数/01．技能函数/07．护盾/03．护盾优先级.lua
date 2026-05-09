local ____lualib = require("lualib_bundle")
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local ____exports = {}
local ____01_FF0E_62A4_76FE_7C7B_578B = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.01．护盾类型")
local _____62A4_76FE_7C7B_578B = ____01_FF0E_62A4_76FE_7C7B_578B["护盾类型"]
--- 对护盾列表按优先级排序（返回新数组，不修改原数组）
-- 
-- 排序规则：
-- 1. 类型优先级 降序（专用 > 通用）
-- 2. 抵挡优先级 降序（高优先级先被打）
-- 3. 剩余时间 升序（最早到期先被打）
____exports["排序护盾列表"] = function(_____62A4_76FE_5217_8868)
    return __TS__ArraySort(
        {table.unpack(_____62A4_76FE_5217_8868)},
        function(____, a, b)
            if a["类型优先级"] ~= b["类型优先级"] then
                return b["类型优先级"] - a["类型优先级"]
            end
            if a["抵挡优先级"] ~= b["抵挡优先级"] then
                return b["抵挡优先级"] - a["抵挡优先级"]
            end
            local aTime = a["剩余时间"] > 0 and a["剩余时间"] or math.huge
            local bTime = b["剩余时间"] > 0 and b["剩余时间"] or math.huge
            return aTime - bTime
        end
    )
end
--- 筛选可匹配伤害类型的护盾
-- 
-- 规则：
-- - 通用护盾可吸收所有伤害（包括真实伤害）
-- - 物理护盾只吸收物理伤害
-- - 魔法护盾只吸收魔法伤害
____exports["筛选可匹配护盾"] = function(_____62A4_76FE_5217_8868, _____662F_7269_7406_4F24_5BB3, _____662F_9B54_6CD5_4F24_5BB3)
    return __TS__ArrayFilter(
        _____62A4_76FE_5217_8868,
        function(____, _____5B9E_4F8B)
            if _____5B9E_4F8B["类型"] == _____62A4_76FE_7C7B_578B["通用"] then
                return true
            end
            if _____5B9E_4F8B["类型"] == _____62A4_76FE_7C7B_578B["物理"] and _____662F_7269_7406_4F24_5BB3 then
                return true
            end
            if _____5B9E_4F8B["类型"] == _____62A4_76FE_7C7B_578B["魔法"] and _____662F_9B54_6CD5_4F24_5BB3 then
                return true
            end
            return false
        end
    )
end
--- 获取按优先级排序的可匹配护盾列表
____exports["获取可匹配护盾列表"] = function(_____62A4_76FE_5217_8868, _____662F_7269_7406_4F24_5BB3, _____662F_9B54_6CD5_4F24_5BB3)
    local _____5339_914D_5217_8868 = ____exports["筛选可匹配护盾"](_____62A4_76FE_5217_8868, _____662F_7269_7406_4F24_5BB3, _____662F_9B54_6CD5_4F24_5BB3)
    return ____exports["排序护盾列表"](_____5339_914D_5217_8868)
end
return ____exports
