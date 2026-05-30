local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____83B7_53D6_53E5_67C4ID, _____5F53_524D_547D_4EE4_5141_8BB8_515C_5E95_4E0B_4EE4, _____5355_4F4D_5728Boss_6218_8303_56F4_5185_6709_6548, _____8BB0_5F55_6700_8FD1_679A_4E3E_76EE_6807, ____on_679A_4E3E_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D, _____8BFB_53D6_73A9_5BB6_82F1_96C4_7EC4, _____8BFB_53D6_5F53_524D_6709_6548_4EC7_6068_76EE_6807, _____4ECE_73A9_5BB6_82F1_96C4_7EC4_67E5_627E_6700_8FD1_654C_4EBA, _____4ECE_9644_8FD1_5355_4F4D_67E5_627E_6700_8FD1_654C_4EBA, RectContainsUnit, IsUnitPausedBJ, YDUserDataGetSafe, getEnemyThreats, isValidCombatEnemyUnit, debugLogForce, GetHandleId, GetUnitX, GetUnitY, IssueTargetOrder, GetUnitCurrentOrder, CreateGroup, DestroyGroup, GroupEnumUnitsInRange, FirstOfGroup, GroupRemoveUnit, ForGroup, GetEnumUnit, _____653B_51FB_547D_4EE4ID, _____653B_51FB_4E00_6B21_547D_4EE4ID, _____505C_6B62_547D_4EE4ID, _____4FDD_6301_547D_4EE4ID, _____6700_8FD1_654C_4EBA_679A_4E3EBoss, _____6700_8FD1_654C_4EBA_679A_4E3E_77E9_5F62, _____6700_8FD1_654C_4EBA_679A_4E3E_6700_5927_8DDD_79BB_5E73_65B9, _____6700_8FD1_654C_4EBA_679A_4E3E_7ED3_679C, _____6700_8FD1_654C_4EBA_679A_4E3E_6700_77ED_8DDD_79BB_5E73_65B9, _____6700_8FD1_654C_4EBA_679A_4E3E_6700_5C0F_53E5_67C4ID
local ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668.getServerTime
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.00．常量定义")
local ____Boss_6218_5355_4F4D_5B57_6BB5 = ____00_FF0E_5E38_91CF_5B9A_4E49["Boss战单位字段"]
local ____Boss_6218_8868_540D = ____00_FF0E_5E38_91CF_5B9A_4E49["Boss战表名"]
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.00．常量定义")
local ____Boss_6218_53EF_89C1_5EA6_73A9_5BB6_69FD_4F4D_6570 = ____00_FF0E_5E38_91CF_5B9A_4E49["Boss战可见度玩家槽位数"]
local ____Boss_6218_5730_70B9_5B57_6BB5 = ____00_FF0E_5E38_91CF_5B9A_4E49["Boss战地点字段"]
local ____Boss_6218_5F00_59CB_63D0_793A_6587_672C = ____00_FF0E_5E38_91CF_5B9A_4E49["Boss战开始提示文本"]
local ____Boss_6218_7BAD_5934_7279_6548_5B57_6BB5 = ____00_FF0E_5E38_91CF_5B9A_4E49["Boss战箭头特效字段"]
local ____Boss_6218_8F6C_573A_540E_63D0_793A_6587_672C = ____00_FF0E_5E38_91CF_5B9A_4E49["Boss战转场后提示文本"]
local ____Boss_6218_515C_5E95_641C_654C_95F4_9694_6BEB_79D2 = ____00_FF0E_5E38_91CF_5B9A_4E49["Boss战兜底搜敌间隔毫秒"]
local ____Boss_6218_6700_5927_8FFD_51FB_8DDD_79BB = ____00_FF0E_5E38_91CF_5B9A_4E49["Boss战最大追击距离"]
local ____Boss_6218_6700_5927_8FFD_51FB_8DDD_79BB_5E73_65B9 = ____00_FF0E_5E38_91CF_5B9A_4E49["Boss战最大追击距离平方"]
local ____Boss_6218_80DC_5229_63D0_793A_6587_672C = ____00_FF0E_5E38_91CF_5B9A_4E49["Boss战胜利提示文本"]
local ____Boss_6218_8FD0_884C_6A21_5757_540D = ____00_FF0E_5E38_91CF_5B9A_4E49["Boss战运行模块名"]
local ____01_FF0EBoss_6218_8FD0_884C_4E0A_4E0B_6587 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.01．Boss战运行上下文")
local _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____01_FF0EBoss_6218_8FD0_884C_4E0A_4E0B_6587["读取Boss战运行上下文"]
local _____8BFB_53D6_77E9_5F62_73A9_5BB6_53EF_89C1_5EA6_4FEE_6574_5668 = ____01_FF0EBoss_6218_8FD0_884C_4E0A_4E0B_6587["读取矩形玩家可见度修整器"]
local _____8BB0_5F55_77E9_5F62_73A9_5BB6_53EF_89C1_5EA6_4FEE_6574_5668 = ____01_FF0EBoss_6218_8FD0_884C_4E0A_4E0B_6587["记录矩形玩家可见度修整器"]
local ____02_FF0EBoss_6218_533A_57DF_97F3_9891 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.02．Boss战区域音频")
local _____63A5_7BA1Boss_6218_533A_57DF_97F3_9891 = ____02_FF0EBoss_6218_533A_57DF_97F3_9891["接管Boss战区域音频"]
function _____83B7_53D6_53E5_67C4ID(handle)
    if handle == nil or handle == 0 then
        return 0
    end
    return GetHandleId(handle) or 0
