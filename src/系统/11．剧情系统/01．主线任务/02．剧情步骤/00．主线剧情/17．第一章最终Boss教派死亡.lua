local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
local ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.02．剧情动作桥接")
local _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F = ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5["发送剧情任务消息"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local YDWEAngleBetweenUnitsSafe = ____require_result_1.YDWEAngleBetweenUnitsSafe
local ____require_result_2 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_2.GetPlayersAll
local ForGroupBJ = ____require_result_2.ForGroupBJ
local ____require_result_3 = require("系统.07．地形系统.07．区域背景音乐.04．区域背景音乐运行时")
local _____5207_6362_533A_57DF_80CC_666F_97F3_4E50_8868_8FBE_5F0F = ____require_result_3["切换区域背景音乐表达式"]
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_4.EC_CreateEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local ____require_result_5 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local YDWETimerDestroyEffect = ____require_result_5.YDWETimerDestroyEffect
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_6["创建单位并登记排泄安全"]
local ____require_result_7 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
local _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_7["立即移除单位并取消排泄登记"]
local ____require_result_8 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.13．剧情片段清理注册表")
local _____6CE8_518C_5267_60C5_7247_6BB5_6E05_7406 = ____require_result_8["注册剧情片段清理"]
local ____require_result_9 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____require_result_9["注册剧情运行时单位"]
local _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____require_result_9["读取剧情运行时单位"]
local _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____require_result_9["清理剧情运行时单位"]
local ____require_result_10 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.12．剧情电影镜头")
local _____8FDB_5165_5267_60C5_7535_5F71_6A21_5F0F = ____require_result_10["进入剧情电影模式"]
local _____9000_51FA_5267_60C5_7535_5F71_6A21_5F0F_5E76_6062_590D_955C_5934 = ____require_result_10["退出剧情电影模式并恢复镜头"]
local _____5E94_7528_5267_60C5_7535_5F71_955C_5934 = ____require_result_10["应用剧情电影镜头"]
local ____require_result_11 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_11.addDelayedCallback
local removeDelayedCallback = ____require_result_11.removeDelayedCallback
local addPeriodicCallback = ____require_result_11.addPeriodicCallback
local removePeriodicCallback = ____require_result_11.removePeriodicCallback
local ____require_result_12 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_12["按名字反查物品ID"]
local ____require_result_13 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑")
local _____6309_7ED3_7B97_952E_6267_884CBoss_6B7B_4EA1_7ED3_7B97 = ____require_result_13["按结算键执行Boss死亡结算"]
local ____require_result_14 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.04．死亡事件桥接")
local _____6D88_8D39_4FDD_7559_5267_60C5Boss_6B7B_4EA1_51FB_6740_8005 = ____require_result_14["消费保留剧情Boss死亡击杀者"]
do
    local ____17_FF0E_7B2C_4E00_7AE0_6700_7EC8Boss_6559_6D3E_6B7B_4EA1 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.17．第一章最终Boss教派死亡")
    ____exports["教派最终Boss死亡剧情片段"] = ____17_FF0E_7B2C_4E00_7AE0_6700_7EC8Boss_6559_6D3E_6B7B_4EA1["教派最终Boss死亡剧情片段"]
end
local GetDyingUnit = jass.GetDyingUnit
local GetUnitTypeId = jass.GetUnitTypeId
local CreateItem = jass.CreateItem
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local IsUnitType = jass.IsUnitType
local IsUnitOwnedByPlayer = jass.IsUnitOwnedByPlayer
local KillUnit = jass.KillUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetRandomInt = jass.GetRandomInt
local Cos = jass.Cos
local Sin = jass.Sin
local IssuePointOrder = jass.IssuePointOrder
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local SetUnitFacing = jass.SetUnitFacing
local SetUnitAnimation = jass.SetUnitAnimation
local PauseUnit = jass.PauseUnit
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local SetUnitVertexColor = jass.SetUnitVertexColor
local GetEnumUnit = jass.GetEnumUnit
local Player = jass.Player
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local bj_DEGTORAD = jass.bj_DEGTORAD
local bj_QUESTMESSAGE_HINT = require("jass.globals").bj_QUESTMESSAGE_HINT
local bj_QUESTMESSAGE_UPDATED = require("jass.globals").bj_QUESTMESSAGE_UPDATED
local _____8499_9762_4EBA_6B7B_4EA1_73B0_573A_6B8B_5F71_952E = "剧情运行时.蒙面人死亡.残影"
local _____8499_9762_4EBA_6B7B_4EA1_51FB_6740_73A9_5BB6_952E = "剧情运行时.蒙面人死亡.击杀玩家"
local _____8499_9762_4EBA_6B7B_4EA1_73AF_5883_97F3_4E50_5EF6_8FDFID = 0
local _____8499_9762_4EBA_6B7B_4EA1_97F3_4E50_5DF2_542F_52A8 = false
local _____8499_9762_4EBA_6B7B_4EA1_6B8B_5F71_6E10_9690_5468_671FID = 0
local _____8499_9762_4EBA_6B7B_4EA1_6B8B_5F71_6E10_9690_6B21_6570 = 0
local _____8499_9762_4EBA_6B7B_4EA1_679A_4E3E_6B8B_5F71 = nil
local _____8499_9762_4EBA_6B7B_4EA1_679A_4E3E_51FB_6740_5019_9009 = nil
local _____8499_9762_4EBA_6B7B_4EA1_955C_5934_9884_8BBE = {
    X = -26699.6,
    Y = -28368.4,
    ["高度偏移"] = 0,
    ["旋转角度"] = 270,
    ["攻角"] = 320,
    ["距离到目标"] = 2800,
    ["滚动角度"] = 0,
    ["观察区域"] = 50,
    ["远景剪裁"] = 5000
}
local function _____53E5_67C4_6709_6548(unit)
    return unit ~= nil and unit ~= 0
end
local function _____5355_4F4D_5B58_6D3B(unit)
    return _____53E5_67C4_6709_6548(unit) and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____8BFB_53D6_8499_9762_4EBA_6B7B_4EA1_5355_4F4D()
    local _____4E0A_4E0B_6587_5355_4F4D = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()["触发单位"]
    if _____53E5_67C4_6709_6548(_____4E0A_4E0B_6587_5355_4F4D) then
        return _____4E0A_4E0B_6587_5355_4F4D
    end
    local _____5DF2_7ED1_5B9ABoss = YDUserDataGetSafe("string", "Boss", "蒙面人", "unit")
    if _____53E5_67C4_6709_6548(_____5DF2_7ED1_5B9ABoss) then
        return _____5DF2_7ED1_5B9ABoss
    end
    return GetDyingUnit()
end
local function _____9009_53D6_8499_9762_4EBA_6B7B_4EA1_51FB_6740_5019_9009()
    if _____8499_9762_4EBA_6B7B_4EA1_679A_4E3E_51FB_6740_5019_9009 ~= nil then
        return
    end
    local unit = GetEnumUnit()
    if _____5355_4F4D_5B58_6D3B(unit) then
        _____8499_9762_4EBA_6B7B_4EA1_679A_4E3E_51FB_6740_5019_9009 = unit
    end
end
local function _____8BFB_53D6_8499_9762_4EBA_6B7B_4EA1_51FB_6740_73A9_5BB6(____Boss_5355_4F4D)
    local _____5DF2_4FDD_7559_51FB_6740_8005 = _____6D88_8D39_4FDD_7559_5267_60C5Boss_6B7B_4EA1_51FB_6740_8005(____Boss_5355_4F4D)
    if _____5355_4F4D_5B58_6D3B(_____5DF2_4FDD_7559_51FB_6740_8005) then
        return _____5DF2_4FDD_7559_51FB_6740_8005
    end
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    if _____73A9_5BB6_82F1_96C4_7EC4 == nil or _____73A9_5BB6_82F1_96C4_7EC4 == 0 then
        return nil
    end
    _____8499_9762_4EBA_6B7B_4EA1_679A_4E3E_51FB_6740_5019_9009 = nil
    ForGroupBJ(_____73A9_5BB6_82F1_96C4_7EC4, _____9009_53D6_8499_9762_4EBA_6B7B_4EA1_51FB_6740_5019_9009)
    local _____5019_9009_82F1_96C4 = _____8499_9762_4EBA_6B7B_4EA1_679A_4E3E_51FB_6740_5019_9009
    _____8499_9762_4EBA_6B7B_4EA1_679A_4E3E_51FB_6740_5019_9009 = nil
    return _____5019_9009_82F1_96C4
end
local function _____5207_6362_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50(add, soundName, rectName)
    _____5207_6362_533A_57DF_80CC_666F_97F3_4E50_8868_8FBE_5F0F((soundName .. " @ ") .. rectName, add)
end
local function _____505C_6B62_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50()
    local rects = {
        "沙漠区域.区域1",
        "沙漠绿洲",
        "悲风山谷",
        "沙漠区域.区域3",
        "巨石峡谷",
        "奇幻湖",
        "史莱姆草原",
        "精灵森"
    }
    do
        local i = 0
        while i < #rects do
            _____5207_6362_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50(false, "gg_snd_JQBGM03", rects[i + 1])
            i = i + 1
        end
    end
end
local function _____64AD_653E_8499_9762_4EBA_6B7B_4EA1_80DC_5229_97F3_4E50()
    _____5207_6362_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50(false, "gg_snd_shengliBgm2", "精灵村")
    _____5207_6362_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50(true, "gg_snd_shengliBgm2", "精灵村")
end
local function _____6DFB_52A0_8499_9762_4EBA_6B7B_4EA1_73AF_5883_97F3_4E50()
    _____5207_6362_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50(true, "gg_snd_BGM006", "史莱姆草原")
    _____5207_6362_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50(true, "gg_snd_BGM007", "精灵森")
    _____5207_6362_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50(true, "gg_snd_BGM006", "奇幻湖")
    _____5207_6362_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50(true, "gg_snd_BGM008", "巨石峡谷")
    _____5207_6362_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50(true, "gg_snd_bgm003", "沙漠绿洲")
    local _____80CC_666F_97F3_4E50 = GetRandomInt(1, 2) == 1 and "gg_snd_BGM016" or "gg_snd_BGM017"
    _____5207_6362_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50(true, _____80CC_666F_97F3_4E50, "沙漠区域.区域1")
    _____5207_6362_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50(true, _____80CC_666F_97F3_4E50, "悲风山谷")
    _____5207_6362_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50(true, _____80CC_666F_97F3_4E50, "沙漠区域.区域3")
end
local function _____6062_590D_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50()
    _____8499_9762_4EBA_6B7B_4EA1_73AF_5883_97F3_4E50_5EF6_8FDFID = 0
    _____5207_6362_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50(false, "gg_snd_shengliBgm2", "精灵村")
    _____5207_6362_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50(false, "gg_snd_zhuchengBGM01", "精灵村")
    _____5207_6362_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50(true, "gg_snd_zhuchengBGM01", "精灵村")
end
local function _____542F_52A8_8499_9762_4EBA_6B7B_4EA1_80DC_5229_97F3_4E50()
    if _____8499_9762_4EBA_6B7B_4EA1_97F3_4E50_5DF2_542F_52A8 then
        return
    end
    _____8499_9762_4EBA_6B7B_4EA1_97F3_4E50_5DF2_542F_52A8 = true
    _____64AD_653E_8499_9762_4EBA_6B7B_4EA1_80DC_5229_97F3_4E50()
    _____6DFB_52A0_8499_9762_4EBA_6B7B_4EA1_73AF_5883_97F3_4E50()
    if _____8499_9762_4EBA_6B7B_4EA1_73AF_5883_97F3_4E50_5EF6_8FDFID ~= 0 then
        removeDelayedCallback(_____8499_9762_4EBA_6B7B_4EA1_73AF_5883_97F3_4E50_5EF6_8FDFID)
    end
    _____8499_9762_4EBA_6B7B_4EA1_73AF_5883_97F3_4E50_5EF6_8FDFID = addDelayedCallback(60000, _____6062_590D_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50)
end
local function _____6062_590D_8499_9762_4EBA_6B7B_4EA1_73A9_5BB6_63A7_5236()
    local unit = GetEnumUnit()
    if not _____53E5_67C4_6709_6548(unit) then
        return
    end
    PauseUnit(unit, false)
    SetUnitInvulnerable(unit, false)
end
local function _____6E05_7406_8499_9762_4EBA_6B7B_4EA1_73B0_573A()
    if _____8499_9762_4EBA_6B7B_4EA1_73AF_5883_97F3_4E50_5EF6_8FDFID ~= 0 then
        removeDelayedCallback(_____8499_9762_4EBA_6B7B_4EA1_73AF_5883_97F3_4E50_5EF6_8FDFID)
        _____8499_9762_4EBA_6B7B_4EA1_73AF_5883_97F3_4E50_5EF6_8FDFID = 0
        _____6062_590D_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50()
    end
    if _____8499_9762_4EBA_6B7B_4EA1_6B8B_5F71_6E10_9690_5468_671FID ~= 0 then
        removePeriodicCallback(_____8499_9762_4EBA_6B7B_4EA1_6B8B_5F71_6E10_9690_5468_671FID)
        _____8499_9762_4EBA_6B7B_4EA1_6B8B_5F71_6E10_9690_5468_671FID = 0
    end
    _____8499_9762_4EBA_6B7B_4EA1_6B8B_5F71_6E10_9690_6B21_6570 = 0
    local _____6B8B_5F71 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8499_9762_4EBA_6B7B_4EA1_73B0_573A_6B8B_5F71_952E)
    if _____6B8B_5F71 ~= nil and _____6B8B_5F71 ~= 0 then
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(_____6B8B_5F71)
    end
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8499_9762_4EBA_6B7B_4EA1_73B0_573A_6B8B_5F71_952E)
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8499_9762_4EBA_6B7B_4EA1_51FB_6740_73A9_5BB6_952E)
    _____8499_9762_4EBA_6B7B_4EA1_97F3_4E50_5DF2_542F_52A8 = false
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    if _____73A9_5BB6_82F1_96C4_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_7EC4 ~= 0 then
        ForGroupBJ(_____73A9_5BB6_82F1_96C4_7EC4, _____6062_590D_8499_9762_4EBA_6B7B_4EA1_73A9_5BB6_63A7_5236)
    end
    _____9000_51FA_5267_60C5_7535_5F71_6A21_5F0F_5E76_6062_590D_955C_5934()
