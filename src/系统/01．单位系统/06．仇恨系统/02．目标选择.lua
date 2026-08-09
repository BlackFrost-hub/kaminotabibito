local ____lualib = require("lualib_bundle")
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
--- 02．目标选择
-- 
-- 从仇恨表中选出应攻击目标（返回含 targetRef）。
-- 普通攻击可严格选择最高仇恨；Boss 主动施法保留高出当前目标至少 20% 才切换的粘性规则。
-- 
-- 初始化时注册清除回调到 00．仇恨存储，实现 removeTarget/clearAllThreat 自动联动清理。
local jass = require("jass.common")
local ____require_result_0 = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储")
local getHighestThreat = ____require_result_0.getHighestThreat
local getThreatByHid = ____require_result_0.getThreatByHid
local getEnemyThreats = ____require_result_0.getEnemyThreats
local _____6CE8_518C_5F53_524D_76EE_6807_6E05_9664_56DE_8C03 = ____require_result_0["注册当前目标清除回调"]
local GetHandleId = jass.GetHandleId
local _____5F53_524D_76EE_6807_8868 = {}
local _____5F3A_5236_76EE_6807_8868 = {}
local _nowMs = nil
local function _____53D6_5355_4F4DID(u)
    if u == nil or u == 0 then
        return 0
    end
    return GetHandleId(u) or 0
end
local function nowMs()
    if _nowMs == nil then
        _nowMs = require("系统.00．核心系统.05．中心计时器").getServerTime
    end
    return _nowMs()
end
local function _____6570_5B57_5347_5E8F_6392_5E8F(a, b)
    return a - b
