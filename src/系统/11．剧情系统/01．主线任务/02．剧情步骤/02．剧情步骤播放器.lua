local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local _____8BA1_7B97_6B65_9AA4_6301_7EED_65F6_95F4, _____5B89_6392_4E0B_4E00_6B65, _____7ED3_675F_5F53_524D_5267_60C5_7247_6BB5, _____83B7_53D6_6267_884C_4E3B_7EBF_5267_60C5_52A8_4F5C_51FD_6570, _____6267_884C_5267_60C5_5EF6_8FDF_4EFB_52A1, _____5C1D_8BD5_505C_6B62_5267_60C5_5EF6_8FDF_4EFB_52A1_626B_63CF, _____6E05_7406_5267_60C5_5EF6_8FDF_4EFB_52A1, ____on_5267_60C5_5EF6_8FDF_4EFB_52A1_626B_63CF, _____6DFB_52A0_5267_60C5_5EF6_8FDF_4EFB_52A1, _____6267_884C_5BF9_767D_6B65_9AA4, _____8BFB_53D6_5F53_524D_5267_60C5_89E6_53D1_5355_4F4D, _____8BFB_53D6_8BF4_8BDD_8005_5355_4F4D, _____6267_884CUIDialog_6B65_9AA4, _____6267_884CUI_5E7F_64AD_6B65_9AA4, _____6267_884C_5E7F_64AD_6B65_9AA4, _____6267_884C_7B49_5F85_6B65_9AA4, _____6267_884C_81EA_5B9A_4E49_52A8_4F5C_6B65_9AA4, _____8BFB_53D6_5355_4F4D_5F15_7528, _____542F_52A8_5267_60C5Boss_6218, _____6267_884CBoss_6218_542F_52A8_6B65_9AA4, _____6267_884C_7ED9_7269_54C1_6B65_9AA4, _____6267_884C_5F53_524D_5267_60C5_6B65_9AA4, _____79FB_9664_5355_4F4D_6682_505C, _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90, addPeriodicCallback, removePeriodicCallback, getServerTime, TransmissionFromUnitWithNameBJ, CinematicModeBJ, GetPlayersAll, _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6, _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6, _____5E7F_64AD_5355_4F4D_63D0_793A, YDUserDataGetSafe, YDUserDataSetSafe, _____542F_52A8Boss_6218_8FD0_884C, _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E, _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8, _____662F_5426_5DF2_767B_8BB0Boss_81EA_52A8_6280_80FD, debugLogForce, Player, SetUnitInvulnerable, bj_TIMETYPE_SET, _____5267_60C5_64AD_653E_5668_6A21_5757_540D, ____Boss_6218_8868_540D, ____Boss_6218_7ED1_5B9A_5355_4F4D_5B57_6BB5, ____Boss_6218_89E6_53D1_73A9_5BB6_5B57_6BB5, _____9ED8_8BA4_5E7F_64AD_5934_50CF_8DEF_5F84, _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001, _____5F53_524D_7247_6BB5, _____5267_60C5_5EF6_8FDF_4EFB_52A1_5217_8868, _____5267_60C5_5EF6_8FDF_4EFB_52A1_626B_63CF_56DE_8C03ID, _____6267_884C_4E3B_7EBF_5267_60C5_52A8_4F5C_51FD_6570
local ____01_FF0E_5267_60C5_7247_6BB5_914D_7F6E_8868 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．剧情片段配置表")
local _____4E3B_7EBF_5267_60C5_7247_6BB5_914D_7F6E_8868 = ____01_FF0E_5267_60C5_7247_6BB5_914D_7F6E_8868.default
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入当前剧情动作上下文"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____6309_540D_5B57_7ED9_89E6_53D1_5355_4F4D_7269_54C1 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["按名字给触发单位物品"]
local _____6267_884C_901A_7528_5267_60C5_52A8_4F5C = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["执行通用剧情动作"]
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
function _____8BA1_7B97_6B65_9AA4_6301_7EED_65F6_95F4(seconds)
    local _____500D_901F = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前倍速"] > 0 and _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前倍速"] or 1
    local result = seconds / _____500D_901F
    if result < 0.03 then
        return 0.03
    end
    return result
end
function _____5B89_6392_4E0B_4E00_6B65(delaySeconds)
    if not _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["是否正在播放"] then
        return
    end
    _____6DFB_52A0_5267_60C5_5EF6_8FDF_4EFB_52A1({
        ["到期时间毫秒"] = getServerTime() + _____8BA1_7B97_6B65_9AA4_6301_7EED_65F6_95F4(delaySeconds) * 1000,
        ["播放世代"] = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["播放世代"],
        ["类型"] = "下一步"
    })
