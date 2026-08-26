--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_9636_6BB5_4E0A_4E0B_6587 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.01．阶段上下文")
local _____521B_5EFA_9636_6BB5_4E0A_4E0B_6587 = ____01_FF0E_9636_6BB5_4E0A_4E0B_6587["创建阶段上下文"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.06．机制清理.01．机制清理篮子")
local _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50 = ____require_result_0["创建机制清理篮子"]
local function _____521B_5EFA_7A7A_8584Boss_9636_6BB5_7F16_6392(_____5355_4F4D)
    local _____7A7A_7F16_6392 = {}
    _____7A7A_7F16_6392["单位"] = _____5355_4F4D
    _____7A7A_7F16_6392["取当前阶段ID"] = function()
        return ""
    end
    _____7A7A_7F16_6392["是阶段"] = function(______9636_6BB5ID)
        return false
    end
    _____7A7A_7F16_6392["手动进入阶段"] = function(______9636_6BB5ID, ______5F53_524D_767E_5206_6BD4)
        return false
    end
    _____7A7A_7F16_6392["生成阶段允许函数"] = function(______6280_80FD_952E)
        return function()
            return false
        end
    end
    _____7A7A_7F16_6392["取阶段清理篮子"] = function(______9636_6BB5ID)
        return nil
    end
    _____7A7A_7F16_6392["销毁"] = function()
    end
    return _____7A7A_7F16_6392
end
local function _____8F6C_6362_9636_6BB5_5B9A_4E49(_____9636_6BB5, _____6267_884C_8FDB_5165)
    return {
        ID = _____9636_6BB5.ID,
        ["血量百分比"] = _____9636_6BB5["血量百分比"],
        ["on进入"] = function(_c, ______767E_5206_6BD4)
            _____6267_884C_8FDB_5165(_____9636_6BB5)
        end
    }
end
____exports["创建薄Boss阶段编排"] = function(_____53C2_6570)
    local _____4E0A_4E0B_6587
    if _____53C2_6570 == nil or _____53C2_6570["单位"] == nil or _____53C2_6570["单位"] == 0 or _____53C2_6570["阶段列表"] == nil or #_____53C2_6570["阶段列表"] <= 0 then
        local ____521B_5EFA_7A7A_8584Boss_9636_6BB5_7F16_6392_2 = _____521B_5EFA_7A7A_8584Boss_9636_6BB5_7F16_6392
        local ____temp_1
        if _____53C2_6570 ~= nil then
            ____temp_1 = _____53C2_6570["单位"]
        else
            ____temp_1 = nil
        end
        return ____521B_5EFA_7A7A_8584Boss_9636_6BB5_7F16_6392_2(____temp_1)
    end
    local _____9636_6BB5_8868 = {}
    local _____7BEE_5B50_8868 = {}
    local _____9636_6BB5_6280_80FD_6C60_8868 = {}
    local _____5DF2_9500_6BC1 = false
    local _____6B63_5728_9500_6BC1 = false
    local _____5F85_9500_6BC1 = false
    local _____5F53_524D_5DF2_8FDB_5165_9636_6BB5ID = _____53C2_6570["初始阶段ID"]
    local _____6B63_5728_79BB_5F00_9636_6BB5 = false
    local _____521D_59CB_9636_6BB5_5B58_5728 = false
    do
        local i = 0
        while i < #_____53C2_6570["阶段列表"] do
            local _____9636_6BB5 = _____53C2_6570["阶段列表"][i + 1]
            if _____9636_6BB5 == nil or _____9636_6BB5.ID == nil or _____9636_6BB5.ID == "" or _____9636_6BB5_8868[_____9636_6BB5.ID] ~= nil then
                return _____521B_5EFA_7A7A_8584Boss_9636_6BB5_7F16_6392(_____53C2_6570["单位"])
            end
            _____9636_6BB5_8868[_____9636_6BB5.ID] = _____9636_6BB5
            if _____9636_6BB5.ID == _____53C2_6570["初始阶段ID"] then
                _____521D_59CB_9636_6BB5_5B58_5728 = true
            end
            _____7BEE_5B50_8868[_____9636_6BB5.ID] = _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50((_____53C2_6570["名称"] .. "-阶段-") .. _____9636_6BB5.ID)
            if _____9636_6BB5["技能池"] ~= nil then
                local _____6C60 = {}
                do
                    local j = 0
                    while j < #_____9636_6BB5["技能池"] do
                        _____6C60[#_____6C60 + 1] = _____9636_6BB5["技能池"][j + 1]
                        j = j + 1
                    end
                end
                _____9636_6BB5_6280_80FD_6C60_8868[_____9636_6BB5.ID] = _____6C60
            end
            i = i + 1
        end
    end
    if not _____521D_59CB_9636_6BB5_5B58_5728 then
        return _____521B_5EFA_7A7A_8584Boss_9636_6BB5_7F16_6392(_____53C2_6570["单位"])
    end
    local _____7F16_6392 = {}
    local function _____6267_884C_9636_6BB5_8FDB_5165(_____9636_6BB5)
        if _____5DF2_9500_6BC1 then
            return
        end
        _____5F53_524D_5DF2_8FDB_5165_9636_6BB5ID = _____9636_6BB5.ID
        if _____9636_6BB5["on进入"] ~= nil then
            _____9636_6BB5["on进入"](_____7F16_6392)
        end
    end
    local function _____6267_884C_9636_6BB5_79BB_5F00(_____9636_6BB5ID)
        if _____9636_6BB5ID == "" then
            return
        end
        local _____9636_6BB5 = _____9636_6BB5_8868[_____9636_6BB5ID]
        _____6B63_5728_79BB_5F00_9636_6BB5 = true
        if _____9636_6BB5 ~= nil and _____9636_6BB5["on离开"] ~= nil then
            _____9636_6BB5["on离开"](_____7F16_6392)
        end
        _____6B63_5728_79BB_5F00_9636_6BB5 = false
        if _____5F53_524D_5DF2_8FDB_5165_9636_6BB5ID == _____9636_6BB5ID then
            _____5F53_524D_5DF2_8FDB_5165_9636_6BB5ID = ""
        end
    end
    local function _____5B8C_6210_9500_6BC1()
        if _____5DF2_9500_6BC1 then
            return
        end
        _____5DF2_9500_6BC1 = true
        _____5F85_9500_6BC1 = false
        for ID in pairs(_____7BEE_5B50_8868) do
            local _____7BEE_5B50 = _____7BEE_5B50_8868[ID]
            if _____7BEE_5B50 ~= nil then
                _____7BEE_5B50["清理全部"](_____7BEE_5B50)
            end
        end
        _____4E0A_4E0B_6587["销毁"](_____4E0A_4E0B_6587)
        _____6B63_5728_9500_6BC1 = false
    end
    local function _____9636_6BB5_952E_5141_8BB8(_____9636_6BB5ID, _____6280_80FD_952E)
        local _____6C60 = _____9636_6BB5_6280_80FD_6C60_8868[_____9636_6BB5ID]
        if _____6C60 == nil then
            return true
        end
        do
            local i = 0
            while i < #_____6C60 do
                if _____6C60[i + 1] == _____6280_80FD_952E then
                    return true
                end
                i = i + 1
            end
        end
        return false
    end
    local _____9636_6BB5_4E0A_4E0B_6587_5217_8868 = {}
    do
        local i = 0
        while i < #_____53C2_6570["阶段列表"] do
            _____9636_6BB5_4E0A_4E0B_6587_5217_8868[#_____9636_6BB5_4E0A_4E0B_6587_5217_8868 + 1] = _____8F6C_6362_9636_6BB5_5B9A_4E49(_____53C2_6570["阶段列表"][i + 1], _____6267_884C_9636_6BB5_8FDB_5165)
            i = i + 1
        end
    end
    _____4E0A_4E0B_6587 = _____521B_5EFA_9636_6BB5_4E0A_4E0B_6587({
        ["名称"] = _____53C2_6570["名称"],
        ["单位"] = _____53C2_6570["单位"],
        ["初始阶段ID"] = _____53C2_6570["初始阶段ID"],
        ["Tick间隔毫秒"] = _____53C2_6570["Tick间隔毫秒"],
        ["阶段列表"] = _____9636_6BB5_4E0A_4E0B_6587_5217_8868,
        ["on阶段变化"] = function(_____65B0_9636_6BB5ID, _____65E7_9636_6BB5ID, ______767E_5206_6BD4)
            _____6267_884C_9636_6BB5_79BB_5F00(_____65E7_9636_6BB5ID)
            if _____5F85_9500_6BC1 or _____5DF2_9500_6BC1 then
                _____5B8C_6210_9500_6BC1()
                return
            end
            local _____65E7_7BEE_5B50 = _____7BEE_5B50_8868[_____65E7_9636_6BB5ID]
            if _____65E7_7BEE_5B50 ~= nil then
                _____65E7_7BEE_5B50["清理全部"](_____65E7_7BEE_5B50)
            end
            if _____5F85_9500_6BC1 or _____5DF2_9500_6BC1 then
                _____5B8C_6210_9500_6BC1()
                return
            end
            local _____65B0_7BEE_5B50 = _____7BEE_5B50_8868[_____65B0_9636_6BB5ID]
            if _____65B0_7BEE_5B50 == nil or _____65B0_7BEE_5B50["已清理"](_____65B0_7BEE_5B50) then
                _____7BEE_5B50_8868[_____65B0_9636_6BB5ID] = _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50((_____53C2_6570["名称"] .. "-阶段-") .. _____65B0_9636_6BB5ID)
            end
        end
    })
    _____7F16_6392["单位"] = _____53C2_6570["单位"]
    _____7F16_6392["取当前阶段ID"] = function()
        return _____5DF2_9500_6BC1 and "" or _____5F53_524D_5DF2_8FDB_5165_9636_6BB5ID
    end
    _____7F16_6392["是阶段"] = function(_____9636_6BB5ID)
        return not _____5DF2_9500_6BC1 and _____5F53_524D_5DF2_8FDB_5165_9636_6BB5ID == _____9636_6BB5ID
    end
    _____7F16_6392["手动进入阶段"] = function(_____9636_6BB5ID, _____5F53_524D_767E_5206_6BD4)
        if _____5DF2_9500_6BC1 or _____6B63_5728_9500_6BC1 or _____5F85_9500_6BC1 then
            return false
        end
        return _____4E0A_4E0B_6587["手动进入阶段"](_____4E0A_4E0B_6587, _____9636_6BB5ID, _____5F53_524D_767E_5206_6BD4 or 1)
    end
    _____7F16_6392["生成阶段允许函数"] = function(_____6280_80FD_952E)
        return function()
            if _____5DF2_9500_6BC1 then
                return false
            end
            return _____9636_6BB5_952E_5141_8BB8(_____5F53_524D_5DF2_8FDB_5165_9636_6BB5ID, _____6280_80FD_952E)
        end
    end
    _____7F16_6392["取阶段清理篮子"] = function(_____9636_6BB5ID)
        if _____5DF2_9500_6BC1 then
            return nil
        end
        return _____7BEE_5B50_8868[_____9636_6BB5ID] or nil
    end
    _____7F16_6392["销毁"] = function()
        if _____5DF2_9500_6BC1 then
            return
        end
        if _____6B63_5728_9500_6BC1 then
            _____5F85_9500_6BC1 = true
            return
        end
        _____6B63_5728_9500_6BC1 = true
        local _____5F53_524DID = _____5F53_524D_5DF2_8FDB_5165_9636_6BB5ID
        if not _____6B63_5728_79BB_5F00_9636_6BB5 then
            _____6267_884C_9636_6BB5_79BB_5F00(_____5F53_524DID)
        else
            _____5F53_524D_5DF2_8FDB_5165_9636_6BB5ID = ""
        end
        _____5B8C_6210_9500_6BC1()
    end
    if _____53C2_6570["清理篮子"] ~= nil then
        local ____self_3 = _____53C2_6570["清理篮子"]
        ____self_3["登记清理"](
            ____self_3,
            _____53C2_6570["名称"] .. "-薄阶段编排",
            function()
                _____7F16_6392["销毁"]()
            end
        )
    end
    local _____521D_59CB_9636_6BB5 = _____9636_6BB5_8868[_____53C2_6570["初始阶段ID"]]
    if _____521D_59CB_9636_6BB5 ~= nil then
        _____6267_884C_9636_6BB5_8FDB_5165(_____521D_59CB_9636_6BB5)
    end
    return _____7F16_6392
end
--- 便捷：为战斗技能定义生成阶段允许（技能键绑定）
____exports["为技能生成阶段允许"] = function(_____7F16_6392, _____6280_80FD_952E)
    return _____7F16_6392["生成阶段允许函数"](_____6280_80FD_952E)
end
return ____exports
