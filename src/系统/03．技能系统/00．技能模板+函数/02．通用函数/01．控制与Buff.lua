local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
local _____505C_6B62_65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_9A71_52A8, _____65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_8868_662F_5426_4E3A_7A7A, ____on_65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406Tick, _____5355_4F4D_62E5_6709Buff_6548_679C, ____Buff_7C7B_578B_62E5_6709_5B57_6BB5, ____Buff_8868_7C7B_578B_662F_51CF_901F, _____6E05_9664_5355_4F4DBuff_6548_679C_5408_96C6, GetUnitAbilityLevel, UnitRemoveAbility, removePeriodicCallback, getServerTime, _____65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_8868, _____65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_9A71_52A8ID, ____Buff_7C7B_578B_5B57_6BB5__51CF_901F
local ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local GS_Suspend = ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF.GS_Suspend
local GS_IsUnitSuspending = ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF.GS_IsUnitSuspending
local GS_LoadSuspend = ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF.GS_LoadSuspend
local GS_UnitSuspend = ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF.GS_UnitSuspend
local ____04_FF0E_5FEB_901FBuff_7CFB_7EDF = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
local SFB_Init = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_Init
local SFB_setBuff = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_setBuff
local SFB_setSlow = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_setSlow
local ____SFB__65BD_52A0_901A_7528Buff = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF["SFB_施加通用Buff"]
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local getBuffRuntime = ____00_FF0EBuff_7CFB_7EDF.getBuffRuntime
local getBuffIdsOnUnit = ____00_FF0EBuff_7CFB_7EDF.getBuffIdsOnUnit
local isUnitInBuffPool = ____00_FF0EBuff_7CFB_7EDF.isUnitInBuffPool
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____00_FF0EBuff_7CFB_7EDF["移除单位指定Buff"]
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local ____07_FF0E_7761_7720_7CFB_7EDF = require("系统.05．Buff系统.07．睡眠系统")
local _____65BD_52A0_7761_7720 = ____07_FF0E_7761_7720_7CFB_7EDF["施加睡眠"]
local _____6E05_9664_7761_7720 = ____07_FF0E_7761_7720_7CFB_7EDF["清除睡眠"]
local _____5355_4F4D_6B63_5728_7761_7720 = ____07_FF0E_7761_7720_7CFB_7EDF["单位正在睡眠"]
local _____6CE8_518C_4EFB_610F_5355_4F4D_88AB_7761_7720_76D1_542C = ____07_FF0E_7761_7720_7CFB_7EDF["注册任意单位被睡眠监听"]
local _____6CE8_518C_4EFB_610F_5355_4F4D_9192_6765_76D1_542C = ____07_FF0E_7761_7720_7CFB_7EDF["注册任意单位醒来监听"]
local _____6CE8_518C_4EFB_610F_5355_4F4D_7761_7720_88AB_6253_7834_76D1_542C = ____07_FF0E_7761_7720_7CFB_7EDF["注册任意单位睡眠被打破监听"]
local ____05_FF0EBuff_6E05_9664_51FD_6570 = require("系统.05．Buff系统.05．Buff清除函数")
local _____79FB_9664_5355_4F4D_6307_5B9A_7C7B_578BBuff = ____05_FF0EBuff_6E05_9664_51FD_6570["移除单位指定类型Buff"]
local _____79FB_9664_5355_4F4D_589E_76CABuff = ____05_FF0EBuff_6E05_9664_51FD_6570["移除单位增益Buff"]
local _____79FB_9664_5355_4F4D_8D1F_9762Buff = ____05_FF0EBuff_6E05_9664_51FD_6570["移除单位负面Buff"]
local _____6309_9A71_6563_7B49_7EA7_79FB_9664_5355_4F4DBuff = ____05_FF0EBuff_6E05_9664_51FD_6570["按驱散等级移除单位Buff"]
local _____4E00_7EA7_9A71_6563_5355_4F4DBuff = ____05_FF0EBuff_6E05_9664_51FD_6570["一级驱散单位Buff"]
local _____4E8C_7EA7_9A71_6563_5355_4F4DBuff = ____05_FF0EBuff_6E05_9664_51FD_6570["二级驱散单位Buff"]
local ____01_FF0E_6838_5FC3_529F_80FD = require("系统.04．伤害系统.03．重伤系统.01．核心功能")
local _____83B7_53D6_5355_4F4D_91CD_4F24 = ____01_FF0E_6838_5FC3_529F_80FD["获取单位重伤"]
local _____65BD_52A0_91CD_4F24 = ____01_FF0E_6838_5FC3_529F_80FD["施加重伤"]
local _____79FB_9664_5355_4F4D_91CD_4F24 = ____01_FF0E_6838_5FC3_529F_80FD["移除单位重伤"]
function _____505C_6B62_65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_9A71_52A8()
    if _____65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_9A71_52A8ID == 0 then
        return
    end
    removePeriodicCallback(_____65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_9A71_52A8ID)
    _____65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_9A71_52A8ID = 0
