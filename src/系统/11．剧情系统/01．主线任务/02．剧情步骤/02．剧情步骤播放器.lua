local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__Number = ____lualib.__TS__Number
local __TS__Delete = ____lualib.__TS__Delete
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
local _____8BA1_7B97_6B65_9AA4_6301_7EED_65F6_95F4, _____5B89_6392_4E0B_4E00_6B65, _____7ED3_675F_5F53_524D_5267_60C5_7247_6BB5, ____on_5267_60C5_4E0B_4E00_6B65_8BA1_65F6_5668_5230_671F, ____on_5267_60C5_7EDD_5BF9_65F6_95F4_52A8_4F5C_5230_671F, _____6267_884C_5BF9_767D_6B65_9AA4, _____6267_884C_7B49_5F85_6B65_9AA4, _____6267_884C_81EA_5B9A_4E49_52A8_4F5C_6B65_9AA4, _____8BFB_53D6YD_5355_4F4D_5F15_7528, _____6267_884CBoss_6218_542F_52A8_6B65_9AA4, _____6267_884C_7ED9_7269_54C1_6B65_9AA4, _____6267_884C_5F53_524D_5267_60C5_6B65_9AA4, safeTimerStart, safeDestroyTimer, TransmissionFromUnitWithNameBJ, CinematicModeBJ, YDUserDataGetSafe, YDUserDataSetSafe, _____542F_52A8Boss_6218_8FD0_884C, _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E, debugLogForce, CreateTimer, GetExpiredTimer, GetHandleId, GetPlayersAll, PauseUnit, SetUnitInvulnerable, bj_TIMETYPE_SET, _____5267_60C5_64AD_653E_5668_6A21_5757_540D, ____Boss_6218_8868_540D, ____Boss_6218_7ED1_5B9A_5355_4F4D_5B57_6BB5, ____Boss_6218_89E6_53D1_73A9_5BB6_5B57_6BB5, _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001, _____5F53_524D_7247_6BB5, _____7EDD_5BF9_65F6_95F4_52A8_4F5C_4E0A_4E0B_6587_8868
local ____01_FF0E_5267_60C5_7247_6BB5_914D_7F6E_8868 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．剧情片段配置表")
local _____4E3B_7EBF_5267_60C5_7247_6BB5_914D_7F6E_8868 = ____01_FF0E_5267_60C5_7247_6BB5_914D_7F6E_8868.default
local ____04_FF0E_4E3B_7EBF_5267_60C5_52A8_4F5C_6CE8_518C_8868 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.04．主线剧情动作注册表")
local _____6267_884C_4E3B_7EBF_5267_60C5_52A8_4F5C = ____04_FF0E_4E3B_7EBF_5267_60C5_52A8_4F5C_6CE8_518C_8868["执行主线剧情动作"]
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入当前剧情动作上下文"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____6309_540D_5B57_7ED9_89E6_53D1_5355_4F4D_7269_54C1 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["按名字给触发单位物品"]
local _____6267_884C_901A_7528_5267_60C5_52A8_4F5C = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["执行通用剧情动作"]
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
    local timer = CreateTimer()
    if timer == nil or timer == 0 then
        return
    end
    safeTimerStart(
        timer,
        _____8BA1_7B97_6B65_9AA4_6301_7EED_65F6_95F4(delaySeconds),
        false,
        ____on_5267_60C5_4E0B_4E00_6B65_8BA1_65F6_5668_5230_671F
    )
end
function _____7ED3_675F_5F53_524D_5267_60C5_7247_6BB5()
    local _____7247_6BB5ID = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前片段ID"] or ""
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["是否正在播放"] = false
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["是否请求跳过"] = false
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] = 0
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前片段ID"] = nil
    _____5F53_524D_7247_6BB5 = nil
    CinematicModeBJ(
        false,
        GetPlayersAll()
    )
    if _____7247_6BB5ID ~= "" then
        debugLogForce(_____5267_60C5_64AD_653E_5668_6A21_5757_540D, "剧情片段结束", _____7247_6BB5ID)
    end
