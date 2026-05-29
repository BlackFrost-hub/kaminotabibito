--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.05．Boss死亡结算.03．核心逻辑")
local _____6309_7ED3_7B97_952E_83B7_53D6Boss_6B7B_4EA1_7ED3_7B97_914D_7F6E = ____require_result_0["按结算键获取Boss死亡结算配置"]
local _____6267_884CBoss_6B7B_4EA1_7ED3_7B97 = ____require_result_0["执行Boss死亡结算"]
do
    local ____12_FF0E_6740_622E_98DF_4EBA_9B54_4E8C_9636_6BB5_6B7B_4EA1 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.12．杀戮食人魔二阶段死亡")
    ____exports["杀戮食人魔死亡剧情片段"] = ____12_FF0E_6740_622E_98DF_4EBA_9B54_4E8C_9636_6BB5_6B7B_4EA1["杀戮食人魔死亡剧情片段"]
end
local GetDyingUnit = jass.GetDyingUnit
local _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54_5C38_4F53 = nil
____exports["执行杀戮食人魔死亡前置"] = function()
    local dyingUnit = GetDyingUnit()
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54_5C38_4F53 = dyingUnit
end
____exports["执行杀戮食人魔死亡奖励"] = function()
    local dyingUnit = _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54_5C38_4F53
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    local _____7ED3_7B97_914D_7F6E = _____6309_7ED3_7B97_952E_83B7_53D6Boss_6B7B_4EA1_7ED3_7B97_914D_7F6E("主线_杀戮食人魔")
    if _____7ED3_7B97_914D_7F6E ~= nil then
        _____6267_884CBoss_6B7B_4EA1_7ED3_7B97(_____7ED3_7B97_914D_7F6E, dyingUnit)
    end
    _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54_5C38_4F53 = nil
end
____exports["杀戮食人魔二阶段死亡剧情动作注册表"] = {["SW01死亡事件_杀戮食人魔死亡前置"] = ____exports["执行杀戮食人魔死亡前置"], ["SW01死亡事件_杀戮食人魔死亡奖励"] = ____exports["执行杀戮食人魔死亡奖励"]}
return ____exports
