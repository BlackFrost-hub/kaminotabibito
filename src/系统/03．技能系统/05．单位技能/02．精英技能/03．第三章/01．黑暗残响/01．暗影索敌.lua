local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.02．精英技能.03．第三章.01．黑暗残响.00．配置")
local _____9ED1_6697_6B8B_54CD_914D_7F6E = ____00_FF0E_914D_7F6E["黑暗残响配置"]
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.00．封印守卫战公共.01．共享")
local _____5355_4F4D_5904_4E8E_786C_63A7_5236 = ____01_FF0E_5171_4EAB["单位处于硬控制"]
local _____53D6_4E24_70B9_65B9_5411_89D2 = ____01_FF0E_5171_4EAB["取两点方向角"]
local _____53D6_5355_4F4DX = ____01_FF0E_5171_4EAB["取单位X"]
local _____53D6_5355_4F4DY = ____01_FF0E_5171_4EAB["取单位Y"]
local _____53D6_6700_8FD1_5355_4F4D = ____01_FF0E_5171_4EAB["取最近单位"]
local _____53D6_6700_8FD1_73A9_5BB6_82F1_96C4 = ____01_FF0E_5171_4EAB["取最近玩家英雄"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____01_FF0E_5171_4EAB["读取单位攻击力"]
local _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D = ____01_FF0E_5171_4EAB["读取单位最大生命"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55 = ____01_FF0E_5171_4EAB["读取封印守卫战敌人记录"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_6838_5FC3 = ____01_FF0E_5171_4EAB["读取封印守卫战核心"]
local _____8BFB_53D6_6B63_5728_4FEE_590D_5C01_5370_951A_70B9_7684_82F1_96C4_5217_8868 = ____01_FF0E_5171_4EAB["读取正在修复封印锚点的英雄列表"]
local _____547D_4EE4_653B_51FB_76EE_6807 = ____01_FF0E_5171_4EAB["命令攻击目标"]
local _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B = ____01_FF0E_5171_4EAB["封印守卫战单位存活"]
local _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548 = ____01_FF0E_5171_4EAB["创建封印守卫战点特效"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_0["开始充能"]
local _____505C_6B62_5355_4F4D_5145_80FD = ____require_result_0["停止单位充能"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_1["创建原生弹幕"]
local _____9500_6BC1_539F_751F_5F39_5E55 = ____require_result_1["销毁原生弹幕"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_2["造成单体技能伤害"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_3["施加快速减速Buff"]
local _____6E05_9664_5355_4F4D_6307_5B9ABuff = ____require_result_3["清除单位指定Buff"]
local ____require_result_4 = require("系统.05．Buff系统.03．Buff表.04．单位.01．封印守卫战")
local _____5C01_5370_5B88_536B_6218BuffID = ____require_result_4["封印守卫战BuffID"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_5.getServerTime
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local _____6697_5F71_5F39_4E0A_4E0B_6587_8868 = {}
local _____6D3B_52A8_6697_5F71_5F39ID_5217_8868 = {}
local function _____9009_62E9_9ED1_6697_6B8B_54CD_73A9_5BB6_76EE_6807(record)
    local repairing = _____8BFB_53D6_6B63_5728_4FEE_590D_5C01_5370_951A_70B9_7684_82F1_96C4_5217_8868()
    local repairTarget = _____53D6_6700_8FD1_5355_4F4D(record["单位"], repairing, _____9ED1_6697_6B8B_54CD_914D_7F6E["索敌范围"])
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(repairTarget) then
        return repairTarget
    end
    return _____53D6_6700_8FD1_73A9_5BB6_82F1_96C4(record["单位"], _____9ED1_6697_6B8B_54CD_914D_7F6E["索敌范围"])
end
local function _____7B5B_9009_9ED1_6697_6B8B_54CD_6697_5F71_5F39_76EE_6807(unit, barrageId)
    local context = _____6697_5F71_5F39_4E0A_4E0B_6587_8868[barrageId]
    return context ~= nil and context["目标"] == unit and _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(unit)
end
local function ____on_9ED1_6697_6B8B_54CD_6697_5F71_5F39_547D_4E2D(target, barrageId)
    local context = _____6697_5F71_5F39_4E0A_4E0B_6587_8868[barrageId]
    if context == nil or context["目标"] ~= target or not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(context["来源"]) or not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) then
        return
    end
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(context["来源"]) * _____9ED1_6697_6B8B_54CD_914D_7F6E["攻击力伤害比例"] + _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(target) * _____9ED1_6697_6B8B_54CD_914D_7F6E["目标最大生命伤害比例"]
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = context["来源"],
        ["目标"] = target,
        ["伤害"] = damage,
        ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
        ["来源类型"] = "单位技能",
        ["标签"] = "封印守卫战-黑暗残响暗影索敌",
        ["参与技能伤害加成"] = false
    })
    _____6E05_9664_5355_4F4D_6307_5B9ABuff(target, _____5C01_5370_5B88_536B_6218BuffID["缚魂减速"])
    _____65BD_52A0_5FEB_901F_51CF_901FBuff(
        context["来源"],
        target,
        0,
        _____9ED1_6697_6B8B_54CD_914D_7F6E["减速比例"],
        _____9ED1_6697_6B8B_54CD_914D_7F6E["减速持续秒"],
        "封印守卫战-黑暗残响暗影索敌",
        "技能",
        _____5C01_5370_5B88_536B_6218BuffID["暗影侵蚀减速"]
    )
    _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548({
        ["模型路径"] = _____9ED1_6697_6B8B_54CD_914D_7F6E["命中特效"],
        X = _____53D6_5355_4F4DX(target),
        Y = _____53D6_5355_4F4DY(target),
        Z = 0,
        ["缩放"] = 0.7,
        ["持续秒"] = 2
    })
end
local function ____on_9ED1_6697_6B8B_54CD_6697_5F71_5F39_7ED3_675F(_reason, barrageId)
    __TS__Delete(_____6697_5F71_5F39_4E0A_4E0B_6587_8868, barrageId)
    local index = __TS__ArrayIndexOf(_____6D3B_52A8_6697_5F71_5F39ID_5217_8868, barrageId)
    if index >= 0 then
        __TS__ArraySplice(_____6D3B_52A8_6697_5F71_5F39ID_5217_8868, index, 1)
    end
end
local function _____53D1_5C04_9ED1_6697_6B8B_54CD_6697_5F71_5F39(source, target)
    if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(source) or not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) then
        return false
    end
    local barrage = _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = source,
        ["载体模式"] = "特效",
        X = _____53D6_5355_4F4DX(source),
        Y = _____53D6_5355_4F4DY(source),
        ["方向角"] = _____53D6_4E24_70B9_65B9_5411_89D2(
            _____53D6_5355_4F4DX(source),
            _____53D6_5355_4F4DY(source),
            _____53D6_5355_4F4DX(target),
            _____53D6_5355_4F4DY(target)
        ),
        ["速度"] = _____9ED1_6697_6B8B_54CD_914D_7F6E["弹幕速度"],
        ["轨迹类型"] = "追踪",
        ["指定目标"] = target,
        ["追踪转向速度"] = 720,
        ["最大距离"] = _____9ED1_6697_6B8B_54CD_914D_7F6E["弹幕最大距离"],
        ["生命周期"] = _____9ED1_6697_6B8B_54CD_914D_7F6E["弹幕生命周期秒"],
        ["命中半径"] = _____9ED1_6697_6B8B_54CD_914D_7F6E["弹幕命中范围"],
        ["影响目标"] = "敌方",
        ["碰撞消失"] = true,
        ["每单位最大命中次数"] = 1,
        ["最大总命中次数"] = 1,
        ["飞行高度"] = 80,
        ["附加特效1"] = {["模型"] = _____9ED1_6697_6B8B_54CD_914D_7F6E["弹幕特效"], ["缩放"] = _____9ED1_6697_6B8B_54CD_914D_7F6E["弹幕缩放"]},
        ["目标筛选"] = _____7B5B_9009_9ED1_6697_6B8B_54CD_6697_5F71_5F39_76EE_6807,
        ["on命中"] = ____on_9ED1_6697_6B8B_54CD_6697_5F71_5F39_547D_4E2D,
        ["on结束"] = ____on_9ED1_6697_6B8B_54CD_6697_5F71_5F39_7ED3_675F
    })
    if barrage == nil or not (barrage["弹幕ID"] > 0) then
        return false
    end
    _____6697_5F71_5F39_4E0A_4E0B_6587_8868[barrage["弹幕ID"]] = {["来源"] = source, ["目标"] = target}
    _____6D3B_52A8_6697_5F71_5F39ID_5217_8868[#_____6D3B_52A8_6697_5F71_5F39ID_5217_8868 + 1] = barrage["弹幕ID"]
    return true
end
local function ____on_9ED1_6697_6B8B_54CD_5145_80FD_5468_671F(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "黑暗残响" or record["充能ID"] ~= chargeId then
        return
    end
    if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["当前目标"]) or _____5355_4F4D_5904_4E8E_786C_63A7_5236(unit) then
        _____505C_6B62_5355_4F4D_5145_80FD(unit)
    end
end
local function ____on_9ED1_6697_6B8B_54CD_5145_80FD_5B8C_6210(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "黑暗残响" or record["充能ID"] ~= chargeId then
        return
    end
    record["充能ID"] = 0
    local target = record["当前目标"]
    record["当前目标"] = nil
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) then
        _____53D1_5C04_9ED1_6697_6B8B_54CD_6697_5F71_5F39(unit, target)
    end
    record["下次技能毫秒"] = getServerTime() + _____9ED1_6697_6B8B_54CD_914D_7F6E["技能冷却毫秒"]
end
local function ____on_9ED1_6697_6B8B_54CD_5145_80FD_7ED3_675F(unit, reason, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "黑暗残响" then
        return
    end
    if record["充能ID"] == chargeId then
        record["充能ID"] = 0
    end
    record["当前目标"] = nil
    if reason ~= "完成" then
        record["下次技能毫秒"] = getServerTime() + _____9ED1_6697_6B8B_54CD_914D_7F6E["技能冷却毫秒"]
    end
end
local function _____5F00_59CB_9ED1_6697_6B8B_54CD_6697_5F71_7D22_654C(record, target)
    if record["充能ID"] ~= 0 or _____5355_4F4D_5904_4E8E_786C_63A7_5236(record["单位"]) or not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) then
        return false
    end
    record["当前目标"] = target
    local id = _____5F00_59CB_5145_80FD(record["单位"], {
        ["持续时间"] = _____9ED1_6697_6B8B_54CD_914D_7F6E["引导持续秒"],
        ["强制硬直"] = true,
        ["显示进度条特效"] = true,
        ["周期回调间隔"] = 0.1,
        ["周期回调"] = ____on_9ED1_6697_6B8B_54CD_5145_80FD_5468_671F,
        ["充能完成回调"] = ____on_9ED1_6697_6B8B_54CD_5145_80FD_5B8C_6210,
        ["结束回调"] = ____on_9ED1_6697_6B8B_54CD_5145_80FD_7ED3_675F
    })
    record["充能ID"] = id
    return id > 0
end
____exports["刷新黑暗残响AI"] = function(record, _____5F53_524D_6BEB_79D2)
    if record["充能ID"] ~= 0 or _____5F53_524D_6BEB_79D2 < record["下次AI毫秒"] then
        return
    end
    record["下次AI毫秒"] = _____5F53_524D_6BEB_79D2 + _____9ED1_6697_6B8B_54CD_914D_7F6E["AI刷新毫秒"]
    local hero = _____9009_62E9_9ED1_6697_6B8B_54CD_73A9_5BB6_76EE_6807(record)
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(hero) then
        record["当前目标"] = hero
        if _____5F53_524D_6BEB_79D2 >= record["下次技能毫秒"] and _____5F00_59CB_9ED1_6697_6B8B_54CD_6697_5F71_7D22_654C(record, hero) then
            return
        end
        _____547D_4EE4_653B_51FB_76EE_6807(record["单位"], hero)
        return
    end
    local core = _____8BFB_53D6_5C01_5370_5B88_536B_6218_6838_5FC3()
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(core) then
        record["当前目标"] = core
        _____547D_4EE4_653B_51FB_76EE_6807(record["单位"], core)
    end
end
____exports["清理黑暗残响机制"] = function(record)
    if record["充能ID"] ~= 0 and _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"]) then
        _____505C_6B62_5355_4F4D_5145_80FD(record["单位"])
    end
    record["充能ID"] = 0
    local keys = {}
    do
        local i = 0
        while i < #_____6D3B_52A8_6697_5F71_5F39ID_5217_8868 do
            local barrageId = _____6D3B_52A8_6697_5F71_5F39ID_5217_8868[i + 1]
            local context = _____6697_5F71_5F39_4E0A_4E0B_6587_8868[barrageId]
            if context ~= nil and context["来源"] == record["单位"] then
                keys[#keys + 1] = barrageId
            end
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #keys do
            _____9500_6BC1_539F_751F_5F39_5E55(keys[i + 1], "手动销毁")
            i = i + 1
        end
    end
end
____exports["清理全部黑暗残响弹幕"] = function()
    local keys = {}
    do
        local i = 0
        while i < #_____6D3B_52A8_6697_5F71_5F39ID_5217_8868 do
            keys[#keys + 1] = _____6D3B_52A8_6697_5F71_5F39ID_5217_8868[i + 1]
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #keys do
            if keys[i + 1] > 0 then
                _____9500_6BC1_539F_751F_5F39_5E55(keys[i + 1], "手动销毁")
            end
            i = i + 1
        end
    end
end
return ____exports
