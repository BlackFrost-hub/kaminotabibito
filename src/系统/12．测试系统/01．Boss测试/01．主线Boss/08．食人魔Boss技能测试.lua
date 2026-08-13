--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____53D6_53E5_67C4ID, _____786E_4FDD_6D4B_8BD5_82F1_96C4_5B66_4F1A_96F7_9706_4E00_51FB, _____8865_5145_6D4B_8BD5_82F1_96C4_9B54_6CD5, ____on_98DF_4EBA_9B54_5EF6_8FDF_6D4B_8BD5, ____on_75DB_4E4B_675F_7F1A_5EF6_8FDF_6D4B_8BD5, jass, spellHeal, debugLogForce, ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B, UnitAddAbility, GetUnitAbilityLevel, IssueImmediateOrder, UnitDamageTarget, GetPlayerId, GetOwningPlayer, SetUnitPosition, GetUnitState, SetUnitState, SetUnitStateJapi, GetHandleId, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE, UNIT_STATE_MANA, UNIT_STATE_MAX_MANA, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS, _____96F7_9706_4E00_51FB_6280_80FDID, _____6D4B_8BD5_82F1_96C4_6700_5927_9B54_6CD5_503C, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y, _____6700_8FD1_6D4B_8BD5_6B65_5175_4E00, _____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C
function _____53D6_53E5_67C4ID(handle)
    return handle ~= nil and handle ~= 0 and GetHandleId(handle) or 0
end
function _____786E_4FDD_6D4B_8BD5_82F1_96C4_5B66_4F1A_96F7_9706_4E00_51FB(unit)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(unit) then
        return false
    end
    local abilityLevel = GetUnitAbilityLevel(unit, _____96F7_9706_4E00_51FB_6280_80FDID)
    if not (abilityLevel > 0) then
        UnitAddAbility(unit, _____96F7_9706_4E00_51FB_6280_80FDID)
        abilityLevel = GetUnitAbilityLevel(unit, _____96F7_9706_4E00_51FB_6280_80FDID)
    end
    return abilityLevel > 0
end
function _____8865_5145_6D4B_8BD5_82F1_96C4_9B54_6CD5(unit)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(unit) then
        return
    end
    SetUnitStateJapi(unit, UNIT_STATE_MAX_MANA, _____6D4B_8BD5_82F1_96C4_6700_5927_9B54_6CD5_503C)
    SetUnitState(unit, UNIT_STATE_MANA, _____6D4B_8BD5_82F1_96C4_6700_5927_9B54_6CD5_503C)
end
function ____on_98DF_4EBA_9B54_5EF6_8FDF_6D4B_8BD5(variable)
    local data = variable
    if data == nil then
        return
    end
    local ____temp_32
    if data["上下文"]["玩家英雄"] ~= nil then
        ____temp_32 = GetOwningPlayer(data["上下文"]["玩家英雄"])
    else
        ____temp_32 = jass:Player(0)
    end
    local pid = GetPlayerId(____temp_32)
    local ____temp_33
    if data["形态"] == "沙漠" then
        ____temp_33 = data["上下文"]["沙漠食人魔"]
    else
        ____temp_33 = data["上下文"]["杀戮食人魔"]
    end
    local boss = ____temp_33
    if data["操作"] == "啃食完成检查" then
        local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
        local maxMana = GetUnitState(boss, UNIT_STATE_MAX_MANA)
        local lifeBeforePostEatingDamage = GetUnitState(boss, UNIT_STATE_LIFE)
        local manaBeforePostEatingDamage = GetUnitState(boss, UNIT_STATE_MANA)
        local postEatingDamage = UnitDamageTarget(
            data["上下文"]["测试山丘之王"],
            boss,
            1,
            true,
            false,
            ATTACK_TYPE_NORMAL,
            DAMAGE_TYPE_NORMAL,
            WEAPON_TYPE_WHOKNOWS
        )
        debugLogForce(
            "食人魔Boss技能测试",
            "啃食完成时间线检查",
            "form=",
            data["形态"],
            "bossHid=",
            _____53D6_53E5_67C4ID(boss),
            "lifeBeforePostEatingDamage=",
            lifeBeforePostEatingDamage,
            "maxLife=",
            maxLife,
            "manaBeforePostEatingDamage=",
            manaBeforePostEatingDamage,
            "maxMana=",
            maxMana,
            "lifeAfterPostEatingDamage=",
            GetUnitState(boss, UNIT_STATE_LIFE),
            "manaAfterPostEatingDamage=",
            GetUnitState(boss, UNIT_STATE_MANA),
            "postEatingDamageSubmitted=",
            postEatingDamage,
            "expected=",
            "追加伤害前生命魔法满值、冷却已重置、解除暂停和无敌；追加伤害后伤害可正常结算"
        )
        return
    end
    local target = data["上下文"]["测试山丘之王"]
    local secondTarget = data["上下文"]["测试圣骑士"]
    if data["操作"] == "治疗反噬" then
        local targetMaxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE)
        local secondTargetMaxLife = GetUnitState(secondTarget, UNIT_STATE_MAX_LIFE)
        SetUnitState(target, UNIT_STATE_LIFE, targetMaxLife - 5000)
        SetUnitState(secondTarget, UNIT_STATE_LIFE, secondTargetMaxLife - 5000)
        spellHeal(target, target, 5000, false)
        spellHeal(secondTarget, secondTarget, 5000, false)
        return
    end
    if data["操作"] == "风暴之锤结束检查" then
        debugLogForce(
            "食人魔Boss技能测试",
            "风暴之锤结束时间线检查",
            "bossHid=",
            _____53D6_53E5_67C4ID(data["上下文"]["沙漠食人魔"]),
            "specifiedTargetHid=",
            _____53D6_53E5_67C4ID(_____6700_8FD1_6D4B_8BD5_6B65_5175_4E00[pid]),
            "interceptorHid=",
            _____53D6_53E5_67C4ID(_____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C[pid]),
            "specifiedTargetLife=",
            GetUnitState(_____6700_8FD1_6D4B_8BD5_6B65_5175_4E00[pid], UNIT_STATE_LIFE),
            "interceptorLife=",
            GetUnitState(_____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C[pid], UNIT_STATE_LIFE),
            "expected=",
            "5秒生命周期结束后弹幕数据清理；指定目标与非指定拦截目标最多各结算一次"
        )
        return
    end
    if data["操作"] == "雷霆敲打结束检查" then
        debugLogForce(
            "食人魔Boss技能测试",
            "雷霆敲打结束时间线检查",
            "bossHid=",
            _____53D6_53E5_67C4ID(data["上下文"]["沙漠食人魔"]),
            "eastTargetLife=",
            GetUnitState(_____6700_8FD1_6D4B_8BD5_6B65_5175_4E00[pid], UNIT_STATE_LIFE),
            "westTargetLife=",
            GetUnitState(_____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C[pid], UNIT_STATE_LIFE),
            "northTargetLife=",
            GetUnitState(data["上下文"]["测试山丘之王"], UNIT_STATE_LIFE),
            "southTargetLife=",
            GetUnitState(data["上下文"]["测试圣骑士"], UNIT_STATE_LIFE),
            "expected=",
            "全部四轮已发射且最后一轮冲击波生命周期结束；每轮应创建东南西北四枚冲击波并结算减速"
        )
        return
    end
    if data["操作"] == "血海绞杀结束检查" then
        debugLogForce(
            "食人魔Boss技能测试",
            "血海绞杀结束时间线检查",
            "bossHid=",
            _____53D6_53E5_67C4ID(data["上下文"]["杀戮食人魔"]),
            "eastTargetLife=",
            GetUnitState(_____6700_8FD1_6D4B_8BD5_6B65_5175_4E00[pid], UNIT_STATE_LIFE),
            "westTargetLife=",
            GetUnitState(_____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C[pid], UNIT_STATE_LIFE),
            "northTargetLife=",
            GetUnitState(data["上下文"]["测试山丘之王"], UNIT_STATE_LIFE),
            "southTargetLife=",
            GetUnitState(data["上下文"]["测试圣骑士"], UNIT_STATE_LIFE),
            "expected=",
            "施法硬直结束且四方向血海弹幕已发射；命中后造成暗伤并眩晕"
        )
        return
    end
    _____8865_5145_6D4B_8BD5_82F1_96C4_9B54_6CD5(target)
    _____8865_5145_6D4B_8BD5_82F1_96C4_9B54_6CD5(secondTarget)
    local targetHasThunderClap = _____786E_4FDD_6D4B_8BD5_82F1_96C4_5B66_4F1A_96F7_9706_4E00_51FB(target)
    local secondTargetHasThunderClap = _____786E_4FDD_6D4B_8BD5_82F1_96C4_5B66_4F1A_96F7_9706_4E00_51FB(secondTarget)
    local started = targetHasThunderClap and IssueImmediateOrder(target, "thunderclap")
    local secondStarted = secondTargetHasThunderClap and IssueImmediateOrder(secondTarget, "thunderclap")