end
function _____65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_8868_662F_5426_4E3A_7A7A()
    for key in pairs(_____65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_8868) do
        if _____65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_8868[key] ~= nil then
            return false
        end
    end
    return true
end
function ____on_65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406Tick()
    local now = getServerTime()
    for key in pairs(_____65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_8868) do
        local hid = key
        local _____5230_671F_65F6_95F4 = _____65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_8868[hid] or 0
        if _____5230_671F_65F6_95F4 > 0 and now >= _____5230_671F_65F6_95F4 then
            __TS__Delete(_____65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_8868, hid)
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(hid, ____exports["施法硬直显示BuffID"])
        end
    end
    if _____65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_8868_662F_5426_4E3A_7A7A() then
        _____505C_6B62_65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_9A71_52A8()
    end
end
function _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, BuffID)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or BuffID == nil or BuffID == 0 then
        return false
    end
    return GetUnitAbilityLevel(_____5355_4F4D, BuffID) > 0
end
function ____Buff_7C7B_578B_62E5_6709_5B57_6BB5(typeName, _____5B57_6BB5)
    local lowerType = string.lower(typeName)
    local lowerField = string.lower(_____5B57_6BB5)
    local start = 0
    while start <= #lowerType do
        local ____end = (string.find(
            lowerType,
            ":",
            math.max(start + 1, 1),
            true
        ) or 0) - 1
        local part = ____end >= 0 and __TS__StringSubstring(lowerType, start, ____end) or __TS__StringSubstring(lowerType, start)
        if part == lowerField then
            return true
        end
        if ____end < 0 then
            break
        end
        start = ____end + 1
    end
    return false
end
function ____Buff_8868_7C7B_578B_662F_51CF_901F(typeName)
    return ____Buff_7C7B_578B_62E5_6709_5B57_6BB5(typeName, ____Buff_7C7B_578B_5B57_6BB5__51CF_901F)
end
function _____6E05_9664_5355_4F4DBuff_6548_679C_5408_96C6(_____5355_4F4D, ____Buff_5217_8868)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    local removed = 0
    local index = 0
    while index < #____Buff_5217_8868 do
        local BuffID = ____Buff_5217_8868[index + 1]
        if _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, BuffID) and UnitRemoveAbility(_____5355_4F4D, BuffID) then
            removed = removed + 1
        end
        index = index + 1
    end
    return removed
