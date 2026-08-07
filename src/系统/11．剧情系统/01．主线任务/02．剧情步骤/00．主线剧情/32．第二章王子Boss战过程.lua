--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入剧情进度"]
local ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E = ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5["创建并冻结剧情Boss预置"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local ____33A_FF0E_738B_5BAB_5BC6_5BA4_573A_666F_5355_4F4D = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.33A．王宫密室场景单位")
local _____5B9A_4F4D_5E76_767B_8BB0_738B_5BAB_5BC6_5BA4_5267_60C5_5355_4F4D = ____33A_FF0E_738B_5BAB_5BC6_5BA4_573A_666F_5355_4F4D["定位并登记王宫密室剧情单位"]
local _____738B_5BAB_5BC6_5BA4_5BF9_5CD9_955C_5934_9884_8BBE = ____33A_FF0E_738B_5BAB_5BC6_5BA4_573A_666F_5355_4F4D["王宫密室对峙镜头预设"]
local _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868 = ____33A_FF0E_738B_5BAB_5BC6_5BA4_573A_666F_5355_4F4D["王宫密室场景站位表"]
local _____64AD_653E_738B_5BAB_5BC6_5BA4_6F14_51FA_7279_6548 = ____33A_FF0E_738B_5BAB_5BC6_5BA4_573A_666F_5355_4F4D["播放王宫密室演出特效"]
local _____64AD_653E_738B_5BAB_4F20_9001_95E8_5C01_5370_7279_6548 = ____33A_FF0E_738B_5BAB_5BC6_5BA4_573A_666F_5355_4F4D["播放王宫传送门封印特效"]
local ____12_FF0E_5267_60C5_7535_5F71_955C_5934 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.12．剧情电影镜头")
local _____5E94_7528_5267_60C5_7535_5F71_955C_5934 = ____12_FF0E_5267_60C5_7535_5F71_955C_5934["应用剧情电影镜头"]
local ____require_result_0 = require("系统.07．地形系统.03．区域传送")
local _____6CE8_518C_5267_60C5_914D_7F6E_4F20_9001 = ____require_result_0["注册剧情配置传送"]
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_1["是玩家英雄组单位"]
local _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 = ____require_result_1["获取玩家英雄单位组"]
local ____require_result_2 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_2["播放主线剧情片段"]
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_3.YDUserDataSetSafe
do
    local ____32_FF0E_7B2C_4E8C_7AE0_738B_5B50Boss_6218_8FC7_7A0B = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.32．第二章王子Boss战过程")
    ____exports["第二章王子Boss战过程剧情片段"] = ____32_FF0E_7B2C_4E8C_7AE0_738B_5B50Boss_6218_8FC7_7A0B["第二章王子Boss战过程剧情片段"]
end
local _____738B_5BAB_4F20_627F_5BC6_5BA4_4F20_9001_914D_7F6EID = "jlc_elven_palace_secret_room"
local _____738B_5BAB_5BC6_5BA4_95E8_5916_5BF9_767D_6807_8BB0_8868 = "主线剧情标记"
local _____738B_5BAB_5BC6_5BA4_95E8_5916_5BF9_767D_6807_8BB0_952E = "第二章王宫密室门外对白已完成"
local _____53D6_6D88_738B_5BAB_4F20_627F_5BC6_5BA4_4F20_9001
local _____738B_5BAB_4F20_627F_5BC6_5BA4_5267_60C5_5DF2_89E6_53D1 = false
____exports["执行第二章王子Boss战前置"] = function()
    YDUserDataSetSafe(
        "string",
        _____738B_5BAB_5BC6_5BA4_95E8_5916_5BF9_767D_6807_8BB0_8868,
        _____738B_5BAB_5BC6_5BA4_95E8_5916_5BF9_767D_6807_8BB0_952E,
        "integer",
        1
    )
    local _____5DF2_6709_91CC_79D1_7279 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("Boss.里科特")
    if _____5DF2_6709_91CC_79D1_7279 ~= nil and _____5DF2_6709_91CC_79D1_7279 ~= 0 then
        return
    end
    _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E({
        ["Boss键"] = "Boss.里科特",
        ["Boss名"] = "里科特",
        X = _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["里科特密室"].X,
        Y = _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["里科特密室"].Y,
        ["朝向"] = _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["里科特密室"]["朝向"],
        ["预创建后暂停"] = true,
        ["预创建后无敌"] = true
    })
end
____exports["执行进入传承密室"] = function()
    _____5B9A_4F4D_5E76_767B_8BB0_738B_5BAB_5BC6_5BA4_5267_60C5_5355_4F4D("主线NPC.耶提尔", "主线NPC.耶提尔", _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["耶提尔密室内"])
    _____5B9A_4F4D_5E76_767B_8BB0_738B_5BAB_5BC6_5BA4_5267_60C5_5355_4F4D("主线NPC.里凡特", "主线NPC.里凡特", _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["里凡特密室内"])
end
____exports["执行里凡特开启传承密室门"] = function()
    _____64AD_653E_738B_5BAB_4F20_9001_95E8_5C01_5370_7279_6548()
    _____64AD_653E_738B_5BAB_5BC6_5BA4_6F14_51FA_7279_6548("里凡特开启传承密室门", _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["里凡特密室门外"])
end
____exports["执行玩家队伍抵达传承密室"] = function()
    _____64AD_653E_738B_5BAB_5BC6_5BA4_6F14_51FA_7279_6548("玩家队伍抵达传承密室", _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["玩家队伍密室对白"])
end
local function ____on_73A9_5BB6_961F_4F0D_8FDB_5165_4F20_627F_5BC6_5BA4(_____89E6_53D1_5355_4F4D)
    if _____738B_5BAB_4F20_627F_5BC6_5BA4_5267_60C5_5DF2_89E6_53D1 then
        return
    end
    _____738B_5BAB_4F20_627F_5BC6_5BA4_5267_60C5_5DF2_89E6_53D1 = true
    _____53D6_6D88_738B_5BAB_4F20_627F_5BC6_5BA4_4F20_9001 = nil
    _____5199_5165_5267_60C5_8FDB_5EA6(34)
    ____exports["执行进入传承密室"]()
    _____5E94_7528_5267_60C5_7535_5F71_955C_5934(_____738B_5BAB_5BC6_5BA4_5BF9_5CD9_955C_5934_9884_8BBE, 0)
    ____exports["执行玩家队伍抵达传承密室"]()
    _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5("elven_city_prince_secret_room_boss_start", {["片段ID"] = "elven_city_prince_secret_room_boss_start", ["触发配置名"] = "王宫传承密室传送入口", ["触发单位"] = _____89E6_53D1_5355_4F4D})
end
____exports["执行注册王宫传承密室传送"] = function()
    if _____738B_5BAB_4F20_627F_5BC6_5BA4_5267_60C5_5DF2_89E6_53D1 or _____53D6_6D88_738B_5BAB_4F20_627F_5BC6_5BA4_4F20_9001 ~= nil then
        return
    end
    _____53D6_6D88_738B_5BAB_4F20_627F_5BC6_5BA4_4F20_9001 = _____6CE8_518C_5267_60C5_914D_7F6E_4F20_9001(_____738B_5BAB_4F20_627F_5BC6_5BA4_4F20_9001_914D_7F6EID, {["读取玩家英雄组"] = _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4, ["允许进入单位"] = _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D, ["完成"] = ____on_73A9_5BB6_961F_4F0D_8FDB_5165_4F20_627F_5BC6_5BA4})
end
____exports["第二章王子Boss战过程剧情动作注册表"] = {
    ["JLC精灵城_第二章王子Boss战前置"] = ____exports["执行第二章王子Boss战前置"],
    ["JLC精灵城_里凡特开启传承密室门"] = ____exports["执行里凡特开启传承密室门"],
    ["JLC精灵城_进入传承密室"] = ____exports["执行进入传承密室"],
    ["JLC精灵城_玩家队伍抵达传承密室"] = ____exports["执行玩家队伍抵达传承密室"],
    ["JLC精灵城_注册王宫传承密室传送"] = ____exports["执行注册王宫传承密室传送"]
}
return ____exports
