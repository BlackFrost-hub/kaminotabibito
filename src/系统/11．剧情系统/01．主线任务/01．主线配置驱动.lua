local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__Delete = ____lualib.__TS__Delete
local __TS__StringCharCodeAt = ____lualib.__TS__StringCharCodeAt
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____00_FF0E_4E3B_7EBF_4EFB_52A1_914D_7F6E_8868 = require("系统.11．剧情系统.01．主线任务.00．主线任务配置表")
local _____53EF_76F4_63A5_8FC1_79FB_5267_60C5_4E3B_7EBF_4EFB_52A1_914D_7F6E_8868 = ____00_FF0E_4E3B_7EBF_4EFB_52A1_914D_7F6E_8868["可直接迁移剧情主线任务配置表"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_0.safeTimerStart
local safeDestroyTimer = ____require_result_0.safeDestroyTimer
local ____require_result_1 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_1.QuestMessageBJ
local ____require_result_2 = require("lib.扩展函数.BJ函数.05A．电影函数")
local TransmissionFromUnitWithNameBJ = ____require_result_2.TransmissionFromUnitWithNameBJ
local ____require_result_3 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_3.GetPlayersAll
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_4.addPeriodicCallback
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_5.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_5.YDUserDataSetSafe
local ____require_result_6 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_6.getRegisteredPlayerHero
local ____require_result_7 = require("系统.08．任务系统.00．任务系统二分开关")
local ENABLE_QUEST_MAINLINE_DRIVER = ____require_result_7.ENABLE_QUEST_MAINLINE_DRIVER
local ____require_result_8 = require("系统.08．任务系统.01．任务数据")
local questDB = ____require_result_8.questDB
local QuestType = ____require_result_8.QuestType
local QuestStatus = ____require_result_8.QuestStatus
local ____require_result_9 = require("系统.08．任务系统.02．任务管理器")
local questManager = ____require_result_9.questManager
local ____require_result_10 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_10.debugLogForce
local CreateTimer = jass.CreateTimer
local GetExpiredTimer = jass.GetExpiredTimer
local GetHandleId = jass.GetHandleId
local GetUnitLoc = jass.GetUnitLoc
local Player = jass.Player
local RemoveLocation = jass.RemoveLocation
local R2I = jass.R2I
local _____4E3B_7EBF_8FD0_884C_65F6_4EFB_52A1ID = "main_story_runtime"
local _____4E3B_7EBF_9A71_52A8_6A21_5757_540D = "11．剧情系统-主线配置驱动"
local _____5EF6_8FDF_52A8_4F5C_4E0A_4E0B_6587_8868 = {}
local _____4E3B_7EBF_9A71_52A8_5DF2_521D_59CB_5316 = false
local _____4E3B_7EBF_9A71_52A8_6B63_5728_6267_884C = false
local function _____8BFB_53D6_5267_60C5_8FDB_5EA6()
    return __TS__Number(YDUserDataGetSafe("string", "剧情进度", "整数", "integer")) or 0
end
local function _____5199_5165_5267_60C5_8FDB_5EA6(value)
    YDUserDataSetSafe(
        "string",
        "剧情进度",
        "整数",
        "integer",
        value
    )
end
local function _____786E_4FDD_4E3B_7EBF_8FD0_884C_65F6_4EFB_52A1()
    if questDB:getQuest(_____4E3B_7EBF_8FD0_884C_65F6_4EFB_52A1ID) then
        return
    end
    questDB:registerQuest({
        id = _____4E3B_7EBF_8FD0_884C_65F6_4EFB_52A1ID,
        type = QuestType.MAIN,
        title = "主线任务",
        description = "剧情进行中",
        objectives = {{
            id = "stage",
            description = "推进主线剧情",
            current = 0,
            required = 1,
            completed = false
        }},
        rewards = {},
        status = QuestStatus.UNDISCOVERED,
        icon = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",
        createdAt = os.time(),
        updatedAt = os.time()
    })
    questDB:acceptQuest(0, _____4E3B_7EBF_8FD0_884C_65F6_4EFB_52A1ID)
end
local function _____5237_65B0_4E3B_7EBF_4EFB_52A1UI(_____4EFB_52A1_63CF_8FF0, _____63D0_793A_6587_672C)
    local ____opt_13 = questDB.globalData
    if ____opt_13 ~= nil then
        ____opt_13 = ____opt_13.quests
    end
    local ____opt_result_15
    if ____opt_13 ~= nil then
        ____opt_result_15 = ____opt_13:get(_____4E3B_7EBF_8FD0_884C_65F6_4EFB_52A1ID)
    end
    local _____4EFB_52A1 = ____opt_result_15
    if _____4EFB_52A1 ~= nil then
        if type(_____4EFB_52A1_63CF_8FF0) == "string" and _____4EFB_52A1_63CF_8FF0 ~= "" then
            _____4EFB_52A1.description = _____4EFB_52A1_63CF_8FF0
        end
        _____4EFB_52A1.updatedAt = os.time()
    end
    local _____5237_65B0_51FD_6570 = questManager.triggerUIRefresh
    if type(_____5237_65B0_51FD_6570) == "function" then
        _____5237_65B0_51FD_6570:call(questManager, 0, _____4E3B_7EBF_8FD0_884C_65F6_4EFB_52A1ID)
    end
    if type(_____63D0_793A_6587_672C) == "string" and _____63D0_793A_6587_672C ~= "" then
        QuestMessageBJ(
            GetPlayersAll(),
            jglobals.bj_QUESTMESSAGE_UPDATED,
            _____63D0_793A_6587_672C
        )
    end
end
local function _____89E3_6790_5BF9_8BDD_9884_89C8(dialogPreview)
    if not dialogPreview then
        return {}
    end
    local _____7ED3_679C = {}
    local _____884C_5217_8868 = __TS__StringSplit(dialogPreview, "\n")
    do
        local i = 0
        while i < #_____884C_5217_8868 do
            do
                local line = __TS__StringTrim(_____884C_5217_8868[i + 1])
                if line == "" then
                    goto __continue14
                end
                local dot = (string.find(line, ".", nil, true) or 0) - 1
                if dot <= 0 then
                    goto __continue14
                end
                local _____5E8F_53F7_6587_672C = __TS__StringTrim(__TS__StringSubstring(line, 0, dot))
                if _____5E8F_53F7_6587_672C == "" or __TS__Number(_____5E8F_53F7_6587_672C) <= 0 then
                    goto __continue14
                end
                local _____4E3B_4F53 = __TS__StringTrim(__TS__StringSubstring(line, dot + 1))
                local _____5206_9694_7B26_4F4D_7F6E = (string.find(_____4E3B_4F53, "：", nil, true) or 0) - 1
                if _____5206_9694_7B26_4F4D_7F6E < 0 then
                    _____5206_9694_7B26_4F4D_7F6E = (string.find(_____4E3B_4F53, ":", nil, true) or 0) - 1
                end
                if _____5206_9694_7B26_4F4D_7F6E <= 0 then
                    goto __continue14
                end
                local _____8BF4_8BDD_8005 = __TS__StringTrim(__TS__StringSubstring(_____4E3B_4F53, 0, _____5206_9694_7B26_4F4D_7F6E))
                local _____6587_672C = __TS__StringTrim(__TS__StringSubstring(_____4E3B_4F53, _____5206_9694_7B26_4F4D_7F6E + 1))
                if _____8BF4_8BDD_8005 == "" or _____6587_672C == "" then
                    goto __continue14
                end
                _____7ED3_679C[#_____7ED3_679C + 1] = {["说话者"] = _____8BF4_8BDD_8005, ["文本"] = _____6587_672C}
            end
            ::__continue14::
            i = i + 1
        end
    end
    return _____7ED3_679C
end
local function _____8BA1_7B97_5BF9_8BDD_6301_7EED_79D2_6570(_____6587_672C)
    local t = 1 + R2I(#_____6587_672C / 10)
    if t < 2 then
        return 2
    end
    if t > 12 then
        return 12
    end
    return t
end
local function _____64AD_653E_4E3B_7EBF_5BF9_8BDD(dialogPreview)
    local _____5BF9_8BDD_5217_8868 = _____89E3_6790_5BF9_8BDD_9884_89C8(dialogPreview)
    do
        local i = 0
        while i < #_____5BF9_8BDD_5217_8868 do
            local _____5BF9_8BDD = _____5BF9_8BDD_5217_8868[i + 1]
            TransmissionFromUnitWithNameBJ(
                GetPlayersAll(),
                nil,
                _____5BF9_8BDD["说话者"],
                nil,
                _____5BF9_8BDD["文本"],
                jglobals.bj_TIMETYPE_SET,
                _____8BA1_7B97_5BF9_8BDD_6301_7EED_79D2_6570(_____5BF9_8BDD["文本"]),
                true
            )
            i = i + 1
        end
    end
end
local function _____79FB_9664_884C_5185_5757_6CE8_91CA(s)
    local _____7ED3_679C = s
    while true do
        local left = (string.find(_____7ED3_679C, "/*", nil, true) or 0) - 1
        if left < 0 then
            break
        end
        local right = (string.find(
            _____7ED3_679C,
            "*/",
            math.max(left + 2 + 1, 1),
            true
        ) or 0) - 1
        if right < 0 then
            _____7ED3_679C = __TS__StringSubstring(_____7ED3_679C, 0, left)
            break
        end
        _____7ED3_679C = __TS__StringSubstring(_____7ED3_679C, 0, left) .. __TS__StringSubstring(_____7ED3_679C, right + 2)
    end
    return _____7ED3_679C
end
local function _____6E05_7406_52A8_4F5C_4EE3_7801(raw)
    local _____7ED3_679C = __TS__StringTrim(_____79FB_9664_884C_5185_5757_6CE8_91CA(raw))
    if _____7ED3_679C == "" then
        return ""
    end
    if (string.find(_____7ED3_679C, "//", nil, true) or 0) - 1 == 0 then
        return ""
    end
    if (string.find(_____7ED3_679C, "call ", nil, true) or 0) - 1 == 0 then
        _____7ED3_679C = __TS__StringTrim(__TS__StringSubstring(_____7ED3_679C, 5))
    end
    if (string.find(_____7ED3_679C, "set ", nil, true) or 0) - 1 == 0 then
        _____7ED3_679C = __TS__StringTrim(__TS__StringSubstring(_____7ED3_679C, 4))
    end
    return _____7ED3_679C
end
local function _____89E3_6790_52A8_4F5C_65F6_95F4_8F74(timeline)
    if not timeline then
        return {}
    end
    local _____7ED3_679C = {}
    local _____884C_5217_8868 = __TS__StringSplit(timeline, "\n")
    do
        local i = 0
        while i < #_____884C_5217_8868 do
            do
                local line = __TS__StringTrim(_____884C_5217_8868[i + 1])
                if line == "" then
                    goto __continue39
                end
                local dot = (string.find(line, ".", nil, true) or 0) - 1
                if dot <= 0 then
                    goto __continue39
                end
                local _____5EF6_8FDF_79D2 = __TS__Number(__TS__StringTrim(__TS__StringSubstring(line, 0, dot)))
                if _____5EF6_8FDF_79D2 ~= _____5EF6_8FDF_79D2 then
                    goto __continue39
                end
                local _____4EE3_7801 = _____6E05_7406_52A8_4F5C_4EE3_7801(__TS__StringSubstring(line, dot + 1))
                if _____4EE3_7801 == "" then
                    goto __continue39
                end
                _____7ED3_679C[#_____7ED3_679C + 1] = {["延迟秒"] = _____5EF6_8FDF_79D2, ["代码"] = _____4EE3_7801}
            end
            ::__continue39::
            i = i + 1
        end
    end
    return _____7ED3_679C
end
local function _____521B_5EFA_4E3B_7EBF_6267_884C_73AF_5883(_____89E6_53D1_5355_4F4D)
    local _____5168_5C40 = _G
    local _____7F13_5B58_4F4D_7F6E = nil
    local env = {
        __triggerUnit = _____89E6_53D1_5355_4F4D,
        string = "string",
        integer = "integer",
        real = "real",
        unit = "unit",
        group = "group",
        player = "player",
        boolean = "boolean",
        GetTriggerUnit = function() return _____89E6_53D1_5355_4F4D end,
        YDLocal1Get = function(ty, key)
            if type(_____5168_5C40.YDLocal1Get) == "function" then
                return _____5168_5C40:YDLocal1Get(ty, key)
            end
            if ty == "location" and key == "单位位置" and _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
                if _____7F13_5B58_4F4D_7F6E == nil then
                    _____7F13_5B58_4F4D_7F6E = GetUnitLoc(_____89E6_53D1_5355_4F4D)
                end
                return _____7F13_5B58_4F4D_7F6E
            end
            return nil
        end
    }
    if type(_____5168_5C40.setmetatable) == "function" then
        _____5168_5C40:setmetatable(env, {__index = _____5168_5C40})
    end
    return env
end
local function _____6E05_7406_4E3B_7EBF_6267_884C_73AF_5883(env)
    if env == nil then
        return
    end
    local ____temp_16
    if env.YDLocal1Get ~= nil then
        ____temp_16 = env:YDLocal1Get("location", "单位位置")
    else
        ____temp_16 = nil
    end
    local _____4F4D_7F6E = ____temp_16
    if _____4F4D_7F6E ~= nil and _____4F4D_7F6E ~= 0 then
        RemoveLocation(_____4F4D_7F6E)
    end
end
local function _____89C4_8303_5316_6761_4EF6_8868_8FBE_5F0F(expr)
    local _____7ED3_679C = expr
    _____7ED3_679C = table.concat(
        __TS__StringSplit(_____7ED3_679C, "\\\""),
        "\""
    )
    _____7ED3_679C = table.concat(
        __TS__StringSplit(_____7ED3_679C, "GetTriggerUnit()"),
        "__triggerUnit"
    )
    return _____7ED3_679C
end
local function _____5224_65AD_4E3B_7EBF_6761_4EF6(expr, _____89E6_53D1_5355_4F4D)
    local loadFn = _G.loadstring
    local setfenvFn = _G.setfenv
    if type(loadFn) ~= "function" or type(setfenvFn) ~= "function" then
        return false
    end
    local fn = loadFn(("return (" .. _____89C4_8303_5316_6761_4EF6_8868_8FBE_5F0F(expr)) .. ")")
    if fn == nil then
        return false
    end
    local env = _____521B_5EFA_4E3B_7EBF_6267_884C_73AF_5883(_____89E6_53D1_5355_4F4D)
    setfenvFn(fn, env)
    do
        local function ____catch(_err)
            return true, false
        end
        local ____try, ____hasReturned, ____returnValue = pcall(function()
            return true, fn() == true
        end)
        if not ____try then
            ____hasReturned, ____returnValue = ____catch(____hasReturned)
        end
        do
            _____6E05_7406_4E3B_7EBF_6267_884C_73AF_5883(env)
        end
        if ____hasReturned then
            return ____returnValue
        end
    end
end
local function _____6267_884C_4E3B_7EBF_52A8_4F5C_4EE3_7801(_____4EE3_7801, _____89E6_53D1_5355_4F4D)
    local loadFn = _G.loadstring
    local setfenvFn = _G.setfenv
    if type(loadFn) ~= "function" or type(setfenvFn) ~= "function" then
        return
    end
    local fn = loadFn(_____4EE3_7801)
    if fn == nil then
        debugLogForce(_____4E3B_7EBF_9A71_52A8_6A21_5757_540D, "[动作编译失败]", _____4EE3_7801)
        return
    end
    local env = _____521B_5EFA_4E3B_7EBF_6267_884C_73AF_5883(_____89E6_53D1_5355_4F4D)
    setfenvFn(fn, env)
    do
        local function ____catch(err)
            debugLogForce(
                _____4E3B_7EBF_9A71_52A8_6A21_5757_540D,
                "[动作执行失败]",
                _____4EE3_7801,
                tostring(err)
            )
        end
        local ____try, ____hasReturned = pcall(function()
            fn()
        end)
        if not ____try then
            ____catch(____hasReturned)
        end
        do
            _____6E05_7406_4E3B_7EBF_6267_884C_73AF_5883(env)
        end
    end
end
local function ____on_4E3B_7EBF_5EF6_8FDF_52A8_4F5C_8BA1_65F6_5668_5230_671F()
    local t = GetExpiredTimer()
    if t == nil or t == 0 then
        return
    end
    local hid = GetHandleId(t)
    local _____4E0A_4E0B_6587 = _____5EF6_8FDF_52A8_4F5C_4E0A_4E0B_6587_8868[hid]
    __TS__Delete(_____5EF6_8FDF_52A8_4F5C_4E0A_4E0B_6587_8868, hid)
    safeDestroyTimer(t)
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    _____6267_884C_4E3B_7EBF_52A8_4F5C_4EE3_7801(_____4E0A_4E0B_6587["代码"], _____4E0A_4E0B_6587["触发单位"])
end
local function _____6267_884C_4E3B_7EBF_52A8_4F5C_65F6_95F4_8F74(timeline, _____89E6_53D1_5355_4F4D)
    local _____6761_76EE_5217_8868 = _____89E3_6790_52A8_4F5C_65F6_95F4_8F74(timeline)
    do
        local i = 0
        while i < #_____6761_76EE_5217_8868 do
            do
                local _____6761_76EE = _____6761_76EE_5217_8868[i + 1]
                if _____6761_76EE["延迟秒"] <= 0 then
                    _____6267_884C_4E3B_7EBF_52A8_4F5C_4EE3_7801(_____6761_76EE["代码"], _____89E6_53D1_5355_4F4D)
                    goto __continue72
                end
                local t = CreateTimer()
                if t == nil or t == 0 then
                    goto __continue72
                end
                local hid = GetHandleId(t)
                _____5EF6_8FDF_52A8_4F5C_4E0A_4E0B_6587_8868[hid] = {["代码"] = _____6761_76EE["代码"], ["触发单位"] = _____89E6_53D1_5355_4F4D}
                safeTimerStart(t, _____6761_76EE["延迟秒"], false, ____on_4E3B_7EBF_5EF6_8FDF_52A8_4F5C_8BA1_65F6_5668_5230_671F)
            end
            ::__continue72::
            i = i + 1
        end
    end
end
local function _____6536_96C6_5DF2_6CE8_518C_73A9_5BB6_82F1_96C4_5217_8868()
    local _____7ED3_679C = {}
    do
        local i = 0
        while i < 8 do
            local _____82F1_96C4 = getRegisteredPlayerHero(Player(i))
            if _____82F1_96C4 ~= nil and _____82F1_96C4 ~= 0 then
                _____7ED3_679C[#_____7ED3_679C + 1] = _____82F1_96C4
            end
            i = i + 1
        end
    end
    return _____7ED3_679C
end
local function _____547D_4E2D_524D_7F6E_9636_6BB5(_____914D_7F6E, _____5F53_524D_9636_6BB5)
    if _____914D_7F6E.fromStage == nil or _____914D_7F6E.fromStage == "*" then
        return true
    end
    return __TS__Number(_____914D_7F6E.fromStage) == _____5F53_524D_9636_6BB5
end
local function _____63D0_53D6_7591_4F3C_51FD_6570_540D(text)
    local _____7ED3_679C = {}
    local n = #text
    local i = 0
    while i < n do
        do
            local ch = __TS__StringCharCodeAt(text, i)
            local _____662F_8D77_59CB_5B57_7B26 = ch >= 65 and ch <= 90 or ch >= 97 and ch <= 122 or ch == 95
            if not _____662F_8D77_59CB_5B57_7B26 then
                i = i + 1
                goto __continue82
            end
            local start = i
            i = i + 1
            while i < n do
                local c = __TS__StringCharCodeAt(text, i)
                local _____662F_6807_8BC6_7B26_5B57_7B26 = c >= 65 and c <= 90 or c >= 97 and c <= 122 or c >= 48 and c <= 57 or c == 95
                if not _____662F_6807_8BC6_7B26_5B57_7B26 then
                    break
                end
                i = i + 1
            end
            local j = i
            while j < n and (__TS__StringCharAt(text, j) == " " or __TS__StringCharAt(text, j) == "\t") do
                j = j + 1
            end
            if j < n and __TS__StringCharAt(text, j) == "(" then
                _____7ED3_679C[#_____7ED3_679C + 1] = __TS__StringSubstring(text, start, i)
            end
        end
        ::__continue82::
    end
    return _____7ED3_679C
end
local function _____662F_5DF2_77E5_51FD_6570(name)
    local _____5168_5C40 = _G
    if type(_____5168_5C40[name]) == "function" then
        return true
    end
    if type(jass[name]) == "function" then
        return true
    end
    return false
end
local function _____8F93_51FA_4E3B_7EBF_517C_5BB9_8BCA_65AD()
    local _____6761_4EF6_7F3A_5931 = __TS__New(Set)
    local _____52A8_4F5C_7F3A_5931 = __TS__New(Set)
    do
        local i = 0
        while i < #_____53EF_76F4_63A5_8FC1_79FB_5267_60C5_4E3B_7EBF_4EFB_52A1_914D_7F6E_8868 do
            local _____914D_7F6E = _____53EF_76F4_63A5_8FC1_79FB_5267_60C5_4E3B_7EBF_4EFB_52A1_914D_7F6E_8868[i + 1]
            local _____6761_4EF6_6587_672C = _____914D_7F6E.condition or ""
            local _____52A8_4F5C_6587_672C = _____914D_7F6E.actionTimeline or ""
            local _____6761_4EF6_51FD_6570 = _____63D0_53D6_7591_4F3C_51FD_6570_540D(_____6761_4EF6_6587_672C)
            do
                local j = 0
                while j < #_____6761_4EF6_51FD_6570 do
                    local name = _____6761_4EF6_51FD_6570[j + 1]
                    if not _____662F_5DF2_77E5_51FD_6570(name) then
                        _____6761_4EF6_7F3A_5931:add(name)
                    end
                    j = j + 1
                end
            end
            local _____52A8_4F5C_51FD_6570 = _____63D0_53D6_7591_4F3C_51FD_6570_540D(_____52A8_4F5C_6587_672C)
            do
                local j = 0
                while j < #_____52A8_4F5C_51FD_6570 do
                    local name = _____52A8_4F5C_51FD_6570[j + 1]
                    if not _____662F_5DF2_77E5_51FD_6570(name) then
                        _____52A8_4F5C_7F3A_5931:add(name)
                    end
                    j = j + 1
                end
            end
            i = i + 1
        end
    end
    debugLogForce(_____4E3B_7EBF_9A71_52A8_6A21_5757_540D, "[兼容诊断] 条件缺失函数数量", _____6761_4EF6_7F3A_5931.size)
    debugLogForce(_____4E3B_7EBF_9A71_52A8_6A21_5757_540D, "[兼容诊断] 动作缺失函数数量", _____52A8_4F5C_7F3A_5931.size)
end
local function _____4E3B_7EBF_63A8_8FDBTick()
    if _____4E3B_7EBF_9A71_52A8_6B63_5728_6267_884C then
        return
    end
    _____4E3B_7EBF_9A71_52A8_6B63_5728_6267_884C = true
    local _____5F53_524D_9636_6BB5 = _____8BFB_53D6_5267_60C5_8FDB_5EA6()
    local _____82F1_96C4_5217_8868 = _____6536_96C6_5DF2_6CE8_518C_73A9_5BB6_82F1_96C4_5217_8868()
    do
        local i = 0
        while i < #_____53EF_76F4_63A5_8FC1_79FB_5267_60C5_4E3B_7EBF_4EFB_52A1_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____53EF_76F4_63A5_8FC1_79FB_5267_60C5_4E3B_7EBF_4EFB_52A1_914D_7F6E_8868[i + 1]
                if _____914D_7F6E.enabled == false then
                    goto __continue103
                end
                if not _____547D_4E2D_524D_7F6E_9636_6BB5(_____914D_7F6E, _____5F53_524D_9636_6BB5) then
                    goto __continue103
                end
                if _____914D_7F6E.condition == nil or _____914D_7F6E.condition == "" then
                    goto __continue103
                end
                local _____547D_4E2D_82F1_96C4 = nil
                do
                    local j = 0
                    while j < #_____82F1_96C4_5217_8868 do
                        local _____82F1_96C4 = _____82F1_96C4_5217_8868[j + 1]
                        if _____5224_65AD_4E3B_7EBF_6761_4EF6(_____914D_7F6E.condition, _____82F1_96C4) then
                            _____547D_4E2D_82F1_96C4 = _____82F1_96C4
                            break
                        end
                        j = j + 1
                    end
                end
                if _____547D_4E2D_82F1_96C4 == nil or _____547D_4E2D_82F1_96C4 == 0 then
                    goto __continue103
                end
                if type(_____914D_7F6E.toStage) == "number" then
                    _____5199_5165_5267_60C5_8FDB_5EA6(_____914D_7F6E.toStage)
                end
                _____6267_884C_4E3B_7EBF_52A8_4F5C_65F6_95F4_8F74(_____914D_7F6E.actionTimeline, _____547D_4E2D_82F1_96C4)
                _____64AD_653E_4E3B_7EBF_5BF9_8BDD(_____914D_7F6E.dialogPreview)
                _____5237_65B0_4E3B_7EBF_4EFB_52A1UI(_____914D_7F6E.questDescText, _____914D_7F6E.questMsgText)
                break
            end
            ::__continue103::
            i = i + 1
        end
    end
    _____4E3B_7EBF_9A71_52A8_6B63_5728_6267_884C = false
end
____exports["init主线剧情配置驱动"] = function()
    if not ENABLE_QUEST_MAINLINE_DRIVER then
        return
    end
    if _____4E3B_7EBF_9A71_52A8_5DF2_521D_59CB_5316 then
        return
    end
    _____4E3B_7EBF_9A71_52A8_5DF2_521D_59CB_5316 = true
    _____786E_4FDD_4E3B_7EBF_8FD0_884C_65F6_4EFB_52A1()
    _____8F93_51FA_4E3B_7EBF_517C_5BB9_8BCA_65AD()
    addPeriodicCallback(300, _____4E3B_7EBF_63A8_8FDBTick)
end
return ____exports
