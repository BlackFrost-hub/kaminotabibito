local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
local ____09_FF0E_6253_5370_7EDF_8BA1 = require("lib.扩展函数.封装函数.05．泄露审计.09．打印统计")
local dump = ____09_FF0E_6253_5370_7EDF_8BA1.dump
--- 泄露审计 - 聊天命令触发器
local jass = require("jass.common")
--- 注册聊天 "-leak" 触发方式，方便临时查看
function ____exports.initLeakWatcherTriggers(self)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" or type(jass.Player) ~= "function" then
        return
    end
    if type(jass.TriggerRegisterPlayerChatEvent) == "function" then
        local trChat = jass.CreateTrigger()
        jass.TriggerRegisterPlayerChatEvent(
            trChat,
            jass.Player(0),
            "-leak",
            false
        )
        jass.TriggerAddAction(
            trChat,
            function()
                local tag
                if type(jass.GetEventPlayerChatString) == "function" then
                    local raw = jass.GetEventPlayerChatString()
                    if raw ~= nil and #raw > 5 then
                        local idx = (string.find(raw, " ", nil, true) or 0) - 1
                        if idx >= 0 and idx < #raw - 1 then
                            tag = __TS__StringTrim(__TS__StringSubstring(raw, idx + 1))
                            if tag == "" then
                                tag = nil
                            end
                        end
                    end
                end
                dump(nil, tag)
            end
        )
    end
end
____exports.initLeakWatcherTriggers(nil)
return ____exports
