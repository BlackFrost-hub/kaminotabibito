--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local getServerTime, doHeal, GetUnitStateJapi, GetUnitState, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local _____4E24_5355_4F4D_8DDD_79BB_5E73_65B9 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位间距离平方"]
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
local ____09_FF0E_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.09．伤害生命下限保护")
local _____521B_5EFA_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4 = ____09_FF0E_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4["创建伤害生命下限保护"]
local ____11_FF0E_6761_4EF6_4F24_5BB3_4FEE_6B63 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.11．条件伤害修正")
local _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63 = ____11_FF0E_6761_4EF6_4F24_5BB3_4FEE_6B63["创建条件伤害修正"]
local ____07_FF0E_6280_80FD_9A71_52A8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.07．技能驱动")
local _____63A8_8FDB_96C5_513F_8D1D_5FB7_6280_80FD_9A71_52A8 = ____07_FF0E_6280_80FD_9A71_52A8["推进雅儿贝德技能驱动"]
local ____01_FF0E_81F3_5C0A_62E6_622A = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.01．至尊拦截")
local _____6CE8_518C_96C5_513F_8D1D_5FB7_81F3_5C0A_62E6_622A = ____01_FF0E_81F3_5C0A_62E6_622A["注册雅儿贝德至尊拦截"]
local ____03_FF0E_5B88_62A4_8005_4E4B_804C_8D23 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.03．守护者之职责")
local _____6CE8_518C_96C5_513F_8D1D_5FB7_5B88_62A4_8005_4E4B_804C_8D23 = ____03_FF0E_5B88_62A4_8005_4E4B_804C_8D23["注册雅儿贝德守护者之职责"]
____exports["推进安兹守护者模式"] = function(context)
    local state = context["雅儿贝德"]
    local albedo = state and state["单位"]
    if state == nil or not _____5355_4F4D_6709_6548(albedo) or context["挑战已结束"] then
        return
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]
    local maxLife = GetUnitStateJapi(albedo, UNIT_STATE_MAX_LIFE)
    if maxLife <= 0 then
        return
    end
    local minimumLife = maxLife * cfg["雅儿贝德锁血比例"]
    local life = GetUnitState(albedo, UNIT_STATE_LIFE)
    if life < minimumLife then
        doHeal({
            HealSource = albedo,
            HealTarget = albedo,
            HealAmount = minimumLife - life,
            ItemHeal = false,
            HealEffect = false
        })
        life = GetUnitState(albedo, UNIT_STATE_LIFE)
    end
    local now = getServerTime()
    state["当前生命比例"] = life / maxLife
    if state["阶段状态"] == "失衡" and now >= state["失衡结束Ms"] then
        state["阶段状态"] = state["当前生命比例"] < cfg["雅儿贝德狂怒阈值"] and "狂怒护卫" or "正常护卫"
        local ____opt_12 = state["成员生命周期"]
        if ____opt_12 ~= nil then
            ____opt_12["设置状态"](____opt_12, "雅儿贝德", "活跃", "失衡结束")
        end
    end
    if state["阶段状态"] ~= "失衡" and state["当前生命比例"] <= state["下一个失衡生命比例"] and state["下一个失衡生命比例"] > cfg["雅儿贝德锁血比例"] then
        state["阶段状态"] = "失衡"
        state["失衡结束Ms"] = now + cfg["雅儿贝德失衡持续秒"] * 1000
        state["下一个失衡生命比例"] = state["下一个失衡生命比例"] - cfg["雅儿贝德失衡生命步进"]
        local ____opt_14 = state["成员生命周期"]
        if ____opt_14 ~= nil then
            ____opt_14["设置状态"](____opt_14, "雅儿贝德", "失衡", "累计损失20%最大生命")
        end
    elseif state["阶段状态"] ~= "失衡" then
        state["阶段状态"] = state["当前生命比例"] < cfg["雅儿贝德狂怒阈值"] and "狂怒护卫" or "正常护卫"
    end
    _____63A8_8FDB_96C5_513F_8D1D_5FB7_6280_80FD_9A71_52A8(context)
