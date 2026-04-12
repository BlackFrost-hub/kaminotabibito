local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____01_FF0EDOT_914D_7F6E = require("系统.04．伤害系统.02．DOT定义.01．DOT配置")
local dotEffectModelFromBuffRow = ____01_FF0EDOT_914D_7F6E.dotEffectModelFromBuffRow
local ____03_FF0EDOT_7C7B_578B_5B9A_4E49 = require("系统.04．伤害系统.02．DOT定义.03．DOT类型定义")
local registerBuiltInDotTypes = ____03_FF0EDOT_7C7B_578B_5B9A_4E49.registerBuiltInDotTypes
local ____04_FF0EDOT_5DE5_5177 = require("系统.04．伤害系统.02．DOT定义.04．DOT工具")
local getDotSourceDisplayName = ____04_FF0EDOT_5DE5_5177.getDotSourceDisplayName
local isValidDotStateRow = ____04_FF0EDOT_5DE5_5177.isValidDotStateRow
local tabDeleteHid = ____04_FF0EDOT_5DE5_5177.tabDeleteHid
local tabRowForHid = ____04_FF0EDOT_5DE5_5177.tabRowForHid
local tabSetHid = ____04_FF0EDOT_5DE5_5177.tabSetHid
local unitHid = ____04_FF0EDOT_5DE5_5177.unitHid
local ____05_FF0EDOT_72B6_6001_540C_6B65 = require("系统.04．伤害系统.02．DOT定义.05．DOT状态同步")
local createDotStateSync = ____05_FF0EDOT_72B6_6001_540C_6B65.createDotStateSync
local ____06_FF0EDOT_6267_884C_5668 = require("系统.04．伤害系统.02．DOT定义.06．DOT执行器")
local createDotExecutor = ____06_FF0EDOT_6267_884C_5668.createDotExecutor
local ____07_FF0EDOT_65BD_52A0_7B56_7565 = require("系统.04．伤害系统.02．DOT定义.07．DOT施加策略")
local createDotApplyStrategy = ____07_FF0EDOT_65BD_52A0_7B56_7565.createDotApplyStrategy
local ____08_FF0EDOT_57FA_7840_5DE5_5177 = require("系统.04．伤害系统.02．DOT定义.08．DOT基础工具")
local createDotBaseUtils = ____08_FF0EDOT_57FA_7840_5DE5_5177.createDotBaseUtils
--- 【通用 DOT 框架】持续伤害/减益（如反恢复、燃烧、中毒等）统一在此注册与驱动。
-- 
-- 设计说明（给后续维护或 AI 参考）：
-- - 每种 DOT 通过 registerDotType(config) 注册，配置里包含：解析装备 Buff、取“最强”参数、算每秒伤害、伤害类型、特效模型等。
-- - **普攻命中**：`01．伤害事件.ts` 在同步阶段快照 `isNormalAttack`，经 `registerDamageCallback` 第 6 参传入；装备普攻类 DOT（`Buff:attack:`）由 `tryApplyHeroAttackGearDots` 等路径处理。视为玩家主动叠 debuff；只要装备仍能提供本类 `best`，则**有条必刷新满额 time**（与乘积、字段漂移无关）。无条则新建。
-- - **非普攻伤害**（技能等）：仍用「同解析 time → 刷新」或「新乘积更大 → 换条」；DOT 秒跳自伤靠 ignoredTargetByType 整轮跳过，batch 仅挡无普攻位的回调。
-- - **剩余秒数**：由 `05．Buff系统.00．Buff系统` 的 Buff 池以 `BUFF_POOL_TICK`（0.1s）递减；本模块每 tick 末 `syncDotRemainingFromBuffPool` 把池内 remaining/effect 写回 `stateByType`。
-- - **dotTimer**：每 1 秒按条目的 amount 造成伤害并播特效；到期以池为准移除条目；effectRecycleTimer 统一回收特效。
-- - 若某 DOT 需要“附加效果”（如 10 秒内减 50 攻），可在 config 里提供 onApply/onTick/onEnd 回调，在施加/每跳/结束时执行。
-- 
-- 与 `01．Buff表.ts` 对应：D001「反恢复」、D002「燃烧」、D003「中毒」、D004「巨魔头颅诅咒」等（`effect` 行与表同步）。
-- **图标与每跳特效模型**：只改 `01．Buff表.ts` 的 `icon` / `effect`，勿在本文件写死路径。
-- - 反恢复：装备 `Buff:dmg:AntiHeal200%;time3` → 精神伤害，每秒 regenHP×200%，持续 time 秒。
-- - 燃烧：装备 `Buff:dmg:Burn50;time5` → 火焰伤害，每秒固定 damage 点，持续 time 秒（数值由解析结果决定）。
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local fourCCToString = ____require_result_0.fourCCToString
local damageEventModule = require("系统.04．伤害系统.01．伤害事件")
local leakCore = require("lib.扩展函数.封装函数.05．泄露审计.index")
local ____leakCore_LeakWatcher_1 = leakCore.LeakWatcher
if ____leakCore_LeakWatcher_1 == nil then
    ____leakCore_LeakWatcher_1 = leakCore
