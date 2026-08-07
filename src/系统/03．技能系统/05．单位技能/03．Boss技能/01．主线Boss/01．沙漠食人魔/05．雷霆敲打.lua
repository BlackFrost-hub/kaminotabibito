local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.00．配置")
local _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["沙漠食人魔单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.02．数值与表现配置")
local _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["沙漠食人魔技能配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____01_FF0ETS_539F_751F_5F39_5E55 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____01_FF0ETS_539F_751F_5F39_5E55["创建原生弹幕"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_1["施加快速减速Buff"]
local ____require_result_2 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_2["获取Boss技能敌对英雄列表"]
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168 = ____require_result_3["暂停并设置无敌安全"]
local _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168 = ____require_result_3["解除暂停并取消无敌安全"]
local ____require_result_4 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_4["显示常规技能吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_4["关闭吟唱条"]
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_5.EC_CreateEffect
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_6.stringToFourCCSafe
local jass = require("jass.common")
local GetUnitFacing = jass.GetUnitFacing
local SetUnitFacing = jass.SetUnitFacing
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local GetUnitState = jass.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____96F7_9706_6572_6253_65E0_654C_6765_6E90 = "沙漠食人魔-雷霆敲打"
local _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____96F7_9706_6572_6253_6280_80FDID = stringToFourCCSafe(_____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["技能ID"]["雷霆敲打"])
local _____96F7_9706_6572_6253_65B9_5411_6570 = 4
local _____96F7_9706_6572_6253_5DF2_6CE8_518C = false
local _____96F7_9706_51B2_51FB_6CE2_6570_636E_8868 = {}
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and not IsUnitType(unit, UNIT_TYPE_DEAD) and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
local function _____83B7_53D6_6C99_6F20_98DF_4EBA_9B54_6280_80FD_4E0A_4E0B_6587(boss)
    local _____5355_4F4D_5B58_6D3B_result_7
    if _____5355_4F4D_5B58_6D3B(boss) then
        _____5355_4F4D_5B58_6D3B_result_7 = boss
    else
        _____5355_4F4D_5B58_6D3B_result_7 = nil
    end
    return _____5355_4F4D_5B58_6D3B_result_7
end
local function _____521B_5EFA_96F7_9706_6572_6253_65B9_5411_89D2_5EA6_5217_8868(_____9762_5411_89D2_5EA6)
    local _____65B9_5411_89D2_5EA6_5217_8868 = {}
    do
        local i = 1
        while i <= _____96F7_9706_6572_6253_65B9_5411_6570 do
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
local function ____on_96F7_9706_51B2_51FB_6CE2_76EE_6807_7B5B_9009(target, barrageId)
    if barrageId == nil then
        return false
    end
    local data = _____96F7_9706_51B2_51FB_6CE2_6570_636E_8868[barrageId]
    return data ~= nil and _____76EE_6807_662FBoss_654C_5BF9_82F1_96C4(data["Boss单位"], target)
end
local function ____on_96F7_9706_51B2_51FB_6CE2_547D_4E2D(target, barrageId)
    if barrageId == nil then
        return
    end
    local data = _____96F7_9706_51B2_51FB_6CE2_6570_636E_8868[barrageId]
    if data == nil or not _____5355_4F4D_5B58_6D3B(data["Boss单位"]) or not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    local cfg = _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E["雷霆敲打"]
    _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
        ["来源"] = data["Boss单位"],
        ["目标"] = target,
        ["技能ID"] = _____96F7_9706_6572_6253_6280_80FDID,
        ["技能实例ID"] = data["技能实例ID"],
        ["伤害公式"] = {["来源攻击力比例"] = cfg["攻击力比例"]},
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_PLANT,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["标签"] = "沙漠食人魔·雷霆敲打"
    })
    _____65BD_52A0_5FEB_901F_51CF_901FBuff(
        data["Boss单位"],
        target,
        0,
        cfg["减速比例"],
        cfg["减速秒"],
        "沙漠食人魔-雷霆敲打",
        "技能"
    )
