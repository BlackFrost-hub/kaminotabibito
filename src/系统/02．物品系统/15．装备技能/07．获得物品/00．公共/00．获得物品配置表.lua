local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_0.resolveItemIdByName
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local jass = require("jass.common")
local _____60E9_7F5A_7269_54C1_767B_8BB0 = {}
local ____require_result_2 = require("lib.扩展函数.物品相关函数.index")
local getItemDataEntry = ____require_result_2.getItemDataEntry
local _____88C5_5907_6570_636E_8868 = require("系统.02．物品系统.01．装备数据").default
local _____60E9_7F5A_88C5_5907_7C7B_578BID_8868 = {}
for itemId in pairs(_____88C5_5907_6570_636E_8868) do
    local ____opt_3 = _____88C5_5907_6570_636E_8868[itemId]
    if ____opt_3 ~= nil then
        ____opt_3 = ____opt_3["惩罚死亡丢弃"]
    end
    if ____opt_3 == true then
        local typeId = stringToFourCCSafe(itemId)
        if typeId ~= 0 then
            _____60E9_7F5A_88C5_5907_7C7B_578BID_8868[typeId] = true
        end
    end
end
____exports["登记并丢弃惩罚装备"] = function(unit)
    if unit == nil or unit == 0 then
        return
    end
    do
        local slot = 0
        while slot < 6 do
            local item = jass.UnitItemInSlot(unit, slot)
            local itemTypeId = item ~= nil and item ~= 0 and jass.GetItemTypeId(item) or 0
            local marked = itemTypeId ~= 0 and _____60E9_7F5A_88C5_5907_7C7B_578BID_8868[itemTypeId] == true
            if item ~= nil and item ~= 0 and marked then
                local key = jass.GetHandleId(unit)
                local ____60E9_7F5A_7269_54C1_767B_8BB0_key_6 = _____60E9_7F5A_7269_54C1_767B_8BB0[key]
                if ____60E9_7F5A_7269_54C1_767B_8BB0_key_6 == nil then
                    local ____temp_5 = {}
                    _____60E9_7F5A_7269_54C1_767B_8BB0[key] = ____temp_5
                    ____60E9_7F5A_7269_54C1_767B_8BB0_key_6 = ____temp_5
                end
                local list = ____60E9_7F5A_7269_54C1_767B_8BB0_key_6
                if __TS__ArrayIndexOf(list, item) < 0 then
                    list[#list + 1] = item
                end
                local x = jass.GetUnitX(unit)
                local y = jass.GetUnitY(unit)
                local removed = jass.UnitRemoveItem(unit, item)
                jass.SetItemPosition(item, x, y)
                return
            end
            slot = slot + 1
        end
    end
end
____exports["复活后放回惩罚物品"] = function(unit)
    local key = jass.GetHandleId(unit)
    local list = _____60E9_7F5A_7269_54C1_767B_8BB0[key]
    if not list then
        return
    end
    __TS__Delete(_____60E9_7F5A_7269_54C1_767B_8BB0, key)
    do
        local i = 0
        while i < #list do
            local item = list[i + 1]
            if item ~= nil and item ~= 0 then
                jass.SetItemPosition(
                    item,
                    jass.GetUnitX(unit),
                    jass.GetUnitY(unit)
                )
            end
            i = i + 1
        end
    end
end
local function _____53D6_88C5_5907_7269_54C1ID(_____88C5_5907_540D_79F0)
    return stringToFourCCSafe(resolveItemIdByName(_____88C5_5907_540D_79F0))
end
____exports["获得物品装备名称"] = {
    ["邪恶之心"] = "邪恶之心（死亡掉落）",
    ["祭祀面具"] = "|cff993366祭祀面具（唯一）|r",
    ["史莱姆粘液"] = "史莱姆粘液",
    ["史莱姆粘液瓶"] = "史莱姆粘液瓶",
    ["豺狼皮甲"] = "豺狼皮甲",
    ["守护之盾"] = "守护之盾",
    ["高原魔力灯笼"] = "高原魔力灯笼",
    ["熔岩宝石"] = "|cffff0000熔岩宝石|r|cffffffcc（只可佩戴一件)|r",
    ["亡之魔杯"] = "|cff33cccc亡之魔杯|r",
    ["熔墓守卫护符"] = "|cff800080熔墓守卫护符|r",
    ["狱生面具"] = "狱生面具",
    ["狱生面具强化"] = "狱生面具（强化）"
}
____exports["获得物品装备ID"] = {
    ["邪恶之心"] = _____53D6_88C5_5907_7269_54C1ID(____exports["获得物品装备名称"]["邪恶之心"]),
    ["祭祀面具"] = _____53D6_88C5_5907_7269_54C1ID(____exports["获得物品装备名称"]["祭祀面具"]),
    ["史莱姆粘液"] = _____53D6_88C5_5907_7269_54C1ID(____exports["获得物品装备名称"]["史莱姆粘液"]),
    ["史莱姆粘液瓶"] = _____53D6_88C5_5907_7269_54C1ID(____exports["获得物品装备名称"]["史莱姆粘液瓶"]),
    ["豺狼皮甲"] = _____53D6_88C5_5907_7269_54C1ID(____exports["获得物品装备名称"]["豺狼皮甲"]),
    ["守护之盾"] = _____53D6_88C5_5907_7269_54C1ID(____exports["获得物品装备名称"]["守护之盾"]),
    ["高原魔力灯笼"] = _____53D6_88C5_5907_7269_54C1ID(____exports["获得物品装备名称"]["高原魔力灯笼"]),
    ["熔岩宝石"] = _____53D6_88C5_5907_7269_54C1ID(____exports["获得物品装备名称"]["熔岩宝石"]),
    ["亡之魔杯"] = _____53D6_88C5_5907_7269_54C1ID(____exports["获得物品装备名称"]["亡之魔杯"]),
    ["熔墓守卫护符"] = _____53D6_88C5_5907_7269_54C1ID(____exports["获得物品装备名称"]["熔墓守卫护符"]),
    ["狱生面具"] = _____53D6_88C5_5907_7269_54C1ID(____exports["获得物品装备名称"]["狱生面具"]),
    ["狱生面具强化"] = _____53D6_88C5_5907_7269_54C1ID(____exports["获得物品装备名称"]["狱生面具强化"])
}
____exports["邪恶之心配置"] = {
    ["装备名称"] = ____exports["获得物品装备名称"]["邪恶之心"],
    ["间隔毫秒"] = 1000,
    ["固定扣血"] = 10,
    ["最大生命扣血比例"] = 0.01,
    ["死亡最小最大生命"] = 1400,
    ["死亡最小当前生命"] = 300,
    ["死亡提示"] = "邪恶之心反噬了持有者。"
}
____exports["祭祀面具配置"] = {
    ["装备名称"] = ____exports["获得物品装备名称"]["祭祀面具"],
    ["间隔毫秒"] = 1000,
    ["固定扣蓝"] = 10,
    ["最大魔法扣蓝比例"] = 0.01,
    ["死亡最小最大魔法"] = 1250,
    ["死亡最小当前魔法"] = 250,
    ["死亡提示"] = "祭祀面具吞噬了持有者。"
}
____exports["史莱姆粘液配置"] = {["装备名称"] = ____exports["获得物品装备名称"]["史莱姆粘液"], ["目标装备名称"] = ____exports["获得物品装备名称"]["史莱姆粘液瓶"], ["增加次数"] = 15, ["最大次数"] = 2147483647}
____exports["豺狼皮甲配置"] = {
    ["装备名称"] = ____exports["获得物品装备名称"]["豺狼皮甲"],
    ["检查间隔毫秒"] = 1000,
    ["高生命阈值"] = 0.7,
    ["生命恢复增加"] = 20,
    ["伤害减少增加"] = 0.1
}
____exports["守护之盾配置"] = {
    ["装备名称"] = ____exports["获得物品装备名称"]["守护之盾"],
    ["攻击同步间隔毫秒"] = 500,
    ["防转攻比例"] = 0.8,
    ["转移半径"] = 800,
    ["转移比例"] = 0.1
}
____exports["高原魔力灯笼配置"] = {
    ["装备名称"] = ____exports["获得物品装备名称"]["高原魔力灯笼"],
    ["间隔毫秒"] = 1000,
    ["最大魔法消耗比例"] = 0.01,
    ["白天治疗半径"] = 700,
    ["白天治疗最大生命比例"] = 0.01,
    ["夜晚伤害减少增加"] = 0.2
}
____exports["熔岩宝石配置"] = {
    ["装备名称"] = ____exports["获得物品装备名称"]["熔岩宝石"],
    ["间隔毫秒"] = 1000,
    ["作用范围"] = 400,
    ["固定火焰伤害"] = 120,
    ["最大生命火焰伤害比例"] = 0.01,
    ["重复佩戴提示"] = "熔岩宝石只可佩戴一件。",
    ["特效路径"] = "Abilities\\Spells\\Items\\AIfb\\AIfbSpecialArt.mdl"
}
____exports["亡之魔杯配置"] = {["装备名称"] = ____exports["获得物品装备名称"]["亡之魔杯"], ["间隔毫秒"] = 1000, ["恢复缺失魔法比例"] = 0.03}
____exports["熔墓守卫护符配置"] = {["装备名称"] = ____exports["获得物品装备名称"]["熔墓守卫护符"], ["间隔毫秒"] = 1000, ["荒芜恢复最大生命比例"] = 0.01}
____exports["狱生面具配置"] = {
    ["装备名称"] = ____exports["获得物品装备名称"]["狱生面具"],
    ["强化装备名称"] = ____exports["获得物品装备名称"]["狱生面具强化"],
    ["间隔毫秒"] = 1000,
    ["作用范围"] = 600,
    ["最大魔法消耗比例"] = 0.01,
    ["强化伤害倍率"] = 2,
    ["强化延迟毫秒"] = 2000,
    ["强化恢复比例"] = 0.3
}
return ____exports