end
--- 通用函数 - 控制与 Buff 便捷入口
-- 
-- 说明：
-- - 这是技能侧最显眼的控制 / 快速 Buff / Buff 清除入口。
-- - 这里只做技能侧便捷转导出，不迁移底层实现。
-- - 底层来源：
--   - `TS/lib/扩展函数/Star扩展函数/Star扩展库/03．硬直暂停系统.ts`
--   - `TS/lib/扩展函数/Star扩展函数/Star扩展库/04．快速Buff系统.ts`
--   - `TS/系统/05．Buff系统/05．Buff清除函数.ts`
-- - 清除函数按 `TS/系统/05．Buff系统/01．Buff表.ts` 的 `type` 前缀工作：
--   - `Buff:` 清增益
--   - `Debuff:` 清负面
--   - `Debuff:control` 清控制类负面
--   - `Debuff:magic` 清魔法类负面
-- - `onlyPurgable=true` 时只清 `canPurge: true` 的条目。
-- - 快速 Buff 的原生魔法效果由魔兽管理；底层清除时会同步移除登记过的原生魔法效果。
-- - 下面这组“硬控制效果合集”使用固定 Buff 原始码，不再依赖 `udg_MFXG` 全局变量。
-- - 这些 Buff 命中后，通常应视为会打断蓄力、引导、持续施法。
local jass = require("jass.common")
GetUnitAbilityLevel = jass.GetUnitAbilityLevel
UnitRemoveAbility = jass.UnitRemoveAbility
local GetHandleId = jass.GetHandleId
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.09．表现系统.15．世界坐标进度UI.01．世界坐标进度UI")
local _____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI = ____require_result_1["创建世界坐标进度UI"]
local _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI = ____require_result_1["更新世界坐标进度UI"]
local _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI = ____require_result_1["销毁世界坐标进度UI"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local buffTableMod = require("系统.05．Buff系统.01．Buff表")
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
do
    local ____02_FF0Edot_4F24_5BB3 = require("系统.04．伤害系统.02．dot伤害")
    ____exports.getUnitBurn = ____02_FF0Edot_4F24_5BB3.getUnitBurn
end
do
    local ____04_FF0E_62A4_7532_964D_4F4E = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.01．debuff.04．护甲降低")
    ____exports["施加单体护甲降低Buff"] = ____04_FF0E_62A4_7532_964D_4F4E["施加单体护甲降低Buff"]
    ____exports["施加范围护甲降低Buff"] = ____04_FF0E_62A4_7532_964D_4F4E["施加范围护甲降低Buff"]
end
do
    local ____04_FF0E_79FB_901F_63D0_5347 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.04．移速提升")
    ____exports["施加移速提升Buff"] = ____04_FF0E_79FB_901F_63D0_5347["施加移速提升Buff"]
    ____exports["清除单位移速提升Buff"] = ____04_FF0E_79FB_901F_63D0_5347["清除单位移速提升Buff"]
end
do
    local ____05_FF0E_89C6_91CE_53D8_5316 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.05．视野变化")
    ____exports["施加视野变化Buff"] = ____05_FF0E_89C6_91CE_53D8_5316["施加视野变化Buff"]
end
do
    local ____06_FF0E_8D1F_9762_6548_679C_514D_75AB_72B6_6001 = require("系统.05．Buff系统.06．负面效果免疫状态")
    ____exports["施加单位负面效果免疫"] = ____06_FF0E_8D1F_9762_6548_679C_514D_75AB_72B6_6001["施加单位负面效果免疫"]
    ____exports["施加单位控制负面效果免疫"] = ____06_FF0E_8D1F_9762_6548_679C_514D_75AB_72B6_6001["施加单位控制负面效果免疫"]
    ____exports["施加单位魔法负面效果免疫"] = ____06_FF0E_8D1F_9762_6548_679C_514D_75AB_72B6_6001["施加单位魔法负面效果免疫"]
    ____exports["清除单位负面效果免疫"] = ____06_FF0E_8D1F_9762_6548_679C_514D_75AB_72B6_6001["清除单位负面效果免疫"]
    ____exports["单位是否免疫负面效果类型"] = ____06_FF0E_8D1F_9762_6548_679C_514D_75AB_72B6_6001["单位是否免疫负面效果类型"]
    ____exports["单位是否免疫负面效果BuffID"] = ____06_FF0E_8D1F_9762_6548_679C_514D_75AB_72B6_6001["单位是否免疫负面效果BuffID"]
end
____exports.GS_Suspend = GS_Suspend
____exports.GS_IsUnitSuspending = GS_IsUnitSuspending
____exports.GS_LoadSuspend = GS_LoadSuspend
____exports.GS_UnitSuspend = GS_UnitSuspend
____exports.SFB_Init = SFB_Init
____exports.SFB_setBuff = SFB_setBuff
____exports.SFB_setSlow = SFB_setSlow
____exports["SFB_施加通用Buff"] = ____SFB__65BD_52A0_901A_7528Buff
____exports.getBuffRuntime = getBuffRuntime
____exports.getBuffIdsOnUnit = getBuffIdsOnUnit
____exports.isUnitInBuffPool = isUnitInBuffPool
____exports["移除单位指定Buff"] = _____79FB_9664_5355_4F4D_6307_5B9ABuff
____exports["施加睡眠"] = _____65BD_52A0_7761_7720
____exports["清除睡眠"] = _____6E05_9664_7761_7720
____exports["单位正在睡眠"] = _____5355_4F4D_6B63_5728_7761_7720
____exports["注册任意单位被睡眠监听"] = _____6CE8_518C_4EFB_610F_5355_4F4D_88AB_7761_7720_76D1_542C
____exports["注册任意单位醒来监听"] = _____6CE8_518C_4EFB_610F_5355_4F4D_9192_6765_76D1_542C
____exports["注册任意单位睡眠被打破监听"] = _____6CE8_518C_4EFB_610F_5355_4F4D_7761_7720_88AB_6253_7834_76D1_542C
____exports["移除单位指定类型Buff"] = _____79FB_9664_5355_4F4D_6307_5B9A_7C7B_578BBuff
____exports["移除单位增益Buff"] = _____79FB_9664_5355_4F4D_589E_76CABuff
____exports["移除单位负面Buff"] = _____79FB_9664_5355_4F4D_8D1F_9762Buff
____exports["按驱散等级移除单位Buff"] = _____6309_9A71_6563_7B49_7EA7_79FB_9664_5355_4F4DBuff
____exports["一级驱散单位Buff"] = _____4E00_7EA7_9A71_6563_5355_4F4DBuff
____exports["二级驱散单位Buff"] = _____4E8C_7EA7_9A71_6563_5355_4F4DBuff
____exports["施法硬直显示BuffID"] = "C037"
____exports["施法硬直显示Buff图标"] = "ReplaceableTextures\\CommandButtons\\BTNReplay-Pause.blp"
_____65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_8868 = {}
_____65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_9A71_52A8ID = 0
local function _____542F_52A8_65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_9A71_52A8()
    if _____65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_9A71_52A8ID ~= 0 then
        return
    end
    _____65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_9A71_52A8ID = addPeriodicCallback(50, ____on_65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406Tick)
end
local function _____5237_65B0_65BD_6CD5_786C_76F4_663E_793ABuff(_____5355_4F4D, _____6301_7EED_65F6_95F4)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or not (_____6301_7EED_65F6_95F4 > 0) then
        return
    end
    local hid = GetHandleId(_____5355_4F4D) or 0
    if hid == 0 then
        return
    end
    _____65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_8868[hid] = getServerTime() + _____6301_7EED_65F6_95F4 * 1000
    registerManualBuff(
        _____5355_4F4D,
        ____exports["施法硬直显示BuffID"],
        _____6301_7EED_65F6_95F4 + 0.2,
        0,
        {sourceName = "施法硬直", iconOverride = ____exports["施法硬直显示Buff图标"]}
    )
    _____542F_52A8_65BD_6CD5_786C_76F4_663E_793ABuff_6E05_7406_9A71_52A8()
end
local _____786C_76F4_8BFB_6761_8868 = {}
local function _____9500_6BC1_786C_76F4_8BFB_6761(_____5355_4F4D_53E5_67C4)
    local _____8BB0_5F55 = _____786C_76F4_8BFB_6761_8868[_____5355_4F4D_53E5_67C4]
    if _____8BB0_5F55 == nil then
        return
    end
    if _____8BB0_5F55["周期ID"] ~= 0 then
        removePeriodicCallback(_____8BB0_5F55["周期ID"])
    end
    _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI(_____8BB0_5F55.UI)
    __TS__Delete(_____786C_76F4_8BFB_6761_8868, _____5355_4F4D_53E5_67C4)
end
local function _____5237_65B0_786C_76F4_8BFB_6761(_____5355_4F4D, _____6301_7EED_65F6_95F4, _____53C2_6570)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or not (_____6301_7EED_65F6_95F4 > 0) then
        return
    end
    local _____5355_4F4D_53E5_67C4 = GetHandleId(_____5355_4F4D) or 0
    if _____5355_4F4D_53E5_67C4 == 0 then
        return
    end
    _____9500_6BC1_786C_76F4_8BFB_6761(_____5355_4F4D_53E5_67C4)
    local _____6700_5927_79D2 = _____6301_7EED_65F6_95F4
    local _____5269_4F59_79D2 = _____6700_5927_79D2
    local ____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI_10 = _____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI
    local ____GetUnitX_result_4 = GetUnitX(_____5355_4F4D)
    local ____GetUnitY_result_5 = GetUnitY(_____5355_4F4D)
    local ____5355_4F4D_6 = _____5355_4F4D
    local ____temp_7 = _____53C2_6570["Z偏移"] or 220
    local ____temp_8 = _____53C2_6570["标题"] or "硬直"
    local ____temp_9 = _____53C2_6570["数值后缀"] or ""
    local ____53C2_6570_UI_7C7B_578B_3 = _____53C2_6570["UI类型"]
    if ____53C2_6570_UI_7C7B_578B_3 == nil then
        ____53C2_6570_UI_7C7B_578B_3 = "自然"
    end
    local UI = ____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI_10({
        X = ____GetUnitX_result_4,
        Y = ____GetUnitY_result_5,
        Z = 0,
        ["跟随单位"] = ____5355_4F4D_6,
        ["跟随Z偏移"] = ____temp_7,
        ["最大值"] = _____6700_5927_79D2,
        ["当前值"] = _____6700_5927_79D2,
        ["标题"] = ____temp_8,
        ["数值后缀"] = ____temp_9,
        ["类型"] = ____53C2_6570_UI_7C7B_578B_3
    })
    local _____5468_671FID = addPeriodicCallback(
        50,
        function()
            _____5269_4F59_79D2 = _____5269_4F59_79D2 - 0.05
            if _____5269_4F59_79D2 <= 0 then
                _____9500_6BC1_786C_76F4_8BFB_6761(_____5355_4F4D_53E5_67C4)
                return
            end
            _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI(UI, _____5269_4F59_79D2)
        end
    )
    _____786C_76F4_8BFB_6761_8868[_____5355_4F4D_53E5_67C4] = {UI = UI, ["周期ID"] = _____5468_671FID}
end
____exports["开始硬直"] = function(_____5355_4F4D, _____6301_7EED_65F6_95F4, _____8BFB_6761_53C2_6570)
    GS_Suspend(_____5355_4F4D, _____6301_7EED_65F6_95F4)
    _____5237_65B0_65BD_6CD5_786C_76F4_663E_793ABuff(_____5355_4F4D, _____6301_7EED_65F6_95F4)
    if _____8BFB_6761_53C2_6570 ~= nil then
        _____5237_65B0_786C_76F4_8BFB_6761(_____5355_4F4D, _____6301_7EED_65F6_95F4, _____8BFB_6761_53C2_6570)
    end
end
____exports["单位是否硬直中"] = GS_IsUnitSuspending
____exports["获取单位硬直剩余时间"] = GS_LoadSuspend
____exports["调整单位硬直时间"] = function(_____5355_4F4D, _____64CD_4F5C_7C7B_578B, _____65F6_95F4_503C)
    GS_UnitSuspend(_____5355_4F4D, _____64CD_4F5C_7C7B_578B, _____65F6_95F4_503C)
    local _____5269_4F59_65F6_95F4 = GS_LoadSuspend(_____5355_4F4D)
    if _____5269_4F59_65F6_95F4 > 0 then
        _____5237_65B0_65BD_6CD5_786C_76F4_663E_793ABuff(_____5355_4F4D, _____5269_4F59_65F6_95F4)
    else
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____5355_4F4D, ____exports["施法硬直显示BuffID"])
    end
