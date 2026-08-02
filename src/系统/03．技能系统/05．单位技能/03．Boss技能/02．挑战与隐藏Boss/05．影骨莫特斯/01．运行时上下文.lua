--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5F71_9AA8_83AB_7279_65AF_9636_6BB5_8FDB_5165P2, _____5E94_7528_5F71_9AA8_83AB_7279_65AFP3_5F3A_5316, _____5F71_9AA8_83AB_7279_65AF_9636_6BB5_8FDB_5165P3, GetUnitAbilityLevel, SGSS_SetState, _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4, _____6280_80FD__83B7_53D6_6280_80FD_5F53_524D_51B7_5374_65F6_95F4, _____6280_80FD__83B7_53D6_6280_80FD_6700_5927_51B7_5374_65F6_95F4, _____5E7D_5F71_7206_53D1_6280_80FDID, _____653B_51FB_529B_5C5E_6027ID, registerManualBuff, _____5F71_9AA8_83AB_7279_65AFBuffID, _____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_5DE5_5382
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local ____01_FF0E_9636_6BB5_4E0A_4E0B_6587 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.01．阶段上下文")
local _____521B_5EFA_9636_6BB5_4E0A_4E0B_6587 = ____01_FF0E_9636_6BB5_4E0A_4E0B_6587["创建阶段上下文"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.00．配置")
local _____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["影骨莫特斯单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.02．数值与表现配置")
local _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯数值与表现配置"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.08．台词播放")
local _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放影骨莫特斯台词"]
local ____11_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.11．公共工具")
local _____5355_4F4D_6709_6548 = ____11_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____11_FF0E_516C_5171_5DE5_5177.stringToFourCC
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
function _____5F71_9AA8_83AB_7279_65AF_9636_6BB5_8FDB_5165P2(_____9636_6BB5)
    local context = ____exports["获取影骨莫特斯上下文"](_____9636_6BB5["单位"])
    if context ~= nil then
        context["阶段"] = 2
    end
end
function _____5E94_7528_5F71_9AA8_83AB_7279_65AFP3_5F3A_5316(context)
    if context["P3强化已应用"] or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return
    end
    local cfg = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["P3强化"]
    local _____653B_51FB_529B_589E_91CF = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(context["Boss单位"]) * cfg["攻击力提高比例"]
    if _____653B_51FB_529B_589E_91CF ~= 0 then
        SGSS_SetState(context["Boss单位"], _____653B_51FB_529B_5C5E_6027ID, _____653B_51FB_529B_589E_91CF)
    end
    context["P3攻击力增量"] = _____653B_51FB_529B_589E_91CF
    if GetUnitAbilityLevel(context["Boss单位"], _____5E7D_5F71_7206_53D1_6280_80FDID) > 0 then
        local _____539F_59CB_6700_5927_51B7_5374 = _____6280_80FD__83B7_53D6_6280_80FD_6700_5927_51B7_5374_65F6_95F4(context["Boss单位"], _____5E7D_5F71_7206_53D1_6280_80FDID) or 0
        if _____539F_59CB_6700_5927_51B7_5374 <= 0 then
            _____539F_59CB_6700_5927_51B7_5374 = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["幽影爆发"]["冷却秒"]
        end
        context["P3幽影爆发原始最大冷却"] = _____539F_59CB_6700_5927_51B7_5374
        local _____5F53_524D_51B7_5374 = _____6280_80FD__83B7_53D6_6280_80FD_5F53_524D_51B7_5374_65F6_95F4(context["Boss单位"], _____5E7D_5F71_7206_53D1_6280_80FDID) or 0
        local ____P3_6700_5927_51B7_5374 = _____539F_59CB_6700_5927_51B7_5374 * cfg["幽影爆发冷却比例"]
        local ____P3_5F53_524D_51B7_5374 = _____5F53_524D_51B7_5374 * cfg["幽影爆发冷却比例"]
        _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(context["Boss单位"], _____5E7D_5F71_7206_53D1_6280_80FDID, ____P3_5F53_524D_51B7_5374, ____P3_6700_5927_51B7_5374)
    end
    registerManualBuff(
        context["Boss单位"],
        _____5F71_9AA8_83AB_7279_65AFBuffID["P3强化"],
        9999,
        cfg["攻击力提高比例"],
        {sourceName = "影骨-P3强化"}
    )
    context["P3强化已应用"] = true
end
function _____5F71_9AA8_83AB_7279_65AF_9636_6BB5_8FDB_5165P3(_____9636_6BB5)
    local context = ____exports["获取影骨莫特斯上下文"](_____9636_6BB5["单位"])
    if context == nil then
        return
    end
    context["阶段"] = 3
    _____5E94_7528_5F71_9AA8_83AB_7279_65AFP3_5F3A_5316(context)
end
____exports["获取影骨莫特斯上下文"] = function(boss)
    return _____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_5DE5_5382["获取"](boss)
