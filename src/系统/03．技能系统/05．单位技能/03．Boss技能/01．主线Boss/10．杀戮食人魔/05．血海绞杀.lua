local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.00．配置")
local _____6740_622E_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["杀戮食人魔单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建杀戮食人魔上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.02．数值与表现配置")
local _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["杀戮食人魔技能配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____01_FF0ETS_539F_751F_5F39_5E55 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____01_FF0ETS_539F_751F_5F39_5E55["创建原生弹幕"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_0["开始硬直"]
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_0["施加快速控制Buff"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168 = ____require_result_1["暂停并设置无敌安全"]
local _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168 = ____require_result_1["解除暂停并取消无敌安全"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_3["获取Boss技能敌对英雄列表"]
local ____require_result_4 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_4["显示常规技能吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_4["关闭吟唱条"]
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_5.EC_CreateEffect
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_6.stringToFourCCSafe
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitFacing = jass.GetUnitFacing
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local GetUnitStateJapi = japi.GetUnitState
local SetUnitState = jass.SetUnitState
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local IsUnitType = jass.IsUnitType
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____6740_622E_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6740_622E_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____8840_6D77_7EDE_6740_6280_80FDID = stringToFourCCSafe(_____6740_622E_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["技能ID"]["血海绞杀"])
local _____8840_6D77_7EDE_6740_65E0_654C_6765_6E90 = "杀戮食人魔-血海绞杀"
local _____8840_6D77_7EDE_6740_5DF2_6CE8_518C = false
local _____8840_6D77_5F39_5E55_6570_636E_8868 = {}
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and not IsUnitType(unit, UNIT_TYPE_DEAD) and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
local function _____521B_5EFA_8840_6D77_7EDE_6740_65B9_5411_89D2_5EA6_5217_8868(_____9762_5411_89D2_5EA6, _____65B9_5411_6570)
    local _____65B9_5411_89D2_5EA6_5217_8868 = {}
    do
        local i = 1
        while i <= _____65B9_5411_6570 do
            _____65B9_5411_89D2_5EA6_5217_8868[i] = _____9762_5411_89D2_5EA6 + 90 * i
            i = i + 1
        end
    end
    return _____65B9_5411_89D2_5EA6_5217_8868
end
local function _____76EE_6807_662FBoss_654C_5BF9_82F1_96C4(boss, target)
    if not _____5355_4F4D_5B58_6D3B(target) then
        return false
    end
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            if heroes[i + 1] == target then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function ____on_8840_6D77_76EE_6807_7B5B_9009(target, barrageId)
    if barrageId == nil then
        return false
    end
    local data = _____8840_6D77_5F39_5E55_6570_636E_8868[barrageId]
    return data ~= nil and _____76EE_6807_662FBoss_654C_5BF9_82F1_96C4(data["Boss单位"], target)
end
local function ____on_8840_6D77_547D_4E2D(target, barrageId)
    if barrageId == nil then
        return
    end
    local data = _____8840_6D77_5F39_5E55_6570_636E_8868[barrageId]
    if data == nil or not _____5355_4F4D_5B58_6D3B(data["Boss单位"]) or not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    local cfg = _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["血海绞杀"]
    _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
        ["来源"] = data["Boss单位"],
        ["目标"] = target,
        ["技能ID"] = _____8840_6D77_7EDE_6740_6280_80FDID,
        ["技能实例ID"] = data["技能实例ID"],
        ["伤害公式"] = {["来源攻击力比例"] = cfg["攻击力比例"]},
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["标签"] = "杀戮食人魔·血海绞杀"
    })
    _____65BD_52A0_5FEB_901F_63A7_5236Buff(
        data["Boss单位"],
        target,
        0,
        cfg["眩晕秒"],
        "杀戮食人魔-血海绞杀",
        "技能"
    )
end
local function ____on_8840_6D77Tick(instance, delta)
    if instance == nil or instance.id == nil then
        return
    end
    local data = _____8840_6D77_5F39_5E55_6570_636E_8868[instance.id]
    if data == nil then
        return
    end
    data["特效累计秒"] = data["特效累计秒"] + delta
    if data["特效累计秒"] < 0.2 then
        return
    end
    data["特效累计秒"] = 0
    local cfg = _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["血海绞杀"]
    EC_CreateEffect(
        cfg["弹幕模型"],
        instance["当前X"],
        instance["当前Y"],
        0,
        0,
        1,
        1,
        1
    )
    EC_CreateEffect(
        cfg["命中特效"],
        instance["当前X"],
        instance["当前Y"],
        0,
        0,
        1,
        1,
        1
    )
end
local function ____on_8840_6D77_7ED3_675F(_reason, barrageId)
    if barrageId == nil then
        return
    end
    __TS__Delete(_____8840_6D77_5F39_5E55_6570_636E_8868, barrageId)
end
local function ____on_8840_6D77_7EDE_6740_53D1_5C04(variable)
    local data = variable
    if data == nil then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(data["上下文"]["Boss单位"]) then
        return
    end
    local boss = data["上下文"]["Boss单位"]
    local cfg = _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["血海绞杀"]
    _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(boss, _____8840_6D77_7EDE_6740_65E0_654C_6765_6E90)
    if #data["方向角度列表"] ~= cfg["方向数"] then
        return
    end
    do
        local i = 0
        while i < #data["方向角度列表"] do
            do
                local angle = data["方向角度列表"][i + 1]
                local projectile = _____521B_5EFA_539F_751F_5F39_5E55({
                    ["所有者"] = boss,
                    ["载体模式"] = "特效",
                    X = GetUnitX(boss),
                    Y = GetUnitY(boss),
                    ["方向角"] = angle,
                    ["速度"] = cfg["弹幕速度"],
                    ["生命周期"] = cfg["弹幕持续秒"],
                    ["最大距离"] = cfg["弹幕速度"] * cfg["弹幕持续秒"],
                    ["命中半径"] = cfg["命中半径"],
                    ["影响目标"] = "敌方",
                    ["碰撞消失"] = false,
                    ["每单位最大命中次数"] = 1,
                    ["目标筛选"] = ____on_8840_6D77_76EE_6807_7B5B_9009,
                    ["on命中"] = ____on_8840_6D77_547D_4E2D,
                    onTick = ____on_8840_6D77Tick,
                    ["on结束"] = ____on_8840_6D77_7ED3_675F
                })
                local _____5F39_5E55ID = projectile ~= nil and projectile["弹幕ID"] or nil
                if _____5F39_5E55ID == nil then
                    goto __continue27
                end
                _____8840_6D77_5F39_5E55_6570_636E_8868[_____5F39_5E55ID] = {["Boss单位"] = boss, ["技能实例ID"] = data["技能实例ID"], ["特效累计秒"] = 0.2}
            end
            ::__continue27::
            i = i + 1
        end
    end
end
local function ____on_8840_6D77_7EDE_6740_786C_76F4_7ED3_675F(variable)
    local data = variable
    if data == nil then
        return
    end
    if _____5355_4F4D_5B58_6D3B(data["上下文"]["Boss单位"]) then
        _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(data["上下文"]["Boss单位"], _____8840_6D77_7EDE_6740_65E0_654C_6765_6E90)
    end
    _____5173_95ED_541F_5531_6761("常规技能")
end
local function ____on_8840_6D77_7EDE_6740_5F00_59CB(variable)
    local data = variable
    if data == nil then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(data["上下文"]["Boss单位"]) then
        return
    end
    local boss = data["上下文"]["Boss单位"]
    local cfg = _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["血海绞杀"]
    local currentLife = GetUnitState(boss, UNIT_STATE_LIFE)
    local cost = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * cfg["最大生命消耗比例"]
    local _____6263_8840_540E_751F_547D = currentLife - cost > 1 and currentLife - cost or 1
    SetUnitState(boss, UNIT_STATE_LIFE, _____6263_8840_540E_751F_547D)
    _____5F00_59CB_786C_76F4(boss, cfg["施法硬直秒"])
    _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(boss, _____8840_6D77_7EDE_6740_65E0_654C_6765_6E90)
    SetUnitAnimationByIndex(boss, cfg["动画编号"])
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({
        ["通道"] = "常规技能",
        ["总时长"] = cfg["施法硬直秒"],
        ["颜色ID"] = 1,
        ["标题文本"] = "血海绞杀",
        ["提示文本"] = "四方向血海即将涌出"
    })
    local facing = GetUnitFacing(boss)
    data["方向角度列表"] = _____521B_5EFA_8840_6D77_7EDE_6740_65B9_5411_89D2_5EA6_5217_8868(facing, cfg["方向数"])
    do
        local i = 0
        while i < #data["方向角度列表"] do
            EC_CreateEffect(
                "war3mapImported\\bossjinggaoh.mdl",
                GetUnitX(boss),
                GetUnitY(boss),
                0,
                data["方向角度列表"][i + 1],
                2.8,
                1,
                1
            )
            i = i + 1
        end
    end
    addDelayedCallback(cfg["生效延迟秒"] * 1000, ____on_8840_6D77_7EDE_6740_53D1_5C04, data)
    addDelayedCallback(cfg["施法硬直秒"] * 1000, ____on_8840_6D77_7EDE_6740_786C_76F4_7ED3_675F, data)
end
____exports["释放杀戮食人魔血海绞杀"] = function(context, skillInstanceId)
    if not _____5355_4F4D_5B58_6D3B(context["Boss单位"]) then
        return false
    end
    addDelayedCallback(30, ____on_8840_6D77_7EDE_6740_5F00_59CB, {["上下文"] = context, ["技能实例ID"] = skillInstanceId, ["方向角度列表"] = {}})
    return true
end
local function ____on_8840_6D77_7EDE_6740_6280_80FD_58F3_91CA_653E(context, _boss, skillInstanceId)
    ____exports["释放杀戮食人魔血海绞杀"](context, skillInstanceId)
end
____exports["注册杀戮食人魔血海绞杀"] = function()
    if _____8840_6D77_7EDE_6740_5DF2_6CE8_518C then
        return
    end
    _____8840_6D77_7EDE_6740_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "杀戮食人魔-血海绞杀",
        ["单位类型ID"] = _____6740_622E_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____8840_6D77_7EDE_6740_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587,
        ["释放技能"] = ____on_8840_6D77_7EDE_6740_6280_80FD_58F3_91CA_653E,
        ["技能实例持续时间秒"] = 4
    })
end
return ____exports
