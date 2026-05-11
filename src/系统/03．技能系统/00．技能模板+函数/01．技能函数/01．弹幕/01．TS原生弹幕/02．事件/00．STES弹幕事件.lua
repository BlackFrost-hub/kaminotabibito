--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_GetTable = ____require_result_0.STES_GetTable
local ____require_result_1 = require("lib.扩展函数.YDWE函数.04．YDWE_trigger")
local YDLocalExecuteTrigger = ____require_result_1.YDLocalExecuteTrigger
local YDTriggerExecuteTrigger = ____require_result_1.YDTriggerExecuteTrigger
local saveParentIndex = ____require_result_1.saveParentIndex
local ____require_result_2 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local YDLocal5Set = ____require_result_2.YDLocal5Set
local flushYDLocal5ParamPage = ____require_result_2.flushYDLocal5ParamPage
local _indexStack = ____require_result_2._indexStack
local getG_SIndex = ____require_result_2.getG_SIndex
local setG_SIndex = ____require_result_2.setG_SIndex
local setG_LIndex = ____require_result_2.setG_LIndex
local StringHash = jass.StringHash
local LoadInteger = jass.LoadInteger
local LoadTriggerHandle = jass.LoadTriggerHandle
local skey_index = StringHash("index")
local function _____5199_5165_5F39_5E55YDLocal5_53C2_6570(_____5B9E_4F8B, _____8F7D_8377)
    YDLocal5Set("integer", "弹幕ID", _____5B9E_4F8B.id)
    YDLocal5Set("unit", "弹幕单位", _____5B9E_4F8B["弹幕单位"])
    YDLocal5Set("unit", "来源单位", _____5B9E_4F8B["参数"]["所有者"])
    local ____YDLocal5Set_4 = YDLocal5Set
    local ____8F7D_8377__76EE_6807_5355_4F4D_3 = _____8F7D_8377["目标单位"]
    if ____8F7D_8377__76EE_6807_5355_4F4D_3 == nil then
        ____8F7D_8377__76EE_6807_5355_4F4D_3 = nil
    end
    ____YDLocal5Set_4("unit", "目标单位", ____8F7D_8377__76EE_6807_5355_4F4D_3)
    local ____YDLocal5Set_6 = YDLocal5Set
    local ____8F7D_8377__6765_6E90_5355_4F4D_5 = _____8F7D_8377["来源单位"]
    if ____8F7D_8377__6765_6E90_5355_4F4D_5 == nil then
        ____8F7D_8377__6765_6E90_5355_4F4D_5 = nil
    end
    ____YDLocal5Set_6("unit", "阻挡来源单位", ____8F7D_8377__6765_6E90_5355_4F4D_5)
    YDLocal5Set("real", "伤害值", _____8F7D_8377["伤害值"] or _____5B9E_4F8B["当前伤害值"])
    YDLocal5Set("real", "剩余生命", _____5B9E_4F8B["剩余生命"])
    YDLocal5Set("string", "结束原因", _____8F7D_8377["结束原因"] or "")
end
____exports["触发原生弹幕STES事件"] = function(_____4E8B_4EF6_540D, _____5B9E_4F8B, _____8F7D_8377)
    if _____8F7D_8377 == nil then
        _____8F7D_8377 = {}
    end
    if _____4E8B_4EF6_540D == nil or _____4E8B_4EF6_540D == "" then
        return
    end
    local ht = STES_GetTable(nil)
    if ht == nil or ht == 0 then
        return
    end
    local hash = StringHash(_____4E8B_4EF6_540D)
    local count = LoadInteger(ht, hash, skey_index)
    if count <= 0 then
        return
    end
    _indexStack[#_indexStack + 1] = getG_SIndex()
    do
        local i = 0
        while i < count do
            local trg = LoadTriggerHandle(ht, hash, i)
            if trg ~= nil and trg ~= 0 then
                YDLocalExecuteTrigger(trg)
                saveParentIndex(trg)
                _____5199_5165_5F39_5E55YDLocal5_53C2_6570(_____5B9E_4F8B, _____8F7D_8377)
                YDTriggerExecuteTrigger(trg, false)
                flushYDLocal5ParamPage()
            end
            i = i + 1
        end
    end
    local prevIndex = #_indexStack > 0 and table.remove(_indexStack) or 0
    setG_SIndex(prevIndex)
    setG_LIndex(prevIndex)
end
return ____exports
