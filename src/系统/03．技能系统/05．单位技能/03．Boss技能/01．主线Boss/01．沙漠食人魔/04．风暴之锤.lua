local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.00．配置")
local _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["沙漠食人魔单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.02．数值与表现配置")
local _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["沙漠食人魔技能配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____01_FF0ETS_539F_751F_5F39_5E55 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____01_FF0ETS_539F_751F_5F39_5E55["创建原生弹幕"]
local _____83B7_53D6_539F_751F_5F39_5E55 = ____01_FF0ETS_539F_751F_5F39_5E55["获取原生弹幕"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_1["启动基础施法时间线"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_2["施加快速控制Buff"]
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_3["获取Boss技能随机敌对英雄"]
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_3["获取Boss技能敌对英雄列表"]
local ____require_result_4 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
local _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = ____require_result_4["取当前有效玩家人数"]
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_5.EC_CreateEffect
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_6.stringToFourCCSafe
local jass = require("jass.common")
local japi = require("jass.japi")
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local SetUnitStateJapi = japi.SetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____98CE_66B4_4E4B_9524_6280_80FDID = stringToFourCCSafe(_____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["技能ID"]["风暴之锤"])
local _____98CE_66B4_4E4B_9524_5DF2_6CE8_518C = false
local _____98CE_66B4_4E4B_9524_5F85_53D1_961F_5217 = {}
local _____98CE_66B4_4E4B_9524_5F39_5E55_8868 = {}
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
local function _____53D6_98CE_66B4_4E4B_9524_76EE_6807(boss)
    local spellTarget = GetSpellTargetUnit()
    if _____76EE_6807_662FBoss_654C_5BF9_82F1_96C4(boss, spellTarget) then
        return spellTarget
    end
    return _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss)
end
local function ____on_98CE_66B4_4E4B_9524_76EE_6807_7B5B_9009(target, barrageId)
    if barrageId == nil then
        debugLogForce("沙漠食人魔-风暴之锤", "目标筛选跳过：弹幕 ID 为空")
        return false
    end
    local data = _____98CE_66B4_4E4B_9524_5F39_5E55_8868[barrageId]
    return data ~= nil and _____76EE_6807_662FBoss_654C_5BF9_82F1_96C4(data["Boss单位"], target)
end
local function ____on_98CE_66B4_4E4B_9524_547D_4E2D(hitUnit, barrageId)
    if barrageId == nil then
        debugLogForce("沙漠食人魔-风暴之锤", "命中回调跳过：弹幕 ID 为空")
        return
    end
    local data = _____98CE_66B4_4E4B_9524_5F39_5E55_8868[barrageId]
    if data == nil or not _____5355_4F4D_5B58_6D3B(data["Boss单位"]) or not _____5355_4F4D_5B58_6D3B(hitUnit) then
        return
    end
    local cfg = _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E["风暴之锤"]
    local instance = _____83B7_53D6_539F_751F_5F39_5E55(barrageId)
    local x = instance ~= nil and instance["当前X"] or GetUnitX(hitUnit)
    local y = instance ~= nil and instance["当前Y"] or GetUnitY(hitUnit)
    local actualMultiplier = hitUnit == data["指定目标"] and 1 or cfg["非指定目标倍率"]
    local damageMultiplier = data["基础倍率"] * actualMultiplier
    local stunDuration = data["基础眩晕秒"] * actualMultiplier
    debugLogForce(
        "沙漠食人魔-风暴之锤",
        "弹幕命中",
        "barrageId=",
        barrageId,
        "bossHid=",
        GetHandleId(data["Boss单位"]),
        "hitHid=",
        GetHandleId(hitUnit),
        "指定目标Hid=",
        GetHandleId(data["指定目标"]),
        "actualMultiplier=",
        actualMultiplier,
        "damageMultiplier=",
        damageMultiplier,
        "stunDuration=",
        stunDuration
    )
    EC_CreateEffect(
        cfg["爆炸特效"],
        x,
        y,
        0,
        270,
        2.5,
        1,
        1
    )
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(data["Boss单位"])
    local radiusSquared = cfg["爆炸范围"] * cfg["爆炸范围"]
    local _____547D_4E2D_76EE_6807_6570_91CF = 0
    do
        local i = 0
        while i < #heroes do
            do
                local target = heroes[i + 1]
                if not _____5355_4F4D_5B58_6D3B(target) then
                    goto __continue17
                end
                local dx = GetUnitX(target) - x
                local dy = GetUnitY(target) - y
                if dx * dx + dy * dy > radiusSquared then
                    goto __continue17
                end
                _____547D_4E2D_76EE_6807_6570_91CF = _____547D_4E2D_76EE_6807_6570_91CF + 1
                _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                    ["来源"] = data["Boss单位"],
                    ["目标"] = target,
                    ["技能ID"] = _____98CE_66B4_4E4B_9524_6280_80FDID,
                    ["技能实例ID"] = data["技能实例ID"],
                    ["伤害公式"] = {["来源攻击力比例"] = damageMultiplier},
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_PLANT,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["标签"] = "沙漠食人魔·风暴之锤"
                })
                _____65BD_52A0_5FEB_901F_63A7_5236Buff(
                    data["Boss单位"],
                    target,
                    0,
                    stunDuration,
                    "沙漠食人魔-风暴之锤",
                    "技能"
                )
            end
            ::__continue17::
            i = i + 1
        end
    end
    debugLogForce(
        "沙漠食人魔-风暴之锤",
        "爆炸结算完成",
        "barrageId=",
        barrageId,
        "targetCount=",
        _____547D_4E2D_76EE_6807_6570_91CF,
        "centerX=",
        x,
        "centerY=",
        y
    )
