--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 03．仇恨驱动
-- 
-- 核心驱动，每0.25秒执行一次：
-- 1. 遍历所有有仇恨表的敌人
-- 2. 死亡清理
-- 3. 选择应攻击目标（filter 排除死亡/超距）
-- 4. 目标变更时更新缓存；同目标也每 tick 补发 attack 命令维持攻击
-- 
-- 目标引用直接从仇恨表的 targetRef 获取，无需额外注册。
local jass = require("jass.common")
local ____require_result_0 = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储")
local getAllTrackedEnemyIds = ____require_result_0.getAllTrackedEnemyIds
local clearAllThreatById = ____require_result_0.clearAllThreatById
local hasThreatTable = ____require_result_0.hasThreatTable
local getEnemyRef = ____require_result_0.getEnemyRef
local getEnemyLastThreatUpdateTimeById = ____require_result_0.getEnemyLastThreatUpdateTimeById
local _____6E05_7406_654C_4EBA_8FC7_671F_4EC7_6068_6761_76EEById = ____require_result_0["清理敌人过期仇恨条目ById"]
local _____4EC7_6068_6574_8868_8D85_65F6_6BEB_79D2 = ____require_result_0["仇恨整表超时毫秒"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.02．目标选择")
local _____83B7_53D6_5E94_653B_51FB_76EE_6807 = ____require_result_1["获取应攻击目标"]
local _____83B7_53D6_5F53_524D_76EE_6807ID = ____require_result_1["获取当前目标ID"]
local _____8BBE_7F6E_5F53_524D_76EE_6807 = ____require_result_1["设置当前目标"]
local _____6E05_9664_6240_6709_5F53_524D_76EE_6807 = ____require_result_1["清除所有当前目标"]
local ____require_result_2 = require("系统.01．单位系统.06．仇恨系统.04．仇恨显示")
local _____66F4_65B0_4EC7_6068_663E_793A = ____require_result_2["更新仇恨显示"]
local _____6E05_9664_4EC7_6068_663E_793AById = ____require_result_2["清除仇恨显示ById"]
local _____6E05_9664_6240_6709_4EC7_6068_663E_793A = ____require_result_2["清除所有仇恨显示"]
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_3.debugLogForce
local GetHandleId = jass.GetHandleId
local IsUnitType = jass.IsUnitType
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IssueTargetOrder = jass.IssueTargetOrder
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local MAX_DISTANCE_SQ = 2500 * 2500
local _____5468_671F_56DE_8C03ID = 0
local _____6A21_5757_540D = "仇恨系统"
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
local function _____6E05_7406_654C_4EBA_4EC7_6068_72B6_6001(_____654C_4EBAID)
    debugLogForce(_____6A21_5757_540D, "清理敌人仇恨状态 敌人ID=", _____654C_4EBAID)
    _____6E05_9664_4EC7_6068_663E_793AById(_____654C_4EBAID)
    clearAllThreatById(_____654C_4EBAID)
end
--- 过滤回调：单位死亡或超距时排除
local function _____6784_5EFA_8FC7_6EE4_51FD_6570(ex, ey)
    return function(entry)
        local ref = entry.targetRef
        if ref == nil or ref == 0 then
            return false
        end
        if IsUnitType(ref, UNIT_TYPE_DEAD) then
            return false
        end
        local tx = GetUnitX(ref)
        local ty = GetUnitY(ref)
        local dx = tx - ex
        local dy = ty - ey
        return dx * dx + dy * dy <= MAX_DISTANCE_SQ
    end
end
--- 驱动 Tick：通过敌人引用表拿到敌人单位，再驱动攻击
local function onTick()
    local _____654C_4EBAID_5217_8868 = getAllTrackedEnemyIds(nil)
    do
        local i = 0
        while i < #_____654C_4EBAID_5217_8868 do
            do
                local _____654C_4EBAID = _____654C_4EBAID_5217_8868[i + 1]
                local _____654C_4EBA = getEnemyRef(_____654C_4EBAID)
                if _____654C_4EBA == nil or _____654C_4EBA == 0 then
                    debugLogForce(_____6A21_5757_540D, "驱动清理：敌人引用丢失 敌人ID=", _____654C_4EBAID)
                    _____6E05_7406_654C_4EBA_4EC7_6068_72B6_6001(_____654C_4EBAID)
                    goto __continue13
                end
                if IsUnitType(_____654C_4EBA, UNIT_TYPE_DEAD) then
                    debugLogForce(_____6A21_5757_540D, "驱动清理：敌人已死亡 敌人ID=", _____654C_4EBAID)
                    _____6E05_7406_654C_4EBA_4EC7_6068_72B6_6001(_____654C_4EBAID)
                    goto __continue13
                end
                _____6E05_7406_654C_4EBA_8FC7_671F_4EC7_6068_6761_76EEById(_____654C_4EBAID)
                if not hasThreatTable(_____654C_4EBAID) then
                    debugLogForce(_____6A21_5757_540D, "驱动清理：过期条目清完后已无仇恨表 敌人ID=", _____654C_4EBAID)
                    _____6E05_9664_4EC7_6068_663E_793AById(_____654C_4EBAID)
                    goto __continue13
                end
                local _____6700_8FD1_53D7_4F24_65F6_95F4 = getEnemyLastThreatUpdateTimeById(_____654C_4EBAID)
                if _____6700_8FD1_53D7_4F24_65F6_95F4 > 0 and nowMs() - _____6700_8FD1_53D7_4F24_65F6_95F4 >= _____4EC7_6068_6574_8868_8D85_65F6_6BEB_79D2 then
                    _____6E05_7406_654C_4EBA_4EC7_6068_72B6_6001(_____654C_4EBAID)
                    goto __continue13
                end
                local ex = GetUnitX(_____654C_4EBA)
                local ey = GetUnitY(_____654C_4EBA)
                local filter = _____6784_5EFA_8FC7_6EE4_51FD_6570(ex, ey)
                local best = _____83B7_53D6_5E94_653B_51FB_76EE_6807(_____654C_4EBA, filter)
                if best == nil then
                    debugLogForce(_____6A21_5757_540D, "驱动清理：未找到有效目标 敌人ID=", _____654C_4EBAID)
                    _____6E05_7406_654C_4EBA_4EC7_6068_72B6_6001(_____654C_4EBAID)
                    goto __continue13
                end
                local _____5F53_524D_76EE_6807ID = _____83B7_53D6_5F53_524D_76EE_6807ID(_____654C_4EBA)
                if best.targetRef == nil or best.targetRef == 0 then
                    _____6E05_7406_654C_4EBA_4EC7_6068_72B6_6001(_____654C_4EBAID)
                    goto __continue13
                end
                _____66F4_65B0_4EC7_6068_663E_793A(_____654C_4EBA, best.targetRef, best.threat)
                if _____5F53_524D_76EE_6807ID ~= best.targetHid then
                    debugLogForce(
                        _____6A21_5757_540D,
                        "切换目标 敌人ID=",
                        _____654C_4EBAID,
                        "新目标=",
                        best.targetHid,
                        "仇恨=",
                        best.threat
                    )
                    IssueTargetOrder(_____654C_4EBA, "attack", best.targetRef)
                    _____8BBE_7F6E_5F53_524D_76EE_6807(_____654C_4EBAID, best.targetHid)
                else
                    IssueTargetOrder(_____654C_4EBA, "attack", best.targetRef)
                end
            end
            ::__continue13::
            i = i + 1
        end
    end
end
--- 带敌人引用的外部驱动入口（由调用方在 tick 外调用，传入敌人单位引用）
____exports["驱动单个敌人"] = function(_____654C_4EBA)
    local _____654C_4EBAID = _____53D6_5355_4F4DID(_____654C_4EBA)
    if _____654C_4EBAID == 0 then
        return
    end
    if not hasThreatTable(_____654C_4EBAID) then
        return
    end
    if IsUnitType(_____654C_4EBA, UNIT_TYPE_DEAD) then
        _____6E05_7406_654C_4EBA_4EC7_6068_72B6_6001(_____654C_4EBAID)
        return
    end
    _____6E05_7406_654C_4EBA_8FC7_671F_4EC7_6068_6761_76EEById(_____654C_4EBAID)
    if not hasThreatTable(_____654C_4EBAID) then
        debugLogForce(_____6A21_5757_540D, "单体驱动清理：过期条目清完后已无仇恨表 敌人ID=", _____654C_4EBAID)
        _____6E05_9664_4EC7_6068_663E_793AById(_____654C_4EBAID)
        return
    end
    local _____6700_8FD1_53D7_4F24_65F6_95F4 = getEnemyLastThreatUpdateTimeById(_____654C_4EBAID)
    if _____6700_8FD1_53D7_4F24_65F6_95F4 > 0 and nowMs() - _____6700_8FD1_53D7_4F24_65F6_95F4 >= _____4EC7_6068_6574_8868_8D85_65F6_6BEB_79D2 then
        _____6E05_7406_654C_4EBA_4EC7_6068_72B6_6001(_____654C_4EBAID)
        return
    end
    local ex = GetUnitX(_____654C_4EBA)
    local ey = GetUnitY(_____654C_4EBA)
    local filter = _____6784_5EFA_8FC7_6EE4_51FD_6570(ex, ey)
    local best = _____83B7_53D6_5E94_653B_51FB_76EE_6807(_____654C_4EBA, filter)
    if best == nil then
        debugLogForce(_____6A21_5757_540D, "单体驱动清理：未找到有效目标 敌人ID=", _____654C_4EBAID)
        _____6E05_7406_654C_4EBA_4EC7_6068_72B6_6001(_____654C_4EBAID)
        return
    end
    local _____5F53_524D_76EE_6807ID = _____83B7_53D6_5F53_524D_76EE_6807ID(_____654C_4EBA)
    if best.targetRef == nil or best.targetRef == 0 then
        _____6E05_7406_654C_4EBA_4EC7_6068_72B6_6001(_____654C_4EBAID)
        return
    end
    _____66F4_65B0_4EC7_6068_663E_793A(_____654C_4EBA, best.targetRef, best.threat)
    if _____5F53_524D_76EE_6807ID ~= best.targetHid then
        debugLogForce(
            _____6A21_5757_540D,
            "切换目标 敌人ID=",
            _____654C_4EBAID,
            "新目标=",
            best.targetHid,
            "仇恨=",
            best.threat
        )
        IssueTargetOrder(_____654C_4EBA, "attack", best.targetRef)
        _____8BBE_7F6E_5F53_524D_76EE_6807(_____654C_4EBAID, best.targetHid)
    else
        IssueTargetOrder(_____654C_4EBA, "attack", best.targetRef)
    end
end
--- 初始化仇恨系统：注册 0.25 秒周期回调
____exports["初始化仇恨系统"] = function()
    if _____5468_671F_56DE_8C03ID ~= 0 then
        return
    end
    local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
    local addPeriodicCallback = ____require_result_4.addPeriodicCallback
    _____5468_671F_56DE_8C03ID = addPeriodicCallback(250, onTick)
    debugLogForce(_____6A21_5757_540D, "初始化仇恨系统 周期ID=", _____5468_671F_56DE_8C03ID)
end
--- 停用仇恨系统
____exports["停用仇恨系统"] = function()
    if _____5468_671F_56DE_8C03ID == 0 then
        return
    end
    local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
    local removePeriodicCallback = ____require_result_5.removePeriodicCallback
    removePeriodicCallback(_____5468_671F_56DE_8C03ID)
    _____5468_671F_56DE_8C03ID = 0
    _____6E05_9664_6240_6709_5F53_524D_76EE_6807(nil)
    _____6E05_9664_6240_6709_4EC7_6068_663E_793A()
    debugLogForce(_____6A21_5757_540D, "停用仇恨系统")
end
return ____exports
