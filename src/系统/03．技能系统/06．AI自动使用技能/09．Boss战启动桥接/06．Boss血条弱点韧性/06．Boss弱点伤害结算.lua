--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____8BFB_53D6_62A4_76FE_6700_5927_503C, _____5199_5165_62A4_76FE_503C, _____5904_7406_62A4_76FE_7834_788E_8BA1_65F6, ____onBoss_5F31_70B9_8868_73B0_5237_65B0Tick, _____786E_4FDDBoss_5F31_70B9_8868_73B0_5237_65B0, getServerTime, addPeriodicCallback, removePeriodicCallback, _____5F31_70B9_8868_73B0_5237_65B0_56DE_8C03ID
local ____01_FF0E_5E38_91CF_5B9A_4E49 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.06．Boss血条弱点韧性.01．常量定义")
local ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E = ____01_FF0E_5E38_91CF_5B9A_4E49["Boss弱点反馈默认配置"]
local ____Boss_5F31_70B9_63D0_793A_6587_672C = ____01_FF0E_5E38_91CF_5B9A_4E49["Boss弱点提示文本"]
local ____Boss_5F31_70B9_6D88_606F_7C7B_578B_9ED8_8BA4_503C = ____01_FF0E_5E38_91CF_5B9A_4E49["Boss弱点消息类型默认值"]
local ____Boss_5F31_70B9_8FD0_884C_5E38_91CF = ____01_FF0E_5E38_91CF_5B9A_4E49["Boss弱点运行常量"]
local ____04_FF0EBoss_5F31_70B9UI = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.06．Boss血条弱点韧性.04．Boss弱点UI")
local _____663E_793ABoss_5F31_70B9_771F_5B9E_56FE_6807 = ____04_FF0EBoss_5F31_70B9UI["显示Boss弱点真实图标"]
local _____5237_65B0Boss_62A4_76FE_6587_672C = ____04_FF0EBoss_5F31_70B9UI["刷新Boss护盾文本"]
local _____8BBE_7F6EBoss_62A4_76FE_7070_8272_663E_793A = ____04_FF0EBoss_5F31_70B9UI["设置Boss护盾灰色显示"]
local _____8BBE_7F6EBoss_62A4_76FE_5B8C_6574_663E_793A = ____04_FF0EBoss_5F31_70B9UI["设置Boss护盾完整显示"]
local _____8BBE_7F6EBoss_62A4_76FE_7834_788E_663E_793A = ____04_FF0EBoss_5F31_70B9UI["设置Boss护盾破碎显示"]
local _____8BBE_7F6EBoss_5F31_70B9_547D_4E2D_8868_73B0 = ____04_FF0EBoss_5F31_70B9UI["设置Boss弱点命中表现"]
local ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.06．Boss血条弱点韧性.05．Boss弱点运行状态")
local _____83B7_53D6_5168_90E8Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001 = ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001["获取全部Boss血条弱点韧性运行状态"]
function _____8BFB_53D6_62A4_76FE_6700_5927_503C(state)
    return state["最大护盾值"] > 0 and state["最大护盾值"] or 0
end
function _____5199_5165_62A4_76FE_503C(state, value)
    state["当前护盾值"] = value > 0 and value or 0
end
function _____5904_7406_62A4_76FE_7834_788E_8BA1_65F6(state, now)
    if not state["是否护盾破碎中"] then
        return
    end
    if state["护盾破碎切灰截止毫秒"] > 0 and now >= state["护盾破碎切灰截止毫秒"] then
        state["护盾破碎切灰截止毫秒"] = 0
        _____8BBE_7F6EBoss_62A4_76FE_7070_8272_663E_793A(state)
    end
    if state["护盾恢复截止毫秒"] > 0 and now >= state["护盾恢复截止毫秒"] then
        local maxShield = _____8BFB_53D6_62A4_76FE_6700_5927_503C(state)
        _____5199_5165_62A4_76FE_503C(state, maxShield)
        _____5237_65B0Boss_62A4_76FE_6587_672C(state, maxShield)
        _____8BBE_7F6EBoss_62A4_76FE_5B8C_6574_663E_793A(state)
        state["是否护盾破碎中"] = false
        state["护盾破碎切灰截止毫秒"] = 0
        state["护盾恢复截止毫秒"] = 0
    end