end
____exports["初始化快速Buff系统"] = SFB_Init
____exports["施加快速Buff"] = ____SFB__65BD_52A0_901A_7528Buff
____exports["施加快速控制Buff"] = SFB_setBuff
____exports["施加快速减速Buff"] = SFB_setSlow
____exports["读取单位重伤"] = _____83B7_53D6_5355_4F4D_91CD_4F24
____exports["施加单位重伤"] = _____65BD_52A0_91CD_4F24
____exports["清除单位重伤"] = _____79FB_9664_5355_4F4D_91CD_4F24
____exports["清除单位指定类型Buff"] = _____79FB_9664_5355_4F4D_6307_5B9A_7C7B_578BBuff
____exports["清除单位指定Buff"] = _____79FB_9664_5355_4F4D_6307_5B9ABuff
____exports["清除单位增益Buff"] = _____79FB_9664_5355_4F4D_589E_76CABuff
____exports["清除单位负面Buff"] = _____79FB_9664_5355_4F4D_8D1F_9762Buff
____exports["按驱散等级清除单位Buff"] = _____6309_9A71_6563_7B49_7EA7_79FB_9664_5355_4F4DBuff
____exports["一级驱散清除单位Buff"] = _____4E00_7EA7_9A71_6563_5355_4F4DBuff
____exports["二级驱散清除单位Buff"] = _____4E8C_7EA7_9A71_6563_5355_4F4DBuff
____exports["获取单位Buff运行数据"] = getBuffRuntime
____exports["获取单位BuffID列表"] = getBuffIdsOnUnit
____exports["单位是否在Buff池中"] = isUnitInBuffPool
____exports["施加黑翼守护契约Buff"] = function(_____5B88_62A4_8005, _____53D7_62A4_8005, _____6301_7EED_65F6_95F4, _____8F6C_79FB_6BD4_4F8B)
    if _____5B88_62A4_8005 == nil or _____5B88_62A4_8005 == 0 or _____53D7_62A4_8005 == nil or _____53D7_62A4_8005 == 0 or not (_____6301_7EED_65F6_95F4 > 0) then
        return
    end
    registerManualBuff(
        _____5B88_62A4_8005,
        _____5E38_89C4BuffID["黑翼守护重盾_守护者契约"],
        _____6301_7EED_65F6_95F4,
        _____8F6C_79FB_6BD4_4F8B,
        {sourceUnit = _____5B88_62A4_8005, effectSourceName = "黑翼守护重盾", effectSourceType = "装备"}
    )
    registerManualBuff(
        _____53D7_62A4_8005,
        _____5E38_89C4BuffID["黑翼守护重盾_受护者契约"],
        _____6301_7EED_65F6_95F4,
        _____8F6C_79FB_6BD4_4F8B,
        {sourceUnit = _____5B88_62A4_8005, effectSourceName = "黑翼守护重盾", effectSourceType = "装备"}
    )