end
local function _____6E05_7406_73B0_573A_4E2D_7ACB_673A_68B0_5355_4F4D()
    local group = CreateGroup()
    if group == nil or group == 0 then
        return
    end
    GroupEnumUnitsInRange(
        group,
        26498.2,
        18955.1,
        3000,
        nil
    )
    local neutralAggressive = Player(jass.PLAYER_NEUTRAL_AGGRESSIVE)
    local mechanicalType = jass.UNIT_TYPE_MECHANICAL
    local unit = FirstOfGroup(group)
    while unit ~= nil and unit ~= 0 do
        GroupRemoveUnit(group, unit)
        if IsUnitType(unit, mechanicalType) and IsUnitOwnedByPlayer(unit, neutralAggressive) then
            KillUnit(unit)
        end
        unit = FirstOfGroup(group)
    end
    DestroyGroup(group)
end
local function _____5E03_7F6E_8499_9762_4EBA_6B7B_4EA1_73B0_573A_82F1_96C4()
    local unit = GetEnumUnit()
    if not _____53E5_67C4_6709_6548(unit) or not _____53E5_67C4_6709_6548(_____8499_9762_4EBA_6B7B_4EA1_679A_4E3E_6B8B_5F71) then
        return
    end
    SetUnitX(unit, -26846.7)
    SetUnitY(unit, -27820.8)
    SetUnitFacing(
        unit,
        YDWEAngleBetweenUnitsSafe(unit, _____8499_9762_4EBA_6B7B_4EA1_679A_4E3E_6B8B_5F71)
    )
    SetUnitAnimation(unit, "Attack")
    PauseUnit(unit, true)
