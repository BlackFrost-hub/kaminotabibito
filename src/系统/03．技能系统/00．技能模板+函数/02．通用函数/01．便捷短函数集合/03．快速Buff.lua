--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____04_FF0E_5FEB_901FBuff_7CFB_7EDF = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
local ____SFB__589E_76CABUFF = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF["SFB_增益BUFF"]
local ____SFB__8D1F_9762BUFF = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF["SFB_负面BUFF"]
local SFB_setInnerFire = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_setInnerFire
local SFB_setBloodlust = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_setBloodlust
local SFB_setCripple = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_setCripple
local SFB_setFaerieFire = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_setFaerieFire
local SFB_setCurse = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_setCurse
local SFB_setSleep = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_setSleep
local SFB_setEntanglingRoots = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_setEntanglingRoots
local SFB_setCyclone = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_setCyclone
local SFB_setItemIllusion = ____04_FF0E_5FEB_901FBuff_7CFB_7EDF.SFB_setItemIllusion
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901FBuff = ____01_FF0E_63A7_5236_4E0EBuff["施加快速Buff"]
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____01_FF0E_63A7_5236_4E0EBuff["施加快速控制Buff"]
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____01_FF0E_63A7_5236_4E0EBuff["施加快速减速Buff"]
local _____8BFB_53D6_5355_4F4D_91CD_4F24 = ____01_FF0E_63A7_5236_4E0EBuff["读取单位重伤"]
local _____65BD_52A0_5355_4F4D_91CD_4F24 = ____01_FF0E_63A7_5236_4E0EBuff["施加单位重伤"]
local _____6E05_9664_5355_4F4D_91CD_4F24 = ____01_FF0E_63A7_5236_4E0EBuff["清除单位重伤"]
____exports["快速增益Buff"] = ____SFB__589E_76CABUFF
____exports["快速负面Buff"] = ____SFB__8D1F_9762BUFF
--- 通用快速Buff。参数顺序：来源单位 -> 目标单位 -> Buff类型 -> 持续时间
____exports["快速Buff"] = _____65BD_52A0_5FEB_901FBuff
--- 通用快速控制Buff。参数顺序：来源单位 -> 目标单位 -> 控制类型 -> 持续时间
____exports["快速控制Buff"] = _____65BD_52A0_5FEB_901F_63A7_5236Buff
--- 快速减速。参数顺序：来源单位 -> 目标单位 -> 攻速减幅 -> 移速减幅 -> 持续时间
____exports["快速减速Buff"] = _____65BD_52A0_5FEB_901F_51CF_901FBuff
--- 快速重伤。参数顺序：目标单位 -> 重伤值 -> 持续时间
____exports["快速重伤"] = _____65BD_52A0_5355_4F4D_91CD_4F24
--- 读取单位当前重伤
____exports["获取重伤"] = _____8BFB_53D6_5355_4F4D_91CD_4F24
--- 移除单位当前重伤
____exports["移除重伤"] = _____6E05_9664_5355_4F4D_91CD_4F24
____exports["快速心灵之火"] = SFB_setInnerFire
____exports["快速嗜血术"] = SFB_setBloodlust
____exports["快速残废"] = SFB_setCripple
____exports["快速精灵之火"] = SFB_setFaerieFire
____exports["快速诅咒"] = SFB_setCurse
____exports["快速睡眠"] = SFB_setSleep
____exports["快速纠缠根须"] = SFB_setEntanglingRoots
____exports["快速飓风"] = SFB_setCyclone
____exports["快速幻象物品"] = SFB_setItemIllusion
return ____exports
