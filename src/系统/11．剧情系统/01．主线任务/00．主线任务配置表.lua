local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__Number = ____lualib.__TS__Number
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local ____exports = {}
local ____06_FF0E_4E3B_7EBF_4EFB_52A1_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.06．主线任务配置表")
local MAIN_STORY_QUEST_CONFIGS = ____06_FF0E_4E3B_7EBF_4EFB_52A1_914D_7F6E_8868.MAIN_STORY_QUEST_CONFIGS
____exports["可直接迁移主线任务ID列表"] = {
    300001,
    300005,
    300006,
    300007,
    300008,
    300009,
    300012,
    300013,
    300017,
    300019,
    300020,
    300022,
    300023,
    300024,
    300025,
    300026,
    300027
}
local _____5F85_4E13_9898_8FC1_79FB_4E3B_7EBF_4EFB_52A1_5907_6CE8_8868 = {
    [300002] = "含 NPC/Boss 创建、触发器注册、任务奖励与多段初始化，建议拆到主线演出/Boss流程。",
    [300003] = "含黑幕、电影模式、BGM 切换，属于纯演出段，建议拆到主线演出。",
    [300004] = "含 Boss 战绑定、条件触发器、护盾/弱点/YD 字段初始化，建议拆到主线 Boss 战。",
    [300010] = "含计时器、触发器注册、单位创建与剧情奖励，建议专题迁移。",
    [300011] = "含演出切场、CreateUnit、ConditionalTriggerExecute，建议专题迁移。",
    [300014] = "含计时器与专题剧情节点，后续单独迁。",
    [300015] = "含 Boss 战专题初始化，后续单独迁。",
    [300016] = "含 BGM、CreateUnit、给物品与剧情推进混合，建议专题迁移。",
    [300018] = "含计时器与强依赖旧流程动作，建议单独迁。",
    [300021] = "含大规模演出、BGM、刷怪、删地形、奖励金币，建议拆主线演出/战斗流程。"
}
local function _____67E5_627E_65E7_4E3B_7EBF_914D_7F6E(_____6765_6E90ID)
    do
        local i = 0
        while i < #MAIN_STORY_QUEST_CONFIGS do
            local _____914D_7F6E = MAIN_STORY_QUEST_CONFIGS[i + 1]
            if _____914D_7F6E.requireID == _____6765_6E90ID then
                return _____914D_7F6E
            end
            i = i + 1
        end
    end
    return nil
end
local function _____8FFD_52A0_517C_5BB9_914D_7F6E(_____7ED3_679C, _____6765_6E90ID, _____8FC1_79FB_72B6_6001, _____8FC1_79FB_5907_6CE8)
    local _____65E7_914D_7F6E = _____67E5_627E_65E7_4E3B_7EBF_914D_7F6E(_____6765_6E90ID)
    if _____65E7_914D_7F6E == nil then
        return
    end
    _____7ED3_679C[#_____7ED3_679C + 1] = __TS__ObjectAssign({}, _____65E7_914D_7F6E, {["来源ID"] = _____6765_6E90ID, ["迁移状态"] = _____8FC1_79FB_72B6_6001, ["迁移备注"] = _____8FC1_79FB_5907_6CE8})
end
local function _____6784_5EFA_5267_60C5_4E3B_7EBF_4EFB_52A1_914D_7F6E_8868()
    local _____7ED3_679C = {}
    do
        local i = 0
        while i < #____exports["可直接迁移主线任务ID列表"] do
            _____8FFD_52A0_517C_5BB9_914D_7F6E(_____7ED3_679C, ____exports["可直接迁移主线任务ID列表"][i + 1], "可直接迁移")
            i = i + 1
        end
    end
    for _____6765_6E90IDText in pairs(_____5F85_4E13_9898_8FC1_79FB_4E3B_7EBF_4EFB_52A1_5907_6CE8_8868) do
        local _____6765_6E90ID = __TS__Number(_____6765_6E90IDText)
        _____8FFD_52A0_517C_5BB9_914D_7F6E(_____7ED3_679C, _____6765_6E90ID, "待专题迁移", _____5F85_4E13_9898_8FC1_79FB_4E3B_7EBF_4EFB_52A1_5907_6CE8_8868[_____6765_6E90ID])
    end
    return _____7ED3_679C
end
____exports["剧情主线任务配置表"] = _____6784_5EFA_5267_60C5_4E3B_7EBF_4EFB_52A1_914D_7F6E_8868()
____exports["可直接迁移剧情主线任务配置表"] = __TS__ArrayFilter(
    ____exports["剧情主线任务配置表"],
    function(____, _____914D_7F6E) return _____914D_7F6E["迁移状态"] == "可直接迁移" end
)
____exports["待专题迁移剧情主线任务配置表"] = __TS__ArrayFilter(
    ____exports["剧情主线任务配置表"],
    function(____, _____914D_7F6E) return _____914D_7F6E["迁移状态"] == "待专题迁移" end
)
return ____exports