end
local function _____73A9_5BB6_82F1_96C4_8FDB_5165_8499_9762_4EBA_6B7B_4EA1_73B0_573A(_____6B8B_5F71)
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    if _____73A9_5BB6_82F1_96C4_7EC4 == nil or _____73A9_5BB6_82F1_96C4_7EC4 == 0 or not _____53E5_67C4_6709_6548(_____6B8B_5F71) then
        return
    end
    _____8499_9762_4EBA_6B7B_4EA1_679A_4E3E_6B8B_5F71 = _____6B8B_5F71
    ForGroupBJ(_____73A9_5BB6_82F1_96C4_7EC4, _____5E03_7F6E_8499_9762_4EBA_6B7B_4EA1_73B0_573A_82F1_96C4)
    _____8499_9762_4EBA_6B7B_4EA1_679A_4E3E_6B8B_5F71 = nil
end
local function _____91CA_653E_8499_9762_4EBA_6B7B_4EA1_73B0_573A_82F1_96C4()
    local unit = GetEnumUnit()
    if not _____53E5_67C4_6709_6548(unit) then
        return
    end
    PauseUnit(unit, false)
    local radians = GetUnitFacing(unit) * bj_DEGTORAD
    IssuePointOrder(
        unit,
        "move",
        GetUnitX(unit) + Cos(radians) * 150,
        GetUnitY(unit) + Sin(radians) * 150
    )
