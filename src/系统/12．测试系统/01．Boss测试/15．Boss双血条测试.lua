--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local globals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local ____require_result_2 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文")
local _____521B_5EFABoss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_2["创建Boss战运行上下文"]
local ____require_result_3 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.05．Boss弱点运行状态")
local _____521B_5EFABoss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001 = ____require_result_3["创建Boss血条弱点韧性运行状态"]
local _____8BFB_53D6Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001 = ____require_result_3["读取Boss血条弱点韧性运行状态"]
local _____6E05_7406Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001 = ____require_result_3["清理Boss血条弱点韧性运行状态"]
local ____require_result_4 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.03．Boss血条UI")
local _____6CE8_518CBoss_8840_6761UI = ____require_result_4["注册Boss血条UI"]
local _____6CE8_9500Boss_8840_6761UI = ____require_result_4["注销Boss血条UI"]
local _____91CD_65B0_6392_5217Boss_8840_6761_69FD_4F4D = ____require_result_4["重新排列Boss血条槽位"]
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local Player = jass.Player
local IsUnitType = jass.IsUnitType
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local GroupEnumUnitsOfPlayer = jass.GroupEnumUnitsOfPlayer
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local function stringToFourCC(value)
    return (string.byte(value, 1) or 0 / 0) * 16777216 + (string.byte(value, 2) or 0 / 0) * 65536 + (string.byte(value, 3) or 0 / 0) * 256 + (string.byte(value, 4) or 0 / 0)