end
function _____5F53_524D_547D_4EE4_5141_8BB8_515C_5E95_4E0B_4EE4(boss)
    if boss == nil or boss == 0 then
        return false
    end
    if IsUnitPausedBJ(boss) then
        return false
    end
    local _____5F53_524D_547D_4EE4ID = GetUnitCurrentOrder(boss) or 0
    if _____5F53_524D_547D_4EE4ID == 0 then
        return true
    end
    if _____5F53_524D_547D_4EE4ID == _____653B_51FB_547D_4EE4ID then
        return true
    end
    if _____5F53_524D_547D_4EE4ID == _____653B_51FB_4E00_6B21_547D_4EE4ID then
        return true
    end
    if _____5F53_524D_547D_4EE4ID == _____505C_6B62_547D_4EE4ID then
        return true
    end
    if _____5F53_524D_547D_4EE4ID == _____4FDD_6301_547D_4EE4ID then
        return true
    end
    return false
end
function _____5355_4F4D_5728Boss_6218_8303_56F4_5185_6709_6548(boss, rectHandle, target, maxDistanceSq)
    if target == nil or target == 0 then
        return false
    end
    if not isValidCombatEnemyUnit(target, boss) then
        return false
    end
    if rectHandle ~= nil and rectHandle ~= 0 and not RectContainsUnit(rectHandle, target) then
        return false
    end
    local dx = GetUnitX(target) - GetUnitX(boss)
    local dy = GetUnitY(target) - GetUnitY(boss)
    return dx * dx + dy * dy <= maxDistanceSq
end
function _____8BB0_5F55_6700_8FD1_679A_4E3E_76EE_6807(target)
    local handleId = _____83B7_53D6_53E5_67C4ID(target)
    if handleId == 0 then
        return
    end
    local dx = GetUnitX(target) - GetUnitX(_____6700_8FD1_654C_4EBA_679A_4E3EBoss)
    local dy = GetUnitY(target) - GetUnitY(_____6700_8FD1_654C_4EBA_679A_4E3EBoss)
    local distanceSq = dx * dx + dy * dy
    if distanceSq > _____6700_8FD1_654C_4EBA_679A_4E3E_6700_5927_8DDD_79BB_5E73_65B9 then
        return
    end
    if _____6700_8FD1_654C_4EBA_679A_4E3E_7ED3_679C == nil then
        _____6700_8FD1_654C_4EBA_679A_4E3E_7ED3_679C = target
        _____6700_8FD1_654C_4EBA_679A_4E3E_6700_77ED_8DDD_79BB_5E73_65B9 = distanceSq
        _____6700_8FD1_654C_4EBA_679A_4E3E_6700_5C0F_53E5_67C4ID = handleId
        return
    end
    if distanceSq < _____6700_8FD1_654C_4EBA_679A_4E3E_6700_77ED_8DDD_79BB_5E73_65B9 then
        _____6700_8FD1_654C_4EBA_679A_4E3E_7ED3_679C = target
        _____6700_8FD1_654C_4EBA_679A_4E3E_6700_77ED_8DDD_79BB_5E73_65B9 = distanceSq
        _____6700_8FD1_654C_4EBA_679A_4E3E_6700_5C0F_53E5_67C4ID = handleId
        return
    end
    if distanceSq == _____6700_8FD1_654C_4EBA_679A_4E3E_6700_77ED_8DDD_79BB_5E73_65B9 and handleId < _____6700_8FD1_654C_4EBA_679A_4E3E_6700_5C0F_53E5_67C4ID then
        _____6700_8FD1_654C_4EBA_679A_4E3E_7ED3_679C = target
        _____6700_8FD1_654C_4EBA_679A_4E3E_6700_5C0F_53E5_67C4ID = handleId
    end