end
function _____7ED3_675F_5F53_524D_5267_60C5_7247_6BB5()
    local _____7247_6BB5ID = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前片段ID"] or ""
    local _____64AD_653E_4E16_4EE3 = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["播放世代"]
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["是否正在播放"] = false
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["是否请求跳过"] = false
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] = 0
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前片段ID"] = nil
    _____5F53_524D_7247_6BB5 = nil
    _____6E05_7406_5267_60C5_5EF6_8FDF_4EFB_52A1(_____64AD_653E_4E16_4EE3)
    CinematicModeBJ(
        false,
        GetPlayersAll()
    )
    if _____7247_6BB5ID ~= "" then
        debugLogForce(_____5267_60C5_64AD_653E_5668_6A21_5757_540D, "剧情片段结束", _____7247_6BB5ID)
    end
end
function _____83B7_53D6_6267_884C_4E3B_7EBF_5267_60C5_52A8_4F5C_51FD_6570()
    if _____6267_884C_4E3B_7EBF_5267_60C5_52A8_4F5C_51FD_6570 == nil then
        local _____6A21_5757 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.04．主线剧情动作注册表")
        _____6267_884C_4E3B_7EBF_5267_60C5_52A8_4F5C_51FD_6570 = _____6A21_5757["执行主线剧情动作"]
    end
    return _____6267_884C_4E3B_7EBF_5267_60C5_52A8_4F5C_51FD_6570
end
function _____6267_884C_5267_60C5_5EF6_8FDF_4EFB_52A1(_____4E0A_4E0B_6587)
    if not _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["是否正在播放"] then
        return
    end
    if _____4E0A_4E0B_6587["播放世代"] ~= _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["播放世代"] then
        return
    end
    if _____4E0A_4E0B_6587["类型"] == "下一步" then
        _____6267_884C_5F53_524D_5267_60C5_6B65_9AA4()
        return
    end
    if _____4E0A_4E0B_6587["动作ID"] == nil or _____4E0A_4E0B_6587["参数"] == nil then
        return
    end
    _____83B7_53D6_6267_884C_4E3B_7EBF_5267_60C5_52A8_4F5C_51FD_6570()(_____4E0A_4E0B_6587["动作ID"], _____4E0A_4E0B_6587["参数"])
end
function _____5C1D_8BD5_505C_6B62_5267_60C5_5EF6_8FDF_4EFB_52A1_626B_63CF()
    if #_____5267_60C5_5EF6_8FDF_4EFB_52A1_5217_8868 > 0 or _____5267_60C5_5EF6_8FDF_4EFB_52A1_626B_63CF_56DE_8C03ID == 0 then
        return
    end
    removePeriodicCallback(_____5267_60C5_5EF6_8FDF_4EFB_52A1_626B_63CF_56DE_8C03ID)
    _____5267_60C5_5EF6_8FDF_4EFB_52A1_626B_63CF_56DE_8C03ID = 0
end
function _____6E05_7406_5267_60C5_5EF6_8FDF_4EFB_52A1(_____64AD_653E_4E16_4EE3)
    local _____5199_5165_7D22_5F15 = 0
    do
        local i = 0
        while i < #_____5267_60C5_5EF6_8FDF_4EFB_52A1_5217_8868 do
            do
                local _____4EFB_52A1 = _____5267_60C5_5EF6_8FDF_4EFB_52A1_5217_8868[i + 1]
                if _____4EFB_52A1["播放世代"] == _____64AD_653E_4E16_4EE3 then
                    goto __continue27
                end
                _____5267_60C5_5EF6_8FDF_4EFB_52A1_5217_8868[_____5199_5165_7D22_5F15 + 1] = _____4EFB_52A1
                _____5199_5165_7D22_5F15 = _____5199_5165_7D22_5F15 + 1
            end
            ::__continue27::
            i = i + 1
        end
    end
    do
        local i = #_____5267_60C5_5EF6_8FDF_4EFB_52A1_5217_8868 - 1
        while i >= _____5199_5165_7D22_5F15 do
            table.remove(_____5267_60C5_5EF6_8FDF_4EFB_52A1_5217_8868)
            i = i - 1
        end
    end
    _____5C1D_8BD5_505C_6B62_5267_60C5_5EF6_8FDF_4EFB_52A1_626B_63CF()
