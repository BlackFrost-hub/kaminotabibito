--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.01．运行时上下文")
local _____589E_52A0_73A9_5BB6_8150_8D25_503C = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["增加玩家腐败值"]
local _____6E05_9664_73A9_5BB6_8150_8D25_503C = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["清除玩家腐败值"]
local _____53D6_8150_8D25_503C_6700_9AD8_73A9_5BB6 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["取腐败值最高玩家"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.02．数值与表现配置")
local _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯数值与表现配置"]
local _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯音效配置"]
local ____16_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.16．公共工具")
local _____5355_4F4D_6709_6548 = ____16_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____6781_5750_6807X = ____16_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____16_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_0["造成单体技能伤害"]
local _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_0["创建独立技能伤害实例"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local IssueTargetOrder = jass.IssueTargetOrder
local KillUnit = jass.KillUnit
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____require_result_2["创建可攻击机制单位"]
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_3["获取Boss技能随机敌对英雄"]
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_3["获取Boss技能敌对英雄列表"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.06．战斗内拾取物")
local _____521B_5EFA_6218_6597_5185_62FE_53D6_7269 = ____require_result_4["创建战斗内拾取物"]
local ____require_result_5 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_5.registerManualBuff
local ____require_result_6 = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.03．莫尔特斯")
local _____83AB_5C14_7279_65AFBuffID = ____require_result_6["莫尔特斯BuffID"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容")
local _____4E34_65F6_8C03_6574_653B_51FB = ____require_result_7["临时调整攻击"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_8["读取单位攻击力"]
local function _____53D6_7532_866B_76EE_6807(context)
    local target = _____53D6_8150_8D25_503C_6700_9AD8_73A9_5BB6(context)
    if _____5355_4F4D_6709_6548(target) then
        return target
    end
    return _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(context["Boss单位"])
end
local function _____83AB_5C14_7279_65AF_866B_5C38_53EF_62FE_53D6_5355_4F4D(variable)
    local data = variable
    if data == nil then
        return {}
    end
    return _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(data.context["Boss单位"])
end
local function _____83AB_5C14_7279_65AF_866B_5C38_62FE_53D6(picker, ______5B9E_4F8B, variable)
    local data = variable
    if data == nil then
        return
    end
    local amount = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败值"]["虫尸清除值"]
    _____6E05_9664_73A9_5BB6_8150_8D25_503C(data.context, picker, amount)
    registerManualBuff(
        picker,
        _____83AB_5C14_7279_65AFBuffID["腐败虫尸净化"],
        3,
        amount,
        {sourceName = "莫尔特斯-腐败虫尸"}
    )
end
local function _____521B_5EFA_866B_5C38_62FE_53D6_7269(context, x, y)
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["共生腐朽虫群"]
    _____521B_5EFA_6218_6597_5185_62FE_53D6_7269({
        ["清理"] = context["清理"],
        ["名称"] = "莫尔特斯-腐败虫尸",
        X = x,
        Y = y,
        ["模型路径"] = cfg["虫尸模型路径"],
        ["缩放"] = 0.55,
        ["持续秒"] = cfg["虫尸持续秒"],
        ["拾取半径"] = cfg["虫尸拾取半径"],
        ["变量"] = {context = context},
        ["可拾取单位列表"] = _____83AB_5C14_7279_65AF_866B_5C38_53EF_62FE_53D6_5355_4F4D,
        ["on拾取"] = _____83AB_5C14_7279_65AF_866B_5C38_62FE_53D6
    })
end
local function _____7206_70B8_7532_866B(data)
    local boss = data.context["Boss单位"]
    local target = data["接触目标"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["共生腐朽虫群"]
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = boss,
        ["目标"] = target,
        ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["爆炸伤害Boss攻击力比例"],
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_PLANT,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "Boss技能",
        ["技能实例ID"] = data["技能实例ID"],
        ["标签"] = "莫尔特斯共生腐朽虫群"
    })
    _____589E_52A0_73A9_5BB6_8150_8D25_503C(data.context, target, cfg["爆炸腐败值"])
end
local function _____7532_866B_8FFD_51FBTick(data)
    local beetle = data["甲虫单位"]
    if not _____5355_4F4D_6709_6548(beetle) or not _____5355_4F4D_6709_6548(data.context["Boss单位"]) then
        removePeriodicCallback(data["周期ID"])
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["共生腐朽虫群"]
    local target = _____53D6_7532_866B_76EE_6807(data.context)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    IssueTargetOrder(beetle, "attack", target)
    local dx = GetUnitX(beetle) - GetUnitX(target)
    local dy = GetUnitY(beetle) - GetUnitY(target)
    if dx * dx + dy * dy <= cfg["接触半径"] * cfg["接触半径"] then
        if data["接触目标"] == target then
            data["接触Ticks"] = data["接触Ticks"] + 1
        else
            data["接触目标"] = target
            data["接触Ticks"] = 1
        end
        if data["接触Ticks"] >= cfg["接触爆炸秒"] then
            _____7206_70B8_7532_866B(data)
            KillUnit(beetle)
            removePeriodicCallback(data["周期ID"])
        end
    else
        data["接触目标"] = nil
        data["接触Ticks"] = 0
    end
end
local function _____83AB_5C14_7279_65AF_7532_866B_8FFD_51FB_5468_671F(variable)
    local data = variable
    if data == nil then
        return
    end
    _____7532_866B_8FFD_51FBTick(data)
end
local function _____83AB_5C14_7279_65AF_7532_866B_6B7B_4EA1(unit, ______51FB_6740_8005, variable)
    local data = variable
    if data == nil then
        return
    end
    _____521B_5EFA_866B_5C38_62FE_53D6_7269(
        data.context,
        GetUnitX(unit),
        GetUnitY(unit)
    )
end
local function _____521B_5EFA_8150_5316_7532_866B(context, angle, _____6280_80FD_5B9E_4F8BID)
    local boss = context["Boss单位"]
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["共生腐朽虫群"]
    local x = _____6781_5750_6807X(
        GetUnitX(boss),
        angle,
        360
    )
    local y = _____6781_5750_6807Y(
        GetUnitY(boss),
        angle,
        360
    )
    local instance = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = "莫尔特斯-腐化甲虫",
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["单位类型"] = cfg["甲虫单位类型"],
        ["模型路径"] = cfg["甲虫模型路径"],
        X = x,
        Y = y,
        ["朝向"] = angle,
        ["最大生命"] = cfg["甲虫生命值"],
        ["缩放"] = cfg["甲虫缩放"],
        ["变量"] = {context = context},
        ["on死亡"] = _____83AB_5C14_7279_65AF_7532_866B_6B7B_4EA1
    })
    if instance == nil or not _____5355_4F4D_6709_6548(instance["单位"]) then
        return
    end
    _____4E34_65F6_8C03_6574_653B_51FB(instance["单位"], cfg["甲虫攻击力"])
    local data = {
        context = context,
        ["甲虫单位"] = instance["单位"],
        ["接触目标"] = nil,
        ["接触Ticks"] = 0,
        ["周期ID"] = 0,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    }
    data["周期ID"] = addPeriodicCallback(1000, _____83AB_5C14_7279_65AF_7532_866B_8FFD_51FB_5468_671F, data)
    local ____self_9 = context["清理"]
    ____self_9["登记周期回调"](____self_9, "莫尔特斯-甲虫追击", data["周期ID"])
end
____exports["尝试释放莫尔特斯共生腐朽虫群"] = function(context, nowMs)
    if context["阶段"] < 2 or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["共生腐朽虫群"]
    if context["下次虫群时间"] <= 0 then
        context["下次虫群时间"] = nowMs + cfg["触发间隔秒"] * 1000
    end
    if nowMs < context["下次虫群时间"] then
        return
    end
    context["下次虫群时间"] = nowMs + cfg["触发间隔秒"] * 1000
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["共生腐朽虫群"]["甲虫入场"],
        GetUnitX(context["Boss单位"]),
        GetUnitY(context["Boss单位"]),
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    local _____6280_80FD_5B9E_4F8BID = _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B({["来源类型"] = "Boss技能", ["标签"] = "莫尔特斯共生腐朽虫群", ["持续时间秒"] = cfg["接触爆炸秒"] + 12})
    do
        local i = 0
        while i < cfg["甲虫数量"] do
            _____521B_5EFA_8150_5316_7532_866B(context, i * 90, _____6280_80FD_5B9E_4F8BID)
            i = i + 1
        end
    end
end
____exports["注册莫尔特斯共生腐朽虫群"] = function()
end
return ____exports