end
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.index")
local _____521B_5EFA_53EC_5524_7269 = ____require_result_0["创建召唤物"]
local ____require_result_1 = require("系统.01．单位系统.10．护卫系统.index")
local _____521B_5EFA_81EA_5B9A_4E49_62A4_536B_5355_4F4D = ____require_result_1["创建自定义护卫单位"]
local _____5904_7406Boss_7ED3_675F_5168_90E8_62A4_536B = ____require_result_1["处理Boss结束全部护卫"]
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_2["读取单位攻击力"]
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
getServerTime = ____require_result_3.getServerTime
local ____require_result_4 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
doHeal = ____require_result_4.doHeal
local jass = require("jass.common")
local japi = require("jass.japi")
GetUnitStateJapi = japi.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
GetUnitState = jass.GetUnitState
local GetOwningPlayer = jass.GetOwningPlayer
local Cos = jass.Cos
local Sin = jass.Sin
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local DEG_TO_RAD = 0.017453292519943295
local _____96C5_513F_8D1D_5FB7_8FD0_884C_65F6_9A71_52A8_5DF2_6CE8_518C = false
local function _____521B_5EFA_96C5_513F_8D1D_5FB7_4F24_5BB3_673A_5236(context, albedo)
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]
    _____521B_5EFA_4F24_5BB3_751F_547D_4E0B_9650_4FDD_62A4({
        ["名称"] = "安兹-雅儿贝德锁血",
        ["单位"] = albedo,
        ["最大生命比例下限"] = cfg["雅儿贝德锁血比例"],
        ["修正优先级"] = 55,
        ["清理"] = context["清理"]
    })
    local boss = context["安兹单位"]
    _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63({
        ["名称"] = "安兹-雅儿贝德护卫减伤",
        ["优先级"] = 55,
        ["清理"] = context["清理"],
        ["条件"] = function(damage)
            if context["挑战已结束"] or context["模式"] ~= "守护者介入" then
                return false
            end
            if damage.target ~= boss or not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(albedo) then
                return false
            end
            local state = context["雅儿贝德"]
            if state == nil or state["阶段状态"] == "失衡" or state["阶段状态"] == "已离场" then
                return false
            end
            if context["当前大型技能"] ~= nil then
                return false
            end
            local radius = cfg["护卫减伤有效距离"]
            return _____4E24_5355_4F4D_8DDD_79BB_5E73_65B9(boss, albedo) <= radius * radius
        end,
        ["修正"] = function(damage)
            local state = context["雅儿贝德"]
            if state == nil then
                return damage.currentDamage
            end
            local reduction = state["当前生命比例"] < cfg["雅儿贝德狂怒阈值"] and cfg["低血护卫减伤"] or cfg["常驻护卫减伤"]
            return damage.currentDamage * (1 - reduction)
        end
    })
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
    return _____521B_5EFA_81EA_5B9A_4E49_62A4_536B_5355_4F4D(
        {
            ["主Boss单位"] = boss,
            ["护卫类型"] = "安兹乌尔恭:雅儿贝德",
            ["护卫血条优先级"] = 300,
            ["标记为召唤单位"] = true,
            ["Boss结束处理"] = "移除"
        },
        function()
            return _____521B_5EFA_53EC_5524_7269({
                ["主人单位"] = boss,
                ["所属玩家"] = GetOwningPlayer(boss),
                ["单位类型"] = _____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E["护卫"]["正式单位ID"],
                ["单位名称"] = _____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E["护卫"]["单位名称"],
                ["模型路径"] = _____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E["护卫"]["模型路径"],
                X = GetUnitX(boss) + Cos(angle) * cfg["雅儿贝德出生距离"],
                Y = GetUnitY(boss) + Sin(angle) * cfg["雅儿贝德出生距离"],
                ["朝向"] = facing,
                ["生命值"] = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * cfg["雅儿贝德生命比例"],
                ["生命值受小怪倍率"] = false,
                ["攻击力"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["雅儿贝德攻击比例"],
                ["攻击间隔"] = cfg["雅儿贝德攻击间隔"],
                ["攻击范围"] = cfg["雅儿贝德攻击范围"],
                ["索敌范围"] = cfg["雅儿贝德索敌范围"],
                ["护甲"] = cfg["雅儿贝德护甲"]
            })
        end
    )
end
____exports["启动安兹守护者模式"] = function(context)
    if not _____5355_4F4D_6709_6548(context["安兹单位"]) or context["挑战已结束"] then
        return false
    end
    local ____opt_5 = context["雅儿贝德"]
    if (____opt_5 and ____opt_5["已初始化"]) == true and context["雅儿贝德"]["成员生命周期"] ~= nil then
        return true
    end
    local ____opt_7 = context["雅儿贝德"]
    local albedo = ____opt_7 and ____opt_7["单位"]
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
    local boss = context["安兹单位"]
    local ____self_9 = context["清理"]
    ____self_9["登记清理"](
        ____self_9,
        "雅儿贝德护卫单位",
        function()
            _____5904_7406Boss_7ED3_675F_5168_90E8_62A4_536B(boss)
        end
    )
    _____521B_5EFA_96C5_513F_8D1D_5FB7_4F24_5BB3_673A_5236(context, albedo)
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
