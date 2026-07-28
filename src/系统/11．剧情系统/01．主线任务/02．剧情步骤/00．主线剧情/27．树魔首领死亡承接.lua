local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入剧情进度"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑")
local _____6309_7ED3_7B97_952E_83B7_53D6Boss_6B7B_4EA1_7ED3_7B97_914D_7F6E = ____require_result_0["按结算键获取Boss死亡结算配置"]
local _____6267_884CBoss_6B7B_4EA1_7ED3_7B97 = ____require_result_0["执行Boss死亡结算"]
do
    local ____27_FF0E_6811_9B54_9996_9886_6B7B_4EA1_627F_63A5 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.27．树魔首领死亡承接")
    ____exports["树魔首领死亡承接剧情片段"] = ____27_FF0E_6811_9B54_9996_9886_6B7B_4EA1_627F_63A5["树魔首领死亡承接剧情片段"]
end
local GetDyingUnit = jass.GetDyingUnit
local pendingTreantDeathUnit = nil
____exports["执行树魔首领死亡前置"] = function(_____53C2_6570)
    local dyingUnit = GetDyingUnit()
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    _____5199_5165_5267_60C5_8FDB_5EA6(__TS__Number(_____53C2_6570["设置剧情进度"]) or __TS__Number(_____53C2_6570["目标进度"]) or 28)
    pendingTreantDeathUnit = dyingUnit
end
____exports["执行树魔首领死亡奖励"] = function()
    if pendingTreantDeathUnit ~= nil and pendingTreantDeathUnit ~= 0 then
        local _____7ED3_7B97_914D_7F6E = _____6309_7ED3_7B97_952E_83B7_53D6Boss_6B7B_4EA1_7ED3_7B97_914D_7F6E("主线_树魔首领")
        if _____7ED3_7B97_914D_7F6E ~= nil then
            _____6267_884CBoss_6B7B_4EA1_7ED3_7B97(_____7ED3_7B97_914D_7F6E, pendingTreantDeathUnit)
        end
    end
    pendingTreantDeathUnit = nil
end
local function _____6267_884C_6811_9B54_9996_9886_6B7B_4EA1_540E_67E5_770B_6389_843D()
end
____exports["树魔首领死亡承接剧情动作注册表"] = {["SW01死亡事件_树魔首领死亡前置"] = ____exports["执行树魔首领死亡前置"], ["SW01死亡事件_树魔首领死亡奖励"] = ____exports["执行树魔首领死亡奖励"], ["JLC精灵城_树魔首领死亡后查看掉落"] = _____6267_884C_6811_9B54_9996_9886_6B7B_4EA1_540E_67E5_770B_6389_843D}
return ____exports
