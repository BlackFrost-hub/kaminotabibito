local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
local ____02_FF0E_7269_54C1_63D0_793A_8BFB_53D6_7F13_5B58 = require("系统.09．表现系统.12．物品提示模拟.02．物品提示读取缓存")
local ObjectType = ____02_FF0E_7269_54C1_63D0_793A_8BFB_53D6_7F13_5B58.ObjectType
local _____5B89_5168_53D6_7269_54C1_5B9E_4F8B_6570_636E_5B57_7B26_4E32 = ____02_FF0E_7269_54C1_63D0_793A_8BFB_53D6_7F13_5B58["安全取物品实例数据字符串"]
local _____5B89_5168_53D6_7269_7F16_5B57_7B26_4E32 = ____02_FF0E_7269_54C1_63D0_793A_8BFB_53D6_7F13_5B58["安全取物编字符串"]
local _____5B89_5168_53D6_7269_7F16_6574_6570 = ____02_FF0E_7269_54C1_63D0_793A_8BFB_53D6_7F13_5B58["安全取物编整数"]
local jass = require("jass.common")
local dynamicTextCore = require("系统.03．技能系统.07．动态技能文本.03．核心逻辑")
local _____6E32_67D3_52A8_6001_6587_672C = dynamicTextCore["渲染动态文本"]
local GetItemName = jass.GetItemName
local GetItemTypeId = jass.GetItemTypeId
local UnitItemInSlot = jass.UnitItemInSlot
local function _____53D6_7269_54C1_4E3B_52A8_84DD_8017(itemTypeId)
    local abilityList = _____5B89_5168_53D6_7269_7F16_5B57_7B26_4E32(ObjectType.ITEM, itemTypeId, "abilList") or ""
    if abilityList == "" then
        return 0
    end
    local firstAbility = __TS__StringTrim(__TS__StringSplit(abilityList, ",")[1] or "")
    if firstAbility == "" then
        return 0
    end
    return _____5B89_5168_53D6_7269_7F16_6574_6570(ObjectType.ABILITY, firstAbility, "Cost")
end
local function _____7269_54C1_6709_4E3B_52A8_6280_80FD(itemTypeId)
    local abilityList = _____5B89_5168_53D6_7269_7F16_5B57_7B26_4E32(ObjectType.ITEM, itemTypeId, "abilList") or ""
    return __TS__StringTrim(__TS__StringSplit(abilityList, ",")[1] or "") ~= ""
end
local function _____53D6_7269_54C1_69FD_4F4D_5C0F_952E_76D8(slot)
    if slot == 0 then
        return "7"
    end
    if slot == 1 then
        return "8"
    end
    if slot == 2 then
        return "4"
    end
    if slot == 3 then
        return "5"
    end
    if slot == 4 then
        return "1"
    end
    if slot == 5 then
        return "2"
    end
    return ""
end
local function _____53D6_7269_54C1_5F53_524D_5C0F_952E_76D8_5FEB_6377_952E(hero, item)
    if hero == nil or hero == 0 or item == nil or item == 0 then
        return ""
    end
    do
        local slot = 0
        while slot < 6 do
            if UnitItemInSlot(hero, slot) == item then
                return _____53D6_7269_54C1_69FD_4F4D_5C0F_952E_76D8(slot)
            end
            slot = slot + 1
        end
    end
    return ""
end
____exports["构建物品提示内容"] = function(item, hero)
    if item == nil or item == 0 then
        return nil
    end
    local itemTypeId = GetItemTypeId(item)
    if itemTypeId == 0 then
        return nil
    end
    local name = GetItemName(item) or ""
    local rawText = _____5B89_5168_53D6_7269_54C1_5B9E_4F8B_6570_636E_5B57_7B26_4E32(item, itemTypeId, 3) or ""
    local dynamicText = hero ~= nil and hero ~= 0 and _____6E32_67D3_52A8_6001_6587_672C(hero, rawText, {appendAltHint = false, preserveFormula = true}) or rawText
    local manaCost = _____53D6_7269_54C1_4E3B_52A8_84DD_8017(itemTypeId)
    local activeUsable = _____7269_54C1_6709_4E3B_52A8_6280_80FD(itemTypeId)
    local activeUseHotkey = activeUsable and _____53D6_7269_54C1_5F53_524D_5C0F_952E_76D8_5FEB_6377_952E(hero, item) or ""
    local goldCost = _____5B89_5168_53D6_7269_7F16_6574_6570(ObjectType.ITEM, itemTypeId, "goldcost")
    local sellableFlag = _____5B89_5168_53D6_7269_7F16_6574_6570(ObjectType.ITEM, itemTypeId, "sellable")
    local pawnableFlag = _____5B89_5168_53D6_7269_7F16_6574_6570(ObjectType.ITEM, itemTypeId, "pawnable")
    local canSell = goldCost > 0 and (sellableFlag > 0 or pawnableFlag > 0)
    return {
        name = name,
        dynamicText = dynamicText,
        manaCost = manaCost,
        sellGold = canSell and goldCost * 0.5 or 0,
        sellable = canSell,
        activeUsable = activeUsable,
        activeUseHotkey = activeUseHotkey
    }
end
return ____exports
