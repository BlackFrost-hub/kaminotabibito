--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
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
local YDWEAngleBetweenUnitsSafe = ____require_result_1.YDWEAngleBetweenUnitsSafe
local ____require_result_2 = require("lib.扩展函数.BJ函数.07．杂项")
local ModifyGateBJ = ____require_result_2.ModifyGateBJ
local ForGroupBJ = ____require_result_2.ForGroupBJ
local ____require_result_3 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local SetUnitLifePercentBJ = ____require_result_3.SetUnitLifePercentBJ
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_4.EC_CreateEffect
local ____require_result_5 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_5["按名字反查Boss单位ID"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_6.stringToFourCCSafe
local ____require_result_7 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑")
local _____6309_7ED3_7B97_952E_6267_884CBoss_6B7B_4EA1_7ED3_7B97 = ____require_result_7["按结算键执行Boss死亡结算"]
local ____require_result_8 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.04．死亡事件桥接")
local _____6D88_8D39_4FDD_7559_5267_60C5Boss_6B7B_4EA1_51FB_6740_8005 = ____require_result_8["消费保留剧情Boss死亡击杀者"]
local ____require_result_9 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_9["创建单位并登记排泄安全"]
local ____require_result_10 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
local _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_10["立即移除单位并取消排泄登记"]
local ____require_result_11 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.13．剧情片段清理注册表")
local _____6CE8_518C_5267_60C5_7247_6BB5_6E05_7406 = ____require_result_11["注册剧情片段清理"]
local ____require_result_12 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_12.addDelayedCallback
local removeDelayedCallback = ____require_result_12.removeDelayedCallback
local addPeriodicCallback = ____require_result_12.addPeriodicCallback
local removePeriodicCallback = ____require_result_12.removePeriodicCallback
local ____require_result_13 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____require_result_13["注册剧情运行时单位"]
local _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____require_result_13["读取剧情运行时单位"]
local _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____require_result_13["清理剧情运行时单位"]
local CreateUnit = jass.CreateUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IssuePointOrder = jass.IssuePointOrder
local Player = jass.Player
local SetUnitFacing = jass.SetUnitFacing
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local PauseUnit = jass.PauseUnit
local SetUnitPosition = jass.SetUnitPosition
local SetUnitVertexColor = jass.SetUnitVertexColor
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local bj_GATEOPERATION_OPEN = jglobals.bj_GATEOPERATION_OPEN
local _____5730_7CBE_6B7B_4EA1_6B8B_8840_5355_4F4D_952E = "主线NPC.地精巫师残血"
local _____5730_7CBE_6B7B_4EA1_795E_79D8_4EBA_5355_4F4D_952E = "剧情运行时.地精死亡神秘人"
local _____5730_7CBE_6B7B_4EA1_51FB_6740_73A9_5BB6_5355_4F4D_952E = "剧情运行时.地精死亡.击杀玩家"
local _____5DF2_521D_59CB_5316_8FDB_5EA604_6838_5FC3 = false
local _____5730_7CBE_6B7B_4EA1_6F14_51FA_4F20_9001X = 0
local _____5730_7CBE_6B7B_4EA1_6F14_51FA_4F20_9001Y = 0
local _____8840_6DB2_7279_6548_5468_671FID = 0
local _____8840_6DB2_7279_6548_6B21_6570 = 0
local _____795E_79D8_4EBA_7B2C_4E8C_9ED1_6D1E_5EF6_8FDFID = 0
local _____795E_79D8_4EBA_6DE1_51FA_542F_52A8_5EF6_8FDFID = 0
local _____795E_79D8_4EBA_6DE1_51FA_5468_671FID = 0
local _____795E_79D8_4EBA_6DE1_51FA_6B21_6570 = 0
local _____5730_7CBE_62B9_9664_7279_6548_5EF6_8FDFID = 0
local function _____6E05_7406_5730_7CBE_6B7B_4EA1_6F14_51FA_56DE_8C03()
    if _____8840_6DB2_7279_6548_5468_671FID ~= 0 then
        removePeriodicCallback(_____8840_6DB2_7279_6548_5468_671FID)
        _____8840_6DB2_7279_6548_5468_671FID = 0
    end
    if _____795E_79D8_4EBA_7B2C_4E8C_9ED1_6D1E_5EF6_8FDFID ~= 0 then
        removeDelayedCallback(_____795E_79D8_4EBA_7B2C_4E8C_9ED1_6D1E_5EF6_8FDFID)
        _____795E_79D8_4EBA_7B2C_4E8C_9ED1_6D1E_5EF6_8FDFID = 0
    end
    if _____795E_79D8_4EBA_6DE1_51FA_542F_52A8_5EF6_8FDFID ~= 0 then
        removeDelayedCallback(_____795E_79D8_4EBA_6DE1_51FA_542F_52A8_5EF6_8FDFID)
        _____795E_79D8_4EBA_6DE1_51FA_542F_52A8_5EF6_8FDFID = 0
    end
    if _____795E_79D8_4EBA_6DE1_51FA_5468_671FID ~= 0 then
        removePeriodicCallback(_____795E_79D8_4EBA_6DE1_51FA_5468_671FID)
        _____795E_79D8_4EBA_6DE1_51FA_5468_671FID = 0
    end
    if _____5730_7CBE_62B9_9664_7279_6548_5EF6_8FDFID ~= 0 then
        removeDelayedCallback(_____5730_7CBE_62B9_9664_7279_6548_5EF6_8FDFID)
        _____5730_7CBE_62B9_9664_7279_6548_5EF6_8FDFID = 0
    end
    _____8840_6DB2_7279_6548_6B21_6570 = 0
    _____795E_79D8_4EBA_6DE1_51FA_6B21_6570 = 0
end
local function ____on_5730_7CBE_6B7B_4EA1_8840_6DB2_7279_6548()
    local _____6B8B_8840_5730_7CBE = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6B7B_4EA1_6B8B_8840_5355_4F4D_952E)
    if _____6B8B_8840_5730_7CBE == nil or _____6B8B_8840_5730_7CBE == 0 then
        if _____8840_6DB2_7279_6548_5468_671FID ~= 0 then
            removePeriodicCallback(_____8840_6DB2_7279_6548_5468_671FID)
        end
        _____8840_6DB2_7279_6548_5468_671FID = 0
        return
    end
    if _____8840_6DB2_7279_6548_6B21_6570 >= 15 then
        removePeriodicCallback(_____8840_6DB2_7279_6548_5468_671FID)
        _____8840_6DB2_7279_6548_5468_671FID = 0
        return
    end
    _____8840_6DB2_7279_6548_6B21_6570 = _____8840_6DB2_7279_6548_6B21_6570 + 1
    EC_CreateEffect(
        "Objects\\Spawnmodels\\Human\\HumanBlood\\BloodElfSpellThiefBlood.mdl",
        GetUnitX(_____6B8B_8840_5730_7CBE),
        GetUnitY(_____6B8B_8840_5730_7CBE),
        0,
        270,
        1.5,
        1,
        2
    )
