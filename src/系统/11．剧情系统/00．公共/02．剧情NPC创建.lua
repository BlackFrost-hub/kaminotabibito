--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_0.YDUserDataSetSafe
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local X_FixUnitStandingSafe = ____require_result_1.X_FixUnitStandingSafe
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_3["创建单位并登记排泄安全"]
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_4.debugLogForce
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_5["添加单位暂停"]
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168 = ____require_result_6["暂停并设置无敌安全"]
local _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID = 15
local CreateUnit = jass.CreateUnit
local Player = jass.Player
local GetPlayerId = jass.GetPlayerId
local IssueImmediateOrder = jass.IssueImmediateOrder
local SetUnitFacing = jass.SetUnitFacing
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local SetUnitPosition = jass.SetUnitPosition
local _____5267_60C5NPC_521B_5EFA_8BCA_65AD_6A21_5757 = "剧情NPC创建诊断"
local function _____8BFB_53D6_5DF2_7ED1_5B9ANPC(_____914D_7F6E)
    if _____914D_7F6E["YD表"] == nil or _____914D_7F6E["YD键"] == nil or _____914D_7F6E["YD字段"] == nil then
        return nil
    end
    local unit = YDUserDataGetSafe("string", _____914D_7F6E["YD表"], _____914D_7F6E["YD键"], _____914D_7F6E["YD类型"] or "unit")
    local ____temp_7
    if unit == nil or unit == 0 then
        ____temp_7 = nil
    else
        ____temp_7 = unit
    end
    return ____temp_7
end
local function _____5199_5165NPC_7ED1_5B9A(_____914D_7F6E, unit)
    if _____914D_7F6E["YD表"] == nil or _____914D_7F6E["YD键"] == nil or _____914D_7F6E["YD字段"] == nil then
        return
    end
    YDUserDataSetSafe(
        "string",
        _____914D_7F6E["YD表"],
        _____914D_7F6E["YD键"],
        _____914D_7F6E["YD类型"] or "unit",
        unit
    )
end
--- 配置化创建或复用场景单位；不负责任务标记、对白和入口监听。
____exports["创建剧情场景单位"] = function(_____914D_7F6E)
    local unit = _____8BFB_53D6_5DF2_7ED1_5B9ANPC(_____914D_7F6E)
    if unit == nil then
        local owner = Player(_____914D_7F6E["玩家ID"] or _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID)
        local unitTypeId = stringToFourCCSafe(_____914D_7F6E["单位ID"])
        if not (unitTypeId > 0) then
            return nil
        end
        debugLogForce(
            _____5267_60C5NPC_521B_5EFA_8BCA_65AD_6A21_5757,
            "CreateUnit前",
            "单位ID",
            _____914D_7F6E["单位ID"],
            "单位码",
            unitTypeId,
            "配置玩家ID",
            _____914D_7F6E["玩家ID"] or _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID,
            "实际玩家ID",
            GetPlayerId(owner),
            "X",
            _____914D_7F6E.X,
            "Y",
            _____914D_7F6E.Y,
            "朝向",
            _____914D_7F6E["朝向"],
            "YD表",
            _____914D_7F6E["YD表"] or "",
            "YD键",
            _____914D_7F6E["YD键"] or "",
            "死亡排泄",
            _____914D_7F6E["登记死亡排泄"] == true
        )
        local ____temp_8
        if _____914D_7F6E["登记死亡排泄"] == true then
            ____temp_8 = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
                owner,
                unitTypeId,
                _____914D_7F6E.X,
                _____914D_7F6E.Y,
                _____914D_7F6E["朝向"]
            )
        else
            ____temp_8 = CreateUnit(
                owner,
                unitTypeId,
                _____914D_7F6E.X,
                _____914D_7F6E.Y,
                _____914D_7F6E["朝向"]
            )
        end
        unit = ____temp_8
        if unit == nil then
            return nil
        end
        _____5199_5165NPC_7ED1_5B9A(_____914D_7F6E, unit)
    end
    if _____914D_7F6E["初始化命令"] ~= nil and _____914D_7F6E["初始化命令"] ~= false then
        IssueImmediateOrder(unit, _____914D_7F6E["初始化命令"])
    end
    local _____6682_505C_6765_6E90 = _____914D_7F6E["初始化暂停来源"] or ""
    if _____6682_505C_6765_6E90 ~= "" then
        if _____914D_7F6E["初始化无敌"] == true then
            _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(unit, _____6682_505C_6765_6E90)
        else
            _____6DFB_52A0_5355_4F4D_6682_505C(unit, _____6682_505C_6765_6E90)
        end
    elseif _____914D_7F6E["初始化无敌"] == true then
        SetUnitInvulnerable(unit, true)
    end
    if _____914D_7F6E["初始化固定站立"] == true then
        X_FixUnitStandingSafe(unit)
    end
    return unit
end
--- 统一复用单位的场景站位动作；创建新单位时优先直接使用创建剧情场景单位配置。
____exports["定位剧情单位"] = function(unit, _____7AD9_4F4D)
    if unit == nil or unit == 0 then
        return false
    end
    SetUnitPosition(unit, _____7AD9_4F4D.X, _____7AD9_4F4D.Y)
    SetUnitFacing(unit, _____7AD9_4F4D["朝向"])
    local _____547D_4EE4 = _____7AD9_4F4D["命令"] == nil and "stop" or _____7AD9_4F4D["命令"]
    if _____547D_4EE4 ~= false then
        IssueImmediateOrder(unit, _____547D_4EE4)
    end
    return true
end
____exports["批量创建剧情场景单位"] = function(_____914D_7F6E_5217_8868)
    local _____7ED3_679C = {}
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local unit = ____exports["创建剧情场景单位"](_____914D_7F6E_5217_8868[i + 1])
            if unit ~= nil and unit ~= 0 then
                _____7ED3_679C[#_____7ED3_679C + 1] = unit
            end
            i = i + 1
        end
    end
    return _____7ED3_679C
end
--- 兼容现有 NPC 配置；新场景演员、入口单位和待战单位统一调用场景单位接口。
____exports["创建剧情NPC单位"] = function(_____914D_7F6E)
    return ____exports["创建剧情场景单位"](_____914D_7F6E)
end
return ____exports
