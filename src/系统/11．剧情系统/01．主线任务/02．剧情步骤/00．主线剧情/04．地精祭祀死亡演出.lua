local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入剧情进度"]
local ____06_FF0EBoss_6B7B_4EA1_5267_60C5_7D22_5F15 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.06．Boss死亡剧情索引")
local _____5C1D_8BD5_64AD_653EBoss_6B7B_4EA1_4E3B_7EBF_5267_60C5 = ____06_FF0EBoss_6B7B_4EA1_5267_60C5_7D22_5F15["尝试播放Boss死亡主线剧情"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local YDUserDataClearSafe = ____require_result_1.YDUserDataClearSafe
local YDWEAngleBetweenUnitsSafe = ____require_result_1.YDWEAngleBetweenUnitsSafe
local ____require_result_2 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataClearTable = ____require_result_2.YDUserDataClearTable
local ____require_result_3 = require("lib.扩展函数.BJ函数.07．杂项")
local ModifyGateBJ = ____require_result_3.ModifyGateBJ
local ForGroupBJ = ____require_result_3.ForGroupBJ
local ____require_result_4 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local SetUnitLifePercentBJ = ____require_result_4.SetUnitLifePercentBJ
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_5.EC_CreateEffect
local ____require_result_6 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_6["按名字反查Boss单位ID"]
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local CreateUnit = jass.CreateUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IssuePointOrder = jass.IssuePointOrder
local Player = jass.Player
local SetUnitFacing = jass.SetUnitFacing
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local SetUnitPosition = jass.SetUnitPosition
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local bj_GATEOPERATION_OPEN = jglobals.bj_GATEOPERATION_OPEN
local _____5DF2_521D_59CB_5316_8FDB_5EA604_6838_5FC3 = false
local _____5730_7CBE_6B7B_4EA1_6F14_51FA_4F20_9001X = 0
local _____5730_7CBE_6B7B_4EA1_6F14_51FA_4F20_9001Y = 0
local function ____on_5730_7CBE_6B7B_4EA1_6F14_51FA_79FB_52A8_82F1_96C4()
    local unit = jass.GetEnumUnit()
    if unit == nil or unit == 0 then
        return
    end
    SetUnitPosition(unit, _____5730_7CBE_6B7B_4EA1_6F14_51FA_4F20_9001X, _____5730_7CBE_6B7B_4EA1_6F14_51FA_4F20_9001Y)
end
local function _____521B_5EFA_6B8B_8840_5730_7CBE_5DEB_5E08()
    local bossRawId = _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID("地精祭祀|cffff0000（BossLV12）|r")
    local bossTypeId = stringToFourCCSafe(bossRawId)
    if not (bossTypeId > 0) then
        return nil
    end
    local _____6B8B_8840_5730_7CBE = CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        bossTypeId,
        -25996.8,
        -13787.8,
        270
    )
    if _____6B8B_8840_5730_7CBE == nil or _____6B8B_8840_5730_7CBE == 0 then
        return nil
    end
    SetUnitInvulnerable(_____6B8B_8840_5730_7CBE, true)
    SetUnitLifePercentBJ(_____6B8B_8840_5730_7CBE, 10)
    return _____6B8B_8840_5730_7CBE
