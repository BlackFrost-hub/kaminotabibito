--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____8BFB_53D6_53EC_5524_7269_4E8B_4EF6_53C2_6570, onSummonStesEventAction, jassStesHashtable, countOnJassStesTable, onRetryRegisterSummonStes, scheduleRetry, tryRegisterSummonStes, jass, jglobals, registerStesListener, ydlStes_syncTriggerStep, ydlStes_finishChildCleanup, ydlStes_readInteger5, ydlStes_readUnitcode5, ydlStes_readReal5, ydlStes_readString5, ydlStes_readUnit5, YDLocal7Set, createDelayedCall, debugLogForce, _____521B_5EFA_53EC_5524_7269, _____6A21_5757_540D, summonStesTrigger, REG_GUARD, TRIG_KEY, ATTEMPT_KEY, MAX_REG_ATTEMPTS, RETRY_SEC
function _____8BFB_53D6_53EC_5524_7269_4E8B_4EF6_53C2_6570(self)
    local moveHeight = ydlStes_readReal5(nil, nil, "moveHeight")
    local attackInterval = ydlStes_readReal5(nil, nil, "atkCd")
    local attackIntervalCompat = ydlStes_readReal5(nil, nil, "MoveHeight")
    local facing = ydlStes_readReal5(nil, nil, "facing")
    local unitTypeString = ydlStes_readString5(nil, nil, "unitType")
    local unitTypeUnitcode = ydlStes_readUnitcode5(nil, nil, "unitType")
    local unitTypeInteger = ydlStes_readInteger5(nil, nil, "unitType")
    local unitType = #unitTypeString == 4 and unitTypeString or (unitTypeUnitcode ~= 0 and unitTypeUnitcode or unitTypeInteger)
    return {
        ["主人单位"] = ydlStes_readUnit5(nil, nil, "Master"),
        ["召唤物单位"] = ydlStes_readUnit5(nil, nil, "Summon"),
        ["单位类型"] = unitType,
        ["单位类型字符串"] = unitTypeString,
        ["单位类型unitcode"] = unitTypeUnitcode,
        x = ydlStes_readReal5(nil, nil, "x"),
        y = ydlStes_readReal5(nil, nil, "y"),
        ["面向"] = facing ~= 0 and facing or nil,
        ["持续时间"] = ydlStes_readReal5(nil, nil, "time"),
        ["模型文件"] = ydlStes_readString5(nil, nil, "ModelFileID"),
        ["飞行高度"] = moveHeight > 0 and moveHeight or nil,
        ["生命值"] = ydlStes_readReal5(nil, nil, "HP"),
        ["生命恢复"] = ydlStes_readReal5(nil, nil, "regenHP"),
        ["攻击力"] = ydlStes_readReal5(nil, nil, "AttackPower"),
        ["攻击间隔"] = attackInterval > 0 and attackInterval or (attackIntervalCompat > 0 and attackIntervalCompat or nil),
        ["护甲"] = ydlStes_readReal5(nil, nil, "def"),
        ["缩放"] = ydlStes_readReal5(nil, nil, "size")
    }
end
____exports["根据Stes事件创建召唤物"] = function()
    do
        local ____try, ____hasReturned, ____returnValue = pcall(function()
            ydlStes_syncTriggerStep(nil, nil)
            local _____53C2_6570 = _____8BFB_53D6_53EC_5524_7269_4E8B_4EF6_53C2_6570(nil)
            debugLogForce(
                _____6A21_5757_540D,
                "收到 OnSummonEvent",
                "Master=",
                _____53C2_6570["主人单位"],
                "Summon=",
                _____53C2_6570["召唤物单位"],
                "unitType=",
                _____53C2_6570["单位类型"],
                "unitTypeString=",
                _____53C2_6570["单位类型字符串"],
                "unitTypeUnitcode=",
                _____53C2_6570["单位类型unitcode"],
                "x=",
                _____53C2_6570.x,
                "y=",
                _____53C2_6570.y,
                "facing=",
                _____53C2_6570["面向"],
                "time=",
                _____53C2_6570["持续时间"],
                "HP=",
                _____53C2_6570["生命值"],
                "size=",
                _____53C2_6570["缩放"]
            )
            local _____53EC_5524_7269 = _____521B_5EFA_53EC_5524_7269(_____53C2_6570)
            if _____53EC_5524_7269 ~= nil and _____53EC_5524_7269 ~= 0 then
                YDLocal7Set(nil, "unit", "Summon", _____53EC_5524_7269)
            end
            debugLogForce(_____6A21_5757_540D, "OnSummonEvent 处理结果 summon=", _____53EC_5524_7269)
            return true, _____53EC_5524_7269
        end)
        do
            ydlStes_finishChildCleanup(nil, nil)
        end
        if not ____try then
            error(____hasReturned, 0)
        end
        if ____try and ____hasReturned then
            return ____returnValue
        end
    end
