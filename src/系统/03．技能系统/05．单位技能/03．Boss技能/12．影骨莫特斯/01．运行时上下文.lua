local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local GetUnitState, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE
local ____15_FF0E_5355_4F4D_6280_80FD_58F3_63D0_793A = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.15．单位技能壳提示")
local _____8BBE_7F6E_5355_4F4D_6280_80FD_58F3_666E_901A_63D0_793A = ____15_FF0E_5355_4F4D_6280_80FD_58F3_63D0_793A["设置单位技能壳普通提示"]
local ____01_FF0E_673A_5236_6E05_7406_7BEE_5B50 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.06．机制清理.01．机制清理篮子")
local _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50 = ____01_FF0E_673A_5236_6E05_7406_7BEE_5B50["创建机制清理篮子"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.00．配置")
local _____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["影骨莫特斯单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.02．数值与表现配置")
local _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯数值与表现配置"]
local ____11_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.12．影骨莫特斯.11．公共工具")
local _____5355_4F4D_6709_6548 = ____11_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____53D6_5355_4F4DID = ____11_FF0E_516C_5171_5DE5_5177["取单位ID"]
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
local jass = require("jass.common")
GetUnitState = jass.GetUnitState
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["移除单位指定Buff"]
local ____require_result_1 = require("系统.05．Buff系统.03．Buff表.01．Boss.10．影骨莫特斯")
local _____5F71_9AA8_83AB_7279_65AFBuffID = ____require_result_1["影骨莫特斯BuffID"]
local _____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_8868 = {}
____exports["获取影骨莫特斯上下文"] = function(boss)
    local id = _____53D6_5355_4F4DID(boss)
    local ____temp_2
    if id == 0 then
        ____temp_2 = nil
    else
        ____temp_2 = _____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_8868[id]
    end
    return ____temp_2
end
____exports["获取或创建影骨莫特斯上下文"] = function(boss)
    local id = _____53D6_5355_4F4DID(boss)
    if id == 0 then
        return nil
    end
    local context = _____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_8868[id]
    if context ~= nil then
        return context
    end
    context = {
        ["Boss单位"] = boss,
        ["阶段"] = ____exports["取影骨莫特斯当前阶段"](boss),
        ["已初始化"] = false,
        ["清理"] = _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50("影骨莫特斯"),
        ["已开启遗产宝箱数"] = 0,
        ["背刺准备"] = false,
        ["幽影爆发中"] = false,
        ["幽影召唤物"] = {},
        ["上次暗影禁锢Ms"] = 0,
        ["下次暗影禁锢间隔Ms"] = 0,
        ["下一个召唤组ID"] = 0,
        ["遗产宝箱已生成"] = false
    }
    _____8BBE_7F6E_5355_4F4D_6280_80FD_58F3_666E_901A_63D0_793A(boss, _____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["主动技能提示"])
    _____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_8868[id] = context
    return context
end
____exports["清理影骨莫特斯上下文"] = function(boss)
    local id = _____53D6_5355_4F4DID(boss)
    if id == 0 then
        return
    end
    local context = _____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_8868[id]
    if context ~= nil then
        local ____self_3 = context["清理"]
        ____self_3["清理全部"](____self_3)
    end
    __TS__Delete(_____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_8868, id)
end
____exports["获取全部影骨莫特斯上下文"] = function()
    local result = {}
    for key in pairs(_____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_8868) do
        local context = _____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_8868[key]
        if context ~= nil then
            result[#result + 1] = context
        end
    end
    return result
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
end
return ____exports
