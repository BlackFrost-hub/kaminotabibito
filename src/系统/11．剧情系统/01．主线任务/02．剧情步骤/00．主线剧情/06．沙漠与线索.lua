local ____lualib = require("lualib_bundle")
local __TS__StringIncludes = ____lualib.__TS__StringIncludes
local __TS__StringSplit = ____lualib.__TS__StringSplit
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
do
    local ____06_FF0E_6C99_6F20_4E0E_7EBF_7D22 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.06．沙漠与线索")
    ____exports["沙漠入口调查剧情片段"] = ____06_FF0E_6C99_6F20_4E0E_7EBF_7D22["沙漠入口调查剧情片段"]
    ____exports["沙漠年轻佣兵线索剧情片段"] = ____06_FF0E_6C99_6F20_4E0E_7EBF_7D22["沙漠年轻佣兵线索剧情片段"]
    ____exports["沙漠年长者线索剧情片段"] = ____06_FF0E_6C99_6F20_4E0E_7EBF_7D22["沙漠年长者线索剧情片段"]
    ____exports["沙漠情报商人线索剧情片段"] = ____06_FF0E_6C99_6F20_4E0E_7EBF_7D22["沙漠情报商人线索剧情片段"]
end
local IssueImmediateOrder = jass.IssueImmediateOrder
local Player = jass.Player
local RemoveDestructable = jass.RemoveDestructable
local SetUnitOwner = jass.SetUnitOwner
local function _____8BFB_53D6_4E3B_7EBFNPC(_____5F15_7528)
    local _____952E_540D = __TS__StringIncludes(_____5F15_7528, ".") and (__TS__StringSplit(_____5F15_7528, ".")[2] or "") or _____5F15_7528
    if _____952E_540D == "" then
        return nil
    end
    return YDUserDataGetSafe("string", "主线NPC", _____952E_540D, "unit")
end
local function _____6267_884C_7EBF_7D22NPC_5BF9_8BDD_524D_7F6E(_____53C2_6570)
    local ____8BFB_53D6_4E3B_7EBFNPC_2 = _____8BFB_53D6_4E3B_7EBFNPC
    local ____53C2_6570_NPC_1 = _____53C2_6570.NPC
    if ____53C2_6570_NPC_1 == nil then
        ____53C2_6570_NPC_1 = ""
    end
    local npc = ____8BFB_53D6_4E3B_7EBFNPC_2(tostring(____53C2_6570_NPC_1))
    if npc ~= nil and npc ~= 0 then
        SetUnitOwner(
            npc,
            Player(6),
            true
        )
    end
    local _____89E6_53D1_5355_4F4D = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit")
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        IssueImmediateOrder(_____89E6_53D1_5355_4F4D, "stop")
    end
end
____exports["执行沙漠情报商人对话前置"] = function(_____53C2_6570)
    _____6267_884C_7EBF_7D22NPC_5BF9_8BDD_524D_7F6E(_____53C2_6570)
    local ____53C2_6570__7834_574F_7269_3 = _____53C2_6570["破坏物"]
    if ____53C2_6570__7834_574F_7269_3 == nil then
        ____53C2_6570__7834_574F_7269_3 = ""
    end
    local _____7834_574F_7269_540D = tostring(____53C2_6570__7834_574F_7269_3)
    if _____7834_574F_7269_540D == "" then
        return
    end
    local destructable = jglobals[_____7834_574F_7269_540D]
    if destructable ~= nil and destructable ~= 0 then
        RemoveDestructable(destructable)
    end
end
____exports["沙漠与线索剧情动作注册表"] = {["JLC沙漠_年轻佣兵对话前置"] = _____6267_884C_7EBF_7D22NPC_5BF9_8BDD_524D_7F6E, ["JLC沙漠_年长者对话前置"] = _____6267_884C_7EBF_7D22NPC_5BF9_8BDD_524D_7F6E, ["JLC沙漠_情报商人对话前置"] = ____exports["执行沙漠情报商人对话前置"]}
return ____exports
