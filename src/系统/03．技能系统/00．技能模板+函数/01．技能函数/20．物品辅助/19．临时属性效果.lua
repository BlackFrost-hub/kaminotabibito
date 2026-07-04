local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____16_FF0E_5C5E_6027_4F4D_79FB_4E0E_6307_4EE4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____4E34_65F6_8C03_6574_653B_51FB = ____16_FF0E_5C5E_6027_4F4D_79FB_4E0E_6307_4EE4["临时调整攻击"]
local _____4E34_65F6_8C03_6574_62A4_7532 = ____16_FF0E_5C5E_6027_4F4D_79FB_4E0E_6307_4EE4["临时调整护甲"]
local _____4E34_65F6_8C03_6574_653B_901F = ____16_FF0E_5C5E_6027_4F4D_79FB_4E0E_6307_4EE4["临时调整攻速"]
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____16_FF0E_5C5E_6027_4F4D_79FB_4E0E_6307_4EE4["调整玩家属性"]
local _____8C03_6574_5355_4F4D_5C5E_6027 = ____16_FF0E_5C5E_6027_4F4D_79FB_4E0E_6307_4EE4["调整单位属性"]
local _____8C03_6574_72B6_6001ID_5C5E_6027 = ____16_FF0E_5C5E_6027_4F4D_79FB_4E0E_6307_4EE4["调整状态ID属性"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local function _____5E94_7528_4E34_65F6_5C5E_6027_6548_679C_9879(_____5355_4F4D, _____9879, _____65B9_5411)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    local _____6570_503C = (_____9879["数值"] or 0) * _____65B9_5411
    if _____6570_503C == 0 then
        return
    end
    if _____9879["类型"] == "攻击" then
        _____4E34_65F6_8C03_6574_653B_51FB(_____5355_4F4D, _____6570_503C)
    elseif _____9879["类型"] == "护甲" then
        _____4E34_65F6_8C03_6574_62A4_7532(_____5355_4F4D, _____6570_503C)
    elseif _____9879["类型"] == "攻速" then
        _____4E34_65F6_8C03_6574_653B_901F(_____5355_4F4D, _____6570_503C)
    elseif _____9879["类型"] == "玩家属性" and _____9879["属性名"] ~= nil then
        _____8C03_6574_73A9_5BB6_5C5E_6027(_____5355_4F4D, _____9879["属性名"], _____6570_503C)
    elseif _____9879["类型"] == "单位属性" and _____9879["属性名"] ~= nil then
        _____8C03_6574_5355_4F4D_5C5E_6027(_____5355_4F4D, _____9879["属性名"], _____6570_503C)
    elseif _____9879["类型"] == "状态ID" and _____9879["属性ID"] ~= nil then
        _____8C03_6574_72B6_6001ID_5C5E_6027(_____5355_4F4D, _____9879["属性ID"], _____6570_503C)
    end
end
____exports["施加临时属性效果"] = function(_____5355_4F4D, _____6301_7EED_6BEB_79D2, _____5C5E_6027_9879, _____9009_9879)
    local _____6FC0_6D3B = _____5355_4F4D ~= nil and _____5355_4F4D ~= 0
    local _____5269_4F59_6B21_6570 = _____9009_9879 and _____9009_9879["次数"]
    if _____6FC0_6D3B then
        do
            local i = 0
            while i < #_____5C5E_6027_9879 do
                _____5E94_7528_4E34_65F6_5C5E_6027_6548_679C_9879(_____5355_4F4D, _____5C5E_6027_9879[i + 1], 1)
                i = i + 1
            end
        end
    end
    local _____5B9E_4F8B
    _____5B9E_4F8B = {
        ["是否激活"] = function()
            return _____6FC0_6D3B
        end,
        ["读取剩余次数"] = function()
            return _____5269_4F59_6B21_6570
        end,
        ["消耗次数"] = function(_____6B21_6570)
            if not _____6FC0_6D3B or _____5269_4F59_6B21_6570 == nil then
                return _____5269_4F59_6B21_6570
            end
            _____5269_4F59_6B21_6570 = _____5269_4F59_6B21_6570 - (_____6B21_6570 or 1)
            if _____5269_4F59_6B21_6570 <= 0 then
                _____5269_4F59_6B21_6570 = 0
                _____5B9E_4F8B["清除"]()
            end
            return _____5269_4F59_6B21_6570
        end,
        ["清除"] = function()
            if not _____6FC0_6D3B then
                return
            end
            _____6FC0_6D3B = false
            do
                local i = #_____5C5E_6027_9879 - 1
                while i >= 0 do
                    _____5E94_7528_4E34_65F6_5C5E_6027_6548_679C_9879(_____5355_4F4D, _____5C5E_6027_9879[i + 1], -1)
                    i = i - 1
                end
            end
            if (_____9009_9879 and _____9009_9879["on清除"]) ~= nil then
                _____9009_9879["on清除"](_____5355_4F4D)
            end
        end
    }
    if _____6301_7EED_6BEB_79D2 > 0 then
        addDelayedCallback(
            _____6301_7EED_6BEB_79D2,
            function()
                _____5B9E_4F8B["清除"]()
            end
        )
    end
    return _____5B9E_4F8B
end
local function _____53D6_5355_4F4D_4E34_65F6_5C5E_6027_6548_679C_952E(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    return GetHandleId(_____5355_4F4D) or 0
end
____exports["创建单位临时属性效果托管器"] = function()
    local _____5B9E_4F8B_8868 = {}
    local function _____6E05_9664(_____5355_4F4D)
        local id = _____53D6_5355_4F4D_4E34_65F6_5C5E_6027_6548_679C_952E(_____5355_4F4D)
        if id == 0 then
            return
        end
        local _____5B9E_4F8B = _____5B9E_4F8B_8868[id]
        if _____5B9E_4F8B == nil then
            return
        end
        __TS__Delete(_____5B9E_4F8B_8868, id)
        _____5B9E_4F8B["清除"]()
    end
    local function _____8BFB_53D6(_____5355_4F4D)
        local id = _____53D6_5355_4F4D_4E34_65F6_5C5E_6027_6548_679C_952E(_____5355_4F4D)
        if id == 0 then
            return nil
        end
        local _____5B9E_4F8B = _____5B9E_4F8B_8868[id]
        return _____5B9E_4F8B ~= nil and _____5B9E_4F8B["是否激活"]() and _____5B9E_4F8B or nil
    end
    local function _____65BD_52A0(_____5355_4F4D, _____6301_7EED_6BEB_79D2, _____5C5E_6027_9879, _____9009_9879)
        local id = _____53D6_5355_4F4D_4E34_65F6_5C5E_6027_6548_679C_952E(_____5355_4F4D)
        if id ~= 0 then
            _____6E05_9664(_____5355_4F4D)
        end
        local _____5F53_524D_5B9E_4F8B = nil
        local _____5B9E_4F8B = ____exports["施加临时属性效果"](
            _____5355_4F4D,
            _____6301_7EED_6BEB_79D2,
            _____5C5E_6027_9879,
            {
                ["次数"] = _____9009_9879 and _____9009_9879["次数"],
                ["on清除"] = function(u)
                    if id ~= 0 and _____5B9E_4F8B_8868[id] == _____5F53_524D_5B9E_4F8B then
                        __TS__Delete(_____5B9E_4F8B_8868, id)
                    end
                    if (_____9009_9879 and _____9009_9879["on清除"]) ~= nil then
                        _____9009_9879["on清除"](u)
                    end
                end
            }
        )
        _____5F53_524D_5B9E_4F8B = _____5B9E_4F8B
        if id ~= 0 and _____5B9E_4F8B["是否激活"]() then
            _____5B9E_4F8B_8868[id] = _____5B9E_4F8B
        end
        return _____5B9E_4F8B
    end
    local function _____6D88_8017_6B21_6570(_____5355_4F4D, _____6B21_6570)
        local _____5B9E_4F8B = _____8BFB_53D6(_____5355_4F4D)
        if _____5B9E_4F8B == nil then
            return nil
        end
        return _____5B9E_4F8B["消耗次数"](_____6B21_6570)
    end
    return {["施加"] = _____65BD_52A0, ["读取"] = _____8BFB_53D6, ["清除"] = _____6E05_9664, ["消耗次数"] = _____6D88_8017_6B21_6570}
end
return ____exports
