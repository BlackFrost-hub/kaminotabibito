local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__StringReplace = ____lualib.__TS__StringReplace
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____6CE8_9500_8303_56F4_76D1_542C, _____6E05_7406_654C_4EBA, _____5C1D_8BD5_6CE8_9500_654C_4EBA_6B7B_4EA1_76D1_542C, _____6E05_7406_9632_5B88_72B6_6001, _____521B_5EFA_5B88_62A4_76EE_6807, _____6CE8_518C_9760_8FD1_76D1_542C, _____91CD_65B0_521B_5EFA_9632_5B88_5165_53E3, ____on_901A_7528_9632_5B88_76EE_6807_88AB_51FB_6740, _____5B8C_6210_901A_7528_9632_5B88, _____5F00_59CB_4E0B_4E00_6CE2, ____on_901A_7528_9632_5B88_654C_4EBA_6B7B_4EA1, _____5F00_59CB_9632_5B88_6218_6597, _____64AD_653E_4E0B_4E00_6BB5_9760_8FD1_5E7F_64AD, ____on_901A_7528_9632_5B88_82F1_96C4_9760_8FD1, _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168, _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0, registerUnitInRangeTrigger, registerDeathListener, unregisterDeathListener, safeTriggerAddAction, safeDestroyTrigger, _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D, _____5E7F_64AD_5355_4F4D_63D0_793A, addDelayedCallback, stringToFourCCSafe, CreateTrigger, GetHandleId, GetTriggeringTrigger, GetTriggerUnit, IssueTargetOrder, PingMinimap, Player, _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID, _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID, _____9632_5B88_72B6_6001_8868, _____8303_56F4_89E6_53D1_5668_72B6_6001_8868, _____654C_4EBA_72B6_6001_8868, _____5DF2_6CE8_518C_654C_4EBA_6B7B_4EA1_76D1_542C
local ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D["创建可攻击机制单位"]
function _____6CE8_9500_8303_56F4_76D1_542C(_____72B6_6001)
    if _____72B6_6001["取消范围监听"] ~= nil then
        _____72B6_6001["取消范围监听"]()
    end
    _____72B6_6001["取消范围监听"] = nil
    if _____72B6_6001["范围触发器"] ~= nil and _____72B6_6001["范围触发器"] ~= 0 then
        __TS__Delete(
            _____8303_56F4_89E6_53D1_5668_72B6_6001_8868,
            GetHandleId(_____72B6_6001["范围触发器"])
        )
        safeDestroyTrigger(_____72B6_6001["范围触发器"])
    end
    _____72B6_6001["范围触发器"] = nil
end
function _____6E05_7406_654C_4EBA(_____72B6_6001)
    do
        local i = 0
        while i < #_____72B6_6001["敌人列表"] do
            do
                local _____654C_4EBA = _____72B6_6001["敌人列表"][i + 1]
                if _____654C_4EBA == nil or _____654C_4EBA == 0 then
                    goto __continue7
                end
                __TS__Delete(
                    _____654C_4EBA_72B6_6001_8868,
                    GetHandleId(_____654C_4EBA)
                )
                _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(_____654C_4EBA)
            end
            ::__continue7::
            i = i + 1
        end
    end
    _____72B6_6001["敌人列表"] = {}
    _____72B6_6001["当前存活敌人数"] = 0
end
function _____5C1D_8BD5_6CE8_9500_654C_4EBA_6B7B_4EA1_76D1_542C()
    for key in pairs(_____654C_4EBA_72B6_6001_8868) do
        if _____654C_4EBA_72B6_6001_8868[key] ~= nil then
            return
        end
    end
    if not _____5DF2_6CE8_518C_654C_4EBA_6B7B_4EA1_76D1_542C then
        return
    end
    unregisterDeathListener(____on_901A_7528_9632_5B88_654C_4EBA_6B7B_4EA1)
    _____5DF2_6CE8_518C_654C_4EBA_6B7B_4EA1_76D1_542C = false
