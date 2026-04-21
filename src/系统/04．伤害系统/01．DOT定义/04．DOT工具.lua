local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local ____exports = {}
local jass = require("jass.common")
--- Lua 下单位作表键时，伤害回调的 target 与选中枚举的 sole 可能不是同一 userdata；统一用 GetHandleId 作键。
function ____exports.unitHid(self, u)
    if u == nil or u == 0 then
        return 0
    end
    return jass.GetHandleId(u)
end
--- pairs 迭代可能混用 number / string 键，不合并会导致「同目标两行状态」或 onDamage 读不到 cur、乘积误判。
function ____exports.tabRowForHid(self, tab, hid)
    if hid == 0 then
        return nil
    end
    local n = tab[hid]
    if n ~= nil then
        return n
    end
    return tab[tostring(hid)]
end
function ____exports.tabSetHid(self, tab, hid, state)
    if hid == 0 then
        return
    end
    __TS__Delete(
        tab,
        tostring(hid)
    )
    tab[hid] = state
end
function ____exports.tabDeleteHid(self, tab, hid)
    if hid == 0 then
        return
    end
    __TS__Delete(tab, hid)
    __TS__Delete(
        tab,
        tostring(hid)
    )
end
function ____exports.collectHidsInTab(self, tab)
    local seen = {}
    local out = {}
    for k in pairs(tab) do
        do
            local kn = type(k) == "number" and k or __TS__ParseInt(k, 10)
            if __TS__NumberIsNaN(__TS__Number(kn)) or kn == 0 then
                goto __continue12
            end
            if seen[kn] then
                goto __continue12
            end
            seen[kn] = true
            out[#out + 1] = kn
        end
        ::__continue12::
    end
    return out
end
--- stateByType 槽位应为 DotState 表；若被污染为数字等则剔除，避免 cur.remaining 报错
function ____exports.isValidDotStateRow(self, v)
    return v ~= nil and type(v) == "table" and type(v.remaining) == "number" and type(v.effect) == "number"
end
function ____exports.getDotSourceDisplayName(self, u)
    if u == nil or u == 0 then
        return "未知"
    end
    local n = jass.GetUnitName(u)
    if n ~= nil and n ~= nil and tostring(n) ~= "" then
        return tostring(n)
    end
    return "未知"
end
return ____exports