end
local function _____542F_52A8_5730_7CBE_6B7B_4EA1_8840_6DB2_7279_6548()
    if _____8840_6DB2_7279_6548_5468_671FID ~= 0 then
        removePeriodicCallback(_____8840_6DB2_7279_6548_5468_671FID)
    end
    _____8840_6DB2_7279_6548_6B21_6570 = 0
    _____8840_6DB2_7279_6548_5468_671FID = addPeriodicCallback(1500, ____on_5730_7CBE_6B7B_4EA1_8840_6DB2_7279_6548)
end
local function ____on_795E_79D8_4EBA_7B2C_4E8C_9ED1_6D1E()
    _____795E_79D8_4EBA_7B2C_4E8C_9ED1_6D1E_5EF6_8FDFID = 0
    local _____795E_79D8_4EBA = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6B7B_4EA1_795E_79D8_4EBA_5355_4F4D_952E)
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
end
local function ____on_795E_79D8_4EBA_6DE1_51FA()
    local _____795E_79D8_4EBA = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6B7B_4EA1_795E_79D8_4EBA_5355_4F4D_952E)
    if _____795E_79D8_4EBA == nil or _____795E_79D8_4EBA == 0 then
        if _____795E_79D8_4EBA_6DE1_51FA_5468_671FID ~= 0 then
            removePeriodicCallback(_____795E_79D8_4EBA_6DE1_51FA_5468_671FID)
        end
        _____795E_79D8_4EBA_6DE1_51FA_5468_671FID = 0
        return
    end
    if _____795E_79D8_4EBA_6DE1_51FA_6B21_6570 >= 4 then
        removePeriodicCallback(_____795E_79D8_4EBA_6DE1_51FA_5468_671FID)
        _____795E_79D8_4EBA_6DE1_51FA_5468_671FID = 0
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(_____795E_79D8_4EBA)
        _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6B7B_4EA1_795E_79D8_4EBA_5355_4F4D_952E)
        return
    end
    _____795E_79D8_4EBA_6DE1_51FA_6B21_6570 = _____795E_79D8_4EBA_6DE1_51FA_6B21_6570 + 1
    SetUnitVertexColor(
        _____795E_79D8_4EBA,
        255,
        255,
        255,
        math.max(0, 255 - _____795E_79D8_4EBA_6DE1_51FA_6B21_6570 * 64)
    )