end
function ____on_679A_4E3E_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D()
    local target = GetEnumUnit()
    if not _____5355_4F4D_5728Boss_6218_8303_56F4_5185_6709_6548(_____6700_8FD1_654C_4EBA_679A_4E3EBoss, _____6700_8FD1_654C_4EBA_679A_4E3E_77E9_5F62, target, _____6700_8FD1_654C_4EBA_679A_4E3E_6700_5927_8DDD_79BB_5E73_65B9) then
        return
    end
    _____8BB0_5F55_6700_8FD1_679A_4E3E_76EE_6807(target)
end
function _____8BFB_53D6_73A9_5BB6_82F1_96C4_7EC4()
    return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
end
function _____8BFB_53D6_5F53_524D_6709_6548_4EC7_6068_76EE_6807(context)
    local entries = getEnemyThreats(context["Boss单位"])
    local bestTarget = nil
    local bestThreat = 0
    local bestHandleId = 0
    do
        local i = 0
        while i < #entries do
            do
                local entry = entries[i + 1]
                local target = entry.targetRef
                if not _____5355_4F4D_5728Boss_6218_8303_56F4_5185_6709_6548(context["Boss单位"], context["地点矩形"], target, ____Boss_6218_6700_5927_8FFD_51FB_8DDD_79BB_5E73_65B9) then
                    goto __continue35
                end
                local targetHandleId = _____83B7_53D6_53E5_67C4ID(target)
                if bestTarget == nil or entry.threat > bestThreat or entry.threat == bestThreat and targetHandleId < bestHandleId then
                    bestTarget = target
                    bestThreat = entry.threat
                    bestHandleId = targetHandleId
                end
            end
            ::__continue35::
            i = i + 1
        end
    end
    return bestTarget
end
function _____4ECE_73A9_5BB6_82F1_96C4_7EC4_67E5_627E_6700_8FD1_654C_4EBA(context)
    local _____73A9_5BB6_82F1_96C4_7EC4 = _____8BFB_53D6_73A9_5BB6_82F1_96C4_7EC4()
    if _____73A9_5BB6_82F1_96C4_7EC4 == nil or _____73A9_5BB6_82F1_96C4_7EC4 == 0 then
        return nil
    end
    _____6700_8FD1_654C_4EBA_679A_4E3EBoss = context["Boss单位"]
    _____6700_8FD1_654C_4EBA_679A_4E3E_77E9_5F62 = context["地点矩形"]
    _____6700_8FD1_654C_4EBA_679A_4E3E_6700_5927_8DDD_79BB_5E73_65B9 = ____Boss_6218_6700_5927_8FFD_51FB_8DDD_79BB_5E73_65B9
    _____6700_8FD1_654C_4EBA_679A_4E3E_7ED3_679C = nil
    _____6700_8FD1_654C_4EBA_679A_4E3E_6700_77ED_8DDD_79BB_5E73_65B9 = 0
    _____6700_8FD1_654C_4EBA_679A_4E3E_6700_5C0F_53E5_67C4ID = 0
    ForGroup(_____73A9_5BB6_82F1_96C4_7EC4, ____on_679A_4E3E_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D)
    return _____6700_8FD1_654C_4EBA_679A_4E3E_7ED3_679C
end
function _____4ECE_9644_8FD1_5355_4F4D_67E5_627E_6700_8FD1_654C_4EBA(context)
    local boss = context["Boss单位"]
    local group = CreateGroup()
    if group == nil or group == 0 then
        return nil
    end
    local result = nil
    local bestDistanceSq = 0
    local bestHandleId = 0
    GroupEnumUnitsInRange(
        group,
        GetUnitX(boss),
        GetUnitY(boss),
        ____Boss_6218_6700_5927_8FFD_51FB_8DDD_79BB,
        nil
    )
    while true do
        do
            local target = FirstOfGroup(group)
            if target == nil or target == 0 then
                break
            end
            GroupRemoveUnit(group, target)
            if not _____5355_4F4D_5728Boss_6218_8303_56F4_5185_6709_6548(boss, context["地点矩形"], target, ____Boss_6218_6700_5927_8FFD_51FB_8DDD_79BB_5E73_65B9) then
                goto __continue42
            end
            local handleId = _____83B7_53D6_53E5_67C4ID(target)
            local dx = GetUnitX(target) - GetUnitX(boss)
            local dy = GetUnitY(target) - GetUnitY(boss)
            local distanceSq = dx * dx + dy * dy
            if result == nil or distanceSq < bestDistanceSq or distanceSq == bestDistanceSq and handleId < bestHandleId then
                result = target
                bestDistanceSq = distanceSq
                bestHandleId = handleId
            end
        end
        ::__continue42::
    end
    DestroyGroup(group)
    return result
