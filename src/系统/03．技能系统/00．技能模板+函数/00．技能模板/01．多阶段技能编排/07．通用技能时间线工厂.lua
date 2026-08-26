local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local ____exports = {}
local ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.01．多阶段技能编排.06．技能阶段链执行器")
local _____5F00_59CB_6280_80FD_9636_6BB5_94FE = ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668["开始技能阶段链"]
local _____505C_6B62_6280_80FD_9636_6BB5_94FE = ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668["停止技能阶段链"]
local _____521B_5EFA_5EF6_8FDF_6267_884C_9636_6BB5 = ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668["创建延迟执行阶段"]
local ____06_FF0E_5BF9_5916_63A5_53E3 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____06_FF0E_5BF9_5916_63A5_53E3["显示常规技能吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____06_FF0E_5BF9_5916_63A5_53E3["关闭吟唱条"]
local ____24_FF0E_6574_6570_4E0E_65F6_95F4_6362_7B97 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.24．整数与时间换算")
local _____79D2_8F6C_6BEB_79D2 = ____24_FF0E_6574_6570_4E0E_65F6_95F4_6362_7B97["秒转毫秒"]
--- 主动停止时间线（中断/收尾/目标失效）。幂等：已结束的时间线返回 false。
____exports["停止通用技能时间线"] = function(_____65F6_95F4_7EBFID, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "中断"
    end
    return _____505C_6B62_6280_80FD_9636_6BB5_94FE(_____65F6_95F4_7EBFID, _____539F_56E0)
end
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local GS_Suspend = ____require_result_2.GS_Suspend
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_3["创建点特效"]
local createUnitEffect = ____require_result_3.createUnitEffect
local destroyUnitEffect = ____require_result_3.destroyUnitEffect
local createTimedUnitEffect = ____require_result_3.createTimedUnitEffect
local ____require_result_4 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_4.Sound3DII_UnitPlayReuse
local GetHandleId = jass.GetHandleId
local GetUnitXSafe = jass.GetUnitX
local GetUnitYSafe = jass.GetUnitY
--- 活动时间线（按单位 handleId → 时间线ID列表，死亡时全部收束）
local _____6D3B_52A8_65F6_95F4_7EBF_8868 = {}
local _____541F_5531_65F6_95F4_7EBF_8868 = {}
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____5355_4F4D_6709_6548_65F6_95F4_7EBF(unit)
    return unit ~= nil and unit ~= 0
end
local function _____767B_8BB0_6D3B_52A8_65F6_95F4_7EBF(_____5355_4F4D, _____65F6_95F4_7EBFID)
    local _____5355_4F4DID = GetHandleId(_____5355_4F4D)
    local _____5217_8868 = _____6D3B_52A8_65F6_95F4_7EBF_8868[_____5355_4F4DID]
    if _____5217_8868 == nil then
        _____5217_8868 = {}
        _____6D3B_52A8_65F6_95F4_7EBF_8868[_____5355_4F4DID] = _____5217_8868
    end
    _____5217_8868[#_____5217_8868 + 1] = _____65F6_95F4_7EBFID
end
local function _____79FB_9664_6D3B_52A8_65F6_95F4_7EBF(_____5355_4F4D, _____65F6_95F4_7EBFID)
    if not _____5355_4F4D_6709_6548_65F6_95F4_7EBF(_____5355_4F4D) then
        return
    end
    local _____5355_4F4DID = GetHandleId(_____5355_4F4D)
    local _____5217_8868 = _____6D3B_52A8_65F6_95F4_7EBF_8868[_____5355_4F4DID]
    if _____5217_8868 == nil then
        return
    end
    local index = __TS__ArrayIndexOf(_____5217_8868, _____65F6_95F4_7EBFID)
    if index >= 0 then
        __TS__ArraySplice(_____5217_8868, index, 1)
    end
    if #_____5217_8868 <= 0 then
        __TS__Delete(_____6D3B_52A8_65F6_95F4_7EBF_8868, _____5355_4F4DID)
    end
end
local function _____64AD_653E_65F6_95F4_7EBF_9636_6BB5_8868_73B0(_____4E0A_4E0B_6587, _____9636_6BB5, _____6E05_7406)
    local _____5355_4F4D = _____4E0A_4E0B_6587["单位"]
    if _____9636_6BB5["硬直秒"] ~= nil and _____9636_6BB5["硬直秒"] > 0 then
        GS_Suspend(_____5355_4F4D, _____9636_6BB5["硬直秒"])
    end
    if _____9636_6BB5["音效"] ~= nil and _____9636_6BB5["音效"]["路径"] ~= nil and _____9636_6BB5["音效"]["路径"] ~= "" then
        Sound3DII_UnitPlayReuse(_____9636_6BB5["音效"]["路径"], _____5355_4F4D, _____9636_6BB5["音效"]["裁断"] or 0)
    end
    if _____9636_6BB5["点特效"] ~= nil and _____9636_6BB5["点特效"]["模型"] ~= nil and _____9636_6BB5["点特效"]["模型"] ~= "" then
        local ____521B_5EFA_70B9_7279_6548_11 = _____521B_5EFA_70B9_7279_6548
        local ____9636_6BB5__70B9_7279_6548__6A21_578B_6 = _____9636_6BB5["点特效"]["模型"]
        local ____temp_7 = _____9636_6BB5["点特效"].X or GetUnitXSafe(_____5355_4F4D)
        local ____temp_8 = _____9636_6BB5["点特效"].Y or GetUnitYSafe(_____5355_4F4D)
        local ____temp_9 = _____9636_6BB5["点特效"].Z or 0
        local ____9636_6BB5__70B9_7279_6548__7F29_653E_10 = _____9636_6BB5["点特效"]["缩放"]
        local ____temp_5
        if _____6E05_7406 == nil then
            ____temp_5 = _____9636_6BB5["点特效"]["持续秒"]
        else
            ____temp_5 = nil
        end
        local _____70B9_7279_6548 = ____521B_5EFA_70B9_7279_6548_11({
            ["模型路径"] = ____9636_6BB5__70B9_7279_6548__6A21_578B_6,
            X = ____temp_7,
            Y = ____temp_8,
            Z = ____temp_9,
            ["缩放"] = ____9636_6BB5__70B9_7279_6548__7F29_653E_10,
            ["持续秒"] = ____temp_5
        })
        if _____6E05_7406 ~= nil and _____70B9_7279_6548 ~= nil and _____70B9_7279_6548 ~= 0 then
            local _____6301_7EED_6BEB_79D2 = (_____9636_6BB5["点特效"]["持续秒"] or 0) * 1000
            if _____6301_7EED_6BEB_79D2 > 0 then
                _____6E05_7406["登记限时特效"](
                    _____6E05_7406,
                    "时间线点特效-" .. tostring(_____4E0A_4E0B_6587["当前阶段索引"]),
                    _____70B9_7279_6548,
                    _____6301_7EED_6BEB_79D2
                )
            else
                _____6E05_7406["登记特效"](
                    _____6E05_7406,
                    "时间线点特效-" .. tostring(_____4E0A_4E0B_6587["当前阶段索引"]),
                    _____70B9_7279_6548
                )
            end
        end
    end
    if _____9636_6BB5["单位特效"] ~= nil and _____9636_6BB5["单位特效"]["模型"] ~= nil and _____9636_6BB5["单位特效"]["模型"] ~= "" then
        if _____6E05_7406 == nil then
            createTimedUnitEffect(_____5355_4F4D, _____9636_6BB5["单位特效"]["挂点"] or "origin", _____9636_6BB5["单位特效"]["模型"], _____9636_6BB5["单位特效"]["持续秒"])
        else
            local effectKey = (("时间线-" .. tostring(_____4E0A_4E0B_6587["阶段链ID"] or _____4E0A_4E0B_6587["时间线ID"])) .. "-") .. tostring(_____4E0A_4E0B_6587["当前阶段索引"])
            local _____7279_6548 = createUnitEffect(
                _____5355_4F4D,
                _____9636_6BB5["单位特效"]["挂点"] or "origin",
                _____9636_6BB5["单位特效"]["模型"],
                nil,
                effectKey
            )
            if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
                _____6E05_7406["登记清理"](
                    _____6E05_7406,
                    "时间线单位特效-" .. tostring(_____4E0A_4E0B_6587["当前阶段索引"]),
                    function()
                        destroyUnitEffect(_____5355_4F4D, effectKey)
                    end
                )
                if _____9636_6BB5["单位特效"]["持续秒"] ~= nil and _____9636_6BB5["单位特效"]["持续秒"] > 0 then
                    local _____5230_671FID = addDelayedCallback(
                        _____9636_6BB5["单位特效"]["持续秒"] * 1000,
                        function()
                            destroyUnitEffect(_____5355_4F4D, effectKey)
                        end
                    )
                    _____6E05_7406["登记延迟回调"](
                        _____6E05_7406,
                        "时间线单位特效到期-" .. tostring(_____4E0A_4E0B_6587["当前阶段索引"]),
                        _____5230_671FID
                    )
                end
            end
        end
    end
end
local function _____65F6_95F4_7EBF_6B7B_4EA1_6E05_7406(dyingUnit, _killingUnit)
    if not _____5355_4F4D_6709_6548_65F6_95F4_7EBF(dyingUnit) then
        return
    end
    local _____5217_8868 = _____6D3B_52A8_65F6_95F4_7EBF_8868[GetHandleId(dyingUnit)]
    if _____5217_8868 == nil then
        return
    end
    local _____5FEB_7167 = __TS__ArraySlice(_____5217_8868)
    do
        local i = 0
        while i < #_____5FEB_7167 do
            _____505C_6B62_6280_80FD_9636_6BB5_94FE(_____5FEB_7167[i + 1], "死亡")
            i = i + 1
        end
    end
end
local function _____65F6_95F4_7EBF_7ED3_675F_56DE_8C03_5305_88C5(_____5355_4F4D, _____539F_56E0, _____65F6_95F4_7EBFID, _____53C2_6570)
    _____79FB_9664_6D3B_52A8_65F6_95F4_7EBF(_____5355_4F4D, _____65F6_95F4_7EBFID)
    if _____53C2_6570["吟唱条"] ~= nil and _____541F_5531_65F6_95F4_7EBF_8868["常规技能"] == _____65F6_95F4_7EBFID then
        __TS__Delete(_____541F_5531_65F6_95F4_7EBF_8868, "常规技能")
        _____5173_95ED_541F_5531_6761(nil, "常规技能")
    end
    if _____53C2_6570["结束回调"] ~= nil then
        _____53C2_6570["结束回调"](_____5355_4F4D, _____539F_56E0, _____65F6_95F4_7EBFID)
    end
end
--- 创建并启动通用技能时间线。
-- 
-- @returns 时间线 ID（0 = 启动失败）
____exports["创建通用技能时间线"] = function(_____53C2_6570)
    if not _____5355_4F4D_6709_6548_65F6_95F4_7EBF(_____53C2_6570["单位"]) or _____53C2_6570["阶段"] == nil or #_____53C2_6570["阶段"] <= 0 then
        return 0
    end
    local _____9636_6BB5_5217_8868 = {}
    do
        local i = 0
        while i < #_____53C2_6570["阶段"] do
            local _____9636_6BB5 = _____53C2_6570["阶段"][i + 1]
            _____9636_6BB5_5217_8868[#_____9636_6BB5_5217_8868 + 1] = _____521B_5EFA_5EF6_8FDF_6267_884C_9636_6BB5(
                _____79D2_8F6C_6BEB_79D2(_____9636_6BB5["延迟秒"] or 0),
                function(_____4E0A_4E0B_6587, _____63A7_5236_5668)
                    _____64AD_653E_65F6_95F4_7EBF_9636_6BB5_8868_73B0(_____4E0A_4E0B_6587, _____9636_6BB5, _____53C2_6570["清理"])
                    local _____6570_636E = _____4E0A_4E0B_6587["数据"]
                    if _____9636_6BB5["业务"] ~= nil then
                        local _____5DF2_5B8C_6210 = false
                        _____9636_6BB5["业务"](
                            _____4E0A_4E0B_6587["单位"],
                            _____6570_636E,
                            function()
                                if _____5DF2_5B8C_6210 then
                                    return
                                end
                                _____5DF2_5B8C_6210 = true
                                _____63A7_5236_5668["完成当前阶段"](_____63A7_5236_5668)
                            end
                        )
                    else
                        _____63A7_5236_5668["完成当前阶段"](_____63A7_5236_5668)
                    end
                end,
                _____9636_6BB5["名称"],
                _____9636_6BB5["业务"] == nil
            )
            i = i + 1
        end
    end
    local _____5DF2_540C_6B65_7ED3_675F = false
    local _____65F6_95F4_7EBFID = _____5F00_59CB_6280_80FD_9636_6BB5_94FE(
        _____53C2_6570["单位"],
        _____9636_6BB5_5217_8868,
        {
            ["数据"] = _____53C2_6570["数据"] or ({}),
            ["结束回调"] = function(_____5355_4F4D, _____539F_56E0, ______9636_6BB5_94FEID, ______4E0A_4E0B_6587)
                _____5DF2_540C_6B65_7ED3_675F = true
                _____65F6_95F4_7EBF_7ED3_675F_56DE_8C03_5305_88C5(_____5355_4F4D, _____539F_56E0, ______9636_6BB5_94FEID, _____53C2_6570)
            end
        }
    )
    if _____65F6_95F4_7EBFID == 0 then
        return 0
    end
    if not _____5DF2_540C_6B65_7ED3_675F then
        _____767B_8BB0_6D3B_52A8_65F6_95F4_7EBF(_____53C2_6570["单位"], _____65F6_95F4_7EBFID)
    end
    if not _____5DF2_540C_6B65_7ED3_675F and _____53C2_6570["吟唱条"] ~= nil then
        _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({["总时长"] = _____53C2_6570["吟唱条"]["总时长"], ["标题"] = _____53C2_6570["吟唱条"]["标题"] or "技能", ["类型"] = _____53C2_6570["吟唱条"]["类型"] or "常规技能"})
        _____541F_5531_65F6_95F4_7EBF_8868["常规技能"] = _____65F6_95F4_7EBFID
    end
    if not _____5DF2_540C_6B65_7ED3_675F and _____53C2_6570["清理"] ~= nil then
        local ____self_12 = _____53C2_6570["清理"]
        ____self_12["登记清理"](
            ____self_12,
            "时间线-" .. tostring(_____65F6_95F4_7EBFID),
            function()
                ____exports["停止通用技能时间线"](_____65F6_95F4_7EBFID, "中断")
            end
        )
    end
    if not _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(_____65F6_95F4_7EBF_6B7B_4EA1_6E05_7406)
    end
    return _____65F6_95F4_7EBFID
end
return ____exports
