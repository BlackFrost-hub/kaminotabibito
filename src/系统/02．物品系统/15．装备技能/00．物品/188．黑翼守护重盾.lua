local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____01_FF0E_524D_6447_9884_8B66_6267_884C_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.04．主动技能流程模板.01．前摇预警执行模板")
local _____5F00_59CB_4E3B_52A8_6280_80FD_524D_6447_9884_8B66_6267_884C_6A21_677F = ____01_FF0E_524D_6447_9884_8B66_6267_884C_6A21_677F["开始主动技能前摇预警执行模板"]
local ____index = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.index")
local _____521B_5EFA_53CB_519B_8303_56F4_627F_4F24_8F6C_79FB = ____index["创建友军范围承伤转移"]
local _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668 = ____index["创建句柄上下文托管器"]
local _____5355_4F4D_7ED1_5B9A_95EA_7535 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电")
local _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535 = _____5355_4F4D_7ED1_5B9A_95EA_7535["创建单位绑定闪电"]
local ____17_FF0E_95EA_7535_6548_679C_4EE3_7801 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.17．闪电效果代码")
local _____95EA_7535_6548_679C_4EE3_7801 = ____17_FF0E_95EA_7535_6548_679C_4EE3_7801["闪电效果代码"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_9ED1_7FFC_5B88_62A4_5951_7EA6Buff = ____01_FF0E_63A7_5236_4E0EBuff["施加黑翼守护契约Buff"]
local _____6E05_9664_9ED1_7FFC_5B88_62A4_5951_7EA6Buff = ____01_FF0E_63A7_5236_4E0EBuff["清除黑翼守护契约Buff"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_5B58_6D3B = ____07_FF0E_88C5_5907_8F85_52A9["单位存活"]
local _____53D6_5F53_524D_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取当前生命"]
local _____53D6_6700_5927_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取最大生命"]
local _____662F_654C_5BF9_5355_4F4D = ____07_FF0E_88C5_5907_8F85_52A9["是敌对单位"]
local _____5F00_59CB_901A_7528_62A4_76FE = ____07_FF0E_88C5_5907_8F85_52A9["开始通用护盾"]
local _____9020_6210_88C5_5907_4F24_5BB3 = ____07_FF0E_88C5_5907_8F85_52A9["造成装备伤害"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____56DBBoss_88C5_5907_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["四Boss装备特效"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_1.registerDamageModifier
local _____62A4_76FE_524D_62E6_622A_4FEE_6539_5668_4F18_5148_7EA7 = ____require_result_1["护盾前拦截修改器优先级"]
local jass = require("jass.common")
local DAMAGE_TYPE_UNIVERSAL = jass.DAMAGE_TYPE_UNIVERSAL
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
local removePeriodicCallback = ____require_result_2.removePeriodicCallback
local getServerTime = ____require_result_2.getServerTime
local _____5B88_62A4_8FDE_63A5_6301_7EED_79D2 = 8
local _____5B88_62A4_8FDE_63A5_8F6C_79FB_6BD4_4F8B = 0.35
local _____5B88_62A4_8FDE_63A5_65AD_5F00_8DDD_79BB = 900
local function _____9ED1_7FFC_5B88_62A4_4F24_5BB3_65E5_5FD7(...)
    debugLogForce("wp188-伤害转移", ...)
end
local _____8FDE_63A5 = _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668("黑翼守护重盾")
local _____5B88_62A4_76EE_6807 = _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668("黑翼守护重盾-守护目标")
local _____6D3B_8DC3_5B88_62A4_8FDE_63A5 = {}
local _____5B88_62A4_8FDE_63A5_9A71_52A8ID = 0
local function _____79FB_9664_6D3B_8DC3_5B88_62A4_8FDE_63A5(state)
    do
        local i = #_____6D3B_8DC3_5B88_62A4_8FDE_63A5 - 1
        while i >= 0 do
            if _____6D3B_8DC3_5B88_62A4_8FDE_63A5[i + 1] == state then
                __TS__ArraySplice(_____6D3B_8DC3_5B88_62A4_8FDE_63A5, i, 1)
            end
            i = i - 1
        end
    end
    if #_____6D3B_8DC3_5B88_62A4_8FDE_63A5 == 0 and _____5B88_62A4_8FDE_63A5_9A71_52A8ID ~= 0 then
        removePeriodicCallback(_____5B88_62A4_8FDE_63A5_9A71_52A8ID)
        _____5B88_62A4_8FDE_63A5_9A71_52A8ID = 0
    end
end
local function _____7ED3_675F_5B88_62A4_8FDE_63A5(_____53D7_62A4_8005, _____9884_671F_5B88_62A4_8005)
    local state = _____8FDE_63A5["读取"](_____53D7_62A4_8005)
    if state == nil or _____9884_671F_5B88_62A4_8005 ~= nil and state["守护者"] ~= _____9884_671F_5B88_62A4_8005 then
        return
    end
    _____8FDE_63A5["清空"](_____53D7_62A4_8005)
    if _____5B88_62A4_76EE_6807["读取"](state["守护者"]) == state["受护者"] then
        _____5B88_62A4_76EE_6807["清空"](state["守护者"])
    end
    _____6E05_9664_9ED1_7FFC_5B88_62A4_5951_7EA6Buff(state["守护者"], state["受护者"])
    _____79FB_9664_6D3B_8DC3_5B88_62A4_8FDE_63A5(state)
end
local function _____5B88_62A4_8FDE_63A5_8DDD_79BB_8D85_9650(state)
    local dx = GetUnitX(state["守护者"]) - GetUnitX(state["受护者"])
    local dy = GetUnitY(state["守护者"]) - GetUnitY(state["受护者"])
    return dx * dx + dy * dy > _____5B88_62A4_8FDE_63A5_65AD_5F00_8DDD_79BB * _____5B88_62A4_8FDE_63A5_65AD_5F00_8DDD_79BB
end
local function _____521B_5EFA_5B88_62A4_5951_7EA6_95EA_7535(state)
    _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535({
        ["效果代码"] = _____95EA_7535_6548_679C_4EE3_7801["白色细束"],
        ["起点单位"] = state["守护者"],
        ["终点单位"] = state["受护者"],
        ["持续时间"] = 1,
        ["起点高度偏移"] = 85,
        ["终点高度偏移"] = 85,
        ["任一死亡时销毁"] = true,
        ["颜色"] = {r = 1, g = 0.82, b = 0.42, a = 0.92}
    })
end
local function ____on_5B88_62A4_8FDE_63A5_9A71_52A8Tick()
    local now = getServerTime()
    do
        local i = #_____6D3B_8DC3_5B88_62A4_8FDE_63A5 - 1
        while i >= 0 do
            do
                local state = _____6D3B_8DC3_5B88_62A4_8FDE_63A5[i + 1]
                if _____8FDE_63A5["读取"](state["受护者"]) ~= state or now >= state["到期"] or not _____5355_4F4D_5B58_6D3B(state["守护者"]) or not _____5355_4F4D_5B58_6D3B(state["受护者"]) or _____53D6_5F53_524D_751F_547D(state["守护者"]) / _____53D6_6700_5927_751F_547D(state["守护者"]) <= 0.2 or _____5B88_62A4_8FDE_63A5_8DDD_79BB_8D85_9650(state) then
                    _____7ED3_675F_5B88_62A4_8FDE_63A5(state["受护者"], state["守护者"])
                    goto __continue15
                end
                if now >= state["下次闪电时间"] then
                    _____521B_5EFA_5B88_62A4_5951_7EA6_95EA_7535(state)
                    state["下次闪电时间"] = now + 1000
                end
            end
            ::__continue15::
            i = i - 1
        end
    end
end
local function _____542F_52A8_5B88_62A4_8FDE_63A5_9A71_52A8()
    if _____5B88_62A4_8FDE_63A5_9A71_52A8ID == 0 then
        _____5B88_62A4_8FDE_63A5_9A71_52A8ID = addPeriodicCallback(100, ____on_5B88_62A4_8FDE_63A5_9A71_52A8Tick)
    end
end
local function ____on_9ED1_7FFC_5B88_62A4_62A4_76FE_524D_4F24_5BB3(context)
    local state = _____8FDE_63A5["读取"](context.target)
    if state ~= nil then
        _____9ED1_7FFC_5B88_62A4_4F24_5BB3_65E5_5FD7(
            "护盾前",
            "受护者:",
            context.target,
            "伤害:",
            context.currentDamage,
            "守护者:",
            state["守护者"]
        )
    end
    return context.currentDamage
end
local function ____on_9ED1_7FFC_5B88_62A4_8F6C_79FB_540E_4F24_5BB3(context)
    local state = _____8FDE_63A5["读取"](context.target)
    if state ~= nil then
        _____9ED1_7FFC_5B88_62A4_4F24_5BB3_65E5_5FD7(
            "承伤阶段后",
            "受护者:",
            context.target,
            "剩余伤害:",
            context.currentDamage,
            "守护者:",
            state["守护者"]
        )
    end
    return context.currentDamage
end
local function _____662F_9ED1_7FFC_5B88_62A4_76F4_63A5_4F24_5BB3(e)
    local context = e["上下文"]
    local state = _____8FDE_63A5["读取"](e["受击者"])
    if state == nil then
        return false
    end
    if context.isTrueDamage == true or context.isDamageTransfer == true or context.isReflectedDamage == true or context.isEquipmentSkillDamage == true then
        _____9ED1_7FFC_5B88_62A4_4F24_5BB3_65E5_5FD7(
            "排除特殊伤害",
            "受护者:",
            e["受击者"],
            "伤害:",
            e["当前伤害"],
            "真实:",
            context.isTrueDamage,
            "转移:",
            context.isDamageTransfer,
            "反伤:",
            context.isReflectedDamage,
            "装备:",
            context.isEquipmentSkillDamage
        )
        return false
    end
    local tag = context.skillDamageTag
    if type(tag) == "string" and ((string.find(tag, "DOT", nil, true) or 0) - 1 >= 0 or (string.find(tag, "持续", nil, true) or 0) - 1 >= 0 or (string.find(tag, "反伤", nil, true) or 0) - 1 >= 0 or (string.find(tag, "环境", nil, true) or 0) - 1 >= 0) then
        _____9ED1_7FFC_5B88_62A4_4F24_5BB3_65E5_5FD7(
            "排除标签伤害",
            "受护者:",
            e["受击者"],
            "伤害:",
            e["当前伤害"],
            "标签:",
            tag
        )
        return false
    end
    _____9ED1_7FFC_5B88_62A4_4F24_5BB3_65E5_5FD7(
        "护盾后允许承伤",
        "受护者:",
        e["受击者"],
        "伤害:",
        e["当前伤害"],
        "攻击者:",
        e["攻击者"]
    )
    return true
end
local function _____83B7_53D6_9ED1_7FFC_5B88_62A4_627F_53D7_8005(e)
    local state = _____8FDE_63A5["读取"](e["受击者"])
    if state == nil or getServerTime() >= state["到期"] or not _____5355_4F4D_5B58_6D3B(state["守护者"]) or _____53D6_5F53_524D_751F_547D(state["守护者"]) / _____53D6_6700_5927_751F_547D(state["守护者"]) <= 0.2 then
        _____9ED1_7FFC_5B88_62A4_4F24_5BB3_65E5_5FD7(
            "守护者无效",
            "受护者:",
            e["受击者"],
            "状态:",
            state
        )
        if state ~= nil then
            _____7ED3_675F_5B88_62A4_8FDE_63A5(e["受击者"], state["守护者"])
        end
        return {}
    end
    _____9ED1_7FFC_5B88_62A4_4F24_5BB3_65E5_5FD7(
        "找到守护者",
        "受护者:",
        e["受击者"],
        "守护者:",
        state["守护者"]
    )
    return {state["守护者"]}
end
local function ____on_9ED1_7FFC_5B88_62A4_4F24_5BB3_8F6C_79FB(e)
    local _____5355_4F4D_5B58_6D3B_result_3
    if _____5355_4F4D_5B58_6D3B(e["攻击者"]) then
        _____5355_4F4D_5B58_6D3B_result_3 = e["攻击者"]
    else
        _____5355_4F4D_5B58_6D3B_result_3 = e["承受者"]
    end
    local _____4F24_5BB3_6765_6E90 = _____5355_4F4D_5B58_6D3B_result_3
    _____9ED1_7FFC_5B88_62A4_4F24_5BB3_65E5_5FD7(
        "执行转移",
        "来源:",
        _____4F24_5BB3_6765_6E90,
        "守护者:",
        e["承受者"],
        "转移伤害:",
        e["转移伤害"]
    )
    _____9020_6210_88C5_5907_4F24_5BB3(
        _____4F24_5BB3_6765_6E90,
        e["承受者"],
        e["转移伤害"],
        DAMAGE_TYPE_UNIVERSAL,
        false,
        nil,
        {
            ["装备技能类型"] = "装备主动",
            ["标签"] = "守护者伤害转移",
            ["伤害形态"] = "单体",
            ["参与技能伤害加成"] = false,
            ["伤害转移"] = true
        }
    )
end
registerDamageModifier(____on_9ED1_7FFC_5B88_62A4_62A4_76FE_524D_4F24_5BB3, _____62A4_76FE_524D_62E6_622A_4FEE_6539_5668_4F18_5148_7EA7)
registerDamageModifier(____on_9ED1_7FFC_5B88_62A4_8F6C_79FB_540E_4F24_5BB3, 34)
_____521B_5EFA_53CB_519B_8303_56F4_627F_4F24_8F6C_79FB({
    ["名称"] = "黑翼守护重盾-守护者之职责",
    ["转移比例"] = _____5B88_62A4_8FDE_63A5_8F6C_79FB_6BD4_4F8B,
    ["转移半径"] = _____5B88_62A4_8FDE_63A5_65AD_5F00_8DDD_79BB,
    ["过滤伤害"] = _____662F_9ED1_7FFC_5B88_62A4_76F4_63A5_4F24_5BB3,
    ["获取候选单位列表"] = _____83B7_53D6_9ED1_7FFC_5B88_62A4_627F_53D7_8005,
    ["on转移"] = ____on_9ED1_7FFC_5B88_62A4_4F24_5BB3_8F6C_79FB
})
____exports["处理黑翼守护重盾使用"] = function(ctx)
    local caster = ctx["施法单位"]
    local target = ctx["目标单位"]
    if not _____5355_4F4D_5B58_6D3B(target) or target == caster or _____662F_654C_5BF9_5355_4F4D(caster, target) then
        return
    end
    _____5F00_59CB_4E3B_52A8_6280_80FD_524D_6447_9884_8B66_6267_884C_6A21_677F({
        ["施法者"] = caster,
        ["目标"] = target,
        ["前摇"] = {
            ["持续时间"] = 1,
            ["强制硬直"] = true,
            ["允许自我打断"] = true,
            ["施法动作名"] = "spell",
            ["过程特效"] = _____56DBBoss_88C5_5907_7279_6548["黑翼拘束"],
            ["过程特效生命周期"] = 1
        },
        ["提示圈"] = false,
        ["执行"] = function()
            local _____539F_5B88_62A4_76EE_6807 = _____5B88_62A4_76EE_6807["读取"](caster)
            if _____539F_5B88_62A4_76EE_6807 ~= nil then
                _____7ED3_675F_5B88_62A4_8FDE_63A5(_____539F_5B88_62A4_76EE_6807, caster)
            end
            _____7ED3_675F_5B88_62A4_8FDE_63A5(target)
            local state = {
                ["守护者"] = caster,
                ["受护者"] = target,
                ["到期"] = getServerTime() + _____5B88_62A4_8FDE_63A5_6301_7EED_79D2 * 1000,
                ["下次闪电时间"] = getServerTime() + 1000
            }
            _____8FDE_63A5["写入"](target, state)
            _____5B88_62A4_76EE_6807["写入"](caster, target)
            _____6D3B_8DC3_5B88_62A4_8FDE_63A5[#_____6D3B_8DC3_5B88_62A4_8FDE_63A5 + 1] = state
            _____521B_5EFA_5B88_62A4_5951_7EA6_95EA_7535(state)
            _____542F_52A8_5B88_62A4_8FDE_63A5_9A71_52A8()
            _____65BD_52A0_9ED1_7FFC_5B88_62A4_5951_7EA6Buff(caster, target, _____5B88_62A4_8FDE_63A5_6301_7EED_79D2, _____5B88_62A4_8FDE_63A5_8F6C_79FB_6BD4_4F8B)
            _____5F00_59CB_901A_7528_62A4_76FE(
                caster,
                caster,
                _____53D6_6700_5927_751F_547D(caster) * 0.12,
                _____5B88_62A4_8FDE_63A5_6301_7EED_79D2,
                "守护者之职责"
            )
            _____5F00_59CB_901A_7528_62A4_76FE(
                caster,
                target,
                _____53D6_6700_5927_751F_547D(target) * 0.1,
                _____5B88_62A4_8FDE_63A5_6301_7EED_79D2,
                "守护者之职责"
            )
            _____64AD_653E_5355_4F4D_7279_6548(
                _____56DBBoss_88C5_5907_7279_6548["黑翼屏障"],
                caster,
                "origin",
                _____5B88_62A4_8FDE_63A5_6301_7EED_79D2,
                0.32
            )
            _____64AD_653E_5355_4F4D_7279_6548(
                _____56DBBoss_88C5_5907_7279_6548["黑翼拘束"],
                target,
                "origin",
                _____5B88_62A4_8FDE_63A5_6301_7EED_79D2,
                0.25
            )
        end
    })
end
return ____exports
