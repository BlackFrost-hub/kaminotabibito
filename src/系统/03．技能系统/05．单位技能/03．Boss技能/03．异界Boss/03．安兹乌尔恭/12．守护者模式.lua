--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5355_4F4D_6709_6548, getServerTime, GetUnitState, SetUnitState, IsUnitType, UNIT_TYPE_DEAD, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE
local ____index = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.index")
local _____96C5_513F_8D1D_5FB7_6280_80FD_72B6_6001 = ____index["雅儿贝德技能状态"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．运行时上下文")
local _____83B7_53D6_5168_90E8_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部安兹运行时上下文"]
local _____7ED1_5B9A_96C5_513F_8D1D_5FB7_5230_5B89_5179_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["绑定雅儿贝德到安兹上下文"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.00．配置")
local _____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["安兹乌尔恭单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local ____20_FF0E_8054_5408_6218_6597_6210_5458_751F_547D_5468_671F = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.20．联合战斗成员生命周期")
local _____521B_5EFA_8054_5408_6218_6597_6210_5458_751F_547D_5468_671F = ____20_FF0E_8054_5408_6218_6597_6210_5458_751F_547D_5468_671F["创建联合战斗成员生命周期"]
local ____19_FF0E_53EF_62A2_5360_72EC_5360_72B6_6001 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.19．可抢占独占状态")
local _____521B_5EFA_53EF_62A2_5360_72EC_5360_72B6_6001_7BA1_7406_5668 = ____19_FF0E_53EF_62A2_5360_72EC_5360_72B6_6001["创建可抢占独占状态管理器"]
local ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.17．周期机制调度器")
local _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668 = ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668["创建周期机制调度器"]
local ____07_FF0E_6280_80FD_9A71_52A8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.07．技能驱动")
local _____63A8_8FDB_96C5_513F_8D1D_5FB7_6280_80FD_9A71_52A8 = ____07_FF0E_6280_80FD_9A71_52A8["推进雅儿贝德技能驱动"]
local ____01_FF0E_81F3_5C0A_62E6_622A = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.01．至尊拦截")
local _____6CE8_518C_96C5_513F_8D1D_5FB7_81F3_5C0A_62E6_622A = ____01_FF0E_81F3_5C0A_62E6_622A["注册雅儿贝德至尊拦截"]
local ____03_FF0E_5B88_62A4_8005_4E4B_804C_8D23 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.03．守护者之职责")
local _____6CE8_518C_96C5_513F_8D1D_5FB7_5B88_62A4_8005_4E4B_804C_8D23 = ____03_FF0E_5B88_62A4_8005_4E4B_804C_8D23["注册雅儿贝德守护者之职责"]
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
____exports["推进安兹守护者模式"] = function(context)
    local state = context["雅儿贝德"]
    local albedo = state and state["单位"]
    if state == nil or not _____5355_4F4D_6709_6548(albedo) or context["挑战已结束"] then
        return
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]
    local maxLife = GetUnitState(albedo, UNIT_STATE_MAX_LIFE)
    if maxLife <= 0 then
        return
    end
    local minimumLife = maxLife * cfg["雅儿贝德锁血比例"]
    local life = GetUnitState(albedo, UNIT_STATE_LIFE)
    if life < minimumLife then
        SetUnitState(albedo, UNIT_STATE_LIFE, minimumLife)
        life = minimumLife
    end
    local now = getServerTime()
    state["当前生命比例"] = life / maxLife
    if state["阶段状态"] == "失衡" and now >= state["失衡结束Ms"] then
        state["阶段状态"] = state["当前生命比例"] < cfg["雅儿贝德狂怒阈值"] and "狂怒护卫" or "正常护卫"
        local ____opt_14 = state["成员生命周期"]
        if ____opt_14 ~= nil then
            ____opt_14["设置状态"](____opt_14, "雅儿贝德", "活跃", "失衡结束")
        end
    end
    if state["阶段状态"] ~= "失衡" and state["当前生命比例"] <= state["下一个失衡生命比例"] and state["下一个失衡生命比例"] > cfg["雅儿贝德锁血比例"] then
        state["阶段状态"] = "失衡"
        state["失衡结束Ms"] = now + cfg["雅儿贝德失衡持续秒"] * 1000
        state["下一个失衡生命比例"] = state["下一个失衡生命比例"] - cfg["雅儿贝德失衡生命步进"]
        local ____opt_16 = state["成员生命周期"]
        if ____opt_16 ~= nil then
            ____opt_16["设置状态"](____opt_16, "雅儿贝德", "失衡", "累计损失20%最大生命")
        end
    elseif state["阶段状态"] ~= "失衡" then
        state["阶段状态"] = state["当前生命比例"] < cfg["雅儿贝德狂怒阈值"] and "狂怒护卫" or "正常护卫"
    end
    _____63A8_8FDB_96C5_513F_8D1D_5FB7_6280_80FD_9A71_52A8(context)
end
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.index")
local _____521B_5EFA_53EC_5524_7269 = ____require_result_0["创建召唤物"]
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_1["读取单位攻击力"]
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_2.registerDamageModifier
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
getServerTime = ____require_result_3.getServerTime
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
GetUnitState = jass.GetUnitState
SetUnitState = jass.SetUnitState
local GetOwningPlayer = jass.GetOwningPlayer
IsUnitType = jass.IsUnitType
local Cos = jass.Cos
local Sin = jass.Sin
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local DEG_TO_RAD = 0.017453292519943295
local _____96C5_513F_8D1D_5FB7_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = false
local _____96C5_513F_8D1D_5FB7_8FD0_884C_65F6_9A71_52A8_5DF2_6CE8_518C = false
local function _____4E24_5355_4F4D_8DDD_79BB_5E73_65B9(a, b)
    local dx = GetUnitX(a) - GetUnitX(b)
    local dy = GetUnitY(a) - GetUnitY(b)
    return dx * dx + dy * dy
end
local function _____67E5_627E_8054_5408_4E0A_4E0B_6587(unit)
    local contexts = _____83B7_53D6_5168_90E8_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #contexts do
            local context = contexts[i + 1]
            local ____temp_6 = context["安兹单位"] == unit
            if not ____temp_6 then
                local ____opt_4 = context["雅儿贝德"]
                ____temp_6 = (____opt_4 and ____opt_4["单位"]) == unit
            end
            if ____temp_6 then
                return context
            end
            i = i + 1
        end
    end
    return nil
end
local function _____96C5_513F_8D1D_5FB7_8054_5408_4F24_5BB3_4FEE_6B63(damage)
    local context = _____67E5_627E_8054_5408_4E0A_4E0B_6587(damage.target)
    if context == nil or context["模式"] ~= "守护者介入" or context["雅儿贝德"] == nil then
        return damage.currentDamage
    end
    local albedo = context["雅儿贝德"]["单位"]
    if not _____5355_4F4D_6709_6548(albedo) then
        return damage.currentDamage
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]
    if damage.target == albedo then
        local maxLife = GetUnitState(albedo, UNIT_STATE_MAX_LIFE)
        local minimumLife = maxLife * cfg["雅儿贝德锁血比例"]
        local currentLife = GetUnitState(albedo, UNIT_STATE_LIFE)
        local allowed = currentLife - minimumLife
        if allowed <= 0 then
            return 0
        end
        return damage.currentDamage > allowed and allowed or damage.currentDamage
    end
    if damage.target ~= context["安兹单位"] or context["当前大型技能"] ~= nil then
        return damage.currentDamage
    end
    if context["雅儿贝德"]["阶段状态"] == "失衡" or context["雅儿贝德"]["阶段状态"] == "已离场" then
        return damage.currentDamage
    end
    local radius = cfg["护卫减伤有效距离"]
    if _____4E24_5355_4F4D_8DDD_79BB_5E73_65B9(context["安兹单位"], albedo) > radius * radius then
        return damage.currentDamage
    end
    local reduction = context["雅儿贝德"]["当前生命比例"] < cfg["雅儿贝德狂怒阈值"] and cfg["低血护卫减伤"] or cfg["常驻护卫减伤"]
    return damage.currentDamage * (1 - reduction)