end
____exports["尝试兜底搜敌并下令"] = function(context, nowMs)
    if nowMs < context["下次兜底搜敌时间"] then
        return
    end
    context["下次兜底搜敌时间"] = nowMs + ____Boss_6218_515C_5E95_641C_654C_95F4_9694_6BEB_79D2
    if not _____5F53_524D_547D_4EE4_5141_8BB8_515C_5E95_4E0B_4EE4(context["Boss单位"]) then
        return
    end
    local threatTarget = _____8BFB_53D6_5F53_524D_6709_6548_4EC7_6068_76EE_6807(context)
    if threatTarget ~= nil and threatTarget ~= 0 then
        context["最近兜底目标ID"] = 0
        return
    end
    local ____4ECE_73A9_5BB6_82F1_96C4_7EC4_67E5_627E_6700_8FD1_654C_4EBA_result_14 = _____4ECE_73A9_5BB6_82F1_96C4_7EC4_67E5_627E_6700_8FD1_654C_4EBA(context)
    if ____4ECE_73A9_5BB6_82F1_96C4_7EC4_67E5_627E_6700_8FD1_654C_4EBA_result_14 == nil then
        ____4ECE_73A9_5BB6_82F1_96C4_7EC4_67E5_627E_6700_8FD1_654C_4EBA_result_14 = _____4ECE_9644_8FD1_5355_4F4D_67E5_627E_6700_8FD1_654C_4EBA(context)
    end
    local fallbackTarget = ____4ECE_73A9_5BB6_82F1_96C4_7EC4_67E5_627E_6700_8FD1_654C_4EBA_result_14
    if fallbackTarget == nil or fallbackTarget == 0 then
        return
    end
    local fallbackTargetId = _____83B7_53D6_53E5_67C4ID(fallbackTarget)
    local currentOrderId = GetUnitCurrentOrder(context["Boss单位"]) or 0
    if context["最近兜底目标ID"] == fallbackTargetId and (currentOrderId == _____653B_51FB_547D_4EE4ID or currentOrderId == _____653B_51FB_4E00_6B21_547D_4EE4ID) then
        return
    end
    IssueTargetOrder(context["Boss单位"], "attack", fallbackTarget)
    context["最近兜底目标ID"] = fallbackTargetId
    debugLogForce(
        ____Boss_6218_8FD0_884C_6A21_5757_540D,
        "兜底搜敌下令",
        "boss=",
        context["Boss句柄ID"],
        "target=",
        fallbackTargetId
    )
