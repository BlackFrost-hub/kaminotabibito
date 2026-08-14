local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local __TS__ParseInt = ____lualib.__TS__ParseInt
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local centerTimer = require("系统.00．核心系统.05．中心计时器")
local ydweModule = require("lib.扩展函数.YDWE函数.index")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local fourCCToString = ____require_result_0.fourCCToString
____exports.ObjectType = ydweModule.ObjectType
local rawYDWEGetItemDataString = ydweModule.YDWEGetItemDataString
local rawGetObjectProperty = ydweModule.getObjectProperty
local _____6DFB_52A0_5468_671F_56DE_8C03 = centerTimer.addPeriodicCallback
local _____53D6_670D_52A1_5668_65F6_95F4 = centerTimer.getServerTime
local GetHandleId = jass.GetHandleId
local _____7269_54C1_63D0_793A_7F13_5B58_8FC7_671F_6BEB_79D2 = 300000
local _____7269_54C1_63D0_793A_7F13_5B58_6E05_7406_95F4_9694_6BEB_79D2 = 5000
local function _____53D6_7269_7F16_67E5_8BE2ID(objectType, objectId)
    if objectType == ____exports.ObjectType.ITEM and type(objectId) == "number" then
        return fourCCToString(objectId)
    end
    return objectId
end
local _____7269_7F16_5B57_7B26_4E32_7F13_5B58 = {}
local _____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58 = {}
local _____7269_7F16_5B57_7B26_4E32_7F13_5B58_8BBF_95EE_65F6_95F4 = {}
local _____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58_8BBF_95EE_65F6_95F4 = {}
local _____7269_7F16_5B57_7B26_4E32_7F13_5B58_952E_5217_8868 = {}
local _____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58_952E_5217_8868 = {}
local _____7269_54C1_63D0_793A_7F13_5B58_6E05_7406TickID = 0
local function _____53D6_7269_7F16_7F13_5B58_952E(objectType, objectId, property)
    return (((tostring(objectType) .. ":") .. tostring(objectId)) .. ":") .. property
end
local function _____53D6_7269_54C1_6570_636E_7F13_5B58_952E(itemKey, dataType)
    return (tostring(itemKey) .. ":") .. tostring(dataType)
end
____exports["清空物品提示读取缓存"] = function()
    _____7269_7F16_5B57_7B26_4E32_7F13_5B58 = {}
    _____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58 = {}
    _____7269_7F16_5B57_7B26_4E32_7F13_5B58_8BBF_95EE_65F6_95F4 = {}
    _____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58_8BBF_95EE_65F6_95F4 = {}
    _____7269_7F16_5B57_7B26_4E32_7F13_5B58_952E_5217_8868 = {}
    _____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58_952E_5217_8868 = {}
