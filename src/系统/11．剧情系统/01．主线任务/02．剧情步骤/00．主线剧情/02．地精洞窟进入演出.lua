local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local ____12_FF0E_5267_60C5_7535_5F71_955C_5934 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.12．剧情电影镜头")
local _____5E94_7528_5267_60C5_7535_5F71_955C_5934 = ____12_FF0E_5267_60C5_7535_5F71_955C_5934["应用剧情电影镜头"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_0["是玩家英雄组单位"]
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local ____require_result_2 = require("lib.扩展函数.BJ函数.05A．电影函数")
local CinematicFilterGenericBJ = ____require_result_2.CinematicFilterGenericBJ
local ____require_result_3 = require("lib.扩展函数.BJ函数.07．杂项")
local SetTimeOfDay = ____require_result_3.SetTimeOfDay
local ____require_result_4 = require("lib.扩展函数.BJ函数.01．触发与事件")
local TriggerRegisterEnterRectSimple = ____require_result_4.TriggerRegisterEnterRectSimple
local ____require_result_5 = require("系统.07．地形系统.07．区域背景音乐.04．区域背景音乐运行时")
local _____5207_6362_533A_57DF_80CC_666F_97F3_4E50_8868_8FBE_5F0F = ____require_result_5["切换区域背景音乐表达式"]
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_6["创建单位并登记排泄安全"]
local ____require_result_7 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
local _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_7["立即移除单位并取消排泄登记"]
local ____require_result_8 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_8.EC_CreateEffect
local ____require_result_9 = require("lib.扩展函数.BJ函数.14．音效函数")
local PlaySoundBJ = ____require_result_9.PlaySoundBJ
local ____require_result_10 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.12．剧情电影镜头")
local _____8FDB_5165_5267_60C5_7535_5F71_6A21_5F0F = ____require_result_10["进入剧情电影模式"]
local _____9000_51FA_5267_60C5_7535_5F71_6A21_5F0F_5E76_6062_590D_955C_5934 = ____require_result_10["退出剧情电影模式并恢复镜头"]
local ____require_result_11 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_11["添加单位暂停"]
local ____require_result_12 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.13．剧情片段清理注册表")
local _____6CE8_518C_5267_60C5_7247_6BB5_6E05_7406 = ____require_result_12["注册剧情片段清理"]
local ____require_result_13 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____require_result_13["注册剧情运行时单位"]
local _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____require_result_13["读取剧情运行时单位"]
local _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____require_result_13["清理剧情运行时单位"]
local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5_5B9E_73B0
local function _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5(_____7247_6BB5ID, _____4E0A_4E0B_6587)
    if _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5_5B9E_73B0 == nil then
        local _____64AD_653E_5668_6A21_5757 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
        _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5_5B9E_73B0 = _____64AD_653E_5668_6A21_5757["播放主线剧情片段"]
    end
    return _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5_5B9E_73B0(_____7247_6BB5ID, _____4E0A_4E0B_6587)
end
local CreateTrigger = jass.CreateTrigger
local GetTriggerUnit = jass.GetTriggerUnit
local TriggerAddAction = jass.TriggerAddAction
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local KillUnit = jass.KillUnit
local IssuePointOrder = jass.IssuePointOrder
local SetUnitFacing = jass.SetUnitFacing
local Player = jass.Player
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local PauseUnit = jass.PauseUnit
local DisplayCineFilter = jass.DisplayCineFilter
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
local _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90 = "剧情系统:Boss预置"
local _____5DF2_521D_59CB_5316_8FDB_5EA602_6838_5FC3 = false
local _____5DF2_89E6_53D1_5730_7CBE_6D1E_7A9F_6F14_51FA = false
local _____5730_7CBE_6D1E_7A9F_6F14_51FA_97F3_4E50_5DF2_542F_52A8 = false
local _____5730_7CBE_6D1E_7A9F_796D_575B_6F14_51FA_5DF2_5F00_59CB = false
local _____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 = "剧情运行时.地精洞窟演出."
local _____5730_7CBE_6D1E_7A9F_955C_5934_9884_8BBE = {
    X = -25967.140625,
    Y = -13941.830078,
    ["高度偏移"] = 0,
    ["旋转角度"] = 90,
    ["攻角"] = 335,
    ["距离到目标"] = 2523.080078,
    ["滚动角度"] = 0,
    ["观察区域"] = 25,
    ["远景剪裁"] = 3800
}
local function _____6709_6548_5355_4F4D(unit)
    return unit ~= nil and unit ~= 0
end
local function _____5207_6362_5730_7CBE_6D1E_7A9F_533A_57DF_97F3_4E50(add, soundName, rectName)
    return _____5207_6362_533A_57DF_80CC_666F_97F3_4E50_8868_8FBE_5F0F((soundName .. " @ ") .. rectName, add) > 0
end
local function _____5F00_59CB_5730_7CBE_6D1E_7A9F_6F14_51FA_97F3_4E50()
    _____5730_7CBE_6D1E_7A9F_6F14_51FA_97F3_4E50_5DF2_542F_52A8 = _____5207_6362_5730_7CBE_6D1E_7A9F_533A_57DF_97F3_4E50(true, "gg_snd_JQBGM01", "gg_rct______________102")
end
local function _____505C_6B62_5730_7CBE_6D1E_7A9F_6F14_51FA_97F3_4E50()
    if not _____5730_7CBE_6D1E_7A9F_6F14_51FA_97F3_4E50_5DF2_542F_52A8 then
        return
    end
    _____5207_6362_5730_7CBE_6D1E_7A9F_533A_57DF_97F3_4E50(false, "gg_snd_JQBGM01", "gg_rct______________102")
    _____5730_7CBE_6D1E_7A9F_6F14_51FA_97F3_4E50_5DF2_542F_52A8 = false
end
local function _____7ED3_675F_5730_7CBE_6D1E_7A9F_6F14_51FA_97F3_4E50()
    _____505C_6B62_5730_7CBE_6D1E_7A9F_6F14_51FA_97F3_4E50()
    _____5207_6362_5730_7CBE_6D1E_7A9F_533A_57DF_97F3_4E50(true, "gg_snd_BGM002", "gg_rct______________025")
end
local function _____521B_5EFA_5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D(rawId, x, y, facing, key)
    local unitTypeId = __TS__Number(require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版").stringToFourCCSafe(rawId))
    if not (unitTypeId > 0) then
        return nil
    end
    local unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(PLAYER_NEUTRAL_AGGRESSIVE),
        unitTypeId,
        x,
        y,
        facing
    )
    if _____6709_6548_5355_4F4D(unit) then
        _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. key, unit)
    end
    return unit
