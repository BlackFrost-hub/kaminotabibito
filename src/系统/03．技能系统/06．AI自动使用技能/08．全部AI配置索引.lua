local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____02_FF0EAI_914D_7F6E_5DE5_5177 = require("系统.03．技能系统.06．AI自动使用技能.02．AI配置工具")
local _____6784_5EFA_5355_4F4DAI_914D_7F6EID_7D22_5F15 = ____02_FF0EAI_914D_7F6E_5DE5_5177["构建单位AI配置ID索引"]
local _____6784_5EFA_5355_4F4DIDAI_914D_7F6E_7D22_5F15 = ____02_FF0EAI_914D_7F6E_5DE5_5177["构建单位IDAI配置索引"]
local _____6784_5EFA_5355_4F4D_540DAI_914D_7F6E_7D22_5F15 = ____02_FF0EAI_914D_7F6E_5DE5_5177["构建单位名AI配置索引"]
local ____03_FF0EBossAI_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.03．BossAI配置表")
local ____BossAI_914D_7F6E_8868 = ____03_FF0EBossAI_914D_7F6E_8868["BossAI配置表"]
local ____04_FF0E_6742_9C7CAI_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.04．杂鱼AI配置表")
local _____6742_9C7CAI_914D_7F6E_8868 = ____04_FF0E_6742_9C7CAI_914D_7F6E_8868["杂鱼AI配置表"]
local ____05_FF0E_7CBE_82F1AI_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.05．精英AI配置表")
local _____7CBE_82F1AI_914D_7F6E_8868 = ____05_FF0E_7CBE_82F1AI_914D_7F6E_8868["精英AI配置表"]
local ____06_FF0E_82F1_96C4BossAI_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.06．英雄BossAI配置表")
local _____82F1_96C4BossAI_914D_7F6E_8868 = ____06_FF0E_82F1_96C4BossAI_914D_7F6E_8868["英雄BossAI配置表"]
local ____07_FF0E_5F02_754CBossAI_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.07．异界BossAI配置表")
local _____5F02_754CBossAI_914D_7F6E_8868 = ____07_FF0E_5F02_754CBossAI_914D_7F6E_8868["异界BossAI配置表"]
local ____array_0 = __TS__SparseArrayNew(table.unpack(_____6742_9C7CAI_914D_7F6E_8868))
__TS__SparseArrayPush(
    ____array_0,
    table.unpack(_____7CBE_82F1AI_914D_7F6E_8868)
)
__TS__SparseArrayPush(
    ____array_0,
    table.unpack(____BossAI_914D_7F6E_8868)
)
__TS__SparseArrayPush(
    ____array_0,
    table.unpack(_____82F1_96C4BossAI_914D_7F6E_8868)
)
__TS__SparseArrayPush(
    ____array_0,
    table.unpack(_____5F02_754CBossAI_914D_7F6E_8868)
)
____exports["全部单位AI配置表"] = {__TS__SparseArraySpread(____array_0)}
____exports["全部单位AI配置ID索引"] = _____6784_5EFA_5355_4F4DAI_914D_7F6EID_7D22_5F15(____exports["全部单位AI配置表"])
____exports["全部单位IDAI配置索引"] = _____6784_5EFA_5355_4F4DIDAI_914D_7F6E_7D22_5F15(____exports["全部单位AI配置表"])
____exports["全部单位名AI配置索引"] = _____6784_5EFA_5355_4F4D_540DAI_914D_7F6E_7D22_5F15(____exports["全部单位AI配置表"])
return ____exports
