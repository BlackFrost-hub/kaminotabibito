local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local ____exports = {}
local ____02_FF0E_6301_6709_578B_5468_671F_6548_679C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果")
local _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C = ____02_FF0E_6301_6709_578B_5468_671F_6548_679C["注册持有型周期效果"]
local ____08_FF0E_6B21_6570_578B_4F24_5BB3_514D_75AB = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.08．次数型伤害免疫")
local _____521B_5EFA_6B21_6570_578B_4F24_5BB3_514D_75AB = ____08_FF0E_6B21_6570_578B_4F24_5BB3_514D_75AB["创建次数型伤害免疫"]
local ____24_FF0E_53E5_67C4_4E0A_4E0B_6587_6258_7BA1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.24．句柄上下文托管")
local _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668 = ____24_FF0E_53E5_67C4_4E0A_4E0B_6587_6258_7BA1["创建句柄上下文托管器"]
local ____07_FF0E_53EF_5145_80FD_5C42_6570Buff = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.01．层数状态.07．可充能层数Buff")
local _____540C_6B65_53EF_5145_80FD_5C42_6570Buff = ____07_FF0E_53EF_5145_80FD_5C42_6570Buff["同步可充能层数Buff"]
local _____6E05_9664_53EF_5145_80FD_5C42_6570Buff = ____07_FF0E_53EF_5145_80FD_5C42_6570Buff["清除可充能层数Buff"]
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____53D6_88C5_5907_7269_54C1ID = ____07_FF0E_88C5_5907_8F85_52A9["取装备物品ID"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____56DBBoss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["四Boss战利品装备名"]
local _____56DBBoss_88C5_5907_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["四Boss装备特效"]
local _____9632_62A4 = _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668("光辉翠绿宝石")
local _____7FE0_7EFF_9632_62A4_6700_4F4E_751F_547D_6BD4_4F8B = 0.08
local _____7FE0_7EFF_9632_62A4_6301_7EED_79D2 = 22
local _____7FE0_7EFF_9632_62A4_5237_65B0_6BEB_79D2 = 20000
local _____7FE0_7EFF_9632_62A4_6700_5927_5C42_6570 = 2
local _____5149_8F89_7FE0_7EFF_5468_671F_63A7_5236_5668 = nil
local function _____540C_6B65_7FE0_7EFF_9632_62A4Buff(state)
    do
        local i = #state["层列表"] - 1
        while i >= 0 do
            local ____self_0 = state["层列表"][i + 1]["控制器"]
            if not ____self_0["是否生效"](____self_0) then
                __TS__ArraySplice(state["层列表"], i, 1)
            end
            i = i - 1
        end
    end
    local _____663E_793A_5269_4F59_6BEB_79D2 = 0
    do
        local i = 0
        while i < #state["层列表"] do
            local ____self_1 = state["层列表"][i + 1]["控制器"]
            local _____5269_4F59_6BEB_79D2 = ____self_1["读取剩余毫秒"](____self_1)
            if _____5269_4F59_6BEB_79D2 > _____663E_793A_5269_4F59_6BEB_79D2 then
                _____663E_793A_5269_4F59_6BEB_79D2 = _____5269_4F59_6BEB_79D2
            end
            i = i + 1
        end
    end
    local _____4E0B_6B21_5145_80FD_5269_4F59_6BEB_79D2 = _____5149_8F89_7FE0_7EFF_5468_671F_63A7_5236_5668 ~= nil and _____5149_8F89_7FE0_7EFF_5468_671F_63A7_5236_5668["读取单位下次触发剩余毫秒"](state["单位"]) or _____7FE0_7EFF_9632_62A4_5237_65B0_6BEB_79D2
    _____540C_6B65_53EF_5145_80FD_5C42_6570Buff({
        ["单位"] = state["单位"],
        BuffID = _____5E38_89C4BuffID["光辉翠绿宝石_翠绿防护"],
        ["当前层数"] = #state["层列表"],
        ["有层剩余毫秒"] = _____663E_793A_5269_4F59_6BEB_79D2,
        ["下次充能剩余毫秒"] = _____4E0B_6B21_5145_80FD_5269_4F59_6BEB_79D2,
        ["Buff显示值"] = 800,
        ["Buff附加参数"] = {
            sourceUnit = state["单位"],
            effectSourceName = _____56DBBoss_6218_5229_54C1_88C5_5907_540D["光辉翠绿宝石"],
            effectSourceType = "装备",
            effectValue2 = _____7FE0_7EFF_9632_62A4_6700_4F4E_751F_547D_6BD4_4F8B,
            tickWhilePaused = true
        }
    })
end
local function _____79FB_9664_5355_5C42_7FE0_7EFF_9632_62A4(state, layer)
    if _____9632_62A4["读取"](state["单位"]) ~= state then
        return
    end
    do
        local i = #state["层列表"] - 1
        while i >= 0 do
            if state["层列表"][i + 1] == layer then
                __TS__ArraySplice(state["层列表"], i, 1)
            end
            i = i - 1
        end
    end
    _____540C_6B65_7FE0_7EFF_9632_62A4Buff(state)
end
local function _____8FC7_6EE4_7FE0_7EFF_9632_62A4_4F24_5BB3(c)
    if c.isDamageTransfer == true or c.isEquipmentSkillDamage == true then
        return false
    end
    local tag = c.skillDamageTag
    if type(tag) == "string" and ((string.find(tag, "DOT", nil, true) or 0) - 1 >= 0 or (string.find(tag, "持续", nil, true) or 0) - 1 >= 0 or (string.find(tag, "反伤", nil, true) or 0) - 1 >= 0 or (string.find(tag, "环境", nil, true) or 0) - 1 >= 0) then
        return false
    end
    return c.isNormalAttack == true or c.isSkillAttack == true or c.isSkillDamage == true or c.isWrappedSkillDamage == true
end
local function ____on_7FE0_7EFF_9632_62A4_62B5_6321(e)
    _____64AD_653E_5355_4F4D_7279_6548(
        _____56DBBoss_88C5_5907_7279_6548["翠绿护盾"],
        e["单位"],
        "origin",
        1.2,
        0.32
    )
end
local function _____65B0_589E_4E00_5C42_7FE0_7EFF_9632_62A4(unit)
    local state = _____9632_62A4["读取"](unit)
    if state == nil then
        state = {["单位"] = unit, ["层列表"] = {}}
        _____9632_62A4["写入"](unit, state)
    end
    do
        local i = #state["层列表"] - 1
        while i >= 0 do
            local ____self_2 = state["层列表"][i + 1]["控制器"]
            if not ____self_2["是否生效"](____self_2) then
                __TS__ArraySplice(state["层列表"], i, 1)
            end
            i = i - 1
        end
    end
    if #state["层列表"] >= _____7FE0_7EFF_9632_62A4_6700_5927_5C42_6570 then
        return
    end
    local currentState = state
    local layer = nil
    local controller = _____521B_5EFA_6B21_6570_578B_4F24_5BB3_514D_75AB({
        ["名称"] = "光辉翠绿体",
        ["单位"] = unit,
        ["免疫类型"] = "物理伤害",
        ["免疫次数"] = 1,
        ["持续秒"] = _____7FE0_7EFF_9632_62A4_6301_7EED_79D2,
        ["最低伤害"] = 800,
        ["最低伤害占最大生命比例"] = _____7FE0_7EFF_9632_62A4_6700_4F4E_751F_547D_6BD4_4F8B,
        ["过滤伤害"] = _____8FC7_6EE4_7FE0_7EFF_9632_62A4_4F24_5BB3,
        ["on抵挡"] = ____on_7FE0_7EFF_9632_62A4_62B5_6321,
        ["on结束"] = function()
            if layer ~= nil then
                _____79FB_9664_5355_5C42_7FE0_7EFF_9632_62A4(currentState, layer)
            end
        end
    })
    layer = {["控制器"] = controller}
    local ____currentState__5C42_5217_8868_3 = currentState["层列表"]
    ____currentState__5C42_5217_8868_3[#____currentState__5C42_5217_8868_3 + 1] = layer
    _____540C_6B65_7FE0_7EFF_9632_62A4Buff(currentState)
    _____64AD_653E_5355_4F4D_7279_6548(
        _____56DBBoss_88C5_5907_7279_6548["翠绿护盾"],
        unit,
        "origin",
        1,
        0.25
    )
end
local function _____6E05_9664_5168_90E8_7FE0_7EFF_9632_62A4(unit)
    local state = _____9632_62A4["取出"](unit)
    if state == nil then
        return
    end
    do
        local i = #state["层列表"] - 1
        while i >= 0 do
            local controller = state["层列表"][i + 1]["控制器"]
            if controller["是否生效"](controller) then
                controller["取消"](controller)
            end
            i = i - 1
        end
    end
    __TS__ArraySetLength(state["层列表"], 0)
    _____6E05_9664_53EF_5145_80FD_5C42_6570Buff(unit, _____5E38_89C4BuffID["光辉翠绿宝石_翠绿防护"])
end
local function ____on_83B7_53D6_5149_8F89_7FE0_7EFF_5B9D_77F3(unit)
    _____65B0_589E_4E00_5C42_7FE0_7EFF_9632_62A4(unit)
end
local function ____on_4E22_5F03_5149_8F89_7FE0_7EFF_5B9D_77F3(unit)
    _____6E05_9664_5168_90E8_7FE0_7EFF_9632_62A4(unit)
end
local function ____on_5149_8F89_7FE0_7EFF_5B9D_77F3_5468_671F(unit)
    _____65B0_589E_4E00_5C42_7FE0_7EFF_9632_62A4(unit)
end
_____5149_8F89_7FE0_7EFF_5468_671F_63A7_5236_5668 = _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C({
    ["物品类型ID"] = _____53D6_88C5_5907_7269_54C1ID(_____56DBBoss_6218_5229_54C1_88C5_5907_540D["光辉翠绿宝石"]),
    ["间隔毫秒"] = _____7FE0_7EFF_9632_62A4_5237_65B0_6BEB_79D2,
    ["按单位独立计时"] = true,
    ["获取回调"] = ____on_83B7_53D6_5149_8F89_7FE0_7EFF_5B9D_77F3,
    ["丢弃回调"] = ____on_4E22_5F03_5149_8F89_7FE0_7EFF_5B9D_77F3,
    ["周期回调"] = ____on_5149_8F89_7FE0_7EFF_5B9D_77F3_5468_671F
})
return ____exports
