--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接")
local _____542F_52A8_5267_60C5Boss_6218 = ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5["启动剧情Boss战"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_0["添加单位暂停"]
local _____6C99_6F20_98DF_4EBA_9B54_4E8C_9636_6BB5_5F85_6218_6682_505C_6765_6E90 = "剧情系统:沙漠食人魔二阶段待战"
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
local YDWEAngleBetweenUnitsSafe = ____require_result_1.YDWEAngleBetweenUnitsSafe
local ____require_result_2 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_2["按名字反查Boss单位ID"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local ____require_result_4 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑")
local _____6309_7ED3_7B97_952E_6267_884CBoss_6B7B_4EA1_7ED3_7B97 = ____require_result_4["按结算键执行Boss死亡结算"]
do
    local ____11_FF0E_6C99_6F20_98DF_4EBA_9B54_4E00_9636_6BB5_6B7B_4EA1 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.11．沙漠食人魔一阶段死亡")
    ____exports["沙漠食人魔一阶段死亡剧情片段"] = ____11_FF0E_6C99_6F20_98DF_4EBA_9B54_4E00_9636_6BB5_6B7B_4EA1["沙漠食人魔一阶段死亡剧情片段"]
end
local CreateUnit = jass.CreateUnit
local GetDyingUnit = jass.GetDyingUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IssueImmediateOrder = jass.IssueImmediateOrder
local IssuePointOrder = jass.IssuePointOrder
local Player = jass.Player
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local IssueTargetOrder = jass.IssueTargetOrder
local UnitSuspendDecay = jass.UnitSuspendDecay
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
local _____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54 = nil
local _____5F85_5F00_6218_76EE_6807_5355_4F4D = nil
local _____5F85_5904_7406_4E00_9636_6BB5_6B7B_4EA1_5355_4F4D = nil
____exports["执行沙漠食人魔一阶段死亡前置"] = function(_____53C2_6570)
    local dyingUnit = GetDyingUnit()
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    _____5F85_5904_7406_4E00_9636_6BB5_6B7B_4EA1_5355_4F4D = dyingUnit
    UnitSuspendDecay(dyingUnit, true)
    _____6309_7ED3_7B97_952E_6267_884CBoss_6B7B_4EA1_7ED3_7B97("沙漠食人魔", dyingUnit)
    local x = GetUnitX(dyingUnit)
    local y = GetUnitY(dyingUnit)
    local riftTypeId = stringToFourCCSafe("e08M")
    local riftUnit = nil
    if riftTypeId > 0 then
        riftUnit = CreateUnit(
            Player(PLAYER_NEUTRAL_PASSIVE),
            riftTypeId,
            27531.2,
            13562.4,
            0
        )
    end
    local lizardTypeId = stringToFourCCSafe("h01I")
    if lizardTypeId > 0 and riftUnit ~= nil and riftUnit ~= 0 then
        local angle = YDWEAngleBetweenUnitsSafe(riftUnit, dyingUnit)
        local lizardUnit = CreateUnit(
            Player(PLAYER_NEUTRAL_PASSIVE),
            lizardTypeId,
            27531.2,
            13562.4,
            angle
        )
        if lizardUnit ~= nil and lizardUnit ~= 0 then
            IssuePointOrder(
                lizardUnit,
                "move",
                GetUnitX(riftUnit) + 150,
                GetUnitY(riftUnit)
            )
            IssueImmediateOrder(lizardUnit, "holdposition")
        end
    end
    local ____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID_6 = _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID
    local ____53C2_6570__4E8C_9636_6BB5Boss_540D_5 = _____53C2_6570["二阶段Boss名"]
    if ____53C2_6570__4E8C_9636_6BB5Boss_540D_5 == nil then
        ____53C2_6570__4E8C_9636_6BB5Boss_540D_5 = "杀戮食人魔"
    end
    local bossRawId = ____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID_6(tostring(____53C2_6570__4E8C_9636_6BB5Boss_540D_5))
    local bossTypeId = stringToFourCCSafe(bossRawId)
    if not (bossTypeId > 0) then
        return
    end
    local bossUnit = CreateUnit(
        Player(PLAYER_NEUTRAL_AGGRESSIVE),
        bossTypeId,
        x,
        y,
        270
    )
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    YDUserDataSetSafe(
        "string",
        "Boss",
        "杀戮食人魔",
        "unit",
        bossUnit
    )
    _____6DFB_52A0_5355_4F4D_6682_505C(bossUnit, _____6C99_6F20_98DF_4EBA_9B54_4E8C_9636_6BB5_5F85_6218_6682_505C_6765_6E90)
    SetUnitInvulnerable(bossUnit, true)
    _____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54 = bossUnit
    _____5F85_5F00_6218_76EE_6807_5355_4F4D = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit")
end
____exports["执行沙漠食人魔二阶段开战"] = function()
    local ____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54_7 = _____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54
    if ____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54_7 == nil then
        ____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54_7 = YDUserDataGetSafe("string", "Boss", "杀戮食人魔", "unit")
    end
    local bossUnit = ____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54_7
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    if _____5F85_5F00_6218_76EE_6807_5355_4F4D ~= nil and _____5F85_5F00_6218_76EE_6807_5355_4F4D ~= 0 then
        IssueTargetOrder(bossUnit, "attack", _____5F85_5F00_6218_76EE_6807_5355_4F4D)
    end
    _____542F_52A8_5267_60C5Boss_6218(bossUnit, {["触发单位"] = _____5F85_5F00_6218_76EE_6807_5355_4F4D, ["暂停来源"] = _____6C99_6F20_98DF_4EBA_9B54_4E8C_9636_6BB5_5F85_6218_6682_505C_6765_6E90})
    _____5F85_5904_7406_4E00_9636_6BB5_6B7B_4EA1_5355_4F4D = nil
    _____5F85_5F00_6218_6740_622E_98DF_4EBA_9B54 = nil
    _____5F85_5F00_6218_76EE_6807_5355_4F4D = nil
end
____exports["沙漠食人魔一阶段死亡剧情动作注册表"] = {["SW01死亡事件_沙漠食人魔一阶段死亡前置"] = ____exports["执行沙漠食人魔一阶段死亡前置"], ["SW01死亡事件_沙漠食人魔二阶段开战"] = ____exports["执行沙漠食人魔二阶段开战"]}
return ____exports