end
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_0.QuestMessageBJ
local ____require_result_1 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_1.GetPlayersAll
local ____require_result_2 = require("lib.扩展函数.BJ函数.04．矩形与区域")
RectContainsUnit = ____require_result_2.RectContainsUnit
local ____require_result_3 = require("lib.扩展函数.BJ函数.05A．电影函数")
local TransmissionFromUnitWithNameBJ = ____require_result_3.TransmissionFromUnitWithNameBJ
local CinematicFilterGenericBJ = ____require_result_3.CinematicFilterGenericBJ
local ____require_result_4 = require("lib.扩展函数.BJ函数.08．单位BJ扩展")
IsUnitPausedBJ = ____require_result_4.IsUnitPausedBJ
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDUserDataGetSafe = ____require_result_5.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_5.YDUserDataSetSafe
local YDUserDataClearSafe = ____require_result_5.YDUserDataClearSafe
local ____require_result_6 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataClearTable = ____require_result_6.YDUserDataClearTable
local ____require_result_7 = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储")
getEnemyThreats = ____require_result_7.getEnemyThreats
local ____require_result_8 = require("lib.扩展函数.封装函数.02．音效系统.index")
local Sound3DII_Mp3PlayReuse = ____require_result_8.Sound3DII_Mp3PlayReuse
local ____require_result_9 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedUnitForPlayer = ____require_result_9.StarOther_PanCameraToTimedUnitForPlayer
local ____require_result_10 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local YDWEAngleBetweenUnits = ____require_result_10.YDWEAngleBetweenUnits
local ____require_result_11 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
isValidCombatEnemyUnit = ____require_result_11.isValidCombatEnemyUnit
local ____require_result_12 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_12.debugLogForce
GetHandleId = jass.GetHandleId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local GetRectCenterX = jass.GetRectCenterX
local GetRectCenterY = jass.GetRectCenterY
local GetOwningPlayer = jass.GetOwningPlayer
local SquareRoot = jass.SquareRoot
local IsUnitType = jass.IsUnitType
local IsUnitInvulnerable = jass.IsUnitInvulnerable
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local PauseUnit = jass.PauseUnit
local PingMinimap = jass.PingMinimap
IssueTargetOrder = jass.IssueTargetOrder
local IssueImmediateOrder = jass.IssueImmediateOrder
GetUnitCurrentOrder = jass.GetUnitCurrentOrder
local OrderId = jass.OrderId
local Player = jass.Player
local IsPlayerInForce = jass.IsPlayerInForce
CreateGroup = jass.CreateGroup
DestroyGroup = jass.DestroyGroup
GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
FirstOfGroup = jass.FirstOfGroup
GroupRemoveUnit = jass.GroupRemoveUnit
ForGroup = jass.ForGroup
GetEnumUnit = jass.GetEnumUnit
local SetUnitPosition = jass.SetUnitPosition
local SetUnitFacing = jass.SetUnitFacing
local IsTerrainPathable = jass.IsTerrainPathable
local CreateFogModifierRect = jass.CreateFogModifierRect
local FogModifierStart = jass.FogModifierStart
local DestroyEffect = jass.DestroyEffect
local DisplayCineFilter = jass.DisplayCineFilter
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY
local FOG_OF_WAR_VISIBLE = jass.FOG_OF_WAR_VISIBLE
local BLEND_MODE_BLEND = jass.BLEND_MODE_BLEND
local ____Quest_6D88_606F_8B66_544A = jglobals.bj_QUESTMESSAGE_WARNING
local ____Quest_6D88_606F_5B8C_6210 = jglobals.bj_QUESTMESSAGE_COMPLETED
local ____Quest_6D88_606F_79D8_5BC6 = jglobals.bj_QUESTMESSAGE_SECRET
local bj_TIMETYPE_SET = jglobals.bj_TIMETYPE_SET
_____653B_51FB_547D_4EE4ID = OrderId("attack")
_____653B_51FB_4E00_6B21_547D_4EE4ID = OrderId("attackonce")
_____505C_6B62_547D_4EE4ID = OrderId("stop")
_____4FDD_6301_547D_4EE4ID = OrderId("holdposition")
local ____Boss_6B7B_4EA1_540EYD_6E05_8868_5EF6_8FDF_6BEB_79D2 = 10000
_____6700_8FD1_654C_4EBA_679A_4E3EBoss = nil
_____6700_8FD1_654C_4EBA_679A_4E3E_77E9_5F62 = nil
_____6700_8FD1_654C_4EBA_679A_4E3E_6700_5927_8DDD_79BB_5E73_65B9 = 0
_____6700_8FD1_654C_4EBA_679A_4E3E_7ED3_679C = nil
_____6700_8FD1_654C_4EBA_679A_4E3E_6700_77ED_8DDD_79BB_5E73_65B9 = 0
_____6700_8FD1_654C_4EBA_679A_4E3E_6700_5C0F_53E5_67C4ID = 0
local _____73A9_5BB6_82F1_96C4_7EA0_504F_77E9_5F62 = nil
local _____73A9_5BB6_82F1_96C4_7EA0_504F_4E2D_5FC3X = 0
local _____73A9_5BB6_82F1_96C4_7EA0_504F_4E2D_5FC3Y = 0
local _____73A9_5BB6_5730_5F62_7EA0_504F_6B65_957F = 150
local _____73A9_5BB6_5730_5F62_7EA0_504F_6700_5927_6B65_6570 = 24
local _____5F85_6E05_7406BossYD_4EFB_52A1_5217_8868 = {}
local function ____on_73A9_5BB6_82F1_96C4_7EA0_504F_5355_4F4D()
    local unit = GetEnumUnit()
    if unit == nil or unit == 0 then
        return
    end
    if IsUnitPausedBJ(unit) then
        return
    end
    if _____73A9_5BB6_82F1_96C4_7EA0_504F_77E9_5F62 ~= nil and _____73A9_5BB6_82F1_96C4_7EA0_504F_77E9_5F62 ~= 0 and not RectContainsUnit(_____73A9_5BB6_82F1_96C4_7EA0_504F_77E9_5F62, unit) then
        return
    end
    if not IsTerrainPathable(
        GetUnitX(unit),
        GetUnitY(unit),
        PATHING_TYPE_WALKABILITY
    ) then
        return
    end
    SetUnitPosition(unit, _____73A9_5BB6_82F1_96C4_7EA0_504F_4E2D_5FC3X, _____73A9_5BB6_82F1_96C4_7EA0_504F_4E2D_5FC3Y)