end
function ____on_75DB_4E4B_675F_7F1A_5EF6_8FDF_6D4B_8BD5(variable)
    local data = variable
    if data == nil then
        return
    end
    local context = data["上下文"]
    local ____temp_34
    if context["玩家英雄"] ~= nil then
        ____temp_34 = GetOwningPlayer(context["玩家英雄"])
    else
        ____temp_34 = jass:Player(0)
    end
    local pid = GetPlayerId(____temp_34)
    local runtime = context["杀戮运行时"]
    local target = runtime["束缚目标"]
    if data["操作"] == "转移伤害" then
        local source = _____6700_8FD1_6D4B_8BD5_6B65_5175_4E00[pid]
        local submitted = UnitDamageTarget(
            source,
            context["杀戮食人魔"],
            1000,
            true,
            false,
            ATTACK_TYPE_NORMAL,
            DAMAGE_TYPE_NORMAL,
            WEAPON_TYPE_WHOKNOWS
        )
        debugLogForce(
            "食人魔Boss技能测试",
            "痛之束缚伤害转移测试",
            "bossHid=",
            _____53D6_53E5_67C4ID(context["杀戮食人魔"]),
            "boundTargetHid=",
            _____53D6_53E5_67C4ID(target),
            "sourceHid=",
            _____53D6_53E5_67C4ID(source),
            "damageStarted=",
            submitted,
            "expected=",
            "目标承受10%强化转移伤害"
        )
        return
    end
    if target ~= nil and target ~= 0 then
        SetUnitPosition(target, _____6D4B_8BD5_4E2D_5FC3X + 1800, _____6D4B_8BD5_4E2D_5FC3Y)
    end
    debugLogForce(
        "食人魔Boss技能测试",
        "痛之束缚距离断链测试",
        "bossHid=",
        _____53D6_53E5_67C4ID(context["杀戮食人魔"]),
        "boundTargetHid=",
        _____53D6_53E5_67C4ID(target),
        "distanceForced=",
        1800,
        "expected=",
        "超过1200码后链接清理"
    )
