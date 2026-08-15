--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____03_FF0EBoss_8840_6761UI = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.03．Boss血条UI")
local _____66F4_65B0Boss_8840_6761_5934_50CF_8D34_56FE = ____03_FF0EBoss_8840_6761UI["更新Boss血条头像贴图"]
local ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.05．Boss弱点运行状态")
local _____8BFB_53D6Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001 = ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001["读取Boss血条弱点韧性运行状态"]
local ____06_FF0EBoss_5F31_70B9_4F24_5BB3_7ED3_7B97 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.06．Boss弱点伤害结算")
local _____8C03_67E5Boss_4E0B_4E00_4E2A_672A_663E_73B0_5F31_70B9 = ____06_FF0EBoss_5F31_70B9_4F24_5BB3_7ED3_7B97["调查Boss下一个未显现弱点"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
--- 修改指定 Boss 当前血条头像。传入空字符串时恢复单位物编 Art 头像。
-- Boss 运行状态尚未建立或已经结束时返回 false。
____exports["设置Boss血条头像"] = function(____Boss_5355_4F4D, _____5934_50CF_8D34_56FE_8DEF_5F84)
    if ____Boss_5355_4F4D == nil or ____Boss_5355_4F4D == 0 or _____5934_50CF_8D34_56FE_8DEF_5F84 == nil then
        return false
    end
    local state = _____8BFB_53D6Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(GetHandleId(____Boss_5355_4F4D))
    if state == nil or state["是否已结束"] then
        return false
    end
    return _____66F4_65B0Boss_8840_6761_5934_50CF_8D34_56FE(state, _____5934_50CF_8D34_56FE_8DEF_5F84)
end
local function _____521B_5EFABoss_5F31_70B9_8C03_67E5_5931_8D25_7ED3_679C(_____539F_56E0)
    return {
        ["成功"] = false,
        ["原因"] = _____539F_56E0,
        ["弱点索引"] = -1,
        ["弱点键"] = "",
        ["当前护盾值"] = 0,
        ["是否护盾破碎中"] = false
    }
end
--- 显现指定活动 Boss 的下一个未显现弱点，并削减 1 点护盾。
-- 必须从同步游戏逻辑调用；返回结果可用于决定技能是否成功结算。
____exports["调查Boss弱点"] = function(____Boss_5355_4F4D, _____6765_6E90_5355_4F4D)
    if ____Boss_5355_4F4D == nil or ____Boss_5355_4F4D == 0 then
        return _____521B_5EFABoss_5F31_70B9_8C03_67E5_5931_8D25_7ED3_679C("单位无效")
    end
    local bossHandleId = GetHandleId(____Boss_5355_4F4D) or 0
    if bossHandleId == 0 then
        return _____521B_5EFABoss_5F31_70B9_8C03_67E5_5931_8D25_7ED3_679C("单位无效")
    end
    local state = _____8BFB_53D6Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001(bossHandleId)
    if state == nil or state["是否已结束"] then
        return _____521B_5EFABoss_5F31_70B9_8C03_67E5_5931_8D25_7ED3_679C("Boss状态不存在")
    end
    return _____8C03_67E5Boss_4E0B_4E00_4E2A_672A_663E_73B0_5F31_70B9(state, _____6765_6E90_5355_4F4D, 1)
end
return ____exports