end
local function ____on_73A9_5BB6_82F1_96C4_8F6C_573A_642C_8FD0_5355_4F4D()
    local unit = GetEnumUnit()
    if unit == nil or unit == 0 then
        return
    end
    SetUnitPosition(unit, _____73A9_5BB6_82F1_96C4_7EA0_504F_4E2D_5FC3X, _____73A9_5BB6_82F1_96C4_7EA0_504F_4E2D_5FC3Y)
end
local function _____8BFB_53D6_73A9_5BB6_7EC4()
    local ____YDUserDataGetSafe_result_13 = YDUserDataGetSafe("string", "玩家", "玩家组", "force")
    if ____YDUserDataGetSafe_result_13 == nil then
        ____YDUserDataGetSafe_result_13 = GetPlayersAll()
    end
    return ____YDUserDataGetSafe_result_13
end
____exports["单位是否死亡"] = function(unit)
    if unit == nil or unit == 0 then
        return true
    end
    return IsUnitType(unit, UNIT_TYPE_DEAD)
end
____exports["读取Boss战矩形"] = function()
    return YDUserDataGetSafe("string", ____Boss_6218_8868_540D, ____Boss_6218_5730_70B9_5B57_6BB5, "rect")
end
____exports["读取Boss战音频"] = function(_____5B57_6BB5_540D)
    return YDUserDataGetSafe("string", ____Boss_6218_8868_540D, _____5B57_6BB5_540D, "sound")
end
____exports["读取Boss战实数"] = function(_____5B57_6BB5_540D)
    return __TS__Number(YDUserDataGetSafe("string", ____Boss_6218_8868_540D, _____5B57_6BB5_540D, "real")) or 0
end
____exports["读取Boss战单位布尔"] = function(bossUnit, _____5B57_6BB5_540D)
    return YDUserDataGetSafe("unit", bossUnit, _____5B57_6BB5_540D, "boolean") == true
end
____exports["读取Boss战单位"] = function(_____5B57_6BB5_540D)
    return YDUserDataGetSafe("string", ____Boss_6218_8868_540D, _____5B57_6BB5_540D, "unit")
end
____exports["确保Boss战区域视野"] = function(rectHandle)
    local rectHandleId = _____83B7_53D6_53E5_67C4ID(rectHandle)
    if rectHandleId == 0 then
        return
    end
    local _____73A9_5BB6_7EC4 = _____8BFB_53D6_73A9_5BB6_7EC4()
    do
        local playerId = 0
        while playerId < ____Boss_6218_53EF_89C1_5EA6_73A9_5BB6_69FD_4F4D_6570 do
            do
                local whichPlayer = Player(playerId)
                if whichPlayer == nil or whichPlayer == 0 then
                    goto __continue56
                end
                if _____73A9_5BB6_7EC4 ~= nil and _____73A9_5BB6_7EC4 ~= 0 and not IsPlayerInForce(whichPlayer, _____73A9_5BB6_7EC4) then
                    goto __continue56
                end
                if _____8BFB_53D6_77E9_5F62_73A9_5BB6_53EF_89C1_5EA6_4FEE_6574_5668(rectHandleId, playerId) ~= nil then
                    goto __continue56
                end
                local fogModifier = CreateFogModifierRect(
                    whichPlayer,
                    FOG_OF_WAR_VISIBLE,
                    rectHandle,
                    true,
                    false
                )
                if fogModifier == nil or fogModifier == 0 then
                    goto __continue56
                end
                FogModifierStart(fogModifier)
                _____8BB0_5F55_77E9_5F62_73A9_5BB6_53EF_89C1_5EA6_4FEE_6574_5668(rectHandleId, playerId, fogModifier)
            end
            ::__continue56::
            playerId = playerId + 1
        end
    end
end
____exports["执行Boss战转场动画"] = function()
    Sound3DII_Mp3PlayReuse("XT\\YX-battle.mp3")
    CinematicFilterGenericBJ(
        0.5,
        BLEND_MODE_BLEND,
        "ReplaceableTextures\\CameraMasks\\Black_mask.blp",
        15,
        15,
        15,
        15,
        0,
        0,
        0,
        0
    )
    TransmissionFromUnitWithNameBJ(
        GetPlayersAll(),
        nil,
        "",
        nil,
        "",
        bj_TIMETYPE_SET,
        2,
        true
    )
