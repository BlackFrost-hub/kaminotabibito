--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____53F2_83B1_59C6_7C98_6DB2_74F6_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["史莱姆粘液瓶物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____53F2_83B1_59C6_7C98_6DB2_74F6_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["史莱姆粘液瓶配置"]
local ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.07．获得物品.00．公共.00．获得物品配置表")
local _____83B7_5F97_7269_54C1_88C5_5907ID = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["获得物品装备ID"]
local _____53F2_83B1_59C6_7C98_6DB2_914D_7F6E = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["史莱姆粘液配置"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.03．快速Buff")
local _____5FEB_901F_51CF_901FBuff = ____require_result_1["快速减速Buff"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.05．物品次数转移")
local _____589E_52A0_7269_54C1_6B21_6570 = ____require_result_2["增加物品次数"]
local ____require_result_3 = require("系统.02．物品系统.15．装备技能.06．获取丢弃.index")
local _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03 = ____require_result_3["监听指定物品获取丢弃"]
local jass = require("jass.common")
local GetItemTypeId = jass.GetItemTypeId
local RemoveItem = jass.RemoveItem
local function _____662F_5426_4E3A_53F2_83B1_59C6_7C98_6DB2_74F6(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____53F2_83B1_59C6_7C98_6DB2_74F6_7269_54C1ID
end
local function ____on_83B7_5F97_53F2_83B1_59C6_7C98_6DB2(unit, item)
    if _____83B7_5F97_7269_54C1_88C5_5907ID["史莱姆粘液瓶"] == 0 then
        return
    end
    _____589E_52A0_7269_54C1_6B21_6570(unit, _____83B7_5F97_7269_54C1_88C5_5907ID["史莱姆粘液瓶"], _____53F2_83B1_59C6_7C98_6DB2_914D_7F6E["增加次数"], _____53F2_83B1_59C6_7C98_6DB2_914D_7F6E["最大次数"])
    if item ~= nil and item ~= 0 then
        RemoveItem(item)
    end
end
local function _____521D_59CB_5316_53F2_83B1_59C6_7C98_6DB2_62FE_53D6_6548_679C()
    if _____83B7_5F97_7269_54C1_88C5_5907ID["史莱姆粘液"] == 0 then
        return
    end
    _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03(_____83B7_5F97_7269_54C1_88C5_5907ID["史莱姆粘液"], ____on_83B7_5F97_53F2_83B1_59C6_7C98_6DB2)
end
____exports["处理史莱姆粘液瓶使用"] = function(_____4E0A_4E0B_6587)
    debugLogForce("12．史莱姆粘液瓶", "进入", "处理史莱姆粘液瓶使用")
    if not _____662F_5426_4E3A_53F2_83B1_59C6_7C98_6DB2_74F6(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    if _____4E0A_4E0B_6587["目标单位"] == nil or _____4E0A_4E0B_6587["目标单位"] == 0 then
        return
    end
    _____5FEB_901F_51CF_901FBuff(
        _____4E0A_4E0B_6587["施法单位"],
        _____4E0A_4E0B_6587["目标单位"],
        _____53F2_83B1_59C6_7C98_6DB2_74F6_914D_7F6E["攻速减幅"],
        _____53F2_83B1_59C6_7C98_6DB2_74F6_914D_7F6E["移速减幅"],
        _____53F2_83B1_59C6_7C98_6DB2_74F6_914D_7F6E["持续时间"]
    )
end
_____521D_59CB_5316_53F2_83B1_59C6_7C98_6DB2_62FE_53D6_6548_679C()
return ____exports
