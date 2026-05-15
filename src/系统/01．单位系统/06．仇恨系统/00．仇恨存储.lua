local ____lualib = require("lualib_bundle")
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local nowMs, _nowMs
function nowMs()
    if _nowMs == nil then
        _nowMs = require("系统.00．核心系统.05．中心计时器").getServerTime
    end
    return _nowMs()
end
--- 00．仇恨存储
-- 
-- 敌人视角的仇恨表。每个敌人维护一张仇恨表，同时存 HandleId 和单位引用。
-- removeTarget / clearAllThreat 自动联动清理当前目标缓存。
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local threatTables = {}
local _____4EC7_6068_4E0A_9650 = 1000
local _____957F_5C3E_6E05_7406_9608_503C = 5
____exports["仇恨整表超时毫秒"] = 10000
____exports["仇恨条目超时毫秒"] = 10000
____exports["仇恨列表最大目标数"] = 6
--- 敌人 HandleId → 敌人单位引用（由 addThreat 自动维护）
local enemyRefTable = {}
--- 敌人 HandleId → 最近一次收到伤害/更新仇恨的服务器时间（毫秒）
local enemyLastThreatUpdateMs = {}
local function _____53D6_5355_4F4DID(u)
    if u == nil or u == 0 then
        return 0
    end
    return GetHandleId(u) or 0
end
local function _____6570_5B57_5347_5E8F_6392_5E8F(a, b)
    return a - b
