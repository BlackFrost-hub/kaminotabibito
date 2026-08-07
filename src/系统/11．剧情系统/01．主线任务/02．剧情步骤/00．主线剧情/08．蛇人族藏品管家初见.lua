local ____lualib = require("lualib_bundle")
local __TS__StringIncludes = ____lualib.__TS__StringIncludes
local __TS__StringSplit = ____lualib.__TS__StringSplit
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入剧情进度"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["读取剧情运行时单位"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
do
    local ____08_FF0E_86C7_4EBA_65CF_85CF_54C1_7BA1_5BB6_521D_89C1 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.08．蛇人族藏品管家初见")
    ____exports["蛇人族藏品管家初见剧情片段"] = ____08_FF0E_86C7_4EBA_65CF_85CF_54C1_7BA1_5BB6_521D_89C1["蛇人族藏品管家初见剧情片段"]
    ____exports["蛇人族藏品管家食人魔任务确认剧情片段"] = ____08_FF0E_86C7_4EBA_65CF_85CF_54C1_7BA1_5BB6_521D_89C1["蛇人族藏品管家食人魔任务确认剧情片段"]
end
local Player = jass.Player
local GetOwningPlayer = jass.GetOwningPlayer
local IssueImmediateOrder = jass.IssueImmediateOrder
local SetUnitOwner = jass.SetUnitOwner
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local _____5F85_786E_8BA4_4EFB_52A1_73A9_5BB6 = nil
local _____5F85_786E_8BA4_4EFB_52A1_89E6_53D1_5355_4F4D = nil
local _____5F85_786E_8BA4_4EFB_52A1NPC = nil
local function _____6E05_7406_98DF_4EBA_9B54_4EFB_52A1_786E_8BA4_72B6_6001()
    _____5F85_786E_8BA4_4EFB_52A1_73A9_5BB6 = nil
    _____5F85_786E_8BA4_4EFB_52A1_89E6_53D1_5355_4F4D = nil
    _____5F85_786E_8BA4_4EFB_52A1NPC = nil
end
local function ____on_62D2_7EDD_98DF_4EBA_9B54_4EFB_52A1()
    _____6E05_7406_98DF_4EBA_9B54_4EFB_52A1_786E_8BA4_72B6_6001()
end
local function ____on_63A5_53D7_98DF_4EBA_9B54_4EFB_52A1()
    local _____89E6_53D1_5355_4F4D = _____5F85_786E_8BA4_4EFB_52A1_89E6_53D1_5355_4F4D
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 9 or _____89E6_53D1_5355_4F4D == nil or _____89E6_53D1_5355_4F4D == 0 then
        _____6E05_7406_98DF_4EBA_9B54_4EFB_52A1_786E_8BA4_72B6_6001()
        return
    end
    local _____5267_60C5_64AD_653E_5668 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
    local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = _____5267_60C5_64AD_653E_5668["播放主线剧情片段"]
    _____6E05_7406_98DF_4EBA_9B54_4EFB_52A1_786E_8BA4_72B6_6001()
    local _____5DF2_542F_52A8 = _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5("jlc_snake_ogre_task_accept", {["片段ID"] = "jlc_snake_ogre_task_accept", ["触发配置名"] = "蛇人族藏品管家对话框接受食人魔任务", ["触发单位"] = _____89E6_53D1_5355_4F4D})
    if _____5DF2_542F_52A8 then
        _____5199_5165_5267_60C5_8FDB_5EA6(10)
    end