end
local LeakWatcher = ____leakCore_LeakWatcher_1
local dotTypes = {}
--- 注册一种 DOT，后续伤害回调会按配置解析装备并施加/覆盖
function ____exports.registerDotType(self, config)
    dotTypes[#dotTypes + 1] = config
end
--- Buff 池同步：避免顶层 require 循环，运行时加载 05．Buff系统.00．Buff系统
local function notifyBuffPool(self, typeId, target, state)
    pcall(function ()
            local m = require("系统.05．Buff系统.00．Buff系统")
            if m ~= nil and type(m.syncDotBuff) == "function" then
                m:syncDotBuff(typeId, target, state)
            end
        end
    )
end
--- 按类型、再按目标存状态。stateByType[typeId][GetHandleId(target)] = { effect, remaining, _dotUnitRef?, ... }
local stateByType = {}
local dotTicks = {}
--- 刚被我们「某类型」伤害打到的单位，下一帧伤害回调里跳过对该类型施加，避免 DOT 触发的伤害再次叠 DOT
local ignoredTargetByType = {}
local equipDataMod = require("系统.02．物品系统.01．装备数据")
local itemsData = equipDataMod.items or equipDataMod.default or ({})
local dotBaseUtils = createDotBaseUtils(nil, {jass = jass, g = g, itemsData = itemsData, fourCCToString = fourCCToString})
local function removeDotTicksForTargetHid(self, typeId, tgtHid)
    do
        local i = #dotTicks - 1
        while i >= 0 do
            local e = dotTicks[i + 1]
            if e.typeId == typeId and unitHid(nil, e.target) == tgtHid then
                __TS__ArraySplice(dotTicks, i, 1)
            end
            i = i - 1
        end
    end
end
local dotStateSync = createDotStateSync(nil, {stateByType = stateByType, dotTypes = dotTypes, removeDotTicksForTargetHid = removeDotTicksForTargetHid, notifyBuffPool = notifyBuffPool})
local dotExecutor = createDotExecutor(nil, {
    jass = jass,
    LeakWatcher = LeakWatcher,
    dotTypes = dotTypes,
    dotTicks = dotTicks,
    stateByType = stateByType,
    ignoredTargetByType = ignoredTargetByType,
    damageEventModule = damageEventModule,
    unitHid = unitHid,
    tabRowForHid = tabRowForHid,
    isValidDotStateRow = isValidDotStateRow
})
local dotApplyStrategy = createDotApplyStrategy(
    nil,
    {
        dotTypes = dotTypes,
        stateByType = stateByType,
        dotTicks = dotTicks,
        ignoredTargetByType = ignoredTargetByType,
        unitHid = unitHid,
        isSourceHeroPlayer1to4 = dotBaseUtils.isSourceHeroPlayer1to4,
        isDebuffDotTargetOk = dotBaseUtils.isDebuffDotTargetOk,
        tabRowForHid = tabRowForHid,
        tabSetHid = tabSetHid,
        tabDeleteHid = tabDeleteHid,
        isValidDotStateRow = isValidDotStateRow,
        getDotSourceDisplayName = getDotSourceDisplayName,
        notifyBuffPool = notifyBuffPool,
        ensureDotTimers = function() return dotExecutor:ensureDotTimers() end,
        getDotTickBatchTargetHids = function() return dotExecutor:getDotTickBatchTargetHids() end
    }
)
--- Buff 池每 0.1s 递减后调用：把池内 remaining/effect 写回 `stateByType`；池已无行则清理逻辑层与秒跳队列。
function ____exports.syncDotRemainingFromBuffPool(self)
    dotStateSync:syncDotRemainingFromBuffPool()
end
--- Buff 池判定某 DOT 到期时调用（池行已删，勿再 syncDotBuff null）
function ____exports.clearDotByBuffPoolExpire(self, buffID, hid)
    dotStateSync:clearDotByBuffPoolExpire(buffID, hid)
end
--- 伤害事件延后展示前调用：用 entry.gearDotAttackRefreshHint 判定普攻位（已在事件同步阶段快照，不依赖 jass 全局），每刀只叠一次装备 DOT，避免多段伤害丢 8192/16384。
-- 与 `onDamage` 内普攻分支互斥：回调里 `isAttackHitForDot` 为真时不再叠层。
function ____exports.tryApplyHeroAttackGearDots(self, source, target, _damage)
    dotApplyStrategy:tryApplyHeroAttackGearDots(source, target, _damage)
end
--- 由 伤害事件.runDeferredDamageDisplay 在每段 DOT 伤害展示回调结束后调用，替代 Timer(0) 清空 batch（避免早于 deferred onDamage）
function ____exports.notifyDotTickBatchDamageDisplayed(self)
    dotExecutor:notifyDotTickBatchDamageDisplayed()
end
local function onDamage(self, target, damage, damageType, fromDotTickBatch, source, isNormalAttackHit)
    dotApplyStrategy:onDamage(
        target,
        damage,
        damageType,
        fromDotTickBatch,
        source,
        isNormalAttackHit
    )
end
local getBestDotFromUnit = dotBaseUtils.getBestDotFromUnit
local getUnitMaxHp = dotBaseUtils.getUnitMaxHp
local getTargetRegenHP = dotBaseUtils.getTargetRegenHP
registerBuiltInDotTypes(nil, {
    registerDotType = ____exports.registerDotType,
    getBestDotFromUnit = getBestDotFromUnit,
    getTargetRegenHP = getTargetRegenHP,
    getUnitMaxHp = getUnitMaxHp,
    dotEffectModelFromBuffRow = dotEffectModelFromBuffRow
})
local registered = false
local function getDotStateByTypeId(self, typeId, unit)
    local tab = stateByType[typeId]
    if tab == nil or unit == nil or unit == 0 then
        return nil
    end
    local h = unitHid(nil, unit)
    local ____temp_2
    if h ~= 0 then
        ____temp_2 = tabRowForHid(nil, tab, h)
    else
        ____temp_2 = nil
    end
    local raw = ____temp_2
    if raw ~= nil then
        return isValidDotStateRow(nil, raw) and raw or nil
    end
    local u = tab[unit]
    return u ~= nil and isValidDotStateRow(nil, u) and u or nil
end
--- 供治疗等系统读取：单位当前反恢复状态，无则返回 null
function ____exports.getUnitAntiHeal(self, unit)
    return getDotStateByTypeId(nil, "antiHeal", unit)
end
--- 供 UI 等读取：单位当前燃烧 DOT 状态，无则返回 null
function ____exports.getUnitBurn(self, unit)
    return getDotStateByTypeId(nil, "burn", unit)
end
--- 供 UI 等读取：单位当前中毒 DOT 状态，无则返回 null
function ____exports.getUnitPoison(self, unit)
    return getDotStateByTypeId(nil, "poison", unit)
end
--- 供 UI 等读取：D004 巨魔头颅诅咒（`registerDotType` id `trollCurse` 注册后才有状态）
function ____exports.getUnitTrollCurse(self, unit)
    return getDotStateByTypeId(nil, "trollCurse", unit)
end
--- 造成精神伤害（供外部直接调用，如其他技能）；会标记 target 以免伤害回调再次施加同源 DOT。
function ____exports.dealSpiritDamage(self, source, target, amount)
    dotExecutor:dealDamageForType("antiHeal", source, target, amount)
end
--- 造成火焰伤害（外部技能与 burn DOT 同源类型时可调用）
function ____exports.dealBurnDamage(self, source, target, amount)
    dotExecutor:dealDamageForType("burn", source, target, amount)
end
if not registered then
    registered = true
    damageEventModule:registerDamageCallback(onDamage)
end
return ____exports