end
local function _____91CA_653E_8499_9762_4EBA_6B7B_4EA1_73B0_573A_73A9_5BB6()
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    if _____73A9_5BB6_82F1_96C4_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_7EC4 ~= 0 then
        ForGroupBJ(_____73A9_5BB6_82F1_96C4_7EC4, _____91CA_653E_8499_9762_4EBA_6B7B_4EA1_73B0_573A_82F1_96C4)
    end
end
local function _____66F4_65B0_8499_9762_4EBA_6B7B_4EA1_6B8B_5F71_6E10_9690()
    local _____6B8B_5F71 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8499_9762_4EBA_6B7B_4EA1_73B0_573A_6B8B_5F71_952E)
    if not _____53E5_67C4_6709_6548(_____6B8B_5F71) or _____8499_9762_4EBA_6B7B_4EA1_6B8B_5F71_6E10_9690_6B21_6570 >= 20 then
        if _____53E5_67C4_6709_6548(_____6B8B_5F71) then
            _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(_____6B8B_5F71)
        end
        _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8499_9762_4EBA_6B7B_4EA1_73B0_573A_6B8B_5F71_952E)
        if _____8499_9762_4EBA_6B7B_4EA1_6B8B_5F71_6E10_9690_5468_671FID ~= 0 then
            removePeriodicCallback(_____8499_9762_4EBA_6B7B_4EA1_6B8B_5F71_6E10_9690_5468_671FID)
        end
        _____8499_9762_4EBA_6B7B_4EA1_6B8B_5F71_6E10_9690_5468_671FID = 0
        return
    end
    _____8499_9762_4EBA_6B7B_4EA1_6B8B_5F71_6E10_9690_6B21_6570 = _____8499_9762_4EBA_6B7B_4EA1_6B8B_5F71_6E10_9690_6B21_6570 + 1
    SetUnitVertexColor(
        _____6B8B_5F71,
        255,
        255,
        255,
        255 - _____8499_9762_4EBA_6B7B_4EA1_6B8B_5F71_6E10_9690_6B21_6570 * 12.75
    )
