--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5355_4F4D_6709_6548, _____6E05_7406_902E_6355_8868_73B0, _____91CA_653E_6F14_51FA_6682_505C, ____on_6267_6CD5_5BF9_767D_7ED3_675F, _____79FB_9664_5355_4F4D_6682_505C, _____9500_6BC1_5355_4F4D_7ED1_5B9A_95EA_7535, DestroyEffect, GetWidgetLife, SetUnitInvulnerable, _____6F14_51FA_6682_505C_6765_6E90, _____5F53_524D_6267_6CD5_72B6_6001
local ____02_FF0E_5267_60C5NPC_521B_5EFA = require("系统.11．剧情系统.00．公共.02．剧情NPC创建")
local _____521B_5EFA_5267_60C5NPC_5355_4F4D = ____02_FF0E_5267_60C5NPC_521B_5EFA["创建剧情NPC单位"]
local ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接")
local _____542F_52A8_5267_60C5Boss_6218 = ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5["启动剧情Boss战"]
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and GetWidgetLife(unit) > 0.405
end
function _____6E05_7406_902E_6355_8868_73B0()
    local state = _____5F53_524D_6267_6CD5_72B6_6001
    if state == nil then
        return
    end
    if state["枷锁闪电"] ~= nil and state["枷锁闪电"] ~= 0 then
        _____9500_6BC1_5355_4F4D_7ED1_5B9A_95EA_7535(state["枷锁闪电"])
        state["枷锁闪电"] = nil
    end
    if state["枷锁特效"] ~= nil and state["枷锁特效"] ~= 0 then
        DestroyEffect(state["枷锁特效"])
        state["枷锁特效"] = nil
    end
end
function _____91CA_653E_6F14_51FA_6682_505C()
    local state = _____5F53_524D_6267_6CD5_72B6_6001
    if state == nil then
        return
    end
    if state["触发英雄"] ~= nil and state["触发英雄"] ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(state["触发英雄"], _____6F14_51FA_6682_505C_6765_6E90)
    end
    if state["Boss单位"] ~= nil and state["Boss单位"] ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(state["Boss单位"], _____6F14_51FA_6682_505C_6765_6E90)
    end
end
function ____on_6267_6CD5_5BF9_767D_7ED3_675F()
    local state = _____5F53_524D_6267_6CD5_72B6_6001
    if state == nil or state["已启动战斗"] or not _____5355_4F4D_6709_6548(state["Boss单位"]) then
        _____6E05_7406_902E_6355_8868_73B0()
        _____91CA_653E_6F14_51FA_6682_505C()
        return
    end
    state["已启动战斗"] = true
    _____6E05_7406_902E_6355_8868_73B0()
    local _____5DF2_542F_52A8 = _____542F_52A8_5267_60C5Boss_6218(state["Boss单位"], {["触发单位"] = state["触发英雄"]})
    _____91CA_653E_6F14_51FA_6682_505C()
    if not _____5DF2_542F_52A8 then
        SetUnitInvulnerable(state["Boss单位"], false)
        state["已启动战斗"] = false
    end
