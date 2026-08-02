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
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行Boss单体技能伤害"]
local ____22_FF0E_9650_6B21_5468_671F_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.22．限次周期执行器")
local _____521B_5EFA_9650_6B21_5468_671F_6267_884C_5668 = ____22_FF0E_9650_6B21_5468_671F_6267_884C_5668["创建限次周期执行器"]
local _____521B_5EFA_5468_671F_884C_4E3A = ____22_FF0E_9650_6B21_5468_671F_6267_884C_5668["创建周期行为"]
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_0["创建独立技能伤害实例"]
local jass = require("jass.common")
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_1.debugLogForce
local _____866B_5C38_62FE_53D6_8C03_8BD5_6A21_5757 = "莫尔特斯-虫尸拾取"
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SquareRoot = jass.SquareRoot
local RemoveUnit = jass.RemoveUnit
local GetOwningPlayer = jass.GetOwningPlayer
local IssueTargetOrder = jass.IssueTargetOrder
local KillUnit = jass.KillUnit
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_3["启动基础施法时间线"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____require_result_4["创建可攻击机制单位"]
local ____require_result_5 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_5["获取Boss技能随机敌对英雄"]
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_5["获取Boss技能敌对英雄列表"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.06．战斗内拾取物")
local _____521B_5EFA_6218_6597_5185_62FE_53D6_7269 = ____require_result_6["创建战斗内拾取物"]
local ____require_result_7 = require("平台扩展API动作")
local _____6269_5C55__8BBE_7279_6548_901F_5EA6 = ____require_result_7["扩展_设特效速度"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_8["创建点特效"]
local ____require_result_9 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_9.registerManualBuff
local ____require_result_10 = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.03．莫尔特斯")
local _____83AB_5C14_7279_65AFBuffID = ____require_result_10["莫尔特斯BuffID"]
local ____require_result_11 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容")
local _____4E34_65F6_8C03_6574_653B_51FB = ____require_result_11["临时调整攻击"]
local function _____8BA1_7B97_8DDD_79BB(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return SquareRoot(dx * dx + dy * dy)
end
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
    local result = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(data.context["Boss单位"])
    local extraUnits = data.context["测试额外虫尸拾取单位"]
    local shouldLog = data["已输出拾取候选日志"] ~= true
    if shouldLog then
        debugLogForce(
            _____866B_5C38_62FE_53D6_8C03_8BD5_6A21_5757,
            "候选列表扫描",
            "尸体坐标=",
            data.X,
            data.Y,
            "正式候选数=",
            #result,
            "额外候选数=",
            extraUnits == nil and "nil" or #extraUnits,
            "拾取半径=",
            _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["共生腐朽虫群"]["虫尸拾取半径"]
        )
        if extraUnits ~= nil then
            do
                local i = 0
                while i < #extraUnits do
                    local unit = extraUnits[i + 1]
                    local valid = _____5355_4F4D_6709_6548(unit)
                    if valid and data.X ~= nil and data.Y ~= nil then
                        local unitX = GetUnitX(unit)
                        local unitY = GetUnitY(unit)
                        debugLogForce(
                            _____866B_5C38_62FE_53D6_8C03_8BD5_6A21_5757,
                            "额外候选",
                            "索引=",
                            i,
                            "单位=",
                            unit,
                            "有效=",
                            true,
                            "单位坐标=",
                            unitX,
                            unitY,
                            "距离=",
                            _____8BA1_7B97_8DDD_79BB(data.X, data.Y, unitX, unitY)
                        )
                    else
                        debugLogForce(
                            _____866B_5C38_62FE_53D6_8C03_8BD5_6A21_5757,
                            "额外候选",
                            "索引=",
                            i,
                            "单位=",
                            unit,
                            "有效=",
                            valid
                        )
                    end
                    i = i + 1
                end
            end
        end
    end
    if extraUnits == nil then
        if shouldLog then
            debugLogForce(_____866B_5C38_62FE_53D6_8C03_8BD5_6A21_5757, "候选列表完成", "总候选数=", #result)
            data["已输出拾取候选日志"] = true
        end
        return result
    end
    do
        local i = 0
        while i < #extraUnits do
            do
                local unit = extraUnits[i + 1]
                if not _____5355_4F4D_6709_6548(unit) then
                    goto __continue16
                end
                local exists = false
                do
                    local j = 0
                    while j < #result do
                        if result[j + 1] == unit then
                            exists = true
                            break
                        end
                        j = j + 1
                    end
                end
                if not exists then
                    result[#result + 1] = unit
                end
            end
            ::__continue16::
            i = i + 1
        end
    end
    if shouldLog then
        debugLogForce(_____866B_5C38_62FE_53D6_8C03_8BD5_6A21_5757, "候选列表完成", "总候选数=", #result)
        data["已输出拾取候选日志"] = true
    end
    return result
end
local function _____64AD_653E_83AB_5C14_7279_65AF_866B_5C38_62FE_53D6_9A71_6563_7279_6548(picker)
    if not _____5355_4F4D_6709_6548(picker) then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["共生腐朽虫群"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["虫尸拾取驱散特效路径"],
        X = GetUnitX(picker),
        Y = GetUnitY(picker),
        ["缩放"] = cfg["虫尸拾取驱散特效缩放"],
        ["持续秒"] = cfg["虫尸拾取驱散特效持续秒"]
    })
end
local function _____83AB_5C14_7279_65AF_866B_5C38_62FE_53D6(picker, _____5B9E_4F8B, variable)
    local data = variable
    if data == nil then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["共生腐朽虫群"]
    local pickerX = _____5355_4F4D_6709_6548(picker) and GetUnitX(picker) or nil
    local pickerY = _____5355_4F4D_6709_6548(picker) and GetUnitY(picker) or nil
    debugLogForce(
        _____866B_5C38_62FE_53D6_8C03_8BD5_6A21_5757,
        "拾取命中",
        "拾取单位=",
        picker,
        "尸体坐标=",
        data.X,
        data.Y,
        "拾取单位坐标=",
        pickerX,
        pickerY,
        "距离=",
        data.X ~= nil and data.Y ~= nil and pickerX ~= nil and pickerY ~= nil and _____8BA1_7B97_8DDD_79BB(data.X, data.Y, pickerX, pickerY) or "nil"
    )
    if _____5B9E_4F8B ~= nil and _____5B9E_4F8B["特效"] ~= nil and _____5B9E_4F8B["特效"] ~= 0 then
        _____6269_5C55__8BBE_7279_6548_901F_5EA6(_____5B9E_4F8B["特效"], cfg["虫尸特效正常播放速度"])
    end
    _____64AD_653E_83AB_5C14_7279_65AF_866B_5C38_62FE_53D6_9A71_6563_7279_6548(picker)
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
local function _____83AB_5C14_7279_65AF_866B_5C38_9500_6BC1(_____5B9E_4F8B, _____539F_56E0, variable)
    local data = variable
    if data == nil then
        return
    end
    data["已销毁"] = true
    debugLogForce(
        _____866B_5C38_62FE_53D6_8C03_8BD5_6A21_5757,
        "尸体销毁",
        "实例=",
        _____5B9E_4F8B == nil and "nil" or _____5B9E_4F8B.ID,
        "原因=",
        _____539F_56E0,
        "尸体坐标=",
        data.X,
        data.Y
    )
end
local function _____51BB_7ED3_83AB_5C14_7279_65AF_866B_5C38_7279_6548(variable)
    local data = variable
    if data == nil or data["拾取物变量"]["已销毁"] == true then
        return
    end
    if data["特效"] == nil or data["特效"] == 0 then
        return
    end
    _____6269_5C55__8BBE_7279_6548_901F_5EA6(data["特效"], 0)
end
local function _____521B_5EFA_866B_5C38_62FE_53D6_7269(context, x, y)
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["共生腐朽虫群"]
    local _____62FE_53D6_7269_53D8_91CF = {context = context, ["已销毁"] = false, X = x, Y = y}
    local _____5B9E_4F8B = _____521B_5EFA_6218_6597_5185_62FE_53D6_7269({
        ["清理"] = context["清理"],
        ["名称"] = "莫尔特斯-腐败虫尸",
        X = x,
        Y = y,
        ["模型路径"] = cfg["虫尸模型路径"],
        ["缩放"] = 0.55,
        ["持续秒"] = cfg["虫尸持续秒"],
        ["拾取半径"] = cfg["虫尸拾取半径"],
        ["变量"] = _____62FE_53D6_7269_53D8_91CF,
        ["可拾取单位列表"] = _____83AB_5C14_7279_65AF_866B_5C38_53EF_62FE_53D6_5355_4F4D,
        ["on拾取"] = _____83AB_5C14_7279_65AF_866B_5C38_62FE_53D6,
        ["on销毁"] = _____83AB_5C14_7279_65AF_866B_5C38_9500_6BC1
    })
    if _____5B9E_4F8B == nil or _____5B9E_4F8B["特效"] == nil or _____5B9E_4F8B["特效"] == 0 then
        debugLogForce(
            _____866B_5C38_62FE_53D6_8C03_8BD5_6A21_5757,
            "尸体创建失败",
            "尸体坐标=",
            x,
            y
        )
        return
    end
    debugLogForce(
        _____866B_5C38_62FE_53D6_8C03_8BD5_6A21_5757,
        "尸体创建成功",
        "实例=",
        _____5B9E_4F8B.ID,
        "尸体坐标=",
        x,
        y,
        "拾取半径=",
        cfg["虫尸拾取半径"],
        "测试额外候选数=",
        context["测试额外虫尸拾取单位"] == nil and "nil" or #context["测试额外虫尸拾取单位"]
    )
    _____6269_5C55__8BBE_7279_6548_901F_5EA6(_____5B9E_4F8B["特效"], cfg["虫尸特效播放速度"])
    local _____51BB_7ED3ID = addDelayedCallback(cfg["虫尸特效冻结延迟秒"] * 1000, _____51BB_7ED3_83AB_5C14_7279_65AF_866B_5C38_7279_6548, {["特效"] = _____5B9E_4F8B["特效"], ["拾取物变量"] = _____62FE_53D6_7269_53D8_91CF})
    local ____self_12 = context["清理"]
    ____self_12["登记延迟回调"](____self_12, "莫尔特斯-腐败虫尸动画冻结", _____51BB_7ED3ID)
end
local function _____5EF6_8FDF_521B_5EFA_83AB_5C14_7279_65AF_866B_5C38(variable)
    local data = variable
    if data == nil then
        return
    end
    _____521B_5EFA_866B_5C38_62FE_53D6_7269(data.context, data.X, data.Y)
end
local function _____521B_5EFA_7532_866B_7206_70B8_7279_6548(context, x, y)
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["共生腐朽虫群"]
    return _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["爆炸特效路径"],
        X = x,
        Y = y,
        ["缩放"] = cfg["爆炸特效缩放"],
        ["持续秒"] = cfg["爆炸特效持续秒"]
    })
end
local function _____7206_70B8_7532_866B(data)
    local boss = data.context["Boss单位"]
    local target = data["接触目标"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["共生腐朽虫群"]
    _____521B_5EFA_7532_866B_7206_70B8_7279_6548(
        data.context,
        GetUnitX(target),
        GetUnitY(target)
    )
    _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = boss,
        ["目标"] = target,
        ["伤害公式"] = {["来源攻击力比例"] = cfg["爆炸伤害Boss攻击力比例"]},
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_PLANT,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["技能实例ID"] = data["技能实例ID"],
        ["标签"] = "莫尔特斯共生腐朽虫群"
    })
    _____589E_52A0_73A9_5BB6_8150_8D25_503C(data.context, target, cfg["爆炸腐败值"])
end
local function _____6392_961F_51FB_6740_5171_751F_8150_673D_866B_7FA4_7532_866B(______6267_884C_6B21_6570, variable)
    local data = variable
    if data == nil or data["甲虫单位列表"] == nil then
        return false
    end
    if data["下一个索引"] >= #data["甲虫单位列表"] then
        return false
    end
    local beetle = data["甲虫单位列表"][data["下一个索引"] + 1]
    data["下一个索引"] = data["下一个索引"] + 1
    if _____5355_4F4D_6709_6548(beetle) then
        _____521B_5EFA_7532_866B_7206_70B8_7279_6548(
            data.context,
            GetUnitX(beetle),
            GetUnitY(beetle)
        )
        KillUnit(beetle)
    end
    return data["下一个索引"] < #data["甲虫单位列表"]
end
local function _____5EF6_8FDF_51FB_6740_5171_751F_8150_673D_866B_7FA4_7532_866B(variable)
    local data = variable
    if data == nil or data.context == nil or data["甲虫单位列表"] == nil or #data["甲虫单位列表"] == 0 then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["共生腐朽虫群"]
    data["下一个索引"] = 0
    data["周期"] = _____521B_5EFA_9650_6B21_5468_671F_6267_884C_5668({
        ["名称"] = "莫尔特斯测试-7-2-排队击杀甲虫",
        ["间隔毫秒"] = cfg["测试击杀间隔毫秒"],
        ["最大执行次数"] = #data["甲虫单位列表"],
        ["变量"] = data,
        ["清理"] = data.context["清理"],
        onTick = _____6392_961F_51FB_6740_5171_751F_8150_673D_866B_7FA4_7532_866B
    })
end
local function _____7532_866B_8FFD_51FBTick(data)
    local beetle = data["甲虫单位"]
    if not _____5355_4F4D_6709_6548(beetle) or not _____5355_4F4D_6709_6548(data.context["Boss单位"]) then
        return false
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["共生腐朽虫群"]
    local target = _____53D6_7532_866B_76EE_6807(data.context)
    if not _____5355_4F4D_6709_6548(target) then
        return true
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
            return false
        end
    else
        data["接触目标"] = nil
        data["接触Ticks"] = 0
    end
    return true
end
local function _____83AB_5C14_7279_65AF_7532_866B_8FFD_51FB_5468_671F(______6267_884C_6B21_6570, variable)
    local data = variable
    if data == nil then
        return false
    end
    return _____7532_866B_8FFD_51FBTick(data)
end
local function _____83AB_5C14_7279_65AF_7532_866B_6B7B_4EA1(unit, ______51FB_6740_8005, variable)
    local data = variable
    if data == nil then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["共生腐朽虫群"]
    local x = GetUnitX(unit)
    local y = GetUnitY(unit)
    RemoveUnit(unit)
    debugLogForce(
        _____866B_5C38_62FE_53D6_8C03_8BD5_6A21_5757,
        "原始甲虫单位已移除",
        "单位=",
        unit,
        "尸体坐标=",
        x,
        y
    )
    local delayedId = addDelayedCallback(cfg["虫尸死亡后延迟秒"] * 1000, _____5EF6_8FDF_521B_5EFA_83AB_5C14_7279_65AF_866B_5C38, {context = data.context, X = x, Y = y})
    local ____self_13 = data.context["清理"]
    ____self_13["登记延迟回调"](____self_13, "莫尔特斯-腐败虫尸生成", delayedId)
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
        return nil
    end
    _____4E34_65F6_8C03_6574_653B_51FB(instance["单位"], cfg["甲虫攻击力"])
    local data = {
        context = context,
        ["甲虫单位"] = instance["单位"],
        ["接触目标"] = nil,
        ["接触Ticks"] = 0,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    }
    data["周期"] = _____521B_5EFA_5468_671F_884C_4E3A({
        ["名称"] = "莫尔特斯-甲虫追击",
        ["间隔毫秒"] = cfg["追击刷新间隔毫秒"],
        ["变量"] = data,
        ["清理"] = context["清理"],
        onTick = _____83AB_5C14_7279_65AF_7532_866B_8FFD_51FB_5468_671F
    })
    return instance["单位"]
end
local function _____7ED3_7B97_83AB_5C14_7279_65AF_5171_751F_8150_673D_866B_7FA4(variable)
    local data = variable
    if data == nil or not _____5355_4F4D_6709_6548(data.context["Boss单位"]) then
        return
    end
    local context = data.context
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["共生腐朽虫群"]
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["共生腐朽虫群"]["甲虫入场"],
        GetUnitX(context["Boss单位"]),
        GetUnitY(context["Boss单位"]),
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    local _____6280_80FD_5B9E_4F8BID = _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B({["来源类型"] = "Boss技能", ["标签"] = "莫尔特斯共生腐朽虫群", ["持续时间秒"] = cfg["接触爆炸秒"] + 12})
    local _____7532_866B_5355_4F4D_5217_8868 = {}
    do
        local i = 0
        while i < cfg["甲虫数量"] do
            local beetle = _____521B_5EFA_8150_5316_7532_866B(context, i * 90, _____6280_80FD_5B9E_4F8BID)
            if _____5355_4F4D_6709_6548(beetle) then
                _____7532_866B_5355_4F4D_5217_8868[#_____7532_866B_5355_4F4D_5217_8868 + 1] = beetle
            end
            i = i + 1
        end
    end
    if data["释放选项"] ~= nil and data["释放选项"]["召唤后延迟击杀全部甲虫"] == true and #_____7532_866B_5355_4F4D_5217_8868 > 0 then
        local delayedId = addDelayedCallback(2000, _____5EF6_8FDF_51FB_6740_5171_751F_8150_673D_866B_7FA4_7532_866B, {context = context, ["甲虫单位列表"] = _____7532_866B_5355_4F4D_5217_8868, ["下一个索引"] = 0, ["周期ID"] = 0})
        local ____self_14 = context["清理"]
        ____self_14["登记延迟回调"](____self_14, "莫尔特斯测试-7-2-击杀甲虫", delayedId)
    end
end
____exports["释放莫尔特斯共生腐朽虫群"] = function(context, _____91CA_653E_9009_9879)
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return false
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["共生腐朽虫群"]
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["名称"] = "莫尔特斯-共生腐朽虫群",
        ["施法者"] = context["Boss单位"],
        ["硬直秒"] = cfg["动作播放秒"],
        ["动画编号"] = cfg["动画编号"],
        ["动画速度"] = cfg["动画速度"],
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = cfg["动作播放秒"],
            ["颜色ID"] = 3,
            ["标题文本"] = "共生腐朽虫群",
            ["提示文本"] = "腐化甲虫将在读条结束后涌出"
        },
        ["清理"] = context["清理"],
        ["on生效"] = function()
            _____7ED3_7B97_83AB_5C14_7279_65AF_5171_751F_8150_673D_866B_7FA4({context = context, ["释放选项"] = _____91CA_653E_9009_9879})
        end
    })
    return true
end
____exports["测试释放莫尔特斯共生腐朽虫群并延迟击杀"] = function(context)
    return ____exports["释放莫尔特斯共生腐朽虫群"](context, {["召唤后延迟击杀全部甲虫"] = true})
end
return ____exports