end
local function ____on_96F7_9706_51B2_51FB_6CE2Tick(instance, delta)
    if instance == nil or instance.id == nil then
        return
    end
    local data = _____96F7_9706_51B2_51FB_6CE2_6570_636E_8868[instance.id]
    if data == nil then
        return
    end
    data["特效累计秒"] = data["特效累计秒"] + delta
    if data["特效累计秒"] < 0.2 then
        return
    end
    data["特效累计秒"] = 0
    EC_CreateEffect(
        _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E["雷霆敲打"]["弹幕模型"],
        instance["当前X"],
        instance["当前Y"],
        0,
        0,
        1,
        1,
        1
    )
end
local function ____on_96F7_9706_51B2_51FB_6CE2_7ED3_675F(reason, barrageId)
    if barrageId == nil then
        return
    end
    __TS__Delete(_____96F7_9706_51B2_51FB_6CE2_6570_636E_8868, barrageId)
end
local function ____on_96F7_9706_6572_6253_53D1_5C04(variable)
    local round = variable
    if round == nil or not _____5355_4F4D_5B58_6D3B(round["施法数据"]["Boss单位"]) then
        return
    end
    local cfg = _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E["雷霆敲打"]
    if #round["方向角度列表"] ~= _____96F7_9706_6572_6253_65B9_5411_6570 then
        return
    end
    do
        local i = 0
        while i < #round["方向角度列表"] do
            do
                local angle = round["方向角度列表"][i + 1]
                local projectile = _____521B_5EFA_539F_751F_5F39_5E55({
                    ["所有者"] = round["施法数据"]["Boss单位"],
                    ["载体模式"] = "特效",
                    X = GetUnitX(round["施法数据"]["Boss单位"]),
                    Y = GetUnitY(round["施法数据"]["Boss单位"]),
                    ["方向角"] = angle,
                    ["速度"] = cfg["弹幕速度"],
                    ["生命周期"] = cfg["弹幕持续秒"],
                    ["最大距离"] = cfg["弹幕速度"] * cfg["弹幕持续秒"],
                    ["命中半径"] = cfg["命中半径"],
                    ["影响目标"] = "敌方",
                    ["碰撞消失"] = false,
                    ["每单位最大命中次数"] = 1,
                    ["目标筛选"] = ____on_96F7_9706_51B2_51FB_6CE2_76EE_6807_7B5B_9009,
                    ["on命中"] = ____on_96F7_9706_51B2_51FB_6CE2_547D_4E2D,
                    onTick = ____on_96F7_9706_51B2_51FB_6CE2Tick,
                    ["on结束"] = ____on_96F7_9706_51B2_51FB_6CE2_7ED3_675F
                })
                local _____5F39_5E55ID = projectile ~= nil and projectile["弹幕ID"] or nil
                if _____5F39_5E55ID == nil then
                    goto __continue27
                end
                _____96F7_9706_51B2_51FB_6CE2_6570_636E_8868[_____5F39_5E55ID] = {["Boss单位"] = round["施法数据"]["Boss单位"], ["技能实例ID"] = round["施法数据"]["技能实例ID"], ["特效累计秒"] = 0.2}
            end
            ::__continue27::
            i = i + 1
        end
    end
end
local function ____on_96F7_9706_6572_6253_8F6C_5411(variable)
    local round = variable
    if round == nil or not _____5355_4F4D_5B58_6D3B(round["施法数据"]["Boss单位"]) then
        return
    end
    SetUnitFacing(round["施法数据"]["Boss单位"], round["面向角度"] + _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E["雷霆敲打"]["每轮转向角度"])
