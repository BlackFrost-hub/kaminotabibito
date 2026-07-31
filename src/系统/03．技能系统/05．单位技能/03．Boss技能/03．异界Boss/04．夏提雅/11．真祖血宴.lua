--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.01．运行时上下文")
local _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["重置夏提雅猎血连击"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.02．数值与表现配置")
local _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["夏提雅数值与表现配置"]
local ____04_FF0E_9C9C_8840_5370_8BB0 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.04．鲜血印记")
local _____5438_6536_590F_63D0_96C5_9C9C_8840_5370_8BB0 = ____04_FF0E_9C9C_8840_5370_8BB0["吸收夏提雅鲜血印记"]
local ____09_FF0E_82F1_7075_6218_4E59_5973 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.09．英灵战乙女")
local _____6E05_7406_82F1_7075_6218_4E59_5973_6295_5F71 = ____09_FF0E_82F1_7075_6218_4E59_5973["清理英灵战乙女投影"]
local ____10_FF0E_955C_50CF_5939_51FB = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.10．镜像夹击")
local _____6E05_7406_955C_50CF_5939_51FB_6295_5F71 = ____10_FF0E_955C_50CF_5939_51FB["清理镜像夹击投影"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____01_FF0E_63A7_5236_4E0EBuff["开始硬直"]
local ____02_FF0E_590F_63D0_96C5 = require("系统.05．Buff系统.03．Buff表.01．Boss.03．异界Boss.02．夏提雅")
local _____590F_63D0_96C5BuffID = ____02_FF0E_590F_63D0_96C5["夏提雅BuffID"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____19_FF0E_541F_5531_6761 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.19．吟唱条")
local _____663E_793A_590F_63D0_96C5_5E38_89C4_541F_5531_6761 = ____19_FF0E_541F_5531_6761["显示夏提雅常规吟唱条"]
local ____18_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.18．台词播放")
local _____64AD_653E_590F_63D0_96C5_53F0_8BCD = ____18_FF0E_53F0_8BCD_64AD_653E["播放夏提雅台词"]
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_1.SGSS_SetState
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local getServerTime = ____require_result_2.getServerTime
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_3.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local AddSpecialEffect = jass.AddSpecialEffect
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____653B_901F_5C5E_6027ID = 10
local _____771F_7956_8840_5BB4_6280_80FDKey = "真祖血宴"
local function _____9650_5236_8840_5BB4_5C42_6570(value)
    local max = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["血宴层数上限"]
    if value <= 0 then
        return 0
    end
    return value >= max and max or value
end
local function _____590D_5236_8840_5BB4_5370_8BB0_5217_8868(context)
    local marks = {}
    do
        local i = 0
        while i < #context["血印句柄列表"] do
            marks[#marks + 1] = context["血印句柄列表"][i + 1]
            i = i + 1
        end
    end
    return marks
end
____exports["释放夏提雅真祖血宴"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["阶段"] ~= "P3真祖血宴" or context["P3转阶段已处理"] or context["当前大型技能"] ~= nil then
        return false
    end
    _____64AD_653E_590F_63D0_96C5_53F0_8BCD(boss, "真祖血宴")
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["真祖血宴"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
    )
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P3
    context["P3转阶段已处理"] = true
    context["当前大型技能"] = _____771F_7956_8840_5BB4_6280_80FDKey
    context["普通机制忙碌到Ms"] = getServerTime() + (cfg["转阶段演出秒"] + 0.25) * 1000
    _____5F00_59CB_786C_76F4(boss, cfg["转阶段演出秒"])
    _____663E_793A_590F_63D0_96C5_5E38_89C4_541F_5531_6761(cfg["转阶段演出秒"], cfg["吟唱条颜色ID"], cfg["吟唱条标题文本"], cfg["吟唱条提示文本"])
    _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB(context)
    local ____self_4 = context["血之狂热控制器"]
    ____self_4["清空"](____self_4, boss, "P3转阶段")
    _____6E05_7406_82F1_7075_6218_4E59_5973_6295_5F71(context)
    _____6E05_7406_955C_50CF_5939_51FB_6295_5F71(context)
    local marks = _____590D_5236_8840_5BB4_5370_8BB0_5217_8868(context)
    local absorbed = 0
    do
        local i = 0
        while i < #marks do
            if _____5438_6536_590F_63D0_96C5_9C9C_8840_5370_8BB0(context, marks[i + 1]) then
                absorbed = absorbed + 1
            end
            i = i + 1
        end
    end
    context["血宴层数"] = _____9650_5236_8840_5BB4_5C42_6570(absorbed)
    context["血宴攻速增量"] = context["血宴层数"] * cfg["血宴每层攻击速度提高"]
    if context["血宴攻速增量"] ~= 0 then
        SGSS_SetState(boss, _____653B_901F_5C5E_6027ID, context["血宴攻速增量"])
    end
    if context["血宴层数"] > 0 then
        registerManualBuff(
            boss,
            _____590F_63D0_96C5BuffID["真祖血宴"],
            3600,
            cfg["血宴每层攻击速度提高"] * 100,
            {stack = context["血宴层数"], sourceName = "夏提雅-P3真祖血宴"}
        )
    end
    local x = GetUnitX(boss)
    local y = GetUnitY(boss)
    local field = AddSpecialEffect(_____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["真祖血宴领域特效路径"], x, y)
    local impact = AddSpecialEffect(_____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["真祖血宴冲击特效路径"], x, y)
    if field ~= nil and field ~= 0 then
        YDWETimerDestroyEffectSafe(cfg["转阶段演出秒"] + 0.4, field)
    end
    if impact ~= nil and impact ~= 0 then
        YDWETimerDestroyEffectSafe(cfg["转阶段演出秒"] + 0.2, impact)
    end
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["转阶段动画编号"], ["持续秒"] = cfg["转阶段演出秒"], ["恢复动画编号"] = 0})
    local delayedId = addDelayedCallback(
        cfg["转阶段演出秒"] * 1000,
        function()
            if context["当前大型技能"] == _____771F_7956_8840_5BB4_6280_80FDKey then
                context["当前大型技能"] = nil
            end
        end
    )
    local ____self_5 = context["清理"]
    ____self_5["登记延迟回调"](____self_5, "夏提雅-真祖血宴转阶段", delayedId)
    return true
end
____exports["真祖血宴机制状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["类型"] = "P3转阶段机制",
    ["语义"] = "英灵回归并结算剩余血印为血宴层数；P3不再生成血印，猎血连击缩短为两段。"
}
return ____exports