end
jass = require("jass.common")
local japi = require("jass.japi")
local globals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_0.SelectUnitForPlayerSingle
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_1.StarOther_PanCameraToTimedForPlayer
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_3["应用Boss战启动属性配置"]
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.07．技能入口")
local _____6CE8_518C_6C99_6F20_98DF_4EBA_9B54_6280_80FD_7ED3_6784 = ____require_result_4["注册沙漠食人魔技能结构"]
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.03．食人魔咒")
local _____91CA_653E_6C99_6F20_98DF_4EBA_9B54_5492 = ____require_result_5["释放沙漠食人魔咒"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.04．风暴之锤")
local _____91CA_653E_6C99_6F20_98DF_4EBA_9B54_98CE_66B4_4E4B_9524 = ____require_result_6["释放沙漠食人魔风暴之锤"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.05．雷霆敲打")
local _____91CA_653E_6C99_6F20_98DF_4EBA_9B54_96F7_9706_6572_6253 = ____require_result_7["释放沙漠食人魔雷霆敲打"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.06．雷霆震怒")
local _____91CA_653E_6C99_6F20_98DF_4EBA_9B54_96F7_9706_9707_6012 = ____require_result_8["释放沙漠食人魔雷霆震怒"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.02．数值与表现配置")
local _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E = ____require_result_9["沙漠食人魔技能配置"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.08．技能入口")
local _____6CE8_518C_6740_622E_98DF_4EBA_9B54_6280_80FD_7ED3_6784 = ____require_result_10["注册杀戮食人魔技能结构"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587 = ____require_result_11["获取或创建杀戮食人魔上下文"]
local _____6E05_7406_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587 = ____require_result_11["清理杀戮食人魔上下文"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.04．深渊魔咒")
local _____91CA_653E_6740_622E_98DF_4EBA_9B54_6DF1_6E0A_9B54_5492 = ____require_result_12["释放杀戮食人魔深渊魔咒"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.05．血海绞杀")
local _____91CA_653E_6740_622E_98DF_4EBA_9B54_8840_6D77_7EDE_6740 = ____require_result_13["释放杀戮食人魔血海绞杀"]
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.06．痛之束缚")
local _____91CA_653E_6740_622E_98DF_4EBA_9B54_75DB_4E4B_675F_7F1A = ____require_result_14["释放杀戮食人魔痛之束缚"]
local ____require_result_15 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.07．雷霆震怒")
local _____91CA_653E_6740_622E_98DF_4EBA_9B54_96F7_9706_9707_6012 = ____require_result_15["释放杀戮食人魔雷霆震怒"]
local ____require_result_16 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_16["标记测试Boss跳过死亡结算"]
local ____require_result_17 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____6CE8_518CBoss_6280_80FD_6D4B_8BD5_76EE_6807 = ____require_result_17["注册Boss技能测试目标"]
local _____6CE8_9500Boss_6280_80FD_6D4B_8BD5_76EE_6807 = ____require_result_17["注销Boss技能测试目标"]
local ____require_result_18 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_18.addDelayedCallback
local getGameDifficulty = ____require_result_18.getGameDifficulty
local ____require_result_19 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
spellHeal = ____require_result_19.spellHeal
local ____require_result_20 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_20.debugLogForce
local ____require_result_21 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____5355_4F4D_662F_5426_65E0_654C_5B89_5168 = ____require_result_21["单位是否无敌安全"]
local ____require_result_22 = require("系统.12．测试系统.00．Boss测试系统.index")
____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_22["Boss测试单位存活"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_22["获取Boss测试玩家基准英雄"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175 = ____require_result_22["准备Boss测试固定步兵"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B = ____require_result_22["准备Boss测试固定山丘之王"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_22["设置Boss测试单位满血"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_22["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_22["注册Boss测试命令组"]
local CreateUnit = jass.CreateUnit
UnitAddAbility = jass.UnitAddAbility
GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local IssueTargetOrder = jass.IssueTargetOrder
IssueImmediateOrder = jass.IssueImmediateOrder
UnitDamageTarget = jass.UnitDamageTarget
GetPlayerId = jass.GetPlayerId
GetOwningPlayer = jass.GetOwningPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetHeroLevel = jass.SetHeroLevel
local SetUnitFacing = jass.SetUnitFacing
SetUnitPosition = jass.SetUnitPosition
GetUnitState = jass.GetUnitState
SetUnitState = jass.SetUnitState
SetUnitStateJapi = japi.SetUnitState
GetHandleId = jass.GetHandleId
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
UNIT_STATE_MANA = jass.UNIT_STATE_MANA
UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____6C99_6F20_98DF_4EBA_9B54_5355_4F4DID = stringToFourCCSafe("N05J")
local _____6740_622E_98DF_4EBA_9B54_5355_4F4DID = stringToFourCCSafe("N05K")
local _____6D4B_8BD5_5723_9A91_58EB_5355_4F4DID = stringToFourCCSafe("Hpal")
_____96F7_9706_4E00_51FB_6280_80FDID = stringToFourCCSafe("AHtc")
_____6D4B_8BD5_82F1_96C4_6700_5927_9B54_6CD5_503C = 999999
_____6D4B_8BD5_4E2D_5FC3X = -540.6
_____6D4B_8BD5_4E2D_5FC3Y = -2495.2
local _____6700_8FD1_6C99_6F20_98DF_4EBA_9B54 = {}
local _____6700_8FD1_6740_622E_98DF_4EBA_9B54 = {}
_____6700_8FD1_6D4B_8BD5_6B65_5175_4E00 = {}
_____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C = {}
local _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B = {}
local _____6700_8FD1_6D4B_8BD5_5723_9A91_58EB = {}
local function _____6062_590DBoss_4F4D_7F6E_4E0E_751F_547D(boss, x)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return
    end
    SetUnitPosition(boss, x, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitFacing(boss, 270)
    SetUnitState(
        boss,
        UNIT_STATE_LIFE,
        GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    )
    _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
end
local function _____83B7_53D6_6216_521B_5EFA_98DF_4EBA_9B54_5F62_6001(player, cache, unitTypeId, x)
    local pid = GetPlayerId(player)
    local boss = cache[pid]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        boss = CreateUnit(
            player,
            unitTypeId,
            x,
            _____6D4B_8BD5_4E2D_5FC3Y,
            270
        )
        cache[pid] = boss
        if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
            SetHeroLevel(boss, 20, false)
        end
        debugLogForce(
            "食人魔Boss技能测试",
            "测试Boss创建",
            "playerId=",
            pid,
            "unitTypeId=",
            unitTypeId,
            "bossHid=",
            _____53D6_53E5_67C4ID(boss)
        )
    end
    _____6062_590DBoss_4F4D_7F6E_4E0E_751F_547D(boss, x)
    return boss
end
local function _____521B_5EFA_6216_83B7_53D6_98DF_4EBA_9B54_6D4B_8BD5_4E0A_4E0B_6587(player)
    local pid = GetPlayerId(player)
    local hero = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(hero) then
        debugLogForce(
            "食人魔Boss技能测试",
            "测试场景创建失败：玩家基准英雄无效",
            "playerId=",
            pid,
            "heroHid=",
            _____53D6_53E5_67C4ID(hero)
        )
        return nil
    end
    _____6CE8_518C_6C99_6F20_98DF_4EBA_9B54_6280_80FD_7ED3_6784()
    _____6CE8_518C_6740_622E_98DF_4EBA_9B54_6280_80FD_7ED3_6784()
    local desert = _____83B7_53D6_6216_521B_5EFA_98DF_4EBA_9B54_5F62_6001(player, _____6700_8FD1_6C99_6F20_98DF_4EBA_9B54, _____6C99_6F20_98DF_4EBA_9B54_5355_4F4DID, _____6D4B_8BD5_4E2D_5FC3X - 260)
    local killing = _____83B7_53D6_6216_521B_5EFA_98DF_4EBA_9B54_5F62_6001(player, _____6700_8FD1_6740_622E_98DF_4EBA_9B54, _____6740_622E_98DF_4EBA_9B54_5355_4F4DID, _____6D4B_8BD5_4E2D_5FC3X + 260)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(desert) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(killing) then
        debugLogForce(
            "食人魔Boss技能测试",
            "测试场景创建失败：Boss单位无效",
            "playerId=",
            pid,
            "desertHid=",
            _____53D6_53E5_67C4ID(desert),
            "killingHid=",
            _____53D6_53E5_67C4ID(killing)
        )
        return nil
    end
    _____6700_8FD1_6D4B_8BD5_6B65_5175_4E00[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_5175_4E00[pid], _____6D4B_8BD5_4E2D_5FC3X - 180, _____6D4B_8BD5_4E2D_5FC3Y - 300, 90)
    _____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C[pid], _____6D4B_8BD5_4E2D_5FC3X + 180, _____6D4B_8BD5_4E2D_5FC3Y - 300, 90)
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid], _____6D4B_8BD5_4E2D_5FC3X + 220, _____6D4B_8BD5_4E2D_5FC3Y + 220, 90)
    local _____5723_9A91_58EB = _____6700_8FD1_6D4B_8BD5_5723_9A91_58EB[pid]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____5723_9A91_58EB) then
        _____5723_9A91_58EB = CreateUnit(
            jass:Player(12),
            _____6D4B_8BD5_5723_9A91_58EB_5355_4F4DID,
            _____6D4B_8BD5_4E2D_5FC3X - 220,
            _____6D4B_8BD5_4E2D_5FC3Y + 220,
            90
        )
        _____6700_8FD1_6D4B_8BD5_5723_9A91_58EB[pid] = _____5723_9A91_58EB
    end
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____5723_9A91_58EB) then
        SetUnitPosition(_____5723_9A91_58EB, _____6D4B_8BD5_4E2D_5FC3X - 220, _____6D4B_8BD5_4E2D_5FC3Y + 220)
        SetUnitFacing(_____5723_9A91_58EB, 90)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(_____5723_9A91_58EB, 99999999)
        _____6CE8_518CBoss_6280_80FD_6D4B_8BD5_76EE_6807(_____5723_9A91_58EB)
    end
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____5723_9A91_58EB) then
        debugLogForce(
            "食人魔Boss技能测试",
            "测试场景创建失败：圣骑士测试英雄无效",
            "playerId=",
            pid,
            "paladinHid=",
            _____53D6_53E5_67C4ID(_____5723_9A91_58EB)
        )
        return nil
    end
    local mountainKingHasThunderClap = _____786E_4FDD_6D4B_8BD5_82F1_96C4_5B66_4F1A_96F7_9706_4E00_51FB(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid])
    local paladinHasThunderClap = _____786E_4FDD_6D4B_8BD5_82F1_96C4_5B66_4F1A_96F7_9706_4E00_51FB(_____6700_8FD1_6D4B_8BD5_5723_9A91_58EB[pid])
    _____8865_5145_6D4B_8BD5_82F1_96C4_9B54_6CD5(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid])
    _____8865_5145_6D4B_8BD5_82F1_96C4_9B54_6CD5(_____6700_8FD1_6D4B_8BD5_5723_9A91_58EB[pid])
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(desert)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(killing)
    local killingRuntime = _____83B7_53D6_6216_521B_5EFA_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587(killing)
    if killingRuntime == nil then
        debugLogForce(
            "食人魔Boss技能测试",
            "测试场景创建失败：杀戮食人魔上下文为空",
            "playerId=",
            pid,
            "bossHid=",
            _____53D6_53E5_67C4ID(killing)
        )
        return nil
    end
    globals.udg_Boss = desert
    SelectUnitForPlayerSingle(desert, player)
    StarOther_PanCameraToTimedForPlayer(player, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y, 0.2)
    debugLogForce(
        "食人魔Boss技能测试",
        "测试场景准备完成",
        "playerId=",
        pid,
        "desertHid=",
        _____53D6_53E5_67C4ID(desert),
        "killingHid=",
        _____53D6_53E5_67C4ID(killing),
        "heroHid=",
        _____53D6_53E5_67C4ID(hero),
        "targetOneHid=",
        _____53D6_53E5_67C4ID(_____6700_8FD1_6D4B_8BD5_6B65_5175_4E00[pid]),
        "targetTwoHid=",
        _____53D6_53E5_67C4ID(_____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C[pid]),
        "mountainKingHid=",
        _____53D6_53E5_67C4ID(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid]),
        "paladinHid=",
        _____53D6_53E5_67C4ID(_____6700_8FD1_6D4B_8BD5_5723_9A91_58EB[pid])
    )
    return {
        ["Boss单位"] = desert,
        ["沙漠食人魔"] = desert,
        ["杀戮食人魔"] = killing,
        ["杀戮运行时"] = killingRuntime,
        ["玩家英雄"] = hero,
        ["测试山丘之王"] = _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid],
        ["测试圣骑士"] = _____6700_8FD1_6D4B_8BD5_5723_9A91_58EB[pid]
    }
end
local function _____6E05_7406_98DF_4EBA_9B54_6D4B_8BD5_4E0A_4E0B_6587(player, context)
    local pid = GetPlayerId(player)
    debugLogForce(
        "食人魔Boss技能测试",
        "测试场景清理开始",
        "playerId=",
        pid,
        "desertHid=",
        _____53D6_53E5_67C4ID(context and context["沙漠食人魔"]),
        "killingHid=",
        _____53D6_53E5_67C4ID(context and context["杀戮食人魔"])
    )
    if context ~= nil and ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context["杀戮食人魔"]) then
        _____6E05_7406_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587(context["杀戮食人魔"])
    end
    _____6CE8_9500Boss_6280_80FD_6D4B_8BD5_76EE_6807(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid])
    _____6CE8_9500Boss_6280_80FD_6D4B_8BD5_76EE_6807(_____6700_8FD1_6D4B_8BD5_5723_9A91_58EB[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_6B65_5175_4E00[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_5723_9A91_58EB[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6C99_6F20_98DF_4EBA_9B54[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6740_622E_98DF_4EBA_9B54[pid])
    _____6700_8FD1_6D4B_8BD5_6B65_5175_4E00[pid] = nil
    _____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C[pid] = nil
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = nil
    _____6700_8FD1_6D4B_8BD5_5723_9A91_58EB[pid] = nil
    _____6700_8FD1_6C99_6F20_98DF_4EBA_9B54[pid] = nil
    _____6700_8FD1_6740_622E_98DF_4EBA_9B54[pid] = nil
    if globals.udg_Boss == (context and context["沙漠食人魔"]) or globals.udg_Boss == (context and context["杀戮食人魔"]) then
        globals.udg_Boss = nil
    end
    debugLogForce("食人魔Boss技能测试", "测试场景清理完成", "playerId=", pid)
end
local function _____8BB0_5F55_6280_80FD_6D4B_8BD5_7ED3_679C(_____6280_80FD_540D_79F0, _____662F_5426_5F00_59CB, boss)
    debugLogForce(
        "食人魔Boss技能测试",
        "技能命令执行",
        "skill=",
        _____6280_80FD_540D_79F0,
        "bossHid=",
        _____53D6_53E5_67C4ID(boss),
        "started=",
        _____662F_5426_5F00_59CB
    )
end
local function _____51C6_5907_98DF_4EBA_9B54_56DB_65B9_5411_6D4B_8BD5_76EE_6807(boss, context)
    local x = GetUnitX(boss)
    local y = GetUnitY(boss)
    local _____76EE_6807_5217_8868 = {
        {
            ["单位"] = _____6700_8FD1_6D4B_8BD5_6B65_5175_4E00[GetPlayerId(GetOwningPlayer(boss))],
            x = x + 450,
            y = y
        },
        {
            ["单位"] = _____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C[GetPlayerId(GetOwningPlayer(boss))],
            x = x - 450,
            y = y
        },
        {["单位"] = context["测试山丘之王"], x = x, y = y + 450},
        {["单位"] = context["测试圣骑士"], x = x, y = y - 450}
    }
    do
        local i = 0
        while i < #_____76EE_6807_5217_8868 do
            do
                local _____76EE_6807 = _____76EE_6807_5217_8868[i + 1]
                if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____76EE_6807["单位"]) then
                    goto __continue26
                end
                SetUnitPosition(_____76EE_6807["单位"], _____76EE_6807.x, _____76EE_6807.y)
                _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(_____76EE_6807["单位"], 100000)
            end
            ::__continue26::
            i = i + 1
        end
    end
    debugLogForce(
        "食人魔Boss技能测试",
        "四方向测试目标已摆位",
        "bossHid=",
        _____53D6_53E5_67C4ID(boss),
        "bossX=",
        x,
        "bossY=",
        y,
        "targetCount=",
        #_____76EE_6807_5217_8868,
        "offset=",
        450,
        "expected=",
        "东西南北四个方向各有一个已登记测试目标"
    )
end
local function _____6D4B_8BD5_98DF_4EBA_9B54_5492(_player, context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6C99_6F20_98DF_4EBA_9B54_5492(context["沙漠食人魔"])
    if _____662F_5426_5F00_59CB then
        addDelayedCallback(2000, ____on_98DF_4EBA_9B54_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["形态"] = "沙漠", ["操作"] = "施法"})
    end
    _____8BB0_5F55_6280_80FD_6D4B_8BD5_7ED3_679C("沙漠-食人魔咒（2秒后山丘之王施法）", _____662F_5426_5F00_59CB, context["沙漠食人魔"])
end
local function _____6D4B_8BD5_98CE_66B4_4E4B_9524(_player, context)
    local pid = GetPlayerId(_player)
    local target = _____6700_8FD1_6D4B_8BD5_6B65_5175_4E00[pid]
    local boss = context["沙漠食人魔"]
    SetUnitPosition(boss, _____6D4B_8BD5_4E2D_5FC3X - 260, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitPosition(target, _____6D4B_8BD5_4E2D_5FC3X + 260, _____6D4B_8BD5_4E2D_5FC3Y)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(target, 100000)
    local issueOrder = ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) and IssueTargetOrder(boss, "thunderbolt", target)
    local _____662F_5426_5F00_59CB = issueOrder or _____91CA_653E_6C99_6F20_98DF_4EBA_9B54_98CE_66B4_4E4B_9524(boss)
    if _____662F_5426_5F00_59CB then
        addDelayedCallback(7000, ____on_98DF_4EBA_9B54_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["形态"] = "沙漠", ["操作"] = "风暴之锤结束检查"})
    end
    debugLogForce(
        "食人魔Boss技能测试",
        "沙漠风暴之锤指定目标测试",
        "bossHid=",
        _____53D6_53E5_67C4ID(boss),
        "specifiedTargetHid=",
        _____53D6_53E5_67C4ID(target),
        "issueOrder=",
        issueOrder,
        "started=",
        _____662F_5426_5F00_59CB,
        "expected=",
        "指定目标命中按100%倍率结算，弹幕5秒后清理"
    )
end
local function _____6D4B_8BD5_98CE_66B4_4E4B_9524_975E_6307_5B9A_76EE_6807(_player, context)
    local pid = GetPlayerId(_player)
    local target = _____6700_8FD1_6D4B_8BD5_6B65_5175_4E00[pid]
    local interceptor = _____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C[pid]
    local boss = context["沙漠食人魔"]
    SetUnitPosition(boss, _____6D4B_8BD5_4E2D_5FC3X - 260, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitPosition(interceptor, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitPosition(target, _____6D4B_8BD5_4E2D_5FC3X + 520, _____6D4B_8BD5_4E2D_5FC3Y)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(target, 100000)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(interceptor, 100000)
    local issueOrder = ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) and IssueTargetOrder(boss, "thunderbolt", target)
    local _____662F_5426_5F00_59CB = issueOrder or _____91CA_653E_6C99_6F20_98DF_4EBA_9B54_98CE_66B4_4E4B_9524(boss)
    if _____662F_5426_5F00_59CB then
        addDelayedCallback(7000, ____on_98DF_4EBA_9B54_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["形态"] = "沙漠", ["操作"] = "风暴之锤结束检查"})
    end
    debugLogForce(
        "食人魔Boss技能测试",
        "沙漠风暴之锤非指定目标拦截测试",
        "bossHid=",
        _____53D6_53E5_67C4ID(boss),
        "specifiedTargetHid=",
        _____53D6_53E5_67C4ID(target),
        "interceptorHid=",
        _____53D6_53E5_67C4ID(interceptor),
        "issueOrder=",
        issueOrder,
        "started=",
        _____662F_5426_5F00_59CB,
        "expected=",
        "弹幕先命中非指定目标时伤害和眩晕均按60%倍率"
    )
end
local function _____6D4B_8BD5_96F7_9706_6572_6253(_player, context)
    local boss = context["沙漠食人魔"]
    _____51C6_5907_98DF_4EBA_9B54_56DB_65B9_5411_6D4B_8BD5_76EE_6807(boss, context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6C99_6F20_98DF_4EBA_9B54_96F7_9706_6572_6253(boss)
    local _____68C0_67E5_5EF6_8FDF_6BEB_79D2 = (_____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E["雷霆敲打"]["轮次间隔秒"] * _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E["雷霆敲打"]["轮数"] + _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E["雷霆敲打"]["预警秒"] + _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E["雷霆敲打"]["弹幕持续秒"] + 0.3) * 1000
    if _____662F_5426_5F00_59CB then
        addDelayedCallback(_____68C0_67E5_5EF6_8FDF_6BEB_79D2, ____on_98DF_4EBA_9B54_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["形态"] = "沙漠", ["操作"] = "雷霆敲打结束检查"})
    end
    debugLogForce(
        "食人魔Boss技能测试",
        "沙漠雷霆敲打四方向测试",
        "bossHid=",
        _____53D6_53E5_67C4ID(boss),
        "started=",
        _____662F_5426_5F00_59CB,
        "checkDelay=",
        _____68C0_67E5_5EF6_8FDF_6BEB_79D2,
        "expected=",
        "全部轮次发射且最后一轮冲击波生命周期结束后检查；每轮创建四个方向冲击波并结算减速"
    )
end
local function _____6D4B_8BD5_666E_901A_96F7_9706_9707_6012(_player, context)
    _____91CA_653E_6C99_6F20_98DF_4EBA_9B54_96F7_9706_9707_6012(context["沙漠食人魔"])
end
local function _____6D4B_8BD5_6DF1_6E0A_9B54_5492(_player, context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6740_622E_98DF_4EBA_9B54_6DF1_6E0A_9B54_5492(context["杀戮运行时"])
    if _____662F_5426_5F00_59CB then
        addDelayedCallback(2000, ____on_98DF_4EBA_9B54_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["形态"] = "杀戮", ["操作"] = "施法"})
    end
end
local function _____6D4B_8BD5_6DF1_6E0A_9B54_5492_6CBB_7597_53CD_566C(_player, context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6740_622E_98DF_4EBA_9B54_6DF1_6E0A_9B54_5492(context["杀戮运行时"])
    if _____662F_5426_5F00_59CB then
        addDelayedCallback(2000, ____on_98DF_4EBA_9B54_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["形态"] = "杀戮", ["操作"] = "治疗反噬"})
    end
end
local function _____6D4B_8BD5_8840_6D77_7EDE_6740(_player, context)
    _____51C6_5907_98DF_4EBA_9B54_56DB_65B9_5411_6D4B_8BD5_76EE_6807(context["杀戮食人魔"], context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6740_622E_98DF_4EBA_9B54_8840_6D77_7EDE_6740(context["杀戮运行时"])
    if _____662F_5426_5F00_59CB then
        addDelayedCallback(5200, ____on_98DF_4EBA_9B54_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["形态"] = "杀戮", ["操作"] = "血海绞杀结束检查"})
    end
    debugLogForce(
        "食人魔Boss技能测试",
        "杀戮血海绞杀四方向测试",
        "bossHid=",
        _____53D6_53E5_67C4ID(context["杀戮食人魔"]),
        "started=",
        _____662F_5426_5F00_59CB,
        "expected=",
        "四个方向各创建一枚血海弹幕，命中后造成暗伤并眩晕"
    )
end
local function _____6D4B_8BD5_75DB_4E4B_675F_7F1A(_player, context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6740_622E_98DF_4EBA_9B54_75DB_4E4B_675F_7F1A(context["杀戮运行时"])
    _____8BB0_5F55_6280_80FD_6D4B_8BD5_7ED3_679C("杀戮-痛之束缚", _____662F_5426_5F00_59CB, context["杀戮食人魔"])
end
local function _____6D4B_8BD5_6740_622E_96F7_9706_9707_6012(_player, context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6740_622E_98DF_4EBA_9B54_96F7_9706_9707_6012(context["杀戮运行时"])
    _____8BB0_5F55_6280_80FD_6D4B_8BD5_7ED3_679C("杀戮-雷霆震怒", _____662F_5426_5F00_59CB, context["杀戮食人魔"])
end
local function _____6D4B_8BD5_84C4_529B_91CD_51FB(_player, context)
    local boss = context["沙漠食人魔"]
    local target = _____6700_8FD1_6D4B_8BD5_6B65_5175_4E00[GetPlayerId(_player)]
    local secondTarget = _____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C[GetPlayerId(_player)]
    SetUnitPosition(boss, _____6D4B_8BD5_4E2D_5FC3X - 260, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitPosition(target, _____6D4B_8BD5_4E2D_5FC3X - 180, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitPosition(secondTarget, _____6D4B_8BD5_4E2D_5FC3X + 180, _____6D4B_8BD5_4E2D_5FC3Y)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(target, 100000)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(secondTarget, 100000)
    local _____6210_529F_6B21_6570 = 0
    do
        local i = 0
        while i < 4 do
            if UnitDamageTarget(
                boss,
                target,
                1,
                true,
                false,
                ATTACK_TYPE_NORMAL,
                DAMAGE_TYPE_NORMAL,
                WEAPON_TYPE_WHOKNOWS
            ) then
                _____6210_529F_6B21_6570 = _____6210_529F_6B21_6570 + 1
            end
            i = i + 1
        end
    end
    debugLogForce(
        "食人魔Boss技能测试",
        "蓄力重击四次普攻测试已提交",
        "bossHid=",
        _____53D6_53E5_67C4ID(boss),
        "centerTargetHid=",
        _____53D6_53E5_67C4ID(target),
        "nearTargetHid=",
        _____53D6_53E5_67C4ID(secondTarget),
        "submitted=",
        _____6210_529F_6B21_6570,
        "expected=",
        "第四击触发400码范围伤害且预期命中两个测试靶"
    )
end
local function _____6D4B_8BD5_98DF_4EBA_9B54_5543_98DF(_player, context, _____5F62_6001)
    local pid = GetPlayerId(_player)
    local ____temp_31
    if _____5F62_6001 == "沙漠" then
        ____temp_31 = context["沙漠食人魔"]
    else
        ____temp_31 = context["杀戮食人魔"]
    end
    local boss = ____temp_31
    local _____88AB_51FB_6740_9776 = _____6700_8FD1_6D4B_8BD5_6B65_5175_4E00[pid]
    local _____514D_4F24_9A8C_8BC1_9776 = _____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C[pid]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____88AB_51FB_6740_9776) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____514D_4F24_9A8C_8BC1_9776) then
        debugLogForce(
            "食人魔Boss技能测试",
            "啃食测试跳过：Boss或测试靶无效",
            "form=",
            _____5F62_6001,
            "bossHid=",
            _____53D6_53E5_67C4ID(boss),
            "killedTargetHid=",
            _____53D6_53E5_67C4ID(_____88AB_51FB_6740_9776),
            "damageTargetHid=",
            _____53D6_53E5_67C4ID(_____514D_4F24_9A8C_8BC1_9776)
        )
        return
    end
    local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    local maxMana = GetUnitState(boss, UNIT_STATE_MAX_MANA)
    SetUnitState(boss, UNIT_STATE_LIFE, maxLife * 0.5)
    SetUnitState(boss, UNIT_STATE_MANA, maxMana * 0.5)
    local lethalDamage = GetUnitState(_____88AB_51FB_6740_9776, UNIT_STATE_MAX_LIFE) + 100000
    local killSubmitted = false
    local lethalHitCount = 0
    do
        local i = 0
        while i < 4 and ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____88AB_51FB_6740_9776) do
            local submitted = UnitDamageTarget(
                boss,
                _____88AB_51FB_6740_9776,
                lethalDamage,
                true,
                false,
                ATTACK_TYPE_NORMAL,
                DAMAGE_TYPE_NORMAL,
                WEAPON_TYPE_WHOKNOWS
            )
            if submitted then
                killSubmitted = true
                lethalHitCount = lethalHitCount + 1
            end
            i = i + 1
        end
    end
    debugLogForce(
        "食人魔Boss技能测试",
        "致命伤害后目标状态",
        "form=",
        _____5F62_6001,
        "bossHid=",
        _____53D6_53E5_67C4ID(boss),
        "targetHid=",
        _____53D6_53E5_67C4ID(_____88AB_51FB_6740_9776),
        "targetLife=",
        GetUnitState(_____88AB_51FB_6740_9776, UNIT_STATE_LIFE),
        "targetAlive=",
        ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____88AB_51FB_6740_9776),
        "lethalHitCount=",
        lethalHitCount,
        "bossSafeInvulnerable=",
        _____5355_4F4D_662F_5426_65E0_654C_5B89_5168(boss)
    )
    local damageDuringEating = UnitDamageTarget(
        _____514D_4F24_9A8C_8BC1_9776,
        boss,
        5000,
        true,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    )
    debugLogForce(
        "食人魔Boss技能测试",
        "食人魔啃食真实死亡事件已提交",
        "form=",
        _____5F62_6001,
        "bossHid=",
        _____53D6_53E5_67C4ID(boss),
        "killedTargetHid=",
        _____53D6_53E5_67C4ID(_____88AB_51FB_6740_9776),
        "killSubmitted=",
        killSubmitted,
        "damageDuringEatingSubmitted=",
        damageDuringEating,
        "bossLifeImmediately=",
        GetUnitState(boss, UNIT_STATE_LIFE),
        "expected=",
        "击杀后暂停硬直并免伤；等待啃食结束恢复100%状态"
    )
    if killSubmitted then
        local difficulty = getGameDifficulty()
        local normalizedDifficulty = difficulty > 0 and difficulty or 1
        local eatingDurationMs = (2.6 - normalizedDifficulty * 0.2) * 1000
        local callbackId = addDelayedCallback(eatingDurationMs + 100, ____on_98DF_4EBA_9B54_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["形态"] = _____5F62_6001, ["操作"] = "啃食完成检查"})
        debugLogForce(
            "食人魔Boss技能测试",
            "啃食完成检查已登记",
            "form=",
            _____5F62_6001,
            "bossHid=",
            _____53D6_53E5_67C4ID(boss),
            "callbackId=",
            callbackId,
            "eatingDurationMs=",
            eatingDurationMs,
            "lifeBeforeEating=",
            maxLife * 0.5,
            "manaBeforeEating=",
            maxMana * 0.5
        )
    end
end
local function _____6D4B_8BD5_6C99_6F20_98DF_4EBA_9B54_5543_98DF(player, context)
    _____6D4B_8BD5_98DF_4EBA_9B54_5543_98DF(player, context, "沙漠")
end
local function _____6D4B_8BD5_6740_622E_98DF_4EBA_9B54_5543_98DF(player, context)
    _____6D4B_8BD5_98DF_4EBA_9B54_5543_98DF(player, context, "杀戮")
end
local function _____6D4B_8BD5_75BC_75DB_590D_4EC7(_player, context)
    local source = _____6700_8FD1_6D4B_8BD5_6B65_5175_4E00[GetPlayerId(_player)]
    local _____6210_529F_6B21_6570 = 0
    do
        local i = 0
        while i < 2 do
            if UnitDamageTarget(
                source,
                context["杀戮食人魔"],
                2000,
                true,
                false,
                ATTACK_TYPE_NORMAL,
                DAMAGE_TYPE_NORMAL,
                WEAPON_TYPE_WHOKNOWS
            ) then
                _____6210_529F_6B21_6570 = _____6210_529F_6B21_6570 + 1
            end
            i = i + 1
        end
    end
    debugLogForce(
        "食人魔Boss技能测试",
        "疼痛复仇阈值测试已提交",
        "bossHid=",
        _____53D6_53E5_67C4ID(context["杀戮食人魔"]),
        "sourceHid=",
        _____53D6_53E5_67C4ID(source),
        "submitted=",
        _____6210_529F_6B21_6570,
        "expected=",
        "根据实际结算伤害观察增伤层与解控次数；本轮应至少触发一次解控并刷新血海绞杀"
    )
end
local function _____6D4B_8BD5_75DB_4E4B_675F_7F1A_4F24_5BB3_8F6C_79FB(_player, context)
    local started = _____91CA_653E_6740_622E_98DF_4EBA_9B54_75DB_4E4B_675F_7F1A(context["杀戮运行时"])
    if started then
        addDelayedCallback(900, ____on_75DB_4E4B_675F_7F1A_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["形态"] = "杀戮", ["操作"] = "转移伤害"})
    end
    _____8BB0_5F55_6280_80FD_6D4B_8BD5_7ED3_679C("杀戮-痛之束缚（链接后Boss受伤）", started, context["杀戮食人魔"])
end
local function _____6D4B_8BD5_75DB_4E4B_675F_7F1A_65AD_94FE(_player, context)
    local started = _____91CA_653E_6740_622E_98DF_4EBA_9B54_75DB_4E4B_675F_7F1A(context["杀戮运行时"])
    if started then
        addDelayedCallback(900, ____on_75DB_4E4B_675F_7F1A_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["形态"] = "杀戮", ["操作"] = "断链"})
    end
    _____8BB0_5F55_6280_80FD_6D4B_8BD5_7ED3_679C("杀戮-痛之束缚（移出1200码断链）", started, context["杀戮食人魔"])
end
local function _____6D4B_8BD5_5FC3_810F_638C_63E1(player, context)
    local pid = GetPlayerId(player)
    local target = context["测试山丘之王"]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        target = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B(target, _____6D4B_8BD5_4E2D_5FC3X + 220, _____6D4B_8BD5_4E2D_5FC3Y + 220, 90)
        context["测试山丘之王"] = target
        _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = target
    end
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        return
    end
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(target, 100000)
    SetUnitState(target, UNIT_STATE_LIFE, 20000)
    UnitDamageTarget(
        context["杀戮食人魔"],
        target,
        1,
        true,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    )
end
local _____98DF_4EBA_9B54_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["命令"] = "食人魔1", ["名称"] = "沙漠-食人魔咒（2秒后施法反噬）", ["执行"] = _____6D4B_8BD5_98DF_4EBA_9B54_5492},
    {["序号"] = 2, ["名称"] = "沙漠-风暴之锤", ["执行"] = _____6D4B_8BD5_98CE_66B4_4E4B_9524},
    {["序号"] = 2, ["命令"] = "食人魔2-2", ["名称"] = "沙漠-风暴之锤非指定目标拦截", ["执行"] = _____6D4B_8BD5_98CE_66B4_4E4B_9524_975E_6307_5B9A_76EE_6807},
    {["序号"] = 3, ["名称"] = "沙漠-雷霆敲打", ["执行"] = _____6D4B_8BD5_96F7_9706_6572_6253},
    {["序号"] = 4, ["名称"] = "沙漠-雷霆震怒", ["执行"] = _____6D4B_8BD5_666E_901A_96F7_9706_9707_6012},
    {["序号"] = 5, ["命令"] = "食人魔5", ["名称"] = "杀戮-深渊魔咒（2秒后两个测试英雄施法）", ["执行"] = _____6D4B_8BD5_6DF1_6E0A_9B54_5492},
    {["序号"] = 5, ["命令"] = "食人魔5-2", ["名称"] = "杀戮-深渊魔咒治疗无效与反噬", ["执行"] = _____6D4B_8BD5_6DF1_6E0A_9B54_5492_6CBB_7597_53CD_566C},
    {["序号"] = 6, ["名称"] = "杀戮-血海绞杀", ["执行"] = _____6D4B_8BD5_8840_6D77_7EDE_6740},
    {["序号"] = 7, ["命令"] = "食人魔7", ["名称"] = "杀戮-痛之束缚（链接后Boss受伤）", ["执行"] = _____6D4B_8BD5_75DB_4E4B_675F_7F1A_4F24_5BB3_8F6C_79FB},
    {["序号"] = 8, ["名称"] = "杀戮-雷霆震怒", ["执行"] = _____6D4B_8BD5_6740_622E_96F7_9706_9707_6012},
    {["序号"] = 9, ["命令"] = "食人魔9", ["名称"] = "沙漠-蓄力重击四次普攻", ["执行"] = _____6D4B_8BD5_84C4_529B_91CD_51FB},
    {["序号"] = 10, ["命令"] = "食人魔10", ["名称"] = "杀戮-疼痛复仇阈值", ["执行"] = _____6D4B_8BD5_75BC_75DB_590D_4EC7},
    {["序号"] = 11, ["命令"] = "食人魔11", ["名称"] = "杀戮-痛之束缚移出1200码", ["执行"] = _____6D4B_8BD5_75DB_4E4B_675F_7F1A_65AD_94FE},
    {["序号"] = 12, ["命令"] = "食人魔12", ["名称"] = "杀戮-心脏掌握低血线", ["执行"] = _____6D4B_8BD5_5FC3_810F_638C_63E1},
    {["序号"] = 13, ["命令"] = "食人魔13", ["名称"] = "沙漠-食人魔啃食（真实击杀/免伤/恢复）", ["执行"] = _____6D4B_8BD5_6C99_6F20_98DF_4EBA_9B54_5543_98DF},
    {["序号"] = 14, ["命令"] = "食人魔14", ["名称"] = "杀戮-食人魔啃食（真实击杀/免伤/恢复）", ["执行"] = _____6D4B_8BD5_6740_622E_98DF_4EBA_9B54_5543_98DF}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "食人魔",
    ["Boss名称"] = "食人魔双形态",
    ["场地"] = {["正式中心"] = {x = _____6D4B_8BD5_4E2D_5FC3X, y = _____6D4B_8BD5_4E2D_5FC3Y}, ["测试空地中心"] = {x = _____6D4B_8BD5_4E2D_5FC3X, y = _____6D4B_8BD5_4E2D_5FC3Y}},
    ["创建或获取上下文"] = _____521B_5EFA_6216_83B7_53D6_98DF_4EBA_9B54_6D4B_8BD5_4E0A_4E0B_6587,
    ["清理上下文"] = _____6E05_7406_98DF_4EBA_9B54_6D4B_8BD5_4E0A_4E0B_6587,
    ["技能命令列表"] = _____98DF_4EBA_9B54_6D4B_8BD5_6280_80FD_5217_8868
})
debugLogForce("食人魔Boss技能测试", "测试命令组注册完成", "commandCount=", #_____98DF_4EBA_9B54_6D4B_8BD5_6280_80FD_5217_8868)
return ____exports