end
local function _____786E_4FDD_96C5_513F_8D1D_5FB7_4F24_5BB3_4FEE_6B63()
    if _____96C5_513F_8D1D_5FB7_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C then
        return
    end
    _____96C5_513F_8D1D_5FB7_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = true
    registerDamageModifier(_____96C5_513F_8D1D_5FB7_8054_5408_4F24_5BB3_4FEE_6B63, 55)
end
local function _____786E_4FDD_96C5_513F_8D1D_5FB7_8FD0_884C_65F6_9A71_52A8()
    if _____96C5_513F_8D1D_5FB7_8FD0_884C_65F6_9A71_52A8_5DF2_6CE8_518C then
        return
    end
    _____96C5_513F_8D1D_5FB7_8FD0_884C_65F6_9A71_52A8_5DF2_6CE8_518C = true
    _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668({["名称"] = "安兹-雅儿贝德守护模式", ["间隔毫秒"] = 250, ["取上下文列表"] = _____83B7_53D6_5168_90E8_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587, ["执行"] = ____exports["推进安兹守护者模式"]})
end
local function _____521B_5EFA_96C5_513F_8D1D_5FB7_5355_4F4D(context)
    local boss = context["安兹单位"]
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]
    local facing = GetUnitFacing(boss)
    local angle = (facing + 90) * DEG_TO_RAD
    return _____521B_5EFA_53EC_5524_7269({
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["单位类型"] = _____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E["护卫"]["正式单位ID"],
        ["单位名称"] = _____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E["护卫"]["单位名称"],
        ["模型路径"] = _____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E["护卫"]["模型路径"],
        X = GetUnitX(boss) + Cos(angle) * cfg["雅儿贝德出生距离"],
        Y = GetUnitY(boss) + Sin(angle) * cfg["雅儿贝德出生距离"],
        ["朝向"] = facing,
        ["生命值"] = GetUnitState(boss, UNIT_STATE_MAX_LIFE) * cfg["雅儿贝德生命比例"],
        ["生命值受小怪倍率"] = false,
        ["攻击力"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["雅儿贝德攻击比例"],
        ["攻击间隔"] = cfg["雅儿贝德攻击间隔"],
        ["攻击范围"] = cfg["雅儿贝德攻击范围"],
        ["索敌范围"] = cfg["雅儿贝德索敌范围"],
        ["护甲"] = cfg["雅儿贝德护甲"]
    })
end
____exports["启动安兹守护者模式"] = function(context)
    if not _____5355_4F4D_6709_6548(context["安兹单位"]) or context["挑战已结束"] then
        return false
    end
    local ____opt_7 = context["雅儿贝德"]
    if (____opt_7 and ____opt_7["已初始化"]) == true and context["雅儿贝德"]["成员生命周期"] ~= nil then
        return true
    end
    local ____opt_9 = context["雅儿贝德"]
    local albedo = ____opt_9 and ____opt_9["单位"]
    if not _____5355_4F4D_6709_6548(albedo) then
        albedo = _____521B_5EFA_96C5_513F_8D1D_5FB7_5355_4F4D(context)
    end
    if not _____5355_4F4D_6709_6548(albedo) or not _____7ED1_5B9A_96C5_513F_8D1D_5FB7_5230_5B89_5179_4E0A_4E0B_6587(context["安兹单位"], albedo) then
        return false
    end
    context["模式"] = "守护者介入"
    local state = context["雅儿贝德"]
    if state == nil then
        return false
    end
    state["成员生命周期"] = _____521B_5EFA_8054_5408_6218_6597_6210_5458_751F_547D_5468_671F({["名称"] = "安兹与雅儿贝德联合挑战", ["清理"] = context["清理"], ["成员列表"] = {{
        key = "安兹",
        ["单位"] = context["安兹单位"],
        ["角色"] = "主目标",
        ["初始状态"] = "活跃",
        ["参与最终结算"] = true,
        ["最终状态列表"] = {"离场"}
    }, {
        key = "雅儿贝德",
        ["单位"] = albedo,
        ["角色"] = "护卫",
        ["初始状态"] = "活跃",
        ["参与最终结算"] = false
    }}})
    state["独占状态"] = _____521B_5EFA_53EF_62A2_5360_72EC_5360_72B6_6001_7BA1_7406_5668({["名称"] = "安兹与雅儿贝德联合技能独占", ["清理"] = context["清理"]})
    local ____self_11 = context["清理"]
    ____self_11["登记单位"](____self_11, "雅儿贝德护卫单位", albedo)
    _____786E_4FDD_96C5_513F_8D1D_5FB7_4F24_5BB3_4FEE_6B63()
    _____786E_4FDD_96C5_513F_8D1D_5FB7_8FD0_884C_65F6_9A71_52A8()
    _____6CE8_518C_96C5_513F_8D1D_5FB7_81F3_5C0A_62E6_622A()
    _____6CE8_518C_96C5_513F_8D1D_5FB7_5B88_62A4_8005_4E4B_804C_8D23()
    return true
end
____exports["安兹守护者模式状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["护卫技能"] = _____96C5_513F_8D1D_5FB7_6280_80FD_72B6_6001,
    ["语义"] = "雅儿贝德作为长期护卫介入，玩家通过压低护卫生命换取安兹减伤下降与阶段大招更易破解。",
    ["实现要求"] = "基础成员生命周期、锁血、失衡与护卫减伤已接入；主动技能和大招联动由护卫子目录继续实现。"
}
return ____exports
