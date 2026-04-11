--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 任意测试2 — Lua 仅通过事件名 STES_Fire，与 JASS STES_Register 共用 STES___HT
-- 
-- 调试输出：遵循 `.cursor/rules/feedback_debug_output.md`，用 print（经 log）而非 DisplayTimedTextToPlayer。
-- 
-- 与 GUI「333」一致：YDLocal 变量名由常量 YD_LOCAL_REAL_KEY 与地图 JASS 对齐（可为中文/英文/数字等，非库默认）。
-- 
-- 当前：**无延迟**，`boot` 内直接 `runAfterDelay()`。若需等 JASS 绑 STES___HT，可恢复下方 `ENTRY_DELAY_SEC` 与注释掉的定时器。
-- 
-- TSTL：模块内局部函数默认带隐式 self，会编成 log(nil,msg)、_print(nil,msg)。
-- 为所有本地函数加 `this: void`，避免多余 nil 与冒号调用错位。
local jass = require("jass.common")
local jglobals = require("jass.globals")
--- 本图 JASS 里 YDLocal5Set/YDLocal1Get 使用的实数变量名字符串（须与触发器里完全一致）
local YD_LOCAL_REAL_KEY = "实数"
local stesMod = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local YDLocal5Get = ____require_result_0.YDLocal5Get
local YDLocal7Set = ____require_result_0.YDLocal7Set
local clearStar_PIndex = ____require_result_0.clearStar_PIndex
local TEST_EVENT = "测试"
local BOOT_GUARD_KEY = "__syzl_anyTest2_booted"
local LUA_STES_REG_KEY = "__syzl_anyTest2_luaStesReg"
local function skeyIndex()
    local jg = jglobals
    if type(jg.STES_skey_index) == "number" and jg.STES_skey_index ~= 0 then
        return jg.STES_skey_index
    end
    if type(jass.StringHash) == "function" then
        return jass.StringHash("index")
    end
    return 0
end
local function log(msg)
    local p = _G.print
    if type(p) == "function" then
        p(msg)
    end
end
--- 向「测试」再挂一个 Lua 创建的触发器：JASS 侧用 STES_GetTable 遍历 + TriggerExecute 时会执行到（如聊天 333）。
local function tryRegisterLuaListenerForJassStes()
    local g = _G
    if g[LUA_STES_REG_KEY] then
        return
    end
    local ht = stesMod.STES_GetTable()
    if ht == nil or ht == 0 then
        return
    end
    g[LUA_STES_REG_KEY] = true
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" then
        log("[任意测试2] 无法 CreateTrigger，跳过 Lua STES 监听注册")
        return
    end
    local trig = jass.CreateTrigger()
    jass.TriggerAddAction(
        trig,
        function()
            do
                pcall(function()
                    local from5 = YDLocal5Get(nil, "real", YD_LOCAL_REAL_KEY)
                    local b = type(from5) == "number" and from5 or 0
                    local quad = (b * b + 13 * b + 42) / (b + 1.0001)
                    local root = math.sqrt(math.max(0, b + 16)) * 2.25
                    local ret = quad + root - math.min(b, 5) * 0.5 + 3.14159
                    YDLocal7Set(nil, "real", YD_LOCAL_REAL_KEY, ret)
                    log((((((("[任意测试2-Lua] YDLocal5Get(real,\"" .. YD_LOCAL_REAL_KEY) .. "\")=") .. tostring(b)) .. " → YDLocal7Set 写回 real,\"") .. YD_LOCAL_REAL_KEY) .. "\"=") .. tostring(ret))
                end)
                do
                    clearStar_PIndex(nil)
                end
            end
        end
    )
    stesMod.STES_Register(trig, TEST_EVENT)
    log(("[任意测试2] 已向「" .. TEST_EVENT) .. "」STES_Register Lua 触发器；与 JASS 注册共用同一张表，输入 333 可测 JASS→Lua")
end
--- 取表 → 注册 Lua 监听 → 有注册则 STES_FireWithReal11Step（亦可包在定时器里延后执行）
local function runAfterDelay()
    local ht = stesMod.STES_GetTable()
    if ht == nil or ht == 0 then
        log("[任意测试2] STES_GetTable() 仍为空（当前无延迟；若绑表晚于 require 可恢复 boot 内定时器）")
        return
    end
    tryRegisterLuaListenerForJassStes()
    local hash = jass.StringHash(TEST_EVENT)
    local sk = skeyIndex()
    local ____temp_1
    if type(jass.LoadInteger) == "function" then
        ____temp_1 = jass.LoadInteger(ht, hash, sk)
    else
        ____temp_1 = 0
    end
    local count = ____temp_1
    log((((((("[任意测试2] 表=" .. tostring(ht)) .. " 事件「") .. TEST_EVENT) .. "」count=") .. tostring(count)) .. " skey_index=") .. tostring(sk))
    if count <= 0 then
        log(("[任意测试2] 计数为 0：事件「" .. TEST_EVENT) .. "」尚无 STES 注册（检查 JASS 是否已 Register、事件名是否一致）")
        return
    end
    log(("[任意测试2] 执行 STES_FireWithReal11Step，realParamKey=\"" .. YD_LOCAL_REAL_KEY) .. "\"（与 GUI 333）")
    stesMod.STES_FireWithReal11Step(TEST_EVENT, YD_LOCAL_REAL_KEY)
    log("[任意测试2] STES_FireWithReal11Step 已返回")
end
local function boot()
    local g = _G
    if g[BOOT_GUARD_KEY] then
        return
    end
    g[BOOT_GUARD_KEY] = true
    log("[任意测试2] 无延迟立即执行 STES 测试")
    runAfterDelay()
end
boot()
return ____exports
