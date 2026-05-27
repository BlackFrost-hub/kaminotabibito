--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_96BE_5EA6_914D_7F6E_8868 = require("系统.00．核心系统.02．功能开关.03．游戏难度选择.00．难度配置表")
local _____6E38_620F_96BE_5EA6_914D_7F6E_8868 = ____00_FF0E_96BE_5EA6_914D_7F6E_8868.default
local _____6E38_620F_96BE_5EA6_5168_5C40_53D8_91CF_540D = ____00_FF0E_96BE_5EA6_914D_7F6E_8868["游戏难度全局变量名"]
local _____6E38_620F_96BE_5EA6_9009_62E9_5EF6_8FDF_79D2 = ____00_FF0E_96BE_5EA6_914D_7F6E_8868["游戏难度选择延迟秒"]
local _____5F31_70B9_6570_91CF_5168_5C40_53D8_91CF_540D = ____00_FF0E_96BE_5EA6_914D_7F6E_8868["弱点数量全局变量名"]
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_0.QuestMessageBJ
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_1.debugLogForce
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_2.YDUserDataSetSafe
local ____require_result_3 = require("系统.01．单位系统.08．单位配置表.04．总单位配置表")
local _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID = ____require_result_3["按名字反查总单位ID"]
local ____require_result_4 = require("系统.03．技能系统.08．技能数据表.01．技能名反查")
local _____6309_540D_5B57_53CD_67E5_6280_80FDID = ____require_result_4["按名字反查技能ID"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_5.stringToFourCCSafe
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_6["创建单位并登记排泄安全"]
local ____require_result_7 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_7.addDelayedCallback
local setGameDifficulty = ____require_result_7.setGameDifficulty
local ____require_result_8 = require("系统.00．核心系统.07．联机安全工具")
local safeTriggerAddAction = ____require_result_8.safeTriggerAddAction
local safeDestroyTrigger = ____require_result_8.safeDestroyTrigger
local _____6A21_5757_540D = "游戏难度选择"
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6 = jass.Player(jass.PLAYER_NEUTRAL_AGGRESSIVE)
local _____663E_793A_5BF9_8BDD_6846_73A9_5BB6 = jass.Player(0)
local _____7B2C_4E00_4E2A_96BE_5EA6_4F7F_8005_73A9_5BB6 = jass.Player(7)
local _____5BF9_8BDD_6846_6807_9898 = "请选择游戏难度"
local _____96BE_5EA6_4F7F_8005_521B_5EFAX = -607.1
local _____96BE_5EA6_4F7F_8005_521B_5EFAY = 6.1
local _____96BE_5EA6_4F7F_8005_671D_5411 = 0
local _____961F_4F0D_590D_6D3B_8868_540D = "团队复活"
local _____961F_4F0D_590D_6D3B_6B21_6570_952E = "次数"
local _____83B7_53D6_6240_6709_73A9_5BB6 = _G.GetPlayersAll
local AddPlayerTechResearched = jass.AddPlayerTechResearched
local CreateTrigger = jass.CreateTrigger
local DialogDestroy = jass.DialogDestroy
local DialogAddButton = jass.DialogAddButton
local DialogClear = jass.DialogClear
local DialogCreate = jass.DialogCreate
local DialogDisplay = jass.DialogDisplay
local GetClickedButton = jass.GetClickedButton
local GetHandleId = jass.GetHandleId
local GetPlayerName = jass.GetPlayerName
local GetTriggerPlayer = jass.GetTriggerPlayer
local Player = jass.Player
local SetUnitAbilityLevel = jass.SetUnitAbilityLevel
local TriggerRegisterDialogEvent = jass.TriggerRegisterDialogEvent
local _____5F53_524D_72B6_6001 = {["是否已初始化"] = false, ["是否已弹窗"] = false, ["是否已锁定选择"] = false}
local _____96BE_5EA6_9009_62E9_5BF9_8BDD_6846 = nil
local _____96BE_5EA6_9009_62E9_89E6_53D1_5668 = nil
local _____96BE_5EA6_6309_94AE_8BB0_5F55_8868 = {}
local function _____8BB0_5F55_9519_8BEF(...)
    debugLogForce(_____6A21_5757_540D, ...)
end
local function _____83B7_53D6_6E38_620F_96BE_5EA6_914D_7F6E_6620_5C04(_____6309_94AE)
    do
        local i = 0
        while i < #_____96BE_5EA6_6309_94AE_8BB0_5F55_8868 do
            local _____8BB0_5F55 = _____96BE_5EA6_6309_94AE_8BB0_5F55_8868[i + 1]
            if _____8BB0_5F55["按钮"] == _____6309_94AE then
                return _____8BB0_5F55["配置"]
            end
            i = i + 1
        end
    end
    return nil
end
local function _____83B7_53D6_6240_6709_73A9_5BB6_53E5_67C4()
    if type(_____83B7_53D6_6240_6709_73A9_5BB6) == "function" then
        return _____83B7_53D6_6240_6709_73A9_5BB6()
    end
    return nil
end
local function _____89E3_6790_5355_4F4D_7C7B_578BID(_____5355_4F4D_540D)
    local ____temp_9
    if _____5355_4F4D_540D == nil then
        ____temp_9 = nil
    else
        ____temp_9 = _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID(_____5355_4F4D_540D)
    end
    local rawId = ____temp_9
    if rawId == nil or rawId == "" then
        _____8BB0_5F55_9519_8BEF("单位反查失败", _____5355_4F4D_540D or "<empty>")
        return 0
    end
    return stringToFourCCSafe(rawId)
end
local function _____89E3_6790_6280_80FD_7C7B_578BID(_____6280_80FD_540D)
    local ____temp_10
    if _____6280_80FD_540D == nil then
        ____temp_10 = nil
    else
        ____temp_10 = _____6309_540D_5B57_53CD_67E5_6280_80FDID(_____6280_80FD_540D)
    end
    local rawId = ____temp_10
    if rawId == nil or rawId == "" then
        _____8BB0_5F55_9519_8BEF("技能反查失败", _____6280_80FD_540D or "<empty>")
        return 0
    end
    return stringToFourCCSafe(rawId)
end
local function _____8BBE_7F6E_5168_5C40_96BE_5EA6_53D8_91CF(_____914D_7F6E)
    jglobals[_____6E38_620F_96BE_5EA6_5168_5C40_53D8_91CF_540D] = _____914D_7F6E["难度值"]
    jglobals[_____5F31_70B9_6570_91CF_5168_5C40_53D8_91CF_540D] = _____914D_7F6E["弱点数量"]
    setGameDifficulty(_____914D_7F6E["难度值"])
end
local function _____8BBE_7F6E_56E2_961F_590D_6D3B_6B21_6570(_____914D_7F6E)
    YDUserDataSetSafe(
        "string",
        _____961F_4F0D_590D_6D3B_8868_540D,
        _____961F_4F0D_590D_6D3B_6B21_6570_952E,
        "integer",
        _____914D_7F6E["团队复活次数"]
    )
end
local function _____5E94_7528_654C_65B9_79D1_6280(_____914D_7F6E)
    if _____914D_7F6E["敌方普通生命科技ID"] ~= nil and _____914D_7F6E["敌方普通生命科技ID"] ~= "" and (_____914D_7F6E["敌方普通生命科技等级"] or 0) > 0 then
        AddPlayerTechResearched(
            _____4E2D_7ACB_654C_5BF9_73A9_5BB6,
            stringToFourCCSafe(_____914D_7F6E["敌方普通生命科技ID"]),
            _____914D_7F6E["敌方普通生命科技等级"] or 0
        )
    end
    if _____914D_7F6E["敌方精英Boss生命科技ID"] ~= nil and _____914D_7F6E["敌方精英Boss生命科技ID"] ~= "" and (_____914D_7F6E["敌方精英Boss生命科技等级"] or 0) > 0 then
        AddPlayerTechResearched(
            _____4E2D_7ACB_654C_5BF9_73A9_5BB6,
            stringToFourCCSafe(_____914D_7F6E["敌方精英Boss生命科技ID"]),
            _____914D_7F6E["敌方精英Boss生命科技等级"] or 0
        )
    end
end
local function _____521B_5EFA_96BE_5EA6_4F7F_8005(owner, _____5355_4F4D_7C7B_578BID, _____6280_80FD_7C7B_578BID, _____6280_80FD_7B49_7EA7)
    if _____5355_4F4D_7C7B_578BID <= 0 then
        return nil
    end
    local unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        owner,
        _____5355_4F4D_7C7B_578BID,
        _____96BE_5EA6_4F7F_8005_521B_5EFAX,
        _____96BE_5EA6_4F7F_8005_521B_5EFAY,
        _____96BE_5EA6_4F7F_8005_671D_5411
    )
    if unit == nil or unit == 0 then
        _____8BB0_5F55_9519_8BEF(
            "创建难度使者失败",
            "owner=",
            GetHandleId(owner),
            "unitTypeId=",
            _____5355_4F4D_7C7B_578BID
        )
        return nil
    end
    if _____6280_80FD_7C7B_578BID > 0 and _____6280_80FD_7B49_7EA7 > 0 then
        SetUnitAbilityLevel(unit, _____6280_80FD_7C7B_578BID, _____6280_80FD_7B49_7EA7)
    end
    return unit
