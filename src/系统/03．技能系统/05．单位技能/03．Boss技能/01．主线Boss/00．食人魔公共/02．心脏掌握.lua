--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____6781_5750_6807X = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标Y"]
local _____4E24_70B9_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["两点角度"]
local ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807 = ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236["执行战斗自身传送到坐标"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____01_FF0E_63A7_5236_4E0EBuff["开始硬直"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411 = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["立即设置单位朝向"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.02．数值与表现配置")
local _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["沙漠食人魔技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.02．数值与表现配置")
local _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["杀戮食人魔技能配置"]
local ____08_FF0E_98DF_4EBA_9B54 = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.08．食人魔")
local _____98DF_4EBA_9B54BuffID = ____08_FF0E_98DF_4EBA_9B54["食人魔BuffID"]
local ____03_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.00．食人魔公共.03．台词播放")
local _____64AD_653E_98DF_4EBA_9B54_516C_5171_53F0_8BCD = ____03_FF0E_53F0_8BCD_64AD_653E["播放食人魔公共台词"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local globals = require("jass.globals")
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_3["获取Boss技能敌对英雄列表"]
local _____662F_5426_5DF2_767B_8BB0Boss_6280_80FD_6D4B_8BD5_76EE_6807 = ____require_result_3["是否已登记Boss技能测试目标"]
local ____require_result_4 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
local _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = ____require_result_4["取当前有效玩家人数"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
local getGameDifficulty = ____require_result_5.getGameDifficulty
local getServerTime = ____require_result_5.getServerTime
local addDelayedCallback = ____require_result_5.addDelayedCallback
local ____require_result_6 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_6.getRegisteredPlayerHero
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____63D0_4EA4_9884_8BA1_7B97BossAOE_6280_80FD_4F24_5BB3 = ____require_result_7["提交预计算BossAOE技能伤害"]
local ____require_result_8 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5927_62DB_541F_5531_6761 = ____require_result_8["显示大招吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_8["关闭吟唱条"]
local ____require_result_9 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_9.EC_CreateEffect
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_10.stringToFourCCSafe
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitTypeId = jass.GetUnitTypeId
local GetOwningPlayer = jass.GetOwningPlayer
local GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
local GetUnitStateJapi = japi.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetUnitName = jass.GetUnitName
local StartSound = jass.StartSound
local IsUnitType = jass.IsUnitType
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____666E_901A_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID = stringToFourCCSafe("N05J")
local _____6740_622E_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID = stringToFourCCSafe("N05K")
local _____5FC3_810F_638C_63E1_72B6_6001_8868 = {}
local _____98DF_4EBA_9B54_5FC3_810F_638C_63E1_5DF2_6CE8_518C = false
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and not IsUnitType(unit, UNIT_TYPE_DEAD) and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
local function _____53D6_53E5_67C4ID(handle)
    return handle ~= nil and handle ~= 0 and GetHandleId(handle) or 0
end
local function _____53D6_5FC3_810F_638C_63E1_914D_7F6E(boss)
    local unitTypeId = GetUnitTypeId(boss)
    if unitTypeId == _____666E_901A_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID then
        return {["配置"] = _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E["心脏掌握"], ["形态名"] = "普通"}
    end
    if unitTypeId == _____6740_622E_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID then
        return {["配置"] = _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["心脏掌握"], ["形态名"] = "杀戮"}
    end
    return nil
end
local function _____83B7_53D6_5FC3_810F_638C_63E1_72B6_6001(boss)
    local bossHid = _____53D6_53E5_67C4ID(boss)
    if bossHid == 0 then
        return nil
    end
    local state = _____5FC3_810F_638C_63E1_72B6_6001_8868[bossHid]
    if state == nil or state["Boss单位"] ~= boss then
        state = {["Boss单位"] = boss, ["冷却结束毫秒"] = 0, ["施法中"] = false}
        _____5FC3_810F_638C_63E1_72B6_6001_8868[bossHid] = state
    end
    return state
end
local function _____662F_6CE8_518C_73A9_5BB6_82F1_96C4(unit)
    if not _____5355_4F4D_5B58_6D3B(unit) then
        return false
    end
    local owner = GetOwningPlayer(unit)
    return owner ~= nil and owner ~= 0 and getRegisteredPlayerHero(owner) == unit or _____662F_5426_5DF2_767B_8BB0Boss_6280_80FD_6D4B_8BD5_76EE_6807(unit)
end
local function _____521B_5EFA_6BCF_79D2_52A8_4F5C_91CD_64AD_65F6_70B9(_____6301_7EED_79D2, _____95F4_9694_79D2)
    local result = {}
    if not (_____95F4_9694_79D2 > 0) then
        return result
    end
    do
        local _____79D2_6570 = _____95F4_9694_79D2
        while _____79D2_6570 < _____6301_7EED_79D2 do
            result[#result + 1] = _____79D2_6570
            _____79D2_6570 = _____79D2_6570 + _____95F4_9694_79D2
        end
    end
    return result
end
local function _____77AC_79FB_5230_76EE_6807_80CC_540E(boss, target, cfg)
    local targetX = GetUnitX(target)
    local targetY = GetUnitY(target)
    local behindAngle = GetUnitFacing(target) + 180
    local behindX = _____6781_5750_6807X(targetX, behindAngle, cfg["瞬移距离"])
    local behindY = _____6781_5750_6807Y(targetY, behindAngle, cfg["瞬移距离"])
    local teleported = _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807(boss, behindX, behindY)
    if teleported then
        _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(
            boss,
            _____4E24_70B9_89D2_5EA6(behindX, behindY, targetX, targetY)
        )
    end
    return teleported
end
local function _____5217_8868_5305_542B_5355_4F4D(list, unit)
    do
        local i = 0
        while i < #list do
            if list[i + 1] == unit then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function ____on_5FC3_810F_638C_63E1_7B2C_4E8C_6BB5_9884_8B66(variable)
    local data = variable
    if data == nil or not _____5355_4F4D_5B58_6D3B(data["目标单位"]) then
        return
    end
    EC_CreateEffect(
        data["配置"]["第二段预警特效"],
        GetUnitX(data["目标单位"]),
        GetUnitY(data["目标单位"]),
        0,
        270,
        1.5,
        1,
        1
    )
    debugLogForce(
        "食人魔-心脏掌握",
        "第二段预警特效",
        "形态=",
        data["形态名"],
        "targetHid=",
        _____53D6_53E5_67C4ID(data["目标单位"])
    )
end
local function ____on_5FC3_810F_638C_63E1_7ED3_7B97(variable)
    local data = variable
    if data == nil then
        return
    end
    _____5173_95ED_541F_5531_6761("大招")
    data["状态"]["施法中"] = false
    if not _____5355_4F4D_5B58_6D3B(data["目标单位"]) then
        debugLogForce(
            "食人魔-心脏掌握",
            "斩杀结算跳过：目标已失效",
            "形态=",
            data["形态名"],
            "bossHid=",
            _____53D6_53E5_67C4ID(data["Boss单位"]),
            "targetHid=",
            _____53D6_53E5_67C4ID(data["目标单位"])
        )
        return
    end
    if not _____5355_4F4D_5B58_6D3B(data["Boss单位"]) then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(data["目标单位"], _____98DF_4EBA_9B54BuffID["心脏掌握"])
        debugLogForce(
            "食人魔-心脏掌握",
            "斩杀结算跳过：Boss已失效",
            "形态=",
            data["形态名"],
            "bossHid=",
            _____53D6_53E5_67C4ID(data["Boss单位"]),
            "targetHid=",
            _____53D6_53E5_67C4ID(data["目标单位"])
        )
        return
    end
    local boss = data["Boss单位"]
    local target = data["目标单位"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local participants = {target}
    local radiusSquared = data["配置"]["分摊范围"] * data["配置"]["分摊范围"]
    local targetX = GetUnitX(target)
    local targetY = GetUnitY(target)
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_5B58_6D3B(hero) or _____5217_8868_5305_542B_5355_4F4D(participants, hero) then
                    goto __continue29
                end
                local dx = GetUnitX(hero) - targetX
                local dy = GetUnitY(hero) - targetY
                if dx * dx + dy * dy <= radiusSquared then
                    participants[#participants + 1] = hero
                end
            end
            ::__continue29::
            i = i + 1
        end
    end
    local currentLife = GetUnitState(target, UNIT_STATE_LIFE)
    local totalDamage = currentLife * data["配置"]["当前生命伤害比例"]
    local sharedDamage = totalDamage / #participants
    EC_CreateEffect(
        data["配置"]["结算特效"],
        targetX,
        targetY,
        0,
        270,
        2,
        1,
        1.5
    )
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(target, _____98DF_4EBA_9B54BuffID["心脏掌握"])
    do
        local i = 0
        while i < #participants do
            _____63D0_4EA4_9884_8BA1_7B97BossAOE_6280_80FD_4F24_5BB3({
                ["来源"] = boss,
                ["目标"] = participants[i + 1],
                ["伤害"] = sharedDamage,
                attack = false,
                ranged = false,
                attackType = ATTACK_TYPE_NORMAL,
                ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
                weaponType = WEAPON_TYPE_WHOKNOWS,
                ["标签"] = data["形态名"] .. "食人魔·心脏掌握"
            })
            i = i + 1
        end
    end
    if not _____5355_4F4D_5B58_6D3B(target) then
        _____64AD_653E_98DF_4EBA_9B54_516C_5171_53F0_8BCD(
            boss,
            "心脏掌握斩杀",
            GetUnitName(target)
        )
    end
    debugLogForce(
        "食人魔-心脏掌握",
        "斩杀结算完成",
        "形态=",
        data["形态名"],
        "bossHid=",
        _____53D6_53E5_67C4ID(boss),
        "targetHid=",
        _____53D6_53E5_67C4ID(target),
        "participantCount=",
        #participants,
        "currentLifeBefore=",
        currentLife,
        "totalDamage=",
        totalDamage,
        "sharedDamage=",
        sharedDamage
    )
end
local function _____5C1D_8BD5_89E6_53D1_5FC3_810F_638C_63E1(boss, target)
    if not _____662F_6CE8_518C_73A9_5BB6_82F1_96C4(target) then
        return
    end
    local info = _____53D6_5FC3_810F_638C_63E1_914D_7F6E(boss)
    local state = _____83B7_53D6_5FC3_810F_638C_63E1_72B6_6001(boss)
    if info == nil or state == nil then
        return
    end
    local now = getServerTime()
    if state["施法中"] or now < state["冷却结束毫秒"] then
        return
    end
    local difficulty = getGameDifficulty() > 0 and getGameDifficulty() or 1
    local threshold = info["配置"]["基础斩杀线比例"] + info["配置"]["每层难度斩杀线比例"] * difficulty
    if _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570() <= 1 then
        threshold = threshold * info["配置"]["单人斩杀线倍率"]
    end
    local currentLife = GetUnitState(target, UNIT_STATE_LIFE)
    local maxLife = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE)
    if not (maxLife > 0) or currentLife > maxLife * threshold then
        return
    end
    state["冷却结束毫秒"] = now + info["配置"]["冷却秒"] * 1000
    state["施法中"] = true
    local teleportSuccess = _____77AC_79FB_5230_76EE_6807_80CC_540E(boss, target, info["配置"])
    _____5F00_59CB_786C_76F4(target, info["配置"]["预警秒"])
    _____5F00_59CB_786C_76F4(boss, info["配置"]["预警秒"])
    registerManualBuff(
        target,
        _____98DF_4EBA_9B54BuffID["心脏掌握"],
        info["配置"]["预警秒"],
        1,
        {sourceUnit = boss, sourceName = info["形态名"] .. "食人魔-心脏掌握"}
    )
    EC_CreateEffect(
        info["配置"]["第一段预警特效"],
        GetUnitX(target),
        GetUnitY(target),
        0,
        270,
        1.5,
        1,
        2
    )
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({
        ["单位"] = boss,
        ["动画编号"] = info["配置"]["动作编号"],
        ["持续秒"] = info["配置"]["预警秒"],
        ["重播时点秒列表"] = _____521B_5EFA_6BCF_79D2_52A8_4F5C_91CD_64AD_65F6_70B9(info["配置"]["预警秒"], info["配置"]["动作重播间隔秒"]),
        ["恢复动画编号"] = 0
    })
    _____663E_793A_5927_62DB_541F_5531_6761({
        ["通道"] = "大招",
        ["总时长"] = info["配置"]["预警秒"],
        ["颜色ID"] = info["配置"]["吟唱条颜色ID"],
        ["标题文本"] = info["配置"]["吟唱条标题文本"],
        ["提示文本"] = (info["形态名"] .. "食人魔") .. info["配置"]["吟唱条提示文本"]
    })
    local _____97F3_6548_53E5_67C4 = globals[info["配置"]["音效全局变量名"]]
    if _____97F3_6548_53E5_67C4 ~= nil and _____97F3_6548_53E5_67C4 ~= 0 then
        StartSound(_____97F3_6548_53E5_67C4)
    end
    _____64AD_653E_98DF_4EBA_9B54_516C_5171_53F0_8BCD(
        boss,
        "心脏掌握",
        GetUnitName(target)
    )
    local data = {
        ["Boss单位"] = boss,
        ["目标单位"] = target,
        ["状态"] = state,
        ["配置"] = info["配置"],
        ["形态名"] = info["形态名"]
    }
    local secondWarningCallbackId = addDelayedCallback(info["配置"]["第二段预警秒"] * 1000, ____on_5FC3_810F_638C_63E1_7B2C_4E8C_6BB5_9884_8B66, data)
    local resolveCallbackId = addDelayedCallback(info["配置"]["预警秒"] * 1000, ____on_5FC3_810F_638C_63E1_7ED3_7B97, data)
    debugLogForce(
        "食人魔-心脏掌握",
        "触发预警表现",
        "形态=",
        info["形态名"],
        "bossHid=",
        _____53D6_53E5_67C4ID(boss),
        "targetHid=",
        _____53D6_53E5_67C4ID(target),
        "difficulty=",
        difficulty,
        "threshold=",
        threshold,
        "currentLife=",
        currentLife,
        "maxLife=",
        maxLife,
        "teleportSuccess=",
        teleportSuccess,
        "targetHardStunSeconds=",
        info["配置"]["预警秒"],
        "bossHardStunSeconds=",
        info["配置"]["预警秒"],
        "animationIndex=",
        info["配置"]["动作编号"],
        "actionReplayIntervalSeconds=",
        info["配置"]["动作重播间隔秒"],
        "secondWarningCallbackId=",
        secondWarningCallbackId,
        "resolveCallbackId=",
        resolveCallbackId
    )
end
local function ____on_98DF_4EBA_9B54_9020_6210_6700_7EC8_4F24_5BB3(target, attacker, applied, _snapshot)
    if not (applied > 0) or not _____5355_4F4D_5B58_6D3B(attacker) then
        return
    end
    _____5C1D_8BD5_89E6_53D1_5FC3_810F_638C_63E1(attacker, target)
end
____exports["注册食人魔心脏掌握"] = function()
    if _____98DF_4EBA_9B54_5FC3_810F_638C_63E1_5DF2_6CE8_518C then
        return
    end
    _____98DF_4EBA_9B54_5FC3_810F_638C_63E1_5DF2_6CE8_518C = true
    registerAppliedFinalDamageListener(____on_98DF_4EBA_9B54_9020_6210_6700_7EC8_4F24_5BB3)
end
return ____exports
