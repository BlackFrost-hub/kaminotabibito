--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 开关：设为 true 启用测试，false 禁用
local ENABLED = false
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local max = ____require_result_0.max
local min = ____require_result_0.min
--- 本图 JASS 里 YDLocal5Set/YDLocal1Get 使用的实数变量名字符串（须与触发器里完全一致）
local YD_LOCAL_REAL_KEY = "实数"
local stesMod = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local ____require_result_1 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local YDLocal5Get = ____require_result_1.YDLocal5Get
local YDLocal7Set = ____require_result_1.YDLocal7Set
local clearStar_PIndex = ____require_result_1.clearStar_PIndex
local TEST_EVENT = "测试"
local BOOT_GUARD_KEY = "__syzl_stesTest_booted"
local LUA_STES_REG_KEY = "__syzl_stesTest_luaStesReg"
local function skeyIndex()
    local jg = jglobals
    if type(jg.STES_skey_index) == "number" and jg.STES_skey_index ~= 0 then
        return jg.STES_skey_index
    end
    return jass:StringHash("index")
end
local function log(msg)
    local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.index")
    local debugLogForce = ____require_result_2.debugLogForce
    debugLogForce(nil, "STES测试", msg)
end
local function onLuaStesListenerAction()
    do
        local ____try, ____error = pcall(function()
            local from5 = YDLocal5Get(nil, "real", YD_LOCAL_REAL_KEY)
            local b = type(from5) == "number" and from5 or 0
            local quad = (b * b + 13 * b + 42) / (b + 1.0001)
            local root = jass:SquareRoot(max(0, b + 16)) * 2.25
            local ret = quad + root - min(b, 5) * 0.5 + 3.14159
            YDLocal7Set(nil, "real", YD_LOCAL_REAL_KEY, ret)
            log((((((("[STES事件测试-Lua] YDLocal5Get(real,\"" .. YD_LOCAL_REAL_KEY) .. "\")=") .. tostring(b)) .. " → YDLocal7Set 写回 real,\"") .. YD_LOCAL_REAL_KEY) .. "\"=") .. tostring(ret))
        end)
        do
            clearStar_PIndex(nil)
        end
        if not ____try then
            error(____error, 0)
        end
    end
end
--- 向「测试」再挂一个 Lua 创建的触发器：JASS 侧用 STES_GetTable 遍历 + TriggerExecute 时会执行到（如聊天 333）。
local function tryRegisterLuaListenerForJassStes()
    local g = _G
    if g[LUA_STES_REG_KEY] then
        return
    end
    local ht = stesMod:STES_GetTable()
    if ht == nil or ht == 0 then
        return
    end
    g[LUA_STES_REG_KEY] = true
    local trig = jass:CreateTrigger()
    jass:TriggerAddAction(trig, onLuaStesListenerAction)
    stesMod:STES_Register(trig, TEST_EVENT)
    log(("[STES事件测试] 已向「" .. TEST_EVENT) .. "」STES_Register Lua 触发器；与 JASS 注册共用同一张表，输入 333 可测 JASS→Lua")
end
--- 取表 → 注册 Lua 监听 → 有注册则 STES_FireWithReal11Step（亦可包在定时器里延后执行）
local function runAfterDelay()
    local ht = stesMod:STES_GetTable()
    if ht == nil or ht == 0 then
        log("[STES事件测试] STES_GetTable() 仍为空（当前无延迟；若绑表晚于 require 可恢复 boot 内定时器）")
        return
    end
    tryRegisterLuaListenerForJassStes()
    local hash = jass:StringHash(TEST_EVENT)
    local sk = skeyIndex()
    local count = jass:LoadInteger(ht, hash, sk)
    log((((((("[STES事件测试] 表=" .. tostring(ht)) .. " 事件「") .. TEST_EVENT) .. "」count=") .. tostring(count)) .. " skey_index=") .. tostring(sk))
    if count <= 0 then
        log(("[STES事件测试] 计数为 0：事件「" .. TEST_EVENT) .. "」尚无 STES 注册（检查 JASS 是否已 Register、事件名是否一致）")
        return
    end
    log(("[STES事件测试] 执行 STES_FireWithReal11Step，realParamKey=\"" .. YD_LOCAL_REAL_KEY) .. "\"（与 GUI 333）")
    stesMod.STES_FireWithReal11Step(TEST_EVENT, YD_LOCAL_REAL_KEY)
    log("[STES事件测试] STES_FireWithReal11Step 已返回")
end
local function boot()
    if not ENABLED then
        return
    end
    local g = _G
    if g[BOOT_GUARD_KEY] then
        return
    end
    g[BOOT_GUARD_KEY] = true
    log("[STES事件测试] 无延迟立即执行 STES 测试")
    runAfterDelay()
end
boot()
return ____exports
