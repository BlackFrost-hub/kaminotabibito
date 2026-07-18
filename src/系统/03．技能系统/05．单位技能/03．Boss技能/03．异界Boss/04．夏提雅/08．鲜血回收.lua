local ____lualib = require("lualib_bundle")
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local _____8DDD_79BBXY = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["距离XY"]
local _____4E24_70B9_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["两点角度"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.01．运行时上下文")
local _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["重置夏提雅猎血连击"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.02．数值与表现配置")
local _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["夏提雅数值与表现配置"]
local ____04_FF0E_9C9C_8840_5370_8BB0 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.04．鲜血印记")
local _____5438_6536_590F_63D0_96C5_9C9C_8840_5370_8BB0 = ____04_FF0E_9C9C_8840_5370_8BB0["吸收夏提雅鲜血印记"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____18_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.18．台词播放")
local _____64AD_653E_590F_63D0_96C5_53F0_8BCD = ____18_FF0E_53F0_8BCD_64AD_653E["播放夏提雅台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____require_result_0 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_0.doHeal
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_2["创建点特效"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local GetRandomReal = jass.GetRandomReal
local GetUnitState = jass.GetUnitState
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local _____9C9C_8840_56DE_6536_6280_80FDKey = "鲜血回收"
local function _____9650_5236_8FDE_7EBF_7F29_653E(value)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["鲜血印记"]
    if value < cfg["回收连线最小缩放"] then
        return cfg["回收连线最小缩放"]
    end
    if value > cfg["回收连线最大缩放"] then
        return cfg["回收连线最大缩放"]
    end
    return value
end
local function _____521B_5EFA_9C9C_8840_56DE_6536_8FDE_7EBF(context, mark)
    local boss = context["Boss单位"]
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["鲜血印记"]
    local bossX = GetUnitX(boss)
    local bossY = GetUnitY(boss)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["鲜血回收连线特效路径"],
        X = mark.X,
        Y = mark.Y,
        ["缩放"] = _____9650_5236_8FDE_7EBF_7F29_653E(_____8DDD_79BBXY(mark.X, mark.Y, bossX, bossY) / cfg["回收连线基准长度"]),
        ["Z轴角度"] = _____4E24_70B9_89D2_5EA6(mark.X, mark.Y, bossX, bossY),
        ["持续秒"] = cfg["回收连线持续秒"]
    })
end
local function _____7ED3_675F_9C9C_8840_56DE_6536(context)
    if context["当前大型技能"] == _____9C9C_8840_56DE_6536_6280_80FDKey then
        context["当前大型技能"] = nil
    end
end
local function _____7ED3_7B97_9C9C_8840_56DE_6536(context)
    local boss = context["Boss单位"]
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["鲜血回收"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
    )
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["鲜血印记"]
    local marks = __TS__ArraySlice(context["血印句柄列表"])
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
    if absorbed > 0 then
        local ratio = GetRandomReal(cfg["单枚回血比例最小"], cfg["单枚回血比例最大"]) * absorbed
        doHeal({
            HealSource = boss,
            HealTarget = boss,
            HealAmount = GetUnitState(boss, UNIT_STATE_MAX_LIFE) * ratio,
            ItemHeal = false,
            HealEffect = false
        })
        local ____self_3 = context["血之狂热控制器"]
        ____self_3["增加"](____self_3, boss, absorbed, "鲜血回收")
    end
    _____7ED3_675F_9C9C_8840_56DE_6536(context)
end
____exports["释放夏提雅鲜血回收"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["当前大型技能"] ~= nil or #context["血印句柄列表"] <= 0 then
        return false
    end
    if context["阶段"] ~= "P1鲜血女武神" and context["阶段"] ~= "P2英灵战乙女" then
        return false
    end
    _____64AD_653E_590F_63D0_96C5_53F0_8BCD(boss, "鲜血回收")
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["鲜血印记"]
    context["当前大型技能"] = _____9C9C_8840_56DE_6536_6280_80FDKey
    context["普通机制忙碌到Ms"] = getServerTime() + (cfg["回收前摇秒"] + 0.25) * 1000
    _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB(context)
    local marks = __TS__ArraySlice(context["血印句柄列表"])
    do
        local i = 0
        while i < #marks do
            if not marks[i + 1]["已清理"] then
                _____521B_5EFA_9C9C_8840_56DE_6536_8FDE_7EBF(context, marks[i + 1])
            end
            i = i + 1
        end
    end
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["回收动画编号"], ["持续秒"] = cfg["回收前摇秒"] + 0.2, ["恢复动画编号"] = 0})
    local delayedId = addDelayedCallback(
        cfg["回收前摇秒"] * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] then
                return
            end
            if context["当前大型技能"] ~= _____9C9C_8840_56DE_6536_6280_80FDKey or context["阶段"] == "P3真祖血宴" then
                _____7ED3_675F_9C9C_8840_56DE_6536(context)
                return
            end
            _____7ED3_7B97_9C9C_8840_56DE_6536(context)
        end
    )
    local ____self_4 = context["清理"]
    ____self_4["登记延迟回调"](____self_4, "夏提雅-鲜血回收", delayedId)
    return true
end
____exports["鲜血回收机制状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["类型"] = "P1P2周期恢复机制",
    ["语义"] = "蓄势后吸收所有剩余血印，按数量恢复生命并获得短时血之狂热。",
    ["实现要求"] = "无血印时跳过；回收期间暂停其他主动技能；回血不得因事件重复触发。"
}
return ____exports
