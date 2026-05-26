--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____05_FF0E_4E3B_7EBF_5267_60C5_4E8B_4EF6_914D_7F6E_8868 = require("系统.11．剧情系统.01．主线任务.01．主线剧情入口.05．主线剧情事件配置表")
local _____4E3B_7EBF_5267_60C5_7269_54C1_4E8B_4EF6_914D_7F6E_8868 = ____05_FF0E_4E3B_7EBF_5267_60C5_4E8B_4EF6_914D_7F6E_8868["主线剧情物品事件配置表"]
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入剧情进度"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____66F4_65B0_4E3B_7EBF_4EFB_52A1UI = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["更新主线任务UI"]
local ____02_FF0E_5267_60C5_6B65_9AA4_64AD_653E_5668 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____02_FF0E_5267_60C5_6B65_9AA4_64AD_653E_5668["播放主线剧情片段"]
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
local ____require_result_6 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_6.GetPlayersAll
local GetItemTypeId = jass.GetItemTypeId
local GetUnitName = jass.GetUnitName
local IsUnitInGroup = jass.IsUnitInGroup
local IsUnitType = jass.IsUnitType
local RemoveItem = jass.RemoveItem
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local bj_TIMETYPE_SET = jglobals.bj_TIMETYPE_SET
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
local function _____83B7_53D6_7269_54C1_4E8B_4EF6_914D_7F6E_7C7B_578BID(_____914D_7F6E)
    if _____914D_7F6E["物品名"] ~= nil and _____914D_7F6E["物品名"] ~= "" then
        return stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____914D_7F6E["物品名"]))
    end
    if _____914D_7F6E["物品ID"] ~= nil and _____914D_7F6E["物品ID"] ~= "" then
        return stringToFourCCSafe(_____914D_7F6E["物品ID"])
    end
    return 0
end
local function _____547D_4E2D_7269_54C1_4E8B_4EF6_914D_7F6E(_____914D_7F6E, _____89E6_53D1_65B9_5F0F, unit, item)
    if _____914D_7F6E["触发方式"] ~= _____89E6_53D1_65B9_5F0F then
        return false
    end
    if unit == nil or unit == 0 then
        return false
    end
    if item == nil or item == 0 then
        return false
    end
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= _____914D_7F6E["需要剧情进度"] then
        return false
    end
    if not _____662F_73A9_5BB6_82F1_96C4(unit) then
        return false
    end
    local _____7269_54C1_7C7B_578BID = _____83B7_53D6_7269_54C1_4E8B_4EF6_914D_7F6E_7C7B_578BID(_____914D_7F6E)
    if not (_____7269_54C1_7C7B_578BID > 0) then
        return false
    end
    if _____914D_7F6E["按持有物品校验"] == true then
        return UnitHasItemOfTypeBJ(unit, _____7269_54C1_7C7B_578BID) == true
    end
    return GetItemTypeId(item) == _____7269_54C1_7C7B_578BID
end
local function _____6267_884C_7269_54C1_4E8B_4EF6_914D_7F6E(_____914D_7F6E, unit, item)
    if _____914D_7F6E["移除触发物品"] == true then
        RemoveItem(item)
    end
    _____5199_5165_5267_60C5_8FDB_5EA6(_____914D_7F6E["目标剧情进度"])
    if _____914D_7F6E["剧情片段ID"] ~= nil and _____914D_7F6E["剧情片段ID"] ~= "" then
        _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5(_____914D_7F6E["剧情片段ID"], {["片段ID"] = _____914D_7F6E["剧情片段ID"], ["触发配置名"] = _____914D_7F6E["配置名"], ["触发单位"] = unit})
        return
    end
    if _____914D_7F6E["对白文本"] ~= nil and _____914D_7F6E["对白文本"] ~= "" then
        TransmissionFromUnitWithNameBJ(
            GetPlayersAll(),
            nil,
            GetUnitName(unit),
            nil,
            _____914D_7F6E["对白文本"],
            bj_TIMETYPE_SET,
            5,
            true
        )
    end
    if _____914D_7F6E["任务描述"] ~= nil and _____914D_7F6E["任务提示"] ~= nil then
        _____66F4_65B0_4E3B_7EBF_4EFB_52A1UI(_____914D_7F6E["任务描述"], _____914D_7F6E["任务提示"])
    end
end
local function _____5904_7406_4E3B_7EBF_5267_60C5_7269_54C1_4E8B_4EF6(_____89E6_53D1_65B9_5F0F, unit, item)
    do
        local i = 0
        while i < #_____4E3B_7EBF_5267_60C5_7269_54C1_4E8B_4EF6_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____4E3B_7EBF_5267_60C5_7269_54C1_4E8B_4EF6_914D_7F6E_8868[i + 1]
                if not _____547D_4E2D_7269_54C1_4E8B_4EF6_914D_7F6E(_____914D_7F6E, _____89E6_53D1_65B9_5F0F, unit, item) then
                    goto __continue25
                end
                _____6267_884C_7269_54C1_4E8B_4EF6_914D_7F6E(_____914D_7F6E, unit, item)
                return
            end
            ::__continue25::
            i = i + 1
        end
    end
end
local function ____on_4E3B_7EBF_5267_60C5_7269_54C1_62FE_53D6(unit, item)
    _____5904_7406_4E3B_7EBF_5267_60C5_7269_54C1_4E8B_4EF6("拾取", unit, item)
end
local function ____on_4E3B_7EBF_5267_60C5_7269_54C1_4F7F_7528(unit, item)
    _____5904_7406_4E3B_7EBF_5267_60C5_7269_54C1_4E8B_4EF6("使用", unit, item)
end
____exports["初始化主线剧情物品事件"] = function()
    if _____5DF2_521D_59CB_5316_4E3B_7EBF_5267_60C5_7269_54C1_4E8B_4EF6 then
        return
    end
    _____5DF2_521D_59CB_5316_4E3B_7EBF_5267_60C5_7269_54C1_4E8B_4EF6 = true
    onItemPickup(____on_4E3B_7EBF_5267_60C5_7269_54C1_62FE_53D6)
    onItemUse(____on_4E3B_7EBF_5267_60C5_7269_54C1_4F7F_7528)
end
return ____exports
