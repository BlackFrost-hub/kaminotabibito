local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.02．精英技能.03．第三章.06．金鳞执刑官.00．配置")
local _____91D1_9CDE_6267_5211_5B98_914D_7F6E = ____00_FF0E_914D_7F6E["金鳞执刑官配置"]
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.00．封印守卫战公共.01．共享")
local _____5355_4F4D_5904_4E8E_786C_63A7_5236 = ____01_FF0E_5171_4EAB["单位处于硬控制"]
local _____547D_4EE4_653B_51FB_76EE_6807 = ____01_FF0E_5171_4EAB["命令攻击目标"]
local _____53D6_4E24_70B9_65B9_5411_89D2 = ____01_FF0E_5171_4EAB["取两点方向角"]
local _____53D6_5355_4F4DX = ____01_FF0E_5171_4EAB["取单位X"]
local _____53D6_5355_4F4DY = ____01_FF0E_5171_4EAB["取单位Y"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____01_FF0E_5171_4EAB["读取单位攻击力"]
local _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9 = ____01_FF0E_5171_4EAB["取单位距离平方"]
local _____8BFB_53D6_5355_4F4D_751F_547D = ____01_FF0E_5171_4EAB["读取单位生命"]
local _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D = ____01_FF0E_5171_4EAB["读取单位最大生命"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55 = ____01_FF0E_5171_4EAB["读取封印守卫战敌人记录"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868 = ____01_FF0E_5171_4EAB["读取封印守卫战玩家英雄列表"]
local _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B = ____01_FF0E_5171_4EAB["封印守卫战单位存活"]
local _____662F_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4 = ____01_FF0E_5171_4EAB["是封印守卫战玩家英雄"]
local _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548 = ____01_FF0E_5171_4EAB["创建封印守卫战点特效"]
local _____521B_5EFA_5C01_5370_5B88_536B_6218_5355_4F4D_5E38_9A7B_7279_6548 = ____01_FF0E_5171_4EAB["创建封印守卫战单位常驻特效"]
local _____9500_6BC1_5C01_5370_5B88_536B_6218_5355_4F4D_5E38_9A7B_7279_6548 = ____01_FF0E_5171_4EAB["销毁封印守卫战单位常驻特效"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_0["开始充能"]
local _____505C_6B62_5355_4F4D_5145_80FD = ____require_result_0["停止单位充能"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_1["创建技能提示圈"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_2["开始冲锋"]
local _____5F00_59CB_51FB_9000 = ____require_result_2["开始击退"]
local _____505C_6B62_5355_4F4D_4F4D_79FB = ____require_result_2["停止单位位移"]
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_3.SGSS_SetState
local ____require_result_4 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_4.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_4["移除单位指定Buff"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_5.getServerTime
local jass = require("jass.common")
local GetUnitDefaultMoveSpeed = jass.GetUnitDefaultMoveSpeed
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____91CD_9CDE_62A4_4F53BuffID = "SGW8"
local _____79FB_52A8_901F_5EA6_5C5E_6027ID = 9
local _____62A4_76FE_7279_6548_952E = "第三章-金鳞执刑官-重鳞护体"
local function _____83B7_53D6_62A4_4F53_72B6_6001(record)
    if record["附加状态"] == nil then
        record["附加状态"] = {}
    end
    return record["附加状态"]
end
local function _____6E05_9664_91CD_9CDE_62A4_4F53(record, _____64AD_653E_7834_88C2_7279_6548)
    local ____opt_6 = record["附加状态"]
    local state = ____opt_6 and ____opt_6["重鳞护体"]
    if state == nil then
        return
    end
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"]) and state["移速减少"] ~= 0 then
        SGSS_SetState(record["单位"], _____79FB_52A8_901F_5EA6_5C5E_6027ID, state["移速减少"])
    end
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"]) then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(record["单位"], _____91CD_9CDE_62A4_4F53BuffID)
    end
    _____9500_6BC1_5C01_5370_5B88_536B_6218_5355_4F4D_5E38_9A7B_7279_6548(record["单位"], _____62A4_76FE_7279_6548_952E)
    if _____64AD_653E_7834_88C2_7279_6548 and _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"]) then
        _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548({
            ["模型路径"] = _____91D1_9CDE_6267_5211_5B98_914D_7F6E["命中特效"],
            X = _____53D6_5355_4F4DX(record["单位"]),
            Y = _____53D6_5355_4F4DY(record["单位"]),
            Z = 0,
            ["缩放"] = 0.9,
            ["持续秒"] = 1.2
        })
    end
    if record["附加状态"] ~= nil then
        __TS__Delete(record["附加状态"], "重鳞护体")
    end
end
local function _____5C1D_8BD5_89E6_53D1_91CD_9CDE_62A4_4F53(record)
    local ____opt_8 = record["附加状态"]
    local state = ____opt_8 and ____opt_8["重鳞护体"]
    local ____temp_12 = state ~= nil
    if not ____temp_12 then
        local ____opt_10 = record["附加状态"]
        ____temp_12 = (____opt_10 and ____opt_10["重鳞护体已触发"]) == true
    end
    if ____temp_12 then
        return
    end
    local maxLife = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(record["单位"])
    if not (maxLife > 0) or _____8BFB_53D6_5355_4F4D_751F_547D(record["单位"]) > maxLife * _____91D1_9CDE_6267_5211_5B98_914D_7F6E["护体触发生命比例"] then
        return
    end
    local moveLoss = GetUnitDefaultMoveSpeed(record["单位"]) * _____91D1_9CDE_6267_5211_5B98_914D_7F6E["护体减速比例"]
    _____83B7_53D6_62A4_4F53_72B6_6001(record)["重鳞护体已触发"] = true
    _____83B7_53D6_62A4_4F53_72B6_6001(record)["重鳞护体"] = {
        ["结束毫秒"] = getServerTime() + _____91D1_9CDE_6267_5211_5B98_914D_7F6E["护体持续秒"] * 1000,
        ["移速减少"] = moveLoss
    }
    SGSS_SetState(record["单位"], _____79FB_52A8_901F_5EA6_5C5E_6027ID, -moveLoss)
    _____521B_5EFA_5C01_5370_5B88_536B_6218_5355_4F4D_5E38_9A7B_7279_6548(record["单位"], _____91D1_9CDE_6267_5211_5B98_914D_7F6E["护盾特效"], _____62A4_76FE_7279_6548_952E)
    registerManualBuff(
        record["单位"],
        _____91CD_9CDE_62A4_4F53BuffID,
        _____91D1_9CDE_6267_5211_5B98_914D_7F6E["护体持续秒"],
        _____91D1_9CDE_6267_5211_5B98_914D_7F6E["护体减伤比例"],
        {sourceUnit = record["单位"], effectSourceName = "金鳞执刑官-重鳞护体", effectSourceType = "技能"}
    )
end
____exports["修正重鳞护体减伤"] = function(context)
    local ____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55_16 = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55
    local ____opt_result_15
    if context ~= nil then
        ____opt_result_15 = context.target
    end
    local record = ____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55_16(____opt_result_15)
    if record == nil or record["类型"] ~= "金鳞执刑官" then
        return context.currentDamage
    end
    local ____opt_17 = record["附加状态"]
    local state = ____opt_17 and ____opt_17["重鳞护体"]
    if state == nil or getServerTime() >= state["结束毫秒"] then
        return context.currentDamage
    end
    return context.currentDamage * (1 - _____91D1_9CDE_6267_5211_5B98_914D_7F6E["护体减伤比例"])
end
local function _____91D1_9CDE_51B2_9635_547D_4E2D_8FC7_6EE4(_unit, target, _moveId)
    return _____662F_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4(target)
end
local function _____91D1_9CDE_51B2_9635_547D_4E2D(unit, target, _moveId)
    if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) then
        return
    end
    _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548({
        ["模型路径"] = _____91D1_9CDE_6267_5211_5B98_914D_7F6E["命中特效"],
        X = _____53D6_5355_4F4DX(target),
        Y = _____53D6_5355_4F4DY(target),
        Z = 0,
        ["缩放"] = 0.75,
        ["持续秒"] = 1.2
    })
    _____5F00_59CB_51FB_9000(target, {
        ["来源单位"] = unit,
        ["主单位"] = unit,
        ["距离"] = _____91D1_9CDE_6267_5211_5B98_914D_7F6E["冲阵击退距离"],
        ["持续时间"] = 0.35,
        ["检查地形"] = true,
        ["禁用碰撞"] = true
    })
end
local function _____91D1_9CDE_51B2_9635_5145_80FD_5468_671F(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "金鳞执刑官" or record["充能ID"] ~= chargeId then
        return
    end
    if _____5355_4F4D_5904_4E8E_786C_63A7_5236(unit) then
        _____505C_6B62_5355_4F4D_5145_80FD(unit)
    end
end
local function _____91D1_9CDE_51B2_9635_7ED3_675F(unit, reason, _moveId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "金鳞执刑官" then
        return
    end
    if reason == "中断" or reason == "死亡" or reason == "主单位死亡" then
        record["下次技能毫秒"] = getServerTime() + _____91D1_9CDE_6267_5211_5B98_914D_7F6E["技能冷却毫秒"]
    end
end
local function _____91D1_9CDE_51B2_9635_5145_80FD_5B8C_6210(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "金鳞执刑官" or record["充能ID"] ~= chargeId then
        return
    end
    record["充能ID"] = 0
    local target = record["当前目标"]
    record["当前目标"] = nil
    if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) then
        return
    end
    local angle = _____53D6_4E24_70B9_65B9_5411_89D2(
        _____53D6_5355_4F4DX(unit),
        _____53D6_5355_4F4DY(unit),
        _____53D6_5355_4F4DX(target),
        _____53D6_5355_4F4DY(target)
    )
    _____5F00_59CB_51B2_950B(
        unit,
        {
            ["角度"] = angle,
            ["距离"] = _____91D1_9CDE_6267_5211_5B98_914D_7F6E["冲阵距离"],
            ["持续时间"] = _____91D1_9CDE_6267_5211_5B98_914D_7F6E["冲阵持续秒"],
            ["检查地形"] = true,
            ["朝向跟随位移"] = true,
            ["暂停单位"] = true,
            ["禁用碰撞"] = true,
            ["位移特效"] = _____91D1_9CDE_6267_5211_5B98_914D_7F6E["冲锋特效"],
            ["命中半径"] = _____91D1_9CDE_6267_5211_5B98_914D_7F6E["冲阵命中范围"],
            ["只命中敌人"] = true,
            ["允许重复命中"] = false,
            ["命中伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(unit) * _____91D1_9CDE_6267_5211_5B98_914D_7F6E["冲阵伤害攻击力比例"],
            ["伤害来源"] = unit,
            ["攻击类型"] = ATTACK_TYPE_NORMAL,
            ["伤害类型"] = DAMAGE_TYPE_NORMAL,
            ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
            ["技能伤害标记"] = {["来源类型"] = "单位技能", ["伤害形态"] = "AOE", ["标签"] = "第三章-金鳞执刑官-金鳞冲阵", ["参与技能伤害加成"] = false},
            ["命中过滤"] = _____91D1_9CDE_51B2_9635_547D_4E2D_8FC7_6EE4,
            ["命中回调"] = _____91D1_9CDE_51B2_9635_547D_4E2D,
            ["结束回调"] = _____91D1_9CDE_51B2_9635_7ED3_675F
        }
    )
    record["下次技能毫秒"] = getServerTime() + _____91D1_9CDE_6267_5211_5B98_914D_7F6E["技能冷却毫秒"]
end
local function _____91D1_9CDE_51B2_9635_5145_80FD_7ED3_675F(unit, reason, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "金鳞执刑官" then
        return
    end
    if record["充能ID"] == chargeId then
        record["充能ID"] = 0
    end
    record["当前目标"] = nil
    if reason ~= "完成" then
        record["下次技能毫秒"] = getServerTime() + _____91D1_9CDE_6267_5211_5B98_914D_7F6E["技能冷却毫秒"]
    end
end
____exports["尝试释放金鳞冲阵"] = function(record)
    if record["充能ID"] ~= 0 or _____5355_4F4D_5904_4E8E_786C_63A7_5236(record["单位"]) then
        return false
    end
    local heroes = _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868()
    local target = nil
    local distance = 999999999
    do
        local i = 0
        while i < #heroes do
            do
                if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(heroes[i + 1]) then
                    goto __continue35
                end
                local current = _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9(record["单位"], heroes[i + 1])
                if current < distance then
                    distance = current
                    target = heroes[i + 1]
                end
            end
            ::__continue35::
            i = i + 1
        end
    end
    if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) then
        return false
    end
    record["当前目标"] = target
    local angle = _____53D6_4E24_70B9_65B9_5411_89D2(
        _____53D6_5355_4F4DX(record["单位"]),
        _____53D6_5355_4F4DY(record["单位"]),
        _____53D6_5355_4F4DX(target),
        _____53D6_5355_4F4DY(target)
    )
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "方向直线",
        X = _____53D6_5355_4F4DX(record["单位"]),
        Y = _____53D6_5355_4F4DY(record["单位"]),
        ["宽度"] = _____91D1_9CDE_6267_5211_5B98_914D_7F6E["预警宽度"],
        ["长度"] = _____91D1_9CDE_6267_5211_5B98_914D_7F6E["预警长度"],
        ["朝向"] = angle,
        ["持续时间"] = _____91D1_9CDE_6267_5211_5B98_914D_7F6E["预警秒"],
        ["来源单位"] = record["单位"]
    })
    local id = _____5F00_59CB_5145_80FD(record["单位"], {
        ["持续时间"] = _____91D1_9CDE_6267_5211_5B98_914D_7F6E["预警秒"],
        ["强制硬直"] = true,
        ["显示进度条特效"] = true,
        ["周期回调间隔"] = 0.1,
        ["周期回调"] = _____91D1_9CDE_51B2_9635_5145_80FD_5468_671F,
        ["充能完成回调"] = _____91D1_9CDE_51B2_9635_5145_80FD_5B8C_6210,
        ["结束回调"] = _____91D1_9CDE_51B2_9635_5145_80FD_7ED3_675F
    })
    record["充能ID"] = id
    return id > 0
end
____exports["刷新金鳞执刑官AI"] = function(record, _____5F53_524D_6BEB_79D2)
    _____5C1D_8BD5_89E6_53D1_91CD_9CDE_62A4_4F53(record)
    local ____opt_19 = record["附加状态"]
    local state = ____opt_19 and ____opt_19["重鳞护体"]
    if state ~= nil and _____5F53_524D_6BEB_79D2 >= state["结束毫秒"] then
        _____6E05_9664_91CD_9CDE_62A4_4F53(record, true)
    end
    if record["充能ID"] ~= 0 or _____5F53_524D_6BEB_79D2 < record["下次AI毫秒"] then
        return
    end
    record["下次AI毫秒"] = _____5F53_524D_6BEB_79D2 + _____91D1_9CDE_6267_5211_5B98_914D_7F6E["AI刷新毫秒"]
    if _____5F53_524D_6BEB_79D2 >= record["下次技能毫秒"] and ____exports["尝试释放金鳞冲阵"](record) then
        return
    end
    local target = _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868()[1]
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) then
        record["当前目标"] = target
        _____547D_4EE4_653B_51FB_76EE_6807(record["单位"], target)
    end
end
____exports["清理金鳞执刑官机制"] = function(record)
    if record["充能ID"] ~= 0 and _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"]) then
        _____505C_6B62_5355_4F4D_5145_80FD(record["单位"])
    end
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"]) then
        _____505C_6B62_5355_4F4D_4F4D_79FB(record["单位"], "中断")
    end
    record["充能ID"] = 0
    _____6E05_9664_91CD_9CDE_62A4_4F53(record, false)
    record["当前目标"] = nil
end
return ____exports
