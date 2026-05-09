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
--- 通用函数 - 控制与 Buff 便捷入口
-- 
-- 说明：
-- - 这里只做技能侧便捷转导出，不迁移底层实现。
-- - 底层来源：
--   - `TS/lib/扩展函数/Star扩展函数/Star扩展库/03．硬直暂停系统.ts`
--   - `TS/lib/扩展函数/Star扩展函数/Star扩展库/04．快速Buff系统.ts`
-- - 下面这组“硬控制效果合集”使用固定 Buff 原始码，不再依赖 `udg_MFXG` 全局变量。
-- - 这些 Buff 命中后，通常应视为会打断蓄力、引导、持续施法。
local jass = require("jass.common")
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
end
____exports["开始硬直"] = GS_Suspend
____exports["单位是否硬直中"] = GS_IsUnitSuspending
____exports["获取单位硬直剩余时间"] = GS_LoadSuspend
____exports["调整单位硬直时间"] = GS_UnitSuspend
____exports["初始化快速Buff系统"] = SFB_Init
____exports["施加快速控制Buff"] = SFB_setBuff
____exports["施加快速减速Buff"] = SFB_setSlow
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
local function _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, BuffID)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or BuffID == nil or BuffID == 0 then
        return false
    end
    return jass.GetUnitAbilityLevel(_____5355_4F4D, BuffID) > 0
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
    return _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__7729_6655) or _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__7834_51FB_6655_7729) or _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__65F6_95F4_505C_6B62) or _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__6C89_9ED8) or _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__706B_9ED1_9ED8_8BA4_7075_9B42_71C3_70E7) or _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__786C_76F4) or _____5355_4F4D_62E5_6709Buff_6548_679C(_____5355_4F4D, _____786C_63A7_5236Buff__51B0_51BB_55B7_5410)
end
return ____exports
