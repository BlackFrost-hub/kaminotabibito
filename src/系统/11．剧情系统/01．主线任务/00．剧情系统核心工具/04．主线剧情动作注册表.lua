local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入剧情进度"]
local ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.02．剧情动作桥接")
local _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F = ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5["发送剧情任务消息"]
local _____53D1_9001_5267_60C5_5C0F_5730_56FE_4FE1_53F7 = ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5["发送剧情小地图信号"]
local ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E = ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5["创建并冻结剧情Boss预置"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local SetUnitFacingToFaceUnitTimed = ____require_result_0.SetUnitFacingToFaceUnitTimed
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09－YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local ____require_result_2 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_2["按名字反查物品ID"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local CreateFogModifierRect = jass.CreateFogModifierRect
local CreateItem = jass.CreateItem
local FogModifierStart = jass.FogModifierStart
local GetPlayersAll = jass.GetPlayersAll
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IssueImmediateOrder = jass.IssueImmediateOrder
local Player = jass.Player
local SetUnitFacingTimed = jass.SetUnitFacingTimed
local SetUnitOwner = jass.SetUnitOwner
local FOG_OF_WAR_VISIBLE = jass.FOG_OF_WAR_VISIBLE
local bj_QUESTMESSAGE_ITEMACQUIRED = require("jass.globals").bj_QUESTMESSAGE_ITEMACQUIRED
local bj_QUESTMESSAGE_UPDATED = require("jass.globals").bj_QUESTMESSAGE_UPDATED
local function _____8BFB_53D6_957F_8001_5355_4F4D()
    return YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit")
end
local function _____5206_5272_540D_79F0_5217_8868(value)
    if value == nil or value == "" then
        return {}
    end
    return __TS__ArrayFilter(
        __TS__ArrayMap(
            __TS__StringSplit(value, ","),
            function(____, item) return __TS__StringTrim(item) end
        ),
        function(____, item) return #item > 0 end
    )
end
local function _____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE(rectVarName)
    local rectHandle = require("jass.globals")[rectVarName]
    if rectHandle == nil or rectHandle == 0 then
        return
    end
    do
        local playerId = 0
        while playerId < 8 do
            do
                local fogModifier = CreateFogModifierRect(
                    Player(playerId),
                    FOG_OF_WAR_VISIBLE,
                    rectHandle,
                    true,
                    false
                )
                if fogModifier == nil or fogModifier == 0 then
                    goto __continue10
                end
                FogModifierStart(fogModifier)
            end
            ::__continue10::
            playerId = playerId + 1
        end
    end
end
local function _____6267_884C_957F_8001_4EFB_52A1_7269_54C1_751F_6210(_____53C2_6570)
    local _____957F_8001_5355_4F4D = _____8BFB_53D6_957F_8001_5355_4F4D()
    if _____957F_8001_5355_4F4D == nil or _____957F_8001_5355_4F4D == 0 then
        return
    end
    local ____5206_5272_540D_79F0_5217_8868_5 = _____5206_5272_540D_79F0_5217_8868
    local ____53C2_6570__7269_54C1_540D_5217_8868_4 = _____53C2_6570["物品名列表"]
    if ____53C2_6570__7269_54C1_540D_5217_8868_4 == nil then
        ____53C2_6570__7269_54C1_540D_5217_8868_4 = ""
    end
    local _____7269_54C1_540D_5217_8868 = ____5206_5272_540D_79F0_5217_8868_5(tostring(____53C2_6570__7269_54C1_540D_5217_8868_4))
    local x = GetUnitX(_____957F_8001_5355_4F4D)
    local y = GetUnitY(_____957F_8001_5355_4F4D)
    do
        local i = 0
        while i < #_____7269_54C1_540D_5217_8868 do
            do
                local rawId = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____7269_54C1_540D_5217_8868[i + 1])
                local itemTypeId = stringToFourCCSafe(rawId)
                if not (itemTypeId > 0) then
                    goto __continue15
                end
                CreateItem(itemTypeId, x, y)
            end
            ::__continue15::
            i = i + 1
        end
    end
end
local function _____6267_884C_957F_8001_4EFB_52A1_66F4_65B0(_____53C2_6570)
    _____53D1_9001_5267_60C5_5C0F_5730_56FE_4FE1_53F7({
        X = __TS__Number(_____53C2_6570["小地图X"]) or 0,
        Y = __TS__Number(_____53C2_6570["小地图Y"]) or 0,
        ["持续时间"] = __TS__Number(_____53C2_6570["小地图持续时间"]) or 0
    })
    local ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_7 = _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F
    local ____53C2_6570__4EFB_52A1_66F4_65B0_63D0_793A_6 = _____53C2_6570["任务更新提示"]
    if ____53C2_6570__4EFB_52A1_66F4_65B0_63D0_793A_6 == nil then
        ____53C2_6570__4EFB_52A1_66F4_65B0_63D0_793A_6 = ""
    end
    ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_7({
        ["消息类型"] = bj_QUESTMESSAGE_UPDATED,
        ["文本"] = tostring(____53C2_6570__4EFB_52A1_66F4_65B0_63D0_793A_6)
    })
end
local function _____6267_884C_5730_7CBE_533A_57DF_663E_89C6_91CE(_____53C2_6570)
    local ____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE_9 = _____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE
    local ____53C2_6570__53EF_89C1_533A_57DF1_8 = _____53C2_6570["可见区域1"]
    if ____53C2_6570__53EF_89C1_533A_57DF1_8 == nil then
        ____53C2_6570__53EF_89C1_533A_57DF1_8 = ""
    end
    ____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE_9(tostring(____53C2_6570__53EF_89C1_533A_57DF1_8))
    local ____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE_11 = _____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE
    local ____53C2_6570__53EF_89C1_533A_57DF2_10 = _____53C2_6570["可见区域2"]
    if ____53C2_6570__53EF_89C1_533A_57DF2_10 == nil then
        ____53C2_6570__53EF_89C1_533A_57DF2_10 = ""
    end
    ____5BF9_6240_6709_73A9_5BB6_6DFB_52A0_533A_57DF_89C6_91CE_11(tostring(____53C2_6570__53EF_89C1_533A_57DF2_10))
end
local function _____6267_884C_5730_7CBE_796D_7940Boss_9884_5907(_____53C2_6570)
    local ____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E_23 = _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E
    local ____53C2_6570_Boss_952E_12 = _____53C2_6570["Boss键"]
    if ____53C2_6570_Boss_952E_12 == nil then
        ____53C2_6570_Boss_952E_12 = ""
    end
    local ____tostring_result_15 = tostring(____53C2_6570_Boss_952E_12)
    local ____53C2_6570_Boss_540D_13 = _____53C2_6570["Boss名"]
    if ____53C2_6570_Boss_540D_13 == nil then
        ____53C2_6570_Boss_540D_13 = ""
    end
    local ____tostring_result_16 = tostring(____53C2_6570_Boss_540D_13)
    local ____temp_17 = __TS__Number(_____53C2_6570.X) or 0
    local ____temp_18 = __TS__Number(_____53C2_6570.Y) or 0
    local ____temp_19 = __TS__Number(_____53C2_6570["朝向"]) or 0
    local ____temp_20 = __TS__Number(_____53C2_6570["注册范围"]) or 0
    local ____temp_21 = _____53C2_6570["预创建后暂停"] == true
    local ____temp_22 = _____53C2_6570["预创建后无敌"] == true
    local ____53C2_6570__8303_56F4_89E6_53D1_914D_7F6E_540D_14 = _____53C2_6570["范围触发配置名"]
    if ____53C2_6570__8303_56F4_89E6_53D1_914D_7F6E_540D_14 == nil then
        ____53C2_6570__8303_56F4_89E6_53D1_914D_7F6E_540D_14 = "地精祭祀范围预置触发"
    end
    ____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E_23({
        ["Boss键"] = ____tostring_result_15,
        ["Boss名"] = ____tostring_result_16,
        X = ____temp_17,
        Y = ____temp_18,
        ["朝向"] = ____temp_19,
        ["注册范围"] = ____temp_20,
        ["预创建后暂停"] = ____temp_21,
        ["预创建后无敌"] = ____temp_22,
        ["范围触发配置名"] = tostring(____53C2_6570__8303_56F4_89E6_53D1_914D_7F6E_540D_14),
        ["范围触发剧情片段ID"] = type(_____53C2_6570["范围触发剧情片段ID"]) == "string" and _____53C2_6570["范围触发剧情片段ID"] or nil
    })
end
local function _____6267_884C_957F_8001_5BF9_8BDD_524D_7F6E(_____53C2_6570)
    local _____4E0A_4E0B_6587 = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()
    local _____89E6_53D1_5355_4F4D = _____4E0A_4E0B_6587["触发单位"]
    local _____957F_8001_5355_4F4D = _____8BFB_53D6_957F_8001_5355_4F4D()
    if type(_____53C2_6570["设置剧情进度"]) == "number" then
        _____5199_5165_5267_60C5_8FDB_5EA6(_____53C2_6570["设置剧情进度"])
    end
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 and _____53C2_6570["触发单位发布命令"] ~= nil then
        IssueImmediateOrder(
            _____89E6_53D1_5355_4F4D,
            tostring(_____53C2_6570["触发单位发布命令"])
        )
    end
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 and _____957F_8001_5355_4F4D ~= nil and _____957F_8001_5355_4F4D ~= 0 then
        SetUnitFacingToFaceUnitTimed(
            _____89E6_53D1_5355_4F4D,
            _____957F_8001_5355_4F4D,
            __TS__Number(_____53C2_6570["触发单位转向耗时"]) or 0
        )
    end
    if _____957F_8001_5355_4F4D ~= nil and _____957F_8001_5355_4F4D ~= 0 then
        if type(_____53C2_6570["长老归属玩家"]) == "number" then
            SetUnitOwner(
                _____957F_8001_5355_4F4D,
                Player(_____53C2_6570["长老归属玩家"]),
                true
            )
        end
        if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
            local angle = jass.YDWEAngleBetweenUnits(_____957F_8001_5355_4F4D, _____89E6_53D1_5355_4F4D)
            SetUnitFacingTimed(
                _____957F_8001_5355_4F4D,
                angle,
                __TS__Number(_____53C2_6570["长老转向耗时"]) or 0
            )
        end
    end
end
local function _____6267_884C_8FDC_53E4_6CE2_52A8_5956_52B1(_____53C2_6570)
    local _____4E0A_4E0B_6587 = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()
    if _____4E0A_4E0B_6587["触发单位"] == nil or _____4E0A_4E0B_6587["触发单位"] == 0 then
        return
    end
    local ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_25 = _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F
    local ____53C2_6570__4EFB_52A1_6D88_606F_6A21_677F_24 = _____53C2_6570["任务消息模板"]
    if ____53C2_6570__4EFB_52A1_6D88_606F_6A21_677F_24 == nil then
        ____53C2_6570__4EFB_52A1_6D88_606F_6A21_677F_24 = ""
    end
    ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_25({
        ["消息类型"] = bj_QUESTMESSAGE_ITEMACQUIRED,
        ["文本"] = tostring(____53C2_6570__4EFB_52A1_6D88_606F_6A21_677F_24)
    })
end
local _____4E3B_7EBF_5267_60C5_52A8_4F5C_6CE8_518C_8868 = {
    ["JLC精灵村_长老对话前置"] = _____6267_884C_957F_8001_5BF9_8BDD_524D_7F6E,
    ["JLC精灵村_长老任务物品生成"] = _____6267_884C_957F_8001_4EFB_52A1_7269_54C1_751F_6210,
    ["JLC精灵村_发布地精任务"] = _____6267_884C_957F_8001_4EFB_52A1_66F4_65B0,
    ["JLC精灵村_地精区域显视野"] = _____6267_884C_5730_7CBE_533A_57DF_663E_89C6_91CE,
    ["JLC精灵村_创建地精祭祀Boss预备"] = _____6267_884C_5730_7CBE_796D_7940Boss_9884_5907,
    ["JLC精灵村_远古波动奖励"] = _____6267_884C_8FDC_53E4_6CE2_52A8_5956_52B1
}
____exports["查找主线剧情动作处理器"] = function(_____52A8_4F5CID)
    return _____4E3B_7EBF_5267_60C5_52A8_4F5C_6CE8_518C_8868[_____52A8_4F5CID]
end
____exports["执行主线剧情动作"] = function(_____52A8_4F5CID, _____53C2_6570)
    local handler = ____exports["查找主线剧情动作处理器"](_____52A8_4F5CID)
    if handler == nil then
        return
    end
    handler(_____53C2_6570)
end
return ____exports