end
____exports["执行蒙面人死亡"] = function(______53C2_6570)
    local dyingUnit = _____8BFB_53D6_8499_9762_4EBA_6B7B_4EA1_5355_4F4D()
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    local dyingTypeId = GetUnitTypeId(dyingUnit)
    if dyingTypeId ~= stringToFourCCSafe("N05N") and dyingTypeId ~= stringToFourCCSafe("N05M") then
        return
    end
    _____6E05_7406_8499_9762_4EBA_6B7B_4EA1_73B0_573A()
    _____505C_6B62_8499_9762_4EBA_6B7B_4EA1_533A_57DF_97F3_4E50()
    _____8FDB_5165_5267_60C5_7535_5F71_6A21_5F0F()
    _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F({["消息类型"] = bj_QUESTMESSAGE_HINT, ["文本"] = "|cffffff00『系统提示』：|r这段剧情无法跳过"})
    _____5E94_7528_5267_60C5_7535_5F71_955C_5934(_____8499_9762_4EBA_6B7B_4EA1_955C_5934_9884_8BBE, 0)
    _____6E05_7406_73B0_573A_4E2D_7ACB_673A_68B0_5355_4F4D()
    local _____6B8B_5F71 = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(jass.PLAYER_NEUTRAL_PASSIVE),
        stringToFourCCSafe("n05H"),
        -26755.1,
        -28618.6,
        90
    )
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8499_9762_4EBA_6B7B_4EA1_73B0_573A_6B8B_5F71_952E, _____6B8B_5F71)
    local _____51FB_6740_73A9_5BB6 = _____8BFB_53D6_8499_9762_4EBA_6B7B_4EA1_51FB_6740_73A9_5BB6(dyingUnit)
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8499_9762_4EBA_6B7B_4EA1_51FB_6740_73A9_5BB6_952E, _____51FB_6740_73A9_5BB6)
    if _____6B8B_5F71 ~= nil and _____6B8B_5F71 ~= 0 then
        EC_CreateEffect(
            "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl",
            GetUnitX(_____6B8B_5F71),
            GetUnitY(_____6B8B_5F71),
            0,
            270,
            2,
            1,
            3
        )
        local _____6B8B_5F71_6D41_8840_7279_6548 = AddSpecialEffectTarget("Objects\\Spawnmodels\\Human\\HumanBlood\\BloodElfSpellThiefBlood.mdl", _____6B8B_5F71, "origin")
        if _____6B8B_5F71_6D41_8840_7279_6548 ~= nil and _____6B8B_5F71_6D41_8840_7279_6548 ~= 0 then
            YDWETimerDestroyEffect(4, _____6B8B_5F71_6D41_8840_7279_6548)
        end
    end
    EC_CreateEffect(
        "Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl",
        -26846.7,
        -27820.8,
        0,
        270,
        1.65,
        1,
        3
    )
    _____73A9_5BB6_82F1_96C4_8FDB_5165_8499_9762_4EBA_6B7B_4EA1_73B0_573A(_____6B8B_5F71)
    _____6309_7ED3_7B97_952E_6267_884CBoss_6B7B_4EA1_7ED3_7B97("蒙面人", dyingUnit, _____51FB_6740_73A9_5BB6)
