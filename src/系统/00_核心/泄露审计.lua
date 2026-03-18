local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
--- 泄露审计工具（轻量版，TS + TSTL 友好）
-- 
-- 功能：
-- - 通过包装常见“容易泄露”的 API（计时器 / 单位组 / 触发器 / 特效 / 矩形 / 雾修正器）
-- - 记录：创建次数、销毁次数、当前存活数量
-- - 每个资源可以带一个 tag（来源标记，例如 "dot伤害" / "装备系统"）
-- - 玩家 0 输入 "-leak" 或按 ESC 跳过动画时，打印当前统计信息
-- 
-- 注意：
-- - 只能统计“通过本工具包装创建 / 销毁”的资源，旧代码直接调用 JASS 原生的不会被统计到。
-- - 建议先在你最怀疑泄露的系统里尝试用这些包装函数。
local jass = require("jass.common")
local alive = __TS__New(Map)
local types = {
    "timer",
    "group",
    "trigger",
    "effect",
    "rect",
    "sound",
    "texttag"
}
local stats = {
    timer = {created = 0, destroyed = 0},
    group = {created = 0, destroyed = 0},
    trigger = {created = 0, destroyed = 0},
    effect = {created = 0, destroyed = 0},
    rect = {created = 0, destroyed = 0},
    sound = {created = 0, destroyed = 0},
    texttag = {created = 0, destroyed = 0}
}
local function track(self, ____type, handle, tag)
    if not handle then
        return
    end
    local s = stats[____type]
    s.created = s.created + 1
    alive:set(handle, {type = ____type, tag = tag, createdIndex = s.created})
end
local function untrack(self, ____type, handle)
    if not handle then
        return
    end
    local s = stats[____type]
    if alive:delete(handle) then
        s.destroyed = s.destroyed + 1
    end
end
____exports.LeakWatcher = {
    createTimer = function(self, tag)
        local t = jass.CreateTimer()
        track(nil, "timer", t, tag)
        return t
    end,
    destroyTimer = function(self, t)
        if not t then
            return
        end
        untrack(nil, "timer", t)
        if type(jass.DestroyTimer) == "function" then
            jass.DestroyTimer(t)
        end
    end,
    createGroup = function(self, tag)
        local g = jass.CreateGroup()
        track(nil, "group", g, tag)
        return g
    end,
    destroyGroup = function(self, gp)
        if not gp then
            return
        end
        untrack(nil, "group", gp)
        if type(jass.DestroyGroup) == "function" then
            jass.DestroyGroup(gp)
        end
    end,
    createTrigger = function(self, tag)
        local trg = jass.CreateTrigger()
        track(nil, "trigger", trg, tag)
        return trg
    end,
    destroyTrigger = function(self, trg)
        if not trg then
            return
        end
        untrack(nil, "trigger", trg)
        if type(jass.DestroyTrigger) == "function" then
            jass.DestroyTrigger(trg)
        end
    end,
    trackEffect = function(self, tag, eff)
        track(nil, "effect", eff, tag)
    end,
    destroyEffect = function(self, eff)
        if not eff then
            return
        end
        untrack(nil, "effect", eff)
        if type(jass.DestroyEffect) == "function" then
            jass.DestroyEffect(eff)
        end
    end,
    trackRect = function(self, tag, rect)
        track(nil, "rect", rect, tag)
    end,
    removeRect = function(self, rect)
        if not rect then
            return
        end
        untrack(nil, "rect", rect)
        if type(jass.RemoveRect) == "function" then
            jass.RemoveRect(rect)
        end
    end,
    createSound = function(self, tag, fileName, looping, is3D, stopwhenoutofrange, fadeInRate, fadeOutRate, eaxSetting)
        if type(jass.CreateSound) ~= "function" then
            return nil
        end
        local s = jass.CreateSound(
            fileName,
            looping,
            is3D,
            stopwhenoutofrange,
            fadeInRate,
            fadeOutRate,
            eaxSetting
        )
        track(nil, "sound", s, tag)
        return s
    end,
    killSoundWhenDone = function(self, s)
        if not s then
            return
        end
        if type(jass.KillSoundWhenDone) == "function" then
            jass.KillSoundWhenDone(s)
        end
        untrack(nil, "sound", s)
    end,
    stopSoundAndKill = function(self, s, killWhenDone, fadeOut)
        if killWhenDone == nil then
            killWhenDone = true
        end
        if fadeOut == nil then
            fadeOut = false
        end
        if not s then
            return
        end
        if type(jass.StopSound) == "function" then
            jass.StopSound(s, killWhenDone, fadeOut)
        elseif type(jass.KillSoundWhenDone) == "function" then
            jass.KillSoundWhenDone(s)
        end
        untrack(nil, "sound", s)
    end,
    createTextTag = function(self, tag)
        if type(jass.CreateTextTag) ~= "function" then
            return nil
        end
        local tt = jass.CreateTextTag()
        track(nil, "texttag", tt, tag)
        return tt
    end,
    destroyTextTag = function(self, tt)
        if not tt then
            return
        end
        untrack(nil, "texttag", tt)
        if type(jass.DestroyTextTag) == "function" then
            jass.DestroyTextTag(tt)
        end
    end,
    dump = function(self, tagFilter)
        if type(jass.DisplayTimedTextToPlayer) ~= "function" then
            return
        end
        local ____table_Player_0
        if jass.Player then
            ____table_Player_0 = jass.Player(0)
        else
            ____table_Player_0 = nil
        end
        local p0 = ____table_Player_0
        local function printLine(____, msg)
            if not p0 then
                return
            end
            jass.DisplayTimedTextToPlayer(
                p0,
                0,
                0,
                15,
                msg
            )
        end
        printLine(nil, "=== 泄露审计 (仅统计使用 LeakWatcher 的资源) ===")
        for ____, tp in ipairs(types) do
            local s = stats[tp]
            local aliveCount = s.created - s.destroyed
            printLine(
                nil,
                (((((tp .. ": alive=") .. tostring(aliveCount)) .. ", created=") .. tostring(s.created)) .. ", destroyed=") .. tostring(s.destroyed)
            )
        end
        if tagFilter then
            printLine(nil, ("--- 详情 tag=" .. tagFilter) .. " ---")
            for ____, ____value in __TS__Iterator(alive) do
                local handle = ____value[1]
                local info = ____value[2]
                if info.tag == tagFilter then
                    printLine(
                        nil,
                        ((((((info.type .. "#") .. tostring(info.createdIndex)) .. " (") .. info.tag) .. ") [") .. tostring(handle)) .. "]"
                    )
                end
            end
        end
    end
}
--- 注册聊天 "-leak" 触发方式，方便临时查看
local function initLeakWatcherTriggers(self)
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
                ____exports.LeakWatcher:dump(tag)
            end
        )
    end
end
initLeakWatcherTriggers(nil)
return ____exports
