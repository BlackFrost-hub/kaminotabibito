--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入剧情进度"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____66F4_65B0_4E3B_7EBF_4EFB_52A1UI = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["更新主线任务UI"]
local ____02_FF0E_5267_60C5_6B65_9AA4 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.index")
local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____02_FF0E_5267_60C5_6B65_9AA4["播放主线剧情片段"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemPickup = ____require_result_0.onItemPickup
local onItemUse = ____require_result_0.onItemUse
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_3.UnitHasItemOfTypeBJ
local ____require_result_4 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_4["按名字反查物品ID"]
local ____require_result_5 = require("lib.扩展函数.BJ函数.05A．电影函数")
local TransmissionFromUnitWithNameBJ = ____require_result_5.TransmissionFromUnitWithNameBJ
local GetItemTypeId = jass.GetItemTypeId
local GetPlayersAll = jass.GetPlayersAll
local GetUnitName = jass.GetUnitName
local IsUnitInGroup = jass.IsUnitInGroup
local IsUnitType = jass.IsUnitType
local RemoveItem = jass.RemoveItem
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local bj_TIMETYPE_SET = jglobals.bj_TIMETYPE_SET
local _____72E9_730E_98DF_4EBA_9B54_4EFB_52A1_7269_54C1_7C7B_578BID = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID("接受任务-|cffff0000狩猎食人魔（等级24）|r"))
local _____9B54_6CD5_4FE1_4EF6_7269_54C1_7C7B_578BID = stringToFourCCSafe("texp")
local ____CS_89E6_53D1_8FDB_5EA6 = 9
local ____CS_76EE_6807_8FDB_5EA6 = 10
local ____ZX02_89E6_53D1_8FDB_5EA6 = 28
local ____ZX02_76EE_6807_8FDB_5EA6 = 29
local ____ZX02_5BF9_767D_6587_672C = "这件物品中残留着异常的魔力波动，应该能作为新的线索。先带回王城，请克林姆德王确认。"
local ____ZX02_4EFB_52A1_63CF_8FF0 = "返回王城，将新发现的魔力线索交给克林姆德王。"
local ____ZX02_4EFB_52A1_63D0_793A = "|cffffff00『主线目标』：|r返回|cffff99cc『克林姆德王城』|r。"
local _____5DF2_521D_59CB_5316_4E3B_7EBF_5267_60C5_7269_54C1_4E8B_4EF6 = false
local function _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4()
    return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
end
local function _____662F_73A9_5BB6_82F1_96C4(unit)
    if unit == nil or unit == 0 then
        return false
    end
    if IsUnitType(unit, UNIT_TYPE_HERO) ~= true then
        return false
    end
    local _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 = _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4()
    if _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 == nil or _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 == 0 then
        return false
    end
    return IsUnitInGroup(unit, _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4) == true
end
local function ____on_72E9_730E_98DF_4EBA_9B54_4EFB_52A1_7269_54C1_62FE_53D6(unit, item)
    if unit == nil or unit == 0 then
        return
    end
    if item == nil or item == 0 then
        return
    end
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= ____CS_89E6_53D1_8FDB_5EA6 then
        return
    end
    if _____72E9_730E_98DF_4EBA_9B54_4EFB_52A1_7269_54C1_7C7B_578BID <= 0 then
        return
    end
    if GetItemTypeId(item) ~= _____72E9_730E_98DF_4EBA_9B54_4EFB_52A1_7269_54C1_7C7B_578BID then
        return
    end
    if not _____662F_73A9_5BB6_82F1_96C4(unit) then
        return
    end
    RemoveItem(item)
    _____5199_5165_5267_60C5_8FDB_5EA6(____CS_76EE_6807_8FDB_5EA6)
    _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5("jlc_snake_ogre_task_accept", {["片段ID"] = "jlc_snake_ogre_task_accept", ["触发配置名"] = "剧情传送CS", ["触发单位"] = unit})
end
local function ____on_9B54_6CD5_4FE1_4EF6_7269_54C1_4F7F_7528(unit, item)
    if unit == nil or unit == 0 then
        return
    end
    if item == nil or item == 0 then
        return
    end
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= ____ZX02_89E6_53D1_8FDB_5EA6 then
        return
    end
    if _____9B54_6CD5_4FE1_4EF6_7269_54C1_7C7B_578BID <= 0 then
        return
    end
    if UnitHasItemOfTypeBJ(unit, _____9B54_6CD5_4FE1_4EF6_7269_54C1_7C7B_578BID) ~= true then
        return
    end
    if not _____662F_73A9_5BB6_82F1_96C4(unit) then
        return
    end
    _____5199_5165_5267_60C5_8FDB_5EA6(____ZX02_76EE_6807_8FDB_5EA6)
    TransmissionFromUnitWithNameBJ(
        GetPlayersAll(),
        nil,
        GetUnitName(unit),
        nil,
        ____ZX02_5BF9_767D_6587_672C,
        bj_TIMETYPE_SET,
        5,
        true
    )
    _____66F4_65B0_4E3B_7EBF_4EFB_52A1UI(____ZX02_4EFB_52A1_63CF_8FF0, ____ZX02_4EFB_52A1_63D0_793A)
end
____exports["初始化主线剧情物品事件"] = function()
    if _____5DF2_521D_59CB_5316_4E3B_7EBF_5267_60C5_7269_54C1_4E8B_4EF6 then
        return
    end
    _____5DF2_521D_59CB_5316_4E3B_7EBF_5267_60C5_7269_54C1_4E8B_4EF6 = true
    onItemPickup(____on_72E9_730E_98DF_4EBA_9B54_4EFB_52A1_7269_54C1_62FE_53D6)
    onItemUse(____on_9B54_6CD5_4FE1_4EF6_7269_54C1_4F7F_7528)
end
return ____exports
