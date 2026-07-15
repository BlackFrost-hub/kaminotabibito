--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D["创建可攻击机制单位"]
local ____04_FF0E_81F3_5C0A_5171_62A4 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.04．至尊共护")
local _____542F_52A8_96C5_513F_8D1D_5FB7_81F3_5C0A_5171_62A4 = ____04_FF0E_81F3_5C0A_5171_62A4["启动雅儿贝德至尊共护"]
local ____require_result_0 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_0["获取Boss技能随机敌对英雄"]
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
local _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = ____require_result_1["取当前有效玩家人数"]
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_2["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_2["移除单位暂停"]
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitType = jass.IsUnitType
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local _____9ED1_7FFC_62D8_675F_6682_505C_6765_6E90 = "雅儿贝德-黑翼拘束"
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____542F_52A8_9ED1_7FFC_62D8_675F_6838_5FC3(context, target, remainingSeconds)
    local state = context["雅儿贝德"]
    local albedo = state and state["单位"]
    if state == nil or not _____5355_4F4D_6709_6548(albedo) or not _____5355_4F4D_6709_6548(target) or context["挑战已结束"] then
        return
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local maxByAlbedo = GetUnitState(albedo, UNIT_STATE_LIFE) * cfg["守护者模式"]["黑翼拘束生命比例"]
    local maxByBoss = GetUnitState(context["安兹单位"], UNIT_STATE_MAX_LIFE) * cfg["守护者模式"]["黑翼拘束安兹最大生命上限比例"]
    local coreLife = maxByAlbedo < maxByBoss and maxByAlbedo or maxByBoss
    local wing = AddSpecialEffectTarget(cfg["表现资源"]["雅儿贝德黑翼拘束特效路径"], target, "origin")
    local paused = false
    if _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570() > 1 then
        paused = _____6DFB_52A0_5355_4F4D_6682_505C(target, _____9ED1_7FFC_62D8_675F_6682_505C_6765_6E90)
    end
    local cleaned = false
    local function cleanup()
        if cleaned then
            return
        end
        cleaned = true
        if paused then
            _____79FB_9664_5355_4F4D_6682_505C(target, _____9ED1_7FFC_62D8_675F_6682_505C_6765_6E90)
        end
        if wing ~= nil and wing ~= 0 then
            DestroyEffect(wing)
        end
    end
    local core = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = "雅儿贝德-黑翼拘束核心",
        ["主人单位"] = albedo,
        ["所属玩家"] = GetOwningPlayer(albedo),
        ["单位类型"] = cfg["守护者模式"]["黑翼拘束核心单位ID"],
        ["模型路径"] = cfg["表现资源"]["雅儿贝德黑翼拘束核心路径"],
        X = GetUnitX(target),
        Y = GetUnitY(target),
        ["最大生命"] = coreLife,
        ["生命值受小怪倍率"] = false,
        ["缩放"] = cfg["守护者模式"]["黑翼拘束核心缩放"],
        ["持续时间"] = remainingSeconds,
        ["on死亡"] = cleanup,
        ["on销毁"] = cleanup
    })
    if core == nil then
        cleanup()
    end
end
____exports["启动雅儿贝德天空坠落联动"] = function(context, castSeconds)
    local state = context["雅儿贝德"]
    if state == nil or not _____5355_4F4D_6709_6548(state["单位"]) or state["阶段状态"] == "失衡" then
        return
    end
    _____542F_52A8_96C5_513F_8D1D_5FB7_81F3_5C0A_5171_62A4(context, castSeconds)
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]
    local target = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(context["安兹单位"])
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local remaining = castSeconds - cfg["黑翼拘束启动延迟秒"]
    if remaining <= 0.5 then
        return
    end
    local delayedId = addDelayedCallback(
        cfg["黑翼拘束启动延迟秒"] * 1000,
        function()
            _____542F_52A8_9ED1_7FFC_62D8_675F_6838_5FC3(context, target, remaining)
        end
    )
    local ____self_6 = context["清理"]
    ____self_6["登记延迟回调"](____self_6, "雅儿贝德-天空坠落黑翼拘束", delayedId)
end
____exports["黑翼拘束技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "单体",
    ["类型"] = "控制机制",
    ["语义"] = "天空坠落期间拘束一名玩家，但拘束核心必须可处理，且不得把玩家推出已确认安全区。"
}
return ____exports
