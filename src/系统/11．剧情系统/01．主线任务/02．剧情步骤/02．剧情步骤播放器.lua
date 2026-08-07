local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__Number = ____lualib.__TS__Number
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____8BA1_7B97_6B65_9AA4_6301_7EED_65F6_95F4, _____5B89_6392_4E0B_4E00_6B65, _____5B8C_6210_7B2C_4E8C_4E09_7AE0_53CB_65B9NPC_5F52_5C5E_6536_5C3E, _____7ED3_675F_5F53_524D_5267_60C5_7247_6BB5, _____83B7_53D6_6267_884C_4E3B_7EBF_5267_60C5_52A8_4F5C_51FD_6570, _____6267_884C_5267_60C5_5EF6_8FDF_4EFB_52A1, _____5C1D_8BD5_505C_6B62_5267_60C5_5EF6_8FDF_4EFB_52A1_626B_63CF, _____6E05_7406_5267_60C5_5EF6_8FDF_4EFB_52A1, ____on_5267_60C5_5EF6_8FDF_4EFB_52A1_626B_63CF, _____6DFB_52A0_5267_60C5_5EF6_8FDF_4EFB_52A1, _____6267_884C_5BF9_767D_6B65_9AA4, _____8BFB_53D6_5F53_524D_5267_60C5_89E6_53D1_5355_4F4D, _____8BFB_53D6_8BF4_8BDD_8005_5355_4F4D, _____6267_884CUIDialog_6B65_9AA4, _____6267_884CUI_5E7F_64AD_6B65_9AA4, _____6E05_7406_5267_60C5ESC_6309_952E_72B6_6001, _____6267_884C_5E7F_64AD_6B65_9AA4, _____6267_884C_7B49_5F85_6B65_9AA4, _____6267_884C_81EA_5B9A_4E49_52A8_4F5C_6B65_9AA4, _____8BFB_53D6_5355_4F4D_5F15_7528, _____6267_884CBoss_6218_542F_52A8_6B65_9AA4, _____6267_884C_7ED9_7269_54C1_6B65_9AA4, _____6267_884C_5F53_524D_5267_60C5_6B65_9AA4, addPeriodicCallback, removePeriodicCallback, getServerTime, TransmissionFromUnitWithNameBJ, GetPlayersAll, _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6, _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6, _____5E7F_64AD_5355_4F4D_63D0_793A, YDUserDataGetSafe, debugLogForce, Player, IsUnitType, SetUnitOwner, UNIT_TYPE_DEAD, bj_TIMETYPE_SET, _____5267_60C5_64AD_653E_5668_6A21_5757_540D, _____9ED8_8BA4_5E7F_64AD_5934_50CF_8DEF_5F84, _____5F53_524D_5267_60C5_89E6_53D1_5355_4F4D_8BED_4E49_540D, _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001, _____5267_60C5ESC_6700_8FD1_6309_4E0B_65F6_95F4_8868, _____5F53_524D_7247_6BB5, _____5267_60C5_5EF6_8FDF_4EFB_52A1_5217_8868, _____5267_60C5_5EF6_8FDF_4EFB_52A1_626B_63CF_56DE_8C03ID, _____6267_884C_4E3B_7EBF_5267_60C5_52A8_4F5C_51FD_6570, _____7B2C_4E8C_4E09_7AE0_53CB_65B9NPC_5F15_7528_767D_540D_5355
local ____01_FF0E_5267_60C5_7247_6BB5_914D_7F6E_8868 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．剧情片段配置表")
local _____4E3B_7EBF_5267_60C5_7247_6BB5_914D_7F6E_8868 = ____01_FF0E_5267_60C5_7247_6BB5_914D_7F6E_8868.default
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入当前剧情动作上下文"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____6309_540D_5B57_7ED9_89E6_53D1_5355_4F4D_7269_54C1 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["按名字给触发单位物品"]
local _____6309_539F_59CBID_7ED9_89E6_53D1_5355_4F4D_7269_54C1 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["按原始ID给触发单位物品"]
local _____6267_884C_901A_7528_5267_60C5_52A8_4F5C = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["执行通用剧情动作"]
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local _____8BBE_7F6E_73A9_5BB6_82F1_96C4_7EC4_63A7_5236_72B6_6001 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["设置玩家英雄组控制状态"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["注册剧情运行时单位"]
local _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["清理剧情运行时单位"]
local ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接")
local _____542F_52A8_5267_60C5Boss_6218 = ____11_FF0E_5267_60C5Boss_6218_542F_52A8_6865_63A5["启动剧情Boss战"]
local ____12_FF0E_5267_60C5_7535_5F71_955C_5934 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.12．剧情电影镜头")
local _____8FDB_5165_5267_60C5_7535_5F71_6A21_5F0F = ____12_FF0E_5267_60C5_7535_5F71_955C_5934["进入剧情电影模式"]
local _____9000_51FA_5267_60C5_7535_5F71_6A21_5F0F_5E76_6062_590D_955C_5934 = ____12_FF0E_5267_60C5_7535_5F71_955C_5934["退出剧情电影模式并恢复镜头"]
local ____13_FF0E_5267_60C5_7247_6BB5_6E05_7406_6CE8_518C_8868 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.13．剧情片段清理注册表")
local _____6267_884C_5267_60C5_7247_6BB5_6E05_7406 = ____13_FF0E_5267_60C5_7247_6BB5_6E05_7406_6CE8_518C_8868["执行剧情片段清理"]
local ____09_FF0E_4E3B_7EBF_8282_70B9_914D_7F6E = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.09．主线节点配置")
local _____83B7_53D6_4E3B_7EBF_8282_70B9_914D_7F6E = ____09_FF0E_4E3B_7EBF_8282_70B9_914D_7F6E["获取主线节点配置"]
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
function _____5B8C_6210_7B2C_4E8C_4E09_7AE0_53CB_65B9NPC_5F52_5C5E_6536_5C3E(_____7247_6BB5)
    if _____7247_6BB5 == nil then
        return
    end
    local _____662F_7B2C_4E8C_7AE0 = (string.find(_____7247_6BB5["片段ID"], "elven_city_", nil, true) or 0) - 1 == 0 or _____7247_6BB5["片段ID"] == "elven_forest_gate_arrival"
    local _____662F_7B2C_4E09_7AE0 = (string.find(_____7247_6BB5["片段ID"], "molten_realm_", nil, true) or 0) - 1 == 0
    if not _____662F_7B2C_4E8C_7AE0 and not _____662F_7B2C_4E09_7AE0 then
        return
    end
    local _____5DF2_5904_7406_5F15_7528 = {}
    do
        local i = 0
        while i < #_____7247_6BB5["步骤列表"] do
            do
                local _____6B65_9AA4 = _____7247_6BB5["步骤列表"][i + 1]
                if _____6B65_9AA4.type ~= "dialog" then
                    goto __continue15
                end
                local _____5F15_7528 = _____6B65_9AA4["说话者引用"]
                if _____5F15_7528 == nil or _____7B2C_4E8C_4E09_7AE0_53CB_65B9NPC_5F15_7528_767D_540D_5355[_____5F15_7528] ~= true or _____5DF2_5904_7406_5F15_7528[_____5F15_7528] == true then
                    goto __continue15
                end
                _____5DF2_5904_7406_5F15_7528[_____5F15_7528] = true
                local unit = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(_____5F15_7528)
                if unit == nil or unit == 0 or IsUnitType(unit, UNIT_TYPE_DEAD) == true then
                    goto __continue15
                end
                SetUnitOwner(
                    unit,
                    Player(6),
                    true
                )
            end
            ::__continue15::
            i = i + 1
        end
    end
end
function _____7ED3_675F_5F53_524D_5267_60C5_7247_6BB5()
    local _____7247_6BB5ID = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前片段ID"] or ""
    local _____5DF2_5B8C_6210_7247_6BB5 = _____5F53_524D_7247_6BB5
    local _____64AD_653E_4E16_4EE3 = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["播放世代"]
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["是否正在播放"] = false
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["是否请求跳过"] = false
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] = 0
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前片段ID"] = nil
    _____5F53_524D_7247_6BB5 = nil
    _____6E05_7406_5267_60C5_5EF6_8FDF_4EFB_52A1(_____64AD_653E_4E16_4EE3)
    _____6E05_7406_5267_60C5ESC_6309_952E_72B6_6001()
    _____5B8C_6210_7B2C_4E8C_4E09_7AE0_53CB_65B9NPC_5F52_5C5E_6536_5C3E(_____5DF2_5B8C_6210_7247_6BB5)
    _____6267_884C_5267_60C5_7247_6BB5_6E05_7406(_____7247_6BB5ID)
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5F53_524D_5267_60C5_89E6_53D1_5355_4F4D_8BED_4E49_540D)
    _____8BBE_7F6E_73A9_5BB6_82F1_96C4_7EC4_63A7_5236_72B6_6001(false, false)
    _____9000_51FA_5267_60C5_7535_5F71_6A21_5F0F_5E76_6062_590D_955C_5934()
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
                    goto __continue35
                end
                _____5267_60C5_5EF6_8FDF_4EFB_52A1_5217_8868[_____5199_5165_7D22_5F15 + 1] = _____4EFB_52A1
                _____5199_5165_7D22_5F15 = _____5199_5165_7D22_5F15 + 1
            end
            ::__continue35::
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
                    goto __continue41
                end
                _____5267_60C5_5EF6_8FDF_4EFB_52A1_5217_8868[_____5199_5165_7D22_5F15 + 1] = _____4EFB_52A1
                _____5199_5165_7D22_5F15 = _____5199_5165_7D22_5F15 + 1
            end
            ::__continue41::
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
        local _____8BF4_8BDD_8005_5355_4F4D = _____8BFB_53D6_8BF4_8BDD_8005_5355_4F4D(_____8BF4_8BDD_8005, _____6B65_9AA4["说话者引用"])
        if _____6B65_9AA4["原生对白自动开启电影模式"] ~= false then
            _____8FDB_5165_5267_60C5_7535_5F71_6A21_5F0F()
        end
        local ____TransmissionFromUnitWithNameBJ_9 = TransmissionFromUnitWithNameBJ
        local ____GetPlayersAll_result_8 = GetPlayersAll()
        local ____temp_7
        if _____8BF4_8BDD_8005_5355_4F4D ~= nil and _____8BF4_8BDD_8005_5355_4F4D ~= 0 then
            ____temp_7 = _____8BF4_8BDD_8005_5355_4F4D
        else
            ____temp_7 = nil
        end
        ____TransmissionFromUnitWithNameBJ_9(
            ____GetPlayersAll_result_8,
            ____temp_7,
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
function _____6E05_7406_5267_60C5ESC_6309_952E_72B6_6001()
    for playerId in pairs(_____5267_60C5ESC_6700_8FD1_6309_4E0B_65F6_95F4_8868) do
        __TS__Delete(
            _____5267_60C5ESC_6700_8FD1_6309_4E0B_65F6_95F4_8868,
            __TS__Number(playerId)
        )
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
function _____6267_884CBoss_6218_542F_52A8_6B65_9AA4(_____6B65_9AA4)
    if _____6B65_9AA4.type ~= "startBossFight" then
        return
    end
    local ____8BFB_53D6_5355_4F4D_5F15_7528_result_10 = _____8BFB_53D6_5355_4F4D_5F15_7528(_____6B65_9AA4["Boss引用"])
    if ____8BFB_53D6_5355_4F4D_5F15_7528_result_10 == nil then
        ____8BFB_53D6_5355_4F4D_5F15_7528_result_10 = _____8BFB_53D6_5355_4F4D_5F15_7528(_____6B65_9AA4["Boss名"] and "Boss." .. tostring(_____6B65_9AA4["Boss名"]) or nil)
    end
    local bossUnit = ____8BFB_53D6_5355_4F4D_5F15_7528_result_10
    _____542F_52A8_5267_60C5Boss_6218(bossUnit)
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] + 1
    _____6267_884C_5F53_524D_5267_60C5_6B65_9AA4()
