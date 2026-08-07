local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____11_FF0E_6761_4EF6_4F24_5BB3_4FEE_6B63 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.11．条件伤害修正")
local _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63 = ____11_FF0E_6761_4EF6_4F24_5BB3_4FEE_6B63["创建条件伤害修正"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____63D0_4EA4_9884_8BA1_7B97BossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["提交预计算BossAOE技能伤害"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.00．配置")
local _____6740_622E_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["杀戮食人魔单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.01．运行时上下文")
local _____83B7_53D6_5168_90E8_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部杀戮食人魔上下文"]
local _____83B7_53D6_6216_521B_5EFA_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建杀戮食人魔上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.02．数值与表现配置")
local _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["杀戮食人魔技能配置"]
local ____08_FF0E_98DF_4EBA_9B54 = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.08．食人魔")
local _____98DF_4EBA_9B54BuffID = ____08_FF0E_98DF_4EBA_9B54["食人魔BuffID"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____6781_5750_6807X = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标Y"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local ____require_result_2 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_2["获取Boss技能敌对英雄列表"]
local _____662F_5426_5DF2_767B_8BB0Boss_6280_80FD_6D4B_8BD5_76EE_6807 = ____require_result_2["是否已登记Boss技能测试目标"]
local ____require_result_3 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
local _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = ____require_result_3["取当前有效玩家人数"]
local ____require_result_4 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_4.getRegisteredPlayerHero
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____6E05_9664_5355_4F4D_63A7_5236_7C7B_8D1F_9762Buff = ____require_result_5["清除单位控制类负面Buff"]
local _____6E05_9664_5355_4F4D_63A7_5236Buff_5408_96C6 = ____require_result_5["清除单位控制Buff合集"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_6["开始硬直"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____require_result_7["播放限时单位动画"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807 = ____require_result_8["执行战斗自身传送到坐标"]
local ____require_result_9 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_9["显示常规技能吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_9["关闭吟唱条"]
local ____require_result_10 = require("系统.00．核心系统.05．中心计时器")
local getGameDifficulty = ____require_result_10.getGameDifficulty
local getServerTime = ____require_result_10.getServerTime
local addDelayedCallback = ____require_result_10.addDelayedCallback
local ____require_result_11 = require("平台扩展API动作")
local _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4 = ____require_result_11["技能_设置技能冷却时间"]
local ____require_result_12 = require("平台扩展API取值")
local _____6280_80FD__83B7_53D6_6280_80FD_6700_5927_51B7_5374_65F6_95F4 = ____require_result_12["技能_获取技能最大冷却时间"]
local ____require_result_13 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_13.EC_CreateEffect
local ____require_result_14 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_14.stringToFourCCSafe
local ____require_result_15 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_15.debugLogForce
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetOwningPlayer = jass.GetOwningPlayer
local GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local IsUnitType = jass.IsUnitType
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____6740_622E_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6740_622E_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____666E_901A_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID = stringToFourCCSafe("N05J")
local _____8840_6D77_7EDE_6740_6280_80FDID = stringToFourCCSafe(_____6740_622E_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["技能ID"]["血海绞杀"])
local _____6740_622E_98DF_4EBA_9B54_88AB_52A8_5DF2_6CE8_518C = false
local _____98DF_4EBA_9B54_5FC3_810F_638C_63E1_5DF2_6CE8_518C = false
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and not IsUnitType(unit, UNIT_TYPE_DEAD) and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
local function _____53D6_53E5_67C4ID(handle)
    return handle ~= nil and handle ~= 0 and GetHandleId(handle) or 0
end
local function _____66F4_65B0_75BC_75DB_590D_4EC7Buff(context)
    local count = #context["增伤层列表"]
    if count <= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["Boss单位"], _____98DF_4EBA_9B54BuffID["疼痛复仇"])
        return
    end
    local latest = 0
    do
        local i = 0
        while i < #context["增伤层列表"] do
            local expire = context["增伤层列表"][i + 1]["到期毫秒"]
            if expire > latest then
                latest = expire
            end
            i = i + 1
        end
    end
    local remaining = (latest - getServerTime()) / 1000
    registerManualBuff(
        context["Boss单位"],
        _____98DF_4EBA_9B54BuffID["疼痛复仇"],
        remaining > 0 and remaining or 0.1,
        count * _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["疼痛复仇"]["增伤比例"],
        {stack = count, sourceUnit = context["Boss单位"], sourceName = "杀戮食人魔-疼痛复仇"}
    )
end
local function ____on_75BC_75DB_590D_4EC7_589E_4F24_5C42_5230_671F(variable)
    local data = variable
    if data == nil then
        return
    end
    local list = data["上下文"]["增伤层列表"]
    do
        local i = 0
        while i < #list do
            do
                if list[i + 1].ID ~= data["层ID"] then
                    goto __continue12
                end
                __TS__ArraySplice(list, i, 1)
                break
            end
            ::__continue12::
            i = i + 1
        end
    end
    _____66F4_65B0_75BC_75DB_590D_4EC7Buff(data["上下文"])
end
local function _____6DFB_52A0_75BC_75DB_590D_4EC7_589E_4F24_5C42(context)
    local cfg = _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["疼痛复仇"]
    local ____context_16, _____4E0B_4E00_589E_4F24_5C42ID_17 = context, "下一增伤层ID"
    local ____context__4E0B_4E00_589E_4F24_5C42ID_18 = ____context_16[_____4E0B_4E00_589E_4F24_5C42ID_17]
    ____context_16[_____4E0B_4E00_589E_4F24_5C42ID_17] = ____context__4E0B_4E00_589E_4F24_5C42ID_18 + 1
    local id = ____context__4E0B_4E00_589E_4F24_5C42ID_18
    local ____context__589E_4F24_5C42_5217_8868_19 = context["增伤层列表"]
    ____context__589E_4F24_5C42_5217_8868_19[#____context__589E_4F24_5C42_5217_8868_19 + 1] = {
        ID = id,
        ["到期毫秒"] = getServerTime() + cfg["增伤持续秒"] * 1000
    }
    _____66F4_65B0_75BC_75DB_590D_4EC7Buff(context)
    addDelayedCallback(cfg["增伤持续秒"] * 1000, ____on_75BC_75DB_590D_4EC7_589E_4F24_5C42_5230_671F, {["上下文"] = context, ["层ID"] = id})
end
local function _____89E6_53D1_75BC_75DB_590D_4EC7_89E3_63A7(context)
    local boss = context["Boss单位"]
    _____6E05_9664_5355_4F4D_63A7_5236_7C7B_8D1F_9762Buff(boss, false)
    _____6E05_9664_5355_4F4D_63A7_5236Buff_5408_96C6(boss)
    local configuredMaxCooldown = _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["血海绞杀"]["冷却秒"]
    local currentMaxCooldown = _____6280_80FD__83B7_53D6_6280_80FD_6700_5927_51B7_5374_65F6_95F4(boss, _____8840_6D77_7EDE_6740_6280_80FDID) or configuredMaxCooldown
    _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(boss, _____8840_6D77_7EDE_6740_6280_80FDID, 0, currentMaxCooldown)
    EC_CreateEffect(
        _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["疼痛复仇"]["解控特效"],
        GetUnitX(boss),
        GetUnitY(boss),
        0,
        270,
        2.5,
        1,
        1
    )
end
local function ____on_6740_622E_98DF_4EBA_9B54_53D7_5230_6700_7EC8_4F24_5BB3(target, _attacker, applied, _snapshot)
    if not (applied > 0) or not _____5355_4F4D_5B58_6D3B(target) or GetUnitTypeId(target) ~= _____6740_622E_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587(target)
    if context == nil then
        return
    end
    local cfg = _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["疼痛复仇"]
    context["增伤累计伤害"] = context["增伤累计伤害"] + applied
    while context["增伤累计伤害"] >= cfg["增伤触发伤害"] do
        context["增伤累计伤害"] = context["增伤累计伤害"] - cfg["增伤触发伤害"]
        _____6DFB_52A0_75BC_75DB_590D_4EC7_589E_4F24_5C42(context)
    end
    context["解控累计伤害"] = context["解控累计伤害"] + applied
    while context["解控累计伤害"] >= cfg["解控触发伤害"] do
        context["解控累计伤害"] = context["解控累计伤害"] - cfg["解控触发伤害"]
        _____89E6_53D1_75BC_75DB_590D_4EC7_89E3_63A7(context)
    end
end
local function _____75BC_75DB_590D_4EC7_4F24_5BB3_6761_4EF6(damageContext)
    return damageContext ~= nil and _____5355_4F4D_5B58_6D3B(damageContext.attacker) and GetUnitTypeId(damageContext.attacker) == _____6740_622E_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID
end
local function _____75BC_75DB_590D_4EC7_4F24_5BB3_4FEE_6B63(damageContext)
    local list = _____83B7_53D6_5168_90E8_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #list do
            do
                local context = list[i + 1]
                if context["Boss单位"] ~= damageContext.attacker then
                    goto __continue24
                end
                local _____4FEE_6B63_540E_4F24_5BB3 = damageContext.currentDamage * (1 + #context["增伤层列表"] * _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["疼痛复仇"]["增伤比例"])
                return _____4FEE_6B63_540E_4F24_5BB3
            end
            ::__continue24::
            i = i + 1
        end
    end
    return damageContext.currentDamage
end
local function _____662F_6CE8_518C_73A9_5BB6_82F1_96C4(unit)
    if not _____5355_4F4D_5B58_6D3B(unit) then
        return false
    end
    local owner = GetOwningPlayer(unit)
    return owner ~= nil and owner ~= 0 and getRegisteredPlayerHero(owner) == unit or _____662F_5426_5DF2_767B_8BB0Boss_6280_80FD_6D4B_8BD5_76EE_6807(unit)
end
local function _____53D6_5FC3_810F_638C_63E1_52A8_4F5C_7F16_53F7(boss)
    local cfg = _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["心脏掌握"]
    return GetUnitTypeId(boss) == _____666E_901A_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID and cfg["普通状态动作编号"] or cfg["动作编号"]
end
local function _____751F_6210_5FC3_810F_638C_63E1_52A8_4F5C_91CD_64AD_65F6_70B9(_____6301_7EED_79D2, _____95F4_9694_79D2)
    local result = {}
    if not (_____95F4_9694_79D2 > 0) then
        return result
    end
    do
        local _____65F6_70B9_79D2 = _____95F4_9694_79D2
        while _____65F6_70B9_79D2 < _____6301_7EED_79D2 do
            result[#result + 1] = _____65F6_70B9_79D2
            _____65F6_70B9_79D2 = _____65F6_70B9_79D2 + _____95F4_9694_79D2
        end
    end
    return result
end
local function _____6E05_7406_5FC3_810F_638C_63E1_8868_73B0(data)
    if data["已结束"] then
        return
    end
    data["已结束"] = true
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(data["目标单位"], _____98DF_4EBA_9B54BuffID["心脏掌握"])
    _____5173_95ED_541F_5531_6761("常规技能")
    if _____5355_4F4D_5B58_6D3B(data["上下文"]["Boss单位"]) then
        SetUnitAnimationByIndex(data["上下文"]["Boss单位"], 1)
    end
end
local function ____on_5FC3_810F_638C_63E1_4E0A_4E0B_6587_6E05_7406(variable)
    local data = variable
    if data == nil then
        return
    end
    _____6E05_7406_5FC3_810F_638C_63E1_8868_73B0(data)
end
local function ____on_5FC3_810F_638C_63E1_7B2C_4E8C_6BB5_9884_8B66(variable)
    local data = variable
    if data == nil or data["已结束"] then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(data["上下文"]["Boss单位"]) or not _____5355_4F4D_5B58_6D3B(data["目标单位"]) then
        _____6E05_7406_5FC3_810F_638C_63E1_8868_73B0(data)
        debugLogForce(
            "杀戮食人魔-心脏掌握",
            "第二段预警跳过：Boss或目标已失效",
            "bossHid=",
            _____53D6_53E5_67C4ID(data["上下文"]["Boss单位"]),
            "targetHid=",
            _____53D6_53E5_67C4ID(data["目标单位"])
        )
        return
    end
    local cfg = _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["心脏掌握"]
    EC_CreateEffect(
        cfg["第二段预警特效"],
        GetUnitX(data["目标单位"]),
        GetUnitY(data["目标单位"]),
        0,
        270,
        1.5,
        1,
        1
    )
    debugLogForce(
        "杀戮食人魔-心脏掌握",
        "第二段预警特效",
        "targetHid=",
        _____53D6_53E5_67C4ID(data["目标单位"])
    )
end
local function ____on_5FC3_810F_638C_63E1_7ED3_7B97(variable)
    local data = variable
    if data == nil or data["已结束"] then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(data["上下文"]["Boss单位"]) or not _____5355_4F4D_5B58_6D3B(data["目标单位"]) then
        _____6E05_7406_5FC3_810F_638C_63E1_8868_73B0(data)
        debugLogForce(
            "杀戮食人魔-心脏掌握",
            "斩杀结算跳过：Boss或目标已失效",
            "bossHid=",
            _____53D6_53E5_67C4ID(data["上下文"]["Boss单位"]),
            "targetHid=",
            _____53D6_53E5_67C4ID(data["目标单位"])
        )
        return
    end
    local boss = data["上下文"]["Boss单位"]
    local target = data["目标单位"]
    local cfg = _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["心脏掌握"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local participants = {}
    local radiusSquared = cfg["分摊范围"] * cfg["分摊范围"]
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_5B58_6D3B(hero) then
                    goto __continue45
                end
                local dx = GetUnitX(hero) - GetUnitX(target)
                local dy = GetUnitY(hero) - GetUnitY(target)
                if dx * dx + dy * dy <= radiusSquared then
                    participants[#participants + 1] = hero
                end
            end
            ::__continue45::
            i = i + 1
        end
    end
    if #participants == 0 then
        participants[#participants + 1] = target
    end
    local totalDamage = GetUnitState(target, UNIT_STATE_LIFE) * cfg["当前生命伤害比例"]
    local sharedDamage = totalDamage / #participants
    EC_CreateEffect(
        cfg["结算特效"],
        GetUnitX(target),
        GetUnitY(target),
        0,
        270,
        2,
        1,
        1.5
    )
    _____6E05_7406_5FC3_810F_638C_63E1_8868_73B0(data)
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
                ["标签"] = "杀戮食人魔·心脏掌握"
            })
            i = i + 1
        end
    end
    debugLogForce(
        "杀戮食人魔-心脏掌握",
        "斩杀结算完成",
        "bossHid=",
        _____53D6_53E5_67C4ID(boss),
        "targetHid=",
        _____53D6_53E5_67C4ID(target),
        "participantCount=",
        #participants,
        "currentLifeBefore=",
        totalDamage / cfg["当前生命伤害比例"],
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
    local context = _____83B7_53D6_6216_521B_5EFA_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587(boss)
    if context == nil then
        return
    end
    local _____5F53_524D_6BEB_79D2 = getServerTime()
    if _____5F53_524D_6BEB_79D2 < context["心脏掌握冷却结束毫秒"] then
        return
    end
    local cfg = _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["心脏掌握"]
    local difficulty = getGameDifficulty() > 0 and getGameDifficulty() or 1
    local threshold = cfg["基础斩杀线比例"] + cfg["每层难度斩杀线比例"] * difficulty
    if _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570() <= 1 then
        threshold = threshold * cfg["单人斩杀线倍率"]
    end
    local _____5F53_524D_751F_547D = GetUnitState(target, UNIT_STATE_LIFE)
    local _____6700_5927_751F_547D = GetUnitState(target, UNIT_STATE_MAX_LIFE)
    if _____5F53_524D_751F_547D > _____6700_5927_751F_547D * threshold then
        return
    end
    context["心脏掌握冷却结束毫秒"] = _____5F53_524D_6BEB_79D2 + cfg["冷却秒"] * 1000
    local data = {["上下文"] = context, ["目标单位"] = target, ["已结束"] = false}
    local _____76EE_6807_80CC_540E_89D2_5EA6 = GetUnitFacing(target) + 180
    local teleportSuccess = _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807(
        boss,
        _____6781_5750_6807X(
            GetUnitX(target),
            _____76EE_6807_80CC_540E_89D2_5EA6,
            cfg["瞬移距离"]
        ),
        _____6781_5750_6807Y(
            GetUnitY(target),
            _____76EE_6807_80CC_540E_89D2_5EA6,
            cfg["瞬移距离"]
        )
    )
    registerManualBuff(
        target,
        _____98DF_4EBA_9B54BuffID["心脏掌握"],
        cfg["预警秒"],
        1,
        {sourceUnit = boss, sourceName = "杀戮食人魔-心脏掌握"}
    )
    EC_CreateEffect(
        cfg["第一段预警特效"],
        GetUnitX(target),
        GetUnitY(target),
        0,
        270,
        1.5,
        1,
        2
    )
    _____5F00_59CB_786C_76F4(target, cfg["预警秒"])
    _____5F00_59CB_786C_76F4(boss, cfg["预警秒"])
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({
        ["通道"] = "常规技能",
        ["总时长"] = cfg["预警秒"],
        ["颜色ID"] = cfg["吟唱条颜色ID"],
        ["标题文本"] = cfg["吟唱条标题文本"],
        ["提示文本"] = cfg["吟唱条提示文本"]
    })
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({
        ["单位"] = boss,
        ["动画编号"] = _____53D6_5FC3_810F_638C_63E1_52A8_4F5C_7F16_53F7(boss),
        ["持续秒"] = cfg["预警秒"],
        ["重播时点秒列表"] = _____751F_6210_5FC3_810F_638C_63E1_52A8_4F5C_91CD_64AD_65F6_70B9(cfg["预警秒"], cfg["动作重播间隔秒"]),
        ["恢复动画编号"] = 1
    })
    local _____7B2C_4E8C_6BB5_56DE_8C03ID = addDelayedCallback(cfg["第二段预警秒"] * 1000, ____on_5FC3_810F_638C_63E1_7B2C_4E8C_6BB5_9884_8B66, data)
    local _____7ED3_7B97_56DE_8C03ID = addDelayedCallback(cfg["预警秒"] * 1000, ____on_5FC3_810F_638C_63E1_7ED3_7B97, data)
    local ____self_20 = context["清理"]
    ____self_20["登记清理"](____self_20, "杀戮食人魔-心脏掌握表现", ____on_5FC3_810F_638C_63E1_4E0A_4E0B_6587_6E05_7406, data)
    local ____self_21 = context["清理"]
    ____self_21["登记延迟回调"](____self_21, "杀戮食人魔-心脏掌握第二段预警", _____7B2C_4E8C_6BB5_56DE_8C03ID)
    local ____self_22 = context["清理"]
    ____self_22["登记延迟回调"](____self_22, "杀戮食人魔-心脏掌握结算", _____7ED3_7B97_56DE_8C03ID)
    debugLogForce(
        "杀戮食人魔-心脏掌握",
        "触发预警表现",
        "bossHid=",
        _____53D6_53E5_67C4ID(boss),
        "targetHid=",
        _____53D6_53E5_67C4ID(target),
        "difficulty=",
        difficulty,
        "threshold=",
        threshold,
        "currentLife=",
        _____5F53_524D_751F_547D,
        "maxLife=",
        _____6700_5927_751F_547D,
        "teleportSuccess=",
        teleportSuccess,
        "targetHardStunSeconds=",
        cfg["预警秒"],
        "bossHardStunSeconds=",
        cfg["预警秒"],
        "animationIndex=",
        _____53D6_5FC3_810F_638C_63E1_52A8_4F5C_7F16_53F7(boss),
        "actionReplayIntervalSeconds=",
        cfg["动作重播间隔秒"],
        "secondWarningCallbackId=",
        _____7B2C_4E8C_6BB5_56DE_8C03ID,
        "resolveCallbackId=",
        _____7ED3_7B97_56DE_8C03ID
    )
end
local function ____on_98DF_4EBA_9B54_9020_6210_6700_7EC8_4F24_5BB3(target, attacker, applied, _snapshot)
    if not (applied > 0) or not _____5355_4F4D_5B58_6D3B(attacker) then
        return
    end
    local attackerTypeId = GetUnitTypeId(attacker)
    if attackerTypeId ~= _____6740_622E_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID and attackerTypeId ~= _____666E_901A_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID then
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
____exports["注册杀戮食人魔被动效果"] = function()
    if _____6740_622E_98DF_4EBA_9B54_88AB_52A8_5DF2_6CE8_518C then
        debugLogForce("杀戮食人魔-被动", "重复注册请求已忽略")
        return
    end
    _____6740_622E_98DF_4EBA_9B54_88AB_52A8_5DF2_6CE8_518C = true
    registerAppliedFinalDamageListener(____on_6740_622E_98DF_4EBA_9B54_53D7_5230_6700_7EC8_4F24_5BB3)
    _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63({["名称"] = "杀戮食人魔-疼痛复仇增伤", ["优先级"] = 60, ["条件"] = _____75BC_75DB_590D_4EC7_4F24_5BB3_6761_4EF6, ["修正"] = _____75BC_75DB_590D_4EC7_4F24_5BB3_4FEE_6B63})
end
return ____exports
