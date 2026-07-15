--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5F71_9AA8_6697_5F71_7981_9522_53D6_76EE_6807_5217_8868, _____5F71_9AA8_6697_5F71_7981_9522_76EE_6807_6709_6548, _____5F71_9AA8_6697_5F71_7981_9522_65BD_52A0_63A7_5236, _____521B_5EFA_5F71_9AA8_6697_5F71_6CD5_9635, GetOwningPlayer, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, _____521B_5EFA_53EF_653B_51FB_63A7_5236_6CD5_9635, _____65BD_52A0_7981_9522, registerManualBuff, _____5F71_9AA8_83AB_7279_65AFBuffID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.00．配置")
local _____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["影骨莫特斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建影骨莫特斯上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.02．数值与表现配置")
local _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯数值与表现配置"]
local _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯表现配置"]
local _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯音效配置"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.08．台词播放")
local _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放影骨莫特斯台词"]
local ____11_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.11．公共工具")
local _____5355_4F4D_6709_6548 = ____11_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____64AD_653E_5F71_9AA8_83AB_7279_65AF_9650_65F6_52A8_4F5C = ____11_FF0E_516C_5171_5DE5_5177["播放影骨莫特斯限时动作"]
local stringToFourCC = ____11_FF0E_516C_5171_5DE5_5177.stringToFourCC
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
function _____5F71_9AA8_6697_5F71_7981_9522_53D6_76EE_6807_5217_8868(variable)
    local data = variable
    if data == nil then
        return {}
    end
    return _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(data.context["Boss单位"])
end
function _____5F71_9AA8_6697_5F71_7981_9522_76EE_6807_6709_6548(target)
    return _____5355_4F4D_6709_6548(target)
end
function _____5F71_9AA8_6697_5F71_7981_9522_65BD_52A0_63A7_5236(target, duration, variable)
    local data = variable
    if data == nil then
        return
    end
    _____65BD_52A0_7981_9522({["来源单位"] = data.context["Boss单位"], ["目标单位"] = target, ["持续时间"] = duration})
    registerManualBuff(
        target,
        _____5F71_9AA8_83AB_7279_65AFBuffID["暗影禁锢"],
        duration,
        1,
        {sourceName = "影骨-暗影禁锢"}
    )