end
function ____onBoss_5F31_70B9_8868_73B0_5237_65B0Tick()
    local now = getServerTime()
    local states = _____83B7_53D6_5168_90E8Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001()
    local hasActive = false
    do
        local i = 0
        while i < #states do
            do
                local state = states[i + 1]
                if state["是否已结束"] or not state["是否伤害结算已注册"] then
                    goto __continue83
                end
                hasActive = true
                _____5904_7406_62A4_76FE_7834_788E_8BA1_65F6(state, now)
                do
                    local weakIndex = 0
                    while weakIndex < #state["弱点保护列表"] do
                        if state["弱点保护列表"][weakIndex + 1] == true and now >= (state["弱点保护截止毫秒列表"][weakIndex + 1] or 0) then
                            state["弱点保护列表"][weakIndex + 1] = false
                            state["弱点保护截止毫秒列表"][weakIndex + 1] = 0
                        end
                        if (state["弱点命中表现截止毫秒列表"][weakIndex + 1] or 0) > 0 and now >= state["弱点命中表现截止毫秒列表"][weakIndex + 1] then
                            state["弱点命中表现截止毫秒列表"][weakIndex + 1] = 0
                            _____8BBE_7F6EBoss_5F31_70B9_547D_4E2D_8868_73B0(state, weakIndex, false)
                        end
                        weakIndex = weakIndex + 1
                    end
                end
            end
            ::__continue83::
            i = i + 1
        end
    end
    if not hasActive and _____5F31_70B9_8868_73B0_5237_65B0_56DE_8C03ID ~= 0 then
        removePeriodicCallback(_____5F31_70B9_8868_73B0_5237_65B0_56DE_8C03ID)
        _____5F31_70B9_8868_73B0_5237_65B0_56DE_8C03ID = 0
    end
end
function _____786E_4FDDBoss_5F31_70B9_8868_73B0_5237_65B0()
    if _____5F31_70B9_8868_73B0_5237_65B0_56DE_8C03ID ~= 0 then
        return
    end
    _____5F31_70B9_8868_73B0_5237_65B0_56DE_8C03ID = addPeriodicCallback(____Boss_5F31_70B9_8FD0_884C_5E38_91CF["表现刷新间隔毫秒"], ____onBoss_5F31_70B9_8868_73B0_5237_65B0Tick)
end
local jass = require("jass.common")
local jassGlobals = require("jass.globals")
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_1.registerDamageModifier
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
getServerTime = ____require_result_2.getServerTime
addPeriodicCallback = ____require_result_2.addPeriodicCallback
removePeriodicCallback = ____require_result_2.removePeriodicCallback
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.07．武器类型")
local _____83B7_53D6_5355_4F4D_6700_7EC8_6B66_5668_7C7B_578B = ____require_result_3["获取单位最终武器类型"]
local ____require_result_4 = require("lib.扩展函数.封装函数.02．音效系统.index")
local Sound3DII_Mp3PlayReuse = ____require_result_4.Sound3DII_Mp3PlayReuse
local prewarmReusableSound = ____require_result_4.prewarmReusableSound
local ____require_result_5 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_5.GetPlayersAll
local ____require_result_6 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_6.QuestMessageBJ
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_7["施加快速控制Buff"]
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerName = jass.GetPlayerName
local Player = jass.Player
local ____jassGlobals_bj_QUESTMESSAGE_UNITACQUIRED_8 = jassGlobals.bj_QUESTMESSAGE_UNITACQUIRED
if ____jassGlobals_bj_QUESTMESSAGE_UNITACQUIRED_8 == nil then
    ____jassGlobals_bj_QUESTMESSAGE_UNITACQUIRED_8 = ____Boss_5F31_70B9_6D88_606F_7C7B_578B_9ED8_8BA4_503C["弱点发现"]