end
local jass = require("jass.common")
GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.00．SGSS")
SGSS_SetState = ____require_result_0.SGSS_SetState
local ____require_result_1 = require("平台扩展API动作")
_____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4 = ____require_result_1["技能_设置技能冷却时间"]
local ____require_result_2 = require("平台扩展API取值")
_____6280_80FD__83B7_53D6_6280_80FD_5F53_524D_51B7_5374_65F6_95F4 = ____require_result_2["技能_获取技能当前冷却时间"]
_____6280_80FD__83B7_53D6_6280_80FD_6700_5927_51B7_5374_65F6_95F4 = ____require_result_2["技能_获取技能最大冷却时间"]
_____5E7D_5F71_7206_53D1_6280_80FDID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["幽影爆发"])
_____653B_51FB_529B_5C5E_6027ID = 1
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_3.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_3["移除单位指定Buff"]
local ____require_result_4 = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.04．影骨莫特斯")
_____5F71_9AA8_83AB_7279_65AFBuffID = ____require_result_4["影骨莫特斯BuffID"]
local function _____521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587(boss, _____6E05_7406)
    _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD(boss, "开场", 0)
    local context = {
        ["Boss单位"] = boss,
        ["阶段"] = 1,
        ["阶段上下文"] = nil,
        ["已初始化"] = false,
        ["清理"] = _____6E05_7406,
        ["已开启遗产宝箱数"] = 0,
        ["背刺准备"] = false,
        ["幽影爆发中"] = false,
        ["幽影召唤物"] = {},
        ["P3强化已应用"] = false,
        ["P3攻击力增量"] = 0,
        ["P3幽影爆发原始最大冷却"] = 0,
        ["遗产宝箱已生成"] = false,
        ["遗产宝箱点"] = nil
    }
    context["阶段上下文"] = _____521B_5EFA_9636_6BB5_4E0A_4E0B_6587({
        ["清理"] = _____6E05_7406,
        ["名称"] = "影骨莫特斯",
        ["单位"] = boss,
        ["初始阶段ID"] = "P1",
        ["阶段列表"] = {{ID = "P1"}, {ID = "P2", ["血量百分比"] = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段阈值"]["P2生命比例"], ["on进入"] = _____5F71_9AA8_83AB_7279_65AF_9636_6BB5_8FDB_5165P2}, {ID = "P3", ["血量百分比"] = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段阈值"]["P3生命比例"], ["on进入"] = _____5F71_9AA8_83AB_7279_65AF_9636_6BB5_8FDB_5165P3}}
    })
    return context
end
local function _____6E05_9664_5F71_9AA8_83AB_7279_65AFP3_5F3A_5316(context)
    if context["P3攻击力增量"] ~= 0 and _____5355_4F4D_6709_6548(context["Boss单位"]) then
        SGSS_SetState(context["Boss单位"], _____653B_51FB_529B_5C5E_6027ID, -context["P3攻击力增量"])
    end
    if context["P3幽影爆发原始最大冷却"] > 0 and _____5355_4F4D_6709_6548(context["Boss单位"]) and GetUnitAbilityLevel(context["Boss单位"], _____5E7D_5F71_7206_53D1_6280_80FDID) > 0 then
        local _____5F53_524D_51B7_5374 = _____6280_80FD__83B7_53D6_6280_80FD_5F53_524D_51B7_5374_65F6_95F4(context["Boss单位"], _____5E7D_5F71_7206_53D1_6280_80FDID) or 0
        _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(context["Boss单位"], _____5E7D_5F71_7206_53D1_6280_80FDID, _____5F53_524D_51B7_5374, context["P3幽影爆发原始最大冷却"])
    end
    if context["Boss单位"] ~= nil and context["Boss单位"] ~= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["Boss单位"], _____5F71_9AA8_83AB_7279_65AFBuffID["P3强化"])
    end
    context["P3强化已应用"] = false
    context["P3攻击力增量"] = 0
    context["P3幽影爆发原始最大冷却"] = 0
end
local function _____6E05_7406_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_673A_5236(context)
    _____6E05_9664_5F71_9AA8_83AB_7279_65AFP3_5F3A_5316(context)
    context["幽影召唤物"] = {}
    context["当前召唤组"] = nil
end
local function ____on_5F71_9AA8_83AB_7279_65AF_5355_4F4D_6B7B_4EA1(_context, dyingUnit, _killingUnit)
    _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD(dyingUnit, "死亡", 0)
end
_____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({
    ["名称"] = "影骨莫特斯",
    ["主动技能提示"] = _____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["主动技能提示"],
    ["创建上下文"] = _____521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587,
    ["on清理"] = _____6E05_7406_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_673A_5236,
    ["死亡时自动清理"] = true,
    ["on单位死亡"] = ____on_5F71_9AA8_83AB_7279_65AF_5355_4F4D_6B7B_4EA1
})
____exports["获取或创建影骨莫特斯上下文"] = function(boss)
    return _____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_5DE5_5382["获取或创建"](boss)
end
____exports["清理影骨莫特斯上下文"] = function(boss)
    _____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
end
____exports["设置影骨莫特斯测试阶段"] = function(context, _____9636_6BB5)
    if _____9636_6BB5 ~= 3 and context["P3强化已应用"] then
        _____6E05_9664_5F71_9AA8_83AB_7279_65AFP3_5F3A_5316(context)
    end
    context["阶段"] = _____9636_6BB5
    if _____9636_6BB5 == 3 then
        _____5E94_7528_5F71_9AA8_83AB_7279_65AFP3_5F3A_5316(context)
    end
end
____exports["获取全部影骨莫特斯上下文"] = function()
    return _____5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587_5DE5_5382["获取全部"]()
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