end
____exports["清除黑翼守护契约Buff"] = function(_____5B88_62A4_8005, _____53D7_62A4_8005)
    if _____5B88_62A4_8005 ~= nil and _____5B88_62A4_8005 ~= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____5B88_62A4_8005, _____5E38_89C4BuffID["黑翼守护重盾_守护者契约"])
    end
    if _____53D7_62A4_8005 ~= nil and _____53D7_62A4_8005 ~= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____53D7_62A4_8005, _____5E38_89C4BuffID["黑翼守护重盾_受护者契约"])
    end
end
--- 判断单位是否拥有指定 Buff 池条目。
____exports["单位是否拥有指定Buff"] = function(_____5355_4F4D, BuffID)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or BuffID == nil or BuffID == "" then
        return false
    end
    return getBuffRuntime(_____5355_4F4D, BuffID) ~= nil
end
--- 清除单位控制类负面 Buff（Buff 表 type 以 `Debuff:control` 开头）。
____exports["清除单位控制类负面Buff"] = function(_____5355_4F4D, _____53EA_6E05_53EF_9A71_6563)
    if _____53EA_6E05_53EF_9A71_6563 == nil then
        _____53EA_6E05_53EF_9A71_6563 = false
    end
    return _____79FB_9664_5355_4F4D_6307_5B9A_7C7B_578BBuff(_____5355_4F4D, "Debuff:control", _____53EA_6E05_53EF_9A71_6563)