end
local function _____521B_5EFA_5730_7CBE_6B7B_4EA1_795E_79D8_4EBA_6F14_51FA(_____6B8B_8840_5730_7CBE)
    local _____795E_79D8_4EBA_5355_4F4DID = stringToFourCCSafe("n05H")
    if not (_____795E_79D8_4EBA_5355_4F4DID > 0) then
        return
    end
    local _____795E_79D8_4EBA = CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____795E_79D8_4EBA_5355_4F4DID,
        -26467.8,
        -13505.7,
        315
    )
    if _____795E_79D8_4EBA == nil or _____795E_79D8_4EBA == 0 then
        return
    end
    EC_CreateEffect(
        "war3mapImported\\blackhole.mdx",
        GetUnitX(_____795E_79D8_4EBA),
        GetUnitY(_____795E_79D8_4EBA),
        0,
        270,
        3,
        1,
        4
    )
    IssuePointOrder(_____795E_79D8_4EBA, "move", -26296.4, -13702.4)
    if _____6B8B_8840_5730_7CBE ~= nil and _____6B8B_8840_5730_7CBE ~= 0 then
        SetUnitFacing(
            _____795E_79D8_4EBA,
            YDWEAngleBetweenUnitsSafe(_____795E_79D8_4EBA, _____6B8B_8840_5730_7CBE)
        )
        EC_CreateEffect(
            "war3mapImported\\Eraser.mdx",
            GetUnitX(_____6B8B_8840_5730_7CBE),
            GetUnitY(_____6B8B_8840_5730_7CBE),
            0,
            270,
            2.2,
            1,
            2
        )
    end
    EC_CreateEffect(
        "war3mapImported\\blackhole.mdx",
        GetUnitX(_____795E_79D8_4EBA),
        GetUnitY(_____795E_79D8_4EBA),
        0,
        270,
        3,
        1,
        4
    )
    SetUnitFacing(_____795E_79D8_4EBA, 270)
end
____exports["执行地精祭祀死亡演出前置"] = function(_____53C2_6570)
    _____5199_5165_5267_60C5_8FDB_5EA6(__TS__Number(_____53C2_6570["设置剧情进度"]) or 4)
    local gate = jglobals.gg_dest_DTg5_9811
    if gate ~= nil and gate ~= 0 then
        ModifyGateBJ(bj_GATEOPERATION_OPEN, gate)
    end
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    if _____73A9_5BB6_82F1_96C4_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_7EC4 ~= 0 then
        _____5730_7CBE_6B7B_4EA1_6F14_51FA_4F20_9001X = -26078.9
        _____5730_7CBE_6B7B_4EA1_6F14_51FA_4F20_9001Y = -14330.5
        ForGroupBJ(_____73A9_5BB6_82F1_96C4_7EC4, ____on_5730_7CBE_6B7B_4EA1_6F14_51FA_79FB_52A8_82F1_96C4)
    end
    local _____6B8B_8840_5730_7CBE = _____521B_5EFA_6B8B_8840_5730_7CBE_5DEB_5E08()
    local bossUnit = YDUserDataGetSafe("string", "Boss", "地精巫师", "unit")
    YDUserDataClearSafe("string", "Boss", "地精巫师", "unit")
    if bossUnit ~= nil and bossUnit ~= 0 then
        YDUserDataClearTable("unit", bossUnit)
    end
    _____521B_5EFA_5730_7CBE_6B7B_4EA1_795E_79D8_4EBA_6F14_51FA(_____6B8B_8840_5730_7CBE)
end
____exports["地精祭祀死亡演出剧情动作注册表"] = {["JLC精灵村_地精祭祀死亡演出前置"] = ____exports["执行地精祭祀死亡演出前置"]}
local function ____on_5730_7CBE_796D_7940_6B7B_4EA1(dyingUnit)
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 3 then
        return
    end
    local bossUnit = YDUserDataGetSafe("string", "Boss", "地精巫师", "unit")
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    if dyingUnit ~= bossUnit then
        return
    end
    _____5C1D_8BD5_64AD_653EBoss_6B7B_4EA1_4E3B_7EBF_5267_60C5(dyingUnit)
end
____exports["初始化进度04_地精祭祀死亡演出核心"] = function()
    if _____5DF2_521D_59CB_5316_8FDB_5EA604_6838_5FC3 then
        return
    end
    _____5DF2_521D_59CB_5316_8FDB_5EA604_6838_5FC3 = true
    registerDeathListener(____on_5730_7CBE_796D_7940_6B7B_4EA1)
end
return ____exports
