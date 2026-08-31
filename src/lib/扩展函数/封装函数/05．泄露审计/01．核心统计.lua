local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
--- 泄露审计 - 核心统计
local jass = require("jass.common")
____exports.alive = {}
____exports.types = {
    "timer",
    "group",
    "trigger",
    "effect",
    "rect",
    "sound",
    "texttag"
}
____exports.stats = {
    timer = {created = 0, destroyed = 0},
    group = {created = 0, destroyed = 0},
    trigger = {created = 0, destroyed = 0},
    effect = {created = 0, destroyed = 0},
    rect = {created = 0, destroyed = 0},
    sound = {created = 0, destroyed = 0},
    texttag = {created = 0, destroyed = 0}
}
--- Lua 里同一句柄可能以不同引用传入；用 leakType+稳定字符串 作键，避免 delete 对不上导致假 alive。
-- 禁止 `local j=jass; j.GetHandleId(h)`：TSTL 会编成 `j:GetHandleId(h)`，self 传成 jass 表会崩 → 只用 `(jass as any).GetHandleId(h)`。
-- CreateSound 等若返回 table 包装，GetHandleId 会报错 → 退回 tostring(handle) 作为稳定调试键。
-- 用 TS 的 typeof：Lua 里 table→__TS__TypeOf 为 "object"，userdata 为 "userdata"，不会误判。
function ____exports.leakKey(self, leakType, handle)
    if handle == nil then
        return leakType .. ":nil"
    end
    if type(handle) == "table" and handle ~= nil then
        return (leakType .. ":obj:") .. tostring(handle)
    end
    return (leakType .. ":") .. tostring(jass.GetHandleId(handle))
end
function ____exports.track(self, ____type, handle, tag)
    if not handle then
        return
    end
    local s = ____exports.stats[____type]
    s.created = s.created + 1
    ____exports.alive[____exports.leakKey(nil, ____type, handle)] = {
        type = ____type,
        tag = tag,
        createdIndex = s.created,
        handleText = tostring(handle)
    }
end
function ____exports.untrack(self, ____type, handle)
    if not handle then
        return
    end
    local s = ____exports.stats[____type]
    local key = ____exports.leakKey(nil, ____type, handle)
    if ____exports.alive[key] ~= nil then
        __TS__Delete(____exports.alive, key)
        s.destroyed = s.destroyed + 1
    end
end
return ____exports