end
function ____on_5267_60C5_5EF6_8FDF_4EFB_52A1_626B_63CF()
    local _____5F53_524D_65F6_95F4_6BEB_79D2 = getServerTime()
    local _____5230_671F_4EFB_52A1 = {}
    local _____5199_5165_7D22_5F15 = 0
    do
        local i = 0
        while i < #_____5267_60C5_5EF6_8FDF_4EFB_52A1_5217_8868 do
            do
                local _____4EFB_52A1 = _____5267_60C5_5EF6_8FDF_4EFB_52A1_5217_8868[i + 1]
                if _____5F53_524D_65F6_95F4_6BEB_79D2 >= _____4EFB_52A1["到期时间毫秒"] then
                    _____5230_671F_4EFB_52A1[#_____5230_671F_4EFB_52A1 + 1] = _____4EFB_52A1
                    goto __continue33
                end
                _____5267_60C5_5EF6_8FDF_4EFB_52A1_5217_8868[_____5199_5165_7D22_5F15 + 1] = _____4EFB_52A1
                _____5199_5165_7D22_5F15 = _____5199_5165_7D22_5F15 + 1
            end
            ::__continue33::
            i = i + 1
        end
    end
    do
        local i = #_____5267_60C5_5EF6_8FDF_4EFB_52A1_5217_8868 - 1
        while i >= _____5199_5165_7D22_5F15 do
            table.remove(_____5267_60C5_5EF6_8FDF_4EFB_52A1_5217_8868)
            i = i - 1
        end
    end
    do
        local i = 0
        while i < #_____5230_671F_4EFB_52A1 do
            _____6267_884C_5267_60C5_5EF6_8FDF_4EFB_52A1(_____5230_671F_4EFB_52A1[i + 1])
            i = i + 1
        end
    end
    _____5C1D_8BD5_505C_6B62_5267_60C5_5EF6_8FDF_4EFB_52A1_626B_63CF()
end
function _____6DFB_52A0_5267_60C5_5EF6_8FDF_4EFB_52A1(_____4EFB_52A1)
    _____5267_60C5_5EF6_8FDF_4EFB_52A1_5217_8868[#_____5267_60C5_5EF6_8FDF_4EFB_52A1_5217_8868 + 1] = _____4EFB_52A1
    if _____5267_60C5_5EF6_8FDF_4EFB_52A1_626B_63CF_56DE_8C03ID == 0 then
        _____5267_60C5_5EF6_8FDF_4EFB_52A1_626B_63CF_56DE_8C03ID = addPeriodicCallback(10, ____on_5267_60C5_5EF6_8FDF_4EFB_52A1_626B_63CF)
    end
end
function _____6267_884C_5BF9_767D_6B65_9AA4(_____6B65_9AA4)
    if _____6B65_9AA4.type ~= "dialog" then
        return
    end
    local _____6301_7EED_65F6_95F4 = _____6B65_9AA4["持续时间"] or 3
    local _____4E0B_4E00_6B65_5EF6_8FDF = _____6B65_9AA4["原生电影阻塞"] == false and 0 or _____6301_7EED_65F6_95F4
    if _____6B65_9AA4["使用原生电影系统"] == true then
        local _____8BF4_8BDD_8005 = _____6B65_9AA4["说话者"] or "系统"
        local _____6587_672C = _____6B65_9AA4["文本"]
        TransmissionFromUnitWithNameBJ(
            GetPlayersAll(),
            nil,
            _____8BF4_8BDD_8005,
            nil,
            _____6587_672C,
            bj_TIMETYPE_SET,
            _____8BA1_7B97_6B65_9AA4_6301_7EED_65F6_95F4(_____6301_7EED_65F6_95F4),
            false
        )
        _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] + 1
        _____5B89_6392_4E0B_4E00_6B65(_____4E0B_4E00_6B65_5EF6_8FDF)
        return
    end
    _____6267_884CUIDialog_6B65_9AA4(_____6B65_9AA4)
end
function _____8BFB_53D6_5F53_524D_5267_60C5_89E6_53D1_5355_4F4D()
    return YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit")
end
function _____8BFB_53D6_8BF4_8BDD_8005_5355_4F4D(_____8BF4_8BDD_8005, _____8BF4_8BDD_8005_5F15_7528)
    local _____5F15_7528_5355_4F4D = _____8BFB_53D6_5355_4F4D_5F15_7528(_____8BF4_8BDD_8005_5F15_7528)
    if _____5F15_7528_5355_4F4D ~= nil and _____5F15_7528_5355_4F4D ~= 0 then
        return _____5F15_7528_5355_4F4D
    end
    if _____8BF4_8BDD_8005 == "玩家" then
        local _____89E6_53D1_5355_4F4D = _____8BFB_53D6_5F53_524D_5267_60C5_89E6_53D1_5355_4F4D()
        if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
            return _____89E6_53D1_5355_4F4D
        end
    end
    if _____8BF4_8BDD_8005 ~= nil and _____8BF4_8BDD_8005 ~= "" then
        local _____8FD0_884C_65F6_5355_4F4D = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("主线NPC." .. _____8BF4_8BDD_8005)
        if _____8FD0_884C_65F6_5355_4F4D ~= nil and _____8FD0_884C_65F6_5355_4F4D ~= 0 then
            return _____8FD0_884C_65F6_5355_4F4D
        end
        local _____4E3B_7EBFNPC_5355_4F4D = YDUserDataGetSafe("string", "主线NPC", _____8BF4_8BDD_8005, "unit")
        if _____4E3B_7EBFNPC_5355_4F4D ~= nil and _____4E3B_7EBFNPC_5355_4F4D ~= 0 then
            return _____4E3B_7EBFNPC_5355_4F4D
        end
        local ____Boss_5355_4F4D = YDUserDataGetSafe("string", "Boss", _____8BF4_8BDD_8005, "unit")
        if ____Boss_5355_4F4D ~= nil and ____Boss_5355_4F4D ~= 0 then
            return ____Boss_5355_4F4D
        end
    end
    return nil
end
function _____6267_884CUIDialog_6B65_9AA4(_____6B65_9AA4)
    if _____6B65_9AA4.type ~= "dialog" then
        return
    end
    local _____8BF4_8BDD_8005 = _____6B65_9AA4["说话者"] or "系统"
    local _____6587_672C = _____6B65_9AA4["文本"]
    local _____6301_7EED_65F6_95F4 = _____6B65_9AA4["持续时间"] or 3
    local _____6301_7EED_65F6_95F4_6BEB_79D2 = _____6301_7EED_65F6_95F4 * 1000
    local _____8BF4_8BDD_8005_5355_4F4D = _____8BFB_53D6_8BF4_8BDD_8005_5355_4F4D(_____8BF4_8BDD_8005, _____6B65_9AA4["说话者引用"])
    if _____8BF4_8BDD_8005_5355_4F4D ~= nil and _____8BF4_8BDD_8005_5355_4F4D ~= 0 then
        do
            local i = 0
            while i < 4 do
                _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
                    Player(i),
                    _____8BF4_8BDD_8005_5355_4F4D,
                    _____6587_672C,
                    _____6301_7EED_65F6_95F4_6BEB_79D2
                )
                i = i + 1
            end
        end
    else
        do
            local i = 0
            while i < 4 do
                _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6(
                    Player(i),
                    _____9ED8_8BA4_5E7F_64AD_5934_50CF_8DEF_5F84,
                    (_____8BF4_8BDD_8005 .. "：") .. _____6587_672C,
                    _____6301_7EED_65F6_95F4_6BEB_79D2
                )
                i = i + 1
            end
        end
    end
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] + 1
    _____5B89_6392_4E0B_4E00_6B65(_____6B65_9AA4["原生电影阻塞"] == false and 0 or _____6301_7EED_65F6_95F4)