end
local function _____5E94_7528_96BE_5EA6_4F7F_8005_5149_73AF(_____914D_7F6E)
    local _____5355_4F4D_7C7B_578BID = _____89E3_6790_5355_4F4D_7C7B_578BID(_____914D_7F6E["难度使者单位名"])
    local _____6280_80FD_7C7B_578BID = _____89E3_6790_6280_80FD_7C7B_578BID(_____914D_7F6E["敌方攻击光环技能名"])
    local _____6280_80FD_7B49_7EA7 = _____914D_7F6E["敌方攻击光环等级"] or 0
    if _____5355_4F4D_7C7B_578BID <= 0 then
        return
    end
    _____521B_5EFA_96BE_5EA6_4F7F_8005(_____7B2C_4E00_4E2A_96BE_5EA6_4F7F_8005_73A9_5BB6, _____5355_4F4D_7C7B_578BID, _____6280_80FD_7C7B_578BID, _____6280_80FD_7B49_7EA7)
    _____521B_5EFA_96BE_5EA6_4F7F_8005(_____4E2D_7ACB_654C_5BF9_73A9_5BB6, _____5355_4F4D_7C7B_578BID, _____6280_80FD_7C7B_578BID, _____6280_80FD_7B49_7EA7)
end
local function _____53D1_9001_96BE_5EA6_9009_62E9_516C_544A(_____9009_62E9_73A9_5BB6, _____914D_7F6E)
    local _____73A9_5BB6_540D = _____9009_62E9_73A9_5BB6 ~= nil and _____9009_62E9_73A9_5BB6 ~= 0 and GetPlayerName(_____9009_62E9_73A9_5BB6) or "未知玩家"
    local _____73A9_5BB6_7EC4 = _____83B7_53D6_6240_6709_73A9_5BB6_53E5_67C4()
    if _____73A9_5BB6_7EC4 == nil or _____73A9_5BB6_7EC4 == 0 then
        _____8BB0_5F55_9519_8BEF("GetPlayersAll 不可用，跳过难度公告")
        return
    end
    local ____QuestMessageBJ_12 = QuestMessageBJ
    local ____jglobals_bj_QUESTMESSAGE_WARNING_11 = jglobals.bj_QUESTMESSAGE_WARNING
    if ____jglobals_bj_QUESTMESSAGE_WARNING_11 == nil then
        ____jglobals_bj_QUESTMESSAGE_WARNING_11 = 12
    end
    ____QuestMessageBJ_12(
        _____73A9_5BB6_7EC4,
        ____jglobals_bj_QUESTMESSAGE_WARNING_11,
        (((((("|cffffff00『系统消息』：|r玩家" .. _____73A9_5BB6_540D) .. "选择了难度") .. tostring(_____914D_7F6E["难度值"])) .. "『") .. _____914D_7F6E["难度标题"]) .. "』，") .. _____914D_7F6E["公告文本"]
    )