end
function _____6267_884C_7ED9_7269_54C1_6B65_9AA4(_____6B65_9AA4)
    if _____6B65_9AA4.type ~= "giveItem" then
        return
    end
    local itemRawId = _____6B65_9AA4["物品ID"]
    local itemName = _____6B65_9AA4["物品名"]
    if itemRawId ~= nil and itemRawId ~= "" then
        _____6309_539F_59CBID_7ED9_89E6_53D1_5355_4F4D_7269_54C1(itemRawId)
    elseif itemName ~= nil and itemName ~= "" then
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
        local ____switch118 = _____6B65_9AA4.type
        local ____cond118 = ____switch118 == "dialog"
        if ____cond118 then
            _____6267_884C_5BF9_767D_6B65_9AA4(_____6B65_9AA4)
            return
        end
        ____cond118 = ____cond118 or ____switch118 == "broadcast"
        if ____cond118 then
            _____6267_884C_5E7F_64AD_6B65_9AA4(_____6B65_9AA4)
            return
        end
        ____cond118 = ____cond118 or ____switch118 == "wait"
        if ____cond118 then
            _____6267_884C_7B49_5F85_6B65_9AA4(_____6B65_9AA4)
            return
        end
        ____cond118 = ____cond118 or ____switch118 == "runAction"
        if ____cond118 then
            _____6267_884C_81EA_5B9A_4E49_52A8_4F5C_6B65_9AA4(_____6B65_9AA4)
            return
        end
        ____cond118 = ____cond118 or ____switch118 == "startBossFight"
        if ____cond118 then
            _____6267_884CBoss_6218_542F_52A8_6B65_9AA4(_____6B65_9AA4)
            return
        end
        ____cond118 = ____cond118 or ____switch118 == "giveItem"
        if ____cond118 then
            _____6267_884C_7ED9_7269_54C1_6B65_9AA4(_____6B65_9AA4)
            return
        end
        do
            local ____6267_884C_901A_7528_5267_60C5_52A8_4F5C_15 = _____6267_884C_901A_7528_5267_60C5_52A8_4F5C
            local ____6B65_9AA4__53C2_6570_14 = _____6B65_9AA4["参数"]
            if ____6B65_9AA4__53C2_6570_14 == nil then
                ____6B65_9AA4__53C2_6570_14 = {}
            end
            ____6267_884C_901A_7528_5267_60C5_52A8_4F5C_15(____6B65_9AA4__53C2_6570_14)
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
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("lib.扩展函数.BJ函数.05A．电影函数")
TransmissionFromUnitWithNameBJ = ____require_result_1.TransmissionFromUnitWithNameBJ
local ____require_result_2 = require("lib.扩展函数.BJ函数.07．杂项")
GetPlayersAll = ____require_result_2.GetPlayersAll
local ____require_result_3 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_3.QuestMessageBJ
local ____require_result_4 = require("系统.09．表现系统.06．广播提示消息.index")
_____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6 = ____require_result_4["发送头像提示给玩家"]
_____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6 = ____require_result_4["发送单位提示给玩家"]
_____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_4["广播单位提示"]
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDUserDataGetSafe = ____require_result_5.YDUserDataGetSafe
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_6.debugLogForce
local CreateTrigger = jass.CreateTrigger
local GetTriggerPlayer = jass.GetTriggerPlayer
local GetPlayerId = jass.GetPlayerId
Player = jass.Player
local TriggerAddAction = jass.TriggerAddAction
local TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent
local TriggerRegisterPlayerEvent = jass.TriggerRegisterPlayerEvent
IsUnitType = jass.IsUnitType
SetUnitOwner = jass.SetUnitOwner
local EVENT_PLAYER_END_CINEMATIC = jass.EVENT_PLAYER_END_CINEMATIC
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
bj_TIMETYPE_SET = jglobals.bj_TIMETYPE_SET
local bj_QUESTMESSAGE_HINT = jglobals.bj_QUESTMESSAGE_HINT
local bj_QUESTMESSAGE_UPDATED = jglobals.bj_QUESTMESSAGE_UPDATED
_____5267_60C5_64AD_653E_5668_6A21_5757_540D = "11．剧情系统-剧情步骤播放器"
_____9ED8_8BA4_5E7F_64AD_5934_50CF_8DEF_5F84 = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"
local _____5267_60C5ESC_53CC_51FB_95F4_9694_6BEB_79D2 = 300
_____5F53_524D_5267_60C5_89E6_53D1_5355_4F4D_8BED_4E49_540D = "剧情.当前触发单位"
local _____9ED8_8BA4_5267_60C5_64AD_653E_5668_8FD0_884C_65F6 = {
    ["当前步骤索引"] = 0,
    ["当前倍速"] = 1,
    ["是否正在播放"] = false,
    ["是否请求跳过"] = false,
    ["播放世代"] = 0
}
_____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001 = __TS__ObjectAssign({}, _____9ED8_8BA4_5267_60C5_64AD_653E_5668_8FD0_884C_65F6)
_____5267_60C5ESC_6700_8FD1_6309_4E0B_65F6_95F4_8868 = {}
local _____5DF2_521D_59CB_5316_5267_60C5_6B65_9AA4_64AD_653E_5668 = false
_____5267_60C5_5EF6_8FDF_4EFB_52A1_5217_8868 = {}
_____5267_60C5_5EF6_8FDF_4EFB_52A1_626B_63CF_56DE_8C03ID = 0
_____7B2C_4E8C_4E09_7AE0_53CB_65B9NPC_5F15_7528_767D_540D_5355 = {
    ["主线NPC.阿莫斯"] = true,
    ["主线NPC.艾伦"] = true,
    ["主线NPC.赤尾"] = true,
    ["主线NPC.锻造区证人"] = true,
    ["主线NPC.恶魔城领主"] = true,
    ["主线NPC.菲尼克斯尔残响"] = true,
    ["主线NPC.赫克提尔"] = true,
    ["主线NPC.皇家禁卫"] = true,
    ["主线NPC.克林姆德王"] = true,
    ["主线NPC.里凡特"] = true,
    ["主线NPC.耶提尔"] = true,
    ["剧情运行时.封印核心奥斯特利一世"] = true
}
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
    local _____6587_672C = "|cffffff00『系统提示』：|r请在 |cffffcc000.3 秒|r 内连续按下两次 |cffffcc00ESC|r 跳过当前剧情。"
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
    if _____6B65_9AA4["跳过也执行"] == false then
        return
    end
    repeat
        local ____switch103 = _____6B65_9AA4.type
        local ____cond103 = ____switch103 == "dialog" or ____switch103 == "broadcast" or ____switch103 == "wait"
        if ____cond103 then
            return
        end
        ____cond103 = ____cond103 or ____switch103 == "runAction"
        if ____cond103 then
            _____83B7_53D6_6267_884C_4E3B_7EBF_5267_60C5_52A8_4F5C_51FD_6570()(_____6B65_9AA4["动作ID"], _____6B65_9AA4["参数"] or ({}))
            return
        end
        ____cond103 = ____cond103 or ____switch103 == "startBossFight"
        if ____cond103 then
            do
                local ____8BFB_53D6_5355_4F4D_5F15_7528_result_11 = _____8BFB_53D6_5355_4F4D_5F15_7528(_____6B65_9AA4["Boss引用"])
                if ____8BFB_53D6_5355_4F4D_5F15_7528_result_11 == nil then
                    ____8BFB_53D6_5355_4F4D_5F15_7528_result_11 = _____8BFB_53D6_5355_4F4D_5F15_7528(_____6B65_9AA4["Boss名"] and "Boss." .. tostring(_____6B65_9AA4["Boss名"]) or nil)
                end
                local bossUnit = ____8BFB_53D6_5355_4F4D_5F15_7528_result_11
                _____542F_52A8_5267_60C5Boss_6218(bossUnit)
                return
            end
        end
        ____cond103 = ____cond103 or ____switch103 == "giveItem"
        if ____cond103 then
            do
                local itemRawId = _____6B65_9AA4["物品ID"]
                local itemName = _____6B65_9AA4["物品名"]
                if itemRawId ~= nil and itemRawId ~= "" then
                    _____6309_539F_59CBID_7ED9_89E6_53D1_5355_4F4D_7269_54C1(itemRawId)
                elseif itemName ~= nil and itemName ~= "" then
                    _____6309_540D_5B57_7ED9_89E6_53D1_5355_4F4D_7269_54C1(itemName)
                end
                return
            end
        end
        do
            local ____6267_884C_901A_7528_5267_60C5_52A8_4F5C_13 = _____6267_884C_901A_7528_5267_60C5_52A8_4F5C
            local ____6B65_9AA4__53C2_6570_12 = _____6B65_9AA4["参数"]
            if ____6B65_9AA4__53C2_6570_12 == nil then
                ____6B65_9AA4__53C2_6570_12 = {}
            end
            ____6267_884C_901A_7528_5267_60C5_52A8_4F5C_13(____6B65_9AA4__53C2_6570_12)
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
local function _____53D1_9001_8DF3_8FC7_540E_7684_4E3B_7EBF_5F15_5BFC()
    local _____8282_70B9 = _____83B7_53D6_4E3B_7EBF_8282_70B9_914D_7F6E(_____8BFB_53D6_5267_60C5_8FDB_5EA6())
    if _____8282_70B9 == nil or _____8282_70B9["提示文本"] == "" then
        return
    end
    QuestMessageBJ(
        GetPlayersAll(),
        bj_QUESTMESSAGE_UPDATED,
        _____8282_70B9["提示文本"]
    )
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
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5F53_524D_5267_60C5_89E6_53D1_5355_4F4D_8BED_4E49_540D)
    if _____4E0A_4E0B_6587 ~= nil then
        _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587(_____4E0A_4E0B_6587)
        if _____4E0A_4E0B_6587["触发单位"] ~= nil and _____4E0A_4E0B_6587["触发单位"] ~= 0 then
            _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5F53_524D_5267_60C5_89E6_53D1_5355_4F4D_8BED_4E49_540D, _____4E0A_4E0B_6587["触发单位"])
        end
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
    local _____5F53_524D_6B65_9AA4 = _____5F53_524D_7247_6BB5["步骤列表"][_____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] + 1]
    if (_____5F53_524D_6B65_9AA4 and _____5F53_524D_6B65_9AA4["可跳过"]) == false or _____5F53_524D_7247_6BB5["可Esc整段跳过"] ~= true and (_____5F53_524D_6B65_9AA4 and _____5F53_524D_6B65_9AA4["可跳过"]) ~= true then
        return
    end
    local player = GetTriggerPlayer()
    if player == nil or player == 0 then
        return
    end
    local playerId = GetPlayerId(player)
    local now = getServerTime()
    local lastPressTime = _____5267_60C5ESC_6700_8FD1_6309_4E0B_65F6_95F4_8868[playerId]
    if lastPressTime == nil or now - lastPressTime > _____5267_60C5ESC_53CC_51FB_95F4_9694_6BEB_79D2 or now < lastPressTime then
        _____5267_60C5ESC_6700_8FD1_6309_4E0B_65F6_95F4_8868[playerId] = now
        QuestMessageBJ(
            GetPlayersAll(),
            bj_QUESTMESSAGE_HINT,
            "|cffffff00『系统提示』：|r已检测到第一次 |cffffcc00ESC|r，请在 |cffffcc000.3 秒|r 内再按一次跳过。"
        )
        return
    end
    __TS__Delete(_____5267_60C5ESC_6700_8FD1_6309_4E0B_65F6_95F4_8868, playerId)
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["是否请求跳过"] = true
    QuestMessageBJ(
        GetPlayersAll(),
        bj_QUESTMESSAGE_HINT,
        "|cffffff00『系统提示』：|r已跳过当前剧情。"
    )
    _____5FEB_8FDB_6267_884C_5F53_524D_7247_6BB5_5269_4F59_903B_8F91()
    _____53D1_9001_8DF3_8FC7_540E_7684_4E3B_7EBF_5F15_5BFC()
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
