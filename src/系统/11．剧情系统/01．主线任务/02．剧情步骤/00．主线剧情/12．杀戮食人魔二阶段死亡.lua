local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
local _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入当前剧情动作上下文"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑")
local _____6309_7ED3_7B97_952E_6267_884CBoss_6B7B_4EA1_7ED3_7B97 = ____require_result_0["按结算键执行Boss死亡结算"]
local ____require_result_1 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.04．死亡事件桥接")
local _____6D88_8D39_4FDD_7559_5267_60C5Boss_6B7B_4EA1_51FB_6740_8005 = ____require_result_1["消费保留剧情Boss死亡击杀者"]
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_2.YDUserDataGetSafe
local YDUserDataClearSafe = ____require_result_2.YDUserDataClearSafe
local ____require_result_3 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.13．剧情片段清理注册表")
local _____6CE8_518C_5267_60C5_7247_6BB5_6E05_7406 = ____require_result_3["注册剧情片段清理"]
do
    local ____12_FF0E_6740_622E_98DF_4EBA_9B54_4E8C_9636_6BB5_6B7B_4EA1 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.12．杀戮食人魔二阶段死亡")
    ____exports["杀戮食人魔死亡剧情片段"] = ____12_FF0E_6740_622E_98DF_4EBA_9B54_4E8C_9636_6BB5_6B7B_4EA1["杀戮食人魔死亡剧情片段"]
end
local GetDyingUnit = jass.GetDyingUnit
local ForGroup = jass.ForGroup
local GetEnumUnit = jass.GetEnumUnit
local _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54_5C38_4F53 = nil
local _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54_51FB_6740_8005 = nil
local _____6740_622E_98DF_4EBA_9B54_6B7B_4EA1_9700_6E05_7406_82F1_96C4_5B9E_6570_952E = {"沙漠食人魔", "沙漠食人魔蓄力", "沙漠食人魔蓄力2"}
local function ____on_6E05_7406_82F1_96C4_98DF_4EBA_9B54_84C4_529B_6570_636E()
    local hero = GetEnumUnit()
    if hero == nil or hero == 0 then
        return
    end
    do
        local i = 0
        while i < #_____6740_622E_98DF_4EBA_9B54_6B7B_4EA1_9700_6E05_7406_82F1_96C4_5B9E_6570_952E do
            YDUserDataClearSafe("unit", hero, _____6740_622E_98DF_4EBA_9B54_6B7B_4EA1_9700_6E05_7406_82F1_96C4_5B9E_6570_952E[i + 1], "real")
            i = i + 1
        end
    end
end
local function _____6E05_7406_5168_4F53_82F1_96C4_98DF_4EBA_9B54_84C4_529B_6570_636E()
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    if _____73A9_5BB6_82F1_96C4_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_7EC4 ~= 0 then
        ForGroup(_____73A9_5BB6_82F1_96C4_7EC4, ____on_6E05_7406_82F1_96C4_98DF_4EBA_9B54_84C4_529B_6570_636E)
    end
end
local function _____6E05_7406_6740_622E_98DF_4EBA_9B54_6B7B_4EA1_7247_6BB5_72B6_6001()
    _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54_5C38_4F53 = nil
    _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54_51FB_6740_8005 = nil
end
____exports["执行杀戮食人魔死亡前置"] = function()
    local _____4E0A_4E0B_6587 = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()
    local _____4E8B_4EF6_6B7B_4EA1_5355_4F4D = GetDyingUnit()
    local ____temp_4
    if _____4E8B_4EF6_6B7B_4EA1_5355_4F4D ~= nil and _____4E8B_4EF6_6B7B_4EA1_5355_4F4D ~= 0 then
        ____temp_4 = _____4E8B_4EF6_6B7B_4EA1_5355_4F4D
    else
        ____temp_4 = _____4E0A_4E0B_6587["触发单位"]
    end
    local dyingUnit = ____temp_4
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    local killingUnit = _____6D88_8D39_4FDD_7559_5267_60C5Boss_6B7B_4EA1_51FB_6740_8005(dyingUnit)
    _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54_5C38_4F53 = dyingUnit
    local ____temp_5
    if killingUnit ~= nil and killingUnit ~= 0 then
        ____temp_5 = killingUnit
    else
        ____temp_5 = nil
    end
    _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54_51FB_6740_8005 = ____temp_5
    if _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54_51FB_6740_8005 ~= nil then
        _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587(__TS__ObjectAssign({}, _____4E0A_4E0B_6587, {["触发单位"] = _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54_51FB_6740_8005}))
    end
end
____exports["执行杀戮食人魔死亡奖励"] = function()
    local dyingUnit = _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54_5C38_4F53
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    _____6309_7ED3_7B97_952E_6267_884CBoss_6B7B_4EA1_7ED3_7B97("主线_杀戮食人魔", dyingUnit, _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54_51FB_6740_8005)
    _____6E05_7406_5168_4F53_82F1_96C4_98DF_4EBA_9B54_84C4_529B_6570_636E()
    _____6E05_7406_6740_622E_98DF_4EBA_9B54_6B7B_4EA1_7247_6BB5_72B6_6001()
end
____exports["杀戮食人魔二阶段死亡剧情动作注册表"] = {["SW01死亡事件_杀戮食人魔死亡前置"] = ____exports["执行杀戮食人魔死亡前置"], ["SW01死亡事件_杀戮食人魔死亡奖励"] = ____exports["执行杀戮食人魔死亡奖励"]}
_____6CE8_518C_5267_60C5_7247_6BB5_6E05_7406("jlc_slaughter_ogre_death", _____6E05_7406_6740_622E_98DF_4EBA_9B54_6B7B_4EA1_7247_6BB5_72B6_6001)
return ____exports