end
____exports["执行蒙面人死亡残影遁走"] = function()
    local _____6B8B_5F71 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8499_9762_4EBA_6B7B_4EA1_73B0_573A_6B8B_5F71_952E)
    if not _____53E5_67C4_6709_6548(_____6B8B_5F71) then
        return
    end
    EC_CreateEffect(
        "war3mapImported\\[AKE]war3AKE.com - 8853914802857115659031497.mdl",
        GetUnitX(_____6B8B_5F71),
        GetUnitY(_____6B8B_5F71),
        0,
        270,
        1.25,
        1,
        5
    )
    if _____8499_9762_4EBA_6B7B_4EA1_6B8B_5F71_6E10_9690_5468_671FID ~= 0 then
        removePeriodicCallback(_____8499_9762_4EBA_6B7B_4EA1_6B8B_5F71_6E10_9690_5468_671FID)
    end
    _____8499_9762_4EBA_6B7B_4EA1_6B8B_5F71_6E10_9690_6B21_6570 = 0
    _____8499_9762_4EBA_6B7B_4EA1_6B8B_5F71_6E10_9690_5468_671FID = addPeriodicCallback(250, _____66F4_65B0_8499_9762_4EBA_6B7B_4EA1_6B8B_5F71_6E10_9690)
end
____exports["执行蒙面人死亡胜利音乐"] = function()
    _____542F_52A8_8499_9762_4EBA_6B7B_4EA1_80DC_5229_97F3_4E50()
    _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F({["消息类型"] = bj_QUESTMESSAGE_UPDATED, ["文本"] = "|cffffff00『主线目标』：|r成功击退神秘蒙面人！"})