end
function _____6267_884CUI_5E7F_64AD_6B65_9AA4(_____6B65_9AA4)
    if _____6B65_9AA4.type ~= "broadcast" then
        return
    end
    local _____6587_672C = _____6B65_9AA4["文本"]
    local _____6301_7EED_65F6_95F4_6BEB_79D2 = (_____6B65_9AA4["持续时间"] or 3) * 1000
    local _____6765_6E90_5355_4F4D = _____8BFB_53D6_5355_4F4D_5F15_7528(_____6B65_9AA4["来源单位引用"])
    if _____6765_6E90_5355_4F4D ~= nil and _____6765_6E90_5355_4F4D ~= 0 then
        _____5E7F_64AD_5355_4F4D_63D0_793A(_____6765_6E90_5355_4F4D, _____6587_672C, _____6301_7EED_65F6_95F4_6BEB_79D2)
        return
    end
    local _____5934_50CF_8DEF_5F84 = _____6B65_9AA4["头像路径"] or _____9ED8_8BA4_5E7F_64AD_5934_50CF_8DEF_5F84
    do
        local i = 0
        while i < 4 do
            _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6(
                Player(i),
                _____5934_50CF_8DEF_5F84,
                _____6587_672C,
                _____6301_7EED_65F6_95F4_6BEB_79D2
            )
            i = i + 1
        end
    end
end
function _____6267_884C_5E7F_64AD_6B65_9AA4(_____6B65_9AA4)
    if _____6B65_9AA4.type ~= "broadcast" then
        return
    end
    local _____6301_7EED_65F6_95F4 = _____6B65_9AA4["持续时间"] or 3
    if _____6B65_9AA4["广播渠道"] == "ui" then
        _____6267_884CUI_5E7F_64AD_6B65_9AA4(_____6B65_9AA4)
    else
        local _____8BF4_8BDD_8005 = _____6B65_9AA4["说话者"] or "系统"
        TransmissionFromUnitWithNameBJ(
            GetPlayersAll(),
            nil,
            _____8BF4_8BDD_8005,
            nil,
            _____6B65_9AA4["文本"],
            bj_TIMETYPE_SET,
            _____8BA1_7B97_6B65_9AA4_6301_7EED_65F6_95F4(_____6301_7EED_65F6_95F4),
            false
        )
    end
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] + 1
    _____5B89_6392_4E0B_4E00_6B65(_____6301_7EED_65F6_95F4)
end
function _____6267_884C_7B49_5F85_6B65_9AA4(_____6B65_9AA4)
    if _____6B65_9AA4.type ~= "wait" then
        return
    end
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] + 1
    _____5B89_6392_4E0B_4E00_6B65(_____6B65_9AA4["持续时间"])
