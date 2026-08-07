local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____5F53_524D_6709_6F6E_5203_4F4D_79FB
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.06．潮蚀巡鳞者.00．配置")
local _____6F6E_8680_5DE1_9CDE_8005_914D_7F6E = ____00_FF0E_914D_7F6E["潮蚀巡鳞者配置"]
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.00．封印守卫战公共.01．共享")
local _____5355_4F4D_5904_4E8E_786C_63A7_5236 = ____01_FF0E_5171_4EAB["单位处于硬控制"]
local _____547D_4EE4_653B_51FB_76EE_6807 = ____01_FF0E_5171_4EAB["命令攻击目标"]
local _____53D6_4E24_70B9_65B9_5411_89D2 = ____01_FF0E_5171_4EAB["取两点方向角"]
local _____53D6_5355_4F4DX = ____01_FF0E_5171_4EAB["取单位X"]
local _____53D6_5355_4F4DY = ____01_FF0E_5171_4EAB["取单位Y"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____01_FF0E_5171_4EAB["读取单位攻击力"]
local _____53D6_6700_8FD1_73A9_5BB6_82F1_96C4 = ____01_FF0E_5171_4EAB["取最近玩家英雄"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868 = ____01_FF0E_5171_4EAB["读取封印守卫战玩家英雄列表"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55 = ____01_FF0E_5171_4EAB["读取封印守卫战敌人记录"]
local _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B = ____01_FF0E_5171_4EAB["封印守卫战单位存活"]
local _____662F_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4 = ____01_FF0E_5171_4EAB["是封印守卫战玩家英雄"]
local _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548 = ____01_FF0E_5171_4EAB["创建封印守卫战点特效"]
function _____5F53_524D_6709_6F6E_5203_4F4D_79FB(record)
    local ____opt_8 = record["附加状态"]
    return (____opt_8 and ____opt_8["潮刃突袭"]) ~= nil and record["附加状态"]["潮刃突袭"]["已结算"] ~= true
end
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_0["开始充能"]
local _____505C_6B62_5355_4F4D_5145_80FD = ____require_result_0["停止单位充能"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_1["创建技能提示圈"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_2["开始冲锋"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_3["造成单体技能伤害"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_4["施加快速减速Buff"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_5.getServerTime
local jass = require("jass.common")
local SquareRoot = jass.SquareRoot
local Cos = jass.Cos
local Sin = jass.Sin
local DEGTORAD = jass.bj_DEGTORAD
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local function _____53D6_8303_56F4_5185_7A81_8FDB_76EE_6807(record)
    local heroes = _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868()
    local x = _____53D6_5355_4F4DX(record["单位"])
    local y = _____53D6_5355_4F4DY(record["单位"])
    local target = nil
    local best = 999999999
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(hero) then
                    goto __continue4
                end
                local dx = _____53D6_5355_4F4DX(hero) - x
                local dy = _____53D6_5355_4F4DY(hero) - y
                local distance = SquareRoot(dx * dx + dy * dy)
                if distance < _____6F6E_8680_5DE1_9CDE_8005_914D_7F6E["施法距离下限"] or distance > _____6F6E_8680_5DE1_9CDE_8005_914D_7F6E["施法距离上限"] then
                    goto __continue4
                end
                if distance < best then
                    best = distance
                    target = hero
                end
            end
            ::__continue4::
            i = i + 1
        end
    end
    return target
end
local function _____6F6E_5203_7A81_88AD_5145_80FD_5468_671F(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "潮蚀巡鳞者" or record["充能ID"] ~= chargeId then
        return
    end
    if _____5355_4F4D_5904_4E8E_786C_63A7_5236(unit) or not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["当前目标"]) then
        _____505C_6B62_5355_4F4D_5145_80FD(unit)
    end
end
local function _____6F6E_5203_7A81_88AD_4F4D_79FB_7ED3_675F(unit, reason, _moveId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "潮蚀巡鳞者" then
        return
    end
    local ____opt_6 = record["附加状态"]
    local state = ____opt_6 and ____opt_6["潮刃突袭"]
    if state == nil or state["已结算"] then
        return
    end
    state["已结算"] = true
    _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548({
        ["模型路径"] = _____6F6E_8680_5DE1_9CDE_8005_914D_7F6E["结束特效"],
        X = _____53D6_5355_4F4DX(unit),
        Y = _____53D6_5355_4F4DY(unit),
        Z = 0,
        ["缩放"] = 0.75,
        ["持续秒"] = 1.2
    })
    if reason == "死亡" or reason == "中断" or reason == "主单位死亡" then
        if record["附加状态"] ~= nil then
            __TS__Delete(record["附加状态"], "潮刃突袭")
        end
        return
    end
    local heroes = _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868()
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(unit) * _____6F6E_8680_5DE1_9CDE_8005_914D_7F6E["伤害攻击力比例"]
    do
        local i = 0
        while i < #heroes do
            do
                local target = heroes[i + 1]
                if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) or not _____662F_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4(target) then
                    goto __continue17
                end
                local dx = _____53D6_5355_4F4DX(target) - state["起点X"]
                local dy = _____53D6_5355_4F4DY(target) - state["起点Y"]
                local along = dx * Cos(state["朝向"] * DEGTORAD) + dy * Sin(state["朝向"] * DEGTORAD)
                local cross = dx * Sin(state["朝向"] * DEGTORAD) - dy * Cos(state["朝向"] * DEGTORAD)
                if along < -64 or along > _____6F6E_8680_5DE1_9CDE_8005_914D_7F6E["突进距离"] + 96 or (cross < 0 and -cross or cross) > _____6F6E_8680_5DE1_9CDE_8005_914D_7F6E["命中范围"] then
                    goto __continue17
                end
                _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                    ["来源"] = unit,
                    ["目标"] = target,
                    ["伤害"] = damage,
                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "单位技能",
                    ["标签"] = "第三章-潮蚀巡鳞者-潮刃突袭",
                    ["参与技能伤害加成"] = false
                })
                _____65BD_52A0_5FEB_901F_51CF_901FBuff(
                    unit,
                    target,
                    0,
                    _____6F6E_8680_5DE1_9CDE_8005_914D_7F6E["命中减速比例"],
                    _____6F6E_8680_5DE1_9CDE_8005_914D_7F6E["命中减速秒"],
                    "潮蚀巡鳞者-潮刃突袭",
                    "技能"
                )
            end
            ::__continue17::
            i = i + 1
        end
    end
    if record["附加状态"] ~= nil then
        __TS__Delete(record["附加状态"], "潮刃突袭")
    end
end
local function _____6F6E_5203_7A81_88AD_5145_80FD_5B8C_6210(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "潮蚀巡鳞者" or record["充能ID"] ~= chargeId then
        return
    end
    record["充能ID"] = 0
    local target = record["当前目标"]
    record["当前目标"] = nil
    if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) then
        return
    end
    local state = {
        ["起点X"] = _____53D6_5355_4F4DX(unit),
        ["起点Y"] = _____53D6_5355_4F4DY(unit),
        ["朝向"] = _____53D6_4E24_70B9_65B9_5411_89D2(
            _____53D6_5355_4F4DX(unit),
            _____53D6_5355_4F4DY(unit),
            _____53D6_5355_4F4DX(target),
            _____53D6_5355_4F4DY(target)
        ),
        ["已结算"] = false
    }
    if record["附加状态"] == nil then
        record["附加状态"] = {}
    end
    record["附加状态"]["潮刃突袭"] = state
    local moveId = _____5F00_59CB_51B2_950B(unit, {
        ["角度"] = state["朝向"],
        ["距离"] = _____6F6E_8680_5DE1_9CDE_8005_914D_7F6E["突进距离"],
        ["持续时间"] = _____6F6E_8680_5DE1_9CDE_8005_914D_7F6E["突进持续秒"],
        ["检查地形"] = true,
        ["朝向跟随位移"] = true,
        ["暂停单位"] = true,
        ["禁用碰撞"] = true,
        ["位移特效"] = _____6F6E_8680_5DE1_9CDE_8005_914D_7F6E["突进特效"],
        ["结束回调"] = _____6F6E_5203_7A81_88AD_4F4D_79FB_7ED3_675F
    })
    if not (moveId > 0) and record["附加状态"] ~= nil then
        __TS__Delete(record["附加状态"], "潮刃突袭")
    end
    record["下次技能毫秒"] = getServerTime() + _____6F6E_8680_5DE1_9CDE_8005_914D_7F6E["技能冷却毫秒"]
end
local function _____6F6E_5203_7A81_88AD_5145_80FD_7ED3_675F(unit, reason, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "潮蚀巡鳞者" then
        return
    end
    if record["充能ID"] == chargeId then
        record["充能ID"] = 0
    end
    record["当前目标"] = nil
    if reason ~= "完成" then
        record["下次技能毫秒"] = getServerTime() + _____6F6E_8680_5DE1_9CDE_8005_914D_7F6E["技能冷却毫秒"]
    end
end
____exports["尝试释放潮刃突袭"] = function(record)
    if record["充能ID"] ~= 0 or _____5F53_524D_6709_6F6E_5203_4F4D_79FB(record) or _____5355_4F4D_5904_4E8E_786C_63A7_5236(record["单位"]) then
        return false
    end
    local target = _____53D6_8303_56F4_5185_7A81_8FDB_76EE_6807(record)
    if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) then
        return false
    end
    record["当前目标"] = target
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "方向直线",
        X = _____53D6_5355_4F4DX(record["单位"]),
        Y = _____53D6_5355_4F4DY(record["单位"]),
        ["宽度"] = _____6F6E_8680_5DE1_9CDE_8005_914D_7F6E["预警宽度"],
        ["长度"] = _____6F6E_8680_5DE1_9CDE_8005_914D_7F6E["预警长度"],
        ["朝向"] = _____53D6_4E24_70B9_65B9_5411_89D2(
            _____53D6_5355_4F4DX(record["单位"]),
            _____53D6_5355_4F4DY(record["单位"]),
            _____53D6_5355_4F4DX(target),
            _____53D6_5355_4F4DY(target)
        ),
        ["持续时间"] = _____6F6E_8680_5DE1_9CDE_8005_914D_7F6E["预警秒"],
        ["来源单位"] = record["单位"]
    })
    local id = _____5F00_59CB_5145_80FD(record["单位"], {
        ["持续时间"] = _____6F6E_8680_5DE1_9CDE_8005_914D_7F6E["预警秒"],
        ["强制硬直"] = true,
        ["显示进度条特效"] = true,
        ["周期回调间隔"] = 0.1,
        ["周期回调"] = _____6F6E_5203_7A81_88AD_5145_80FD_5468_671F,
        ["充能完成回调"] = _____6F6E_5203_7A81_88AD_5145_80FD_5B8C_6210,
        ["结束回调"] = _____6F6E_5203_7A81_88AD_5145_80FD_7ED3_675F
    })
    record["充能ID"] = id
    return id > 0
end
____exports["刷新潮蚀巡鳞者AI"] = function(record, _____5F53_524D_6BEB_79D2)
    if _____5F53_524D_6709_6F6E_5203_4F4D_79FB(record) or record["充能ID"] ~= 0 or _____5F53_524D_6BEB_79D2 < record["下次AI毫秒"] then
        return
    end
    record["下次AI毫秒"] = _____5F53_524D_6BEB_79D2 + _____6F6E_8680_5DE1_9CDE_8005_914D_7F6E["AI刷新毫秒"]
    if _____5F53_524D_6BEB_79D2 >= record["下次技能毫秒"] and ____exports["尝试释放潮刃突袭"](record) then
        return
    end
    local target = _____53D6_6700_8FD1_73A9_5BB6_82F1_96C4(record["单位"])
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) then
        record["当前目标"] = target
        _____547D_4EE4_653B_51FB_76EE_6807(record["单位"], target)
    end
end
____exports["清理潮蚀巡鳞者机制"] = function(record)
    if record["充能ID"] ~= 0 and _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"]) then
        _____505C_6B62_5355_4F4D_5145_80FD(record["单位"])
    end
    record["充能ID"] = 0
    record["当前目标"] = nil
    if record["附加状态"] ~= nil then
        __TS__Delete(record["附加状态"], "潮刃突袭")
    end
end
return ____exports