end
local bj_QUESTMESSAGE_UNITACQUIRED = ____jassGlobals_bj_QUESTMESSAGE_UNITACQUIRED_8
local ____jassGlobals_bj_QUESTMESSAGE_WARNING_9 = jassGlobals.bj_QUESTMESSAGE_WARNING
if ____jassGlobals_bj_QUESTMESSAGE_WARNING_9 == nil then
    ____jassGlobals_bj_QUESTMESSAGE_WARNING_9 = ____Boss_5F31_70B9_6D88_606F_7C7B_578B_9ED8_8BA4_503C["护盾破碎"]
end
local bj_QUESTMESSAGE_WARNING = ____jassGlobals_bj_QUESTMESSAGE_WARNING_9
local _____662F_5426_5DF2_6CE8_518CBoss_5F31_70B9_6700_7EC8_4F24_5BB3_76D1_542C = false
local _____662F_5426_5DF2_6CE8_518CBoss_5F31_70B9_4F24_5BB3_4FEE_6B63 = false
local _____662F_5426_5DF2_6CE8_518CBoss_7834_76FE_4F24_5BB3_4FEE_6B63 = false
_____5F31_70B9_8868_73B0_5237_65B0_56DE_8C03ID = 0
local function _____8BFB_53D6_62A4_76FE_503C(state)
    return state["当前护盾值"] > 0 and state["当前护盾值"] or 0
end
local function _____53D6_6B63_6570_914D_7F6E(value, fallback)
    return value ~= nil and value > 0 and value or fallback
end
local function _____53D6_975E_8D1F_914D_7F6E(value, fallback)
    return value ~= nil and value >= 0 and value or fallback
end
local function _____53D6_6709_6548_500D_7387_914D_7F6E(value, fallback)
    return value ~= nil and value > 0 and value or fallback
end
local function _____53D6_4F24_5BB3_52A0_6210_914D_7F6E(value, fallback)
    return value ~= nil and value or fallback
end
local function _____64AD_653E_5168_5458_672C_5730_97F3_6548(path)
    if path == nil or path == "" then
        return
    end
    do
        local playerId = 0
        while playerId <= ____Boss_5F31_70B9_8FD0_884C_5E38_91CF["全员音效最大玩家ID"] do
            Sound3DII_Mp3PlayReuse(
                path,
                Player(playerId)
            )
            playerId = playerId + 1
        end
    end
end
local function _____9884_70EDBoss_5F31_70B9_53CD_9988_97F3_6548(state)
    local ____prewarmReusableSound_12 = prewarmReusableSound
    local ____opt_10 = state["配置"]
    ____prewarmReusableSound_12(____opt_10 and ____opt_10["弱点发现音效路径"] or ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["弱点发现音效路径"])
    local ____prewarmReusableSound_15 = prewarmReusableSound
    local ____opt_13 = state["配置"]
    ____prewarmReusableSound_15(____opt_13 and ____opt_13["弱点击中音效路径"] or ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["弱点击中音效路径"])
    local ____prewarmReusableSound_18 = prewarmReusableSound
    local ____opt_16 = state["配置"]
    ____prewarmReusableSound_18(____opt_16 and ____opt_16["护盾破碎音效路径"] or ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["护盾破碎音效路径"])
end
local function _____53D1_9001_5168_5458_4EFB_52A1_6D88_606F(messageType, message)
    if message == "" then
        return
    end
    QuestMessageBJ(
        GetPlayersAll(),
        messageType,
        message
    )
end
local function _____53D6_653B_51FB_8005_73A9_5BB6_540D(attacker)
    if attacker == nil or attacker == 0 then
        return ____Boss_5F31_70B9_63D0_793A_6587_672C["默认玩家名"]
    end
    local owner = GetOwningPlayer(attacker)
    if owner == nil or owner == 0 then
        return ____Boss_5F31_70B9_63D0_793A_6587_672C["默认玩家名"]
    end
    local name = GetPlayerName(owner)
    return name ~= nil and name ~= "" and name or ____Boss_5F31_70B9_63D0_793A_6587_672C["默认玩家名"]
