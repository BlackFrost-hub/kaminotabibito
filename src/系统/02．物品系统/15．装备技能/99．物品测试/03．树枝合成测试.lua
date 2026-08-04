--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_1.getRegisteredPlayerHero
local ____require_result_2 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_2["按名字反查物品ID"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local ____require_result_4 = require("lib.扩展函数.物品相关函数.index")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_4["创建物品并注册排泄监听"]
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_5.debugLogForce
local Player = jass.Player
local GetPlayerId = jass.GetPlayerId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local _____6A21_5757_540D = "树枝合成测试"
local _____6811_679D_6D4B_8BD5_547D_4EE4 = "tree4"
local _____6811_679D_7269_54C1_540D = "树枝"
local _____6811_679D_521B_5EFA_504F_79FB = {{-48, -32}, {48, -32}, {-48, 32}, {48, 32}}
local function _____662F_73A9_5BB61(player)
    return player ~= nil and player ~= 0 and GetPlayerId(player) == 0
end
local function _____521B_5EFA_56DB_4E2A_6811_679D(player, _command)
    if not _____662F_73A9_5BB61(player) then
        return
    end
    local hero = getRegisteredPlayerHero(Player(0))
    if hero == nil or hero == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到玩家1注册英雄")
        return
    end
    local rawId = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____6811_679D_7269_54C1_540D)
    local itemTypeId = stringToFourCCSafe(rawId)
    if itemTypeId == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到树枝物品ID", _____6811_679D_7269_54C1_540D, rawId)
        return
    end
    local heroX = GetUnitX(hero)
    local heroY = GetUnitY(hero)
    local createdCount = 0
    do
        local i = 0
        while i < #_____6811_679D_521B_5EFA_504F_79FB do
            local offset = _____6811_679D_521B_5EFA_504F_79FB[i + 1]
            local item = _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(itemTypeId, heroX + offset[1], heroY + offset[2])
            if item ~= nil and item ~= 0 then
                createdCount = createdCount + 1
            end
            i = i + 1
        end
    end
    debugLogForce(_____6A21_5757_540D, "已在玩家1注册英雄脚下创建树枝", "数量", createdCount)
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6811_679D_6D4B_8BD5_547D_4EE4, _____521B_5EFA_56DB_4E2A_6811_679D)
return ____exports