end
--- 硬控制 / 会打断蓄力的魔法效果合集
-- 
-- 对应旧 JASS：
-- - udg_MFXG[1] = 'BSTN' 眩晕
-- - udg_MFXG[2] = 'BPSE' 破击晕眩
-- - udg_MFXG[3] = 'B000' 时间停止
-- - udg_MFXG[4] = 'BNsi' 沉默
-- - udg_MFXG[5] = 'BNso' 火黑-默认灵魂燃烧
-- - udg_MFXG[7] = 'B01B' 硬直
-- - udg_MFXG[8] = 'Bfrz' 冰冻喷吐
-- - 快速 Buff 现用控制效果：变形、睡眠、纠缠根须、飓风等也并入这里。
-- 
-- 说明：
-- - `Bslo` 是减速，不属于硬控制，因此不放进这里。
-- - `B002` 是旧表里的“魔法效果”占位，不作为打断合集使用。
local _____65BD_6CD5_786C_76F4Buff__9B54_6CD5_6548_679C = 1110454322
local _____786C_63A7_5236Buff__7729_6655 = 1112757326
local _____786C_63A7_5236Buff__7834_51FB_6655_7729 = 1112560453
local _____786C_63A7_5236Buff__65F6_95F4_505C_6B62 = 1110454320
local _____786C_63A7_5236Buff__6C89_9ED8 = 1112437609
local _____786C_63A7_5236Buff__706B_9ED1_9ED8_8BA4_7075_9B42_71C3_70E7 = 1112437615
local _____786C_63A7_5236Buff__786C_76F4 = 1110454594
local _____786C_63A7_5236Buff__51B0_51BB_55B7_5410 = 1114010234
local _____786C_63A7_5236Buff__53D8_5F62 = 1114664057
local _____786C_63A7_5236Buff__7761_7720_4E3B_6548_679C = 1112896364
local _____786C_63A7_5236Buff__7761_7720_6682_505C = 1112896368
local _____786C_63A7_5236Buff__7761_7720_7729_6655 = 1114993524
local _____786C_63A7_5236Buff__7EA0_7F20_6839_987B = 1111844210
local _____786C_63A7_5236Buff__98D3_98CE_4E3B_6548_679C = 1113815395
local _____786C_63A7_5236Buff__98D3_98CE_9644_52A0 = 1113815346
local _____8F6F_63A7_5236Buff__51CF_901F = 1114860655
local _____8F6F_63A7_5236Buff__6B8B_5E9F = 1113813609
local _____8F6F_63A7_5236Buff__8BC5_5492 = 1113813619
local _____524A_5F31Buff__7CBE_7075_4E4B_706B = 1114005861
local _____6301_7EED_4F24_5BB3Buff__5BC4_751F = 1112436833
local ____Buff_7C7B_578B_5B57_6BB5__8D1F_9762 = "debuff"
local ____Buff_7C7B_578B_5B57_6BB5__63A7_5236 = "control"
local ____Buff_7C7B_578B_5B57_6BB5__8F6F_63A7_5236 = "soft"
____Buff_7C7B_578B_5B57_6BB5__51CF_901F = "slow"
local ____Buff_7C7B_578B_5B57_6BB5__6301_7EED_4F24_5BB3 = "dot"
local _____786C_63A7_5236Buff_5408_96C6 = {
    _____786C_63A7_5236Buff__7729_6655,
    _____786C_63A7_5236Buff__7834_51FB_6655_7729,
    _____786C_63A7_5236Buff__65F6_95F4_505C_6B62,
    _____786C_63A7_5236Buff__6C89_9ED8,
    _____786C_63A7_5236Buff__706B_9ED1_9ED8_8BA4_7075_9B42_71C3_70E7,
    _____786C_63A7_5236Buff__786C_76F4,
    _____786C_63A7_5236Buff__51B0_51BB_55B7_5410,
    _____786C_63A7_5236Buff__53D8_5F62,
    _____786C_63A7_5236Buff__7761_7720_4E3B_6548_679C,
    _____786C_63A7_5236Buff__7761_7720_6682_505C,
    _____786C_63A7_5236Buff__7761_7720_7729_6655,
    _____786C_63A7_5236Buff__7EA0_7F20_6839_987B,
    _____786C_63A7_5236Buff__98D3_98CE_4E3B_6548_679C,
    _____786C_63A7_5236Buff__98D3_98CE_9644_52A0
}
local _____8F6F_63A7_5236Buff_5408_96C6 = {_____8F6F_63A7_5236Buff__51CF_901F, _____8F6F_63A7_5236Buff__6B8B_5E9F, _____8F6F_63A7_5236Buff__8BC5_5492}
local _____51CF_901FBuff_5408_96C6 = {_____8F6F_63A7_5236Buff__51CF_901F}
local _____539F_751F_6301_7EED_4F24_5BB3Buff_5408_96C6 = {_____6301_7EED_4F24_5BB3Buff__5BC4_751F}
local ____array_11 = __TS__SparseArrayNew(table.unpack(_____786C_63A7_5236Buff_5408_96C6))
__TS__SparseArrayPush(
    ____array_11,
    table.unpack(_____8F6F_63A7_5236Buff_5408_96C6)
)
local _____539F_751F_63A7_5236Buff_5408_96C6 = {__TS__SparseArraySpread(____array_11)}
local ____array_12 = __TS__SparseArrayNew(table.unpack(_____539F_751F_63A7_5236Buff_5408_96C6))
__TS__SparseArrayPush(
    ____array_12,
    _____524A_5F31Buff__7CBE_7075_4E4B_706B,
    table.unpack(_____539F_751F_6301_7EED_4F24_5BB3Buff_5408_96C6)
)
local _____539F_751F_8D1F_9762Buff_5408_96C6 = {__TS__SparseArraySpread(____array_12)}
local function _____5355_4F4D_62E5_6709_4EFB_610FBuff_6548_679C_5408_96C6(_____5355_4F4D, ____Buff_5217_8868)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    local index = 0
    while index < #____Buff_5217_8868 do
        if _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, ____Buff_5217_8868[index + 1]) then
            return true
        end
        index = index + 1
    end
    return false