end
function _____6E05_7406_9632_5B88_72B6_6001(_____72B6_6001, _____662F_5426_5220_9664_72B6_6001)
    _____72B6_6001["运行中"] = false
    _____72B6_6001["战斗中"] = false
    _____6CE8_9500_8303_56F4_76D1_542C(_____72B6_6001)
    _____6E05_7406_654C_4EBA(_____72B6_6001)
    local _____5B88_62A4_76EE_6807_5B9E_4F8B = _____72B6_6001["守护目标实例"]
    _____72B6_6001["守护目标实例"] = nil
    _____72B6_6001["守护目标单位"] = nil
    if _____5B88_62A4_76EE_6807_5B9E_4F8B ~= nil and _____5B88_62A4_76EE_6807_5B9E_4F8B["是否存活"](_____5B88_62A4_76EE_6807_5B9E_4F8B) then
        _____5B88_62A4_76EE_6807_5B9E_4F8B["销毁"](_____5B88_62A4_76EE_6807_5B9E_4F8B)
    end
    if _____662F_5426_5220_9664_72B6_6001 then
        __TS__Delete(_____9632_5B88_72B6_6001_8868, _____72B6_6001["配置"]["唯一键"])
    end
    _____5C1D_8BD5_6CE8_9500_654C_4EBA_6B7B_4EA1_76D1_542C()
end
function _____521B_5EFA_5B88_62A4_76EE_6807(_____72B6_6001)
    local _____53C2_6570 = _____72B6_6001["配置"]["守护目标"]
    local _____5B9E_4F8B = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D(__TS__ObjectAssign(
        {},
        _____53C2_6570,
        {
            ["所属玩家"] = Player(_____53C2_6570["所属玩家ID"] or _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID),
            X = _____72B6_6001["配置"]["中心X"],
            Y = _____72B6_6001["配置"]["中心Y"],
            ["on被击杀"] = ____on_901A_7528_9632_5B88_76EE_6807_88AB_51FB_6740,
            ["变量"] = _____72B6_6001
        }
    ))
    if _____5B9E_4F8B == nil then
        return false
    end
    _____72B6_6001["守护目标实例"] = _____5B9E_4F8B
    _____72B6_6001["守护目标单位"] = _____5B9E_4F8B["单位"]
    return true
end
function _____6CE8_518C_9760_8FD1_76D1_542C(_____72B6_6001)
    _____6CE8_9500_8303_56F4_76D1_542C(_____72B6_6001)
    if _____72B6_6001["守护目标单位"] == nil or _____72B6_6001["守护目标单位"] == 0 then
        return
    end
    local _____89E6_53D1_5668 = CreateTrigger()
    if _____89E6_53D1_5668 == nil or _____89E6_53D1_5668 == 0 then
        return
    end
    if safeTriggerAddAction(_____89E6_53D1_5668, ____on_901A_7528_9632_5B88_82F1_96C4_9760_8FD1) == nil then
        safeDestroyTrigger(_____89E6_53D1_5668)
        return
    end
    _____72B6_6001["范围触发器"] = _____89E6_53D1_5668
    _____8303_56F4_89E6_53D1_5668_72B6_6001_8868[GetHandleId(_____89E6_53D1_5668)] = _____72B6_6001
    _____72B6_6001["取消范围监听"] = registerUnitInRangeTrigger(
        _____89E6_53D1_5668,
        _____72B6_6001["守护目标单位"],
        _____72B6_6001["配置"]["触发范围"],
        nil,
        false
    )