end
local function _____9500_6BC1_96BE_5EA6_5BF9_8BDD_6846()
    if _____96BE_5EA6_9009_62E9_5BF9_8BDD_6846 ~= nil and _____96BE_5EA6_9009_62E9_5BF9_8BDD_6846 ~= 0 then
        DialogDisplay(_____663E_793A_5BF9_8BDD_6846_73A9_5BB6, _____96BE_5EA6_9009_62E9_5BF9_8BDD_6846, false)
        DialogClear(_____96BE_5EA6_9009_62E9_5BF9_8BDD_6846)
        DialogDestroy(_____96BE_5EA6_9009_62E9_5BF9_8BDD_6846)
        _____96BE_5EA6_9009_62E9_5BF9_8BDD_6846 = nil
    end
    if _____96BE_5EA6_9009_62E9_89E6_53D1_5668 ~= nil and _____96BE_5EA6_9009_62E9_89E6_53D1_5668 ~= 0 then
        safeDestroyTrigger(_____96BE_5EA6_9009_62E9_89E6_53D1_5668)
        _____96BE_5EA6_9009_62E9_89E6_53D1_5668 = nil
    end
    _____96BE_5EA6_6309_94AE_8BB0_5F55_8868 = {}
end
local function _____5E94_7528_6E38_620F_96BE_5EA6(_____914D_7F6E, _____9009_62E9_73A9_5BB6)
    _____5F53_524D_72B6_6001["是否已锁定选择"] = true
    _____5F53_524D_72B6_6001["当前难度值"] = _____914D_7F6E["难度值"]
    _____5F53_524D_72B6_6001["当前难度标题"] = _____914D_7F6E["难度标题"]
    _____8BBE_7F6E_56E2_961F_590D_6D3B_6B21_6570(_____914D_7F6E)
    _____8BBE_7F6E_5168_5C40_96BE_5EA6_53D8_91CF(_____914D_7F6E)
    _____5E94_7528_654C_65B9_79D1_6280(_____914D_7F6E)
    _____5E94_7528_96BE_5EA6_4F7F_8005_5149_73AF(_____914D_7F6E)
    _____53D1_9001_96BE_5EA6_9009_62E9_516C_544A(_____9009_62E9_73A9_5BB6, _____914D_7F6E)
    _____9500_6BC1_96BE_5EA6_5BF9_8BDD_6846()