end
local function _____542F_52A8_795E_79D8_4EBA_6DE1_51FA()
    _____795E_79D8_4EBA_6DE1_51FA_542F_52A8_5EF6_8FDFID = 0
    if _____795E_79D8_4EBA_6DE1_51FA_5468_671FID ~= 0 then
        removePeriodicCallback(_____795E_79D8_4EBA_6DE1_51FA_5468_671FID)
    end
    _____795E_79D8_4EBA_6DE1_51FA_6B21_6570 = 0
    _____795E_79D8_4EBA_6DE1_51FA_5468_671FID = addPeriodicCallback(1000, ____on_795E_79D8_4EBA_6DE1_51FA)
end
local function _____64AD_653E_5730_7CBE_62B9_9664_7279_6548()
    _____5730_7CBE_62B9_9664_7279_6548_5EF6_8FDFID = 0
    local _____6B8B_8840_5730_7CBE = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6B7B_4EA1_6B8B_8840_5355_4F4D_952E)
    if _____6B8B_8840_5730_7CBE == nil or _____6B8B_8840_5730_7CBE == 0 then
        return
    end
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
    local _____6B8B_8840_5730_7CBE = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
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
    PauseUnit(_____6B8B_8840_5730_7CBE, true)
    SetUnitLifePercentBJ(_____6B8B_8840_5730_7CBE, 10)
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6B7B_4EA1_6B8B_8840_5355_4F4D_952E, _____6B8B_8840_5730_7CBE)
    return _____6B8B_8840_5730_7CBE
end
local function _____521B_5EFA_5730_7CBE_6B7B_4EA1_795E_79D8_4EBA_6F14_51FA(_____6B8B_8840_5730_7CBE)
    local _____795E_79D8_4EBA_5355_4F4DID = stringToFourCCSafe("n05H")
    if not (_____795E_79D8_4EBA_5355_4F4DID > 0) then
        return nil
    end
    local _____795E_79D8_4EBA = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____795E_79D8_4EBA_5355_4F4DID,
        -26467.8,
        -13505.7,
        315
    )
    if _____795E_79D8_4EBA == nil or _____795E_79D8_4EBA == 0 then
        return nil
    end
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6B7B_4EA1_795E_79D8_4EBA_5355_4F4D_952E, _____795E_79D8_4EBA)
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
    end
    SetUnitFacing(_____795E_79D8_4EBA, 270)
    _____795E_79D8_4EBA_7B2C_4E8C_9ED1_6D1E_5EF6_8FDFID = addDelayedCallback(8000, ____on_795E_79D8_4EBA_7B2C_4E8C_9ED1_6D1E)
    _____795E_79D8_4EBA_6DE1_51FA_542F_52A8_5EF6_8FDFID = addDelayedCallback(12000, _____542F_52A8_795E_79D8_4EBA_6DE1_51FA)
    _____5730_7CBE_62B9_9664_7279_6548_5EF6_8FDFID = addDelayedCallback(20000, _____64AD_653E_5730_7CBE_62B9_9664_7279_6548)
    return _____795E_79D8_4EBA
