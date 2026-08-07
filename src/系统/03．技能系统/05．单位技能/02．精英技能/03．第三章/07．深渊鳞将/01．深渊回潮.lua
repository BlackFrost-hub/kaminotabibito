local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local ____exports = {}
local _____6F6E_6C50_7275_5F15_7ED3_675F, _____7ED3_7B97_6F6E_6C50_7275_5F15, _____5F00_59CB_7275_5F15, _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3, getServerTime, DAMAGE_TYPE_NORMAL, ATTACK_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS, _____7275_5F15_6765_6E90_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.02．精英技能.03．第三章.07．深渊鳞将.00．配置")
local _____6DF1_6E0A_9CDE_5C06_914D_7F6E = ____00_FF0E_914D_7F6E["深渊鳞将配置"]
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.00．封印守卫战公共.01．共享")
local _____5355_4F4D_5904_4E8E_786C_63A7_5236 = ____01_FF0E_5171_4EAB["单位处于硬控制"]
local _____547D_4EE4_653B_51FB_76EE_6807 = ____01_FF0E_5171_4EAB["命令攻击目标"]
local _____53D6_4E24_70B9_65B9_5411_89D2 = ____01_FF0E_5171_4EAB["取两点方向角"]
local _____53D6_5355_4F4DX = ____01_FF0E_5171_4EAB["取单位X"]
local _____53D6_5355_4F4DY = ____01_FF0E_5171_4EAB["取单位Y"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____01_FF0E_5171_4EAB["读取单位攻击力"]
local _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9 = ____01_FF0E_5171_4EAB["取单位距离平方"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55 = ____01_FF0E_5171_4EAB["读取封印守卫战敌人记录"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868 = ____01_FF0E_5171_4EAB["读取封印守卫战玩家英雄列表"]
local _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B = ____01_FF0E_5171_4EAB["封印守卫战单位存活"]
local _____662F_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4 = ____01_FF0E_5171_4EAB["是封印守卫战玩家英雄"]
local _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548 = ____01_FF0E_5171_4EAB["创建封印守卫战点特效"]
function _____6F6E_6C50_7275_5F15_7ED3_675F(unit, _reason, pullId)
    local record = _____7275_5F15_6765_6E90_8868[pullId]
    if record == nil then
        return
    end
    __TS__Delete(_____7275_5F15_6765_6E90_8868, pullId)
    local ____opt_15 = record["附加状态"]
    local state = ____opt_15 and ____opt_15["潮汐牵引"]
    if state == nil then
        return
    end
    local index = __TS__ArrayIndexOf(state["牵引ID列表"], pullId)
    if index >= 0 then
        __TS__ArraySplice(state["牵引ID列表"], index, 1)
    end
    if state["清理中"] or #state["牵引ID列表"] > 0 then
        return
    end
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"]) then
        _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548({
            ["模型路径"] = _____6DF1_6E0A_9CDE_5C06_914D_7F6E["牵引结束特效"],
            X = _____53D6_5355_4F4DX(record["单位"]),
            Y = _____53D6_5355_4F4DY(record["单位"]),
            Z = 0,
            ["缩放"] = 1,
            ["持续秒"] = 1.2
        })
    end
    if record["附加状态"] ~= nil then
        record["附加状态"]["回潮封锁毫秒"] = getServerTime() + _____6DF1_6E0A_9CDE_5C06_914D_7F6E["回潮封锁秒"] * 1000
        __TS__Delete(record["附加状态"], "潮汐牵引")
    end
end
function _____7ED3_7B97_6F6E_6C50_7275_5F15(record)
    local ____temp_19 = not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"])
    if not ____temp_19 then
        local ____opt_17 = record["附加状态"]
        ____temp_19 = (____opt_17 and ____opt_17["潮汐牵引"]) ~= nil
    end
    if ____temp_19 then
        return
    end
    local now = getServerTime()
    local ____opt_20 = record["附加状态"]
    local ____temp_22 = ____opt_20 and ____opt_20["潮汐牵引冷却毫秒"]
    if ____temp_22 == nil then
        ____temp_22 = 0
    end
    if ____temp_22 > now then
        return
    end
    local heroes = _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868()
    local state = {["牵引ID列表"] = {}, ["清理中"] = false}
    if record["附加状态"] == nil then
        record["附加状态"] = {}
    end
    record["附加状态"]["潮汐牵引"] = state
    _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548({
        ["模型路径"] = _____6DF1_6E0A_9CDE_5C06_914D_7F6E["牵引中心特效"],
        X = _____53D6_5355_4F4DX(record["单位"]),
        Y = _____53D6_5355_4F4DY(record["单位"]),
        Z = 0,
        ["缩放"] = 1,
        ["持续秒"] = _____6DF1_6E0A_9CDE_5C06_914D_7F6E["牵引持续秒"] + 0.4
    })
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(record["单位"]) * _____6DF1_6E0A_9CDE_5C06_914D_7F6E["牵引伤害攻击力比例"]
    do
        local i = 0
        while i < #heroes do
            do
                local target = heroes[i + 1]
                if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) or not _____662F_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4(target) then
                    goto __continue52
                end
                if _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9(record["单位"], target) > _____6DF1_6E0A_9CDE_5C06_914D_7F6E["牵引范围"] * _____6DF1_6E0A_9CDE_5C06_914D_7F6E["牵引范围"] then
                    goto __continue52
                end
                _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                    ["来源"] = record["单位"],
                    ["目标"] = target,
                    ["伤害"] = damage,
                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                    attack = false,
                    ranged = true,
                    attackType = ATTACK_TYPE_NORMAL,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "单位技能",
                    ["标签"] = "第三章-深渊鳞将-潮汐牵引",
                    ["参与技能伤害加成"] = false
                })
                local pullId = _____5F00_59CB_7275_5F15(target, {
                    ["中心单位"] = record["单位"],
                    ["主单位"] = record["单位"],
                    ["持续时间"] = _____6DF1_6E0A_9CDE_5C06_914D_7F6E["牵引持续秒"],
                    ["每秒速度"] = _____6DF1_6E0A_9CDE_5C06_914D_7F6E["牵引拉近距离"] / _____6DF1_6E0A_9CDE_5C06_914D_7F6E["牵引持续秒"],
                    ["最小距离"] = 96,
                    ["最大牵引距离"] = _____6DF1_6E0A_9CDE_5C06_914D_7F6E["牵引拉近距离"],
                    ["到达后结束"] = true,
                    ["检查地形"] = true,
                    ["禁用碰撞"] = true,
                    ["暂停单位"] = false,
                    ["朝向跟随牵引"] = false,
                    ["启用闪电效果"] = false,
                    ["结束回调"] = _____6F6E_6C50_7275_5F15_7ED3_675F
                })
                if pullId > 0 then
                    local ____state__7275_5F15ID_5217_8868_23 = state["牵引ID列表"]
                    ____state__7275_5F15ID_5217_8868_23[#____state__7275_5F15ID_5217_8868_23 + 1] = pullId
                    _____7275_5F15_6765_6E90_8868[pullId] = record
                end
            end
            ::__continue52::
            i = i + 1
        end
    end
    record["附加状态"]["潮汐牵引冷却毫秒"] = now + _____6DF1_6E0A_9CDE_5C06_914D_7F6E["牵引冷却毫秒"]
    if #state["牵引ID列表"] == 0 then
        record["附加状态"]["回潮封锁毫秒"] = now + _____6DF1_6E0A_9CDE_5C06_914D_7F6E["回潮封锁秒"] * 1000
        __TS__Delete(record["附加状态"], "潮汐牵引")
    end
end
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_0["开始充能"]
local _____505C_6B62_5355_4F4D_5145_80FD = ____require_result_0["停止单位充能"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_1["创建技能提示圈"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.05．吸附·牵引.01．牵引系统.03．对外接口")
_____5F00_59CB_7275_5F15 = ____require_result_2["开始牵引"]
local _____505C_6B62_7275_5F15 = ____require_result_2["停止牵引"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_3["造成单体技能伤害"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_4["施加快速减速Buff"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
getServerTime = ____require_result_5.getServerTime
local jass = require("jass.common")
DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
_____7275_5F15_6765_6E90_8868 = {}
local function _____89D2_5EA6_5DEE(first, second)
    local value = first - second
    while value < -180 do
        value = value + 360
    end
    while value > 180 do
        value = value - 360
    end
    return value < 0 and -value or value
end
local function _____6DF1_6E0A_56DE_6F6E_5145_80FD_5468_671F(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "深渊鳞将" or record["充能ID"] ~= chargeId then
        return
    end
    if _____5355_4F4D_5904_4E8E_786C_63A7_5236(unit) then
        _____505C_6B62_5355_4F4D_5145_80FD(unit)
    end
end
local function _____6DF1_6E0A_56DE_6F6E_5145_80FD_5B8C_6210(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "深渊鳞将" or record["充能ID"] ~= chargeId then
        return
    end
    record["充能ID"] = 0
    local ____opt_6 = record["附加状态"]
    local state = ____opt_6 and ____opt_6["深渊回潮"]
    if state == nil then
        return
    end
    local heroes = _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868()
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(unit) * _____6DF1_6E0A_9CDE_5C06_914D_7F6E["回潮伤害攻击力比例"]
    local x = _____53D6_5355_4F4DX(unit)
    local y = _____53D6_5355_4F4DY(unit)
    do
        local i = 0
        while i < 3 do
            local lineAngle = state["朝向"] + (i - 1) * 35
            _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548({
                ["模型路径"] = _____6DF1_6E0A_9CDE_5C06_914D_7F6E["回潮特效"],
                X = x,
                Y = y,
                Z = 0,
                ["Z轴角度"] = lineAngle,
                ["缩放"] = 1,
                ["持续秒"] = 1.4
            })
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #heroes do
            do
                local target = heroes[i + 1]
                if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) or not _____662F_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4(target) then
                    goto __continue14
                end
                local distance = _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9(unit, target)
                if distance > _____6DF1_6E0A_9CDE_5C06_914D_7F6E["回潮半径"] * _____6DF1_6E0A_9CDE_5C06_914D_7F6E["回潮半径"] then
                    goto __continue14
                end
                local targetAngle = _____53D6_4E24_70B9_65B9_5411_89D2(
                    x,
                    y,
                    _____53D6_5355_4F4DX(target),
                    _____53D6_5355_4F4DY(target)
                )
                if _____89D2_5EA6_5DEE(targetAngle, state["朝向"]) > _____6DF1_6E0A_9CDE_5C06_914D_7F6E["回潮扇形角度"] * 0.5 then
                    goto __continue14
                end
                _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                    ["来源"] = unit,
                    ["目标"] = target,
                    ["伤害"] = damage,
                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                    attack = false,
                    ranged = true,
                    attackType = ATTACK_TYPE_NORMAL,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "单位技能",
                    ["标签"] = "第三章-深渊鳞将-深渊回潮",
                    ["参与技能伤害加成"] = false
                })
                _____65BD_52A0_5FEB_901F_51CF_901FBuff(
                    unit,
                    target,
                    _____6DF1_6E0A_9CDE_5C06_914D_7F6E["回潮减速比例"],
                    _____6DF1_6E0A_9CDE_5C06_914D_7F6E["回潮减速比例"],
                    _____6DF1_6E0A_9CDE_5C06_914D_7F6E["回潮减速秒"],
                    "深渊鳞将-深渊回潮",
                    "技能"
                )
            end
            ::__continue14::
            i = i + 1
        end
    end
    if record["附加状态"] ~= nil then
        __TS__Delete(record["附加状态"], "深渊回潮")
    end
    if record["附加状态"] ~= nil then
        record["附加状态"]["深渊回潮冷却毫秒"] = getServerTime() + _____6DF1_6E0A_9CDE_5C06_914D_7F6E["回潮冷却毫秒"]
    end
end
local function _____6DF1_6E0A_56DE_6F6E_5145_80FD_7ED3_675F(unit, reason, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "深渊鳞将" then
        return
    end
    if record["充能ID"] == chargeId then
        record["充能ID"] = 0
    end
    if record["附加状态"] ~= nil then
        __TS__Delete(record["附加状态"], "深渊回潮")
    end
    if reason ~= "完成" and record["附加状态"] ~= nil then
        record["附加状态"]["深渊回潮冷却毫秒"] = getServerTime() + _____6DF1_6E0A_9CDE_5C06_914D_7F6E["回潮冷却毫秒"]
    end
end
____exports["尝试释放深渊回潮"] = function(record)
    if record["充能ID"] ~= 0 or _____5355_4F4D_5904_4E8E_786C_63A7_5236(record["单位"]) then
        return false
    end
    local heroes = _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868()
    if #heroes == 0 then
        return false
    end
    local now = getServerTime()
    local ____opt_8 = record["附加状态"]
    local ____temp_10 = ____opt_8 and ____opt_8["深渊回潮冷却毫秒"]
    if ____temp_10 == nil then
        ____temp_10 = 0
    end
    local ____temp_14 = ____temp_10 > now
    if not ____temp_14 then
        local ____opt_11 = record["附加状态"]
        local ____temp_13 = ____opt_11 and ____opt_11["回潮封锁毫秒"]
        if ____temp_13 == nil then
            ____temp_13 = 0
        end
        ____temp_14 = ____temp_13 > now
    end
    if ____temp_14 then
        return false
    end
    local target = heroes[1]
    local state = {["朝向"] = _____53D6_4E24_70B9_65B9_5411_89D2(
        _____53D6_5355_4F4DX(record["单位"]),
        _____53D6_5355_4F4DY(record["单位"]),
        _____53D6_5355_4F4DX(target),
        _____53D6_5355_4F4DY(target)
    )}
    if record["附加状态"] == nil then
        record["附加状态"] = {}
    end
    record["附加状态"]["深渊回潮"] = state
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "扇形",
        X = _____53D6_5355_4F4DX(record["单位"]),
        Y = _____53D6_5355_4F4DY(record["单位"]),
        ["半径"] = _____6DF1_6E0A_9CDE_5C06_914D_7F6E["回潮半径"],
        ["扇形角度"] = _____6DF1_6E0A_9CDE_5C06_914D_7F6E["回潮扇形角度"],
        ["朝向"] = state["朝向"],
        ["持续时间"] = _____6DF1_6E0A_9CDE_5C06_914D_7F6E["回潮预警秒"],
        ["来源单位"] = record["单位"]
    })
    local id = _____5F00_59CB_5145_80FD(record["单位"], {
        ["持续时间"] = _____6DF1_6E0A_9CDE_5C06_914D_7F6E["回潮预警秒"],
        ["强制硬直"] = true,
        ["显示进度条特效"] = true,
        ["周期回调间隔"] = 0.1,
        ["周期回调"] = _____6DF1_6E0A_56DE_6F6E_5145_80FD_5468_671F,
        ["充能完成回调"] = _____6DF1_6E0A_56DE_6F6E_5145_80FD_5B8C_6210,
        ["结束回调"] = _____6DF1_6E0A_56DE_6F6E_5145_80FD_7ED3_675F
    })
    record["充能ID"] = id
    return id > 0
end
local function _____6F6E_6C50_7275_5F15_5145_80FD_5468_671F(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "深渊鳞将" or record["充能ID"] ~= chargeId then
        return
    end
    if _____5355_4F4D_5904_4E8E_786C_63A7_5236(unit) then
        _____505C_6B62_5355_4F4D_5145_80FD(unit)
    end
end
local function _____6F6E_6C50_7275_5F15_5145_80FD_5B8C_6210(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "深渊鳞将" or record["充能ID"] ~= chargeId then
        return
    end
    record["充能ID"] = 0
    if record["附加状态"] ~= nil then
        __TS__Delete(record["附加状态"], "潮汐牵引准备")
    end
    _____7ED3_7B97_6F6E_6C50_7275_5F15(record)
end
local function _____6F6E_6C50_7275_5F15_5145_80FD_7ED3_675F(unit, reason, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "深渊鳞将" then
        return
    end
    if record["充能ID"] == chargeId then
        record["充能ID"] = 0
    end
    if reason ~= "完成" and record["附加状态"] ~= nil then
        __TS__Delete(record["附加状态"], "潮汐牵引准备")
        record["附加状态"]["潮汐牵引冷却毫秒"] = getServerTime() + _____6DF1_6E0A_9CDE_5C06_914D_7F6E["牵引冷却毫秒"]
    end
end
local function _____91CA_653E_6F6E_6C50_7275_5F15(record)
    local ____temp_26 = record["充能ID"] ~= 0 or _____5355_4F4D_5904_4E8E_786C_63A7_5236(record["单位"])
    if not ____temp_26 then
        local ____opt_24 = record["附加状态"]
        ____temp_26 = (____opt_24 and ____opt_24["潮汐牵引"]) ~= nil
    end
    local ____temp_26_29 = ____temp_26
    if not ____temp_26_29 then
        local ____opt_27 = record["附加状态"]
        ____temp_26_29 = (____opt_27 and ____opt_27["潮汐牵引准备"]) == true
    end
    if ____temp_26_29 then
        return false
    end
    local now = getServerTime()
    local ____opt_30 = record["附加状态"]
    local ____temp_32 = ____opt_30 and ____opt_30["潮汐牵引冷却毫秒"]
    if ____temp_32 == nil then
        ____temp_32 = 0
    end
    if ____temp_32 > now then
        return false
    end
    if record["附加状态"] == nil then
        record["附加状态"] = {}
    end
    record["附加状态"]["潮汐牵引准备"] = true
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "圆形",
        X = _____53D6_5355_4F4DX(record["单位"]),
        Y = _____53D6_5355_4F4DY(record["单位"]),
        ["半径"] = _____6DF1_6E0A_9CDE_5C06_914D_7F6E["牵引范围"],
        ["持续时间"] = _____6DF1_6E0A_9CDE_5C06_914D_7F6E["牵引预警秒"],
        ["来源单位"] = record["单位"]
    })
    local id = _____5F00_59CB_5145_80FD(record["单位"], {
        ["持续时间"] = _____6DF1_6E0A_9CDE_5C06_914D_7F6E["牵引预警秒"],
        ["强制硬直"] = true,
        ["显示进度条特效"] = true,
        ["周期回调间隔"] = 0.1,
        ["周期回调"] = _____6F6E_6C50_7275_5F15_5145_80FD_5468_671F,
        ["充能完成回调"] = _____6F6E_6C50_7275_5F15_5145_80FD_5B8C_6210,
        ["结束回调"] = _____6F6E_6C50_7275_5F15_5145_80FD_7ED3_675F
    })
    record["充能ID"] = id
    if not (id > 0) then
        __TS__Delete(record["附加状态"], "潮汐牵引准备")
    end
    return id > 0
end
____exports["刷新深渊鳞将AI"] = function(record, _____5F53_524D_6BEB_79D2)
    if record["充能ID"] ~= 0 or _____5F53_524D_6BEB_79D2 < record["下次AI毫秒"] then
        return
    end
    record["下次AI毫秒"] = _____5F53_524D_6BEB_79D2 + _____6DF1_6E0A_9CDE_5C06_914D_7F6E["AI刷新毫秒"]
    local ____opt_33 = record["附加状态"]
    local pullState = ____opt_33 and ____opt_33["潮汐牵引"]
    if pullState ~= nil and #pullState["牵引ID列表"] == 0 and record["附加状态"] ~= nil then
        __TS__Delete(record["附加状态"], "潮汐牵引")
    end
    local ____5F53_524D_6BEB_79D2_38 = _____5F53_524D_6BEB_79D2
    local ____opt_35 = record["附加状态"]
    local ____temp_37 = ____opt_35 and ____opt_35["深渊回潮冷却毫秒"]
    if ____temp_37 == nil then
        ____temp_37 = 0
    end
    local ____temp_43 = ____5F53_524D_6BEB_79D2_38 >= ____temp_37
    if ____temp_43 then
        local ____5F53_524D_6BEB_79D2_42 = _____5F53_524D_6BEB_79D2
        local ____opt_39 = record["附加状态"]
        local ____temp_41 = ____opt_39 and ____opt_39["回潮封锁毫秒"]
        if ____temp_41 == nil then
            ____temp_41 = 0
        end
        ____temp_43 = ____5F53_524D_6BEB_79D2_42 >= ____temp_41
    end
    if ____temp_43 and ____exports["尝试释放深渊回潮"](record) then
        return
    end
    local ____5F53_524D_6BEB_79D2_47 = _____5F53_524D_6BEB_79D2
    local ____opt_44 = record["附加状态"]
    local ____temp_46 = ____opt_44 and ____opt_44["潮汐牵引冷却毫秒"]
    if ____temp_46 == nil then
        ____temp_46 = 0
    end
    if ____5F53_524D_6BEB_79D2_47 >= ____temp_46 and _____91CA_653E_6F6E_6C50_7275_5F15(record) then
        return
    end
    local target = _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868()[1]
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) then
        record["当前目标"] = target
        _____547D_4EE4_653B_51FB_76EE_6807(record["单位"], target)
    end
end
____exports["清理深渊鳞将机制"] = function(record)
    if record["充能ID"] ~= 0 and _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"]) then
        _____505C_6B62_5355_4F4D_5145_80FD(record["单位"])
    end
    local ____opt_48 = record["附加状态"]
    local state = ____opt_48 and ____opt_48["潮汐牵引"]
    if state ~= nil then
        state["清理中"] = true
        local ids = __TS__ArraySlice(state["牵引ID列表"])
        do
            local i = 0
            while i < #ids do
                __TS__Delete(_____7275_5F15_6765_6E90_8868, ids[i + 1])
                _____505C_6B62_7275_5F15(ids[i + 1])
                i = i + 1
            end
        end
    end
    record["充能ID"] = 0
    record["当前目标"] = nil
    if record["附加状态"] ~= nil then
        __TS__Delete(record["附加状态"], "深渊回潮")
        __TS__Delete(record["附加状态"], "潮汐牵引")
    end
end
return ____exports