end
local function _____6784_9020_5F31_70B9_53D1_73B0_63D0_793A(attacker, weak)
    return ((((((____Boss_5F31_70B9_63D0_793A_6587_672C["战斗提示前缀"] .. ____Boss_5F31_70B9_63D0_793A_6587_672C["弱点发现玩家名前缀"]) .. _____53D6_653B_51FB_8005_73A9_5BB6_540D(attacker)) .. ____Boss_5F31_70B9_63D0_793A_6587_672C["弱点发现玩家名后缀"]) .. weak["提示颜色"]) .. ____Boss_5F31_70B9_63D0_793A_6587_672C["弱点发现弱点名前缀"]) .. weak["显示名"]) .. ____Boss_5F31_70B9_63D0_793A_6587_672C["弱点发现弱点名后缀"]
end
local function _____67E5_627E_76EE_6807Boss_5F31_70B9_72B6_6001(target)
    if target == nil or target == 0 then
        return nil
    end
    local targetHandleId = GetHandleId(target)
    local states = _____83B7_53D6_5168_90E8Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001()
    do
        local i = 0
        while i < #states do
            local state = states[i + 1]
            if state["Boss句柄ID"] == targetHandleId and state["是否伤害结算已注册"] and not state["是否已结束"] then
                return state
            end
            i = i + 1
        end
    end
    return nil
end
local function _____53D6_6B66_5668_5F31_70B9_952E(attacker)
    local weaponType = _____83B7_53D6_5355_4F4D_6700_7EC8_6B66_5668_7C7B_578B(attacker)
    if weaponType == "剑" then
        return "剑弱"
    end
    if weaponType == "枪" then
        return "枪弱"
    end
    if weaponType == "斧锤" then
        return "斧弱"
    end
    if weaponType == "弓箭" then
        return "弓弱"
    end
    if weaponType == "匕首" then
        return "短剑弱"
    end
    if weaponType == "法杖" then
        return "杖弱"
    end
    return ""
end
local function _____53D6_5C5E_6027_5F31_70B9_952E(snapshot)
    if snapshot == nil then
        return ""
    end
    if snapshot.isFireDamage == true then
        return "火弱"
    end
    if snapshot.isWaterDamage == true then
        return "冰弱"
    end
    if snapshot.isThunderDamage == true then
        return "雷弱"
    end
    if snapshot.isWoodDamage == true then
        return "风弱"
    end
    if snapshot.isLightDamage == true then
        return "光弱"
    end
    if snapshot.isDarkDamage == true then
        return "暗弱"
    end
    return ""
end
local function _____67E5_627E_5F31_70B9_7D22_5F15(state, weakKey)
    if state["配置"] == nil or weakKey == "" then
        return -1
    end
    local weakList = state["配置"]["弱点列表"]
    do
        local i = 0
        while i < #weakList do
            if weakList[i + 1]["弱点键"] == weakKey then
                return i
            end
            i = i + 1
        end
    end
    return -1
end
local function _____53D6_547D_4E2D_5F31_70B9_7D22_5F15(state, attacker, applied, snapshot)
    if state["配置"] == nil then
        return -1
    end
    local weaponWeakKey = ""
    if snapshot ~= nil and snapshot.isNormalAttack == true and snapshot.isPhysicalDamage == true then
        local demand = state["配置"]["弱点伤害需求"] or 0
        state["武器弱点伤害累计"] = state["武器弱点伤害累计"] + applied
        if demand <= 0 or state["武器弱点伤害累计"] >= demand then
            state["武器弱点伤害累计"] = 0
            weaponWeakKey = _____53D6_6B66_5668_5F31_70B9_952E(attacker)
        end
    end
    local weaponIndex = _____67E5_627E_5F31_70B9_7D22_5F15(state, weaponWeakKey)
    if weaponIndex >= 0 then
        return weaponIndex
    end
    local elementWeakKey = _____53D6_5C5E_6027_5F31_70B9_952E(snapshot)
    return _____67E5_627E_5F31_70B9_7D22_5F15(state, elementWeakKey)
