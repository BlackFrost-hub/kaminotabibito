--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 花生成命令（-种花）
-- 
-- 用途：在测试玩家英雄身边直接生成一株花（荧光草/星露花/晨曦花/月影花随机一种），
-- 用于验证采集流程与花模型；生成逻辑与 20．世界地图单位缓步创建 的初始化一致
-- （创建物品并注册排泄监听 + 登记采集物品实例）。
-- 
-- 只读排查请用 -花诊断；找场上已有的花请用 -跟踪花。
local jass = require("jass.common")
local ____require_result_0 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6 = ____require_result_0["是允许测试玩家"]
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_2.getRegisteredPlayerHero
local ____require_result_3 = require("lib.扩展函数.物品相关函数.创建物品函数")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_3["创建物品并注册排泄监听"]
local ____require_result_4 = require("系统.02．物品系统.17．装备采集.02．核心")
local _____767B_8BB0_91C7_96C6_7269_54C1_5B9E_4F8B = ____require_result_4["登记采集物品实例"]
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_5.debugLogForce
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRandomReal = jass.GetRandomReal
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local _____6A21_5757_540D = "花生成命令"
local _____751F_6210_547D_4EE4 = "-种花"
--- 生成点相对英雄的距离范围（码）
local _____6700_5C0F_8DDD_79BB = 120
local _____6700_5927_8DDD_79BB = 220
--- 可生成的花（与 06．植物配置表 / 地图物编一致）
local _____53EF_751F_6210_82B1_8868 = {{["名称"] = "荧光草", ["物品ID"] = 1936226148}, {["名称"] = "星露花", ["物品ID"] = 1227900980}, {["名称"] = "晨曦花", ["物品ID"] = 1227900981}, {["名称"] = "月影花", ["物品ID"] = 1227900982}}
local function ____on_79CD_82B1_547D_4EE4(player, _command)
    if not _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    local hero = getRegisteredPlayerHero(player)
    if hero == nil or hero == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到当前玩家已注册英雄")
        return
    end
    local _____82F1_96C4X = GetUnitX(hero)
    local _____82F1_96C4Y = GetUnitY(hero)
    local _____8DDD_79BB = GetRandomReal(_____6700_5C0F_8DDD_79BB, _____6700_5927_8DDD_79BB)
    local _____89D2_5EA6 = GetRandomReal(0, 2 * math.pi)
    local _____843D_70B9X = _____82F1_96C4X + math.cos(_____89D2_5EA6) * _____8DDD_79BB
    local _____843D_70B9Y = _____82F1_96C4Y + math.sin(_____89D2_5EA6) * _____8DDD_79BB
    local _____76EE_6807 = _____53EF_751F_6210_82B1_8868[math.floor(GetRandomReal(0, #_____53EF_751F_6210_82B1_8868)) + 1]
    local _____7269_54C1 = _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(_____76EE_6807["物品ID"], _____843D_70B9X, _____843D_70B9Y)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        DisplayTimedTextToPlayer(
            player,
            0,
            0,
            8,
            ("[种花] 创建失败：" .. _____76EE_6807["名称"]) .. "（物品ID 可能不在物编内）"
        )
        debugLogForce(
            _____6A21_5757_540D,
            "创建失败：目标 =",
            _____76EE_6807["名称"],
            "坐标 =",
            _____843D_70B9X,
            _____843D_70B9Y
        )
        return
    end
    _____767B_8BB0_91C7_96C6_7269_54C1_5B9E_4F8B(_____7269_54C1, _____76EE_6807["物品ID"], "测试.种花")
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        8,
        ((("[种花] 已在身边生成 " .. _____76EE_6807["名称"]) .. "（") .. tostring(math.floor(_____8DDD_79BB + 0.5))) .. " 码外）"
    )
    debugLogForce(
        _____6A21_5757_540D,
        "生成完成：",
        _____76EE_6807["名称"],
        "坐标 =",
        math.floor(_____843D_70B9X + 0.5),
        math.floor(_____843D_70B9Y + 0.5)
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____751F_6210_547D_4EE4, ____on_79CD_82B1_547D_4EE4)
debugLogForce(_____6A21_5757_540D, "已注册命令：输入", _____751F_6210_547D_4EE4, "在英雄身边生成一株花")
return ____exports