end
____exports["完成Boss战转场搬运"] = function(context)
    local boss = context["Boss单位"]
    local _____89E6_53D1_73A9_5BB6_5355_4F4D = ____exports["读取Boss战单位"]("触发玩家")
    local bossX = ____exports["读取Boss战实数"]("BS移动X轴")
    local bossY = ____exports["读取Boss战实数"]("BS移动Y轴")
    local playerX = ____exports["读取Boss战实数"]("玩家移动X轴")
    local playerY = ____exports["读取Boss战实数"]("玩家移动Y轴")
    local _____73A9_5BB6_82F1_96C4_7EC4 = _____8BFB_53D6_73A9_5BB6_82F1_96C4_7EC4()
    DisplayCineFilter(false)
    if bossX ~= 0 or bossY ~= 0 then
        SetUnitPosition(boss, bossX, bossY)
        IssueImmediateOrder(boss, "holdposition")
    end
    if _____89E6_53D1_73A9_5BB6_5355_4F4D == nil or _____89E6_53D1_73A9_5BB6_5355_4F4D == 0 then
        return
    end
    SetUnitPosition(_____89E6_53D1_73A9_5BB6_5355_4F4D, playerX, playerY)
    if _____73A9_5BB6_82F1_96C4_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_7EC4 ~= 0 then
        _____73A9_5BB6_82F1_96C4_7EA0_504F_77E9_5F62 = nil
        _____73A9_5BB6_82F1_96C4_7EA0_504F_4E2D_5FC3X = playerX
        _____73A9_5BB6_82F1_96C4_7EA0_504F_4E2D_5FC3Y = playerY
        ForGroup(_____73A9_5BB6_82F1_96C4_7EC4, ____on_73A9_5BB6_82F1_96C4_8F6C_573A_642C_8FD0_5355_4F4D)
    end
    SetUnitFacing(
        _____89E6_53D1_73A9_5BB6_5355_4F4D,
        YDWEAngleBetweenUnits(_____89E6_53D1_73A9_5BB6_5355_4F4D, boss)
    )
    StarOther_PanCameraToTimedUnitForPlayer(
        GetOwningPlayer(_____89E6_53D1_73A9_5BB6_5355_4F4D),
        _____89E6_53D1_73A9_5BB6_5355_4F4D,
        0.1
    )
end
____exports["完成Boss战启动"] = function(context)
    _____63A5_7BA1Boss_6218_533A_57DF_97F3_9891(context)
    ____exports["确保Boss战区域视野"](context["地点矩形"])
    SetUnitInvulnerable(context["Boss单位"], false)
    PauseUnit(context["Boss单位"], false)
    if context["地点矩形"] ~= nil and context["地点矩形"] ~= 0 then
        PingMinimap(
            GetRectCenterX(context["地点矩形"]),
            GetRectCenterY(context["地点矩形"]),
            15
        )
    else
        PingMinimap(
            GetUnitX(context["Boss单位"]),
            GetUnitY(context["Boss单位"]),
            15
        )
    end
    QuestMessageBJ(
        GetPlayersAll(),
        ____Quest_6D88_606F_8B66_544A,
        ____Boss_6218_5F00_59CB_63D0_793A_6587_672C
    )
    context["是否已激活"] = true
    ____exports["尝试兜底搜敌并下令"](
        context,
        getServerTime()
    )
    debugLogForce(
        ____Boss_6218_8FD0_884C_6A21_5757_540D,
        "Boss战正式激活",
        "boss=",
        context["Boss句柄ID"],
        "generation=",
        context["运行代次"]
    )
end
____exports["纠偏Boss位置"] = function(context)
    if context["地点矩形"] == nil or context["地点矩形"] == 0 then
        return
    end
    if IsUnitPausedBJ(context["Boss单位"]) then
        return
    end
    if not IsTerrainPathable(
        GetUnitX(context["Boss单位"]),
        GetUnitY(context["Boss单位"]),
        PATHING_TYPE_WALKABILITY
    ) then
        return
    end
    SetUnitPosition(
        context["Boss单位"],
        GetRectCenterX(context["地点矩形"]),
        GetRectCenterY(context["地点矩形"])
    )
