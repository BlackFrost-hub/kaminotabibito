--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.01．运行时上下文")
local _____589E_52A0_73A9_5BB6_8150_8D25_503C = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["增加玩家腐败值"]
local _____6E05_9664_73A9_5BB6_8150_8D25_503C = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["清除玩家腐败值"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.02．数值与表现配置")
local _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯数值与表现配置"]
local _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯音效配置"]
local ____13_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.13．台词播放")
local _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD = ____13_FF0E_53F0_8BCD_64AD_653E["播放莫尔特斯台词"]
local ____16_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.16．公共工具")
local _____5355_4F4D_6709_6548 = ____16_FF0E_516C_5171_5DE5_5177["单位有效"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60 = ____00_FF0EBoss_97F3_6548_64AD_653E["尝试播放Boss拟声池"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____63D0_4EA4_9884_8BA1_7B97Boss_5355_4F53_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["提交预计算Boss单体技能伤害"]
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_0["创建独立技能伤害实例"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_1["创建点特效"]
local jass = require("jass.common")
local AddSpecialEffect = jass.AddSpecialEffect
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRandomInt = jass.GetRandomInt
local Location = jass.Location
local RemoveLocation = jass.RemoveLocation
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_2 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_2["获取Boss技能敌对英雄列表"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_3["创建技能提示圈"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_4["启动基础施法时间线"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_5["施加快速减速Buff"]
local ____require_result_6 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_6.registerManualBuff
local ____require_result_7 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_7.addDelayedCallback
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_8["读取单位攻击力"]
local ____require_result_9 = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.03．莫尔特斯")
local _____83AB_5C14_7279_65AFBuffID = ____require_result_9["莫尔特斯BuffID"]
local ____require_result_10 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_10.debugLogForce
local ____require_result_11 = require("lib.扩展函数.BJ函数.11．贴图函数")
local CreateUbersplatBJ = ____require_result_11.CreateUbersplatBJ
local ShowUbersplatBJ = ____require_result_11.ShowUbersplatBJ
local SetUbersplatRenderAlways = ____require_result_11.SetUbersplatRenderAlways
local _____8150_673D_9886_57DF_8C03_8BD5_6A21_5757 = "莫尔特斯-腐朽领域"
local function _____521B_5EFA_8150_673D_9886_57DF_6CBC_6CFD_5730_8868(context)
    local grid = context["根须宫格"]
    if grid == nil then
        debugLogForce(_____8150_673D_9886_57DF_8C03_8BD5_6A21_5757, "地表创建跳过", "原因=根须宫格为空")
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽领域"]
    local color = cfg["沼泽贴图颜色"]
    local _____683C_5B50_5217_8868 = grid["格子列表"]
    if #_____683C_5B50_5217_8868 == 0 then
        debugLogForce(_____8150_673D_9886_57DF_8C03_8BD5_6A21_5757, "地表创建跳过", "原因=九宫格没有格子")
        return
    end
    local _____8986_76D6_884C_6570 = cfg["沼泽贴图覆盖行数"]
    local _____8986_76D6_5217_6570 = cfg["沼泽贴图覆盖列数"]
    local _____603B_5BBD_5EA6 = grid["宽度"]
    local _____603B_9AD8_5EA6 = grid["高度"]
    local _____9996_683C = _____683C_5B50_5217_8868[1]
    local _____672B_683C = _____683C_5B50_5217_8868[#_____683C_5B50_5217_8868]
    local _____5BAB_683C_4E2D_5FC3X = (_____9996_683C["左"] + _____672B_683C["右"]) / 2
    local _____5BAB_683C_4E2D_5FC3Y = (_____9996_683C["下"] + _____672B_683C["上"]) / 2
    local _____4E2D_5FC3X = context["根须领域中心X"] or _____5BAB_683C_4E2D_5FC3X
    local _____4E2D_5FC3Y = context["根须领域中心Y"] or _____5BAB_683C_4E2D_5FC3Y
    local _____8D77_70B9X = _____4E2D_5FC3X - _____603B_5BBD_5EA6 / 2
    local _____8D77_70B9Y = _____4E2D_5FC3Y - _____603B_9AD8_5EA6 / 2
    local _____91C7_6837_5BBD_5EA6 = _____603B_5BBD_5EA6 / _____8986_76D6_5217_6570
    local _____91C7_6837_9AD8_5EA6 = _____603B_9AD8_5EA6 / _____8986_76D6_884C_6570
    debugLogForce(
        _____8150_673D_9886_57DF_8C03_8BD5_6A21_5757,
        "地表创建开始",
        "覆盖网格=",
        _____8986_76D6_884C_6570,
        "x",
        _____8986_76D6_5217_6570,
        "类型=",
        cfg["沼泽贴图类型"],
        "颜色=",
        color.r,
        color.g,
        color.b,
        color.a,
        "强制暂停=",
        cfg["沼泽贴图强制暂停"],
        "无出生时间=",
        cfg["沼泽贴图无出生时间"],
        "中心=",
        _____4E2D_5FC3X,
        _____4E2D_5FC3Y
    )
    local _____6210_529F_6570_91CF = 0
    do
        local row = 0
        while row < _____8986_76D6_884C_6570 do
            do
                local col = 0
                while col < _____8986_76D6_5217_6570 do
                    do
                        local x = _____8D77_70B9X + _____91C7_6837_5BBD_5EA6 * (col + 0.5)
                        local y = _____8D77_70B9Y + _____91C7_6837_9AD8_5EA6 * (row + 0.5)
                        local loc = Location(x, y)
                        local ubersplat = CreateUbersplatBJ(
                            loc,
                            cfg["沼泽贴图类型"],
                            color.r,
                            color.g,
                            color.b,
                            color.a,
                            cfg["沼泽贴图强制暂停"],
                            cfg["沼泽贴图无出生时间"]
                        )
                        RemoveLocation(loc)
                        local index = row * _____8986_76D6_5217_6570 + col
                        debugLogForce(
                            _____8150_673D_9886_57DF_8C03_8BD5_6A21_5757,
                            "地表贴图返回",
                            "索引=",
                            index,
                            "x=",
                            x,
                            "y=",
                            y,
                            "句柄=",
                            ubersplat
                        )
                        if ubersplat == nil or ubersplat == 0 then
                            goto __continue8
                        end
                        SetUbersplatRenderAlways(ubersplat, true)
                        ShowUbersplatBJ(true, ubersplat)
                        debugLogForce(
                            _____8150_673D_9886_57DF_8C03_8BD5_6A21_5757,
                            "地表贴图已显示",
                            "索引=",
                            index,
                            "句柄=",
                            ubersplat
                        )
                        local ____self_12 = context["清理"]
                        ____self_12["登记贴图"](____self_12, "莫尔特斯-腐朽领域沼泽", ubersplat)
                        _____6210_529F_6570_91CF = _____6210_529F_6570_91CF + 1
                    end
                    ::__continue8::
                    col = col + 1
                end
            end
            row = row + 1
        end
    end
    debugLogForce(_____8150_673D_9886_57DF_8C03_8BD5_6A21_5757, "地表创建结束", "成功数量=", _____6210_529F_6570_91CF)
end
local function _____521B_5EFA_51C0_5316_7B26_6587(context)
    local grid = context["根须宫格"]
    if grid == nil then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽领域"]
    local cells = {
        grid["获取格子"](grid, 0, 0),
        grid["获取格子"](grid, 0, 2),
        grid["获取格子"](grid, 2, 0),
        grid["获取格子"](grid, 2, 2)
    }
    do
        local i = 0
        while i < cfg["净化符文数量"] and i < #cells do
            do
                local cell = cells[i + 1]
                if cell == nil then
                    goto __continue13
                end
                local effect = AddSpecialEffect(cfg["净化符文模型路径"], cell["中心X"], cell["中心Y"])
                local ____self_13 = context["清理"]
                ____self_13["登记特效"](____self_13, "莫尔特斯-净化符文", effect)
                _____521B_5EFA_6280_80FD_63D0_793A_5708({
                    ["类型"] = "白色安全圆",
                    X = cell["中心X"],
                    Y = cell["中心Y"],
                    ["半径"] = cfg["净化符文半径"],
                    ["持续时间"] = cfg["净化持续秒"]
                })
            end
            ::__continue13::
            i = i + 1
        end
    end
end
local function _____521B_5EFA_8150_673D_9886_57DF_4E2D_5FC3Tick_7279_6548(context)
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽领域"]
    local _____6839_987B_9886_57DF_914D_7F6E = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["根须领域"]
    local grid = context["根须宫格"]
    local ____temp_14
    if grid == nil then
        ____temp_14 = nil
    else
        ____temp_14 = grid["格子列表"]
    end
    local _____683C_5B50_5217_8868 = ____temp_14
    local ____temp_15
    if _____683C_5B50_5217_8868 ~= nil and #_____683C_5B50_5217_8868 > 0 then
        ____temp_15 = _____683C_5B50_5217_8868[1]
    else
        ____temp_15 = nil
    end
    local _____9996_683C = ____temp_15
    local ____temp_16
    if _____683C_5B50_5217_8868 ~= nil and #_____683C_5B50_5217_8868 > 0 then
        ____temp_16 = _____683C_5B50_5217_8868[#_____683C_5B50_5217_8868]
    else
        ____temp_16 = nil
    end
    local _____672B_683C = ____temp_16
    local _____4E2D_5FC3X = context["根须领域中心X"] or (_____9996_683C ~= nil and _____672B_683C ~= nil and (_____9996_683C["左"] + _____672B_683C["右"]) / 2 or _____6839_987B_9886_57DF_914D_7F6E["中心X"])
    local _____4E2D_5FC3Y = context["根须领域中心Y"] or (_____9996_683C ~= nil and _____672B_683C ~= nil and (_____9996_683C["下"] + _____672B_683C["上"]) / 2 or _____6839_987B_9886_57DF_914D_7F6E["中心Y"])
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["沼泽Tick特效路径"],
        X = _____4E2D_5FC3X,
        Y = _____4E2D_5FC3Y,
        ["持续秒"] = cfg["沼泽Tick特效持续秒"],
        ["缩放"] = cfg["沼泽Tick特效缩放"]
    })
end
local function _____5904_7406_51C0_5316_7B26_6587(context, hero)
    local grid = context["根须宫格"]
    if grid == nil then
        return false
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽领域"]
    local cells = {
        grid["获取格子"](grid, 0, 0),
        grid["获取格子"](grid, 0, 2),
        grid["获取格子"](grid, 2, 0),
        grid["获取格子"](grid, 2, 2)
    }
    do
        local i = 0
        while i < #cells do
            do
                local cell = cells[i + 1]
                if cell == nil then
                    goto __continue19
                end
                local dx = GetUnitX(hero) - cell["中心X"]
                local dy = GetUnitY(hero) - cell["中心Y"]
                if dx * dx + dy * dy <= cfg["净化符文半径"] * cfg["净化符文半径"] then
                    _____6E05_9664_73A9_5BB6_8150_8D25_503C(context, hero, _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败值"]["净化光斑每秒清除"])
                    registerManualBuff(
                        hero,
                        _____83AB_5C14_7279_65AFBuffID["净化庇护"],
                        1.2,
                        1,
                        {sourceName = "莫尔特斯-净化符文"}
                    )
                    return true
                end
            end
            ::__continue19::
            i = i + 1
        end
    end
    return false
end
local function _____83AB_5C14_7279_65AF_8150_673D_6CBC_6CFD_6839_987B(variable)
    local data = variable
    if data == nil then
        return
    end
    local context = data.context
    local target = data.target
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local _____7A7F_523A_914D_7F6E = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽根须穿刺"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____7A7F_523A_914D_7F6E["穿刺特效路径"],
        X = data.X,
        Y = data.Y,
        ["持续秒"] = _____7A7F_523A_914D_7F6E["瞬时特效持续秒"],
        ["缩放"] = _____7A7F_523A_914D_7F6E["穿刺命中特效缩放"]
    })
    _____63D0_4EA4_9884_8BA1_7B97Boss_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = context["Boss单位"],
        ["目标"] = target,
        ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(context["Boss单位"]),
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_PLANT,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["技能实例ID"] = data["技能实例ID"],
        ["标签"] = "莫尔特斯腐朽领域根须"
    })
    _____589E_52A0_73A9_5BB6_8150_8D25_503C(context, target, _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽根须穿刺"]["腐败值"])
end
local function _____7ED3_7B97_83AB_5C14_7279_65AF_8150_673D_9886_57DF_5C55_5F00(variable)
    local context = variable
    if context == nil or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return
    end
    debugLogForce(
        _____8150_673D_9886_57DF_8C03_8BD5_6A21_5757,
        "展开结算",
        "根须宫格=",
        context["根须宫格"] == nil and "nil" or "ready",
        "中心=",
        context["根须领域中心X"],
        context["根须领域中心Y"]
    )
    context["腐朽领域已生效"] = true
    _____521B_5EFA_8150_673D_9886_57DF_6CBC_6CFD_5730_8868(context)
    _____521B_5EFA_51C0_5316_7B26_6587(context)
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["腐朽领域"]["展开"],
        GetUnitX(context["Boss单位"]),
        GetUnitY(context["Boss单位"]),
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60({
        ["标识"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["标识"],
        ["音效路径列表"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["音效路径列表"],
        X = GetUnitX(context["Boss单位"]),
        Y = GetUnitY(context["Boss单位"]),
        ["裁断距离"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"],
        ["冷却Ms"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["冷却Ms"],
        ["触发概率百分比"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["转阶段触发概率百分比"]
    })
end
____exports["触发莫尔特斯腐朽领域"] = function(context)
    if context["腐朽领域已触发"] or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        debugLogForce(
            _____8150_673D_9886_57DF_8C03_8BD5_6A21_5757,
            "触发跳过",
            "已触发=",
            context["腐朽领域已触发"],
            "Boss有效=",
            _____5355_4F4D_6709_6548(context["Boss单位"])
        )
        return
    end
    context["腐朽领域已触发"] = true
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽领域"]
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["名称"] = "莫尔特斯-腐朽领域",
        ["施法者"] = context["Boss单位"],
        ["硬直秒"] = cfg["动作播放秒"],
        ["动画编号"] = cfg["动画编号"],
        ["动画速度"] = cfg["动画速度"],
        ["吟唱条"] = {
            ["通道"] = "大招",
            ["总时长"] = cfg["动作播放秒"],
            ["颜色ID"] = 3,
            ["标题文本"] = "腐朽领域",
            ["提示文本"] = "腐败沼泽将在读条结束后覆盖场地"
        },
        ["清理"] = context["清理"],
        ["播放台词"] = function()
            _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD(context["Boss单位"], "低血量")
        end,
        ["on生效"] = function()
            _____7ED3_7B97_83AB_5C14_7279_65AF_8150_673D_9886_57DF_5C55_5F00(context)
        end
    })
    debugLogForce(
        _____8150_673D_9886_57DF_8C03_8BD5_6A21_5757,
        "触发成功",
        "延迟毫秒=",
        cfg["动作播放秒"] * 1000,
        "根须宫格=",
        context["根须宫格"] == nil and "nil" or "ready"
    )
end
____exports["处理莫尔特斯沼泽腐败"] = function(context)
    if not context["腐朽领域已生效"] or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return false
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽领域"]
    _____521B_5EFA_8150_673D_9886_57DF_4E2D_5FC3Tick_7279_6548(context)
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue34
                end
                if _____5904_7406_51C0_5316_7B26_6587(context, hero) then
                    goto __continue34
                end
                _____65BD_52A0_5FEB_901F_51CF_901FBuff(
                    context["Boss单位"],
                    hero,
                    cfg["减速比例"],
                    cfg["减速比例"],
                    1.3
                )
                _____589E_52A0_73A9_5BB6_8150_8D25_503C(context, hero, cfg["沼泽每跳腐败值"])
            end
            ::__continue34::
            i = i + 1
        end
    end
    return true
end
____exports["处理莫尔特斯沼泽根须"] = function(context)
    if not context["腐朽领域已生效"] or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return false
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽领域"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
    if #heroes <= 0 then
        return false
    end
    local target = heroes[GetRandomInt(0, #heroes - 1) + 1]
    if not _____5355_4F4D_6709_6548(target) then
        return true
    end
    local x = GetUnitX(target)
    local y = GetUnitY(target)
    local _____6280_80FD_5B9E_4F8BID = _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B({["来源类型"] = "Boss技能", ["标签"] = "莫尔特斯腐朽领域根须", ["持续时间秒"] = 3})
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "圆形",
        X = x,
        Y = y,
        ["半径"] = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["根须领域"]["单格边长"] * 0.5,
        ["持续时间"] = 1
    })
    local data = {
        context = context,
        target = target,
        X = x,
        Y = y,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    }
    local id = addDelayedCallback(cfg["根须结算延迟毫秒"], _____83AB_5C14_7279_65AF_8150_673D_6CBC_6CFD_6839_987B, data)
    local ____self_17 = context["清理"]
    ____self_17["登记延迟回调"](____self_17, "莫尔特斯-腐朽沼泽根须", id)
    return true
end
return ____exports