end
local function ____on_98CE_66B4_4E4B_9524_7ED3_675F(reason, barrageId)
    if barrageId == nil then
        debugLogForce("沙漠食人魔-风暴之锤", "弹幕结束跳过清理：弹幕 ID 为空", "reason=", reason)
        return
    end
    debugLogForce(
        "沙漠食人魔-风暴之锤",
        "弹幕结束",
        "barrageId=",
        barrageId,
        "reason=",
        reason
    )
    __TS__Delete(_____98CE_66B4_4E4B_9524_5F39_5E55_8868, barrageId)
end
local function ____on_98CE_66B4_4E4B_9524_751F_6548()
    debugLogForce("沙漠食人魔-风暴之锤", "施法生效回调", "pendingCount=", #_____98CE_66B4_4E4B_9524_5F85_53D1_961F_5217)
    while #_____98CE_66B4_4E4B_9524_5F85_53D1_961F_5217 > 0 do
        do
            local data = _____98CE_66B4_4E4B_9524_5F85_53D1_961F_5217[1]
            __TS__ArraySplice(_____98CE_66B4_4E4B_9524_5F85_53D1_961F_5217, 0, 1)
            if data == nil or not _____5355_4F4D_5B58_6D3B(data["Boss单位"]) or not _____5355_4F4D_5B58_6D3B(data["指定目标"]) then
                debugLogForce(
                    "沙漠食人魔-风暴之锤",
                    "弹幕创建跳过",
                    "dataValid=",
                    data ~= nil,
                    "bossAlive=",
                    data ~= nil and _____5355_4F4D_5B58_6D3B(data["Boss单位"]),
                    "targetAlive=",
                    data ~= nil and _____5355_4F4D_5B58_6D3B(data["指定目标"])
                )
                goto __continue23
            end
            local cfg = _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E["风暴之锤"]
            local singlePlayerMultiplier = _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570() <= 1 and cfg["单人倍率"] or 1
            local projectileLife = cfg["弹幕生命值"]
            local projectile = _____521B_5EFA_539F_751F_5F39_5E55({
                ["所有者"] = data["Boss单位"],
                ["轨迹类型"] = "追踪",
                ["指定目标"] = data["指定目标"],
                ["速度"] = cfg["速度"],
                ["生命周期"] = cfg["生命周期秒"],
                ["命中半径"] = cfg["命中半径"],
                ["影响目标"] = "敌方",
                ["碰撞消失"] = true,
                ["最大总命中次数"] = 1,
                ["弹幕生命值"] = projectileLife,
                ["可攻击摧毁"] = true,
                ["模型"] = cfg["模型"],
                ["缩放"] = 3,
                ["飞行高度"] = 325,
                ["目标筛选"] = ____on_98CE_66B4_4E4B_9524_76EE_6807_7B5B_9009,
                ["on命中"] = ____on_98CE_66B4_4E4B_9524_547D_4E2D,
                ["on结束"] = ____on_98CE_66B4_4E4B_9524_7ED3_675F
            })
            local _____5F39_5E55ID = projectile ~= nil and projectile["弹幕ID"] or nil
            debugLogForce(
                "沙漠食人魔-风暴之锤",
                "弹幕创建结果",
                "barrageId=",
                _____5F39_5E55ID,
                "projectileValid=",
                projectile ~= nil,
                "bossHid=",
                GetHandleId(data["Boss单位"]),
                "targetHid=",
                GetHandleId(data["指定目标"])
            )
            if _____5F39_5E55ID == nil then
                debugLogForce("沙漠食人魔-风暴之锤", "弹幕数据登记跳过：弹幕 ID 为空")
                return
            end
            _____98CE_66B4_4E4B_9524_5F39_5E55_8868[_____5F39_5E55ID] = {
                ["Boss单位"] = data["Boss单位"],
                ["指定目标"] = data["指定目标"],
                ["技能实例ID"] = data["技能实例ID"],
                ["基础倍率"] = cfg["攻击力比例"] * singlePlayerMultiplier,
                ["基础眩晕秒"] = cfg["眩晕秒"] * singlePlayerMultiplier
            }
            if projectile["弹幕单位"] ~= nil and projectile["弹幕单位"] ~= 0 then
                SetUnitStateJapi(projectile["弹幕单位"], UNIT_STATE_MAX_LIFE, projectileLife)
                SetUnitState(projectile["弹幕单位"], UNIT_STATE_LIFE, projectileLife)
            end
            debugLogForce(
                "沙漠食人魔-风暴之锤",
                "弹幕已创建",
                "barrageId=",
                _____5F39_5E55ID,
                "bossHid=",
                GetHandleId(data["Boss单位"]),
                "targetHid=",
                GetHandleId(data["指定目标"]),
                "life=",
                projectileLife,
                "singlePlayerMultiplier=",
                singlePlayerMultiplier
            )
            return
        end
        ::__continue23::
    end
end
____exports["释放沙漠食人魔风暴之锤"] = function(boss, skillInstanceId)
    if not _____5355_4F4D_5B58_6D3B(boss) then
        debugLogForce("沙漠食人魔-风暴之锤", "释放拒绝：Boss无效")
        return false
    end
    local target = _____53D6_98CE_66B4_4E4B_9524_76EE_6807(boss)
    if not _____5355_4F4D_5B58_6D3B(target) then
        debugLogForce(
            "沙漠食人魔-风暴之锤",
            "释放拒绝：目标无效",
            "bossHid=",
            GetHandleId(boss),
            "skillInstanceId=",
            skillInstanceId
        )
        return false
    end
    _____98CE_66B4_4E4B_9524_5F85_53D1_961F_5217[#_____98CE_66B4_4E4B_9524_5F85_53D1_961F_5217 + 1] = {["Boss单位"] = boss, ["指定目标"] = target, ["技能实例ID"] = skillInstanceId}
    debugLogForce(
        "沙漠食人魔-风暴之锤",
        "施法开始",
        "bossHid=",
        GetHandleId(boss),
        "targetHid=",
        GetHandleId(target),
        "skillInstanceId=",
        skillInstanceId,
        "pendingCount=",
        #_____98CE_66B4_4E4B_9524_5F85_53D1_961F_5217
    )
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["名称"] = "沙漠食人魔-风暴之锤",
        ["施法者"] = boss,
        ["目标单位"] = target,
        ["硬直秒"] = 1,
        ["动画编号"] = 5,
        ["恢复动画编号"] = 1,
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = 1,
            ["颜色ID"] = 3,
            ["标题文本"] = "风暴之锤",
            ["提示文本"] = "追踪重锤即将发射"
        },
        ["on生效"] = ____on_98CE_66B4_4E4B_9524_751F_6548
    })
    return true
end
local function ____on_98CE_66B4_4E4B_9524_6280_80FD_58F3_91CA_653E(_context, boss, skillInstanceId)
    ____exports["释放沙漠食人魔风暴之锤"](boss, skillInstanceId)
end
____exports["注册沙漠食人魔风暴之锤"] = function()
    if _____98CE_66B4_4E4B_9524_5DF2_6CE8_518C then
        return
    end
    _____98CE_66B4_4E4B_9524_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "沙漠食人魔-风暴之锤",
        ["单位类型ID"] = _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____98CE_66B4_4E4B_9524_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6C99_6F20_98DF_4EBA_9B54_6280_80FD_4E0A_4E0B_6587,
        ["释放技能"] = ____on_98CE_66B4_4E4B_9524_6280_80FD_58F3_91CA_653E,
        ["技能实例持续时间秒"] = 7
    })
end
return ____exports