end
local function _____83B7_53D6_6709_5E8F_654C_4EBAID_5217_8868()
    local result = {}
    for key in pairs(threatTables) do
        local id = __TS__ParseInt(key, 10)
        if not __TS__NumberIsNaN(__TS__Number(id)) then
            result[#result + 1] = id
        end
    end
    __TS__ArraySort(result, _____6570_5B57_5347_5E8F_6392_5E8F)
    return result
end
local ______6E05_9664_5F53_524D_76EE_6807 = nil
local function _____9650_5236_4EC7_6068_503C(value)
    if value <= 0 then
        return 0
    end
    if value >= _____4EC7_6068_4E0A_9650 then
        return _____4EC7_6068_4E0A_9650
    end
    return value
end
local function _____83B7_53D6_603B_4EC7_6068_503C(list)
    if list == nil or #list == 0 then
        return 0
    end
    local total = 0
    do
        local i = 0
        while i < #list do
            total = total + list[i + 1].threat
            i = i + 1
        end
    end
    return total
end
local function _____6E05_7406_957F_5C3E_4EC7_6068(list)
    if list == nil or #list <= 2 then
        return
    end
    do
        local i = #list - 1
        while i >= 0 do
            if list[i + 1].threat < _____957F_5C3E_6E05_7406_9608_503C then
                __TS__ArraySplice(list, i, 1)
            end
            i = i - 1
        end
    end
end
local function _____6309_603B_6C60_4E0A_9650_91CD_5206_914D(list)
    if list == nil or #list == 0 then
        return
    end
    if #list < 2 then
        return
    end
    local _____5F53_524D_603B_4EC7_6068 = _____83B7_53D6_603B_4EC7_6068_503C(list)
    if _____5F53_524D_603B_4EC7_6068 <= 0 or _____5F53_524D_603B_4EC7_6068 <= _____4EC7_6068_4E0A_9650 then
        return
    end
    local _____7F29_653E_6BD4_4F8B = _____4EC7_6068_4E0A_9650 / _____5F53_524D_603B_4EC7_6068
    do
        local i = 0
        while i < #list do
            list[i + 1].threat = _____9650_5236_4EC7_6068_503C(list[i + 1].threat * _____7F29_653E_6BD4_4F8B)
            i = i + 1
        end
    end
    _____6E05_7406_957F_5C3E_4EC7_6068(list)
end
local function _____89E6_53D1_5F53_524D_76EE_6807_6E05_9664(_____654C_4EBAID, _____76EE_6807ID)
    if ______6E05_9664_5F53_524D_76EE_6807 ~= nil then
        ______6E05_9664_5F53_524D_76EE_6807(_____654C_4EBAID, _____76EE_6807ID)
    end
end
local function _____79FB_9664_6761_76EE_5E76_8054_52A8(list, _____654C_4EBAID, index)
    local entry = list[index + 1]
    if entry == nil then
        return
    end
    local _____76EE_6807ID = entry.targetHid
    __TS__ArraySplice(list, index, 1)
    _____89E6_53D1_5F53_524D_76EE_6807_6E05_9664(_____654C_4EBAID, _____76EE_6807ID)
end
local function _____7EF4_6301_5217_8868_4E0A_9650(list, _____654C_4EBAID)
    if list == nil then
        return
    end
    while #list > ____exports["仇恨列表最大目标数"] do
        local _____6700_5C0F_7D22_5F15 = 0
        do
            local i = 1
            while i < #list do
                if list[i + 1].threat < list[_____6700_5C0F_7D22_5F15 + 1].threat then
                    _____6700_5C0F_7D22_5F15 = i
                end
                i = i + 1
            end
        end
        _____79FB_9664_6761_76EE_5E76_8054_52A8(list, _____654C_4EBAID, _____6700_5C0F_7D22_5F15)
    end
end
local function _____6E05_7406_8FC7_671F_6761_76EE(list, _____654C_4EBAID, _____5F53_524D_65F6_95F4)
    if list == nil or #list == 0 then
        return
    end
    do
        local i = #list - 1
        while i >= 0 do
            if _____5F53_524D_65F6_95F4 - list[i + 1].lastUpdateTime >= ____exports["仇恨条目超时毫秒"] then
                _____79FB_9664_6761_76EE_5E76_8054_52A8(list, _____654C_4EBAID, i)
            end
            i = i - 1
        end
    end
end
local function _____6E05_7406_5217_8868_5E76_91CD_5206_914D(_____654C_4EBAID, list, _____5F53_524D_65F6_95F4)
    if list == nil then
        return
    end
    _____6E05_7406_8FC7_671F_6761_76EE(list, _____654C_4EBAID, _____5F53_524D_65F6_95F4)
    if #list == 0 then
        __TS__Delete(threatTables, _____654C_4EBAID)
        __TS__Delete(enemyRefTable, _____654C_4EBAID)
        __TS__Delete(enemyLastThreatUpdateMs, _____654C_4EBAID)
        return
    end
    _____7EF4_6301_5217_8868_4E0A_9650(list, _____654C_4EBAID)
    if #list == 0 then
        __TS__Delete(threatTables, _____654C_4EBAID)
        __TS__Delete(enemyRefTable, _____654C_4EBAID)
        __TS__Delete(enemyLastThreatUpdateMs, _____654C_4EBAID)
        return
    end
    _____6309_603B_6C60_4E0A_9650_91CD_5206_914D(list)
    if #list == 0 then
        __TS__Delete(threatTables, _____654C_4EBAID)
        __TS__Delete(enemyRefTable, _____654C_4EBAID)
        __TS__Delete(enemyLastThreatUpdateMs, _____654C_4EBAID)
    end
end
--- 由 02．目标选择 注册清除回调，实现联动。回调参数：(敌人ID, 目标ID)，目标ID=0表示全部清除。
____exports["注册当前目标清除回调"] = function(fn)
    ______6E05_9664_5F53_524D_76EE_6807 = fn
end
--- 增加仇恨（累加），同时维护敌人引用表
function ____exports.addThreat(_____654C_4EBA, _____4EC7_6068_76EE_6807, _____6570_503C)
    local _____654C_4EBAID = _____53D6_5355_4F4DID(_____654C_4EBA)
    local _____76EE_6807ID = _____53D6_5355_4F4DID(_____4EC7_6068_76EE_6807)
    if _____654C_4EBAID == 0 or _____76EE_6807ID == 0 then
        return
    end
    if _____6570_503C <= 0 then
        return
    end
    local _____5F53_524D_65F6_95F4 = nowMs()
    enemyRefTable[_____654C_4EBAID] = _____654C_4EBA
    enemyLastThreatUpdateMs[_____654C_4EBAID] = _____5F53_524D_65F6_95F4
    local list = threatTables[_____654C_4EBAID]
    if list == nil then
        list = {}
        threatTables[_____654C_4EBAID] = list
    end
    _____6E05_7406_5217_8868_5E76_91CD_5206_914D(_____654C_4EBAID, list, _____5F53_524D_65F6_95F4)
    list = threatTables[_____654C_4EBAID]
    if list == nil then
        list = {}
        threatTables[_____654C_4EBAID] = list
    end
    enemyRefTable[_____654C_4EBAID] = _____654C_4EBA
    enemyLastThreatUpdateMs[_____654C_4EBAID] = _____5F53_524D_65F6_95F4
    do
        local i = 0
        while i < #list do
            if list[i + 1].targetHid == _____76EE_6807ID then
                list[i + 1].threat = _____9650_5236_4EC7_6068_503C(list[i + 1].threat + _____6570_503C)
                list[i + 1].targetRef = _____4EC7_6068_76EE_6807
                list[i + 1].lastUpdateTime = _____5F53_524D_65F6_95F4
                _____6E05_7406_5217_8868_5E76_91CD_5206_914D(_____654C_4EBAID, list, _____5F53_524D_65F6_95F4)
                return
            end
            i = i + 1
        end
    end
    local _____65B0_6761_76EE_4EC7_6068 = _____9650_5236_4EC7_6068_503C(_____6570_503C)
    if _____65B0_6761_76EE_4EC7_6068 <= 0 then
        return
    end
    list[#list + 1] = {targetHid = _____76EE_6807ID, targetRef = _____4EC7_6068_76EE_6807, threat = _____65B0_6761_76EE_4EC7_6068, lastUpdateTime = _____5F53_524D_65F6_95F4}
    _____6E05_7406_5217_8868_5E76_91CD_5206_914D(_____654C_4EBAID, list, _____5F53_524D_65F6_95F4)
end
--- 设置仇恨（覆盖），同时维护敌人引用表
function ____exports.setThreat(_____654C_4EBA, _____4EC7_6068_76EE_6807, _____6570_503C)
    local _____654C_4EBAID = _____53D6_5355_4F4DID(_____654C_4EBA)
    local _____76EE_6807ID = _____53D6_5355_4F4DID(_____4EC7_6068_76EE_6807)
    if _____654C_4EBAID == 0 or _____76EE_6807ID == 0 then
        return
    end
    local _____5F53_524D_65F6_95F4 = nowMs()
    enemyRefTable[_____654C_4EBAID] = _____654C_4EBA
    enemyLastThreatUpdateMs[_____654C_4EBAID] = _____5F53_524D_65F6_95F4
    local list = threatTables[_____654C_4EBAID]
    if list == nil then
        list = {}
        threatTables[_____654C_4EBAID] = list
    end
    _____6E05_7406_5217_8868_5E76_91CD_5206_914D(_____654C_4EBAID, list, _____5F53_524D_65F6_95F4)
    list = threatTables[_____654C_4EBAID]
    if list == nil then
        list = {}
        threatTables[_____654C_4EBAID] = list
    end
    enemyRefTable[_____654C_4EBAID] = _____654C_4EBA
    enemyLastThreatUpdateMs[_____654C_4EBAID] = _____5F53_524D_65F6_95F4
    do
        local i = 0
        while i < #list do
            if list[i + 1].targetHid == _____76EE_6807ID then
                list[i + 1].threat = _____9650_5236_4EC7_6068_503C(_____6570_503C)
                list[i + 1].targetRef = _____4EC7_6068_76EE_6807
                list[i + 1].lastUpdateTime = _____5F53_524D_65F6_95F4
                _____6E05_7406_5217_8868_5E76_91CD_5206_914D(_____654C_4EBAID, list, _____5F53_524D_65F6_95F4)
                return
            end
            i = i + 1
        end
    end
    local _____65B0_6761_76EE_4EC7_6068 = _____9650_5236_4EC7_6068_503C(_____6570_503C)
    if _____65B0_6761_76EE_4EC7_6068 <= 0 then
        return
    end
    list[#list + 1] = {targetHid = _____76EE_6807ID, targetRef = _____4EC7_6068_76EE_6807, threat = _____65B0_6761_76EE_4EC7_6068, lastUpdateTime = _____5F53_524D_65F6_95F4}
    _____6E05_7406_5217_8868_5E76_91CD_5206_914D(_____654C_4EBAID, list, _____5F53_524D_65F6_95F4)
end
--- 获取对某个目标的仇恨值（按 HandleId）
function ____exports.getThreatByHid(_____654C_4EBA, _____76EE_6807ID)
    local _____654C_4EBAID = _____53D6_5355_4F4DID(_____654C_4EBA)
    if _____654C_4EBAID == 0 or _____76EE_6807ID == 0 then
        return 0
    end
    local list = threatTables[_____654C_4EBAID]
    if list == nil then
        return 0
    end
    do
        local i = 0
        while i < #list do
            if list[i + 1].targetHid == _____76EE_6807ID then
                return list[i + 1].threat
            end
            i = i + 1
        end
    end
    return 0
end
function ____exports.getThreat(_____654C_4EBA, _____4EC7_6068_76EE_6807)
    local _____654C_4EBAID = _____53D6_5355_4F4DID(_____654C_4EBA)
    local _____76EE_6807ID = _____53D6_5355_4F4DID(_____4EC7_6068_76EE_6807)
    if _____654C_4EBAID == 0 or _____76EE_6807ID == 0 then
        return 0
    end
    local list = threatTables[_____654C_4EBAID]
    if list == nil then
        return 0
    end
    do
        local i = 0
        while i < #list do
            if list[i + 1].targetHid == _____76EE_6807ID then
                return list[i + 1].threat
            end
            i = i + 1
        end
    end
    return 0
end
--- 获取最高仇恨的目标（传递 filter 过滤 targetRef，返回的 entry 含 targetRef）
function ____exports.getHighestThreat(_____654C_4EBA, filter)
    local _____654C_4EBAID = _____53D6_5355_4F4DID(_____654C_4EBA)
    if _____654C_4EBAID == 0 then
        return nil
    end
    local list = threatTables[_____654C_4EBAID]
    if list == nil or #list == 0 then
        return nil
    end
    local best = nil
    do
        local i = 0
        while i < #list do
            do
                if filter ~= nil and not filter(list[i + 1]) then
                    goto __continue81
                end
                if best == nil or list[i + 1].threat > best.threat then
                    best = list[i + 1]
                end
            end
            ::__continue81::
            i = i + 1
        end
    end
    return best
end
--- 移除某个目标。仅当被移除目标正好是当前目标时才触达清除回调。
function ____exports.removeTarget(_____654C_4EBA, _____4EC7_6068_76EE_6807)
    local _____654C_4EBAID = _____53D6_5355_4F4DID(_____654C_4EBA)
    local _____76EE_6807ID = _____53D6_5355_4F4DID(_____4EC7_6068_76EE_6807)
    if _____654C_4EBAID == 0 or _____76EE_6807ID == 0 then
        return
    end
    local list = threatTables[_____654C_4EBAID]
    if list == nil then
        return
    end
    do
        local i = 0
        while i < #list do
            if list[i + 1].targetHid == _____76EE_6807ID then
                _____79FB_9664_6761_76EE_5E76_8054_52A8(list, _____654C_4EBAID, i)
                if #list == 0 then
                    __TS__Delete(threatTables, _____654C_4EBAID)
                    __TS__Delete(enemyRefTable, _____654C_4EBAID)
                    __TS__Delete(enemyLastThreatUpdateMs, _____654C_4EBAID)
                end
                return
            end
            i = i + 1
        end
    end
end
--- 清空某个敌人的所有仇恨（联动清理当前目标缓存，目标ID传0表示全部清除）
function ____exports.clearAllThreat(_____654C_4EBA)
    local _____654C_4EBAID = _____53D6_5355_4F4DID(_____654C_4EBA)
    if _____654C_4EBAID == 0 then
        return
    end
    __TS__Delete(threatTables, _____654C_4EBAID)
    __TS__Delete(enemyRefTable, _____654C_4EBAID)
    __TS__Delete(enemyLastThreatUpdateMs, _____654C_4EBAID)
    if ______6E05_9664_5F53_524D_76EE_6807 ~= nil then
        ______6E05_9664_5F53_524D_76EE_6807(_____654C_4EBAID, 0)
    end
end
--- 无条件按 ID 清空（用于敌人引用丢失的场景）
function ____exports.clearAllThreatById(_____654C_4EBAID)
    if _____654C_4EBAID == 0 then
        return
    end
    __TS__Delete(threatTables, _____654C_4EBAID)
    __TS__Delete(enemyRefTable, _____654C_4EBAID)
    __TS__Delete(enemyLastThreatUpdateMs, _____654C_4EBAID)
    if ______6E05_9664_5F53_524D_76EE_6807 ~= nil then
        ______6E05_9664_5F53_524D_76EE_6807(_____654C_4EBAID, 0)
    end
end
--- 该敌人是否有仇恨记录
function ____exports.isEnemyTracked(_____654C_4EBA)
    local _____654C_4EBAID = _____53D6_5355_4F4DID(_____654C_4EBA)
    if _____654C_4EBAID == 0 then
        return false
    end
    return threatTables[_____654C_4EBAID] ~= nil
end
--- 仇恨表中的目标数量
function ____exports.getEnemyThreatCount(_____654C_4EBA)
    local _____654C_4EBAID = _____53D6_5355_4F4DID(_____654C_4EBA)
    if _____654C_4EBAID == 0 then
        return 0
    end
    local list = threatTables[_____654C_4EBAID]
    return list == nil and 0 or #list
end
--- 获取该敌人所有仇恨目标的只读快照
function ____exports.getEnemyThreats(_____654C_4EBA)
    local _____654C_4EBAID = _____53D6_5355_4F4DID(_____654C_4EBA)
    if _____654C_4EBAID == 0 then
        return {}
    end
    local list = threatTables[_____654C_4EBAID]
    if list == nil then
        return {}
    end
    local result = {}
    do
        local i = 0
        while i < #list do
            result[#result + 1] = list[i + 1]
            i = i + 1
        end
    end
    return result
end
--- 获取所有有仇恨记录的敌人 ID（稳定数组）
function ____exports.getAllTrackedEnemyIds()
    return _____83B7_53D6_6709_5E8F_654C_4EBAID_5217_8868()
end
--- 按 ID 取敌人仇恨表是否还有记录（驱动层用）
function ____exports.hasThreatTable(_____654C_4EBAID)
    return threatTables[_____654C_4EBAID] ~= nil
end
--- 从敌人引用表获取敌人单位引用
function ____exports.getEnemyRef(_____654C_4EBAID)
    local ____enemyRefTable______654C_4EBAID_0 = enemyRefTable[_____654C_4EBAID]
    if ____enemyRefTable______654C_4EBAID_0 == nil then
        ____enemyRefTable______654C_4EBAID_0 = nil
    end
    return ____enemyRefTable______654C_4EBAID_0
end
--- 获取最近一次收到伤害/更新仇恨的服务器时间（毫秒）
function ____exports.getEnemyLastThreatUpdateTimeById(_____654C_4EBAID)
    return enemyLastThreatUpdateMs[_____654C_4EBAID] or 0
end
____exports["清理敌人过期仇恨条目ById"] = function(_____654C_4EBAID)
    if _____654C_4EBAID == 0 then
        return
    end
    local list = threatTables[_____654C_4EBAID]
    if list == nil then
        return
    end
    _____6E05_7406_5217_8868_5E76_91CD_5206_914D(
        _____654C_4EBAID,
        list,
        nowMs()
    )
end
_nowMs = nil
return ____exports