end
function ____on_5267_60C5_4E0B_4E00_6B65_8BA1_65F6_5668_5230_671F()
    local timer = GetExpiredTimer()
    safeDestroyTimer(timer)
    _____6267_884C_5F53_524D_5267_60C5_6B65_9AA4()
end
function ____on_5267_60C5_7EDD_5BF9_65F6_95F4_52A8_4F5C_5230_671F()
    local timer = GetExpiredTimer()
    local handleId = GetHandleId(timer)
    local _____4E0A_4E0B_6587 = _____7EDD_5BF9_65F6_95F4_52A8_4F5C_4E0A_4E0B_6587_8868[handleId]
    __TS__Delete(_____7EDD_5BF9_65F6_95F4_52A8_4F5C_4E0A_4E0B_6587_8868, handleId)
    safeDestroyTimer(timer)
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    if not _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["是否正在播放"] then
        return
    end
    if _____4E0A_4E0B_6587["播放世代"] ~= _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["播放世代"] then
        return
    end
    if _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["是否请求跳过"] then
        return
    end
    _____6267_884C_4E3B_7EBF_5267_60C5_52A8_4F5C(_____4E0A_4E0B_6587["动作ID"], _____4E0A_4E0B_6587["参数"])
end
function _____6267_884C_5BF9_767D_6B65_9AA4(_____6B65_9AA4)
    if _____6B65_9AA4.type ~= "dialog" and _____6B65_9AA4.type ~= "broadcast" then
        return
    end
    local _____8BF4_8BDD_8005 = _____6B65_9AA4["说话者"] or "系统"
    local _____6587_672C = _____6B65_9AA4["文本"]
    local _____6301_7EED_65F6_95F4 = _____6B65_9AA4["持续时间"] or 3
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
    _____6267_884C_4E3B_7EBF_5267_60C5_52A8_4F5C(_____6B65_9AA4["动作ID"], _____53C2_6570)
    _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["当前步骤索引"] + 1
    _____6267_884C_5F53_524D_5267_60C5_6B65_9AA4()
end
function _____8BFB_53D6YD_5355_4F4D_5F15_7528(_____5F15_7528)
    if _____5F15_7528 == nil or _____5F15_7528 == "" then
        return nil
    end
    local splitIndex = (string.find(_____5F15_7528, ".", nil, true) or 0) - 1
    if splitIndex < 0 then
        return nil
    end
    local tableName = __TS__StringSubstring(_____5F15_7528, 0, splitIndex)
    local keyName = __TS__StringSubstring(_____5F15_7528, splitIndex + 1)
    if tableName == "" or keyName == "" then
        return nil
    end
    return YDUserDataGetSafe("string", tableName, keyName, "unit")