end
local function _____79FB_9664_5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D(key)
    local unit = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. key)
    if _____6709_6548_5355_4F4D(unit) then
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(unit)
    end
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. key)
end
local function _____64AD_653E_5730_7CBE_6D1E_7A9F_4EEA_5F0F_97F3_6548()
    local soundHandle = jglobals.gg_snd_GWSY0101
    if soundHandle ~= nil and soundHandle ~= 0 then
        PlaySoundBJ(soundHandle)
    end
end
local function _____6E05_7406_5730_7CBE_6D1E_7A9F_6F14_51FA()
    DisplayCineFilter(false)
    _____505C_6B62_5730_7CBE_6D1E_7A9F_6F14_51FA_97F3_4E50()
    _____5730_7CBE_6D1E_7A9F_796D_575B_6F14_51FA_5DF2_5F00_59CB = false
    do
        local i = 1
        while i <= 8 do
            local unit = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. tostring(i))
            if _____6709_6548_5355_4F4D(unit) then
                _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(unit)
            end
            _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. tostring(i))
            i = i + 1
        end
    end
    local _____9B54_6CD5_6838_5FC3 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. "100")
    if _____6709_6548_5355_4F4D(_____9B54_6CD5_6838_5FC3) then
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(_____9B54_6CD5_6838_5FC3)
    end
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. "100")
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    if _____73A9_5BB6_82F1_96C4_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_7EC4 ~= 0 then
        local ____require_result_14 = require("lib.扩展函数.BJ函数.07．杂项")
        local ForGroupBJ = ____require_result_14.ForGroupBJ
        ForGroupBJ(
            _____73A9_5BB6_82F1_96C4_7EC4,
            function()
                local unit = jass.GetEnumUnit()
                if unit == nil or unit == 0 then
                    return
                end
                PauseUnit(unit, false)
                SetUnitInvulnerable(unit, false)
            end
        )
    end
    _____9000_51FA_5267_60C5_7535_5F71_6A21_5F0F_5E76_6062_590D_955C_5934()
end
local function ____on_5730_7CBE_6D1E_7A9F_8FDB_5165_89E6_53D1()
    if _____5DF2_89E6_53D1_5730_7CBE_6D1E_7A9F_6F14_51FA then
        return
    end
    local _____89E6_53D1_5355_4F4D = GetTriggerUnit()
    if not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____89E6_53D1_5355_4F4D) then
        return
    end
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 1 then
        return
    end
    local _____7247_6BB5ID = "jlc_goblin_cave_intro"
    if _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5(_____7247_6BB5ID, {["片段ID"] = _____7247_6BB5ID, ["触发配置名"] = "地精洞窟进入演出核心", ["触发单位"] = _____89E6_53D1_5355_4F4D}) then
        _____5DF2_89E6_53D1_5730_7CBE_6D1E_7A9F_6F14_51FA = true
    end
