local ____lualib = require("lualib_bundle")
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local jassStesHashtable, countOnJassStesTable, _____6253_5370Boss_6218_542F_52A8_8DF3_8FC7, _____8BFB_53D6Boss_6218YD_53D8_91CF_5355_4F4D, _____8BFB_53D6Boss_6218YD_7ED1_5B9A_5355_4F4D, _____767B_8BB0Boss_81EA_52A8_6280_80FD_542F_52A8, _____5C1D_8BD5_4ECEYDUserData_8865_8BFBBoss, ____onBoss_6218_542F_52A8_5EF6_8FDF_8865_8BFB, _____5B89_6392_4E00_5E27_540E_8865_8BFBBoss, _____5904_7406Boss_6218_542F_52A8Stes, ____onBoss_6218_542F_52A8Stes_4E8B_4EF6Action, ____onRetryRegisterBoss_6218_542F_52A8Stes, scheduleRetry, ____tryRegisterBoss_6218_542F_52A8Stes, jass, jglobals, registerStesListener, ydlStes_syncTriggerStep, ydlStes_finishChildCleanup, ydlStes_readUnit5, YDUserDataGetSafe, addDelayedCallback, debugLogForce, ____Boss_6218_542F_52A8STES_4E8B_4EF6_540D, ____Boss_6218_8868_540D, ____Boss_6218_5355_4F4D_5B57_6BB5, ____Boss_6218_7ED1_5B9A_5355_4F4D_5B57_6BB5, ____Boss_6218_542F_52A8_6865_63A5_6A21_5757_540D, ____Boss_6218_542F_52A8_5EF6_8FDF_6BEB_79D2, _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8, _____662F_5426_5DF2_767B_8BB0Boss_81EA_52A8_6280_80FD, _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E, GetHandleId, GetUnitName, LoadInteger, StringHash, ____Boss_6218_542F_52A8Stes_89E6_53D1_5668, REG_GUARD, TRIG_KEY, ATTEMPT_KEY, MAX_REG_ATTEMPTS, RETRY_DELAY_MS, _____5F85_8865_8BFBBoss_53E5_67C4_8868
function jassStesHashtable()
    local cands = {jglobals.STES___HT, jglobals.STES_HT, jglobals.udg_STES___HT, jglobals.udg_STES_HT}
    do
        local i = 0
        while i < #cands do
            local ht = cands[i + 1]
            if ht ~= nil and ht ~= 0 then
                return ht
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
    return LoadInteger(
        ht,
        StringHash(eventName),
        StringHash("index")
    )
end
function _____6253_5370Boss_6218_542F_52A8_8DF3_8FC7(reason)
    debugLogForce(____Boss_6218_542F_52A8_6865_63A5_6A21_5757_540D, "跳过", reason)
end
function _____8BFB_53D6Boss_6218YD_53D8_91CF_5355_4F4D()
    return YDUserDataGetSafe("string", ____Boss_6218_8868_540D, ____Boss_6218_5355_4F4D_5B57_6BB5, "unit")
end
function _____8BFB_53D6Boss_6218YD_7ED1_5B9A_5355_4F4D()
    return YDUserDataGetSafe("string", ____Boss_6218_8868_540D, ____Boss_6218_7ED1_5B9A_5355_4F4D_5B57_6BB5, "unit")
end
function _____767B_8BB0Boss_81EA_52A8_6280_80FD_542F_52A8(bossUnit, source)
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    if _____662F_5426_5DF2_767B_8BB0Boss_81EA_52A8_6280_80FD(bossUnit) then
        debugLogForce(
            ____Boss_6218_542F_52A8_6865_63A5_6A21_5757_540D,
            "已登记，跳过重复注册",
            "source=",
            source,
            "name=",
            GetUnitName(bossUnit)
        )
        return
    end
    _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8(bossUnit, source)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(bossUnit)
    debugLogForce(
        ____Boss_6218_542F_52A8_6865_63A5_6A21_5757_540D,
        "登记Boss自动技能壳子",
        "source=",
        source,
        "name=",
        GetUnitName(bossUnit)
    )
end
function _____5C1D_8BD5_4ECEYDUserData_8865_8BFBBoss(bossHandleId)
    _____5F85_8865_8BFBBoss_53E5_67C4_8868[bossHandleId] = nil
    local bossUnit = _____8BFB_53D6Boss_6218YD_53D8_91CF_5355_4F4D()
    if bossUnit ~= nil and bossUnit ~= 0 then
        _____767B_8BB0Boss_81EA_52A8_6280_80FD_542F_52A8(bossUnit, "Boss战.单位")
        return
    end
    local bindUnit = _____8BFB_53D6Boss_6218YD_7ED1_5B9A_5355_4F4D()
    if bindUnit ~= nil and bindUnit ~= 0 then
        _____767B_8BB0Boss_81EA_52A8_6280_80FD_542F_52A8(bindUnit, "Boss战.绑定单位")
        return
    end
    _____6253_5370Boss_6218_542F_52A8_8DF3_8FC7("STES 已触发，但 Boss / 绑定单位 均为空")
end
function ____onBoss_6218_542F_52A8_5EF6_8FDF_8865_8BFB()
    local _____5217_8868 = __TS__ObjectKeys(_____5F85_8865_8BFBBoss_53E5_67C4_8868)
    do
        local i = 0
        while i < #_____5217_8868 do
            local handleId = __TS__Number(_____5217_8868[i + 1]) or 0
            if handleId > 0 and _____5F85_8865_8BFBBoss_53E5_67C4_8868[handleId] then
                _____5C1D_8BD5_4ECEYDUserData_8865_8BFBBoss(handleId)
            end
            i = i + 1
        end
    end
