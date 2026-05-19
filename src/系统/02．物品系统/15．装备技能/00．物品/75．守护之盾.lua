local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.07．获得物品.00．公共.00．获得物品配置表")
local _____5B88_62A4_4E4B_76FE_914D_7F6E = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["守护之盾配置"]
local _____83B7_5F97_7269_54C1_88C5_5907ID = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["获得物品装备ID"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果")
local _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C = ____require_result_0["注册持有型周期效果"]
local ____require_result_1 = require("系统.02．物品系统.15．装备技能.06．获取丢弃.index")
local _____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF = ____require_result_1["获取单位当前持有指定物品数量"]
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____53D8_66F4_8D44_6E90_503C = ____require_result_2["变更资源值"]
local ____require_result_3 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_3.registerDamageModifier
local ____require_result_4 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____4E34_65F6_8C03_6574_653B_51FB = ____require_result_4["临时调整攻击"]
local _____5355_4F4D_5B58_6D3B = ____require_result_4["单位存活"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ConvertUnitState = jass.ConvertUnitState
local IsUnitAlly = jass.IsUnitAlly
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitStateJapi = japi.GetUnitState
local _____5B88_62A4_4E4B_76FE_653B_51FB_72B6_6001_8868 = {}
local _____5B88_62A4_4E4B_76FE_6301_6709_8005_5217_8868 = {}
local _____5B88_62A4_4E4B_76FE_6301_6709_8005_8868 = {}
local _____5DF2_6CE8_518C_5B88_62A4_4E4B_76FE_4F24_5BB3_4FEE_6B63 = false
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____53D6_5355_4F4D_62A4_7532(unit)
    return GetUnitStateJapi(
        unit,
        ConvertUnitState(32)
    )
end
local function _____52A0_5165_5B88_62A4_4E4B_76FE_6301_6709_8005(unit)
    local id = _____53D6_5355_4F4DID(unit)
    if id == 0 or _____5B88_62A4_4E4B_76FE_6301_6709_8005_8868[id] ~= nil then
        return
    end
    _____5B88_62A4_4E4B_76FE_6301_6709_8005_8868[id] = unit
    _____5B88_62A4_4E4B_76FE_6301_6709_8005_5217_8868[#_____5B88_62A4_4E4B_76FE_6301_6709_8005_5217_8868 + 1] = unit
end
local function _____79FB_9664_5B88_62A4_4E4B_76FE_6301_6709_8005(unit)
    local id = _____53D6_5355_4F4DID(unit)
    if id == 0 then
        return
    end
    __TS__Delete(_____5B88_62A4_4E4B_76FE_6301_6709_8005_8868, id)
    do
        local i = #_____5B88_62A4_4E4B_76FE_6301_6709_8005_5217_8868 - 1
        while i >= 0 do
            if _____53D6_5355_4F4DID(_____5B88_62A4_4E4B_76FE_6301_6709_8005_5217_8868[i + 1]) == id then
                __TS__ArraySplice(_____5B88_62A4_4E4B_76FE_6301_6709_8005_5217_8868, i, 1)
            end
            i = i - 1
        end
    end
end
local function _____53D6_6216_521B_5EFA_5B88_62A4_4E4B_76FE_653B_51FB_72B6_6001(unit)
    local id = _____53D6_5355_4F4DID(unit)
    local state = _____5B88_62A4_4E4B_76FE_653B_51FB_72B6_6001_8868[id]
    if state ~= nil then
        return state
    end
    local nextState = {["当前加成"] = 0}
    _____5B88_62A4_4E4B_76FE_653B_51FB_72B6_6001_8868[id] = nextState
    return nextState
end
local function _____6E05_7406_5B88_62A4_4E4B_76FE_653B_51FB_52A0_6210(unit)
    local id = _____53D6_5355_4F4DID(unit)
    if id == 0 then
        return
    end
    local state = _____5B88_62A4_4E4B_76FE_653B_51FB_72B6_6001_8868[id]
    if state ~= nil and state["当前加成"] ~= 0 then
        _____4E34_65F6_8C03_6574_653B_51FB(unit, -state["当前加成"])
    end
    __TS__Delete(_____5B88_62A4_4E4B_76FE_653B_51FB_72B6_6001_8868, id)
end
local function ____on_5B88_62A4_4E4B_76FE_653B_51FB_540C_6B65(unit, currentCount)
    if not _____5355_4F4D_5B58_6D3B(unit) or currentCount <= 0 then
        _____6E05_7406_5B88_62A4_4E4B_76FE_653B_51FB_52A0_6210(unit)
        return
    end
    local state = _____53D6_6216_521B_5EFA_5B88_62A4_4E4B_76FE_653B_51FB_72B6_6001(unit)
    local nextBonus = _____53D6_5355_4F4D_62A4_7532(unit) * _____5B88_62A4_4E4B_76FE_914D_7F6E["防转攻比例"] * currentCount
    local delta = nextBonus - state["当前加成"]
    if delta ~= 0 then
        _____4E34_65F6_8C03_6574_653B_51FB(unit, delta)
        state["当前加成"] = nextBonus
    end
end
local function ____on_5B88_62A4_4E4B_76FE_4E22_5F03(unit)
    _____6E05_7406_5B88_62A4_4E4B_76FE_653B_51FB_52A0_6210(unit)
    _____79FB_9664_5B88_62A4_4E4B_76FE_6301_6709_8005(unit)
end
local function ____on_5B88_62A4_4E4B_76FE_83B7_5F97(unit, currentCount)
    if currentCount > 0 then
        _____52A0_5165_5B88_62A4_4E4B_76FE_6301_6709_8005(unit)
    end
end
local function ____on_5B88_62A4_4E4B_76FE_5931_53BB(unit, currentCount)
    if currentCount <= 0 then
        ____on_5B88_62A4_4E4B_76FE_4E22_5F03(unit)
    end
end
local function _____53D6_8F6C_79FB_627F_53D7_8005(target)
    local tx = GetUnitX(target)
    local ty = GetUnitY(target)
    local owner = GetOwningPlayer(target)
    do
        local i = 0
        while i < #_____5B88_62A4_4E4B_76FE_6301_6709_8005_5217_8868 do
            do
                local holder = _____5B88_62A4_4E4B_76FE_6301_6709_8005_5217_8868[i + 1]
                if holder == nil or holder == 0 or holder == target then
                    goto __continue27
                end
                if not _____5355_4F4D_5B58_6D3B(holder) then
                    goto __continue27
                end
                if not IsUnitAlly(holder, owner) then
                    goto __continue27
                end
                if _____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF(holder, _____83B7_5F97_7269_54C1_88C5_5907ID["守护之盾"]) <= 0 then
                    goto __continue27
                end
                local dx = GetUnitX(holder) - tx
                local dy = GetUnitY(holder) - ty
                if dx * dx + dy * dy <= _____5B88_62A4_4E4B_76FE_914D_7F6E["转移半径"] * _____5B88_62A4_4E4B_76FE_914D_7F6E["转移半径"] then
                    return holder
                end
            end
            ::__continue27::
            i = i + 1
        end
    end
    return nil
end
local function ____on_5B88_62A4_4E4B_76FE_4F24_5BB3_4FEE_6B63(context)
    if not (context.currentDamage >= 1) then
        return context.currentDamage
    end
    if context.isTrueDamage == true then
        return context.currentDamage
    end
    local target = context.target
    if target == nil or target == 0 or not _____5355_4F4D_5B58_6D3B(target) then
        return context.currentDamage
    end
    local holder = _____53D6_8F6C_79FB_627F_53D7_8005(target)
    if holder == nil then
        return context.currentDamage
    end
    local transfer = context.currentDamage * _____5B88_62A4_4E4B_76FE_914D_7F6E["转移比例"]
    if not (transfer > 0) then
        return context.currentDamage
    end
    _____53D8_66F4_8D44_6E90_503C(
        holder,
        -transfer,
        "life",
        false,
        true,
        nil,
        0
    )
    return context.currentDamage - transfer
end
local function _____521D_59CB_5316_5B88_62A4_4E4B_76FE()
    if _____83B7_5F97_7269_54C1_88C5_5907ID["守护之盾"] == 0 then
        return
    end
    _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C({
        ["物品类型ID"] = _____83B7_5F97_7269_54C1_88C5_5907ID["守护之盾"],
        ["间隔毫秒"] = _____5B88_62A4_4E4B_76FE_914D_7F6E["攻击同步间隔毫秒"],
        ["周期回调"] = ____on_5B88_62A4_4E4B_76FE_653B_51FB_540C_6B65,
        ["获取回调"] = ____on_5B88_62A4_4E4B_76FE_83B7_5F97,
        ["丢弃回调"] = ____on_5B88_62A4_4E4B_76FE_4E22_5F03
    })
    if not _____5DF2_6CE8_518C_5B88_62A4_4E4B_76FE_4F24_5BB3_4FEE_6B63 then
        _____5DF2_6CE8_518C_5B88_62A4_4E4B_76FE_4F24_5BB3_4FEE_6B63 = true
        registerDamageModifier(____on_5B88_62A4_4E4B_76FE_4F24_5BB3_4FEE_6B63, 35)
    end
end
_____521D_59CB_5316_5B88_62A4_4E4B_76FE()
return ____exports