end
function _____521B_5EFA_5F71_9AA8_6697_5F71_6CD5_9635(context, x, y)
    local cfg = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["暗影禁锢"]
    _____64AD_653EBoss_5750_6807_97F3_6548(_____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["暗影禁锢"]["法阵生效"], x, y, _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"])
    _____521B_5EFA_53EF_653B_51FB_63A7_5236_6CD5_9635({
        ["清理"] = context["清理"],
        ["名称"] = "影骨-暗影禁锢法阵",
        ["主人单位"] = context["Boss单位"],
        ["所属玩家"] = GetOwningPlayer(context["Boss单位"]),
        ["单位类型"] = cfg["法阵单位类型"],
        ["模型路径"] = _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["暗影禁锢法阵"],
        X = x,
        Y = y,
        ["半径"] = cfg["半径"],
        ["最大生命"] = cfg["法阵生命值"],
        ["缩放"] = cfg["法阵缩放"],
        ["持续秒"] = cfg["禁锢秒"],
        ["摧毁后剩余秒"] = cfg["摧毁后剩余秒"],
        ["变量"] = {context = context},
        ["取目标列表"] = _____5F71_9AA8_6697_5F71_7981_9522_53D6_76EE_6807_5217_8868,
        ["目标有效"] = _____5F71_9AA8_6697_5F71_7981_9522_76EE_6807_6709_6548,
        ["施加控制"] = _____5F71_9AA8_6697_5F71_7981_9522_65BD_52A0_63A7_5236,
        ["创建特效路径"] = _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["暗影禁锢法阵"],
        ["摧毁特效路径"] = _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["暗影禁锢摧毁"]
    })
end
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
GetOwningPlayer = jass.GetOwningPlayer
local GetRandomReal = jass.GetRandomReal
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_1["获取Boss技能随机敌对英雄"]
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_2["创建技能提示圈"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.04．可攻击控制法阵")
_____521B_5EFA_53EF_653B_51FB_63A7_5236_6CD5_9635 = ____require_result_3["创建可攻击控制法阵"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.18．周期范围效果.06．对外接口")
_____65BD_52A0_7981_9522 = ____require_result_4["施加禁锢"]
local ____require_result_5 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_5.registerManualBuff
local ____require_result_6 = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.04．影骨莫特斯")
_____5F71_9AA8_83AB_7279_65AFBuffID = ____require_result_6["影骨莫特斯BuffID"]
local _____5F71_9AA8_5355_4F4D_7C7B_578BID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____6697_5F71_7981_9522_6280_80FDID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["暗影禁锢"])
local _____5DF2_6CE8_518C_6697_5F71_7981_9522 = false
local function _____5F71_9AA8_6697_5F71_7981_9522_751F_6548(variable)
    local data = variable
    if data == nil then
        return
    end
    _____521B_5EFA_5F71_9AA8_6697_5F71_6CD5_9635(data.context, data.x, data.y)
end
____exports["释放影骨暗影禁锢"] = function(context, target)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD(context["Boss单位"], "暗影禁锢")
    local cfg = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["暗影禁锢"]
    _____64AD_653E_5F71_9AA8_83AB_7279_65AF_9650_65F6_52A8_4F5C(context["Boss单位"], cfg["动画编号"], cfg["动画速度"], cfg["动画播放秒"])
    local x = GetUnitX(target)
    local y = GetUnitY(target)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "圆形",
        X = x,
        Y = y,
        ["半径"] = cfg["半径"],
        ["持续时间"] = cfg["预警秒"],
        ["来源单位"] = context["Boss单位"]
    })
    _____64AD_653EBoss_5750_6807_97F3_6548(_____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["暗影禁锢"]["预警"], x, y, _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"])
    local id = addDelayedCallback(cfg["预警秒"] * 1000, _____5F71_9AA8_6697_5F71_7981_9522_751F_6548, {context = context, x = x, y = y})
    local ____self_7 = context["清理"]
    ____self_7["登记延迟回调"](____self_7, "影骨-暗影禁锢", id)
end
____exports["尝试触发影骨暗影禁锢"] = function(context, nowMs)
    local cfg = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["暗影禁锢"]
    if context["下次暗影禁锢间隔Ms"] <= 0 then
        context["下次暗影禁锢间隔Ms"] = GetRandomReal(cfg["触发间隔最小秒"], cfg["触发间隔最大秒"]) * 1000
    end
    if context["上次暗影禁锢Ms"] <= 0 then
        context["上次暗影禁锢Ms"] = nowMs
        return
    end
    if context["上次暗影禁锢Ms"] > 0 and nowMs - context["上次暗影禁锢Ms"] < context["下次暗影禁锢间隔Ms"] then
        return
    end
    local target = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(context["Boss单位"], context["Boss单位"], cfg["目标搜索半径"])
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    context["上次暗影禁锢Ms"] = nowMs
    context["下次暗影禁锢间隔Ms"] = GetRandomReal(cfg["触发间隔最小秒"], cfg["触发间隔最大秒"]) * 1000
    ____exports["释放影骨暗影禁锢"](context, target)
end
local function ____on_5F71_9AA8_6697_5F71_7981_9522_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____6697_5F71_7981_9522_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____5F71_9AA8_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    local spellTarget = GetSpellTargetUnit()
    local _____5355_4F4D_6709_6548_result_8
    if _____5355_4F4D_6709_6548(spellTarget) then
        _____5355_4F4D_6709_6548_result_8 = spellTarget
    else
        _____5355_4F4D_6709_6548_result_8 = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(castingUnit)
    end
    local target = _____5355_4F4D_6709_6548_result_8
    ____exports["释放影骨暗影禁锢"](context, target)
end
____exports["注册影骨莫特斯暗影禁锢"] = function()
    if _____5DF2_6CE8_518C_6697_5F71_7981_9522 then
        return
    end
    _____5DF2_6CE8_518C_6697_5F71_7981_9522 = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "05．暗影禁锢",
        ["单位类型ID"] = _____5F71_9AA8_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____6697_5F71_7981_9522_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_5F71_9AA8_6697_5F71_7981_9522_65BD_6CD5(boss, _____6697_5F71_7981_9522_6280_80FDID)
        end
    })
end
return ____exports
