--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_6B7B_4EA1_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.01．死亡事件.01．死亡事件配置表")
local _____83B7_53D6_6B7B_4EA1_4E8B_4EF6_914D_7F6E = ____01_FF0E_6B7B_4EA1_4E8B_4EF6_914D_7F6E_8868["获取死亡事件配置"]
local _____53D6_7269_54C1_56DB_5B57_7801 = ____01_FF0E_6B7B_4EA1_4E8B_4EF6_914D_7F6E_8868["取物品四字码"]
---
-- @noSelfInFile
local jass = require("jass.common")
local itemJudgeFns = require("lib.扩展函数.物品相关函数.index")
local function _____7ED9_4E88_5347_7EA7_88C5_5907(_____5355_4F4D, _____5347_7EA7_5230_88C5_5907ID)
    local _____5347_7EA7_56DB_5B57_7801 = _____53D6_7269_54C1_56DB_5B57_7801(_____5347_7EA7_5230_88C5_5907ID)
    if not (_____5347_7EA7_56DB_5B57_7801 > 0) then
        return
    end
    local x = jass:GetUnitX(_____5355_4F4D)
    local y = jass:GetUnitY(_____5355_4F4D)
    local item = itemJudgeFns["创建物品并注册排泄监听"](_____5347_7EA7_56DB_5B57_7801, x, y)
    if item == nil or item == 0 then
        return
    end
    jass:UnitAddItem(_____5355_4F4D, item)
end
local function _____5904_7406_5355_4E2A_51FB_6740_53E0_5C42(_____51FB_6740_8005, _____914D_7F6E)
    local _____7269_54C1_56DB_5B57_7801 = _____53D6_7269_54C1_56DB_5B57_7801(_____914D_7F6E["装备ID"])
    if not (_____7269_54C1_56DB_5B57_7801 > 0) then
        return
    end
    local item = itemJudgeFns.GetItemOfTypeFromUnitBJ(_____51FB_6740_8005, _____7269_54C1_56DB_5B57_7801)
    if item == nil or item == 0 then
        return
    end
    local _____5F53_524D_5C42_6570 = jass:GetItemCharges(item)
    if _____914D_7F6E["满层升级到装备名"] == nil then
        if _____5F53_524D_5C42_6570 >= _____914D_7F6E["最大层数"] then
            return
        end
        local _____65B0_5C42_6570 = _____5F53_524D_5C42_6570 + _____914D_7F6E["每次增加层数"] >= _____914D_7F6E["最大层数"] and _____914D_7F6E["最大层数"] or _____5F53_524D_5C42_6570 + _____914D_7F6E["每次增加层数"]
        jass:SetItemCharges(item, _____65B0_5C42_6570)
        return
    end
    local _____65B0_5C42_6570 = _____5F53_524D_5C42_6570 + _____914D_7F6E["每次增加层数"]
    jass:SetItemCharges(item, _____65B0_5C42_6570)
    if _____65B0_5C42_6570 < _____914D_7F6E["最大层数"] then
        return
    end
    jass:RemoveItem(item)
    _____7ED9_4E88_5347_7EA7_88C5_5907(_____51FB_6740_8005, _____914D_7F6E["满层升级到装备ID"])
end
____exports["处理击杀叠层"] = function(_____4E0A_4E0B_6587)
    local _____51FB_6740_8005 = _____4E0A_4E0B_6587["击杀单位"]
    if _____51FB_6740_8005 == nil or _____51FB_6740_8005 == 0 then
        return
    end
    for ____, _____914D_7F6E in ipairs(_____83B7_53D6_6B7B_4EA1_4E8B_4EF6_914D_7F6E()["击杀叠层列表"]) do
        _____5904_7406_5355_4E2A_51FB_6740_53E0_5C42(_____51FB_6740_8005, _____914D_7F6E)
    end
end
return ____exports