end
function _____6267_884C_81EA_5B9A_4E49_52A8_4F5C_6B65_9AA4(_____6B65_9AA4)
    if _____6B65_9AA4.type ~= "runAction" then
        return
    end
    local _____53C2_6570 = _____6B65_9AA4["参数"] or ({})
    if _____53C2_6570["挂点"] == "absoluteTime" then
        _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] + 1
        _____6267_884C_5F53_524D_5267_60C5_6B65_9AA4()
        return
    end
    _____83B7_53D6_6267_884C_4E3B_7EBF_5267_60C5_52A8_4F5C_51FD_6570()(_____6B65_9AA4["动作ID"], _____53C2_6570)
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] + 1
    _____6267_884C_5F53_524D_5267_60C5_6B65_9AA4()
end
function _____8BFB_53D6_5355_4F4D_5F15_7528(_____5F15_7528)
    if _____5F15_7528 == nil or _____5F15_7528 == "" then
        return nil
    end
    return _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(_____5F15_7528)
end
function _____542F_52A8_5267_60C5Boss_6218(bossUnit)
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    if not _____662F_5426_5DF2_767B_8BB0Boss_81EA_52A8_6280_80FD(bossUnit) then
        _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8(bossUnit, "Boss战.绑定单位")
    end
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(bossUnit)
    YDUserDataSetSafe(
        "string",
        ____Boss_6218_8868_540D,
        ____Boss_6218_7ED1_5B9A_5355_4F4D_5B57_6BB5,
        "unit",
        bossUnit
    )
    local _____89E6_53D1_5355_4F4D = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit")
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        YDUserDataSetSafe(
            "string",
            ____Boss_6218_8868_540D,
            ____Boss_6218_89E6_53D1_73A9_5BB6_5B57_6BB5,
            "unit",
            _____89E6_53D1_5355_4F4D
        )
    end
    _____79FB_9664_5355_4F4D_6682_505C(bossUnit, _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90)
    SetUnitInvulnerable(bossUnit, false)
    _____542F_52A8Boss_6218_8FD0_884C(bossUnit)
end
function _____6267_884CBoss_6218_542F_52A8_6B65_9AA4(_____6B65_9AA4)
    if _____6B65_9AA4.type ~= "startBossFight" then
        return
    end
    local ____8BFB_53D6_5355_4F4D_5F15_7528_result_11 = _____8BFB_53D6_5355_4F4D_5F15_7528(_____6B65_9AA4["Boss引用"])
    if ____8BFB_53D6_5355_4F4D_5F15_7528_result_11 == nil then
        ____8BFB_53D6_5355_4F4D_5F15_7528_result_11 = _____8BFB_53D6_5355_4F4D_5F15_7528(_____6B65_9AA4["Boss名"] and "Boss." .. tostring(_____6B65_9AA4["Boss名"]) or nil)
    end
    local bossUnit = ____8BFB_53D6_5355_4F4D_5F15_7528_result_11
    _____542F_52A8_5267_60C5Boss_6218(bossUnit)
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] + 1
    _____6267_884C_5F53_524D_5267_60C5_6B65_9AA4()
end
function _____6267_884C_7ED9_7269_54C1_6B65_9AA4(_____6B65_9AA4)
    if _____6B65_9AA4.type ~= "giveItem" then
        return
    end
    local itemName = _____6B65_9AA4["物品名"]
    if itemName ~= nil and itemName ~= "" then
        _____6309_540D_5B57_7ED9_89E6_53D1_5355_4F4D_7269_54C1(itemName)
    end
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] + 1
    _____6267_884C_5F53_524D_5267_60C5_6B65_9AA4()
end
function _____6267_884C_5F53_524D_5267_60C5_6B65_9AA4()
    if not _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["是否正在播放"] or _____5F53_524D_7247_6BB5 == nil then
        return
    end
    if _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["是否请求跳过"] then
        _____7ED3_675F_5F53_524D_5267_60C5_7247_6BB5()
        return
    end
    if _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] >= #_____5F53_524D_7247_6BB5["步骤列表"] then
        _____7ED3_675F_5F53_524D_5267_60C5_7247_6BB5()
        return
    end
    local _____6B65_9AA4 = _____5F53_524D_7247_6BB5["步骤列表"][_____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] + 1]
    repeat
        local ____switch105 = _____6B65_9AA4.type
        local ____cond105 = ____switch105 == "dialog"
        if ____cond105 then
            _____6267_884C_5BF9_767D_6B65_9AA4(_____6B65_9AA4)
            return
        end
        ____cond105 = ____cond105 or ____switch105 == "broadcast"
        if ____cond105 then
            _____6267_884C_5E7F_64AD_6B65_9AA4(_____6B65_9AA4)
            return
        end
        ____cond105 = ____cond105 or ____switch105 == "wait"
        if ____cond105 then
            _____6267_884C_7B49_5F85_6B65_9AA4(_____6B65_9AA4)
            return
        end
        ____cond105 = ____cond105 or ____switch105 == "runAction"
        if ____cond105 then
            _____6267_884C_81EA_5B9A_4E49_52A8_4F5C_6B65_9AA4(_____6B65_9AA4)
            return
        end
        ____cond105 = ____cond105 or ____switch105 == "startBossFight"
        if ____cond105 then
            _____6267_884CBoss_6218_542F_52A8_6B65_9AA4(_____6B65_9AA4)
            return
        end
        ____cond105 = ____cond105 or ____switch105 == "giveItem"
        if ____cond105 then
            _____6267_884C_7ED9_7269_54C1_6B65_9AA4(_____6B65_9AA4)
            return
        end
        do
            local ____6267_884C_901A_7528_5267_60C5_52A8_4F5C_16 = _____6267_884C_901A_7528_5267_60C5_52A8_4F5C
            local ____6B65_9AA4__53C2_6570_15 = _____6B65_9AA4["参数"]
            if ____6B65_9AA4__53C2_6570_15 == nil then
                ____6B65_9AA4__53C2_6570_15 = {}
            end
            ____6267_884C_901A_7528_5267_60C5_52A8_4F5C_16(____6B65_9AA4__53C2_6570_15)
            _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] + 1
            _____6267_884C_5F53_524D_5267_60C5_6B65_9AA4()
            return
        end
    until true
