--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetRandomInt = jass.GetRandomInt
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.12．测试系统.00．Boss测试系统.02．Boss测试单位")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_1["Boss测试单位存活"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_1["获取Boss测试玩家基准英雄"]
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____require_result_2["播放Boss坐标音效"]
local _____6D4B_8BD5_547D_4EE4 = "soundtest"
local _____6D4B_8BD5_88C1_65AD_8DDD_79BB = 2800
local _____6D4B_8BD5_97F3_6548_5217_8868 = {{["名称"] = "火02", ["路径"] = "Sound\\Boss\\Phoenixel\\SFX\\phoenixel_element_burst_fire_02.mp3"}, {["名称"] = "毒02", ["路径"] = "Sound\\Boss\\Phoenixel\\SFX\\phoenixel_element_burst_poison_02.mp3"}}
local function ____onBoss_97F3_65483D_64AD_653E_6D4B_8BD5(player, _command)
    local hero = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(hero) then
        DisplayTimedTextToPlayer(
            player,
            0,
            0,
            8,
            "[Boss音效3D测试] 找不到大法师或已登记玩家英雄。"
        )
        return
    end
    local item = _____6D4B_8BD5_97F3_6548_5217_8868[GetRandomInt(0, #_____6D4B_8BD5_97F3_6548_5217_8868 - 1) + 1]
    _____64AD_653EBoss_5750_6807_97F3_6548(
        item["路径"],
        GetUnitX(hero),
        GetUnitY(hero),
        _____6D4B_8BD5_88C1_65AD_8DDD_79BB
    )
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        8,
        (("[Boss音效3D测试] 本次随机播放：" .. item["名称"]) .. " | ") .. item["路径"]
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____onBoss_97F3_65483D_64AD_653E_6D4B_8BD5)
return ____exports
