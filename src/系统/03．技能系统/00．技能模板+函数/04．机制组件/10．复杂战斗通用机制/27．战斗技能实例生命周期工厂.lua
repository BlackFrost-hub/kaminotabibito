local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.06．机制清理.01．机制清理篮子")
local _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50 = ____require_result_0["创建机制清理篮子"]
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
local _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_1["结束独立技能伤害实例"]
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_2.registerDeathListener
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local getGameTime = ____require_result_3.getGameTime
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____require_result_4["单位存活"]
local _____53D6_5355_4F4DID = ____require_result_4["取单位ID"]
local _____5355_4F4D_4E0A_4E0B_6587_8868 = {}
local _____5B9E_4F8B_7D22_5F15_8868 = {}
local _____4E0B_4E00_5B9E_4F8BID = 1
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____53D6_6216_5EFA_5355_4F4D_6280_80FD_8868(_____5355_4F4DID)
    local _____8868 = _____5355_4F4D_4E0A_4E0B_6587_8868[_____5355_4F4DID]
    if _____8868 == nil then
        _____8868 = {["技能表"] = {}, ["代次表"] = {}}
        _____5355_4F4D_4E0A_4E0B_6587_8868[_____5355_4F4DID] = _____8868
    end
    return _____8868
end
local function _____6458_9664_5B9E_4F8B(_____63A7_5236_5668)
    __TS__Delete(_____5B9E_4F8B_7D22_5F15_8868, _____63A7_5236_5668["实例ID"])
    local _____65BD_6CD5_8005ID = _____53D6_5355_4F4DID(_____63A7_5236_5668["施法者"])
    local _____8868 = _____5355_4F4D_4E0A_4E0B_6587_8868[_____65BD_6CD5_8005ID]
    if _____8868 == nil then
        return
    end
    local _____5217_8868 = _____8868["技能表"][_____63A7_5236_5668["技能键"]]
    if _____5217_8868 == nil then
        return
    end
    local idx = __TS__ArrayIndexOf(_____5217_8868, _____63A7_5236_5668)
    if idx >= 0 then
        __TS__ArraySplice(_____5217_8868, idx, 1)
    end
    if #_____5217_8868 <= 0 then
        __TS__Delete(_____8868["技能表"], _____63A7_5236_5668["技能键"])
    end
    local _____6280_80FD_6570_91CF = 0
    for _____952E in pairs(_____8868["技能表"]) do
        if _____8868["技能表"][_____952E] ~= nil then
            _____6280_80FD_6570_91CF = _____6280_80FD_6570_91CF + 1
        end
    end
    if _____6280_80FD_6570_91CF <= 0 then
        __TS__Delete(_____5355_4F4D_4E0A_4E0B_6587_8868, _____65BD_6CD5_8005ID)
    end