end
____exports["执行地精洞窟演出前置"] = function(_____53C2_6570)
    SetTimeOfDay(0)
    _____6E05_7406_5730_7CBE_6D1E_7A9F_6F14_51FA()
    _____8FDB_5165_5267_60C5_7535_5F71_6A21_5F0F()
    CinematicFilterGenericBJ(
        2,
        1,
        "ReplaceableTextures\\CameraMasks\\Black_mask.blp",
        50,
        50,
        50,
        50,
        0,
        0,
        0,
        0
    )
end
____exports["执行地精洞窟祭坛演出开始"] = function()
    if _____5730_7CBE_6D1E_7A9F_796D_575B_6F14_51FA_5DF2_5F00_59CB then
        return
    end
    _____5730_7CBE_6D1E_7A9F_796D_575B_6F14_51FA_5DF2_5F00_59CB = true
    DisplayCineFilter(false)
    _____5F00_59CB_5730_7CBE_6D1E_7A9F_6F14_51FA_97F3_4E50()
    _____521B_5EFA_5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D(
        "n009",
        -26266.8,
        -14055.6,
        45,
        "1"
    )
    _____521B_5EFA_5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D(
        "n009",
        -25716.8,
        -14086.2,
        135,
        "2"
    )
    _____521B_5EFA_5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D(
        "n008",
        -26276.1,
        -13945.2,
        45,
        "3"
    )
    _____521B_5EFA_5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D(
        "n008",
        -25713.5,
        -13958.6,
        135,
        "4"
    )
    _____521B_5EFA_5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D(
        "n01H",
        -25994.5,
        -13977.6,
        90,
        "5"
    )
    _____521B_5EFA_5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D(
        "nhef",
        -25909.9,
        -14001.3,
        90,
        "6"
    )
    _____5E94_7528_5267_60C5_7535_5F71_955C_5934(_____5730_7CBE_6D1E_7A9F_955C_5934_9884_8BBE, 0)
    local bossUnit = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D("Boss.地精巫师")
    if _____6709_6548_5355_4F4D(bossUnit) then
        SetUnitInvulnerable(bossUnit, true)
        _____6DFB_52A0_5355_4F4D_6682_505C(bossUnit, _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90)
    end