end
function _____6267_884CBoss_6218_542F_52A8_6B65_9AA4(_____6B65_9AA4)
    if _____6B65_9AA4.type ~= "startBossFight" then
        return
    end
    local ____8BFB_53D6YD_5355_4F4D_5F15_7528_result_6 = _____8BFB_53D6YD_5355_4F4D_5F15_7528(_____6B65_9AA4["Boss引用"])
    if ____8BFB_53D6YD_5355_4F4D_5F15_7528_result_6 == nil then
        ____8BFB_53D6YD_5355_4F4D_5F15_7528_result_6 = _____8BFB_53D6YD_5355_4F4D_5F15_7528(_____6B65_9AA4["Boss名"] and "Boss." .. tostring(_____6B65_9AA4["Boss名"]) or nil)
    end
    local bossUnit = ____8BFB_53D6YD_5355_4F4D_5F15_7528_result_6
    if bossUnit ~= nil and bossUnit ~= 0 then
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
        PauseUnit(bossUnit, false)
        SetUnitInvulnerable(bossUnit, false)
        _____542F_52A8Boss_6218_8FD0_884C(bossUnit)
    end
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
        local ____switch49 = _____6B65_9AA4.type
        local ____cond49 = ____switch49 == "dialog" or ____switch49 == "broadcast"
        if ____cond49 then
            _____6267_884C_5BF9_767D_6B65_9AA4(_____6B65_9AA4)
            return
        end
        ____cond49 = ____cond49 or ____switch49 == "wait"
        if ____cond49 then
            _____6267_884C_7B49_5F85_6B65_9AA4(_____6B65_9AA4)
            return
        end
        ____cond49 = ____cond49 or ____switch49 == "runAction"
        if ____cond49 then
            _____6267_884C_81EA_5B9A_4E49_52A8_4F5C_6B65_9AA4(_____6B65_9AA4)
            return
        end
        ____cond49 = ____cond49 or ____switch49 == "startBossFight"
        if ____cond49 then
            _____6267_884CBoss_6218_542F_52A8_6B65_9AA4(_____6B65_9AA4)
            return
        end
        ____cond49 = ____cond49 or ____switch49 == "giveItem"
        if ____cond49 then
            _____6267_884C_7ED9_7269_54C1_6B65_9AA4(_____6B65_9AA4)
            return
        end
        do
            local ____6267_884C_901A_7528_5267_60C5_52A8_4F5C_8 = _____6267_884C_901A_7528_5267_60C5_52A8_4F5C
            local ____6B65_9AA4__53C2_6570_7 = _____6B65_9AA4["参数"]
            if ____6B65_9AA4__53C2_6570_7 == nil then
                ____6B65_9AA4__53C2_6570_7 = {}
            end
            ____6267_884C_901A_7528_5267_60C5_52A8_4F5C_8(____6B65_9AA4__53C2_6570_7)
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
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
safeTimerStart = ____require_result_0.safeTimerStart
safeDestroyTimer = ____require_result_0.safeDestroyTimer
local ____require_result_1 = require("lib.扩展函数.BJ函数.05A．电影函数")
TransmissionFromUnitWithNameBJ = ____require_result_1.TransmissionFromUnitWithNameBJ
CinematicModeBJ = ____require_result_1.CinematicModeBJ
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDUserDataGetSafe = ____require_result_2.YDUserDataGetSafe
YDUserDataSetSafe = ____require_result_2.YDUserDataSetSafe
local ____require_result_3 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.03．Boss战运行驱动")
_____542F_52A8Boss_6218_8FD0_884C = ____require_result_3["启动Boss战运行"]
local ____require_result_4 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.03．战斗启动属性.04．战斗启动属性应用")
_____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_4["应用Boss战启动属性配置"]
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_5.debugLogForce
CreateTimer = jass.CreateTimer
local CreateTrigger = jass.CreateTrigger
GetExpiredTimer = jass.GetExpiredTimer
GetHandleId = jass.GetHandleId
GetPlayersAll = jass.GetPlayersAll
local GetTriggerPlayer = jass.GetTriggerPlayer
PauseUnit = jass.PauseUnit
local Player = jass.Player
local QuestMessageBJ = jass.QuestMessageBJ
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
local _____9ED8_8BA4_5267_60C5_64AD_653E_5668_8FD0_884C_65F6 = {
    ["当前步骤索引"] = 0,
    ["当前倍速"] = 1,
    ["是否正在播放"] = false,
    ["是否请求跳过"] = false,
    ["播放世代"] = 0
}
_____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001 = __TS__ObjectAssign({}, _____9ED8_8BA4_5267_60C5_64AD_653E_5668_8FD0_884C_65F6)
local _____5DF2_521D_59CB_5316_5267_60C5_6B65_9AA4_64AD_653E_5668 = false
_____7EDD_5BF9_65F6_95F4_52A8_4F5C_4E0A_4E0B_6587_8868 = {}
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
    local timer = CreateTimer()
    if timer == nil or timer == 0 then
        return
    end
    local handleId = GetHandleId(timer)
    _____7EDD_5BF9_65F6_95F4_52A8_4F5C_4E0A_4E0B_6587_8868[handleId] = {["播放世代"] = _____5267_60C5_64AD_653E_5668_8FD0_884C_65F6_72B6_6001["播放世代"], ["动作ID"] = _____6B65_9AA4["动作ID"], ["参数"] = _____53C2_6570}
    safeTimerStart(
        timer,
        _____8BA1_7B97_6B65_9AA4_6301_7EED_65F6_95F4(_____65F6_95F4_79D2),
        false,
        ____on_5267_60C5_7EDD_5BF9_65F6_95F4_52A8_4F5C_5230_671F
    )
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
