local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果")
local _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C = ____require_result_0["注册持有型周期效果"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听")
local _____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF = ____require_result_1["获取单位当前持有指定物品数量"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_2.getUnitsInRange
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local matchUnitFilter = ____require_result_3.matchUnitFilter
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.08．单位判定与筛选函数")
local SUC_GetUnitLife = ____require_result_4.SUC_GetUnitLife
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local _____5B58_6D3B_751F_547D_9608_503C = 0.405
local _____8303_56F4_5149_73AF_5B9E_4F8B_8868 = {}
local _____624B_52A8_8303_56F4_5149_73AF_5B9E_4F8B_8868 = {}
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____53D6_73A9_5BB6ID(unit)
    if unit == nil or unit == 0 then
        return -1
    end
    local player = GetOwningPlayer(unit)
    if player == nil or player == 0 then
        return -1
    end
    return GetPlayerId(player)
end
local function _____5355_4F4D_5F53_524D_5B58_6D3B(unit, minLife)
    if unit == nil or unit == 0 then
        return false
    end
    return SUC_GetUnitLife(unit) > minLife
end
local function _____6784_5EFA_7B5B_9009_53C2_6570(_____914D_7F6E)
    if _____914D_7F6E["目标类型"] == "敌人" then
        return {
            ["仅敌人"] = true,
            ["排除自身"] = true,
            ["要求有效单位"] = true,
            ["允许建筑"] = false,
            ["允许机械"] = false,
            ["允许古树"] = false,
            ["允许无敌"] = _____914D_7F6E["排除无敌"] ~= true,
            ["允许死亡"] = false
        }
    end
    return {
        ["仅友军"] = true,
        ["排除自身"] = _____914D_7F6E["目标类型"] == "友军不含自己",
        ["要求有效单位"] = true,
        ["允许建筑"] = false,
        ["允许机械"] = false,
        ["允许古树"] = false,
        ["允许无敌"] = _____914D_7F6E["排除无敌"] ~= true,
        ["允许死亡"] = false
    }
end
local function _____76EE_6807_901A_8FC7_5149_73AF_7B5B_9009(_____914D_7F6E, target, holder)
    local _____6700_5C0F_751F_547D_503C = _____914D_7F6E["最小生命值"] == nil and _____5B58_6D3B_751F_547D_9608_503C or _____914D_7F6E["最小生命值"]
    if not _____5355_4F4D_5F53_524D_5B58_6D3B(target, _____6700_5C0F_751F_547D_503C) then
        return false
    end
    if not matchUnitFilter(
        target,
        holder,
        _____6784_5EFA_7B5B_9009_53C2_6570(_____914D_7F6E)
    ) then
        return false
    end
    if _____914D_7F6E["额外筛选"] ~= nil and _____914D_7F6E["额外筛选"](target, holder) ~= true then
        return false
    end
    return true
end
local function _____53D6_76EE_6807_53BB_91CD_952E(_____914D_7F6E, target)
    if _____914D_7F6E["去重类型"] == "玩家" then
        return _____53D6_73A9_5BB6ID(target)
    end
    return _____53D6_5355_4F4DID(target)
end
local function _____6784_5EFA_4E0B_4E00_6279_76EE_6807(_____914D_7F6E, holder)
    local x = GetUnitX(holder)
    local y = GetUnitY(holder)
    local units = getUnitsInRange(x, y, _____914D_7F6E["半径"])
    local _____76EE_6807_5355_4F4D_6620_5C04_8868 = {}
    local _____76EE_6807_952E_5217_8868 = {}
    do
        local i = 0
        while i < #units do
            do
                local target = units[i + 1]
                if not _____76EE_6807_901A_8FC7_5149_73AF_7B5B_9009(_____914D_7F6E, target, holder) then
                    goto __continue19
                end
                local _____76EE_6807_952E = _____53D6_76EE_6807_53BB_91CD_952E(_____914D_7F6E, target)
                if _____76EE_6807_952E < 0 then
                    goto __continue19
                end
                if _____76EE_6807_5355_4F4D_6620_5C04_8868[_____76EE_6807_952E] ~= nil then
                    goto __continue19
                end
                _____76EE_6807_5355_4F4D_6620_5C04_8868[_____76EE_6807_952E] = target
                local _____63D2_5165_4F4D_7F6E = #_____76EE_6807_952E_5217_8868
                while _____63D2_5165_4F4D_7F6E > 0 and _____76EE_6807_952E_5217_8868[_____63D2_5165_4F4D_7F6E] > _____76EE_6807_952E do
                    _____63D2_5165_4F4D_7F6E = _____63D2_5165_4F4D_7F6E - 1
                end
                __TS__ArraySplice(_____76EE_6807_952E_5217_8868, _____63D2_5165_4F4D_7F6E, 0, _____76EE_6807_952E)
            end
            ::__continue19::
            i = i + 1
        end
    end
    local _____76EE_6807_5355_4F4D_5217_8868 = {}
    do
        local i = 0
        while i < #_____76EE_6807_952E_5217_8868 do
            _____76EE_6807_5355_4F4D_5217_8868[#_____76EE_6807_5355_4F4D_5217_8868 + 1] = _____76EE_6807_5355_4F4D_6620_5C04_8868[_____76EE_6807_952E_5217_8868[i + 1]]
            i = i + 1
        end
    end
    return {["目标键列表"] = _____76EE_6807_952E_5217_8868, ["目标单位列表"] = _____76EE_6807_5355_4F4D_5217_8868}
end
local function _____53D6_6301_6709_8005_72B6_6001(_____914D_7F6E, holderId)
    local _____5DF2_6709_72B6_6001 = _____914D_7F6E["持有者状态表"][holderId]
    if _____5DF2_6709_72B6_6001 ~= nil then
        return _____5DF2_6709_72B6_6001
    end
    local _____65B0_72B6_6001 = {["目标键列表"] = {}, ["目标单位列表"] = {}}
    _____914D_7F6E["持有者状态表"][holderId] = _____65B0_72B6_6001
    return _____65B0_72B6_6001
end
local function _____6E05_7406_6301_6709_8005_5149_73AF(_____914D_7F6E, holder, currentCount)
    local holderId = _____53D6_5355_4F4DID(holder)
    if holderId == 0 then
        return
    end
    local _____72B6_6001 = _____914D_7F6E["持有者状态表"][holderId]
    if _____72B6_6001 == nil then
        return
    end
    do
        local i = 0
        while i < #_____72B6_6001["目标单位列表"] do
            do
                local target = _____72B6_6001["目标单位列表"][i + 1]
                if target == nil or target == 0 then
                    goto __continue32
                end
                _____914D_7F6E["移除目标效果"](target, holder, currentCount)
            end
            ::__continue32::
            i = i + 1
        end
    end
    __TS__Delete(_____914D_7F6E["持有者状态表"], holderId)
end
local function _____540C_6B65_5355_4E2A_6301_6709_8005_5149_73AF(_____914D_7F6E, holder, currentCount)
    local holderId = _____53D6_5355_4F4DID(holder)
    if holderId == 0 then
        return
    end
    if not _____5355_4F4D_5F53_524D_5B58_6D3B(holder, _____5B58_6D3B_751F_547D_9608_503C) or currentCount <= 0 then
        _____6E05_7406_6301_6709_8005_5149_73AF(_____914D_7F6E, holder, currentCount)
        return
    end
    local _____72B6_6001 = _____53D6_6301_6709_8005_72B6_6001(_____914D_7F6E, holderId)
    local _____4E0B_4E00_6279_76EE_6807 = _____6784_5EFA_4E0B_4E00_6279_76EE_6807(_____914D_7F6E, holder)
    local _____65E7_952E_5217_8868 = _____72B6_6001["目标键列表"]
    local _____65E7_5355_4F4D_5217_8868 = _____72B6_6001["目标单位列表"]
    local _____65B0_952E_5217_8868 = _____4E0B_4E00_6279_76EE_6807["目标键列表"]
    local _____65B0_5355_4F4D_5217_8868 = _____4E0B_4E00_6279_76EE_6807["目标单位列表"]
    local _____65E7_7D22_5F15 = 0
    local _____65B0_7D22_5F15 = 0
    while _____65E7_7D22_5F15 < #_____65E7_952E_5217_8868 or _____65B0_7D22_5F15 < #_____65B0_952E_5217_8868 do
        do
            local _____65E7_952E = _____65E7_7D22_5F15 < #_____65E7_952E_5217_8868 and _____65E7_952E_5217_8868[_____65E7_7D22_5F15 + 1] or 2147483647
            local _____65B0_952E = _____65B0_7D22_5F15 < #_____65B0_952E_5217_8868 and _____65B0_952E_5217_8868[_____65B0_7D22_5F15 + 1] or 2147483647
            if _____65E7_952E == _____65B0_952E then
                local sameTarget = _____65B0_5355_4F4D_5217_8868[_____65B0_7D22_5F15 + 1]
                if sameTarget ~= nil and sameTarget ~= 0 and _____914D_7F6E["同步目标效果"] ~= nil then
                    _____914D_7F6E["同步目标效果"](sameTarget, holder, currentCount)
                end
                _____65E7_7D22_5F15 = _____65E7_7D22_5F15 + 1
                _____65B0_7D22_5F15 = _____65B0_7D22_5F15 + 1
                goto __continue37
            end
            if _____65E7_952E < _____65B0_952E then
                local oldTarget = _____65E7_5355_4F4D_5217_8868[_____65E7_7D22_5F15 + 1]
                if oldTarget ~= nil and oldTarget ~= 0 then
                    _____914D_7F6E["移除目标效果"](oldTarget, holder, currentCount)
                end
                _____65E7_7D22_5F15 = _____65E7_7D22_5F15 + 1
                goto __continue37
            end
            local newTarget = _____65B0_5355_4F4D_5217_8868[_____65B0_7D22_5F15 + 1]
            if newTarget ~= nil and newTarget ~= 0 then
                _____914D_7F6E["应用目标效果"](newTarget, holder, currentCount)
            end
            _____65B0_7D22_5F15 = _____65B0_7D22_5F15 + 1
        end
        ::__continue37::
    end
    _____72B6_6001["目标键列表"] = _____65B0_952E_5217_8868
    _____72B6_6001["目标单位列表"] = _____65B0_5355_4F4D_5217_8868
end
local function ____on_8303_56F4_5149_73AF_5468_671F(unit, _currentCount)
    do
        local i = 0
        while i < #_____8303_56F4_5149_73AF_5B9E_4F8B_8868 do
            do
                local _____914D_7F6E = _____8303_56F4_5149_73AF_5B9E_4F8B_8868[i + 1]
                local _____5F53_524D_6570_91CF = _____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF(unit, _____914D_7F6E["物品类型ID"])
                if _____5F53_524D_6570_91CF <= 0 then
                    goto __continue45
                end
                _____540C_6B65_5355_4E2A_6301_6709_8005_5149_73AF(_____914D_7F6E, unit, _____5F53_524D_6570_91CF)
            end
            ::__continue45::
            i = i + 1
        end
    end
end
local function ____on_8303_56F4_5149_73AF_4E22_5F03(unit)
    do
        local i = 0
        while i < #_____8303_56F4_5149_73AF_5B9E_4F8B_8868 do
            do
                local _____914D_7F6E = _____8303_56F4_5149_73AF_5B9E_4F8B_8868[i + 1]
                local _____5F53_524D_6570_91CF = _____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF(unit, _____914D_7F6E["物品类型ID"])
                if _____5F53_524D_6570_91CF > 0 then
                    goto __continue49
                end
                _____6E05_7406_6301_6709_8005_5149_73AF(_____914D_7F6E, unit, 1)
            end
            ::__continue49::
            i = i + 1
        end
    end
end
____exports["注册持有型范围光环"] = function(_____53C2_6570)
    if _____53C2_6570 == nil or _____53C2_6570["物品类型ID"] == 0 or _____53C2_6570["间隔毫秒"] <= 0 or _____53C2_6570["半径"] <= 0 then
        return
    end
    local _____914D_7F6E = __TS__ObjectAssign({}, _____53C2_6570, {["持有者状态表"] = {}})
    _____8303_56F4_5149_73AF_5B9E_4F8B_8868[#_____8303_56F4_5149_73AF_5B9E_4F8B_8868 + 1] = _____914D_7F6E
    _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C({["物品类型ID"] = _____53C2_6570["物品类型ID"], ["间隔毫秒"] = _____53C2_6570["间隔毫秒"], ["周期回调"] = ____on_8303_56F4_5149_73AF_5468_671F, ["丢弃回调"] = ____on_8303_56F4_5149_73AF_4E22_5F03})
end
____exports["创建手动范围光环"] = function(_____53C2_6570)
    if _____53C2_6570 == nil or _____53C2_6570["半径"] <= 0 then
        return 0
    end
    local _____914D_7F6E = __TS__ObjectAssign({}, _____53C2_6570, {["持有者状态表"] = {}})
    _____624B_52A8_8303_56F4_5149_73AF_5B9E_4F8B_8868[#_____624B_52A8_8303_56F4_5149_73AF_5B9E_4F8B_8868 + 1] = _____914D_7F6E
    return #_____624B_52A8_8303_56F4_5149_73AF_5B9E_4F8B_8868
end
____exports["同步手动范围光环"] = function(_____5149_73AFID, _____6301_6709_8005, _____751F_6548)
    if _____5149_73AFID <= 0 then
        return
    end
    local _____914D_7F6E = _____624B_52A8_8303_56F4_5149_73AF_5B9E_4F8B_8868[_____5149_73AFID]
    if _____914D_7F6E == nil then
        return
    end
    _____540C_6B65_5355_4E2A_6301_6709_8005_5149_73AF(_____914D_7F6E, _____6301_6709_8005, _____751F_6548 and 1 or 0)
end
return ____exports
