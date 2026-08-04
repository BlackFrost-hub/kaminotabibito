local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入剧情进度"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["清理剧情运行时单位"]
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["注册剧情运行时单位"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑")
local _____6309_7ED3_7B97_952E_6267_884CBoss_6B7B_4EA1_7ED3_7B97 = ____require_result_0["按结算键执行Boss死亡结算"]
local ____require_result_1 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.04．死亡事件桥接")
local _____6D88_8D39_4FDD_7559_5267_60C5Boss_6B7B_4EA1_51FB_6740_8005 = ____require_result_1["消费保留剧情Boss死亡击杀者"]
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_2.getRegisteredPlayerHero
do
    local ____27_FF0E_6811_9B54_9996_9886_6B7B_4EA1_627F_63A5 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.27．树魔首领死亡承接")
    ____exports["树魔首领死亡承接剧情片段"] = ____27_FF0E_6811_9B54_9996_9886_6B7B_4EA1_627F_63A5["树魔首领死亡承接剧情片段"]
end
local GetDyingUnit = jass.GetDyingUnit
local Player = jass.Player
local pendingTreantDeathUnit = nil
local _____6811_9B54_6B7B_4EA1_8C03_67E5_961F_5458_5F15_7528 = "剧情运行时.树魔死亡调查队员"
____exports["执行树魔首领死亡前置"] = function(_____53C2_6570)
    local _____4E0A_4E0B_6587 = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()
    local ____4E0A_4E0B_6587__89E6_53D1_5355_4F4D_3 = _____4E0A_4E0B_6587["触发单位"]
    if ____4E0A_4E0B_6587__89E6_53D1_5355_4F4D_3 == nil then
        ____4E0A_4E0B_6587__89E6_53D1_5355_4F4D_3 = GetDyingUnit()
    end
    local dyingUnit = ____4E0A_4E0B_6587__89E6_53D1_5355_4F4D_3
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    _____5199_5165_5267_60C5_8FDB_5EA6(__TS__Number(_____53C2_6570["设置剧情进度"]) or __TS__Number(_____53C2_6570["目标进度"]) or 28)
    pendingTreantDeathUnit = dyingUnit
    local killingUnit = _____6D88_8D39_4FDD_7559_5267_60C5Boss_6B7B_4EA1_51FB_6740_8005(dyingUnit)
    local ____temp_4
    if killingUnit ~= nil and killingUnit ~= 0 then
        ____temp_4 = killingUnit
    else
        ____temp_4 = getRegisteredPlayerHero(Player(0))
    end
    local _____8C03_67E5_961F_5458 = ____temp_4
    if _____8C03_67E5_961F_5458 ~= nil and _____8C03_67E5_961F_5458 ~= 0 then
        _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____6811_9B54_6B7B_4EA1_8C03_67E5_961F_5458_5F15_7528, _____8C03_67E5_961F_5458)
    end
end
____exports["执行树魔首领死亡奖励"] = function()
    if pendingTreantDeathUnit ~= nil and pendingTreantDeathUnit ~= 0 then
        _____6309_7ED3_7B97_952E_6267_884CBoss_6B7B_4EA1_7ED3_7B97("主线_树魔首领", pendingTreantDeathUnit)
    end
    pendingTreantDeathUnit = nil
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____6811_9B54_6B7B_4EA1_8C03_67E5_961F_5458_5F15_7528)
end
____exports["树魔首领死亡承接剧情动作注册表"] = {["SW01死亡事件_树魔首领死亡前置"] = ____exports["执行树魔首领死亡前置"], ["SW01死亡事件_树魔首领死亡奖励"] = ____exports["执行树魔首领死亡奖励"]}
return ____exports