end
local function ____Buff_8868_7C7B_578B_662F_8D1F_9762(typeName)
    return ____Buff_7C7B_578B_62E5_6709_5B57_6BB5(typeName, ____Buff_7C7B_578B_5B57_6BB5__8D1F_9762)
end
local function ____Buff_8868_7C7B_578B_662F_63A7_5236(typeName)
    return ____Buff_7C7B_578B_62E5_6709_5B57_6BB5(typeName, ____Buff_7C7B_578B_5B57_6BB5__63A7_5236)
end
local function ____Buff_8868_7C7B_578B_662F_8F6F_63A7_5236(typeName)
    return ____Buff_7C7B_578B_62E5_6709_5B57_6BB5(typeName, ____Buff_7C7B_578B_5B57_6BB5__8F6F_63A7_5236) or ____Buff_8868_7C7B_578B_662F_51CF_901F(typeName)
end
local function ____Buff_8868_7C7B_578B_662F_786C_63A7_5236(typeName)
    return ____Buff_8868_7C7B_578B_662F_63A7_5236(typeName) and not ____Buff_8868_7C7B_578B_662F_8F6F_63A7_5236(typeName)
end
local function ____Buff_8868_7C7B_578B_662F_63A7_5236_6548_679C(typeName)
    return ____Buff_8868_7C7B_578B_662F_786C_63A7_5236(typeName) or ____Buff_8868_7C7B_578B_662F_8F6F_63A7_5236(typeName)
end
local function ____Buff_8868_7C7B_578B_662F_6301_7EED_4F24_5BB3(typeName)
    return ____Buff_7C7B_578B_62E5_6709_5B57_6BB5(typeName, ____Buff_7C7B_578B_5B57_6BB5__6301_7EED_4F24_5BB3)
end
local function _____5355_4F4D_62E5_6709_5339_914DBuff_6C60_6761_76EE(_____5355_4F4D, _____5339_914D_51FD_6570)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    local ids = getBuffIdsOnUnit(_____5355_4F4D)
    do
        local i = 0
        while i < #ids do
            do
                local meta = buffTableMod.buffs[ids[i + 1]]
                local ____temp_13
                if meta ~= nil then
                    ____temp_13 = meta.type
                else
                    ____temp_13 = nil
                end
                local typeName = ____temp_13
                if type(typeName) ~= "string" then
                    goto __continue59
                end
                if _____5339_914D_51FD_6570(typeName) then
                    return true
                end
            end
            ::__continue59::
            i = i + 1
        end
    end
    return false
end
local function _____5355_4F4D_62E5_6709_7EC4_5408Buff_5408_96C6(_____5355_4F4D, _____5339_914D_51FD_6570, _____539F_751FBuff_5217_8868)
    return _____5355_4F4D_62E5_6709_5339_914DBuff_6C60_6761_76EE(_____5355_4F4D, _____5339_914D_51FD_6570) or _____5355_4F4D_62E5_6709_4EFB_610FBuff_6548_679C_5408_96C6(_____5355_4F4D, _____539F_751FBuff_5217_8868)
end
local function _____6E05_9664_5355_4F4D_5339_914DBuff_6C60_6761_76EE(_____5355_4F4D, _____5339_914D_51FD_6570)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    local ids = getBuffIdsOnUnit(_____5355_4F4D)
    local removed = 0
    do
        local i = 0
        while i < #ids do
            do
                local buffID = ids[i + 1]
                local meta = buffTableMod.buffs[buffID]
                local ____temp_14
                if meta ~= nil then
                    ____temp_14 = meta.type
                else
                    ____temp_14 = nil
                end
                local typeName = ____temp_14
                if type(typeName) ~= "string" then
                    goto __continue66
                end
                if not _____5339_914D_51FD_6570(typeName) then
                    goto __continue66
                end
                if _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____5355_4F4D, buffID) then
                    removed = removed + 1
                end
            end
            ::__continue66::
            i = i + 1
        end
    end
    return removed
