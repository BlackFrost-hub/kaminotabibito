--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
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
local ____05_FF0EBuff_6E05_9664_51FD_6570 = require("系统.05．Buff系统.05．Buff清除函数")
local _____79FB_9664_5355_4F4D_6307_5B9A_7C7B_578BBuff = ____05_FF0EBuff_6E05_9664_51FD_6570["移除单位指定类型Buff"]
local _____79FB_9664_5355_4F4D_589E_76CABuff = ____05_FF0EBuff_6E05_9664_51FD_6570["移除单位增益Buff"]
local _____79FB_9664_5355_4F4D_8D1F_9762Buff = ____05_FF0EBuff_6E05_9664_51FD_6570["移除单位负面Buff"]
local _____6309_9A71_6563_7B49_7EA7_79FB_9664_5355_4F4DBuff = ____05_FF0EBuff_6E05_9664_51FD_6570["按驱散等级移除单位Buff"]
local _____4E00_7EA7_9A71_6563_5355_4F4DBuff = ____05_FF0EBuff_6E05_9664_51FD_6570["一级驱散单位Buff"]
local _____4E8C_7EA7_9A71_6563_5355_4F4DBuff = ____05_FF0EBuff_6E05_9664_51FD_6570["二级驱散单位Buff"]
local ____index = require("系统.04．伤害系统.03．重伤系统.index")
local _____83B7_53D6_5355_4F4D_91CD_4F24 = ____index["获取单位重伤"]
local _____65BD_52A0_91CD_4F24 = ____index["施加重伤"]
local _____79FB_9664_5355_4F4D_91CD_4F24 = ____index["移除单位重伤"]
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
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
do
    local ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
    ____exports.GS_Suspend = ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF.GS_Suspend
    ____exports.GS_IsUnitSuspending = ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF.GS_IsUnitSuspending
    ____exports.GS_LoadSuspend = ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF.GS_LoadSuspend
    ____exports.GS_UnitSuspend = ____03_FF0E_786C_76F4_6682_505C_7CFB_7EDF.GS_UnitSuspend
end
do
    local ____04_FF0E_5FEB_901FBuff_7CFB_7EDF = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
    ____exports.SFB_Init = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_Init
    ____exports.SFB_setBuff = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_setBuff
    ____exports.SFB_setSlow = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_setSlow
    ____exports["SFB_施加通用Buff"] = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF["SFB_施加通用Buff"]
end
do
    local ____05_FF0EBuff_6E05_9664_51FD_6570 = require("系统.05．Buff系统.05．Buff清除函数")
    ____exports["移除单位指定类型Buff"] = ____05_FF0EBuff_6E05_9664_51FD_6570["移除单位指定类型Buff"]
    ____exports["移除单位增益Buff"] = ____05_FF0EBuff_6E05_9664_51FD_6570["移除单位增益Buff"]
    ____exports["移除单位负面Buff"] = ____05_FF0EBuff_6E05_9664_51FD_6570["移除单位负面Buff"]
    ____exports["按驱散等级移除单位Buff"] = ____05_FF0EBuff_6E05_9664_51FD_6570["按驱散等级移除单位Buff"]
    ____exports["一级驱散单位Buff"] = ____05_FF0EBuff_6E05_9664_51FD_6570["一级驱散单位Buff"]
    ____exports["二级驱散单位Buff"] = ____05_FF0EBuff_6E05_9664_51FD_6570["二级驱散单位Buff"]
end
____exports["开始硬直"] = GS_Suspend
____exports["单位是否硬直中"] = GS_IsUnitSuspending
____exports["获取单位硬直剩余时间"] = GS_LoadSuspend
____exports["调整单位硬直时间"] = GS_UnitSuspend
____exports["初始化快速Buff系统"] = SFB_Init
____exports["施加快速Buff"] = ____SFB__65BD_52A0_901A_7528Buff
____exports["施加快速控制Buff"] = SFB_setBuff
____exports["施加快速减速Buff"] = SFB_setSlow
____exports["读取单位重伤"] = _____83B7_53D6_5355_4F4D_91CD_4F24
____exports["施加单位重伤"] = _____65BD_52A0_91CD_4F24
____exports["清除单位重伤"] = _____79FB_9664_5355_4F4D_91CD_4F24
____exports["清除单位指定类型Buff"] = _____79FB_9664_5355_4F4D_6307_5B9A_7C7B_578BBuff
____exports["清除单位增益Buff"] = _____79FB_9664_5355_4F4D_589E_76CABuff
____exports["清除单位负面Buff"] = _____79FB_9664_5355_4F4D_8D1F_9762Buff
____exports["按驱散等级清除单位Buff"] = _____6309_9A71_6563_7B49_7EA7_79FB_9664_5355_4F4DBuff
____exports["一级驱散清除单位Buff"] = _____4E00_7EA7_9A71_6563_5355_4F4DBuff
____exports["二级驱散清除单位Buff"] = _____4E8C_7EA7_9A71_6563_5355_4F4DBuff
--- 清除单位可驱散增益 Buff（只清 Buff 表 `canPurge: true` 的 `Buff:` 条目）。
____exports["清除单位可驱散增益Buff"] = function(_____5355_4F4D)
    return _____79FB_9664_5355_4F4D_589E_76CABuff(_____5355_4F4D, true)
end
--- 清除单位可驱散负面 Buff（只清 Buff 表 `canPurge: true` 的 `Debuff:` 条目）。
____exports["清除单位可驱散负面Buff"] = function(_____5355_4F4D)
    return _____79FB_9664_5355_4F4D_8D1F_9762Buff(_____5355_4F4D, true)
end
--- 清除单位控制类负面 Buff（Buff 表 type 以 `Debuff:control` 开头）。
____exports["清除单位控制类负面Buff"] = function(_____5355_4F4D, _____53EA_6E05_53EF_9A71_6563)
    if _____53EA_6E05_53EF_9A71_6563 == nil then
        _____53EA_6E05_53EF_9A71_6563 = false
    end
    return _____79FB_9664_5355_4F4D_6307_5B9A_7C7B_578BBuff(_____5355_4F4D, "Debuff:control", _____53EA_6E05_53EF_9A71_6563)
end
--- 清除单位魔法类负面 Buff（Buff 表 type 以 `Debuff:magic` 开头）。
____exports["清除单位魔法类负面Buff"] = function(_____5355_4F4D, _____53EA_6E05_53EF_9A71_6563)
    if _____53EA_6E05_53EF_9A71_6563 == nil then
        _____53EA_6E05_53EF_9A71_6563 = false
    end
    return _____79FB_9664_5355_4F4D_6307_5B9A_7C7B_578BBuff(_____5355_4F4D, "Debuff:magic", _____53EA_6E05_53EF_9A71_6563)
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
local function _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, BuffID)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or BuffID == nil or BuffID == 0 then
        return false
    end
    return GetUnitAbilityLevel(_____5355_4F4D, BuffID) > 0
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
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    return _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__7729_6655) or _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__7834_51FB_6655_7729) or _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__65F6_95F4_505C_6B62) or _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__6C89_9ED8) or _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__706B_9ED1_9ED8_8BA4_7075_9B42_71C3_70E7) or _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__786C_76F4) or _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__51B0_51BB_55B7_5410) or _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__53D8_5F62) or _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__7761_7720_4E3B_6548_679C) or _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__7761_7720_6682_505C) or _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__7761_7720_7729_6655) or _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__7EA0_7F20_6839_987B) or _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__98D3_98CE_4E3B_6548_679C) or _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__98D3_98CE_9644_52A0)
end
return ____exports
