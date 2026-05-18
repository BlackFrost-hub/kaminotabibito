--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_65BD_6CD5_89E6_53D1_5E38_91CF = require("系统.02．物品系统.15．装备技能.03．主动技能.02．施法触发.01．施法触发常量")
local _____65BD_6CD5_4E3B_52A8_6280_80FD_6700_5C0F_51B7_5374 = ____01_FF0E_65BD_6CD5_89E6_53D1_5E38_91CF["施法主动技能最小冷却"]
local ____06_FF0E_6218_58EB_5927_8863 = require("系统.02．物品系统.15．装备技能.00．物品.06．战士大衣")
local _____5904_7406_6218_58EB_5927_8863_65BD_6CD5 = ____06_FF0E_6218_58EB_5927_8863["处理战士大衣施法"]
local ____07_FF0E_6BD4_5B89_8840_722A = require("系统.02．物品系统.15．装备技能.00．物品.07．比安血爪")
local _____5904_7406_6BD4_5B89_8840_722A_65BD_6CD5 = ____07_FF0E_6BD4_5B89_8840_722A["处理比安血爪施法"]
local ____10_FF0E_5DE8_9B54_5927_5251 = require("系统.02．物品系统.15．装备技能.00．物品.10．巨魔大剑")
local _____5904_7406_5DE8_9B54_5927_5251_65BD_6CD5 = ____10_FF0E_5DE8_9B54_5927_5251["处理巨魔大剑施法"]
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isNotUsingInventoryItem = ____require_result_1.isNotUsingInventoryItem
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local getObjectPropertyRealSafe = ____require_result_2.getObjectPropertyRealSafe
local ____require_result_3 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local ObjectType = ____require_result_3.ObjectType
local _____5DF2_521D_59CB_5316_65BD_6CD5_4E3B_52A8_6280_80FD_6838_5FC3 = false
local function _____6EE1_8DB3_65BD_6CD5_4E3B_52A8_6280_80FD_516C_5171_524D_7F6E_6761_4EF6(_____65BD_6CD5_5355_4F4D, _____6280_80FDID)
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
        return false
    end
    if _____6280_80FDID == nil or _____6280_80FDID == 0 then
        return false
    end
    if not isNotUsingInventoryItem(_____65BD_6CD5_5355_4F4D) then
        return false
    end
    return getObjectPropertyRealSafe(ObjectType.ABILITY, _____6280_80FDID, "Cool1") >= _____65BD_6CD5_4E3B_52A8_6280_80FD_6700_5C0F_51B7_5374
end
local function ____on_65BD_6CD5_4E3B_52A8_6280_80FD_751F_6548(_____65BD_6CD5_5355_4F4D, _____6280_80FDID)
    if not _____6EE1_8DB3_65BD_6CD5_4E3B_52A8_6280_80FD_516C_5171_524D_7F6E_6761_4EF6(_____65BD_6CD5_5355_4F4D, _____6280_80FDID) then
        return
    end
    _____5904_7406_6218_58EB_5927_8863_65BD_6CD5(_____65BD_6CD5_5355_4F4D)
    _____5904_7406_6BD4_5B89_8840_722A_65BD_6CD5(_____65BD_6CD5_5355_4F4D)
    _____5904_7406_5DE8_9B54_5927_5251_65BD_6CD5(_____65BD_6CD5_5355_4F4D, _____6280_80FDID)
end
____exports["初始化施法主动技能核心"] = function()
    if _____5DF2_521D_59CB_5316_65BD_6CD5_4E3B_52A8_6280_80FD_6838_5FC3 then
        return
    end
    _____5DF2_521D_59CB_5316_65BD_6CD5_4E3B_52A8_6280_80FD_6838_5FC3 = true
    registerSpellEffectListener(____on_65BD_6CD5_4E3B_52A8_6280_80FD_751F_6548)
end
return ____exports