end
local function _____6E05_9664_5355_4F4D_7EC4_5408Buff_5408_96C6(_____5355_4F4D, _____5339_914D_51FD_6570, _____539F_751FBuff_5217_8868)
    return _____6E05_9664_5355_4F4D_5339_914DBuff_6C60_6761_76EE(_____5355_4F4D, _____5339_914D_51FD_6570) + _____6E05_9664_5355_4F4DBuff_6548_679C_5408_96C6(_____5355_4F4D, _____539F_751FBuff_5217_8868)
end
--- 施法硬直效果
-- 
-- 对应旧 JASS：
-- - udg_MFXG[0] = 'B002'
-- 
-- 说明：
-- - 这个效果单独保留，不并入“硬控制效果合集”。
-- - 是否会打断蓄力/引导，由具体技能自己决定。
____exports["单位是否处于施法硬直效果"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    return _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____65BD_6CD5_786C_76F4Buff__9B54_6CD5_6548_679C)
end
____exports["单位是否处于硬控制效果合集"] = function(_____5355_4F4D)
    return _____5355_4F4D_62E5_6709_7EC4_5408Buff_5408_96C6(_____5355_4F4D, ____Buff_8868_7C7B_578B_662F_786C_63A7_5236, _____786C_63A7_5236Buff_5408_96C6)
end
____exports["单位是否处于软控制效果合集"] = function(_____5355_4F4D)
    return _____5355_4F4D_62E5_6709_7EC4_5408Buff_5408_96C6(_____5355_4F4D, ____Buff_8868_7C7B_578B_662F_8F6F_63A7_5236, _____8F6F_63A7_5236Buff_5408_96C6)
end
____exports["单位是否处于减速效果合集"] = function(_____5355_4F4D)
    return _____5355_4F4D_62E5_6709_7EC4_5408Buff_5408_96C6(_____5355_4F4D, ____Buff_8868_7C7B_578B_662F_51CF_901F, _____51CF_901FBuff_5408_96C6)
end
--- 控制合集：硬控制 + 软控制。
____exports["单位是否处于控制效果合集"] = function(_____5355_4F4D)
    return _____5355_4F4D_62E5_6709_7EC4_5408Buff_5408_96C6(_____5355_4F4D, ____Buff_8868_7C7B_578B_662F_63A7_5236_6548_679C, _____539F_751F_63A7_5236Buff_5408_96C6)
end
____exports["单位是否处于负面Buff合集"] = function(_____5355_4F4D)
    return _____5355_4F4D_62E5_6709_7EC4_5408Buff_5408_96C6(_____5355_4F4D, ____Buff_8868_7C7B_578B_662F_8D1F_9762, _____539F_751F_8D1F_9762Buff_5408_96C6)
end
____exports["单位是否处于持续伤害效果合集"] = function(_____5355_4F4D)
    return _____5355_4F4D_62E5_6709_7EC4_5408Buff_5408_96C6(_____5355_4F4D, ____Buff_8868_7C7B_578B_662F_6301_7EED_4F24_5BB3, _____539F_751F_6301_7EED_4F24_5BB3Buff_5408_96C6)
end
____exports["清除单位硬控制Buff合集"] = function(_____5355_4F4D)
    return _____6E05_9664_5355_4F4D_7EC4_5408Buff_5408_96C6(_____5355_4F4D, ____Buff_8868_7C7B_578B_662F_786C_63A7_5236, _____786C_63A7_5236Buff_5408_96C6)
end
____exports["清除单位软控制Buff合集"] = function(_____5355_4F4D)
    return _____6E05_9664_5355_4F4D_7EC4_5408Buff_5408_96C6(_____5355_4F4D, ____Buff_8868_7C7B_578B_662F_8F6F_63A7_5236, _____8F6F_63A7_5236Buff_5408_96C6)
end
____exports["清除单位减速Buff合集"] = function(_____5355_4F4D)
    return _____6E05_9664_5355_4F4D_7EC4_5408Buff_5408_96C6(_____5355_4F4D, ____Buff_8868_7C7B_578B_662F_51CF_901F, _____51CF_901FBuff_5408_96C6)
end
____exports["清除单位控制Buff合集"] = function(_____5355_4F4D)
    return _____6E05_9664_5355_4F4D_7EC4_5408Buff_5408_96C6(_____5355_4F4D, ____Buff_8868_7C7B_578B_662F_63A7_5236_6548_679C, _____539F_751F_63A7_5236Buff_5408_96C6)
end
____exports["清除单位负面Buff合集"] = function(_____5355_4F4D)
    return _____6E05_9664_5355_4F4D_7EC4_5408Buff_5408_96C6(_____5355_4F4D, ____Buff_8868_7C7B_578B_662F_8D1F_9762, _____539F_751F_8D1F_9762Buff_5408_96C6)
end
____exports["清除单位持续伤害Buff合集"] = function(_____5355_4F4D)
    return _____6E05_9664_5355_4F4D_7EC4_5408Buff_5408_96C6(_____5355_4F4D, ____Buff_8868_7C7B_578B_662F_6301_7EED_4F24_5BB3, _____539F_751F_6301_7EED_4F24_5BB3Buff_5408_96C6)
end
return ____exports
