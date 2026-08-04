local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____8C03_7528_804A_5929_547D_4EE4_76D1_542C_5668
function _____8C03_7528_804A_5929_547D_4EE4_76D1_542C_5668(listeners, player, command)
    do
        local i = 0
        while i < #listeners do
            do
                local listener = listeners[i + 1]
                if listener["权限"] ~= nil and not listener["权限"](player) then
                    goto __continue15
                end
                local callback = listener["回调"]
                if callback ~= nil then
                    callback(player, command)
                end
            end
            ::__continue15::
            i = i + 1
        end
    end
end
--- 聊天命令事件中心
-- 
-- 功能：监听玩家聊天消息，支持注册特定命令的回调
local jass = require("jass.common")
local _____521B_5EFA_89E6_53D1_5668 = jass.CreateTrigger
local _____6DFB_52A0_89E6_53D1_52A8_4F5C = jass.TriggerAddAction
local _____6CE8_518C_73A9_5BB6_804A_5929_4E8B_4EF6 = jass.TriggerRegisterPlayerChatEvent
local _____83B7_53D6_89E6_53D1_73A9_5BB6 = jass.GetTriggerPlayer
local _____83B7_53D6_804A_5929_5B57_7B26_4E32 = jass.GetEventPlayerChatString
local _____83B7_53D6_73A9_5BB6_5BF9_8C61 = jass.Player
local _____547D_4EE4_76D1_542C_5668 = __TS__New(Map)
local _____524D_7F00_547D_4EE4_76D1_542C_5668 = {}
local _____5DF2_521D_59CB_5316 = false
local _____5F53_524D_804A_5929_547D_4EE4_6CE8_518C_6743_9650
____exports["设置聊天命令注册权限"] = function(_____6743_9650)
    _____5F53_524D_804A_5929_547D_4EE4_6CE8_518C_6743_9650 = _____6743_9650
end
local function _____73A9_5BB6_804A_5929()
    local player = _____83B7_53D6_89E6_53D1_73A9_5BB6()
    if player == nil or player == 0 then
        return
    end
    local chatString = _____83B7_53D6_804A_5929_5B57_7B26_4E32()
    if chatString == nil or chatString == "" then
        return
    end
    local listeners = _____547D_4EE4_76D1_542C_5668:get(chatString)
    if listeners ~= nil then
        _____8C03_7528_804A_5929_547D_4EE4_76D1_542C_5668(listeners, player, chatString)
    end
    do
        local i = 0
        while i < #_____524D_7F00_547D_4EE4_76D1_542C_5668 do
            do
                local listener = _____524D_7F00_547D_4EE4_76D1_542C_5668[i + 1]
                if #chatString < #listener["前缀"] then
                    goto __continue8
                end
                if __TS__StringSubstring(chatString, 0, #listener["前缀"]) ~= listener["前缀"] then
                    goto __continue8
                end
                if listener["权限"] ~= nil and not listener["权限"](player) then
                    goto __continue8
                end
                local callback = listener["回调"]
                if callback ~= nil then
                    callback(player, chatString)
                end
            end
            ::__continue8::
            i = i + 1
        end
    end
end
local function _____521D_59CB_5316_804A_5929_4E8B_4EF6_4E2D_5FC3()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    local trig = _____521B_5EFA_89E6_53D1_5668()
    _____6DFB_52A0_89E6_53D1_52A8_4F5C(trig, _____73A9_5BB6_804A_5929)
    do
        local i = 0
        while i <= 15 do
            _____6CE8_518C_73A9_5BB6_804A_5929_4E8B_4EF6(
                trig,
                _____83B7_53D6_73A9_5BB6_5BF9_8C61(i),
                "",
                false
            )
            i = i + 1
        end
    end
end
--- 注册聊天命令监听。
-- 第一次使用时会自动初始化事件中心。
____exports["注册聊天命令监听"] = function(_____547D_4EE4, _____56DE_8C03)
    if _____56DE_8C03 == nil then
        return
    end
    if _____547D_4EE4 == "" then
        return
    end
    _____521D_59CB_5316_804A_5929_4E8B_4EF6_4E2D_5FC3()
    local list = _____547D_4EE4_76D1_542C_5668:get(_____547D_4EE4)
    if list == nil then
        list = {}
        _____547D_4EE4_76D1_542C_5668:set(_____547D_4EE4, list)
    end
    do
        local i = 0
        while i < #list do
            if list[i + 1]["回调"] == _____56DE_8C03 then
                return
            end
            i = i + 1
        end
    end
    list[#list + 1] = {["回调"] = _____56DE_8C03, ["权限"] = _____5F53_524D_804A_5929_547D_4EE4_6CE8_518C_6743_9650}
end
--- 注册聊天命令前缀监听，回调收到完整聊天字符串。
-- 第一次使用时会自动初始化事件中心。
____exports["注册聊天命令前缀监听"] = function(_____524D_7F00, _____56DE_8C03)
    if _____56DE_8C03 == nil then
        return
    end
    if _____524D_7F00 == "" then
        return
    end
    _____521D_59CB_5316_804A_5929_4E8B_4EF6_4E2D_5FC3()
    do
        local i = 0
        while i < #_____524D_7F00_547D_4EE4_76D1_542C_5668 do
            local listener = _____524D_7F00_547D_4EE4_76D1_542C_5668[i + 1]
            if listener["前缀"] == _____524D_7F00 and listener["回调"] == _____56DE_8C03 then
                return
            end
            i = i + 1
        end
    end
    _____524D_7F00_547D_4EE4_76D1_542C_5668[#_____524D_7F00_547D_4EE4_76D1_542C_5668 + 1] = {["前缀"] = _____524D_7F00, ["回调"] = _____56DE_8C03, ["权限"] = _____5F53_524D_804A_5929_547D_4EE4_6CE8_518C_6743_9650}
end
--- 取消聊天命令监听。
____exports["取消聊天命令监听"] = function(_____547D_4EE4, _____56DE_8C03)
    local list = _____547D_4EE4_76D1_542C_5668:get(_____547D_4EE4)
    if list == nil then
        return
    end
    local index = -1
    do
        local i = 0
        while i < #list do
            if list[i + 1]["回调"] == _____56DE_8C03 then
                index = i
                break
            end
            i = i + 1
        end
    end
    if index >= 0 then
        __TS__ArraySplice(list, index, 1)
    end
end
return ____exports