end
local function _____53D6_5F31_70B9_51B7_5374_6BEB_79D2(state, weak)
    local ____opt_19 = state["配置"]
    if (____opt_19 and ____opt_19["弱点冷却毫秒"]) ~= nil and state["配置"]["弱点冷却毫秒"] > 0 then
        return state["配置"]["弱点冷却毫秒"]
    end
    return weak["类别"] == "武器" and ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["武器弱点冷却毫秒"] or ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["属性弱点冷却毫秒"]
end
local function _____6263_9664Boss_62A4_76FE(state)
    local shieldValue = _____8BFB_53D6_62A4_76FE_503C(state)
    if shieldValue <= 0 then
        _____5237_65B0Boss_62A4_76FE_6587_672C(state, 0)
        return 0
    end
    local ____53D6_6B63_6570_914D_7F6E_23 = _____53D6_6B63_6570_914D_7F6E
    local ____opt_21 = state["配置"]
    local reduceValue = ____53D6_6B63_6570_914D_7F6E_23(____opt_21 and ____opt_21["护盾命中削减值"], ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["护盾命中削减值"])
    local nextValue = shieldValue - reduceValue
    _____5199_5165_62A4_76FE_503C(state, nextValue)
    _____5237_65B0Boss_62A4_76FE_6587_672C(state, nextValue > 0 and nextValue or 0)
    return nextValue > 0 and nextValue or 0
end
local function _____89E6_53D1Boss_62A4_76FE_7834_788E(state, attacker)
    if state["是否护盾破碎中"] then
        return
    end
    state["是否护盾破碎中"] = true
    _____5199_5165_62A4_76FE_503C(state, 0)
    _____5237_65B0Boss_62A4_76FE_6587_672C(state, 0)
    _____8BBE_7F6EBoss_62A4_76FE_7834_788E_663E_793A(state)
    local ____64AD_653E_5168_5458_672C_5730_97F3_6548_26 = _____64AD_653E_5168_5458_672C_5730_97F3_6548
    local ____opt_24 = state["配置"]
    ____64AD_653E_5168_5458_672C_5730_97F3_6548_26(____opt_24 and ____opt_24["护盾破碎音效路径"] or ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["护盾破碎音效路径"])
    _____53D1_9001_5168_5458_4EFB_52A1_6D88_606F(bj_QUESTMESSAGE_WARNING, ____Boss_5F31_70B9_63D0_793A_6587_672C["护盾破碎提示"])
    local ____temp_27
    if attacker ~= nil and attacker ~= 0 then
        ____temp_27 = attacker
    else
        ____temp_27 = state["Boss单位"]
    end
    local source = ____temp_27
    local ____53D6_6B63_6570_914D_7F6E_30 = _____53D6_6B63_6570_914D_7F6E
    local ____opt_28 = state["配置"]
    local controlDuration = ____53D6_6B63_6570_914D_7F6E_30(____opt_28 and ____opt_28["破盾控制持续秒"], ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["破盾控制持续秒"])
    local ____53D6_975E_8D1F_914D_7F6E_33 = _____53D6_975E_8D1F_914D_7F6E
    local ____opt_31 = state["配置"]
    local controlType = ____53D6_975E_8D1F_914D_7F6E_33(____opt_31 and ____opt_31["破盾控制Buff类型"], ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["破盾控制Buff类型"])
    if controlDuration > 0 then
        _____65BD_52A0_5FEB_901F_63A7_5236Buff(source, state["Boss单位"], controlType, controlDuration)
    end
    local now = getServerTime()
    local ____53D6_6B63_6570_914D_7F6E_36 = _____53D6_6B63_6570_914D_7F6E
    local ____opt_34 = state["配置"]
    local brokenMs = ____53D6_6B63_6570_914D_7F6E_36(____opt_34 and ____opt_34["破碎护盾显示毫秒"], ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["破碎护盾显示毫秒"])
    local ____53D6_6B63_6570_914D_7F6E_39 = _____53D6_6B63_6570_914D_7F6E
    local ____opt_37 = state["配置"]
    local restoreMs = ____53D6_6B63_6570_914D_7F6E_39(____opt_37 and ____opt_37["护盾冷却毫秒"], ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["护盾恢复延迟毫秒"])
    state["护盾破碎切灰截止毫秒"] = now + brokenMs
    state["护盾恢复截止毫秒"] = now + brokenMs + restoreMs
