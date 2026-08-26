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
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
--- 活动实例（单位 handleId → 控制器数组；死亡时统一收束）
local _____6D3B_52A8_5B9E_4F8B_8868 = {}
local _____4E0B_4E00_4E2A_5B9E_4F8B_6807_8BC6 = 1
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____5355_4F4D_6709_6548_6536_675F(unit)
    return unit ~= nil and unit ~= 0
end
local function _____5B9E_4F8B_6536_675F_6B7B_4EA1_6E05_7406(dyingUnit, _killingUnit)
    if not _____5355_4F4D_6709_6548_6536_675F(dyingUnit) then
        return
    end
    local _____5217_8868 = _____6D3B_52A8_5B9E_4F8B_8868[GetHandleId(dyingUnit)]
    if _____5217_8868 == nil then
        return
    end
    __TS__Delete(
        _____6D3B_52A8_5B9E_4F8B_8868,
        GetHandleId(dyingUnit)
    )
    do
        local i = 0
        while i < #_____5217_8868 do
            local _____63A7_5236_5668 = _____5217_8868[i + 1]
            if _____63A7_5236_5668 ~= nil and not _____63A7_5236_5668["已结束"]() then
                _____63A7_5236_5668["主动清理"]()
            end
            i = i + 1
        end
    end
end
local function _____786E_4FDD_6536_675F_6B7B_4EA1_76D1_542C()
    if _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
    registerDeathListener(_____5B9E_4F8B_6536_675F_6B7B_4EA1_6E05_7406)
end
--- 创建技能实例收束控制器。单位死亡时自动以"主动清理"收束。
____exports["创建技能实例收束"] = function(_____53C2_6570)
    local _____63A7_5236_5668
    if _____53C2_6570["名称"] == "" then
        return nil
    end
    local ____4E0B_4E00_4E2A_5B9E_4F8B_6807_8BC6_3 = _____4E0B_4E00_4E2A_5B9E_4F8B_6807_8BC6
    _____4E0B_4E00_4E2A_5B9E_4F8B_6807_8BC6 = ____4E0B_4E00_4E2A_5B9E_4F8B_6807_8BC6_3 + 1
    local _____5B9E_4F8B_6807_8BC6 = ____4E0B_4E00_4E2A_5B9E_4F8B_6807_8BC6_3
    local _____7BEE_5B50 = _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50((_____53C2_6570["名称"] .. "-实例") .. tostring(_____5B9E_4F8B_6807_8BC6))
    local _____5DF2_6536_675F = false
    local _____7ED3_675F_539F_56E0 = nil
    local function _____6536_675F(_____539F_56E0)
        if _____5DF2_6536_675F then
            return
        end
        _____5DF2_6536_675F = true
        _____7ED3_675F_539F_56E0 = _____539F_56E0
        _____63A7_5236_5668["结束原因"] = _____539F_56E0
        _____7BEE_5B50["清理全部"](_____7BEE_5B50)
        if _____53C2_6570["技能实例ID"] ~= nil then
            _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(_____53C2_6570["技能实例ID"])
        end
        if _____5355_4F4D_6709_6548_6536_675F(_____53C2_6570["单位"]) then
            local _____5217_8868 = _____6D3B_52A8_5B9E_4F8B_8868[GetHandleId(_____53C2_6570["单位"])]
            if _____5217_8868 ~= nil then
                local idx = __TS__ArrayIndexOf(_____5217_8868, _____63A7_5236_5668)
                if idx >= 0 then
                    __TS__ArraySplice(_____5217_8868, idx, 1)
                end
                if #_____5217_8868 <= 0 then
                    __TS__Delete(
                        _____6D3B_52A8_5B9E_4F8B_8868,
                        GetHandleId(_____53C2_6570["单位"])
                    )
                end
            end
        end
        if _____53C2_6570["结束回调"] ~= nil then
            local _____56DE_8C03 = _____53C2_6570["结束回调"]
            _____56DE_8C03(_____539F_56E0, _____63A7_5236_5668)
        end
    end
    _____63A7_5236_5668 = {
        ["实例标识"] = _____5B9E_4F8B_6807_8BC6,
        ["数据"] = _____53C2_6570["数据"],
        ["结束原因"] = _____7ED3_675F_539F_56E0,
        ["登记延迟回调"] = function(id)
            if not _____5DF2_6536_675F then
                _____7BEE_5B50["登记延迟回调"](
                    _____7BEE_5B50,
                    "延迟" .. tostring(id),
                    id
                )
            end
        end,
        ["登记周期回调"] = function(id)
            if not _____5DF2_6536_675F then
                _____7BEE_5B50["登记周期回调"](
                    _____7BEE_5B50,
                    "周期" .. tostring(id),
                    id
                )
            end
        end,
        ["登记特效"] = function(_____7279_6548)
            if not _____5DF2_6536_675F then
                _____7BEE_5B50["登记特效"](
                    _____7BEE_5B50,
                    "特效" .. tostring(GetHandleId(_____7279_6548)),
                    _____7279_6548
                )
            end
        end,
        ["登记限时特效"] = function(_____7279_6548, _____6301_7EED_6BEB_79D2)
            if not _____5DF2_6536_675F then
                _____7BEE_5B50["登记限时特效"](
                    _____7BEE_5B50,
                    "限时特效" .. tostring(GetHandleId(_____7279_6548)),
                    _____7279_6548,
                    _____6301_7EED_6BEB_79D2
                )
            end
        end,
        ["登记单位"] = function(_____5355_4F4D)
            if not _____5DF2_6536_675F then
                _____7BEE_5B50["登记单位"](
                    _____7BEE_5B50,
                    "单位" .. tostring(GetHandleId(_____5355_4F4D)),
                    _____5355_4F4D
                )
            end
        end,
        ["登记自定义清理"] = function(_____540D_79F0, _____6E05_7406)
            if not _____5DF2_6536_675F then
                _____7BEE_5B50["登记清理"](_____7BEE_5B50, _____540D_79F0, _____6E05_7406)
            end
        end,
        ["完成"] = function()
            _____6536_675F("完成")
        end,
        ["中断"] = function()
            _____6536_675F("中断")
        end,
        ["目标失效"] = function()
            _____6536_675F("目标失效")
        end,
        ["主动清理"] = function()
            _____6536_675F("主动清理")
        end,
        ["已结束"] = function()
            return _____5DF2_6536_675F
        end
    }
    if _____5355_4F4D_6709_6548_6536_675F(_____53C2_6570["单位"]) then
        local _____5217_8868 = _____6D3B_52A8_5B9E_4F8B_8868[GetHandleId(_____53C2_6570["单位"])]
        if _____5217_8868 == nil then
            _____5217_8868 = {}
            _____6D3B_52A8_5B9E_4F8B_8868[GetHandleId(_____53C2_6570["单位"])] = _____5217_8868
        end
        _____5217_8868[#_____5217_8868 + 1] = _____63A7_5236_5668
        _____786E_4FDD_6536_675F_6B7B_4EA1_76D1_542C()
    end
    return _____63A7_5236_5668
end
--- 读取结束原因（null = 未结束）
____exports["读取技能实例结束原因"] = function(_____63A7_5236_5668)
    local ____temp_4
    if _____63A7_5236_5668 == nil then
        ____temp_4 = nil
    else
        ____temp_4 = _____63A7_5236_5668["结束原因"]
    end
    return ____temp_4
end
return ____exports