end
function _____91CD_65B0_521B_5EFA_9632_5B88_5165_53E3(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or not _____72B6_6001["运行中"] or _____72B6_6001["已完成"] or _____72B6_6001["守护目标单位"] ~= nil then
        return
    end
    if not _____521B_5EFA_5B88_62A4_76EE_6807(_____72B6_6001) then
        return
    end
    _____6CE8_518C_9760_8FD1_76D1_542C(_____72B6_6001)
    local _____63D0_793A = _____72B6_6001["配置"]["重试提示"]
    if _____63D0_793A ~= nil then
        _____5E7F_64AD_5355_4F4D_63D0_793A(_____72B6_6001["守护目标单位"], _____63D0_793A["文本"], _____63D0_793A["持续毫秒"])
    end
    local _____4FE1_53F7_79D2 = _____72B6_6001["配置"]["小地图信号秒"] or 0
    if _____4FE1_53F7_79D2 > 0 then
        PingMinimap(_____72B6_6001["配置"]["中心X"], _____72B6_6001["配置"]["中心Y"], _____4FE1_53F7_79D2)
    end
end
function ____on_901A_7528_9632_5B88_76EE_6807_88AB_51FB_6740(_____6B7B_4EA1_5355_4F4D, ______51FB_6740_8005, variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or not _____72B6_6001["运行中"] or _____72B6_6001["已完成"] or _____6B7B_4EA1_5355_4F4D ~= _____72B6_6001["守护目标单位"] then
        return
    end
    local _____63D0_793A = _____72B6_6001["配置"]["失败提示"]
    if _____63D0_793A ~= nil then
        _____5E7F_64AD_5355_4F4D_63D0_793A(_____6B7B_4EA1_5355_4F4D, _____63D0_793A["文本"], _____63D0_793A["持续毫秒"])
    end
    _____72B6_6001["守护目标实例"] = nil
    _____72B6_6001["守护目标单位"] = nil
    _____72B6_6001["战斗中"] = false
    _____72B6_6001["当前波次索引"] = 0
    _____6CE8_9500_8303_56F4_76D1_542C(_____72B6_6001)
    _____6E05_7406_654C_4EBA(_____72B6_6001)
    _____5C1D_8BD5_6CE8_9500_654C_4EBA_6B7B_4EA1_76D1_542C()
    if _____72B6_6001["配置"]["on失败"] ~= nil then
        _____72B6_6001["配置"]["on失败"](_____72B6_6001["配置"]["上下文"])
    end
    addDelayedCallback(_____72B6_6001["配置"]["重试延迟毫秒"] or 5000, _____91CD_65B0_521B_5EFA_9632_5B88_5165_53E3, _____72B6_6001)
end
function _____5B8C_6210_901A_7528_9632_5B88(_____72B6_6001)
    if not _____72B6_6001["运行中"] or _____72B6_6001["已完成"] then
        return
    end
    _____72B6_6001["战斗中"] = false
    _____72B6_6001["已完成"] = true
    _____6CE8_9500_8303_56F4_76D1_542C(_____72B6_6001)
    _____5C1D_8BD5_6CE8_9500_654C_4EBA_6B7B_4EA1_76D1_542C()
    local _____63D0_793A = _____72B6_6001["配置"]["完成提示"]
    if _____63D0_793A ~= nil then
        _____5E7F_64AD_5355_4F4D_63D0_793A(_____72B6_6001["守护目标单位"], _____63D0_793A["文本"], _____63D0_793A["持续毫秒"])
    end
    if _____72B6_6001["配置"]["on完成"] ~= nil then
        _____72B6_6001["配置"]["on完成"](_____72B6_6001["配置"]["上下文"])
    end
end
function _____5F00_59CB_4E0B_4E00_6CE2(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or not _____72B6_6001["运行中"] or not _____72B6_6001["战斗中"] or _____72B6_6001["已完成"] or _____72B6_6001["当前存活敌人数"] > 0 then
        return
    end
    if _____72B6_6001["当前波次索引"] >= #_____72B6_6001["配置"]["波次"] then
        _____5B8C_6210_901A_7528_9632_5B88(_____72B6_6001)
        return
    end
    local _____6CE2_6B21 = _____72B6_6001["配置"]["波次"][_____72B6_6001["当前波次索引"] + 1]
    _____72B6_6001["当前波次索引"] = _____72B6_6001["当前波次索引"] + 1
    local _____51FA_751F_5E8F_53F7 = 0
    do
        local i = 0
        while i < #_____6CE2_6B21 do
            do
                local _____5355_4F4D_914D_7F6E = _____6CE2_6B21[i + 1]
                local _____5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____5355_4F4D_914D_7F6E["单位ID"])
                if _____5355_4F4D_7C7B_578BID == 0 then
                    goto __continue40
                end
                do
                    local j = 0
                    while j < _____5355_4F4D_914D_7F6E["数量"] do
                        do
                            local _____504F_79FB = _____72B6_6001["配置"]["出生偏移"][_____51FA_751F_5E8F_53F7 % #_____72B6_6001["配置"]["出生偏移"] + 1]
                            _____51FA_751F_5E8F_53F7 = _____51FA_751F_5E8F_53F7 + 1
                            local _____654C_4EBA = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
                                Player(_____72B6_6001["配置"]["敌对玩家ID"] or _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
                                _____5355_4F4D_7C7B_578BID,
                                _____72B6_6001["配置"]["中心X"] + _____504F_79FB.X,
                                _____72B6_6001["配置"]["中心Y"] + _____504F_79FB.Y,
                                270
                            )
                            if _____654C_4EBA == nil or _____654C_4EBA == 0 then
                                goto __continue43
                            end
                            local ____72B6_6001__654C_4EBA_5217_8868_9 = _____72B6_6001["敌人列表"]
                            ____72B6_6001__654C_4EBA_5217_8868_9[#____72B6_6001__654C_4EBA_5217_8868_9 + 1] = _____654C_4EBA
                            _____72B6_6001["当前存活敌人数"] = _____72B6_6001["当前存活敌人数"] + 1
                            _____654C_4EBA_72B6_6001_8868[GetHandleId(_____654C_4EBA)] = _____72B6_6001
                            IssueTargetOrder(_____654C_4EBA, "attack", _____72B6_6001["守护目标单位"])
                        end
                        ::__continue43::
                        j = j + 1
                    end
                end
            end
            ::__continue40::
            i = i + 1
        end
    end
    if not _____5DF2_6CE8_518C_654C_4EBA_6B7B_4EA1_76D1_542C and _____72B6_6001["当前存活敌人数"] > 0 then
        registerDeathListener(____on_901A_7528_9632_5B88_654C_4EBA_6B7B_4EA1)
        _____5DF2_6CE8_518C_654C_4EBA_6B7B_4EA1_76D1_542C = true
    end
    local _____6A21_677F = _____72B6_6001["配置"]["波次提示模板"]
    if _____6A21_677F ~= nil and _____6A21_677F ~= "" then
        _____5E7F_64AD_5355_4F4D_63D0_793A(
            _____72B6_6001["守护目标单位"],
            __TS__StringReplace(
                _____6A21_677F,
                "{波次}",
                tostring(_____72B6_6001["当前波次索引"])
            ),
            4200
        )
    end
    if _____72B6_6001["当前存活敌人数"] <= 0 then
        addDelayedCallback(1000, _____5F00_59CB_4E0B_4E00_6CE2, _____72B6_6001)
    end
end
function ____on_901A_7528_9632_5B88_654C_4EBA_6B7B_4EA1(_____6B7B_4EA1_5355_4F4D, ______51FB_6740_8005)
    if _____6B7B_4EA1_5355_4F4D == nil or _____6B7B_4EA1_5355_4F4D == 0 then
        return
    end
    local _____5355_4F4D_53E5_67C4ID = GetHandleId(_____6B7B_4EA1_5355_4F4D)
    local _____72B6_6001 = _____654C_4EBA_72B6_6001_8868[_____5355_4F4D_53E5_67C4ID]
    if _____72B6_6001 == nil or not _____72B6_6001["战斗中"] or _____72B6_6001["当前存活敌人数"] <= 0 then
        return
    end
    __TS__Delete(_____654C_4EBA_72B6_6001_8868, _____5355_4F4D_53E5_67C4ID)
    do
        local i = 0
        while i < #_____72B6_6001["敌人列表"] do
            do
                if _____72B6_6001["敌人列表"][i + 1] ~= _____6B7B_4EA1_5355_4F4D then
                    goto __continue52
                end
                __TS__ArraySplice(_____72B6_6001["敌人列表"], i, 1)
                _____72B6_6001["当前存活敌人数"] = _____72B6_6001["当前存活敌人数"] - 1
                break
            end
            ::__continue52::
            i = i + 1
        end
    end
    if _____72B6_6001["当前存活敌人数"] <= 0 then
        _____5C1D_8BD5_6CE8_9500_654C_4EBA_6B7B_4EA1_76D1_542C()
        addDelayedCallback(_____72B6_6001["配置"]["波次间隔毫秒"] or 2500, _____5F00_59CB_4E0B_4E00_6CE2, _____72B6_6001)
    end
end
function _____5F00_59CB_9632_5B88_6218_6597(_____72B6_6001)
    if not _____72B6_6001["运行中"] or _____72B6_6001["已完成"] or _____72B6_6001["战斗中"] or _____72B6_6001["守护目标单位"] == nil then
        return
    end
    _____72B6_6001["战斗中"] = true
    _____72B6_6001["当前波次索引"] = 0
    _____72B6_6001["当前存活敌人数"] = 0
    _____5F00_59CB_4E0B_4E00_6CE2(_____72B6_6001)
end
function _____64AD_653E_4E0B_4E00_6BB5_9760_8FD1_5E7F_64AD(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or not _____72B6_6001["运行中"] or _____72B6_6001["已完成"] or _____72B6_6001["守护目标单位"] == nil then
        return
    end
    local _____5E7F_64AD_5217_8868 = _____72B6_6001["配置"]["靠近广播"] or ({})
    if _____72B6_6001["当前广播索引"] >= #_____5E7F_64AD_5217_8868 then
        _____5F00_59CB_9632_5B88_6218_6597(_____72B6_6001)
        return
    end
    local _____5E7F_64AD = _____5E7F_64AD_5217_8868[_____72B6_6001["当前广播索引"] + 1]
    _____72B6_6001["当前广播索引"] = _____72B6_6001["当前广播索引"] + 1
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____72B6_6001["守护目标单位"], _____5E7F_64AD["文本"], _____5E7F_64AD["持续毫秒"])
    addDelayedCallback(_____5E7F_64AD["持续毫秒"] + 400, _____64AD_653E_4E0B_4E00_6BB5_9760_8FD1_5E7F_64AD, _____72B6_6001)
end
function ____on_901A_7528_9632_5B88_82F1_96C4_9760_8FD1()
    local _____89E6_53D1_5668 = GetTriggeringTrigger()
    if _____89E6_53D1_5668 == nil or _____89E6_53D1_5668 == 0 then
        return
    end
    local _____72B6_6001 = _____8303_56F4_89E6_53D1_5668_72B6_6001_8868[GetHandleId(_____89E6_53D1_5668)]
    if _____72B6_6001 == nil or not _____72B6_6001["运行中"] or _____72B6_6001["已完成"] or _____72B6_6001["战斗中"] then
        return
    end
    local _____89E6_53D1_5355_4F4D = GetTriggerUnit()
    if _____89E6_53D1_5355_4F4D == nil or _____89E6_53D1_5355_4F4D == 0 or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____89E6_53D1_5355_4F4D) then
        return
    end
    _____6CE8_9500_8303_56F4_76D1_542C(_____72B6_6001)
    _____72B6_6001["当前广播索引"] = 0
    _____64AD_653E_4E0B_4E00_6BB5_9760_8FD1_5E7F_64AD(_____72B6_6001)
end
____exports["停止通用防守"] = function(_____552F_4E00_952E)
    local _____72B6_6001 = _____9632_5B88_72B6_6001_8868[_____552F_4E00_952E]
    if _____72B6_6001 ~= nil then
        _____6E05_7406_9632_5B88_72B6_6001(_____72B6_6001, true)
    end
end
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
_____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_0["创建单位并登记排泄安全"]
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
_____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_1["立即移除单位并取消排泄登记"]
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
registerUnitInRangeTrigger = ____require_result_2.registerUnitInRangeTrigger
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
registerDeathListener = ____require_result_3.registerDeathListener
unregisterDeathListener = ____require_result_3.unregisterDeathListener
local ____require_result_4 = require("系统.00．核心系统.07．联机安全工具")
safeTriggerAddAction = ____require_result_4.safeTriggerAddAction
safeDestroyTrigger = ____require_result_4.safeDestroyTrigger
local ____require_result_5 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
_____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_5["是玩家英雄组单位"]
local ____require_result_6 = require("系统.09．表现系统.06．广播提示消息.index")
_____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_6["广播单位提示"]
local ____require_result_7 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_7.addDelayedCallback
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
stringToFourCCSafe = ____require_result_8.stringToFourCCSafe
CreateTrigger = jass.CreateTrigger
GetHandleId = jass.GetHandleId
GetTriggeringTrigger = jass.GetTriggeringTrigger
GetTriggerUnit = jass.GetTriggerUnit
IssueTargetOrder = jass.IssueTargetOrder
PingMinimap = jass.PingMinimap
Player = jass.Player
_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = jass.PLAYER_NEUTRAL_AGGRESSIVE
_____4E2D_7ACB_88AB_52A8_73A9_5BB6ID = jass.PLAYER_NEUTRAL_PASSIVE
_____9632_5B88_72B6_6001_8868 = {}
_____8303_56F4_89E6_53D1_5668_72B6_6001_8868 = {}
_____654C_4EBA_72B6_6001_8868 = {}
_____5DF2_6CE8_518C_654C_4EBA_6B7B_4EA1_76D1_542C = false
____exports["启动通用防守"] = function(_____914D_7F6E)
    ____exports["停止通用防守"](_____914D_7F6E["唯一键"])
    if _____914D_7F6E["唯一键"] == "" or #_____914D_7F6E["波次"] <= 0 or #_____914D_7F6E["出生偏移"] <= 0 then
        return false
    end
    local _____72B6_6001 = {
        ["配置"] = _____914D_7F6E,
        ["运行中"] = true,
        ["战斗中"] = false,
        ["已完成"] = false,
        ["当前波次索引"] = 0,
        ["当前广播索引"] = 0,
        ["当前存活敌人数"] = 0,
        ["守护目标单位"] = nil,
        ["敌人列表"] = {},
        ["范围触发器"] = nil
    }
    _____9632_5B88_72B6_6001_8868[_____914D_7F6E["唯一键"]] = _____72B6_6001
    if not _____521B_5EFA_5B88_62A4_76EE_6807(_____72B6_6001) then
        _____6E05_7406_9632_5B88_72B6_6001(_____72B6_6001, true)
        return false
    end
    _____6CE8_518C_9760_8FD1_76D1_542C(_____72B6_6001)
    local _____63D0_793A = _____914D_7F6E["接取提示"]
    if _____63D0_793A ~= nil then
        _____5E7F_64AD_5355_4F4D_63D0_793A(_____72B6_6001["守护目标单位"], _____63D0_793A["文本"], _____63D0_793A["持续毫秒"])
    end
    local _____4FE1_53F7_79D2 = _____914D_7F6E["小地图信号秒"] or 0
    if _____4FE1_53F7_79D2 > 0 then
        PingMinimap(_____914D_7F6E["中心X"], _____914D_7F6E["中心Y"], _____4FE1_53F7_79D2)
    end
    return true
end
return ____exports