end
local function _____5904_7406Boss_5F31_70B9_547D_4E2D(state, weakIndex, attacker, applied)
    if state["配置"] == nil then
        return
    end
    if weakIndex < 0 or weakIndex >= #state["配置"]["弱点列表"] then
        return
    end
    if state["弱点保护列表"][weakIndex + 1] == true then
        return
    end
    local now = getServerTime()
    local weak = state["配置"]["弱点列表"][weakIndex + 1]
    local isFirstDiscovery = state["弱点已暴露列表"][weakIndex + 1] ~= true
    _____663E_793ABoss_5F31_70B9_771F_5B9E_56FE_6807(state, weakIndex)
    if isFirstDiscovery then
        _____64AD_653E_5168_5458_672C_5730_97F3_6548(state["配置"]["弱点发现音效路径"] or ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["弱点发现音效路径"])
        if state["配置"]["弱点发现提示启用"] ~= false then
            _____53D1_9001_5168_5458_4EFB_52A1_6D88_606F(
                bj_QUESTMESSAGE_UNITACQUIRED,
                _____6784_9020_5F31_70B9_53D1_73B0_63D0_793A(attacker, weak)
            )
        end
    end
    _____8BBE_7F6EBoss_5F31_70B9_547D_4E2D_8868_73B0(state, weakIndex, true)
    state["弱点保护列表"][weakIndex + 1] = true
    state["弱点保护截止毫秒列表"][weakIndex + 1] = now + _____53D6_5F31_70B9_51B7_5374_6BEB_79D2(state, weak)
    state["弱点命中表现截止毫秒列表"][weakIndex + 1] = now + _____53D6_6B63_6570_914D_7F6E(state["配置"]["弱点命中表现毫秒"], ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["弱点命中表现毫秒"])
    local shieldValue = _____6263_9664Boss_62A4_76FE(state)
    _____64AD_653E_5168_5458_672C_5730_97F3_6548(state["配置"]["弱点击中音效路径"] or ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["弱点击中音效路径"])
    if shieldValue <= 0 then
        _____89E6_53D1Boss_62A4_76FE_7834_788E(state, attacker)
    end
    _____786E_4FDDBoss_5F31_70B9_8868_73B0_5237_65B0()
end
local function ____onBoss_5F31_70B9_547D_4E2D_4F24_5BB3_4FEE_6B63(context)
    if context == nil then
        return 0
    end
    if not (context.currentDamage > 0) then
        return context.currentDamage
    end
    local state = _____67E5_627E_76EE_6807Boss_5F31_70B9_72B6_6001(context.target)
    if state == nil or state["配置"] == nil then
        return context.currentDamage
    end
    state["待处理弱点命中索引"] = -1
    if state["是否护盾破碎中"] then
        return context.currentDamage
    end
    local weakIndex = _____53D6_547D_4E2D_5F31_70B9_7D22_5F15(state, context.attacker, context.currentDamage, context)
    if weakIndex < 0 then
        return context.currentDamage
    end
    if state["弱点保护列表"][weakIndex + 1] == true then
        return context.currentDamage
    end
    state["待处理弱点命中索引"] = weakIndex
    local bonus = _____53D6_4F24_5BB3_52A0_6210_914D_7F6E(state["配置"]["弱点命中伤害加成"], ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["弱点命中伤害加成"])
    if not (bonus > 0) then
        return context.currentDamage
    end
    return context.currentDamage * (1 + bonus)