end
function _____5B89_6392_4E00_5E27_540E_8865_8BFBBoss()
    addDelayedCallback(____Boss_6218_542F_52A8_5EF6_8FDF_6BEB_79D2, ____onBoss_6218_542F_52A8_5EF6_8FDF_8865_8BFB)
end
function _____5904_7406Boss_6218_542F_52A8Stes()
    do
        local ____try, ____hasReturned, ____returnValue = pcall(function()
            ydlStes_syncTriggerStep(nil)
            local stesBoss = ydlStes_readUnit5(nil, "Boss")
            if stesBoss ~= nil and stesBoss ~= 0 then
                _____767B_8BB0Boss_81EA_52A8_6280_80FD_542F_52A8(stesBoss, "STES.Boss")
                return true
            end
            local handleId = GetHandleId(jass.GetTriggeringTrigger())
            _____5F85_8865_8BFBBoss_53E5_67C4_8868[handleId] = true
            _____5B89_6392_4E00_5E27_540E_8865_8BFBBoss()
        end)
        do
            ydlStes_finishChildCleanup(nil)
        end
        if not ____try then
            error(____hasReturned, 0)
        end
        if ____try and ____hasReturned then
            return ____returnValue
        end
    end
end
function ____onBoss_6218_542F_52A8Stes_4E8B_4EF6Action()
    _____5904_7406Boss_6218_542F_52A8Stes()
end
function ____onRetryRegisterBoss_6218_542F_52A8Stes()
    ____tryRegisterBoss_6218_542F_52A8Stes()
end
function scheduleRetry()
    addDelayedCallback(RETRY_DELAY_MS, ____onRetryRegisterBoss_6218_542F_52A8Stes)
end
function ____tryRegisterBoss_6218_542F_52A8Stes()
    local g = _G
    if g[REG_GUARD] then
        return
    end
    if g[TRIG_KEY] == nil then
        ____Boss_6218_542F_52A8Stes_89E6_53D1_5668 = registerStesListener(____Boss_6218_542F_52A8STES_4E8B_4EF6_540D, ____onBoss_6218_542F_52A8Stes_4E8B_4EF6Action)
        g[TRIG_KEY] = ____Boss_6218_542F_52A8Stes_89E6_53D1_5668
    else
        ____Boss_6218_542F_52A8Stes_89E6_53D1_5668 = g[TRIG_KEY]
    end
    local jCount = countOnJassStesTable(____Boss_6218_542F_52A8STES_4E8B_4EF6_540D)
    local attempt = g[ATTEMPT_KEY] or 0
    g[ATTEMPT_KEY] = attempt + 1
    if jCount >= 1 then
        g[REG_GUARD] = true
        debugLogForce(
            ____Boss_6218_542F_52A8_6865_63A5_6A21_5757_540D,
            "注册成功",
            "event=",
            ____Boss_6218_542F_52A8STES_4E8B_4EF6_540D,
            "count=",
            jCount
        )
        return
    end
    if g[ATTEMPT_KEY] >= MAX_REG_ATTEMPTS then
        debugLogForce(
            ____Boss_6218_542F_52A8_6865_63A5_6A21_5757_540D,
            "注册失败",
            "event=",
            ____Boss_6218_542F_52A8STES_4E8B_4EF6_540D,
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
ydlStes_readUnit5 = ____require_result_1.ydlStes_readUnit5
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDUserDataGetSafe = ____require_result_2.YDUserDataGetSafe
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_3.addDelayedCallback
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_4.debugLogForce
local ____require_result_5 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.00．常量定义")
____Boss_6218_542F_52A8STES_4E8B_4EF6_540D = ____require_result_5["Boss战启动STES事件名"]
____Boss_6218_8868_540D = ____require_result_5["Boss战表名"]
____Boss_6218_5355_4F4D_5B57_6BB5 = ____require_result_5["Boss战单位字段"]
____Boss_6218_7ED1_5B9A_5355_4F4D_5B57_6BB5 = ____require_result_5["Boss战绑定单位字段"]
____Boss_6218_542F_52A8_6865_63A5_6A21_5757_540D = ____require_result_5["Boss战启动桥接模块名"]
____Boss_6218_542F_52A8_5EF6_8FDF_6BEB_79D2 = ____require_result_5["Boss战启动延迟毫秒"]
local ____require_result_6 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.01．Boss自动技能注册表")
_____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8 = ____require_result_6["记录Boss自动技能启动"]
_____662F_5426_5DF2_767B_8BB0Boss_81EA_52A8_6280_80FD = ____require_result_6["是否已登记Boss自动技能"]
local ____require_result_7 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.03．战斗启动属性.04．战斗启动属性应用")
_____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_7["应用Boss战启动属性配置"]
GetHandleId = jass.GetHandleId
GetUnitName = jass.GetUnitName
LoadInteger = jass.LoadInteger
StringHash = jass.StringHash
____Boss_6218_542F_52A8Stes_89E6_53D1_5668 = nil
REG_GUARD = "__syzl_boss_ai_start_registered"
TRIG_KEY = "__syzl_boss_ai_start_trig"
ATTEMPT_KEY = "__syzl_boss_ai_start_reg_attempt"
MAX_REG_ATTEMPTS = 30
RETRY_DELAY_MS = 100
_____5F85_8865_8BFBBoss_53E5_67C4_8868 = {}
____exports["注册Boss战启动Stes桥接"] = function()
    ____tryRegisterBoss_6218_542F_52A8Stes()
end
____exports["注册Boss战启动Stes桥接"]()
return ____exports