end
____exports["纠偏玩家英雄位置"] = function(rectHandle)
    local _____73A9_5BB6_82F1_96C4_7EC4 = _____8BFB_53D6_73A9_5BB6_82F1_96C4_7EC4()
    if _____73A9_5BB6_82F1_96C4_7EC4 == nil or _____73A9_5BB6_82F1_96C4_7EC4 == 0 then
        return
    end
    if rectHandle == nil or rectHandle == 0 then
        return
    end
    _____73A9_5BB6_82F1_96C4_7EA0_504F_77E9_5F62 = rectHandle
    _____73A9_5BB6_82F1_96C4_7EA0_504F_4E2D_5FC3X = GetRectCenterX(rectHandle)
    _____73A9_5BB6_82F1_96C4_7EA0_504F_4E2D_5FC3Y = GetRectCenterY(rectHandle)
    ForGroup(_____73A9_5BB6_82F1_96C4_7EC4, ____on_73A9_5BB6_82F1_96C4_7EA0_504F_5355_4F4D)
end
____exports["清理Boss战单位字段"] = function(bossUnit)
    local _____5F53_524DBoss_6218_5355_4F4D = YDUserDataGetSafe("string", ____Boss_6218_8868_540D, ____Boss_6218_5355_4F4D_5B57_6BB5, "unit")
    if _____5F53_524DBoss_6218_5355_4F4D == nil or _____5F53_524DBoss_6218_5355_4F4D == 0 then
        return
    end
    if _____83B7_53D6_53E5_67C4ID(_____5F53_524DBoss_6218_5355_4F4D) ~= _____83B7_53D6_53E5_67C4ID(bossUnit) then
        return
    end
    YDUserDataSetSafe(
        "string",
        ____Boss_6218_8868_540D,
        ____Boss_6218_5355_4F4D_5B57_6BB5,
        "unit",
        nil
    )
    YDUserDataClearSafe("string", ____Boss_6218_8868_540D, ____Boss_6218_5355_4F4D_5B57_6BB5, "unit")
end
____exports["清理Boss箭头特效"] = function(bossUnit)
    local arrowEffect = YDUserDataGetSafe("unit", bossUnit, ____Boss_6218_7BAD_5934_7279_6548_5B57_6BB5, "effect")
    if arrowEffect == nil or arrowEffect == 0 then
        return
    end
    DestroyEffect(arrowEffect)
end
____exports["登记Boss死亡延迟清理YD数据"] = function(context, nowMs)
    _____5F85_6E05_7406BossYD_4EFB_52A1_5217_8868[#_____5F85_6E05_7406BossYD_4EFB_52A1_5217_8868 + 1] = {bossUnit = context["Boss单位"], bossHandleId = context["Boss句柄ID"], ["运行代次"] = context["运行代次"], ["截止时间"] = nowMs + ____Boss_6B7B_4EA1_540EYD_6E05_8868_5EF6_8FDF_6BEB_79D2}
end
____exports["处理待清理Boss单位YD数据"] = function(nowMs)
    do
        local i = #_____5F85_6E05_7406BossYD_4EFB_52A1_5217_8868 - 1
        while i >= 0 do
            do
                local task = _____5F85_6E05_7406BossYD_4EFB_52A1_5217_8868[i + 1]
                if nowMs < task["截止时间"] then
                    goto __continue90
                end
                local currentContext = _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587(task.bossUnit)
                if currentContext == nil or currentContext["运行代次"] == task["运行代次"] then
                    YDUserDataClearTable("unit", task.bossUnit)
                    debugLogForce(
                        ____Boss_6218_8FD0_884C_6A21_5757_540D,
                        "延迟清理Boss单位YDUserData",
                        "boss=",
                        task.bossHandleId,
                        "generation=",
                        task["运行代次"]
                    )
                end
                __TS__ArraySplice(_____5F85_6E05_7406BossYD_4EFB_52A1_5217_8868, i, 1)
            end
            ::__continue90::
            i = i - 1
        end
    end
end
____exports["当前是否存在待清理BossYD任务"] = function()
    return #_____5F85_6E05_7406BossYD_4EFB_52A1_5217_8868 > 0
end
____exports["获取Boss战转场后提示文本"] = function()
    return ____Boss_6218_8F6C_573A_540E_63D0_793A_6587_672C
end
____exports["获取Boss战胜利提示文本"] = function()
    return ____Boss_6218_80DC_5229_63D0_793A_6587_672C
end
____exports["获取Quest消息完成"] = function()
    return ____Quest_6D88_606F_5B8C_6210
end
____exports["获取Quest消息秘密"] = function()
    return ____Quest_6D88_606F_79D8_5BC6
end
return ____exports