end
local function ____onBoss_5F31_70B9_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    local state = _____67E5_627E_76EE_6807Boss_5F31_70B9_72B6_6001(target)
    if state == nil or state["配置"] == nil then
        return
    end
    local weakIndex = state["待处理弱点命中索引"]
    state["待处理弱点命中索引"] = -1
    if not (applied > 0) then
        return
    end
    if state["是否护盾破碎中"] then
        return
    end
    if weakIndex < 0 then
        return
    end
    _____5904_7406Boss_5F31_70B9_547D_4E2D(state, weakIndex, attacker, applied)
end
local function _____786E_4FDDBoss_5F31_70B9_6700_7EC8_4F24_5BB3_76D1_542C()
    if _____662F_5426_5DF2_6CE8_518CBoss_5F31_70B9_6700_7EC8_4F24_5BB3_76D1_542C then
        return
    end
    _____662F_5426_5DF2_6CE8_518CBoss_5F31_70B9_6700_7EC8_4F24_5BB3_76D1_542C = true
    registerAppliedFinalDamageListener(____onBoss_5F31_70B9_6700_7EC8_4F24_5BB3)
end
local function _____786E_4FDDBoss_5F31_70B9_4F24_5BB3_4FEE_6B63()
    if _____662F_5426_5DF2_6CE8_518CBoss_5F31_70B9_4F24_5BB3_4FEE_6B63 then
        return
    end
    _____662F_5426_5DF2_6CE8_518CBoss_5F31_70B9_4F24_5BB3_4FEE_6B63 = true
    registerDamageModifier(____onBoss_5F31_70B9_547D_4E2D_4F24_5BB3_4FEE_6B63, 30)
end
local function ____onBoss_7834_76FE_4F24_5BB3_4FEE_6B63(context)
    if context == nil then
        return 0
    end
    if not (context.currentDamage > 0) then
        return context.currentDamage
    end
    local state = _____67E5_627E_76EE_6807Boss_5F31_70B9_72B6_6001(context.target)
    if state == nil or state["配置"] == nil then
        return context.currentDamage
    end
    if not state["是否护盾破碎中"] then
        return context.currentDamage
    end
    local multiplier = _____53D6_6709_6548_500D_7387_914D_7F6E(state["配置"]["破盾伤害倍率"], ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["破盾伤害倍率"])
    return context.currentDamage * multiplier
end
local function _____786E_4FDDBoss_7834_76FE_4F24_5BB3_4FEE_6B63()
    if _____662F_5426_5DF2_6CE8_518CBoss_7834_76FE_4F24_5BB3_4FEE_6B63 then
        return
    end
    _____662F_5426_5DF2_6CE8_518CBoss_7834_76FE_4F24_5BB3_4FEE_6B63 = true
    registerDamageModifier(____onBoss_7834_76FE_4F24_5BB3_4FEE_6B63, 25)
end
____exports["注册Boss弱点伤害结算"] = function(state)
    if state["是否已结束"] or state["是否伤害结算已注册"] then
        return
    end
    if not state["是否弱点已注册"] then
        return
    end
    _____9884_70EDBoss_5F31_70B9_53CD_9988_97F3_6548(state)
    _____786E_4FDDBoss_5F31_70B9_4F24_5BB3_4FEE_6B63()
    _____786E_4FDDBoss_7834_76FE_4F24_5BB3_4FEE_6B63()
    _____786E_4FDDBoss_5F31_70B9_6700_7EC8_4F24_5BB3_76D1_542C()
    state["是否伤害结算已注册"] = true
end
____exports["注销Boss弱点伤害结算"] = function(state)
    if not state["是否伤害结算已注册"] then
        return
    end
    state["是否伤害结算已注册"] = false
    state["是否护盾破碎中"] = false
    state["护盾破碎切灰截止毫秒"] = 0
    state["护盾恢复截止毫秒"] = 0
end
return ____exports