end
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
_____79FB_9664_5355_4F4D_6682_505C = ____require_result_0["移除单位暂停"]
_____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90 = "剧情系统:Boss预置"
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
addPeriodicCallback = ____require_result_1.addPeriodicCallback
removePeriodicCallback = ____require_result_1.removePeriodicCallback
getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("lib.扩展函数.BJ函数.05A．电影函数")
TransmissionFromUnitWithNameBJ = ____require_result_2.TransmissionFromUnitWithNameBJ
CinematicModeBJ = ____require_result_2.CinematicModeBJ
local ____require_result_3 = require("lib.扩展函数.BJ函数.07．杂项")
GetPlayersAll = ____require_result_3.GetPlayersAll
local ____require_result_4 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_4.QuestMessageBJ
local ____require_result_5 = require("系统.09．表现系统.06．广播提示消息.index")
_____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6 = ____require_result_5["发送头像提示给玩家"]
_____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6 = ____require_result_5["发送单位提示给玩家"]
_____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_5["广播单位提示"]
local ____require_result_6 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDUserDataGetSafe = ____require_result_6.YDUserDataGetSafe
YDUserDataSetSafe = ____require_result_6.YDUserDataSetSafe
local ____require_result_7 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.03．Boss战运行驱动")
_____542F_52A8Boss_6218_8FD0_884C = ____require_result_7["启动Boss战运行"]
local ____require_result_8 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
_____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_8["应用Boss战启动属性配置"]
local ____require_result_9 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
_____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8 = ____require_result_9["记录Boss自动技能启动"]
_____662F_5426_5DF2_767B_8BB0Boss_81EA_52A8_6280_80FD = ____require_result_9["是否已登记Boss自动技能"]
local ____require_result_10 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_10.debugLogForce
local CreateTrigger = jass.CreateTrigger
local GetTriggerPlayer = jass.GetTriggerPlayer
Player = jass.Player
SetUnitInvulnerable = jass.SetUnitInvulnerable
local TriggerAddAction = jass.TriggerAddAction
local TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent
local TriggerRegisterPlayerEvent = jass.TriggerRegisterPlayerEvent
local EVENT_PLAYER_END_CINEMATIC = jass.EVENT_PLAYER_END_CINEMATIC
bj_TIMETYPE_SET = jglobals.bj_TIMETYPE_SET
local bj_QUESTMESSAGE_HINT = jglobals.bj_QUESTMESSAGE_HINT
_____5267_60C5_64AD_653E_5668_6A21_5757_540D = "11．剧情系统-剧情步骤播放器"
____Boss_6218_8868_540D = "Boss战"
____Boss_6218_7ED1_5B9A_5355_4F4D_5B57_6BB5 = "绑定单位"
____Boss_6218_89E6_53D1_73A9_5BB6_5B57_6BB5 = "触发玩家"
_____9ED8_8BA4_5E7F_64AD_5934_50CF_8DEF_5F84 = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"
local _____9ED8_8BA4_5267_60C5_64AD_653E_5668_8FD0_884C_65F6 = {
    ["当前步骤索引"] = 0,
    ["当前倍速"] = 1,
    ["是否正在播放"] = false,
    ["是否请求跳过"] = false,
    ["播放世代"] = 0
}
_____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001 = __TS__ObjectAssign({}, _____9ED8_8BA4_5267_60C5_64AD_653E_5668_8FD0_884C_65F6)
local _____5DF2_521D_59CB_5316_5267_60C5_6B65_9AA4_64AD_653E_5668 = false
_____5267_60C5_5EF6_8FDF_4EFB_52A1_5217_8868 = {}
_____5267_60C5_5EF6_8FDF_4EFB_52A1_626B_63CF_56DE_8C03ID = 0
____exports["创建剧情播放器运行时"] = function()
    return __TS__ObjectAssign({}, _____9ED8_8BA4_5267_60C5_64AD_653E_5668_8FD0_884C_65F6)