end
local function _____6E05_7406_5730_7CBE_796D_7940_6B7B_4EA1_6F14_51FA()
    _____6E05_7406_5730_7CBE_6B7B_4EA1_6F14_51FA_56DE_8C03()
    local _____6B8B_8840_5730_7CBE = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6B7B_4EA1_6B8B_8840_5355_4F4D_952E)
    if _____6B8B_8840_5730_7CBE ~= nil and _____6B8B_8840_5730_7CBE ~= 0 then
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(_____6B8B_8840_5730_7CBE)
    end
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6B7B_4EA1_6B8B_8840_5355_4F4D_952E)
    local _____795E_79D8_4EBA = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6B7B_4EA1_795E_79D8_4EBA_5355_4F4D_952E)
    if _____795E_79D8_4EBA ~= nil and _____795E_79D8_4EBA ~= 0 then
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(_____795E_79D8_4EBA)
    end
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6B7B_4EA1_795E_79D8_4EBA_5355_4F4D_952E)
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6B7B_4EA1_51FB_6740_73A9_5BB6_5355_4F4D_952E)
end
____exports["执行地精祭祀死亡演出前置"] = function()
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
    _____542F_52A8_5730_7CBE_6B7B_4EA1_8840_6DB2_7279_6548()
    local bossUnit = YDUserDataGetSafe("string", "Boss", "地精巫师", "unit")
    local _____5DF2_7F13_5B58_51FB_6740_8005 = _____6D88_8D39_4FDD_7559_5267_60C5Boss_6B7B_4EA1_51FB_6740_8005(bossUnit)
    local ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_14 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6B7B_4EA1_51FB_6740_73A9_5BB6_5355_4F4D_952E)
    if ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_14 == nil then
        ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_14 = _____5DF2_7F13_5B58_51FB_6740_8005
    end
    local _____51FB_6740_73A9_5BB6 = ____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D_result_14
    _____6309_7ED3_7B97_952E_6267_884CBoss_6B7B_4EA1_7ED3_7B97("主线_地精祭祀", bossUnit, _____51FB_6740_73A9_5BB6)
    _____521B_5EFA_5730_7CBE_6B7B_4EA1_795E_79D8_4EBA_6F14_51FA(_____6B8B_8840_5730_7CBE)
end
____exports["地精祭祀死亡演出剧情动作注册表"] = {["JLC精灵村_地精祭祀死亡演出前置"] = ____exports["执行地精祭祀死亡演出前置"]}
_____6CE8_518C_5267_60C5_7247_6BB5_6E05_7406("jlc_goblin_boss_death", _____6E05_7406_5730_7CBE_796D_7940_6B7B_4EA1_6F14_51FA)
local function ____on_5730_7CBE_796D_7940_6B7B_4EA1(dyingUnit, killingUnit)
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
    if killingUnit ~= nil and killingUnit ~= 0 then
        _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6B7B_4EA1_51FB_6740_73A9_5BB6_5355_4F4D_952E, killingUnit)
    end
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("Boss.地精巫师")
    local _____5DF2_542F_52A8_5267_60C5 = _____5C1D_8BD5_64AD_653EBoss_6B7B_4EA1_4E3B_7EBF_5267_60C5(dyingUnit)
    if not _____5DF2_542F_52A8_5267_60C5 then
        _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____5730_7CBE_6B7B_4EA1_51FB_6740_73A9_5BB6_5355_4F4D_952E)
    end
end
____exports["初始化进度04_地精祭祀死亡演出核心"] = function()
    if _____5DF2_521D_59CB_5316_8FDB_5EA604_6838_5FC3 then
        return
    end
    _____5DF2_521D_59CB_5316_8FDB_5EA604_6838_5FC3 = true
    registerDeathListener(____on_5730_7CBE_796D_7940_6B7B_4EA1)
end
return ____exports
