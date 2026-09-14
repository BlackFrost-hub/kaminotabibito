local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
____exports["异界Boss挑战配置表"] = {{
    ["挑战物品ID"] = "I0BA",
    ["最高可挑战等级"] = 25,
    ["Boss单位ID列表"] = {"E07E", "E079", "O005", "E07X"},
    ["基础生命值"] = 8000,
    ["基础生命恢复"] = 50,
    ["攻击力"] = 250
}, {
    ["挑战物品ID"] = "I0BB",
    ["最高可挑战等级"] = 35,
    ["Boss单位ID列表"] = {"E07E", "E079", "O005", "E07X"},
    ["基础生命值"] = 13000,
    ["基础生命恢复"] = 100,
    ["攻击力"] = 450
}, {
    ["挑战物品ID"] = "I0B8",
    ["最高可挑战等级"] = 45,
    ["Boss单位ID列表"] = {"E07E", "E079", "O005", "E07X"},
    ["基础生命值"] = 24000,
    ["基础生命恢复"] = 200,
    ["攻击力"] = 750
}, {
    ["挑战物品ID"] = "I0B9",
    ["最高可挑战等级"] = 55,
    ["Boss单位ID列表"] = {"E07E", "E079", "O005", "E07X"},
    ["基础生命值"] = 32000,
    ["基础生命恢复"] = 250,
    ["攻击力"] = 950
}}
____exports["异界Boss挑战池"] = {"赫萝", "克洛克达尔", "萨菲罗斯", "天子"}
local _____5F53_524D_5F02_754CBoss_6311_6218_6C60 = {"赫萝", "克洛克达尔", "萨菲罗斯", "天子"}
____exports["异界Boss挑战运行缓存表"] = {}
local ____require_result_0 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
local _____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_0["解析配置内部ID"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_1.debugLogForce
local _____5F02_754CBoss_6311_6218_65E5_5FD7_6A21_5757 = "异界Boss挑战"
local _____5DF2_521D_59CB_5316_5F02_754CBoss_6311_6218_7269_54C1_76D1_542C = false
____exports["记录异界Boss挑战运行"] = function(_____8BB0_5F55)
    local ____exports__5F02_754CBoss_6311_6218_8FD0_884C_7F13_5B58_8868_2 = ____exports["异界Boss挑战运行缓存表"]
    ____exports__5F02_754CBoss_6311_6218_8FD0_884C_7F13_5B58_8868_2[#____exports__5F02_754CBoss_6311_6218_8FD0_884C_7F13_5B58_8868_2 + 1] = _____8BB0_5F55
end
____exports["获取当前异界Boss挑战运行"] = function()
    return ____exports["异界Boss挑战运行缓存表"][#____exports["异界Boss挑战运行缓存表"]]
end
____exports["移除异界Boss挑战运行"] = function(boss)
    do
        local i = #____exports["异界Boss挑战运行缓存表"] - 1
        while i >= 0 do
            if ____exports["异界Boss挑战运行缓存表"][i + 1]["Boss单位"] == boss then
                __TS__ArraySplice(____exports["异界Boss挑战运行缓存表"], i, 1)
            end
            i = i - 1
        end
    end
end
____exports["获取异界Boss挑战配置"] = function(itemTypeId)
    do
        local i = 0
        while i < #____exports["异界Boss挑战配置表"] do
            local _____914D_7F6E = ____exports["异界Boss挑战配置表"][i + 1]
            if _____89E3_6790_914D_7F6E_5185_90E8ID(_____914D_7F6E["挑战物品ID"]) == itemTypeId then
                return _____914D_7F6E
            end
            i = i + 1
        end
    end
    return nil
end
____exports["随机选择异界Boss单位ID"] = function(_____914D_7F6E)
    local jass = require("jass.common")
    if #_____5F53_524D_5F02_754CBoss_6311_6218_6C60 == 0 then
        do
            local i = 0
            while i < #____exports["异界Boss挑战池"] do
                _____5F53_524D_5F02_754CBoss_6311_6218_6C60[#_____5F53_524D_5F02_754CBoss_6311_6218_6C60 + 1] = ____exports["异界Boss挑战池"][i + 1]
                i = i + 1
            end
        end
    end
    local index = jass.GetRandomInt(1, #_____5F53_524D_5F02_754CBoss_6311_6218_6C60) - 1
    local _____540D_79F0 = _____5F53_524D_5F02_754CBoss_6311_6218_6C60[index + 1] or _____5F53_524D_5F02_754CBoss_6311_6218_6C60[1]
    __TS__ArraySplice(_____5F53_524D_5F02_754CBoss_6311_6218_6C60, index, 1)
    do
        local i = 0
        while i < #_____914D_7F6E["Boss单位ID列表"] do
            local candidate = _____914D_7F6E["Boss单位ID列表"][i + 1]
            if candidate == "E07E" and _____540D_79F0 == "赫萝" or candidate == "E079" and _____540D_79F0 == "克洛克达尔" or candidate == "O005" and _____540D_79F0 == "萨菲罗斯" or candidate == "E07X" and _____540D_79F0 == "天子" then
                return candidate
            end
            i = i + 1
        end
    end
    return _____914D_7F6E["Boss单位ID列表"][1]
end
____exports["初始化异界Boss挑战物品监听"] = function()
    if _____5DF2_521D_59CB_5316_5F02_754CBoss_6311_6218_7269_54C1_76D1_542C then
        debugLogForce(_____5F02_754CBoss_6311_6218_65E5_5FD7_6A21_5757, "监听已初始化，跳过重复注册")
        return
    end
    _____5DF2_521D_59CB_5316_5F02_754CBoss_6311_6218_7269_54C1_76D1_542C = true
    local events = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
    local jass = require("jass.common")
    local RemoveItem = jass.RemoveItem
    local GetItemTypeId = jass.GetItemTypeId
    local GetHeroLevel = jass.GetHeroLevel
    local GetUnitX = jass.GetUnitX
    local GetUnitY = jass.GetUnitY
    local SetUnitOwner = jass.SetUnitOwner
    local Player = jass.Player
    local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
    local ____require_result_3 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接")
    local _____542F_52A8_5267_60C5Boss_6218 = ____require_result_3["启动剧情Boss战"]
    local ____require_result_4 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
    local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_4["应用Boss战启动属性配置"]
    local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
    local addDelayedCallback = ____require_result_5.addDelayedCallback
    local getGameDifficulty = ____require_result_5.getGameDifficulty
    local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
    local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_6["创建单位并登记排泄安全"]
    local ____require_result_7 = require("平台扩展API动作")
    local _____5355_4F4D__8BBE_7F6E_6BCF_79D2_751F_547D_6062_590D = ____require_result_7["单位_设置每秒生命恢复"]
    local SetUnitState = jass.SetUnitState
    local SetUnitLifePercentBJ = jass.SetUnitLifePercentBJ
    local ConvertUnitState = jass.ConvertUnitState
    local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
    local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
    local CreateGroup = jass.CreateGroup
    local DestroyGroup = jass.DestroyGroup
    local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
    local FirstOfGroup = jass.FirstOfGroup
    local GroupRemoveUnit = jass.GroupRemoveUnit
    local GetUnitTypeId = jass.GetUnitTypeId
    local AddItemToStockBJ = require("lib.扩展函数.BJ函数.03．物品与库存").AddItemToStockBJ
    local _____5546_5E97_5355_4F4D_7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID("hvlt")
    local function _____8865_56DE_6311_6218_7269_54C1_5E93_5B58(unit, itemTypeId)
        local group = CreateGroup()
        if group == nil or group == 0 then
            return
        end
        GroupEnumUnitsInRange(
            group,
            GetUnitX(unit),
            GetUnitY(unit),
            1200,
            nil
        )
        local nearby
        while true do
            nearby = FirstOfGroup(group)
            if nearby == nil or nearby == 0 then
                break
            end
            GroupRemoveUnit(group, nearby)
            if GetUnitTypeId(nearby) == _____5546_5E97_5355_4F4D_7C7B_578BID then
                AddItemToStockBJ(itemTypeId, nearby, 1, 1)
                break
            end
        end
        DestroyGroup(group)
    end
    local function onPickup(unit, item)
        local itemTypeId = (item == nil or item == 0) and 0 or GetItemTypeId(item)
        local heroLevel = (unit == nil or unit == 0) and 0 or GetHeroLevel(unit)
        local _____914D_7F6E = ____exports["获取异界Boss挑战配置"](itemTypeId)
        if _____914D_7F6E == nil then
            return
        end
        if unit == nil or unit == 0 then
            debugLogForce(_____5F02_754CBoss_6311_6218_65E5_5FD7_6A21_5757, "拾取单位为空", "itemTypeId", itemTypeId)
            return
        end
        if heroLevel > _____914D_7F6E["最高可挑战等级"] then
            debugLogForce(
                _____5F02_754CBoss_6311_6218_65E5_5FD7_6A21_5757,
                "等级超过上限，退回库存",
                "heroLevel",
                heroLevel,
                "maxLevel",
                _____914D_7F6E["最高可挑战等级"]
            )
            RemoveItem(item)
            _____8865_56DE_6311_6218_7269_54C1_5E93_5B58(unit, itemTypeId)
            return
        end
        debugLogForce(
            _____5F02_754CBoss_6311_6218_65E5_5FD7_6A21_5757,
            "挑战通过，消耗物品",
            "heroLevel",
            heroLevel,
            "maxLevel",
            _____914D_7F6E["最高可挑战等级"]
        )
        RemoveItem(item)
        local shopGroup = CreateGroup()
        if shopGroup ~= nil and shopGroup ~= 0 then
            GroupEnumUnitsInRange(
                shopGroup,
                GetUnitX(unit),
                GetUnitY(unit),
                1000,
                nil
            )
            local shop
            while true do
                shop = FirstOfGroup(shopGroup)
                if shop == nil or shop == 0 then
                    break
                end
                GroupRemoveUnit(shopGroup, shop)
                if GetUnitTypeId(shop) == _____5546_5E97_5355_4F4D_7C7B_578BID then
                    SetUnitOwner(
                        shop,
                        Player(6),
                        true
                    )
                end
            end
            DestroyGroup(shopGroup)
        end
        local ____require_result_8 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
        local STES_Fire = ____require_result_8.STES_Fire
        STES_Fire("异界Boss背景框")
        local _____96BE_5EA6_503C = getGameDifficulty() > 0 and getGameDifficulty() or 1
        local _____751F_547D_500D_7387_8868 = {
            [1] = 1,
            [2] = 1.2,
            [3] = 1.5,
            [4] = 2,
            [5] = 2.6,
            [6] = 3.2
        }
        local _____6700_5927_751F_547D_503C = _____914D_7F6E["基础生命值"] * (_____751F_547D_500D_7387_8868[_____96BE_5EA6_503C] or 1 + (_____96BE_5EA6_503C - 1) * 0.6)
        addDelayedCallback(
            6600,
            function(value)
                debugLogForce(_____5F02_754CBoss_6311_6218_65E5_5FD7_6A21_5757, "延迟回调开始", "hasUnit", value ~= nil and value.unit ~= nil and value.unit ~= 0)
                if value == nil or value.unit == nil or value.unit == 0 then
                    return
                end
                local bossUnitId = ____exports["随机选择异界Boss单位ID"](_____914D_7F6E)
                local bossTypeId = _____89E3_6790_914D_7F6E_5185_90E8ID(bossUnitId)
                debugLogForce(
                    _____5F02_754CBoss_6311_6218_65E5_5FD7_6A21_5757,
                    "准备创建Boss",
                    "bossUnitId",
                    bossUnitId,
                    "bossTypeId",
                    bossTypeId,
                    "difficulty",
                    _____96BE_5EA6_503C
                )
                local boss = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
                    Player(PLAYER_NEUTRAL_AGGRESSIVE),
                    bossTypeId,
                    26468,
                    20612.5,
                    270
                )
                if boss == nil or boss == 0 then
                    debugLogForce(
                        _____5F02_754CBoss_6311_6218_65E5_5FD7_6A21_5757,
                        "Boss创建失败",
                        "bossUnitId",
                        bossUnitId,
                        "bossTypeId",
                        bossTypeId
                    )
                    return
                end
                SetUnitState(boss, UNIT_STATE_MAX_LIFE, _____6700_5927_751F_547D_503C)
                SetUnitState(boss, UNIT_STATE_LIFE, _____6700_5927_751F_547D_503C)
                SetUnitState(
                    boss,
                    ConvertUnitState(18),
                    _____914D_7F6E["攻击力"]
                )
                _____5355_4F4D__8BBE_7F6E_6BCF_79D2_751F_547D_6062_590D(boss, _____914D_7F6E["基础生命恢复"])
                ____exports["记录异界Boss挑战运行"]({
                    ["Boss单位"] = boss,
                    ["触发单位"] = value.unit,
                    ["配置"] = _____914D_7F6E,
                    ["难度值"] = _____96BE_5EA6_503C,
                    ["最大生命值"] = _____6700_5927_751F_547D_503C
                })
                _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(boss)
                SetUnitLifePercentBJ(boss, 100)
                local started = _____542F_52A8_5267_60C5Boss_6218(boss, {["触发单位"] = value.unit})
                debugLogForce(
                    _____5F02_754CBoss_6311_6218_65E5_5FD7_6A21_5757,
                    "Boss创建并启动完成",
                    "started",
                    started,
                    "bossUnitId",
                    bossUnitId
                )
            end,
            {unit = unit}
        )
    end
    local listenerId = events.onItemPickup(onPickup)
    debugLogForce(_____5F02_754CBoss_6311_6218_65E5_5FD7_6A21_5757, "拾取监听注册完成", "listenerId", listenerId)
end
return ____exports
