local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入剧情进度"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataClearSafe = ____require_result_0.YDUserDataClearSafe
local ____require_result_1 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataClearTable = ____require_result_1.YDUserDataClearTable
local ____require_result_2 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_2["按名字反查物品ID"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local ____require_result_4 = require("lib.扩展函数.BJ函数.03．物品与库存")
local AddItemToStockBJ = ____require_result_4.AddItemToStockBJ
do
    local ____27_FF0E_6811_9B54_9996_9886_6B7B_4EA1_627F_63A5 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.27．树魔首领死亡承接")
    ____exports["树魔首领死亡承接剧情片段"] = ____27_FF0E_6811_9B54_9996_9886_6B7B_4EA1_627F_63A5["树魔首领死亡承接剧情片段"]
end
local CreateItem = jass.CreateItem
local CreateUnit = jass.CreateUnit
local GetDyingUnit = jass.GetDyingUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local Player = jass.Player
local pendingTreantDeathUnit = nil
local pendingTreantDeathX
local pendingTreantDeathY
____exports["执行树魔首领死亡前置"] = function(_____53C2_6570)
    local dyingUnit = GetDyingUnit()
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    _____5199_5165_5267_60C5_8FDB_5EA6(__TS__Number(_____53C2_6570["设置剧情进度"]) or __TS__Number(_____53C2_6570["目标进度"]) or 28)
    pendingTreantDeathUnit = dyingUnit
    pendingTreantDeathX = GetUnitX(dyingUnit)
    pendingTreantDeathY = GetUnitY(dyingUnit)
end
____exports["执行树魔首领死亡奖励"] = function()
    local x = pendingTreantDeathX
    local y = pendingTreantDeathY
    if x == nil or y == nil then
        return
    end
    local _____5B9D_7BB1_7C7B_578BID = stringToFourCCSafe("e070")
    if _____5B9D_7BB1_7C7B_578BID > 0 then
        local _____5B9D_7BB1 = CreateUnit(
            Player(jass.PLAYER_NEUTRAL_PASSIVE),
            _____5B9D_7BB1_7C7B_578BID,
            x,
            y,
            0
        )
        if _____5B9D_7BB1 ~= nil and _____5B9D_7BB1 ~= 0 then
            local _____7269_54C1A = stringToFourCCSafe("I0C3")
            local _____7269_54C1B = stringToFourCCSafe("I0C5")
            local _____7269_54C1C = stringToFourCCSafe("I0C7")
            if _____7269_54C1A > 0 then
                AddItemToStockBJ(_____7269_54C1A, _____5B9D_7BB1, 1, 1)
            end
            if _____7269_54C1B > 0 then
                AddItemToStockBJ(_____7269_54C1B, _____5B9D_7BB1, 1, 1)
            end
            if _____7269_54C1C > 0 then
                AddItemToStockBJ(_____7269_54C1C, _____5B9D_7BB1, 1, 1)
            end
        end
    end
    local _____9B54_6CD5_4FE1_4EF6_7C7B_578BID = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID("魔法信件"))
    if _____9B54_6CD5_4FE1_4EF6_7C7B_578BID > 0 then
        CreateItem(_____9B54_6CD5_4FE1_4EF6_7C7B_578BID, x, y)
    end
    YDUserDataClearSafe("string", "Boss", "树魔首领", "unit")
    if pendingTreantDeathUnit ~= nil and pendingTreantDeathUnit ~= 0 then
        YDUserDataClearTable("unit", pendingTreantDeathUnit)
    end
    pendingTreantDeathUnit = nil
    pendingTreantDeathX = nil
    pendingTreantDeathY = nil
end
local function _____6267_884C_6811_9B54_9996_9886_6B7B_4EA1_540E_8FD4_57CE()
end
____exports["树魔首领死亡承接剧情动作注册表"] = {["SW01死亡事件_树魔首领死亡前置"] = ____exports["执行树魔首领死亡前置"], ["SW01死亡事件_树魔首领死亡奖励"] = ____exports["执行树魔首领死亡奖励"], ["JLC精灵城_树魔首领死亡后返城"] = _____6267_884C_6811_9B54_9996_9886_6B7B_4EA1_540E_8FD4_57CE}
return ____exports