end
local function _____83B7_53D6_6709_5E8F_5F53_524D_76EE_6807_654C_4EBAID_5217_8868()
    local result = {}
    for key in pairs(_____5F53_524D_76EE_6807_8868) do
        local id = __TS__ParseInt(key, 10)
        if not __TS__NumberIsNaN(__TS__Number(id)) then
            result[#result + 1] = id
        end
    end
    __TS__ArraySort(result, _____6570_5B57_5347_5E8F_6392_5E8F)
    return result
end
local function _____6E05_9664_5F53_524D_76EE_6807(_____654C_4EBAID, _____76EE_6807ID)
    if _____654C_4EBAID == 0 then
        return
    end
    if _____76EE_6807ID == 0 then
        __TS__Delete(_____5F53_524D_76EE_6807_8868, _____654C_4EBAID)
        __TS__Delete(_____5F3A_5236_76EE_6807_8868, _____654C_4EBAID)
        return
    end
    local _____8BB0_5F55 = _____5F53_524D_76EE_6807_8868[_____654C_4EBAID]
    if _____8BB0_5F55 ~= nil and _____8BB0_5F55.targetHid == _____76EE_6807ID then
        __TS__Delete(_____5F53_524D_76EE_6807_8868, _____654C_4EBAID)
    end
    local _____5F3A_5236_8BB0_5F55 = _____5F3A_5236_76EE_6807_8868[_____654C_4EBAID]
    if _____5F3A_5236_8BB0_5F55 ~= nil and _____5F3A_5236_8BB0_5F55.targetHid == _____76EE_6807ID then
        __TS__Delete(_____5F3A_5236_76EE_6807_8868, _____654C_4EBAID)
    end
end
_____6CE8_518C_5F53_524D_76EE_6807_6E05_9664_56DE_8C03(_____6E05_9664_5F53_524D_76EE_6807)
--- 获取当前缓存的攻击目标ID
____exports["获取当前目标ID"] = function(_____654C_4EBA)
    local _____654C_4EBAID = _____53D6_5355_4F4DID(_____654C_4EBA)
    if _____654C_4EBAID == 0 then
        return 0
    end
    local _____8BB0_5F55 = _____5F53_524D_76EE_6807_8868[_____654C_4EBAID]
    return _____8BB0_5F55 == nil and 0 or _____8BB0_5F55.targetHid
end
____exports["设置强制攻击目标"] = function(_____654C_4EBA, _____76EE_6807, _____6301_7EED_6BEB_79D2)
    local _____654C_4EBAID = _____53D6_5355_4F4DID(_____654C_4EBA)
    local _____76EE_6807ID = _____53D6_5355_4F4DID(_____76EE_6807)
    if _____654C_4EBAID == 0 or _____76EE_6807ID == 0 or _____6301_7EED_6BEB_79D2 <= 0 then
        return
    end
    _____5F3A_5236_76EE_6807_8868[_____654C_4EBAID] = {
        targetHid = _____76EE_6807ID,
        targetRef = _____76EE_6807,
        enemyRef = _____654C_4EBA,
        expireMs = nowMs() + _____6301_7EED_6BEB_79D2
    }
end
____exports["获取强制攻击目标"] = function(_____654C_4EBA, filter)
    local _____654C_4EBAID = _____53D6_5355_4F4DID(_____654C_4EBA)
    if _____654C_4EBAID == 0 then
        return nil
    end
    local _____8BB0_5F55 = _____5F3A_5236_76EE_6807_8868[_____654C_4EBAID]
    if _____8BB0_5F55 == nil then
        return nil
    end
    if nowMs() >= _____8BB0_5F55.expireMs then
        __TS__Delete(_____5F3A_5236_76EE_6807_8868, _____654C_4EBAID)
        return nil
    end
    local entry = {targetHid = _____8BB0_5F55.targetHid, targetRef = _____8BB0_5F55.targetRef, threat = 999999}
    if filter ~= nil and not filter(entry) then
        return nil
    end
    return entry
end
____exports["获取所有强制目标敌人ID"] = function()
    local result = {}
    local now = nowMs()
    for key in pairs(_____5F3A_5236_76EE_6807_8868) do
        do
            local id = __TS__ParseInt(key, 10)
            if __TS__NumberIsNaN(__TS__Number(id)) then
                goto __continue26
            end
            local _____8BB0_5F55 = _____5F3A_5236_76EE_6807_8868[id]
            if _____8BB0_5F55 == nil or now >= _____8BB0_5F55.expireMs then
                __TS__Delete(_____5F3A_5236_76EE_6807_8868, id)
                goto __continue26
            end
            result[#result + 1] = id
        end
        ::__continue26::
    end
    __TS__ArraySort(result, _____6570_5B57_5347_5E8F_6392_5E8F)
    return result
end
____exports["获取强制目标敌人引用"] = function(_____654C_4EBAID)
    if _____654C_4EBAID == 0 then
        return nil
    end
    local _____8BB0_5F55 = _____5F3A_5236_76EE_6807_8868[_____654C_4EBAID]
    if _____8BB0_5F55 == nil then
        return nil
    end
    if nowMs() >= _____8BB0_5F55.expireMs then
        __TS__Delete(_____5F3A_5236_76EE_6807_8868, _____654C_4EBAID)
        return nil
    end
    return _____8BB0_5F55.enemyRef
end
--- 严格选择过滤范围内的最高仇恨攻击目标；明确的强制点名优先。
____exports["获取最高仇恨攻击目标"] = function(_____654C_4EBA, filter)
    local _____654C_4EBAID = _____53D6_5355_4F4DID(_____654C_4EBA)
    if _____654C_4EBAID == 0 then
        return nil
    end
    local _____5F3A_5236_76EE_6807 = ____exports["获取强制攻击目标"](_____654C_4EBA, filter)
    if _____5F3A_5236_76EE_6807 ~= nil then
        return _____5F3A_5236_76EE_6807
    end
    return getHighestThreat(_____654C_4EBA, filter)
end
--- Boss 主动施法目标：最高仇恨有效且比当前目标高至少 20% 时才切换。
-- 
-- @param filter 由驱动层传入，过滤死亡/超距目标（filter 接收 ThreatEntry，含 targetRef）
____exports["获取应攻击目标"] = function(_____654C_4EBA, filter)
    local _____654C_4EBAID = _____53D6_5355_4F4DID(_____654C_4EBA)
    if _____654C_4EBAID == 0 then
        return nil
    end
    local best = ____exports["获取最高仇恨攻击目标"](_____654C_4EBA, filter)
    if best == nil then
        return nil
    end
    local _____5F53_524D_8BB0_5F55 = _____5F53_524D_76EE_6807_8868[_____654C_4EBAID]
    if _____5F53_524D_8BB0_5F55 ~= nil and _____5F53_524D_8BB0_5F55.targetHid ~= 0 and _____5F53_524D_8BB0_5F55.targetHid ~= best.targetHid then
        local _____5F53_524D_4EC7_6068 = getThreatByHid(_____654C_4EBA, _____5F53_524D_8BB0_5F55.targetHid)
        if _____5F53_524D_4EC7_6068 > 0 and best.threat < _____5F53_524D_4EC7_6068 * 1.2 then
            local _____5217_8868 = getEnemyThreats(_____654C_4EBA)
            do
                local i = 0
                while i < #_____5217_8868 do
                    local entry = _____5217_8868[i + 1]
                    if entry.targetHid == _____5F53_524D_8BB0_5F55.targetHid and (filter == nil or filter(entry)) then
                        return entry
                    end
                    i = i + 1
                end
            end
        end
    end
    return best
end
--- 设置当前攻击目标缓存
____exports["设置当前目标"] = function(_____654C_4EBAID, _____76EE_6807ID)
    if _____654C_4EBAID == 0 then
        return
    end
    _____5F53_524D_76EE_6807_8868[_____654C_4EBAID] = {targetHid = _____76EE_6807ID}
end
--- 清除所有当前目标缓存
____exports["清除所有当前目标"] = function()
    local _____654C_4EBAID_5217_8868 = _____83B7_53D6_6709_5E8F_5F53_524D_76EE_6807_654C_4EBAID_5217_8868()
    do
        local i = 0
        while i < #_____654C_4EBAID_5217_8868 do
            __TS__Delete(_____5F53_524D_76EE_6807_8868, _____654C_4EBAID_5217_8868[i + 1])
            i = i + 1
        end
    end
    local _____5F3A_5236_654C_4EBAID_5217_8868 = ____exports["获取所有强制目标敌人ID"]()
    do
        local i = 0
        while i < #_____5F3A_5236_654C_4EBAID_5217_8868 do
            __TS__Delete(_____5F3A_5236_76EE_6807_8868, _____5F3A_5236_654C_4EBAID_5217_8868[i + 1])
            i = i + 1
        end
    end
end
return ____exports