end
local _____6D4B_8BD5_547D_4EE4 = "hp"
local _____6E05_7406_547D_4EE4 = "hpclear"
local _____6B7B_4EA1_9A91_58EB_5355_4F4DID = stringToFourCC("Udre")
local _____6B7B_4EA1_9A91_58EB_539F_59CBX = -2048.1
local _____6B7B_4EA1_9A91_58EB_539F_59CBY = -1335.6
local _____6D4B_8BD5_8840_6761_53E5_67C4_8868 = {}
local _____7F13_5B58_6B7B_4EA1_9A91_58EB_5355_4F4D = nil
local _____5DF2_521D_59CB_5316 = false
local function _____5355_4F4D_53EF_7528_4E8E_8840_6761_6D4B_8BD5(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____8BFB_53D6_9884_8BBE_6B7B_4EA1_9A91_58EB()
    local presetUnit = globals.gg_unit_Udre_0014
    if _____5355_4F4D_53EF_7528_4E8E_8840_6761_6D4B_8BD5(presetUnit) then
        return presetUnit
    end
    if _____5355_4F4D_53EF_7528_4E8E_8840_6761_6D4B_8BD5(_____7F13_5B58_6B7B_4EA1_9A91_58EB_5355_4F4D) then
        return _____7F13_5B58_6B7B_4EA1_9A91_58EB_5355_4F4D
    end
    local group = CreateGroup()
    GroupEnumUnitsOfPlayer(
        group,
        Player(0),
        nil
    )
    local nearestUnit = nil
    local nearestDistanceSquared = 0
    local unit = FirstOfGroup(group)
    while unit ~= nil and unit ~= 0 do
        GroupRemoveUnit(group, unit)
        if _____5355_4F4D_53EF_7528_4E8E_8840_6761_6D4B_8BD5(unit) and GetUnitTypeId(unit) == _____6B7B_4EA1_9A91_58EB_5355_4F4DID then
            local dx = GetUnitX(unit) - _____6B7B_4EA1_9A91_58EB_539F_59CBX
            local dy = GetUnitY(unit) - _____6B7B_4EA1_9A91_58EB_539F_59CBY
            local distanceSquared = dx * dx + dy * dy
            if nearestUnit == nil or distanceSquared < nearestDistanceSquared then
                nearestUnit = unit
                nearestDistanceSquared = distanceSquared
            end
        end
        unit = FirstOfGroup(group)
    end
    DestroyGroup(group)
    _____7F13_5B58_6B7B_4EA1_9A91_58EB_5355_4F4D = nearestUnit
    return nearestUnit
end
local function _____521B_5EFA_6216_590D_7528_6D4B_8BD5_8840_6761(unit)
    if not _____5355_4F4D_53EF_7528_4E8E_8840_6761_6D4B_8BD5(unit) then
        return false
    end
    local handleId = GetHandleId(unit)
    if handleId == 0 then
        return false
    end
    local state = _____8BFB_53D6Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(handleId)
    if state == nil or state["是否已结束"] then
        local context = _____521B_5EFABoss_6218_8FD0_884C_4E0A_4E0B_6587(unit, nil, nil, nil)
        if context == nil then
            return false
        end
        state = _____521B_5EFABoss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(context, nil)
    end
    _____6D4B_8BD5_8840_6761_53E5_67C4_8868[handleId] = true
    _____6CE8_518CBoss_8840_6761UI(state)
    _____91CD_65B0_6392_5217Boss_8840_6761_69FD_4F4D()
    return true
end
local function _____6E05_7406_6D4B_8BD5_8840_6761(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local handleId = GetHandleId(unit)
    if handleId == 0 or _____6D4B_8BD5_8840_6761_53E5_67C4_8868[handleId] ~= true then
        return false
    end
    local state = _____8BFB_53D6Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(handleId)
    if state ~= nil then
        state["是否已结束"] = true
        _____6CE8_9500Boss_8840_6761UI(state)
        _____6E05_7406Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(handleId)
    end
    _____6D4B_8BD5_8840_6761_53E5_67C4_8868[handleId] = nil
    return true
end
local function ____on_53CC_8840_6761_6D4B_8BD5_547D_4EE4(player, _command)
    local archmage = globals.gg_unit_Hamg_0002
    local deathKnight = _____8BFB_53D6_9884_8BBE_6B7B_4EA1_9A91_58EB()
    local archmageReady = _____521B_5EFA_6216_590D_7528_6D4B_8BD5_8840_6761(archmage)
    local deathKnightReady = _____521B_5EFA_6216_590D_7528_6D4B_8BD5_8840_6761(deathKnight)
    if archmageReady and deathKnightReady then
        DisplayTimedTextToPlayer(
            player,
            0,
            0,
            8,
            "[双Boss血条测试] 已显示大法师与死亡骑士血条。杀死任意一只可测试自动上移；输入 hpclear 清理。 "
        )
        return
    end
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        8,
        ((("[双Boss血条测试] 预设单位读取失败：Hamg=" .. (archmageReady and "正常" or "无效")) .. "，Udre=") .. (deathKnightReady and "正常" or "无效")) .. "。"
    )
end
local function ____on_53CC_8840_6761_6E05_7406_547D_4EE4(player, _command)
    _____6E05_7406_6D4B_8BD5_8840_6761(globals.gg_unit_Hamg_0002)
    _____6E05_7406_6D4B_8BD5_8840_6761(_____8BFB_53D6_9884_8BBE_6B7B_4EA1_9A91_58EB())
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        5,
        "[双Boss血条测试] 已清理测试血条。"
    )
end
local function ____on_6D4B_8BD5_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    local handleId = GetHandleId(dyingUnit)
    if _____6D4B_8BD5_8840_6761_53E5_67C4_8868[handleId] ~= true then
        return
    end
    _____6E05_7406_6D4B_8BD5_8840_6761(dyingUnit)
end
local function _____521D_59CB_5316Boss_53CC_8840_6761_6D4B_8BD5()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_53CC_8840_6761_6D4B_8BD5_547D_4EE4)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6E05_7406_547D_4EE4, ____on_53CC_8840_6761_6E05_7406_547D_4EE4)
    registerDeathListener(____on_6D4B_8BD5_5355_4F4D_6B7B_4EA1)
end
_____521D_59CB_5316Boss_53CC_8840_6761_6D4B_8BD5()
return ____exports
