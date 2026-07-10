--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____on_5F71_9AA8_83AB_7279_65AF_6B7B_4EA1, GetUnitTypeId, GetUnitState, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE, _____5F71_9AA8_83AB_7279_65AF_5355_4F4D_7C7B_578BID, _____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_5DE5_5382
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.00．配置")
local _____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["影骨莫特斯单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.02．数值与表现配置")
local _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯数值与表现配置"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.08．台词播放")
local _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放影骨莫特斯台词"]
local ____11_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.11．公共工具")
local _____5355_4F4D_6709_6548 = ____11_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____11_FF0E_516C_5171_5DE5_5177.stringToFourCC
____exports["清理影骨莫特斯上下文"] = function(boss)
    _____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
end
____exports["取影骨莫特斯当前阶段"] = function(boss)
    if not _____5355_4F4D_6709_6548(boss) then
        return 1
    end
    local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    if not (maxLife > 0) then
        return 1
    end
    local ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife
    if ratio <= _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段阈值"]["P3生命比例"] then
        return 3
    end
    if ratio <= _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段阈值"]["P2生命比例"] then
        return 2
    end
    return 1
end
function ____on_5F71_9AA8_83AB_7279_65AF_6B7B_4EA1(dyingUnit)
    if GetUnitTypeId(dyingUnit) ~= _____5F71_9AA8_83AB_7279_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD(dyingUnit, "死亡", 0)
    ____exports["清理影骨莫特斯上下文"](dyingUnit)
end
local jass = require("jass.common")
GetUnitTypeId = jass.GetUnitTypeId
GetUnitState = jass.GetUnitState
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
_____5F71_9AA8_83AB_7279_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____5F71_9AA8_83AB_7279_65AF_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local ____require_result_2 = require("系统.05．Buff系统.03．Buff表.01．Boss.10．影骨莫特斯")
local _____5F71_9AA8_83AB_7279_65AFBuffID = ____require_result_2["影骨莫特斯BuffID"]
local function _____521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587(boss, _____6E05_7406)
    _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD(boss, "开场", 0)
    return {
        ["Boss单位"] = boss,
        ["阶段"] = ____exports["取影骨莫特斯当前阶段"](boss),
        ["已初始化"] = false,
        ["清理"] = _____6E05_7406,
        ["已开启遗产宝箱数"] = 0,
        ["背刺准备"] = false,
        ["幽影爆发中"] = false,
        ["幽影召唤物"] = {},
        ["上次暗影禁锢Ms"] = 0,
        ["下次暗影禁锢间隔Ms"] = 0,
        ["下一个召唤组ID"] = 0,
        ["遗产宝箱已生成"] = false
    }
end
_____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({["名称"] = "影骨莫特斯", ["主动技能提示"] = _____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["主动技能提示"], ["创建上下文"] = _____521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587})
____exports["获取影骨莫特斯上下文"] = function(boss)
    return _____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_5DE5_5382["获取"](boss)
end
____exports["获取或创建影骨莫特斯上下文"] = function(boss)
    return _____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_5DE5_5382["获取或创建"](boss)
end
____exports["获取全部影骨莫特斯上下文"] = function()
    return _____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_5DE5_5382["获取全部"]()
end
____exports["刷新影骨莫特斯阶段"] = function(context)
    context["阶段"] = ____exports["取影骨莫特斯当前阶段"](context["Boss单位"])
    return context["阶段"]
end
____exports["设置影骨背刺准备"] = function(context, enabled)
    context["背刺准备"] = enabled
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return
    end
    if enabled then
        registerManualBuff(
            context["Boss单位"],
            _____5F71_9AA8_83AB_7279_65AFBuffID["背刺准备"],
            12,
            1,
            {sourceName = "影骨-背刺准备"}
        )
    else
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["Boss单位"], _____5F71_9AA8_83AB_7279_65AFBuffID["背刺准备"])
    end
end
____exports["刷新影骨幽灵形态Buff"] = function(context)
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return
    end
    if context["幽影爆发中"] then
        registerManualBuff(
            context["Boss单位"],
            _____5F71_9AA8_83AB_7279_65AFBuffID["幽灵形态"],
            _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["幽影爆发"]["持续秒"],
            1,
            {sourceName = "影骨-幽灵形态"}
        )
    else
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["Boss单位"], _____5F71_9AA8_83AB_7279_65AFBuffID["幽灵形态"])
    end
end
____exports["刷新影骨盗贼遗产Buff"] = function(context)
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) or context["已开启遗产宝箱数"] <= 0 then
        return
    end
    registerManualBuff(
        context["Boss单位"],
        _____5F71_9AA8_83AB_7279_65AFBuffID["盗贼遗产"],
        9999,
        context["已开启遗产宝箱数"],
        {stack = context["已开启遗产宝箱数"], sourceName = "影骨-盗贼遗产"}
    )
end
____exports["注册影骨莫特斯运行时"] = function()
    if _____5F71_9AA8_83AB_7279_65AF_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____5F71_9AA8_83AB_7279_65AF_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
    registerDeathListener(____on_5F71_9AA8_83AB_7279_65AF_6B7B_4EA1)
end
return ____exports