end
____exports["查找主线剧情片段"] = function(_____7247_6BB5ID)
    do
        local i = 0
        while i < #_____4E3B_7EBF_5267_60C5_7247_6BB5_914D_7F6E_8868 do
            local _____7247_6BB5 = _____4E3B_7EBF_5267_60C5_7247_6BB5_914D_7F6E_8868[i + 1]
            if _____7247_6BB5["片段ID"] == _____7247_6BB5ID then
                return _____7247_6BB5
            end
            i = i + 1
        end
    end
    return nil
end
local function _____5B89_6392_7EDD_5BF9_65F6_95F4_52A8_4F5C(_____6B65_9AA4)
    if _____6B65_9AA4.type ~= "runAction" then
        return
    end
    local _____53C2_6570 = _____6B65_9AA4["参数"] or ({})
    if _____53C2_6570["挂点"] ~= "absoluteTime" then
        return
    end
    local _____65F6_95F4_79D2 = type(_____53C2_6570["时间秒"]) == "number" and _____53C2_6570["时间秒"] or (__TS__Number(_____53C2_6570["时间秒"]) or 0)
    _____6DFB_52A0_5267_60C5_5EF6_8FDF_4EFB_52A1({
        ["到期时间毫秒"] = getServerTime() + _____8BA1_7B97_6B65_9AA4_6301_7EED_65F6_95F4(_____65F6_95F4_79D2) * 1000,
        ["播放世代"] = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["播放世代"],
        ["类型"] = "绝对时间动作",
        ["动作ID"] = _____6B65_9AA4["动作ID"],
        ["参数"] = _____53C2_6570
    })
end
local function _____5B89_6392_7247_6BB5_7EDD_5BF9_65F6_95F4_52A8_4F5C(_____7247_6BB5)
    do
        local i = 0
        while i < #_____7247_6BB5["步骤列表"] do
            _____5B89_6392_7EDD_5BF9_65F6_95F4_52A8_4F5C(_____7247_6BB5["步骤列表"][i + 1])
            i = i + 1
        end
    end
end
local function _____5E7F_64AD_5267_60C5_8DF3_8FC7_63D0_793A()
    local _____6587_672C = "|cffffff00『系统提示』：|r按下 |cffffcc00~|r 键可跳过当前剧情。"
    do
        local i = 0
        while i < 4 do
            _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6(
                Player(i),
                _____9ED8_8BA4_5E7F_64AD_5934_50CF_8DEF_5F84,
                _____6587_672C,
                3200
            )
            i = i + 1
        end
    end
end
local function _____6267_884C_8DF3_8FC7_6A21_5F0F_6B65_9AA4_903B_8F91(_____6B65_9AA4)
    repeat
        local ____switch93 = _____6B65_9AA4.type
        local ____cond93 = ____switch93 == "dialog" or ____switch93 == "broadcast" or ____switch93 == "wait"
        if ____cond93 then
            return
        end
        ____cond93 = ____cond93 or ____switch93 == "runAction"
        if ____cond93 then
            _____83B7_53D6_6267_884C_4E3B_7EBF_5267_60C5_52A8_4F5C_51FD_6570()(_____6B65_9AA4["动作ID"], _____6B65_9AA4["参数"] or ({}))
            return
        end
        ____cond93 = ____cond93 or ____switch93 == "startBossFight"
        if ____cond93 then
            do
                local ____8BFB_53D6_5355_4F4D_5F15_7528_result_12 = _____8BFB_53D6_5355_4F4D_5F15_7528(_____6B65_9AA4["Boss引用"])
                if ____8BFB_53D6_5355_4F4D_5F15_7528_result_12 == nil then
                    ____8BFB_53D6_5355_4F4D_5F15_7528_result_12 = _____8BFB_53D6_5355_4F4D_5F15_7528(_____6B65_9AA4["Boss名"] and "Boss." .. tostring(_____6B65_9AA4["Boss名"]) or nil)
                end
                local bossUnit = ____8BFB_53D6_5355_4F4D_5F15_7528_result_12
                _____542F_52A8_5267_60C5Boss_6218(bossUnit)
                return
            end
        end
        ____cond93 = ____cond93 or ____switch93 == "giveItem"
        if ____cond93 then
            do
                local itemName = _____6B65_9AA4["物品名"]
                if itemName ~= nil and itemName ~= "" then
                    _____6309_540D_5B57_7ED9_89E6_53D1_5355_4F4D_7269_54C1(itemName)
                end
                return
            end
        end
        do
            local ____6267_884C_901A_7528_5267_60C5_52A8_4F5C_14 = _____6267_884C_901A_7528_5267_60C5_52A8_4F5C
            local ____6B65_9AA4__53C2_6570_13 = _____6B65_9AA4["参数"]
            if ____6B65_9AA4__53C2_6570_13 == nil then
                ____6B65_9AA4__53C2_6570_13 = {}
            end
            ____6267_884C_901A_7528_5267_60C5_52A8_4F5C_14(____6B65_9AA4__53C2_6570_13)
            return
        end
    until true