end
--- 按源 JASS 的时间顺序执行祭坛演员动作；阶段动作在跳过剧情时也会顺序消费。
____exports["执行地精洞窟演员动作"] = function(_____53C2_6570)
    local _____9636_6BB5 = __TS__Number(_____53C2_6570["阶段"]) or 0
    local bossUnit = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D("Boss.地精巫师")
    if _____9636_6BB5 == 1 then
        if _____6709_6548_5355_4F4D(bossUnit) then
            SetUnitAnimationByIndex(bossUnit, 4)
        end
        if not _____6709_6548_5355_4F4D(_____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. "100")) then
            _____521B_5EFA_5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D(
                "e00U",
                -25959.4,
                -14091,
                90,
                "100"
            )
        end
        local _____6F14_54585 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. "5")
        local _____6F14_54586 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. "6")
        if _____6709_6548_5355_4F4D(_____6F14_54585) then
            KillUnit(_____6F14_54585)
        end
        if _____6709_6548_5355_4F4D(_____6F14_54586) then
            KillUnit(_____6F14_54586)
        end
        return
    end
    if _____9636_6BB5 == 2 then
        local _____6F14_54581 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. "1")
        local _____6F14_54582 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. "2")
        if _____6709_6548_5355_4F4D(_____6F14_54581) then
            IssuePointOrder(_____6F14_54581, "move", -25909.9, -14001.3)
        end
        if _____6709_6548_5355_4F4D(_____6F14_54582) then
            IssuePointOrder(_____6F14_54582, "move", -25994.5, -13977.6)
        end
        return
    end
    if _____9636_6BB5 == 3 then
        _____79FB_9664_5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D("1")
        _____79FB_9664_5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D("2")
        _____521B_5EFA_5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D(
            "n008",
            -25909.9,
            -14001.3,
            90,
            "7"
        )
        _____521B_5EFA_5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D(
            "n008",
            -25994.5,
            -13977.6,
            90,
            "8"
        )
        EC_CreateEffect(
            "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl",
            -25959.4,
            -14091,
            0,
            270,
            2,
            1,
            2
        )
        _____64AD_653E_5730_7CBE_6D1E_7A9F_4EEA_5F0F_97F3_6548()
        return
    end
    if _____9636_6BB5 == 4 then
        local _____6F14_54583 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. "3")
        local _____6F14_54584 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. "4")
        local _____6F14_54587 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. "7")
        local _____6F14_54588 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. "8")
        if _____6709_6548_5355_4F4D(_____6F14_54583) then
            SetUnitAnimationByIndex(_____6F14_54583, 1)
        end
        if _____6709_6548_5355_4F4D(_____6F14_54584) then
            SetUnitAnimationByIndex(_____6F14_54584, 1)
        end
        if _____6709_6548_5355_4F4D(_____6F14_54587) then
            SetUnitAnimationByIndex(_____6F14_54587, 1)
        end
        if _____6709_6548_5355_4F4D(_____6F14_54588) then
            SetUnitAnimationByIndex(_____6F14_54588, 1)
        end
        if _____6709_6548_5355_4F4D(bossUnit) then
            SetUnitFacing(bossUnit, 90)
            SetUnitAnimationByIndex(bossUnit, 4)
        end
        return
    end
    if _____9636_6BB5 == 5 then
        _____64AD_653E_5730_7CBE_6D1E_7A9F_4EEA_5F0F_97F3_6548()
        local _____6F14_54583 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. "3")
        local _____6F14_54584 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. "4")
        local _____6F14_54587 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. "7")
        local _____6F14_54588 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6D1E_7A9F_4E34_65F6_5355_4F4D_952E_524D_7F00 .. "8")
        if _____6709_6548_5355_4F4D(_____6F14_54583) then
            SetUnitAnimationByIndex(_____6F14_54583, 1)
        end
        if _____6709_6548_5355_4F4D(_____6F14_54584) then
            SetUnitAnimationByIndex(_____6F14_54584, 1)
        end
        if _____6709_6548_5355_4F4D(_____6F14_54587) then
            SetUnitAnimationByIndex(_____6F14_54587, 1)
        end
        if _____6709_6548_5355_4F4D(_____6F14_54588) then
            SetUnitAnimationByIndex(_____6F14_54588, 1)
        end
        return
    end
    if _____9636_6BB5 == 6 then
        CinematicFilterGenericBJ(
            2,
            1,
            "ReplaceableTextures\\CameraMasks\\Black_mask.blp",
            50,
            50,
            50,
            50,
            0,
            0,
            0,
            0
        )
    end
end
____exports["执行地精洞窟演出收尾"] = function()
    DisplayCineFilter(false)
    _____7ED3_675F_5730_7CBE_6D1E_7A9F_6F14_51FA_97F3_4E50()
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    if _____73A9_5BB6_82F1_96C4_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_7EC4 ~= 0 then
        local ____require_result_15 = require("lib.扩展函数.BJ函数.07．杂项")
        local ForGroupBJ = ____require_result_15.ForGroupBJ
        ForGroupBJ(
            _____73A9_5BB6_82F1_96C4_7EC4,
            function()
                local unit = jass.GetEnumUnit()
                if unit == nil or unit == 0 then
                    return
                end
                SetUnitInvulnerable(unit, false)
                PauseUnit(unit, false)
            end
        )
    end
    _____9000_51FA_5267_60C5_7535_5F71_6A21_5F0F_5E76_6062_590D_955C_5934()
end
____exports["地精洞窟进入演出剧情动作注册表"] = {["JLC精灵村_地精洞窟演出前置"] = ____exports["执行地精洞窟演出前置"], ["JLC精灵村_地精洞窟祭坛演出开始"] = ____exports["执行地精洞窟祭坛演出开始"], ["JLC精灵村_地精洞窟演员动作"] = ____exports["执行地精洞窟演员动作"], ["JLC精灵村_地精洞窟演出收尾"] = ____exports["执行地精洞窟演出收尾"]}
_____6CE8_518C_5267_60C5_7247_6BB5_6E05_7406("jlc_goblin_cave_intro", _____6E05_7406_5730_7CBE_6D1E_7A9F_6F14_51FA)
____exports["初始化进度02_地精洞窟进入演出核心"] = function()
    if _____5DF2_521D_59CB_5316_8FDB_5EA602_6838_5FC3 then
        return
    end
    _____5DF2_521D_59CB_5316_8FDB_5EA602_6838_5FC3 = true
    local rect = jglobals.gg_rct______________020
    if rect == nil or rect == 0 then
        return
    end
    local trigger = CreateTrigger()
    TriggerRegisterEnterRectSimple(trigger, rect)
    TriggerAddAction(trigger, ____on_5730_7CBE_6D1E_7A9F_8FDB_5165_89E6_53D1)
end
return ____exports
