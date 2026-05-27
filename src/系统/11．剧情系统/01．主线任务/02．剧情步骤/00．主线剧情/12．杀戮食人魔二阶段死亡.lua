--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataClearSafe = ____require_result_0.YDUserDataClearSafe
local ____require_result_1 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataClearTable = ____require_result_1.YDUserDataClearTable
local ____require_result_2 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_2["按名字反查物品ID"]
local ____require_result_3 = require("系统.01．单位系统.08．单位配置表.04．总单位配置表")
local _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID = ____require_result_3["按名字反查总单位ID"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_4.stringToFourCCSafe
local ____require_result_5 = require("lib.扩展函数.BJ函数.03．物品与库存")
local AddItemToStockBJ = ____require_result_5.AddItemToStockBJ
do
    local ____12_FF0E_6740_622E_98DF_4EBA_9B54_4E8C_9636_6BB5_6B7B_4EA1 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.12．杀戮食人魔二阶段死亡")
    ____exports["杀戮食人魔死亡剧情片段"] = ____12_FF0E_6740_622E_98DF_4EBA_9B54_4E8C_9636_6BB5_6B7B_4EA1["杀戮食人魔死亡剧情片段"]
end
local CreateItem = jass.CreateItem
local CreateUnit = jass.CreateUnit
local GetDyingUnit = jass.GetDyingUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local Player = jass.Player
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54_5C38_4F53 = nil
local _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54X = 0
local _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54Y = 0
local function _____521B_5EFA_98DF_4EBA_9B54_5934_9885(x, y)
    local itemTypeId = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID("食人魔头颅")) or stringToFourCCSafe("I0D4")
    if itemTypeId > 0 then
        CreateItem(itemTypeId, x, y)
    end
end
local function _____521B_5EFA_9009_62E9_5B9D_7BB1(x, y)
    local chestTypeId = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID("宝箱")) or stringToFourCCSafe("e070")
    if not (chestTypeId > 0) then
        return
    end
    local chest = CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        chestTypeId,
        x,
        y,
        0
    )
    if chest == nil or chest == 0 then
        return
    end
    AddItemToStockBJ(
        stringToFourCCSafe("I0D1"),
        chest,
        1,
        1
    )
    AddItemToStockBJ(
        stringToFourCCSafe("I089"),
        chest,
        1,
        1
    )
    AddItemToStockBJ(
        stringToFourCCSafe("I0D3"),
        chest,
        1,
        1
    )
end
____exports["执行杀戮食人魔死亡前置"] = function()
    local dyingUnit = GetDyingUnit()
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54_5C38_4F53 = dyingUnit
    _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54X = GetUnitX(dyingUnit)
    _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54Y = GetUnitY(dyingUnit)
end
____exports["执行杀戮食人魔死亡奖励"] = function()
    local dyingUnit = _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54_5C38_4F53
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    local x = _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54X
    local y = _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54Y
    YDUserDataClearSafe("string", "Boss", "杀戮食人魔", "unit")
    YDUserDataClearTable("unit", dyingUnit)
    _____521B_5EFA_98DF_4EBA_9B54_5934_9885(x, y)
    _____521B_5EFA_9009_62E9_5B9D_7BB1(x, y)
    _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54_5C38_4F53 = nil
    _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54X = 0
    _____5F85_5904_7406_6740_622E_98DF_4EBA_9B54Y = 0
end
____exports["杀戮食人魔二阶段死亡剧情动作注册表"] = {["SW01死亡事件_杀戮食人魔死亡前置"] = ____exports["执行杀戮食人魔死亡前置"], ["SW01死亡事件_杀戮食人魔死亡奖励"] = ____exports["执行杀戮食人魔死亡奖励"]}
return ____exports