end
function onSummonStesEventAction(self)
    ____exports["根据Stes事件创建召唤物"]()
end
function jassStesHashtable()
    local jg = jglobals
    local cands = {jg.STES___HT, jg.STES_HT, jg.udg_STES___HT, jg.udg_STES_HT}
    do
        local i = 0
        while i < #cands do
            local t = cands[i + 1]
            if t ~= nil and t ~= 0 then
                return t
            end
            i = i + 1
        end
    end
    return nil
end
function countOnJassStesTable(eventName)
    local ht = jassStesHashtable()
    if ht == nil or ht == 0 then
        return -1
    end
    return jass.LoadInteger(
        ht,
        jass.StringHash(eventName),
        jass.StringHash("index")
    )
end
function onRetryRegisterSummonStes(self)
    tryRegisterSummonStes()
end
function scheduleRetry()
    createDelayedCall(RETRY_SEC, onRetryRegisterSummonStes)
end
function tryRegisterSummonStes()
    local g = _G
    if g[REG_GUARD] then
        return
    end
    if g[TRIG_KEY] == nil then
        summonStesTrigger = registerStesListener(nil, ____exports.SUMMON_STES_EVENT, onSummonStesEventAction)
        g[TRIG_KEY] = summonStesTrigger
    else
        summonStesTrigger = g[TRIG_KEY]
    end
    local jCount = countOnJassStesTable(____exports.SUMMON_STES_EVENT)
    local attempt = g[ATTEMPT_KEY] or 0
    g[ATTEMPT_KEY] = attempt + 1
    debugLogForce(
        _____6A21_5757_540D,
        "注册检查",
        "attempt=",
        attempt + 1,
        "jCount=",
        jCount,
        "trigger=",
        summonStesTrigger
    )
    if jCount >= 1 then
        g[REG_GUARD] = true
        debugLogForce(
            _____6A21_5757_540D,
            "注册成功",
            "event=",
            ____exports.SUMMON_STES_EVENT,
            "count=",
            jCount
        )
        return
    end
    if g[ATTEMPT_KEY] >= MAX_REG_ATTEMPTS then
        debugLogForce(
            _____6A21_5757_540D,
            "注册失败",
            "event=",
            ____exports.SUMMON_STES_EVENT,
            "最后计数=",
            jCount
        )
        return
    end
    scheduleRetry()
end
jass = require("jass.common")
jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
registerStesListener = ____require_result_0.registerStesListener
local ____require_result_1 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
ydlStes_syncTriggerStep = ____require_result_1.ydlStes_syncTriggerStep
ydlStes_finishChildCleanup = ____require_result_1.ydlStes_finishChildCleanup
ydlStes_readInteger5 = ____require_result_1.ydlStes_readInteger5
ydlStes_readUnitcode5 = ____require_result_1.ydlStes_readUnitcode5
ydlStes_readReal5 = ____require_result_1.ydlStes_readReal5
ydlStes_readString5 = ____require_result_1.ydlStes_readString5
ydlStes_readUnit5 = ____require_result_1.ydlStes_readUnit5
local ____require_result_2 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
YDLocal7Set = ____require_result_2.YDLocal7Set
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.index")
createDelayedCall = ____require_result_3.createDelayedCall
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_4.debugLogForce
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
_____521B_5EFA_53EC_5524_7269 = ____require_result_5["创建召唤物"]
____exports.SUMMON_STES_EVENT = "OnSummonEvent"
_____6A21_5757_540D = "召唤物桥接"
summonStesTrigger = nil
REG_GUARD = "__syzl_summon_registered"
TRIG_KEY = "__syzl_summon_trig"
ATTEMPT_KEY = "__syzl_summon_reg_attempt"
MAX_REG_ATTEMPTS = 30
RETRY_SEC = 0.1
____exports["注册召唤物Stes桥接"] = function()
    tryRegisterSummonStes()
end
____exports["注册召唤物Stes桥接"]()
return ____exports
