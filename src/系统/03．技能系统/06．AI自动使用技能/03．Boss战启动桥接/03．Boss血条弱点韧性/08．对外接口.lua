--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____03_FF0EBoss_8840_6761UI = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.03．Boss血条UI")
local _____66F4_65B0Boss_8840_6761_5934_50CF_8D34_56FE = ____03_FF0EBoss_8840_6761UI["更新Boss血条头像贴图"]
local ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.05．Boss弱点运行状态")
local _____8BFB_53D6Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001 = ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001["读取Boss血条弱点韧性运行状态"]
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
return ____exports
