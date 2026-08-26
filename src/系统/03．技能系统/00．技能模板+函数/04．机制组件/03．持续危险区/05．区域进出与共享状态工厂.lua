local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local addDelayedCallback = ____require_result_0.addDelayedCallback
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____require_result_1["单位存活"]
local _____53D6_5355_4F4DID = ____require_result_1["取单位ID"]
local _____8DDD_79BB_5E73_65B9XY = ____require_result_1["距离平方XY"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local _____5171_4EAB_8BA1_6570_8868 = {}
local function _____9ED8_8BA4_53D6_76EE_6807ID(_____76EE_6807)
    return _____53D6_5355_4F4DID(_____76EE_6807)
end
local function _____9ED8_8BA4_76EE_6807_6709_6548(_____76EE_6807)
    if _____76EE_6807 == nil or _____76EE_6807 == 0 then
        return false
    end
    return _____5355_4F4D_5B58_6D3B(_____76EE_6807)
end
local function _____9ED8_8BA4_53D6_76EE_6807_5750_6807(_____76EE_6807)
    return {
        X = GetUnitX(_____76EE_6807),
        Y = GetUnitY(_____76EE_6807)
    }
end
____exports["创建区域进出"] = function(_____53C2_6570)
    local _____6210_5458_7D22_5F15, _____89E6_53D1_79BB_5F00, _____9500_6BC1, _____5468_671FID, _____5230_671F_56DE_8C03ID, _____5DF2_9500_6BC1, _____6B63_5728_89E6_53D1_79BB_5F00, _____5F85_9500_6BC1_539F_56E0, _____6210_5458_5217_8868, _____5B9E_4F8B_72B6_6001, _____5B9E_4F8B
    function _____6210_5458_7D22_5F15(ID)
        do
            local i = 0
            while i < #_____6210_5458_5217_8868 do
                if _____6210_5458_5217_8868[i + 1].ID == ID then
                    return i
                end
                i = i + 1
            end
        end
        return -1
    end
    function _____89E6_53D1_79BB_5F00(_____8BB0_5F55)
        _____6B63_5728_89E6_53D1_79BB_5F00 = true
        local idx = _____6210_5458_7D22_5F15(_____8BB0_5F55.ID)
        if idx >= 0 then
            __TS__ArraySplice(_____6210_5458_5217_8868, idx, 1)
        end
        if _____53C2_6570["共享键"] ~= nil then
            local _____8868 = _____5171_4EAB_8BA1_6570_8868[_____53C2_6570["共享键"]]
            local ____temp_2
            if _____8868 ~= nil then
                ____temp_2 = _____8868[_____8BB0_5F55.ID]
            else
                ____temp_2 = nil
            end
            local rec = ____temp_2
            if rec ~= nil then
                rec["计数"] = rec["计数"] - 1
                if rec["计数"] <= 0 then
                    if _____8868 ~= nil then
                        __TS__Delete(_____8868, _____8BB0_5F55.ID)
                    end
                    if _____8868 ~= nil then
                        local _____4ECD_6709_5171_4EAB_6210_5458 = false
                        for ID in pairs(_____8868) do
                            if _____8868[__TS__Number(ID)] ~= nil then
                                _____4ECD_6709_5171_4EAB_6210_5458 = true
                                break
                            end
                        end
                        if not _____4ECD_6709_5171_4EAB_6210_5458 then
                            __TS__Delete(_____5171_4EAB_8BA1_6570_8868, _____53C2_6570["共享键"])
                        end
                    end
                    if _____53C2_6570["on共享离开"] ~= nil then
                        _____53C2_6570["on共享离开"](_____8BB0_5F55["目标"], _____53C2_6570["共享键"])
                    end
                end
            end
        end
        if _____53C2_6570["on离开"] ~= nil then
            _____53C2_6570["on离开"](_____8BB0_5F55["目标"], _____5B9E_4F8B)
        end
        __TS__Delete(_____5B9E_4F8B_72B6_6001, _____8BB0_5F55.ID)
        _____6B63_5728_89E6_53D1_79BB_5F00 = false
        if _____5F85_9500_6BC1_539F_56E0 ~= nil then
            local _____539F_56E0 = _____5F85_9500_6BC1_539F_56E0
            _____5F85_9500_6BC1_539F_56E0 = nil
            _____9500_6BC1(_____539F_56E0)
        end
    end
    function _____9500_6BC1(_____539F_56E0)
        if _____5DF2_9500_6BC1 then
            return
        end
        if _____6B63_5728_89E6_53D1_79BB_5F00 then
            if _____5F85_9500_6BC1_539F_56E0 == nil then
                _____5F85_9500_6BC1_539F_56E0 = _____539F_56E0
            end
            return
        end
        _____5DF2_9500_6BC1 = true
        if _____5468_671FID ~= 0 then
            removePeriodicCallback(_____5468_671FID)
            _____5468_671FID = 0
        end
        if _____5230_671F_56DE_8C03ID ~= 0 then
            removeDelayedCallback(_____5230_671F_56DE_8C03ID)
            _____5230_671F_56DE_8C03ID = 0
        end
        while #_____6210_5458_5217_8868 > 0 do
            _____89E6_53D1_79BB_5F00(_____6210_5458_5217_8868[1])
        end
        if _____53C2_6570["on销毁"] ~= nil then
            _____53C2_6570["on销毁"](_____539F_56E0, _____5B9E_4F8B)
        end
    end
    if not (_____53C2_6570["半径"] > 0) or not (_____53C2_6570["Tick间隔毫秒"] == nil or _____53C2_6570["Tick间隔毫秒"] > 0) then
        return nil
    end
    local _____53D6ID = _____53C2_6570["取目标ID"] or _____9ED8_8BA4_53D6_76EE_6807ID
    local _____53D6_5750_6807 = _____53C2_6570["取目标坐标"] or _____9ED8_8BA4_53D6_76EE_6807_5750_6807
    local _____6821_9A8C_6709_6548 = _____53C2_6570["目标有效"] or _____9ED8_8BA4_76EE_6807_6709_6548
    _____5468_671FID = 0
    _____5230_671F_56DE_8C03ID = 0
    _____5DF2_9500_6BC1 = false
    _____6B63_5728_89E6_53D1_79BB_5F00 = false
    _____5F85_9500_6BC1_539F_56E0 = nil
    local _____8FDB_5165_5E8F_53F7 = 0
    _____6210_5458_5217_8868 = {}
    _____5B9E_4F8B_72B6_6001 = {}
    _____5B9E_4F8B = {}
    local function _____5F53_524D_4E2D_5FC3()
        if _____53C2_6570["中心"]["类型"] == "固定" then
            return {X = _____53C2_6570["中心"].X, Y = _____53C2_6570["中心"].Y}
        end
        if _____53C2_6570["中心"]["类型"] == "锚点单位" then
            local _____5355_4F4D = _____53C2_6570["中心"]["单位"]
            if _____5355_4F4D == nil or _____5355_4F4D == 0 then
                return {X = 0, Y = 0}
            end
            return {
                X = GetUnitX(_____5355_4F4D),
                Y = GetUnitY(_____5355_4F4D)
            }
        end
        local pos = _____53C2_6570["中心"]["读取"]()
        return pos ~= nil and pos or ({X = 0, Y = 0})
    end
    local function _____5171_4EAB_952E_8868()
        if _____53C2_6570["共享键"] == nil then
            return nil
        end
        local _____8868 = _____5171_4EAB_8BA1_6570_8868[_____53C2_6570["共享键"]]
        if _____8868 == nil then
            _____8868 = {}
            _____5171_4EAB_8BA1_6570_8868[_____53C2_6570["共享键"]] = _____8868
        end
        return _____8868
    end
    local function _____5904_7406Tick()
        if _____5DF2_9500_6BC1 then
            return
        end
        local c = _____5F53_524D_4E2D_5FC3()
        local _____534A_5F84_5E73_65B9 = _____53C2_6570["半径"] * _____53C2_6570["半径"]
        local _____5019_9009 = _____53C2_6570["目标源"]() or ({})
        local _____672C_5E27 = {}
        do
            local i = 0
            while i < #_____5019_9009 do
                do
                    local _____76EE_6807 = _____5019_9009[i + 1]
                    if _____76EE_6807 == nil or _____76EE_6807 == 0 then
                        goto __continue44
                    end
                    if not _____6821_9A8C_6709_6548(_____76EE_6807) then
                        goto __continue44
                    end
                    local _____5750_6807 = _____53D6_5750_6807(_____76EE_6807)
                    if _____5750_6807 == nil then
                        goto __continue44
                    end
                    local x = _____5750_6807.X
                    local y = _____5750_6807.Y
                    if _____8DDD_79BB_5E73_65B9XY(x, y, c.X, c.Y) > _____534A_5F84_5E73_65B9 then
                        goto __continue44
                    end
                    if _____53C2_6570["形状筛选"] ~= nil and not _____53C2_6570["形状筛选"](_____76EE_6807, c.X, c.Y) then
                        goto __continue44
                    end
                    local ID = _____53D6ID(_____76EE_6807)
                    if not (ID > 0) then
                        goto __continue44
                    end
                    local _____91CD_590D = false
                    do
                        local j = 0
                        while j < #_____672C_5E27 do
                            if _____672C_5E27[j + 1].ID == ID then
                                _____91CD_590D = true
                                break
                            end
                            j = j + 1
                        end
                    end
                    if not _____91CD_590D then
                        _____672C_5E27[#_____672C_5E27 + 1] = {["目标"] = _____76EE_6807, ID = ID}
                    end
                end
                ::__continue44::
                i = i + 1
            end
        end
        local _____79BB_5F00_7D22_5F15 = 0
        while _____79BB_5F00_7D22_5F15 < #_____6210_5458_5217_8868 do
            do
                local _____8BB0_5F55 = _____6210_5458_5217_8868[_____79BB_5F00_7D22_5F15 + 1]
                if not _____6821_9A8C_6709_6548(_____8BB0_5F55["目标"]) then
                    _____89E6_53D1_79BB_5F00(_____8BB0_5F55)
                    if _____5DF2_9500_6BC1 then
                        return
                    end
                    goto __continue55
                end
                local _____4ECD_5728 = false
                do
                    local j = 0
                    while j < #_____672C_5E27 do
                        if _____672C_5E27[j + 1].ID == _____8BB0_5F55.ID then
                            _____4ECD_5728 = true
                            break
                        end
                        j = j + 1
                    end
                end
                if not _____4ECD_5728 then
                    _____89E6_53D1_79BB_5F00(_____8BB0_5F55)
                    if _____5DF2_9500_6BC1 then
                        return
                    end
                    goto __continue55
                end
                _____79BB_5F00_7D22_5F15 = _____79BB_5F00_7D22_5F15 + 1
            end
            ::__continue55::
        end
        do
            local i = 0
            while i < #_____672C_5E27 do
                do
                    local _____547D_4E2D = _____672C_5E27[i + 1]
                    if _____6210_5458_7D22_5F15(_____547D_4E2D.ID) >= 0 then
                        goto __continue64
                    end
                    local ____547D_4E2D__76EE_6807_4 = _____547D_4E2D["目标"]
                    local ____547D_4E2D_ID_5 = _____547D_4E2D.ID
                    local ____8FDB_5165_5E8F_53F7_3 = _____8FDB_5165_5E8F_53F7
                    _____8FDB_5165_5E8F_53F7 = ____8FDB_5165_5E8F_53F7_3 + 1
                    local _____8BB0_5F55 = {["目标"] = ____547D_4E2D__76EE_6807_4, ID = ____547D_4E2D_ID_5, ["进入序号"] = ____8FDB_5165_5E8F_53F7_3}
                    _____6210_5458_5217_8868[#_____6210_5458_5217_8868 + 1] = _____8BB0_5F55
                    _____5B9E_4F8B_72B6_6001[_____547D_4E2D.ID] = {}
                    if _____53C2_6570["共享键"] ~= nil then
                        local _____8868 = _____5171_4EAB_952E_8868()
                        local ____temp_6
                        if _____8868 ~= nil then
                            ____temp_6 = _____8868[_____547D_4E2D.ID]
                        else
                            ____temp_6 = nil
                        end
                        local rec = ____temp_6
                        if rec == nil then
                            rec = {["计数"] = 0, ["数据"] = {}}
                            if _____8868 ~= nil then
                                _____8868[_____547D_4E2D.ID] = rec
                            end
                        end
                        rec["计数"] = rec["计数"] + 1
                    end
                    if _____53C2_6570["on进入"] ~= nil then
                        _____53C2_6570["on进入"](_____547D_4E2D["目标"], _____5B9E_4F8B)
                    end
                    if _____5DF2_9500_6BC1 then
                        return
                    end
                end
                ::__continue64::
                i = i + 1
            end
        end
        do
            local i = 0
            while i < #_____6210_5458_5217_8868 do
                if _____53C2_6570["on停留"] ~= nil then
                    _____53C2_6570["on停留"](_____6210_5458_5217_8868[i + 1]["目标"], _____5B9E_4F8B)
                end
                if _____5DF2_9500_6BC1 then
                    return
                end
                i = i + 1
            end
        end
    end
    _____5B9E_4F8B["取当前成员"] = function()
        local _____7ED3_679C = {}
        do
            local i = 0
            while i < #_____6210_5458_5217_8868 do
                _____7ED3_679C[#_____7ED3_679C + 1] = _____6210_5458_5217_8868[i + 1]["目标"]
                i = i + 1
            end
        end
        return _____7ED3_679C
    end
    _____5B9E_4F8B["取状态"] = function(_____76EE_6807)
        local _____72B6_6001 = _____5B9E_4F8B_72B6_6001[_____53D6ID(_____76EE_6807)]
        local ____temp_7
        if _____72B6_6001 ~= nil then
            ____temp_7 = _____72B6_6001
        else
            ____temp_7 = nil
        end
        return ____temp_7
    end
    _____5B9E_4F8B["取共享状态"] = function(_____76EE_6807)
        if _____53C2_6570["共享键"] == nil then
            return nil
        end
        local _____8868 = _____5171_4EAB_8BA1_6570_8868[_____53C2_6570["共享键"]]
        local ____temp_8
        if _____8868 ~= nil then
            ____temp_8 = _____8868[_____53D6ID(_____76EE_6807)]
        else
            ____temp_8 = nil
        end
        local rec = ____temp_8
        local ____temp_9
        if rec ~= nil then
            ____temp_9 = rec["数据"]
        else
            ____temp_9 = nil
        end
        return ____temp_9
    end
    _____5B9E_4F8B["取共享计数"] = function(_____76EE_6807)
        if _____53C2_6570["共享键"] == nil then
            return 0
        end
        local _____8868 = _____5171_4EAB_8BA1_6570_8868[_____53C2_6570["共享键"]]
        local ____temp_10
        if _____8868 ~= nil then
            ____temp_10 = _____8868[_____53D6ID(_____76EE_6807)]
        else
            ____temp_10 = nil
        end
        local rec = ____temp_10
        return rec ~= nil and rec["计数"] or 0
    end
    _____5B9E_4F8B["取中心"] = _____5F53_524D_4E2D_5FC3
    _____5B9E_4F8B["销毁"] = function(_____539F_56E0)
        _____9500_6BC1(_____539F_56E0 or "手动销毁")
    end
    _____5B9E_4F8B["已销毁"] = function()
        return _____5DF2_9500_6BC1
    end
    if _____53C2_6570["清理篮子"] ~= nil then
        local ____self_11 = _____53C2_6570["清理篮子"]
        ____self_11["登记清理"](
            ____self_11,
            _____53C2_6570["名称"] .. "-区域进出",
            function()
                _____9500_6BC1("清理篮子")
            end
        )
    end
    _____5468_671FID = addPeriodicCallback(_____53C2_6570["Tick间隔毫秒"] or 100, _____5904_7406Tick)
    if _____53C2_6570["持续毫秒"] ~= nil and _____53C2_6570["持续毫秒"] > 0 then
        local function _____5230_671F_5904_7406()
            _____5230_671F_56DE_8C03ID = 0
            _____9500_6BC1("到期")
        end
        _____5230_671F_56DE_8C03ID = addDelayedCallback(_____53C2_6570["持续毫秒"], _____5230_671F_5904_7406)
    end
    return _____5B9E_4F8B
end
return ____exports
