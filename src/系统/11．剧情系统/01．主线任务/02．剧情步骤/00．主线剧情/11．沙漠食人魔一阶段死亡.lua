--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_0.YDUserDataSetSafe
local YDWEAngleBetweenUnitsSafe = ____require_result_0.YDWEAngleBetweenUnitsSafe
local ____require_result_1 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_1["按名字反查Boss单位ID"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.03．Boss战运行驱动")
local _____542F_52A8Boss_6218_8FD0_884C = ____require_result_3["启动Boss战运行"]
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
local PauseUnit = jass.PauseUnit
local Player = jass.Player
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local UnitSuspendDecay = jass.UnitSuspendDecay
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
____exports["执行沙漠食人魔一阶段死亡"] = function(_____53C2_6570)
    local dyingUnit = GetDyingUnit()
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    UnitSuspendDecay(dyingUnit, true)
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
    local ____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID_5 = _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID
    local ____53C2_6570__4E8C_9636_6BB5Boss_540D_4 = _____53C2_6570["二阶段Boss名"]
    if ____53C2_6570__4E8C_9636_6BB5Boss_540D_4 == nil then
        ____53C2_6570__4E8C_9636_6BB5Boss_540D_4 = "杀戮食人魔"
    end
    local bossRawId = ____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID_5(tostring(____53C2_6570__4E8C_9636_6BB5Boss_540D_4))
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
    YDUserDataSetSafe(
        "string",
        "Boss战",
        "绑定单位",
        "unit",
        bossUnit
    )
    PauseUnit(bossUnit, true)
    SetUnitInvulnerable(bossUnit, true)
    _____542F_52A8Boss_6218_8FD0_884C(bossUnit)
end
____exports["沙漠食人魔一阶段死亡剧情动作注册表"] = {["SW01死亡事件_沙漠食人魔一阶段死亡"] = ____exports["执行沙漠食人魔一阶段死亡"]}
return ____exports
