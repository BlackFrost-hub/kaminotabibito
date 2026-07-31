local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local _____53D6_5355_4F4DID = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["取单位ID"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.00．配置")
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["巴尔扎罗斯单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．数值与表现配置")
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯技能数值配置"]
local _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯音效配置"]
local ____14_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.14．台词播放")
local _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD = ____14_FF0E_53F0_8BCD_64AD_653E["播放巴尔扎罗斯台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____01_FF0ETS_539F_751F_5F39_5E55 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_9501_5B9A_5355_4F4D_4E8C_9636_8D1D_585E_5C14XYZ_8F68_8FF9 = ____01_FF0ETS_539F_751F_5F39_5E55["创建锁定单位二阶贝塞尔XYZ轨迹"]
local _____521B_5EFA_539F_751F_5F39_5E55 = ____01_FF0ETS_539F_751F_5F39_5E55["创建原生弹幕"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____require_result_0["计算组合技能伤害"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____require_result_1["播放限时单位动画"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.index")
local _____521B_5EFA_8840_91CF_8282_70B9_89E6_53D1_5668 = ____require_result_2["创建血量节点触发器"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾")
local _____5F00_59CB_62A4_76FE = ____require_result_3["开始护盾"]
local _____62A4_76FE_7C7B_578B = ____require_result_3["护盾类型"]
local _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C = ____require_result_3["查询单位标签护盾值"]
local ____require_result_4 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_4.registerDamageModifier
local ____require_result_5 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_5.registerManualBuff
local getBuffRuntime = ____require_result_5.getBuffRuntime
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_5["移除单位指定Buff"]
local ____require_result_6 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_6.getServerTime
local ____require_result_7 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_7["造成单体技能伤害"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetUnitState = jass.GetUnitState
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local EXSetEffectZ = japi.EXSetEffectZ
local EXSetEffectSize = japi.EXSetEffectSize
local IsUnitType = jass.IsUnitType
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local SquareRoot = jass.SquareRoot
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____7194_5CA9_62A4_76FE_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = false
local _____8FD1_6218_53CD_5F39_51B7_5374_8868 = {}
local _____51B0_971C_547D_4E2D_62A4_76FE_65F6_95F4_8868 = {}
local _____7194_5CA9_62A4_76FE_53CD_5F39_5F39_5E55_72B6_6001_8868 = {}
local function _____64AD_653E_62A4_76FE_77ED_52A8_4F5C(boss)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩护盾"]
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({
        ["单位"] = boss,
        ["动画编号"] = config["动画编号"],
        ["动画速度"] = config["动画速度"],
        ["持续秒"] = 0.7,
        ["恢复动画"] = false,
        ["恢复动画速度"] = 1
    })
end
local function _____79FB_9664_4E00_5C42_7194_5CA9_66B4_8D70(boss)
    local buffID = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["熔岩暴走"]
    local runtime = getBuffRuntime(boss, buffID)
    if runtime == nil then
        return
    end
    local ____runtime_stack_8 = runtime.stack
    if ____runtime_stack_8 == nil then
        ____runtime_stack_8 = 1
    end
    local stack = ____runtime_stack_8
    if stack <= 1 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(boss, buffID)
        return
    end
    local ____registerManualBuff_12 = registerManualBuff
    local ____boss_11 = boss
    local ____runtime_remaining_9 = runtime.remaining
    if ____runtime_remaining_9 == nil then
        ____runtime_remaining_9 = 10
    end
    local ____runtime_effect_10 = runtime.effect
    if ____runtime_effect_10 == nil then
        ____runtime_effect_10 = 0
    end
    ____registerManualBuff_12(
        ____boss_11,
        buffID,
        ____runtime_remaining_9,
        ____runtime_effect_10,
        {stack = stack - 1, sourceName = "巴尔扎罗斯"}
    )
end
____exports["释放巴尔扎罗斯熔岩护盾"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩护盾"]
    local shieldValue = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * config["护盾Boss最大生命比例"]
    local bossId = _____53D6_5355_4F4DID(boss)
    _____64AD_653E_62A4_76FE_77ED_52A8_4F5C(boss)
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["熔岩护盾"]["护盾生成"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD(boss, "熔岩护盾")
    local _____62A4_76FE_5750_6807X = GetUnitX(boss)
    local _____62A4_76FE_5750_6807Y = GetUnitY(boss)
    local _____62A4_76FE_7279_6548 = AddSpecialEffect(config["特效路径"], _____62A4_76FE_5750_6807X, _____62A4_76FE_5750_6807Y)
    if _____62A4_76FE_7279_6548 ~= nil and _____62A4_76FE_7279_6548 ~= 0 then
        EXSetEffectZ(_____62A4_76FE_7279_6548, config["特效高度"])
        EXSetEffectSize(_____62A4_76FE_7279_6548, config["特效缩放"])
    end
    registerManualBuff(
        boss,
        _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["熔岩护盾"],
        config["持续秒"],
        shieldValue,
        {sourceName = "巴尔扎罗斯"}
    )
    _____5F00_59CB_62A4_76FE(
        boss,
        {
            ["类型"] = _____62A4_76FE_7C7B_578B["通用"],
            ["数值"] = shieldValue,
            ["持续时间"] = config["持续秒"],
            ["来源单位"] = boss,
            ["标签"] = config["护盾标签"],
            ["结束回调"] = function()
                if _____62A4_76FE_7279_6548 ~= nil and _____62A4_76FE_7279_6548 ~= 0 then
                    DestroyEffect(_____62A4_76FE_7279_6548)
                end
                _____79FB_9664_5355_4F4D_6307_5B9ABuff(boss, _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["熔岩护盾"])
            end,
            ["破碎回调"] = function()
                local lastIce = _____51B0_971C_547D_4E2D_62A4_76FE_65F6_95F4_8868[bossId] or 0
                if lastIce > 0 and getServerTime() - lastIce <= 250 then
                    _____79FB_9664_4E00_5C42_7194_5CA9_66B4_8D70(boss)
                end
            end
        }
    )
end
local function _____8BA1_7B97_53CD_5F39_4F24_5BB3(boss, attacker)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩护盾"]
    return _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, attacker, {["来源攻击力比例"] = config["近战反弹Boss攻击力比例"], ["目标最大生命比例"] = config["近战反弹来源最大生命比例"]})
end
local function ____on_7194_5CA9_62A4_76FE_53CD_5F39_5F39_5E55_7ED3_675F(_____539F_56E0, _____5F39_5E55ID)
    if _____539F_56E0 == "完成" or _____539F_56E0 == "距离结束" then
        return
    end
    __TS__Delete(_____7194_5CA9_62A4_76FE_53CD_5F39_5F39_5E55_72B6_6001_8868, _____5F39_5E55ID)
end
local function ____on_7194_5CA9_62A4_76FE_53CD_5F39_5F39_5E55_5230_8FBE(_____5F39_5E55ID)
    local state = _____7194_5CA9_62A4_76FE_53CD_5F39_5F39_5E55_72B6_6001_8868[_____5F39_5E55ID]
    __TS__Delete(_____7194_5CA9_62A4_76FE_53CD_5F39_5F39_5E55_72B6_6001_8868, _____5F39_5E55ID)
    if state == nil or not _____5355_4F4D_6709_6548(state["Boss单位"]) or not _____5355_4F4D_6709_6548(state["攻击单位"]) then
        return
    end
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = state["Boss单位"],
        ["目标"] = state["攻击单位"],
        ["伤害"] = _____8BA1_7B97_53CD_5F39_4F24_5BB3(state["Boss单位"], state["攻击单位"]),
        attack = false,
        ranged = true,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "Boss技能"
    })
end
local function _____53D1_5C04_7194_5CA9_62A4_76FE_53CD_5F39_5F39_5E55(boss, attacker)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩护盾"]
    local startX = GetUnitX(boss)
    local startY = GetUnitY(boss)
    local targetX = GetUnitX(attacker)
    local targetY = GetUnitY(attacker)
    local dx = targetX - startX
    local dy = targetY - startY
    local distance = SquareRoot(dx * dx + dy * dy)
    local controlX = (startX + targetX) * 0.5 + config["近战反弹控制点侧偏"]
    local controlY = (startY + targetY) * 0.5
    if distance > 0.01 then
        controlX = (startX + targetX) * 0.5 - dy / distance * config["近战反弹控制点侧偏"]
        controlY = (startY + targetY) * 0.5 + dx / distance * config["近战反弹控制点侧偏"]
    end
    local barrage = _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = boss,
        ["载体模式"] = "单位",
        ["模型"] = config["近战反弹弹道路径"],
        ["缩放"] = config["近战反弹弹道缩放"],
        X = startX,
        Y = startY,
        ["方向角"] = 0,
        ["指定目标"] = attacker,
        ["速度"] = 1,
        ["生命周期"] = config["近战反弹弹道飞行秒"],
        ["命中半径"] = 0,
        ["禁用碰撞"] = true,
        ["不可阻挡"] = false,
        ["被阻挡时销毁"] = true,
        ["轨迹采样器"] = _____521B_5EFA_9501_5B9A_5355_4F4D_4E8C_9636_8D1D_585E_5C14XYZ_8F68_8FF9(
            startX,
            startY,
            config["近战反弹起点高度"],
            controlX,
            controlY,
            config["近战反弹控制点高度"],
            attacker,
            config["近战反弹目标高度"]
        ),
        ["on结束"] = ____on_7194_5CA9_62A4_76FE_53CD_5F39_5F39_5E55_7ED3_675F,
        ["on到达目标点"] = ____on_7194_5CA9_62A4_76FE_53CD_5F39_5F39_5E55_5230_8FBE
    })
    _____7194_5CA9_62A4_76FE_53CD_5F39_5F39_5E55_72B6_6001_8868[barrage["弹幕ID"]] = {["Boss单位"] = boss, ["攻击单位"] = attacker}
end
local function _____5C1D_8BD5_5B89_6392_8FD1_6218_53CD_5F39(boss, attacker)
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(attacker) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩护盾"]
    local attackerId = _____53D6_5355_4F4DID(attacker)
    if attackerId == 0 then
        return
    end
    local now = getServerTime()
    local nextAllowed = _____8FD1_6218_53CD_5F39_51B7_5374_8868[attackerId] or 0
    if now < nextAllowed then
        return
    end
    _____8FD1_6218_53CD_5F39_51B7_5374_8868[attackerId] = now + config["近战反弹冷却秒"] * 1000
    _____53D1_5C04_7194_5CA9_62A4_76FE_53CD_5F39_5F39_5E55(boss, attacker)
end
local function _____5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE_4F24_5BB3_4FEE_6B63(context)
    local boss = context.target
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩护盾"]
    if not _____5355_4F4D_6709_6548(boss) or _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C(boss, config["护盾标签"]) <= 0 then
        return context.currentDamage
    end
    if context.isNormalAttack == true and context.isRangedAttack ~= true and _____5355_4F4D_6709_6548(context.attacker) then
        _____5C1D_8BD5_5B89_6392_8FD1_6218_53CD_5F39(boss, context.attacker)
    end
    if context.isWaterDamage == true then
        local bossId = _____53D6_5355_4F4DID(boss)
        if bossId ~= 0 then
            _____51B0_971C_547D_4E2D_62A4_76FE_65F6_95F4_8868[bossId] = getServerTime()
        end
        return context.currentDamage * config["冰霜护盾消耗倍率"]
    end
    return context.currentDamage
end
local function _____786E_4FDD_7194_5CA9_62A4_76FE_4F24_5BB3_4FEE_6B63()
    if _____7194_5CA9_62A4_76FE_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C then
        return
    end
    _____7194_5CA9_62A4_76FE_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = true
    registerDamageModifier(_____5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE_4F24_5BB3_4FEE_6B63, 110)
end
____exports["初始化巴尔扎罗斯熔岩护盾节点"] = function(context)
    if context["熔岩护盾节点已初始化"] then
        return
    end
    context["熔岩护盾节点已初始化"] = true
    _____786E_4FDD_7194_5CA9_62A4_76FE_4F24_5BB3_4FEE_6B63()
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩护盾"]
    _____521B_5EFA_8840_91CF_8282_70B9_89E6_53D1_5668({
        ["清理"] = context["清理"],
        ["名称"] = "巴尔扎罗斯-熔岩护盾血量节点",
        ["单位"] = context["Boss单位"],
        ["节点列表"] = {
            {
                ID = "熔岩护盾-85",
                ["百分比"] = config["触发生命比例"][1],
                ["on触发"] = function()
                    ____exports["释放巴尔扎罗斯熔岩护盾"](context)
                end
            },
            {
                ID = "熔岩护盾-55",
                ["百分比"] = config["触发生命比例"][2],
                ["on触发"] = function()
                    ____exports["释放巴尔扎罗斯熔岩护盾"](context)
                end
            },
            {
                ID = "熔岩护盾-25",
                ["百分比"] = config["触发生命比例"][3],
                ["on触发"] = function()
                    ____exports["释放巴尔扎罗斯熔岩护盾"](context)
                end
            }
        }
    })
end
____exports["注册巴尔扎罗斯熔岩护盾"] = function()
    _____786E_4FDD_7194_5CA9_62A4_76FE_4F24_5BB3_4FEE_6B63()
end
return ____exports