end
local function _____6253_5F00_98DF_4EBA_9B54_4EFB_52A1_786E_8BA4_5BF9_8BDD_6846()
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 9 or _____5F85_786E_8BA4_4EFB_52A1_73A9_5BB6 == nil or _____5F85_786E_8BA4_4EFB_52A1_73A9_5BB6 == 0 or _____5F85_786E_8BA4_4EFB_52A1NPC == nil or _____5F85_786E_8BA4_4EFB_52A1NPC == 0 then
        _____6E05_7406_98DF_4EBA_9B54_4EFB_52A1_786E_8BA4_72B6_6001()
        return
    end
    local ____UI_51FD_6570 = require("系统.00．核心系统.03．UI函数")
    local openNpcDialog = ____UI_51FD_6570.openNpcDialog
    local _____5DF2_6253_5F00 = openNpcDialog(nil, _____5F85_786E_8BA4_4EFB_52A1_73A9_5BB6, {lines = {}, npcUnit = _____5F85_786E_8BA4_4EFB_52A1NPC, quest = {
        title = "蛇人族藏品管家",
        text = "【狩猎沙漠食人魔】\n\n接受委托后，蛇人族会开启通往沙漠食人魔巢穴的异常裂隙。击败它并带回凭证，便可换取夜光翡翠。\n\n该目标将开启 Boss 战，请确认队伍已经做好准备。",
        acceptText = "接受任务",
        rejectText = "暂不接受",
        onAccept = ____on_63A5_53D7_98DF_4EBA_9B54_4EFB_52A1,
        onReject = ____on_62D2_7EDD_98DF_4EBA_9B54_4EFB_52A1
    }})
    if not _____5DF2_6253_5F00 then
        _____6E05_7406_98DF_4EBA_9B54_4EFB_52A1_786E_8BA4_72B6_6001()
    end
end
____exports["执行蛇人族藏品管家初见"] = function(_____53C2_6570)
    local ____53C2_6570_NPC_2 = _____53C2_6570.NPC
    if ____53C2_6570_NPC_2 == nil then
        ____53C2_6570_NPC_2 = ""
    end
    local ____npc_5F15_7528 = tostring(____53C2_6570_NPC_2)
    local _____952E_540D = __TS__StringIncludes(____npc_5F15_7528, ".") and (__TS__StringSplit(____npc_5F15_7528, ".")[2] or "") or ____npc_5F15_7528
    if _____952E_540D == "" then
        return
    end
    local ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_3 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(____npc_5F15_7528)
    if ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_3 == nil then
        ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_3 = YDUserDataGetSafe("string", "主线NPC", _____952E_540D, "unit")
    end
    local ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_3_4 = ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_3
    if ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_3_4 == nil then
        ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_3_4 = require("jass.globals")[____npc_5F15_7528]
    end
    local npc = ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_3_4
    if npc == nil or npc == 0 then
        return
    end
    local _____89E6_53D1_5355_4F4D = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit")
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        IssueImmediateOrder(_____89E6_53D1_5355_4F4D, "stop")
    end
    SetUnitOwner(
        npc,
        Player(6),
        true
    )
end
____exports["执行蛇人族藏品管家任务确认"] = function(_____53C2_6570)
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 9 then
        return
    end
    local ____53C2_6570_NPC_5 = _____53C2_6570.NPC
    if ____53C2_6570_NPC_5 == nil then
        ____53C2_6570_NPC_5 = "主线NPC.蛇人族藏品管家"
    end
    local ____npc_5F15_7528 = tostring(____53C2_6570_NPC_5)
    local _____952E_540D = __TS__StringIncludes(____npc_5F15_7528, ".") and (__TS__StringSplit(____npc_5F15_7528, ".")[2] or "") or ____npc_5F15_7528
    local ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_6 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(____npc_5F15_7528)
    if ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_6 == nil then
        ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_6 = YDUserDataGetSafe("string", "主线NPC", _____952E_540D, "unit")
    end
    local npc = ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_6
    local _____89E6_53D1_5355_4F4D = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()["触发单位"]
    if npc == nil or npc == 0 or _____89E6_53D1_5355_4F4D == nil or _____89E6_53D1_5355_4F4D == 0 then
        return
    end
    local _____73A9_5BB6 = GetOwningPlayer(_____89E6_53D1_5355_4F4D)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    _____5F85_786E_8BA4_4EFB_52A1_73A9_5BB6 = _____73A9_5BB6
    _____5F85_786E_8BA4_4EFB_52A1_89E6_53D1_5355_4F4D = _____89E6_53D1_5355_4F4D
    _____5F85_786E_8BA4_4EFB_52A1NPC = npc
    addDelayedCallback(10, _____6253_5F00_98DF_4EBA_9B54_4EFB_52A1_786E_8BA4_5BF9_8BDD_6846)
end
____exports["蛇人族藏品管家初见剧情动作注册表"] = {["SRZ蛇人族_藏品管家初见"] = ____exports["执行蛇人族藏品管家初见"], ["SRZ蛇人族_打开食人魔任务确认"] = ____exports["执行蛇人族藏品管家任务确认"]}
return ____exports