end
____exports["执行蒙面人死亡释放玩家"] = function()
    _____91CA_653E_8499_9762_4EBA_6B7B_4EA1_73B0_573A_73A9_5BB6()
end
____exports["执行蒙面人死亡关闭电影模式"] = function()
    _____9000_51FA_5267_60C5_7535_5F71_6A21_5F0F_5E76_6062_590D_955C_5934()
end
____exports["执行蒙面人死亡收尾"] = function(_____53C2_6570)
    local ____53C2_6570__56FA_5B9A_6389_843D_7269_54C1_540D_15 = _____53C2_6570["固定掉落物品名"]
    if ____53C2_6570__56FA_5B9A_6389_843D_7269_54C1_540D_15 == nil then
        ____53C2_6570__56FA_5B9A_6389_843D_7269_54C1_540D_15 = ""
    end
    local _____56FA_5B9A_6389_843D_7269_54C1_540D = tostring(____53C2_6570__56FA_5B9A_6389_843D_7269_54C1_540D_15)
    local _____56FA_5B9A_6389_843D_7269_54C1ID = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____56FA_5B9A_6389_843D_7269_54C1_540D))
    if _____56FA_5B9A_6389_843D_7269_54C1ID > 0 then
        CreateItem(
            _____56FA_5B9A_6389_843D_7269_54C1ID,
            __TS__Number(_____53C2_6570["固定掉落X"]) or 15678.8,
            __TS__Number(_____53C2_6570["固定掉落Y"]) or -29965.6
        )
    end
    local _____957F_8001 = YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit")
    if not _____53E5_67C4_6709_6548(_____957F_8001) then
        return
    end
    SetUnitX(
        _____957F_8001,
        __TS__Number(_____53C2_6570["族长新位置X"]) or 28775.2
    )
    SetUnitY(
        _____957F_8001,
        __TS__Number(_____53C2_6570["族长新位置Y"]) or -28660.2
    )
end
____exports["第一章最终Boss教派死亡剧情动作注册表"] = {
    ["SW01死亡事件_蒙面人死亡"] = ____exports["执行蒙面人死亡"],
    ["SW01死亡事件_蒙面人死亡残影遁走"] = ____exports["执行蒙面人死亡残影遁走"],
    ["SW01死亡事件_蒙面人死亡胜利音乐"] = ____exports["执行蒙面人死亡胜利音乐"],
    ["SW01死亡事件_蒙面人死亡释放玩家"] = ____exports["执行蒙面人死亡释放玩家"],
    ["SW01死亡事件_蒙面人死亡关闭电影模式"] = ____exports["执行蒙面人死亡关闭电影模式"],
    ["SW01死亡事件_蒙面人死亡收尾"] = ____exports["执行蒙面人死亡收尾"]
}
_____6CE8_518C_5267_60C5_7247_6BB5_6E05_7406("jlc_cult_final_boss_death", _____6E05_7406_8499_9762_4EBA_6B7B_4EA1_73B0_573A)
return ____exports