end
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
local registerPlayerUnitEventForPlayerIds = ____require_result_1.registerPlayerUnitEventForPlayerIds
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_2.registerDeathListener
local unregisterDeathListener = ____require_result_2.unregisterDeathListener
local ____require_result_3 = require("系统.00．核心系统.07．联机安全工具")
local safeTriggerAddAction = ____require_result_3.safeTriggerAddAction
local safeTriggerRemoveAction = ____require_result_3.safeTriggerRemoveAction
local safeDestroyTrigger = ____require_result_3.safeDestroyTrigger
local ____require_result_4 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_4["是玩家英雄组单位"]
local ____require_result_5 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_5["广播单位提示"]
local ____require_result_6 = require("系统.09．表现系统.06．广播提示消息.00．常量定义")
local _____5E7F_64AD_63D0_793A_6ED1_5165_6BEB_79D2 = ____require_result_6["广播提示滑入毫秒"]
local _____5E7F_64AD_63D0_793A_6DE1_51FA_6BEB_79D2 = ____require_result_6["广播提示淡出毫秒"]
local ____require_result_7 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_7["添加单位暂停"]
_____79FB_9664_5355_4F4D_6682_505C = ____require_result_7["移除单位暂停"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电")
local _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535 = ____require_result_8["创建单位绑定闪电"]
_____9500_6BC1_5355_4F4D_7ED1_5B9A_95EA_7535 = ____require_result_8["销毁单位绑定闪电"]
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_9.stringToFourCCSafe
local ____require_result_10 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_10.GetPlayersAll
local ____require_result_11 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_11.QuestMessageBJ
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local Cos = jass.Cos
local CreateGroup = jass.CreateGroup
local CreateTrigger = jass.CreateTrigger
DestroyEffect = jass.DestroyEffect
local DestroyGroup = jass.DestroyGroup
local FirstOfGroup = jass.FirstOfGroup
local GetAttacker = jass.GetAttacker
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerController = jass.GetPlayerController
local GetPlayerId = jass.GetPlayerId
local GetPlayerSlotState = jass.GetPlayerSlotState
local GetPlayerState = jass.GetPlayerState
local GetRandomReal = jass.GetRandomReal
local GetTriggerUnit = jass.GetTriggerUnit
local GetUnitFacing = jass.GetUnitFacing
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
GetWidgetLife = jass.GetWidgetLife
local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
local GroupRemoveUnit = jass.GroupRemoveUnit
local IssueImmediateOrder = jass.IssueImmediateOrder
local Player = jass.Player
local Rect = jass.Rect
local RemoveRect = jass.RemoveRect
local SetPlayerState = jass.SetPlayerState
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitFacing = jass.SetUnitFacing
SetUnitInvulnerable = jass.SetUnitInvulnerable
local Sin = jass.Sin
local _____7CBE_7075_57CE_5DE6 = -16512
local _____7CBE_7075_57CE_53F3 = -3744
local _____7CBE_7075_57CE_4E0B = -13280
local _____7CBE_7075_57CE_4E0A = -5632
local _____6267_6CD5_5355_4F4D_68C0_67E5_8303_56F4 = 500
local _____745F_5170_8FEA_5C14_51FA_751F_524D_65B9_8DDD_79BB = 250
local _____6982_7387_68C0_67E5_51B7_5374_6BEB_79D2 = 1000
_____6F14_51FA_6682_505C_6765_6E90 = "支线.瑟兰迪尔执法演出"
local _____53EF_6E38_73A9_73A9_5BB6ID = {
    0,
    1,
    2,
    3,
    4
}
local _____89D2_5EA6_8F6C_5F27_5EA6 = 0.017453292519943295
local _____6267_6CD5_961F_7537_5355_4F4DID = stringToFourCCSafe("h00L")
local _____6267_6CD5_961F_5973_5355_4F4DID = stringToFourCCSafe("h00K")
local _____6267_6CD5_961F_957F_5355_4F4DID = stringToFourCCSafe("h00Z")
local _____5723_5149_7279_6548 = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl"
local _____7A7A_4E2D_9501_94FE_7279_6548 = "Abilities\\Spells\\Human\\AerialShackles\\AerialShacklesTarget.mdl"
local _____7CBE_7075_57CE_76D1_542C_77E9_5F62 = nil
local _____653B_51FB_76D1_542C_89E6_53D1_5668 = nil
local _____653B_51FB_76D1_542C_52A8_4F5C = nil
local _____5165_53E3_5DF2_89E6_53D1 = false
local _____4E0A_6B21_6982_7387_68C0_67E5_65F6_95F4 = -_____6982_7387_68C0_67E5_51B7_5374_6BEB_79D2
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____5355_4F4D_4F4D_4E8E_7CBE_7075_57CE(unit)
    if not _____5355_4F4D_6709_6548(unit) then
        return false
    end
    local x = GetUnitX(unit)
    local y = GetUnitY(unit)
    return x >= _____7CBE_7075_57CE_5DE6 and x <= _____7CBE_7075_57CE_53F3 and y >= _____7CBE_7075_57CE_4E0B and y <= _____7CBE_7075_57CE_4E0A
end
local function _____662F_53EF_6E38_73A9_82F1_96C4(unit)
    if not _____5355_4F4D_6709_6548(unit) or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(unit) then
        return false
    end
    local playerId = GetPlayerId(GetOwningPlayer(unit))
    return playerId >= 0 and playerId <= 4
end
local function _____8BFB_53D6_9644_8FD1_6267_6CD5_89E6_53D1_6982_7387(victim)
    local group = CreateGroup()
    if group == nil or group == 0 then
        return 0
    end
    GroupEnumUnitsInRange(
        group,
        GetUnitX(victim),
        GetUnitY(victim),
        _____6267_6CD5_5355_4F4D_68C0_67E5_8303_56F4,
        nil
    )
    local _____6709_666E_901A_961F_5458 = false
    local _____6709_6267_6CD5_961F_957F = false
    while true do
        do
            local unit = FirstOfGroup(group)
            if unit == nil or unit == 0 then
                break
            end
            GroupRemoveUnit(group, unit)
            if not _____5355_4F4D_6709_6548(unit) then
                goto __continue9
            end
            local unitTypeId = GetUnitTypeId(unit)
            if unitTypeId == _____6267_6CD5_961F_957F_5355_4F4DID then
                _____6709_6267_6CD5_961F_957F = true
                break
            end
            if unitTypeId == _____6267_6CD5_961F_7537_5355_4F4DID or unitTypeId == _____6267_6CD5_961F_5973_5355_4F4DID then
                _____6709_666E_901A_961F_5458 = true
            end
        end
        ::__continue9::
    end
    DestroyGroup(group)
    return _____6709_6267_6CD5_961F_957F and 10 or (_____6709_666E_901A_961F_5458 and 5 or 0)
end
local function _____53D6_5E7F_64AD_5B8C_6574_64AD_653E_6BEB_79D2(_____505C_7559_6BEB_79D2)
    return _____5E7F_64AD_63D0_793A_6ED1_5165_6BEB_79D2 + _____505C_7559_6BEB_79D2 + _____5E7F_64AD_63D0_793A_6DE1_51FA_6BEB_79D2
end
local function _____64AD_653E_7B2C_516D_6BB5_5BF9_767D()
    local state = _____5F53_524D_6267_6CD5_72B6_6001
    if state == nil or not _____5355_4F4D_6709_6548(state["Boss单位"]) then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(state["触发英雄"], "看来这次解释不清了。大家小心，先挡住他！", 3200)
    addDelayedCallback(
        _____53D6_5E7F_64AD_5B8C_6574_64AD_653E_6BEB_79D2(3200),
        ____on_6267_6CD5_5BF9_767D_7ED3_675F
    )
end
local function _____64AD_653E_7B2C_4E94_6BB5_5BF9_767D()
    local state = _____5F53_524D_6267_6CD5_72B6_6001
    if state == nil or not _____5355_4F4D_6709_6548(state["Boss单位"]) then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(state["Boss单位"], "拒捕、袭击城民，还企图以武力抗法。很好，那就由我亲自执行裁决。", 4200)
    addDelayedCallback(
        _____53D6_5E7F_64AD_5B8C_6574_64AD_653E_6BEB_79D2(4200),
        _____64AD_653E_7B2C_516D_6BB5_5BF9_767D
    )
end
local function _____64AD_653E_7B2C_56DB_6BB5_5BF9_767D()
    local state = _____5F53_524D_6267_6CD5_72B6_6001
    if state == nil or not _____5355_4F4D_6709_6548(state["Boss单位"]) then
        return
    end
    _____6E05_7406_902E_6355_8868_73B0()
    _____5E7F_64AD_5355_4F4D_63D0_793A(state["触发英雄"], "等等，事情还没弄清楚，不能就这么把我们带走！", 3400)
    addDelayedCallback(
        _____53D6_5E7F_64AD_5B8C_6574_64AD_653E_6BEB_79D2(3400),
        _____64AD_653E_7B2C_4E94_6BB5_5BF9_767D
    )
end
local function _____64AD_653E_7B2C_4E09_6BB5_5BF9_767D()
    local state = _____5F53_524D_6267_6CD5_72B6_6001
    if state == nil or not _____5355_4F4D_6709_6548(state["Boss单位"]) then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(state["Boss单位"], "武器已经落在无辜者身上，这不叫误会。放下武器，跟我回执法厅。", 4200)
    addDelayedCallback(
        _____53D6_5E7F_64AD_5B8C_6574_64AD_653E_6BEB_79D2(4200),
        _____64AD_653E_7B2C_56DB_6BB5_5BF9_767D
    )
end
local function _____64AD_653E_7B2C_4E8C_6BB5_5BF9_767D()
    local state = _____5F53_524D_6267_6CD5_72B6_6001
    if state == nil or not _____5355_4F4D_6709_6548(state["Boss单位"]) then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(state["触发英雄"], "误会，我们只是……一时没控制好手。", 3000)
    addDelayedCallback(
        _____53D6_5E7F_64AD_5B8C_6574_64AD_653E_6BEB_79D2(3000),
        _____64AD_653E_7B2C_4E09_6BB5_5BF9_767D
    )
end
local function _____64AD_653E_7B2C_4E00_6BB5_5BF9_767D()
    local state = _____5F53_524D_6267_6CD5_72B6_6001
    if state == nil or not _____5355_4F4D_6709_6548(state["Boss单位"]) then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(state["Boss单位"], "住手。这里是精灵王城，不是任由外来者撒野的地方。", 3500)
    addDelayedCallback(
        _____53D6_5E7F_64AD_5B8C_6574_64AD_653E_6BEB_79D2(3500),
        _____64AD_653E_7B2C_4E8C_6BB5_5BF9_767D
    )
end
local function _____6CE8_9500_6267_6CD5_5165_53E3()
    if _____653B_51FB_76D1_542C_89E6_53D1_5668 ~= nil and _____653B_51FB_76D1_542C_52A8_4F5C ~= nil then
        safeTriggerRemoveAction(_____653B_51FB_76D1_542C_89E6_53D1_5668, _____653B_51FB_76D1_542C_52A8_4F5C)
    end
    _____653B_51FB_76D1_542C_89E6_53D1_5668 = nil
    _____653B_51FB_76D1_542C_52A8_4F5C = nil
    if _____7CBE_7075_57CE_76D1_542C_77E9_5F62 ~= nil and _____7CBE_7075_57CE_76D1_542C_77E9_5F62 ~= 0 then
        RemoveRect(_____7CBE_7075_57CE_76D1_542C_77E9_5F62)
    end
    _____7CBE_7075_57CE_76D1_542C_77E9_5F62 = nil
end
local function _____521B_5EFA_5E76_64AD_653E_5723_5149_7279_6548(victim)
    local effect = AddSpecialEffect(
        _____5723_5149_7279_6548,
        GetUnitX(victim),
        GetUnitY(victim)
    )
    if effect ~= nil and effect ~= 0 then
        DestroyEffect(effect)
    end
end
local function _____5F00_59CB_745F_5170_8FEA_5C14_6267_6CD5_6F14_51FA(hero, victim)
    local facing = GetUnitFacing(hero)
    local radians = facing * _____89D2_5EA6_8F6C_5F27_5EA6
    local bossX = GetUnitX(hero) + Cos(radians) * _____745F_5170_8FEA_5C14_51FA_751F_524D_65B9_8DDD_79BB
    local bossY = GetUnitY(hero) + Sin(radians) * _____745F_5170_8FEA_5C14_51FA_751F_524D_65B9_8DDD_79BB
    local boss = _____521B_5EFA_5267_60C5NPC_5355_4F4D({
        ["单位ID"] = "N057",
        X = bossX,
        Y = bossY,
        ["朝向"] = (facing + 180) % 360,
        ["玩家ID"] = 15,
        ["登记死亡排泄"] = true
    })
    if boss == nil or boss == 0 then
        return false
    end
    _____5F53_524D_6267_6CD5_72B6_6001 = {
        ["Boss单位"] = boss,
        ["触发英雄"] = hero,
        ["受害NPC"] = victim,
        ["枷锁特效"] = nil,
        ["枷锁闪电"] = nil,
        ["已启动战斗"] = false,
        ["已执行罚款"] = false
    }
    _____5165_53E3_5DF2_89E6_53D1 = true
    _____6CE8_9500_6267_6CD5_5165_53E3()
    IssueImmediateOrder(hero, "stop")
    IssueImmediateOrder(boss, "stop")
    SetUnitFacing(boss, (facing + 180) % 360)
    SetUnitInvulnerable(boss, true)
    _____6DFB_52A0_5355_4F4D_6682_505C(hero, _____6F14_51FA_6682_505C_6765_6E90)
    _____6DFB_52A0_5355_4F4D_6682_505C(boss, _____6F14_51FA_6682_505C_6765_6E90)
    SetUnitAnimationByIndex(boss, 9)
    _____521B_5EFA_5E76_64AD_653E_5723_5149_7279_6548(victim)
    _____5F53_524D_6267_6CD5_72B6_6001["枷锁特效"] = AddSpecialEffectTarget(_____7A7A_4E2D_9501_94FE_7279_6548, hero, "origin")
    _____5F53_524D_6267_6CD5_72B6_6001["枷锁闪电"] = _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535({
        ["效果代码"] = "LEAS",
        ["起点单位"] = boss,
        ["终点单位"] = hero,
        ["持续时间"] = 60,
        ["起点高度偏移"] = 120,
        ["终点高度偏移"] = 80
    })
    _____64AD_653E_7B2C_4E00_6BB5_5BF9_767D()
    return true
end
local function ____on_73A9_5BB6_653B_51FB_4E2D_7ACBNPC()
    if _____5165_53E3_5DF2_89E6_53D1 or _____7CBE_7075_57CE_76D1_542C_77E9_5F62 == nil or _____7CBE_7075_57CE_76D1_542C_77E9_5F62 == 0 then
        return
    end
    local victim = GetTriggerUnit()
    local attacker = GetAttacker()
    if not _____662F_53EF_6E38_73A9_82F1_96C4(attacker) or not _____5355_4F4D_4F4D_4E8E_7CBE_7075_57CE(attacker) or not _____5355_4F4D_4F4D_4E8E_7CBE_7075_57CE(victim) then
        return
    end
    if GetOwningPlayer(victim) ~= Player(jass.PLAYER_NEUTRAL_PASSIVE) then
        return
    end
    local probability = _____8BFB_53D6_9644_8FD1_6267_6CD5_89E6_53D1_6982_7387(victim)
    if probability <= 0 then
        return
    end
    local currentTime = getServerTime()
    if currentTime - _____4E0A_6B21_6982_7387_68C0_67E5_65F6_95F4 < _____6982_7387_68C0_67E5_51B7_5374_6BEB_79D2 then
        return
    end
    _____4E0A_6B21_6982_7387_68C0_67E5_65F6_95F4 = currentTime
    if GetRandomReal(0, 100) >= probability then
        return
    end
    _____5F00_59CB_745F_5170_8FEA_5C14_6267_6CD5_6F14_51FA(attacker, victim)
end
local function _____662F_6709_6548_5728_7EBF_73A9_5BB6(player)
    return player ~= nil and player ~= 0 and GetPlayerController(player) == jass.MAP_CONTROL_USER and GetPlayerSlotState(player) == jass.PLAYER_SLOT_STATE_PLAYING
end
local function _____6267_884C_5168_5458_6CBB_5B89_7F5A_6B3E()
    do
        local playerId = 0
        while playerId <= 4 do
            do
                local player = Player(playerId)
                if not _____662F_6709_6548_5728_7EBF_73A9_5BB6(player) then
                    goto __continue55
                end
                local currentGold = GetPlayerState(player, jass.PLAYER_STATE_RESOURCE_GOLD)
                SetPlayerState(
                    player,
                    jass.PLAYER_STATE_RESOURCE_GOLD,
                    math.max(0, currentGold - 10000)
                )
            end
            ::__continue55::
            playerId = playerId + 1
        end
    end
    QuestMessageBJ(
        GetPlayersAll(),
        jglobals.bj_QUESTMESSAGE_WARNING,
        "|cffffff00『系统消息』：|r因扰乱精灵王城治安，所有玩家被处以|cffff000010000金币|r罚款。"
    )
end
local function ____on_745F_5170_8FEA_5C14_6B7B_4EA1(dyingUnit, _killingUnit)
    local state = _____5F53_524D_6267_6CD5_72B6_6001
    if state == nil or dyingUnit ~= state["Boss单位"] or state["已执行罚款"] then
        return
    end
    state["已执行罚款"] = true
    _____6E05_7406_902E_6355_8868_73B0()
    _____91CA_653E_6F14_51FA_6682_505C()
    _____6267_884C_5168_5458_6CBB_5B89_7F5A_6B3E()
    if _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        unregisterDeathListener(____on_745F_5170_8FEA_5C14_6B7B_4EA1)
        _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
    end
    _____5F53_524D_6267_6CD5_72B6_6001 = nil
end
____exports["初始化瑟兰迪尔执法事件"] = function()
    if _____653B_51FB_76D1_542C_89E6_53D1_5668 ~= nil or _____5165_53E3_5DF2_89E6_53D1 then
        return
    end
    _____7CBE_7075_57CE_76D1_542C_77E9_5F62 = Rect(_____7CBE_7075_57CE_5DE6, _____7CBE_7075_57CE_4E0B, _____7CBE_7075_57CE_53F3, _____7CBE_7075_57CE_4E0A)
    local trigger = CreateTrigger()
    if trigger == nil or trigger == 0 then
        if _____7CBE_7075_57CE_76D1_542C_77E9_5F62 ~= nil and _____7CBE_7075_57CE_76D1_542C_77E9_5F62 ~= 0 then
            RemoveRect(_____7CBE_7075_57CE_76D1_542C_77E9_5F62)
        end
        _____7CBE_7075_57CE_76D1_542C_77E9_5F62 = nil
        return
    end
    local action = safeTriggerAddAction(trigger, ____on_73A9_5BB6_653B_51FB_4E2D_7ACBNPC)
    if action == nil then
        safeDestroyTrigger(trigger)
        if _____7CBE_7075_57CE_76D1_542C_77E9_5F62 ~= nil and _____7CBE_7075_57CE_76D1_542C_77E9_5F62 ~= 0 then
            RemoveRect(_____7CBE_7075_57CE_76D1_542C_77E9_5F62)
        end
        _____7CBE_7075_57CE_76D1_542C_77E9_5F62 = nil
        return
    end
    _____653B_51FB_76D1_542C_89E6_53D1_5668 = trigger
    _____653B_51FB_76D1_542C_52A8_4F5C = action
    registerPlayerUnitEventForPlayerIds(trigger, _____53EF_6E38_73A9_73A9_5BB6ID, jass.EVENT_PLAYER_UNIT_ATTACKED)
    registerDeathListener(____on_745F_5170_8FEA_5C14_6B7B_4EA1)
    _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
end
____exports["读取当前瑟兰迪尔执法Boss"] = function()
    return _____5F53_524D_6267_6CD5_72B6_6001 and _____5F53_524D_6267_6CD5_72B6_6001["Boss单位"]
end
return ____exports