end
local function _____786E_4FDD_6B7B_4EA1_76D1_542C()
    if _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
    registerDeathListener(function(dyingUnit, _killingUnit)
        local _____6B7B_4EA1ID = _____53D6_5355_4F4DID(dyingUnit)
        local _____8868 = _____5355_4F4D_4E0A_4E0B_6587_8868[_____6B7B_4EA1ID]
        if _____8868 ~= nil then
            local _____5FEB_7167 = {}
            for _____952E in pairs(_____8868["技能表"]) do
                do
                    local _____5217_8868 = _____8868["技能表"][_____952E]
                    if _____5217_8868 == nil then
                        goto __continue17
                    end
                    do
                        local i = 0
                        while i < #_____5217_8868 do
                            _____5FEB_7167[#_____5FEB_7167 + 1] = _____5217_8868[i + 1]
                            i = i + 1
                        end
                    end
                end
                ::__continue17::
            end
            do
                local i = 0
                while i < #_____5FEB_7167 do
                    _____5FEB_7167[i + 1]["结束"]("施法者死亡")
                    i = i + 1
                end
            end
            __TS__Delete(_____5355_4F4D_4E0A_4E0B_6587_8868, _____6B7B_4EA1ID)
        end
        local _____76EE_6807_547D_4E2D = {}
        for _____5355_4F4DID in pairs(_____5B9E_4F8B_7D22_5F15_8868) do
            do
                local _____63A7_5236_5668 = _____5B9E_4F8B_7D22_5F15_8868[_____5355_4F4DID]
                if _____63A7_5236_5668 == nil then
                    goto __continue24
                end
                if _____63A7_5236_5668["目标"] ~= nil and _____53D6_5355_4F4DID(_____63A7_5236_5668["目标"]) == _____6B7B_4EA1ID then
                    _____76EE_6807_547D_4E2D[#_____76EE_6807_547D_4E2D + 1] = _____63A7_5236_5668
                end
            end
            ::__continue24::
        end
        do
            local i = 0
            while i < #_____76EE_6807_547D_4E2D do
                _____76EE_6807_547D_4E2D[i + 1]["结束"]("目标死亡")
                i = i + 1
            end
        end
    end)
end
____exports["创建战斗技能实例"] = function(_____53C2_6570)
    _____786E_4FDD_6B7B_4EA1_76D1_542C()
    local ____4E0B_4E00_5B9E_4F8BID_5 = _____4E0B_4E00_5B9E_4F8BID
    _____4E0B_4E00_5B9E_4F8BID = ____4E0B_4E00_5B9E_4F8BID_5 + 1
    local _____5B9E_4F8BID = ____4E0B_4E00_5B9E_4F8BID_5
    local _____65BD_6CD5_8005ID = _____53D6_5355_4F4DID(_____53C2_6570["施法者"])
    local _____8868 = _____53D6_6216_5EFA_5355_4F4D_6280_80FD_8868(_____65BD_6CD5_8005ID)
    local _____4EE3_6B21 = (_____8868["代次表"][_____53C2_6570["技能键"]] or 0) + 1
    _____8868["代次表"][_____53C2_6570["技能键"]] = _____4EE3_6B21
    local _____76EE_6807_53E5_67C4ID = _____53C2_6570["目标"] ~= nil and _____53D6_5355_4F4DID(_____53C2_6570["目标"]) or 0
    local _____521B_5EFA_65F6_95F4 = getGameTime()
    local _____7BEE_5B50 = _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50((("战斗技能实例-" .. _____53C2_6570["技能键"]) .. "-") .. tostring(_____5B9E_4F8BID))
    local _____7ED3_675F_539F_56E0 = nil
    local _____63A7_5236_5668 = {}
    local function _____6536_675F(_____539F_56E0)
        if _____7ED3_675F_539F_56E0 ~= nil then
            return false
        end
        _____7ED3_675F_539F_56E0 = _____539F_56E0
        _____63A7_5236_5668["结束原因"] = _____539F_56E0
        _____7BEE_5B50["清理全部"](_____7BEE_5B50)
        if _____53C2_6570["技能实例ID"] ~= nil then
            _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(_____53C2_6570["技能实例ID"])
        end
        _____6458_9664_5B9E_4F8B(_____63A7_5236_5668)
        if _____53C2_6570["结束回调"] ~= nil then
            _____53C2_6570["结束回调"](_____539F_56E0, _____63A7_5236_5668)
        end
        return true
    end
    _____63A7_5236_5668["实例ID"] = _____5B9E_4F8BID
    _____63A7_5236_5668["代次"] = _____4EE3_6B21
    _____63A7_5236_5668["技能键"] = _____53C2_6570["技能键"]
    _____63A7_5236_5668["施法者"] = _____53C2_6570["施法者"]
    local ____53C2_6570__76EE_6807_6 = _____53C2_6570["目标"]
    if ____53C2_6570__76EE_6807_6 == nil then
        ____53C2_6570__76EE_6807_6 = nil
    end
    _____63A7_5236_5668["目标"] = ____53C2_6570__76EE_6807_6
    _____63A7_5236_5668["创建时间"] = _____521B_5EFA_65F6_95F4
    _____63A7_5236_5668["数据"] = _____53C2_6570["数据"]
    _____63A7_5236_5668["仍有效"] = function()
        if _____7ED3_675F_539F_56E0 ~= nil then
            return false
        end
        local _____8868 = _____5355_4F4D_4E0A_4E0B_6587_8868[_____65BD_6CD5_8005ID]
        return _____8868 ~= nil and (_____8868["代次表"][_____53C2_6570["技能键"]] or 0) == _____4EE3_6B21
    end
    _____63A7_5236_5668["施法者未替换"] = function()
        local ____temp_7
        if _____53C2_6570["当前施法者读取"] ~= nil then
            ____temp_7 = _____53C2_6570["当前施法者读取"]()
        else
            ____temp_7 = _____53C2_6570["施法者"]
        end
        local _____5F53_524D_65BD_6CD5_8005 = ____temp_7
        return _____5F53_524D_65BD_6CD5_8005 ~= nil and _____5F53_524D_65BD_6CD5_8005 ~= 0 and _____53D6_5355_4F4DID(_____5F53_524D_65BD_6CD5_8005) == _____65BD_6CD5_8005ID
    end
    _____63A7_5236_5668["目标有效"] = function()
        if _____53C2_6570["目标"] == nil then
            return false
        end
        if _____53D6_5355_4F4DID(_____53C2_6570["目标"]) ~= _____76EE_6807_53E5_67C4ID then
            return false
        end
        return _____5355_4F4D_5B58_6D3B(_____53C2_6570["目标"])
    end
    _____63A7_5236_5668["校验并收束目标"] = function()
        if _____7ED3_675F_539F_56E0 ~= nil then
            return false
        end
        if _____53C2_6570["目标"] == nil then
            return false
        end
        if _____63A7_5236_5668["目标有效"]() then
            return false
        end
        return _____6536_675F("目标失效")
    end
    _____63A7_5236_5668["登记延迟回调"] = function(id)
        _____7BEE_5B50["登记延迟回调"](
            _____7BEE_5B50,
            "延迟回调-" .. tostring(id),
            id
        )
    end
    _____63A7_5236_5668["登记周期回调"] = function(id)
        _____7BEE_5B50["登记周期回调"](
            _____7BEE_5B50,
            "周期回调-" .. tostring(id),
            id
        )
    end
    _____63A7_5236_5668["登记特效"] = function(_____7279_6548)
        _____7BEE_5B50["登记特效"](
            _____7BEE_5B50,
            (("特效-" .. tostring(_____5B9E_4F8BID)) .. "-") .. tostring(_____53D6_5355_4F4DID(_____7279_6548)),
            _____7279_6548
        )
    end
    _____63A7_5236_5668["登记限时特效"] = function(_____7279_6548, _____6301_7EED_6BEB_79D2)
        _____7BEE_5B50["登记限时特效"](
            _____7BEE_5B50,
            (("限时特效-" .. tostring(_____5B9E_4F8BID)) .. "-") .. tostring(_____53D6_5355_4F4DID(_____7279_6548)),
            _____7279_6548,
            _____6301_7EED_6BEB_79D2
        )
    end
    _____63A7_5236_5668["登记单位"] = function(_____5355_4F4D)
        _____7BEE_5B50["登记单位"](
            _____7BEE_5B50,
            "单位-" .. tostring(_____53D6_5355_4F4DID(_____5355_4F4D)),
            _____5355_4F4D
        )
    end
    _____63A7_5236_5668["登记自定义清理"] = function(_____540D_79F0, _____6E05_7406)
        _____7BEE_5B50["登记清理"](_____7BEE_5B50, _____540D_79F0, _____6E05_7406)
    end
    _____63A7_5236_5668["完成"] = function()
        _____6536_675F("完成")
    end
    _____63A7_5236_5668["中断"] = function()
        _____6536_675F("中断")
    end
    _____63A7_5236_5668["手动清理"] = function()
        _____6536_675F("手动清理")
    end
    _____63A7_5236_5668["结束"] = function(_____539F_56E0)
        return _____6536_675F(_____539F_56E0)
    end
    _____63A7_5236_5668["已结束"] = function()
        return _____7ED3_675F_539F_56E0 ~= nil
    end
    _____63A7_5236_5668["结束原因"] = nil
    if _____53C2_6570["清理篮子"] ~= nil then
        local ____self_8 = _____53C2_6570["清理篮子"]
        ____self_8["登记清理"](
            ____self_8,
            (("战斗技能实例-" .. _____53C2_6570["技能键"]) .. "-") .. tostring(_____5B9E_4F8BID),
            function()
                _____6536_675F("战斗结束")
            end
        )
    end
    _____5B9E_4F8B_7D22_5F15_8868[_____5B9E_4F8BID] = _____63A7_5236_5668
    local _____5217_8868 = _____8868["技能表"][_____53C2_6570["技能键"]]
    if _____5217_8868 == nil then
        _____5217_8868 = {}
        _____8868["技能表"][_____53C2_6570["技能键"]] = _____5217_8868
    end
    _____5217_8868[#_____5217_8868 + 1] = _____63A7_5236_5668
    return _____63A7_5236_5668
end
--- 按单位 + 技能键查询活跃实例（不传技能键 = 该单位全部）
____exports["查询战斗技能实例"] = function(_____5355_4F4D, _____6280_80FD_952E)
    local _____8868 = _____5355_4F4D_4E0A_4E0B_6587_8868[_____53D6_5355_4F4DID(_____5355_4F4D)]
    if _____8868 == nil then
        return {}
    end
    if _____6280_80FD_952E ~= nil then
        local _____5217_8868 = _____8868["技能表"][_____6280_80FD_952E]
        if _____5217_8868 == nil then
            return {}
        end
        local _____7ED3_679C = {}
        do
            local i = 0
            while i < #_____5217_8868 do
                _____7ED3_679C[#_____7ED3_679C + 1] = _____5217_8868[i + 1]
                i = i + 1
            end
        end
        return _____7ED3_679C
    end
    local _____7ED3_679C = {}
    for _____952E in pairs(_____8868["技能表"]) do
        do
            local _____5217_8868 = _____8868["技能表"][_____952E]
            if _____5217_8868 == nil then
                goto __continue65
            end
            do
                local i = 0
                while i < #_____5217_8868 do
                    _____7ED3_679C[#_____7ED3_679C + 1] = _____5217_8868[i + 1]
                    i = i + 1
                end
            end
        end
        ::__continue65::
    end
    return _____7ED3_679C
end
--- 按实例 ID 查询
____exports["按ID查询战斗技能实例"] = function(_____5B9E_4F8BID)
    return _____5B9E_4F8B_7D22_5F15_8868[_____5B9E_4F8BID] or nil
end
--- 结束单位全部实例（默认原因"战斗结束"；技能键可选过滤）
____exports["结束单位战斗技能实例"] = function(_____5355_4F4D, _____539F_56E0, _____6280_80FD_952E)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "战斗结束"
    end
    local _____5217_8868 = ____exports["查询战斗技能实例"](_____5355_4F4D, _____6280_80FD_952E)
    local _____6570_91CF = 0
    do
        local i = 0
        while i < #_____5217_8868 do
            if _____5217_8868[i + 1]["结束"](_____539F_56E0) then
                _____6570_91CF = _____6570_91CF + 1
            end
            i = i + 1
        end
    end
    return _____6570_91CF
end
--- 检测单位替换并收束（句柄变化时按"单位替换"结束该单位全部实例）
____exports["校验单位替换并收束"] = function(_____5355_4F4D)
    local _____5217_8868 = ____exports["查询战斗技能实例"](_____5355_4F4D)
    local _____6570_91CF = 0
    do
        local i = 0
        while i < #_____5217_8868 do
            if not _____5217_8868[i + 1]["施法者未替换"]() and _____5217_8868[i + 1]["结束"]("单位替换") then
                _____6570_91CF = _____6570_91CF + 1
            end
            i = i + 1
        end
    end
    return _____6570_91CF
end
return ____exports