end
local function ____on_96F7_9706_6572_6253_8F6E_6B21(variable)
    local data = variable
    if data == nil or not _____5355_4F4D_5B58_6D3B(data["Boss单位"]) then
        if data ~= nil and data["周期ID"] > 0 then
            removePeriodicCallback(data["周期ID"])
        end
        return
    end
    local cfg = _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E["雷霆敲打"]
    data["已执行轮数"] = data["已执行轮数"] + 1
    SetUnitAnimationByIndex(data["Boss单位"], cfg["动画编号"])
    local facing = GetUnitFacing(data["Boss单位"])
    local round = {
        ["施法数据"] = data,
        ["面向角度"] = facing,
        ["方向角度列表"] = _____521B_5EFA_96F7_9706_6572_6253_65B9_5411_89D2_5EA6_5217_8868(facing)
    }
    do
        local i = 0
        while i < #round["方向角度列表"] do
            EC_CreateEffect(
                cfg["预警特效"],
                GetUnitX(data["Boss单位"]),
                GetUnitY(data["Boss单位"]),
                0,
                round["方向角度列表"][i + 1],
                2.8,
                1,
                1
            )
            i = i + 1
        end
    end
    addDelayedCallback(cfg["预警秒"] * 1000, ____on_96F7_9706_6572_6253_53D1_5C04, round)
    if data["已执行轮数"] < cfg["轮数"] then
        addDelayedCallback(850, ____on_96F7_9706_6572_6253_8F6C_5411, round)
    end
    if data["已执行轮数"] >= cfg["轮数"] and data["周期ID"] > 0 then
        removePeriodicCallback(data["周期ID"])
        data["周期ID"] = 0
    end
end
local function ____on_96F7_9706_6572_6253_7ED3_675F(variable)
    local data = variable
    if data == nil then
        return
    end
    if data["周期ID"] > 0 then
        removePeriodicCallback(data["周期ID"])
    end
    data["周期ID"] = 0
    _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(data["Boss单位"], _____96F7_9706_6572_6253_65E0_654C_6765_6E90)
    _____5173_95ED_541F_5531_6761("常规技能")
end
____exports["释放沙漠食人魔雷霆敲打"] = function(boss, skillInstanceId)
    if not _____5355_4F4D_5B58_6D3B(boss) then
        return false
    end
    local cfg = _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E["雷霆敲打"]
    local data = {["Boss单位"] = boss, ["技能实例ID"] = skillInstanceId, ["已执行轮数"] = 0, ["周期ID"] = 0}
    local _____6700_540E_4E00_8F6E_53D1_5C04_79D2 = cfg["轮次间隔秒"] * cfg["轮数"] + cfg["预警秒"]
    local _____603B_6301_7EED_79D2 = _____6700_540E_4E00_8F6E_53D1_5C04_79D2 + 0.1
    _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(boss, _____96F7_9706_6572_6253_65E0_654C_6765_6E90)
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({
        ["通道"] = "常规技能",
        ["总时长"] = _____603B_6301_7EED_79D2,
        ["颜色ID"] = 3,
        ["标题文本"] = "雷霆敲打",
        ["提示文本"] = "连续四轮雷霆冲击"
    })
    data["周期ID"] = addPeriodicCallback(cfg["轮次间隔秒"] * 1000, ____on_96F7_9706_6572_6253_8F6E_6B21, data)
    addDelayedCallback(_____603B_6301_7EED_79D2 * 1000, ____on_96F7_9706_6572_6253_7ED3_675F, data)
    return true
end
local function ____on_96F7_9706_6572_6253_6280_80FD_58F3_91CA_653E(_context, boss, skillInstanceId)
    ____exports["释放沙漠食人魔雷霆敲打"](boss, skillInstanceId)
end
____exports["注册沙漠食人魔雷霆敲打"] = function()
    if _____96F7_9706_6572_6253_5DF2_6CE8_518C then
        return
    end
    _____96F7_9706_6572_6253_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "沙漠食人魔-雷霆敲打",
        ["单位类型ID"] = _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____96F7_9706_6572_6253_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6C99_6F20_98DF_4EBA_9B54_6280_80FD_4E0A_4E0B_6587,
        ["释放技能"] = ____on_96F7_9706_6572_6253_6280_80FD_58F3_91CA_653E,
        ["技能实例持续时间秒"] = 8
    })
end
return ____exports
