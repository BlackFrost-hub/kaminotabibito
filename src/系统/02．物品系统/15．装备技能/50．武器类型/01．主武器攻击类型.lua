--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____09_FF0E_88C5_5907_6218_6597_5224_65AD = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.09．装备战斗判断")
local _____53D6_5355_4F4DID = ____09_FF0E_88C5_5907_6218_6597_5224_65AD["取单位ID"]
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemPickup = ____require_result_0.onItemPickup
local onItemDrop = ____require_result_0.onItemDrop
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.07．武器类型")
local _____7269_54C1_662F_5426_4E3B_6B66_5668 = ____require_result_1["物品是否主武器"]
local _____540C_6B65_5355_4F4D_4E3B_6B66_5668_653B_51FB_7C7B_578B = ____require_result_1["同步单位主武器攻击类型"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.26．延迟去重批处理队列")
local _____521B_5EFA_5EF6_8FDF_53BB_91CD_6279_5904_7406_961F_5217 = ____require_result_2["创建延迟去重批处理队列"]
local ____require_result_3 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_3["是玩家英雄组单位"]
local _____5DF2_6CE8_518C_4E3B_6B66_5668_653B_51FB_7C7B_578B_76D1_542C = false
local _____4E3B_6B66_5668_653B_51FB_7C7B_578B_5237_65B0_961F_5217 = _____521B_5EFA_5EF6_8FDF_53BB_91CD_6279_5904_7406_961F_5217(
    "主武器攻击类型刷新",
    {
        ["延迟毫秒"] = 50,
        ["处理"] = function(unit)
            if unit == nil or unit == 0 then
                return
            end
            if not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(unit) then
                return
            end
            _____540C_6B65_5355_4F4D_4E3B_6B66_5668_653B_51FB_7C7B_578B(unit)
        end
    }
)
local function _____6392_961F_5237_65B0_5355_4F4D_4E3B_6B66_5668_653B_51FB_7C7B_578B(unit)
    local unitId = _____53D6_5355_4F4DID(unit)
    if unitId == 0 then
        return
    end
    _____4E3B_6B66_5668_653B_51FB_7C7B_578B_5237_65B0_961F_5217["加入"](unitId, unit)
end
local function ____on_4E3B_6B66_5668_62FE_53D6(unit, item)
    if not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(unit) then
        return
    end
    if not _____7269_54C1_662F_5426_4E3B_6B66_5668(item) then
        return
    end
    _____6392_961F_5237_65B0_5355_4F4D_4E3B_6B66_5668_653B_51FB_7C7B_578B(unit)
end
local function ____on_4E3B_6B66_5668_4E22_5F03(unit, item)
    if not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(unit) then
        return
    end
    if not _____7269_54C1_662F_5426_4E3B_6B66_5668(item) then
        return
    end
    _____6392_961F_5237_65B0_5355_4F4D_4E3B_6B66_5668_653B_51FB_7C7B_578B(unit)
end
____exports["初始化主武器攻击类型联动"] = function()
    if _____5DF2_6CE8_518C_4E3B_6B66_5668_653B_51FB_7C7B_578B_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_4E3B_6B66_5668_653B_51FB_7C7B_578B_76D1_542C = true
    onItemPickup(____on_4E3B_6B66_5668_62FE_53D6)
    onItemDrop(____on_4E3B_6B66_5668_4E22_5F03)
end
____exports["初始化主武器攻击类型联动"]()
return ____exports
