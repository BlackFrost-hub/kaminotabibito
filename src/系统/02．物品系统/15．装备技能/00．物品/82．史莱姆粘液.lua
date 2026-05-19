--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.07．获得物品.00．公共.00．获得物品配置表")
local _____53F2_83B1_59C6_7C98_6DB2_914D_7F6E = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["史莱姆粘液配置"]
local _____83B7_5F97_7269_54C1_88C5_5907ID = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["获得物品装备ID"]
local ____require_result_0 = require("系统.02．物品系统.15．装备技能.06．获取丢弃.index")
local _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03 = ____require_result_0["监听指定物品获取丢弃"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.05．物品次数转移")
local _____589E_52A0_7269_54C1_6B21_6570 = ____require_result_1["增加物品次数"]
local jass = require("jass.common")
local RemoveItem = jass.RemoveItem
local function ____on_53F2_83B1_59C6_7C98_6DB2_83B7_5F97(unit, item)
    if _____83B7_5F97_7269_54C1_88C5_5907ID["史莱姆粘液瓶"] == 0 then
        return
    end
    _____589E_52A0_7269_54C1_6B21_6570(unit, _____83B7_5F97_7269_54C1_88C5_5907ID["史莱姆粘液瓶"], _____53F2_83B1_59C6_7C98_6DB2_914D_7F6E["增加次数"], _____53F2_83B1_59C6_7C98_6DB2_914D_7F6E["最大次数"])
    if item ~= nil and item ~= 0 then
        RemoveItem(item)
    end
end
local function _____521D_59CB_5316_53F2_83B1_59C6_7C98_6DB2()
    if _____83B7_5F97_7269_54C1_88C5_5907ID["史莱姆粘液"] == 0 then
        return
    end
    _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03(_____83B7_5F97_7269_54C1_88C5_5907ID["史莱姆粘液"], ____on_53F2_83B1_59C6_7C98_6DB2_83B7_5F97)
end
_____521D_59CB_5316_53F2_83B1_59C6_7C98_6DB2()
return ____exports