end
local function _____8BB0_5F55_7269_7F16_7F13_5B58_8BBF_95EE(_____7F13_5B58_952E)
    if _____7269_7F16_5B57_7B26_4E32_7F13_5B58_8BBF_95EE_65F6_95F4[_____7F13_5B58_952E] == nil then
        _____7269_7F16_5B57_7B26_4E32_7F13_5B58_952E_5217_8868[#_____7269_7F16_5B57_7B26_4E32_7F13_5B58_952E_5217_8868 + 1] = _____7F13_5B58_952E
    end
    _____7269_7F16_5B57_7B26_4E32_7F13_5B58_8BBF_95EE_65F6_95F4[_____7F13_5B58_952E] = _____53D6_670D_52A1_5668_65F6_95F4()
end
local function _____8BB0_5F55_7269_54C1_6570_636E_7F13_5B58_8BBF_95EE(_____7F13_5B58_952E)
    if _____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58_8BBF_95EE_65F6_95F4[_____7F13_5B58_952E] == nil then
        _____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58_952E_5217_8868[#_____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58_952E_5217_8868 + 1] = _____7F13_5B58_952E
    end
    _____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58_8BBF_95EE_65F6_95F4[_____7F13_5B58_952E] = _____53D6_670D_52A1_5668_65F6_95F4()
end
local function _____6E05_7406_7269_7F16_8FC7_671F_7F13_5B58(_____5F53_524D_65F6_95F4)
    local writeIndex = 0
    do
        local i = 0
        while i < #_____7269_7F16_5B57_7B26_4E32_7F13_5B58_952E_5217_8868 do
            local _____7F13_5B58_952E = _____7269_7F16_5B57_7B26_4E32_7F13_5B58_952E_5217_8868[i + 1]
            local _____6700_540E_8BBF_95EE = _____7269_7F16_5B57_7B26_4E32_7F13_5B58_8BBF_95EE_65F6_95F4[_____7F13_5B58_952E]
            if _____6700_540E_8BBF_95EE ~= nil and _____5F53_524D_65F6_95F4 - _____6700_540E_8BBF_95EE < _____7269_54C1_63D0_793A_7F13_5B58_8FC7_671F_6BEB_79D2 then
                _____7269_7F16_5B57_7B26_4E32_7F13_5B58_952E_5217_8868[writeIndex + 1] = _____7F13_5B58_952E
                writeIndex = writeIndex + 1
            else
                __TS__Delete(_____7269_7F16_5B57_7B26_4E32_7F13_5B58, _____7F13_5B58_952E)
                __TS__Delete(_____7269_7F16_5B57_7B26_4E32_7F13_5B58_8BBF_95EE_65F6_95F4, _____7F13_5B58_952E)
            end
            i = i + 1
        end
    end
    __TS__ArraySetLength(_____7269_7F16_5B57_7B26_4E32_7F13_5B58_952E_5217_8868, writeIndex)
end
local function _____6E05_7406_7269_54C1_6570_636E_8FC7_671F_7F13_5B58(_____5F53_524D_65F6_95F4)
    local writeIndex = 0
    do
        local i = 0
        while i < #_____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58_952E_5217_8868 do
            local _____7F13_5B58_952E = _____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58_952E_5217_8868[i + 1]
            local _____6700_540E_8BBF_95EE = _____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58_8BBF_95EE_65F6_95F4[_____7F13_5B58_952E]
            if _____6700_540E_8BBF_95EE ~= nil and _____5F53_524D_65F6_95F4 - _____6700_540E_8BBF_95EE < _____7269_54C1_63D0_793A_7F13_5B58_8FC7_671F_6BEB_79D2 then
                _____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58_952E_5217_8868[writeIndex + 1] = _____7F13_5B58_952E
                writeIndex = writeIndex + 1
            else
                __TS__Delete(_____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58, _____7F13_5B58_952E)
                __TS__Delete(_____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58_8BBF_95EE_65F6_95F4, _____7F13_5B58_952E)
            end
            i = i + 1
        end
    end
    __TS__ArraySetLength(_____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58_952E_5217_8868, writeIndex)
end
local function _____6267_884C_7269_54C1_63D0_793A_7F13_5B58_8FC7_671F_6E05_7406()
    local _____5F53_524D_65F6_95F4 = _____53D6_670D_52A1_5668_65F6_95F4()
    _____6E05_7406_7269_7F16_8FC7_671F_7F13_5B58(_____5F53_524D_65F6_95F4)
    _____6E05_7406_7269_54C1_6570_636E_8FC7_671F_7F13_5B58(_____5F53_524D_65F6_95F4)
end
____exports["确保物品提示缓存清理Tick"] = function()
    if _____7269_54C1_63D0_793A_7F13_5B58_6E05_7406TickID ~= 0 then
        return
    end
    _____7269_54C1_63D0_793A_7F13_5B58_6E05_7406TickID = _____6DFB_52A0_5468_671F_56DE_8C03(_____7269_54C1_63D0_793A_7F13_5B58_6E05_7406_95F4_9694_6BEB_79D2, _____6267_884C_7269_54C1_63D0_793A_7F13_5B58_8FC7_671F_6E05_7406)
end
local _____5F85_8BFB_7269_7F16_7C7B_578B = 0
local _____5F85_8BFB_7269_7F16ID = 0
local _____5F85_8BFB_7269_7F16_5C5E_6027 = ""
local _____8BFB_53D6_7269_7F16_7ED3_679C = ""
local function _____6267_884C_8BFB_53D6_7269_7F16_5B57_7B26_4E32(self)
    _____8BFB_53D6_7269_7F16_7ED3_679C = rawGetObjectProperty(nil, _____5F85_8BFB_7269_7F16_7C7B_578B, _____5F85_8BFB_7269_7F16ID, _____5F85_8BFB_7269_7F16_5C5E_6027) or ""
end
____exports["安全取物编字符串"] = function(objectType, objectId, property)
    local _____67E5_8BE2ID = _____53D6_7269_7F16_67E5_8BE2ID(objectType, objectId)
    local _____7F13_5B58_952E = _____53D6_7269_7F16_7F13_5B58_952E(objectType, _____67E5_8BE2ID, property)
    local _____5DF2_7F13_5B58 = _____7269_7F16_5B57_7B26_4E32_7F13_5B58[_____7F13_5B58_952E]
    if _____5DF2_7F13_5B58 ~= nil then
        _____8BB0_5F55_7269_7F16_7F13_5B58_8BBF_95EE(_____7F13_5B58_952E)
        return _____5DF2_7F13_5B58
    end
    _____5F85_8BFB_7269_7F16_7C7B_578B = objectType
    _____5F85_8BFB_7269_7F16ID = _____67E5_8BE2ID
    _____5F85_8BFB_7269_7F16_5C5E_6027 = property
    _____8BFB_53D6_7269_7F16_7ED3_679C = ""
    local ok = pcall(_____6267_884C_8BFB_53D6_7269_7F16_5B57_7B26_4E32)
    if ok == true then
        local _____7ED3_679C = _____8BFB_53D6_7269_7F16_7ED3_679C or ""
        _____7269_7F16_5B57_7B26_4E32_7F13_5B58[_____7F13_5B58_952E] = _____7ED3_679C
        _____8BB0_5F55_7269_7F16_7F13_5B58_8BBF_95EE(_____7F13_5B58_952E)
        return _____7ED3_679C
    end
    return ""
end
____exports["安全取物编整数"] = function(objectType, objectId, property)
    local value = __TS__ParseInt(____exports["安全取物编字符串"](objectType, objectId, property))
    return value or 0
end
local _____5F85_8BFB_7269_54C1_6570_636EID = 0
local _____5F85_8BFB_7269_54C1_6570_636E_7C7B_578B = 0
local _____8BFB_53D6_7269_54C1_6570_636E_7ED3_679C = ""
local function _____6267_884C_8BFB_53D6_7269_54C1_6570_636E_5B57_7B26_4E32(self)
    _____8BFB_53D6_7269_54C1_6570_636E_7ED3_679C = rawYDWEGetItemDataString(nil, _____5F85_8BFB_7269_54C1_6570_636EID, _____5F85_8BFB_7269_54C1_6570_636E_7C7B_578B) or ""
end
local function _____5B89_5168_53D6_7269_54C1_6570_636E_5B57_7B26_4E32(itemTypeId, dataType, _____7F13_5B58_7269_54C1_952E)
    local _____7F13_5B58_952E = _____53D6_7269_54C1_6570_636E_7F13_5B58_952E(
        _____7F13_5B58_7269_54C1_952E or "type:" .. tostring(itemTypeId),
        dataType
    )
    local _____5DF2_7F13_5B58 = _____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58[_____7F13_5B58_952E]
    if _____5DF2_7F13_5B58 ~= nil and _____5DF2_7F13_5B58 ~= "" then
        _____8BB0_5F55_7269_54C1_6570_636E_7F13_5B58_8BBF_95EE(_____7F13_5B58_952E)
        return _____5DF2_7F13_5B58
    end
    _____5F85_8BFB_7269_54C1_6570_636EID = itemTypeId
    _____5F85_8BFB_7269_54C1_6570_636E_7C7B_578B = dataType
    _____8BFB_53D6_7269_54C1_6570_636E_7ED3_679C = ""
    local ok = pcall(_____6267_884C_8BFB_53D6_7269_54C1_6570_636E_5B57_7B26_4E32)
    if ok == true then
        local _____7ED3_679C = _____8BFB_53D6_7269_54C1_6570_636E_7ED3_679C or ""
        if _____7ED3_679C ~= "" then
            _____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58[_____7F13_5B58_952E] = _____7ED3_679C
            _____8BB0_5F55_7269_54C1_6570_636E_7F13_5B58_8BBF_95EE(_____7F13_5B58_952E)
        end
        return _____7ED3_679C
    end
    return ""
end
____exports["安全取物品实例数据字符串"] = function(item, itemTypeId, dataType)
    if item == nil or item == 0 then
        return _____5B89_5168_53D6_7269_54C1_6570_636E_5B57_7B26_4E32(itemTypeId, dataType)
    end
    local _____5B9E_4F8B_7F13_5B58_952E = _____53D6_7269_54C1_6570_636E_7F13_5B58_952E(
        GetHandleId(item),
        dataType
    )
    local _____5DF2_7F13_5B58 = _____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58[_____5B9E_4F8B_7F13_5B58_952E]
    if _____5DF2_7F13_5B58 ~= nil and _____5DF2_7F13_5B58 ~= "" then
        _____8BB0_5F55_7269_54C1_6570_636E_7F13_5B58_8BBF_95EE(_____5B9E_4F8B_7F13_5B58_952E)
        return _____5DF2_7F13_5B58
    end
    local _____7C7B_578B_7269_904D_6587_672C = _____5B89_5168_53D6_7269_54C1_6570_636E_5B57_7B26_4E32(itemTypeId, dataType)
    if _____7C7B_578B_7269_904D_6587_672C ~= "" then
        _____7269_54C1_6570_636E_5B57_7B26_4E32_7F13_5B58[_____5B9E_4F8B_7F13_5B58_952E] = _____7C7B_578B_7269_904D_6587_672C
        _____8BB0_5F55_7269_54C1_6570_636E_7F13_5B58_8BBF_95EE(_____5B9E_4F8B_7F13_5B58_952E)
    end
    return _____7C7B_578B_7269_904D_6587_672C
end
return ____exports
