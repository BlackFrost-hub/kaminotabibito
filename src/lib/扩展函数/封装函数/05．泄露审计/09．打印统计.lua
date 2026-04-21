local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local ____01_FF0E_6838_5FC3_7EDF_8BA1 = require("lib.扩展函数.封装函数.05．泄露审计.01．核心统计")
local alive = ____01_FF0E_6838_5FC3_7EDF_8BA1.alive
local types = ____01_FF0E_6838_5FC3_7EDF_8BA1.types
local stats = ____01_FF0E_6838_5FC3_7EDF_8BA1.stats
--- 泄露审计 - 打印统计
local jass = require("jass.common")
--- 打印当前统计信息；可选 tagFilter 只查看某个来源
function ____exports.dump(self, tagFilter)
    local p0 = jass.Player(0)
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
    printLine(nil, "=== LeakWatcher 记账 (非 jass.debug 句柄表) ===")
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
return ____exports