end
local function ____on_96BE_5EA6_5BF9_8BDD_6846_70B9_51FB()
    if _____5F53_524D_72B6_6001["是否已锁定选择"] then
        return
    end
    local _____70B9_51FB_6309_94AE = GetClickedButton()
    if _____70B9_51FB_6309_94AE == nil or _____70B9_51FB_6309_94AE == 0 then
        return
    end
    local _____914D_7F6E = _____83B7_53D6_6E38_620F_96BE_5EA6_914D_7F6E_6620_5C04(_____70B9_51FB_6309_94AE)
    if _____914D_7F6E == nil then
        _____8BB0_5F55_9519_8BEF("无法匹配被点击的难度按钮")
        return
    end
    _____5E94_7528_6E38_620F_96BE_5EA6(
        _____914D_7F6E,
        GetTriggerPlayer()
    )
end
local function _____6DFB_52A0_96BE_5EA6_6309_94AE(_____5BF9_8BDD_6846, _____914D_7F6E)
    local _____70ED_952E_5B57_7B26 = string.byte(
        tostring(_____914D_7F6E["难度值"]),
        1
    ) or 0 / 0
    local _____6309_94AE = DialogAddButton(_____5BF9_8BDD_6846, _____914D_7F6E["按钮文本"], _____70ED_952E_5B57_7B26)
    _____96BE_5EA6_6309_94AE_8BB0_5F55_8868[#_____96BE_5EA6_6309_94AE_8BB0_5F55_8868 + 1] = {["按钮"] = _____6309_94AE, ["配置"] = _____914D_7F6E}
end
____exports["显示游戏难度选择对话框"] = function()
    if _____5F53_524D_72B6_6001["是否已弹窗"] or _____5F53_524D_72B6_6001["是否已锁定选择"] then
        return
    end
    _____5F53_524D_72B6_6001["是否已弹窗"] = true
    _____96BE_5EA6_9009_62E9_5BF9_8BDD_6846 = DialogCreate()
    if _____96BE_5EA6_9009_62E9_5BF9_8BDD_6846 == nil or _____96BE_5EA6_9009_62E9_5BF9_8BDD_6846 == 0 then
        _____8BB0_5F55_9519_8BEF("创建难度对话框失败")
        return
    end
    jass.DialogSetMessage(_____96BE_5EA6_9009_62E9_5BF9_8BDD_6846, _____5BF9_8BDD_6846_6807_9898)
    do
        local i = 0
        while i < #_____6E38_620F_96BE_5EA6_914D_7F6E_8868 do
            _____6DFB_52A0_96BE_5EA6_6309_94AE(_____96BE_5EA6_9009_62E9_5BF9_8BDD_6846, _____6E38_620F_96BE_5EA6_914D_7F6E_8868[i + 1])
            i = i + 1
        end
    end
    _____96BE_5EA6_9009_62E9_89E6_53D1_5668 = CreateTrigger()
    if _____96BE_5EA6_9009_62E9_89E6_53D1_5668 == nil or _____96BE_5EA6_9009_62E9_89E6_53D1_5668 == 0 then
        _____8BB0_5F55_9519_8BEF("创建难度对话框触发器失败")
        _____9500_6BC1_96BE_5EA6_5BF9_8BDD_6846()
        return
    end
    TriggerRegisterDialogEvent(_____96BE_5EA6_9009_62E9_89E6_53D1_5668, _____96BE_5EA6_9009_62E9_5BF9_8BDD_6846)
    safeTriggerAddAction(_____96BE_5EA6_9009_62E9_89E6_53D1_5668, ____on_96BE_5EA6_5BF9_8BDD_6846_70B9_51FB)
    DialogDisplay(_____663E_793A_5BF9_8BDD_6846_73A9_5BB6, _____96BE_5EA6_9009_62E9_5BF9_8BDD_6846, true)
end
____exports["获取游戏难度配置表"] = function()
    return _____6E38_620F_96BE_5EA6_914D_7F6E_8868
end
____exports["获取游戏难度选择延迟秒"] = function()
    return _____6E38_620F_96BE_5EA6_9009_62E9_5EF6_8FDF_79D2
end
____exports["获取游戏难度选择状态"] = function()
    return _____5F53_524D_72B6_6001
end
____exports["初始化游戏难度选择"] = function()
    if _____5F53_524D_72B6_6001["是否已初始化"] then
        return
    end
    _____5F53_524D_72B6_6001["是否已初始化"] = true
    addDelayedCallback(_____6E38_620F_96BE_5EA6_9009_62E9_5EF6_8FDF_79D2 * 1000, ____exports["显示游戏难度选择对话框"])
end
return ____exports