end
local function _____5FEB_8FDB_6267_884C_5F53_524D_7247_6BB5_5269_4F59_903B_8F91()
    if _____5F53_524D_7247_6BB5 == nil then
        return
    end
    do
        local i = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"]
        while i < #_____5F53_524D_7247_6BB5["步骤列表"] do
            _____6267_884C_8DF3_8FC7_6A21_5F0F_6B65_9AA4_903B_8F91(_____5F53_524D_7247_6BB5["步骤列表"][i + 1])
            i = i + 1
        end
    end
end
____exports["播放主线剧情片段"] = function(_____7247_6BB5ID, _____4E0A_4E0B_6587)
    local _____7247_6BB5 = ____exports["查找主线剧情片段"](_____7247_6BB5ID)
    if _____7247_6BB5 == nil then
        debugLogForce(_____5267_60C5_64AD_653E_5668_6A21_5757_540D, "找不到剧情片段", _____7247_6BB5ID)
        return false
    end
    if _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["是否正在播放"] then
        debugLogForce(_____5267_60C5_64AD_653E_5668_6A21_5757_540D, "已有剧情播放中，跳过", _____7247_6BB5ID)
        return false
    end
    if _____4E0A_4E0B_6587 ~= nil then
        _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587(_____4E0A_4E0B_6587)
    end
    _____5F53_524D_7247_6BB5 = _____7247_6BB5
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["播放世代"] = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["播放世代"] + 1
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前片段ID"] = _____7247_6BB5ID
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] = 0
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前倍速"] = _____7247_6BB5["默认倍速"] or 1
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["是否正在播放"] = true
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["是否请求跳过"] = false
    if _____7247_6BB5["可Esc整段跳过"] == true then
        _____5E7F_64AD_5267_60C5_8DF3_8FC7_63D0_793A()
    end
    _____5B89_6392_7247_6BB5_7EDD_5BF9_65F6_95F4_52A8_4F5C(_____7247_6BB5)
    debugLogForce(
        _____5267_60C5_64AD_653E_5668_6A21_5757_540D,
        "播放剧情片段",
        _____7247_6BB5ID,
        "steps=",
        #_____7247_6BB5["步骤列表"]
    )
    _____6267_884C_5F53_524D_5267_60C5_6B65_9AA4()
    return true
end
local function ____on_5267_60C5ESC_8DF3_8FC7()
    if not _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["是否正在播放"] or _____5F53_524D_7247_6BB5 == nil then
        return
    end
    if _____5F53_524D_7247_6BB5["可Esc整段跳过"] ~= true then
        return
    end
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["是否请求跳过"] = true
    QuestMessageBJ(
        GetPlayersAll(),
        bj_QUESTMESSAGE_HINT,
        "|cffffff00『系统提示』：|r已跳过当前剧情。"
    )
    _____5FEB_8FDB_6267_884C_5F53_524D_7247_6BB5_5269_4F59_903B_8F91()
    _____7ED3_675F_5F53_524D_5267_60C5_7247_6BB5()
end
local function ____on_5267_60C5_4E8C_500D_901F_547D_4EE4()
    local player = GetTriggerPlayer()
    if player == nil or player == 0 then
        return
    end
    if not _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["是否正在播放"] then
        return
    end
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前倍速"] = 2
    QuestMessageBJ(
        GetPlayersAll(),
        bj_QUESTMESSAGE_HINT,
        "|cffffff00『系统提示』：|r当前剧情已切换为 2 倍速。"
    )
end
local function _____6CE8_518C_5267_60C5_64AD_653E_5668_8F93_5165_4E8B_4EF6()
    local escTrigger = CreateTrigger()
    local speedTrigger = CreateTrigger()
    do
        local i = 0
        while i < 8 do
            TriggerRegisterPlayerEvent(
                escTrigger,
                Player(i),
                EVENT_PLAYER_END_CINEMATIC
            )
            TriggerRegisterPlayerChatEvent(
                speedTrigger,
                Player(i),
                "-2",
                true
            )
            i = i + 1
        end
    end
    TriggerAddAction(escTrigger, ____on_5267_60C5ESC_8DF3_8FC7)
    TriggerAddAction(speedTrigger, ____on_5267_60C5_4E8C_500D_901F_547D_4EE4)
end
____exports["初始化剧情步骤播放器"] = function()
    if _____5DF2_521D_59CB_5316_5267_60C5_6B65_9AA4_64AD_653E_5668 then
        return
    end
    _____5DF2_521D_59CB_5316_5267_60C5_6B65_9AA4_64AD_653E_5668 = true
    local ____ = _____4E3B_7EBF_5267_60C5_7247_6BB5_914D_7F6E_8868
    _____6CE8_518C_5267_60C5_64AD_653E_5668_8F93_5165_4E8B_4EF6()
end
return ____exports
