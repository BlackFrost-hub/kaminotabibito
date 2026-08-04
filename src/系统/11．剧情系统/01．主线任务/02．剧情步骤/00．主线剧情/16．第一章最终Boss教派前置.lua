local ____lualib = require("lualib_bundle")
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local _____6559_6D3E_73B0_573A_73A9_5BB6_82F1_96C4_7EC4, jassGlobalsCamera, YDUserDataGetSafe
local ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E = ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5["创建并冻结剧情Boss预置"]
local ____12_FF0E_5267_60C5_7535_5F71_955C_5934 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.12．剧情电影镜头")
local _____8FDB_5165_5267_60C5_7535_5F71_6A21_5F0F = ____12_FF0E_5267_60C5_7535_5F71_955C_5934["进入剧情电影模式"]
local _____9000_51FA_5267_60C5_7535_5F71_6A21_5F0F_5E76_6062_590D_955C_5934 = ____12_FF0E_5267_60C5_7535_5F71_955C_5934["退出剧情电影模式并恢复镜头"]
function _____6559_6D3E_73B0_573A_73A9_5BB6_82F1_96C4_7EC4()
    return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
end
function jassGlobalsCamera(name)
    return require("jass.globals")[name]
end
---
-- @noSelfInFile
local jass = require("jass.common")
local jassGlobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local YDWEAngleBetweenUnitsSafe = ____require_result_0.YDWEAngleBetweenUnitsSafe
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.KK扩展API.00．装饰物函数")
local DzDoodadCreate = ____require_result_2.DzDoodadCreate
local ____require_result_3 = require("lib.扩展函数.BJ函数.07．杂项")
local GetRandomDirectionDeg = ____require_result_3.GetRandomDirectionDeg
local ____require_result_4 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_4.GetPlayersAll
local ForGroupBJ = ____require_result_4.ForGroupBJ
local ____require_result_5 = require("lib.扩展函数.BJ函数.05A．电影函数")
local CinematicModeBJ = ____require_result_5.CinematicModeBJ
local ____require_result_6 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_6.StarOther_PanCameraToTimedForPlayer
local ____require_result_7 = require("系统.00．核心系统.07．联机安全工具")
local safeForForce = ____require_result_7.safeForForce
local ____require_result_8 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_8.EC_CreateEffect
local ____require_result_9 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_9["创建单位并登记排泄安全"]
local ____require_result_10 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
local _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_10["立即移除单位并取消排泄登记"]
local ____require_result_11 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.13．剧情片段清理注册表")
local _____6CE8_518C_5267_60C5_7247_6BB5_6E05_7406 = ____require_result_11["注册剧情片段清理"]
local ____require_result_12 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____require_result_12["注册剧情运行时单位"]
local _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____require_result_12["读取剧情运行时单位"]
local _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____require_result_12["清理剧情运行时单位"]
local ____require_result_13 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_13.addDelayedCallback
local removeDelayedCallback = ____require_result_13.removeDelayedCallback
local ____require_result_14 = require("lib.扩展函数.KK扩展API.00．装饰物函数")
local DzDoodadRemove = ____require_result_14.DzDoodadRemove
local ____require_result_15 = require("系统.07．地形系统.07．区域背景音乐.04．区域背景音乐运行时")
local _____5378_8F7D_533A_57DF_80CC_666F_97F3_4E50_53E5_67C4 = ____require_result_15["卸载区域背景音乐句柄"]
do
    local ____16_FF0E_7B2C_4E00_7AE0_6700_7EC8Boss_6559_6D3E_524D_7F6E = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.16．第一章最终Boss教派前置")
    ____exports["护卫试炼后回村剧情片段"] = ____16_FF0E_7B2C_4E00_7AE0_6700_7EC8Boss_6559_6D3E_524D_7F6E["护卫试炼后回村剧情片段"]
    ____exports["教派最终Boss启动剧情片段"] = ____16_FF0E_7B2C_4E00_7AE0_6700_7EC8Boss_6559_6D3E_524D_7F6E["教派最终Boss启动剧情片段"]
end
local CreateUnit = jass.CreateUnit
local Condition = jass.Condition
local DestroyGroup = jass.DestroyGroup
local FirstOfGroup = jass.FirstOfGroup
local GetFilterUnit = jass.GetFilterUnit
local GetRandomInt = jass.GetRandomInt
local GetOwningPlayer = jass.GetOwningPlayer
local Player = jass.Player
local GroupRemoveUnit = jass.GroupRemoveUnit
local GetUnitsInRectMatching = jass.GetUnitsInRectMatching
local IsPlayerInForce = jass.IsPlayerInForce
local ShowUnit = jass.ShowUnit
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local PauseUnit = jass.PauseUnit
local SetUnitAnimation = jass.SetUnitAnimation
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local IssueTargetOrder = jass.IssueTargetOrder
local CameraSetupApplyForPlayer = jass.CameraSetupApplyForPlayer
local GetEnumPlayer = jass.GetEnumPlayer
local GetEnumUnit = jass.GetEnumUnit
local GetLocalPlayer = jass.GetLocalPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetCameraFieldForPlayer = jass.SetCameraFieldForPlayer
local ResetToGameCameraForPlayer = jass.ResetToGameCameraForPlayer
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local _____6559_6D3E_73B0_573A_5355_4F4D_952E_524D_7F00 = "剧情运行时.教派袭击现场."
local _____6559_6D3E_73B0_573A_6811_6728 = {}
local _____6559_6D3E_955C_5934_5207_6362_5EF6_8FDFID = 0
local function _____6E05_7406_6559_6D3E_88AD_51FB_73B0_573A_5BF9_8C61()
    if _____6559_6D3E_955C_5934_5207_6362_5EF6_8FDFID ~= 0 then
        removeDelayedCallback(_____6559_6D3E_955C_5934_5207_6362_5EF6_8FDFID)
        _____6559_6D3E_955C_5934_5207_6362_5EF6_8FDFID = 0
    end
    do
        local i = 1
        while i <= 6 do
            local unit = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____6559_6D3E_73B0_573A_5355_4F4D_952E_524D_7F00 .. tostring(i))
            if unit ~= nil and unit ~= 0 then
                _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(unit)
            end
            _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____6559_6D3E_73B0_573A_5355_4F4D_952E_524D_7F00 .. tostring(i))
            i = i + 1
        end
    end
    do
        local i = #_____6559_6D3E_73B0_573A_6811_6728 - 1
        while i >= 0 do
            local doodad = _____6559_6D3E_73B0_573A_6811_6728[i + 1]
            if doodad ~= nil and doodad ~= 0 then
                DzDoodadRemove(doodad)
            end
            i = i - 1
        end
    end
    __TS__ArraySetLength(_____6559_6D3E_73B0_573A_6811_6728, 0)
end
local function _____6E05_7406_6559_6D3E_88AD_51FB_73B0_573A()
    _____6E05_7406_6559_6D3E_88AD_51FB_73B0_573A_5BF9_8C61()
    local _____73A9_5BB6_82F1_96C4_7EC4 = _____6559_6D3E_73B0_573A_73A9_5BB6_82F1_96C4_7EC4()
    if _____73A9_5BB6_82F1_96C4_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_7EC4 ~= 0 then
        ForGroupBJ(
            _____73A9_5BB6_82F1_96C4_7EC4,
            function()
                local unit = GetEnumUnit()
                if unit == nil or unit == 0 then
                    return
                end
                PauseUnit(unit, false)
                SetUnitInvulnerable(unit, false)
            end
        )
    end
    _____9000_51FA_5267_60C5_7535_5F71_6A21_5F0F_5E76_6062_590D_955C_5934()
    local localPlayer = GetLocalPlayer()
    SetCameraFieldForPlayer(localPlayer, jass.CAMERA_FIELD_TARGET_DISTANCE, 3000, 0)
    ResetToGameCameraForPlayer(localPlayer, 0)
end
local function _____8BFB_53D6_6559_6D3E_73B0_573A_5355_4F4D_7C7B_578B(rawId)
    return __TS__Number(require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版").stringToFourCCSafe(rawId))
end
local function _____6E05_7406_8BED_4E49_5355_4F4D(_____8868, _____952E)
    local ____require_result_16 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
    local YDUserDataGetSafe = ____require_result_16.YDUserDataGetSafe
    local ____require_result_17 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
    local YDUserDataClearTable = ____require_result_17.YDUserDataClearTable
    local unit = YDUserDataGetSafe("string", _____8868, _____952E, "unit")
    if unit ~= nil and unit ~= 0 then
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(unit)
    end
    YDUserDataClearTable("string", _____8868)
end
local function _____662F_5E94_9690_85CF_7684_6751_5185_4E2D_7ACB_5355_4F4D()
    local unit = GetFilterUnit()
    if unit == nil or unit == 0 then
        return false
    end
    local _____73A9_5BB6_7EC4 = YDUserDataGetSafe("string", "玩家", "玩家组", "force")
    return _____73A9_5BB6_7EC4 ~= nil and _____73A9_5BB6_7EC4 ~= 0 and GetOwningPlayer(unit) == Player(PLAYER_NEUTRAL_PASSIVE) and not IsPlayerInForce(
        GetOwningPlayer(unit),
        _____73A9_5BB6_7EC4
    )
end
local function _____9690_85CF_6751_5185_4E2D_7ACB_5355_4F4D()
    local _____77E9_5F62 = jassGlobals.gg_rct________________QY
    if _____77E9_5F62 == nil or _____77E9_5F62 == 0 then
        return
    end
    local _____5355_4F4D_7EC4 = GetUnitsInRectMatching(
        _____77E9_5F62,
        Condition(_____662F_5E94_9690_85CF_7684_6751_5185_4E2D_7ACB_5355_4F4D)
    )
    if _____5355_4F4D_7EC4 == nil or _____5355_4F4D_7EC4 == 0 then
        return
    end
    local unit = FirstOfGroup(_____5355_4F4D_7EC4)
    while unit ~= nil and unit ~= 0 do
        GroupRemoveUnit(_____5355_4F4D_7EC4, unit)
        ShowUnit(unit, false)
        unit = FirstOfGroup(_____5355_4F4D_7EC4)
    end
    DestroyGroup(_____5355_4F4D_7EC4)
end
____exports["执行护卫试炼后回村"] = function(_____53C2_6570)
    _____6E05_7406_6559_6D3E_88AD_51FB_73B0_573A_5BF9_8C61()
    _____6E05_7406_8BED_4E49_5355_4F4D("ZXCS", "DW")
    _____6E05_7406_8BED_4E49_5355_4F4D("ZXCS2", "DW")
    _____9690_85CF_6751_5185_4E2D_7ACB_5355_4F4D()
    local _____73A9_5BB6_82F1_96C4_7EC4 = _____6559_6D3E_73B0_573A_73A9_5BB6_82F1_96C4_7EC4()
    if _____73A9_5BB6_82F1_96C4_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_7EC4 ~= 0 then
        ForGroupBJ(
            _____73A9_5BB6_82F1_96C4_7EC4,
            function()
                local unit = GetEnumUnit()
                if unit == nil or unit == 0 then
                    return
                end
                PauseUnit(unit, true)
                SetUnitInvulnerable(unit, true)
            end
        )
    end
    _____8FDB_5165_5267_60C5_7535_5F71_6A21_5F0F()
    local _____957F_8001 = YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit")
    if _____957F_8001 ~= nil and _____957F_8001 ~= 0 then
        SetUnitPosition(
            _____957F_8001,
            __TS__Number(_____53C2_6570["族长位置X"]) or -26114.4,
            __TS__Number(_____53C2_6570["族长位置Y"]) or -28671.3
        )
        SetUnitFacing(_____957F_8001, 180)
    end
end
____exports["执行教派袭击预置"] = function()
    _____6E05_7406_6559_6D3E_88AD_51FB_73B0_573A_5BF9_8C61()
    local _____795E_79D8_4EBAID = stringToFourCCSafe("n05H")
    local _____7CBE_7075_62A4_536BID = stringToFourCCSafe("nhef")
    local _____7CBE_7075_5B88_536BID = stringToFourCCSafe("n01H")
    if not (_____795E_79D8_4EBAID > 0) or not (_____7CBE_7075_62A4_536BID > 0) or not (_____7CBE_7075_5B88_536BID > 0) then
        return
    end
    local _____73B0_573A_5355_4F4D_5217_8868 = {
        {_____795E_79D8_4EBAID, -26755.1, -28618.6, 0},
        {_____7CBE_7075_62A4_536BID, -25907.1, -28413, 178},
        {_____7CBE_7075_62A4_536BID, -25888.1, -28937.1, 185.47},
        {_____7CBE_7075_5B88_536BID, -26119.9, -28926.5, 123.7},
        {_____7CBE_7075_5B88_536BID, -25965.7, -29021.4, 180},
        {_____7CBE_7075_5B88_536BID, -26065.8, -28460.5, 180}
    }
    do
        local i = 0
        while i < #_____73B0_573A_5355_4F4D_5217_8868 do
            local _____9884_7F6E = _____73B0_573A_5355_4F4D_5217_8868[i + 1]
            local unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
                Player(PLAYER_NEUTRAL_PASSIVE),
                _____9884_7F6E[1],
                _____9884_7F6E[2],
                _____9884_7F6E[3],
                _____9884_7F6E[4]
            )
            _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(
                _____6559_6D3E_73B0_573A_5355_4F4D_952E_524D_7F00 .. tostring(i + 1),
                unit
            )
            i = i + 1
        end
    end
    local _____6811_6728_5750_6807 = {
        {-27676.5, -26406},
        {-27008.7, -26384.5},
        {-26437.1, -27038.1},
        {-27524.2, -27604.2},
        {-27404.8, -28326.7},
        {-26557.1, -28108.3},
        {-24975.3, -28808.4},
        {-25385.3, -27834.4},
        {-23911.9, -29142.2},
        {-22237.8, -28776.7},
        {-22255.9, -28312.7},
        {-24574.1, -27746.7},
        {-23911.9, -29142.2},
        {-23963.1, -27718},
        {-23632, -27698.7},
        {-25487.6, -26993.6},
        {-24839.6, -26980.8},
        {-23963.1, -27718},
        {-24464.3, -26590.1},
        {-23681.3, -26604.5},
        {-23665.1, -27128.5}
    }
    do
        local i = 0
        while i < #_____6811_6728_5750_6807 do
            local point = _____6811_6728_5750_6807[i + 1]
            _____6559_6D3E_73B0_573A_6811_6728[#_____6559_6D3E_73B0_573A_6811_6728 + 1] = DzDoodadCreate(
                stringToFourCCSafe("YOtf"),
                1,
                point[1],
                point[2],
                0,
                GetRandomDirectionDeg(),
                1
            )
            i = i + 1
        end
    end
    local _____73A9_5BB6_7EC4 = GetPlayersAll()
    local _____955C_5934A = jassGlobalsCamera("gg_cam_Camera_014_______u")
    if _____955C_5934A ~= nil and _____955C_5934A ~= 0 then
        safeForForce(
            _____73A9_5BB6_7EC4,
            function()
                local player = GetEnumPlayer()
                CameraSetupApplyForPlayer(true, _____955C_5934A, player, 0)
                StarOther_PanCameraToTimedForPlayer(player, -26236.2, -28701.7, 5)
            end
        )
    end
    if _____6559_6D3E_955C_5934_5207_6362_5EF6_8FDFID ~= 0 then
        removeDelayedCallback(_____6559_6D3E_955C_5934_5207_6362_5EF6_8FDFID)
    end
    _____6559_6D3E_955C_5934_5207_6362_5EF6_8FDFID = addDelayedCallback(
        5000,
        function()
            _____6559_6D3E_955C_5934_5207_6362_5EF6_8FDFID = 0
            local _____955C_5934B = jassGlobalsCamera("gg_cam_Camera_014")
            if _____955C_5934B == nil or _____955C_5934B == 0 then
                return
            end
            safeForForce(
                GetPlayersAll(),
                function() return CameraSetupApplyForPlayer(
                    true,
                    _____955C_5934B,
                    GetEnumPlayer(),
                    0
                ) end
            )
        end
    )
end
local function _____6267_884C_6559_6D3E_73B0_573A_73A9_5BB6_5165_573A()
    local _____795E_79D8_4EBA = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____6559_6D3E_73B0_573A_5355_4F4D_952E_524D_7F00 .. "1")
    local _____73A9_5BB6_82F1_96C4_7EC4 = _____6559_6D3E_73B0_573A_73A9_5BB6_82F1_96C4_7EC4()
    if _____795E_79D8_4EBA == nil or _____795E_79D8_4EBA == 0 or _____73A9_5BB6_82F1_96C4_7EC4 == nil or _____73A9_5BB6_82F1_96C4_7EC4 == 0 then
        return
    end
    ForGroupBJ(
        _____73A9_5BB6_82F1_96C4_7EC4,
        function()
            local unit = GetEnumUnit()
            if unit == nil or unit == 0 then
                return
            end
            SetUnitPosition(unit, -26846.7, -27820.8)
            SetUnitFacing(
                unit,
                YDWEAngleBetweenUnitsSafe(unit, _____795E_79D8_4EBA)
            )
            SetUnitAnimation(unit, "Attack")
            PauseUnit(unit, true)
        end
    )
end
local function _____6267_884C_6559_6D3E_73B0_573A_73A9_5BB6_6062_590D()
    local _____795E_79D8_4EBA = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____6559_6D3E_73B0_573A_5355_4F4D_952E_524D_7F00 .. "1")
    local _____73A9_5BB6_82F1_96C4_7EC4 = _____6559_6D3E_73B0_573A_73A9_5BB6_82F1_96C4_7EC4()
    if _____73A9_5BB6_82F1_96C4_7EC4 == nil or _____73A9_5BB6_82F1_96C4_7EC4 == 0 then
        return
    end
    ForGroupBJ(
        _____73A9_5BB6_82F1_96C4_7EC4,
        function()
            local unit = GetEnumUnit()
            if unit == nil or unit == 0 then
                return
            end
            PauseUnit(unit, false)
            SetUnitInvulnerable(unit, false)
            if _____795E_79D8_4EBA ~= nil and _____795E_79D8_4EBA ~= 0 then
                IssueTargetOrder(unit, "attack", _____795E_79D8_4EBA)
            end
        end
    )
    if _____795E_79D8_4EBA ~= nil and _____795E_79D8_4EBA ~= 0 then
        SetUnitFacing(_____795E_79D8_4EBA, 90)
        EC_CreateEffect(
            "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl",
            GetUnitX(_____795E_79D8_4EBA),
            GetUnitY(_____795E_79D8_4EBA),
            0,
            270,
            1.5,
            1,
            1
        )
    end
end
local function _____6267_884C_6559_6D3E_6218_6597_6536_675F()
    _____9000_51FA_5267_60C5_7535_5F71_6A21_5F0F_5E76_6062_590D_955C_5934()
    local sound = jassGlobalsCamera("gg_snd_JQBGM04")
    local rect = jassGlobalsCamera("gg_rct________________QY")
    _____5378_8F7D_533A_57DF_80CC_666F_97F3_4E50_53E5_67C4(sound, rect)
end
____exports["执行教派Boss随机姿态"] = function(_____53C2_6570)
    local roll = GetRandomInt(1, 2)
    local ____temp_20
    if roll == 1 then
        local ____53C2_6570__5251_58EB_59FF_6001Boss_540D_18 = _____53C2_6570["剑士姿态Boss名"]
        if ____53C2_6570__5251_58EB_59FF_6001Boss_540D_18 == nil then
            ____53C2_6570__5251_58EB_59FF_6001Boss_540D_18 = "教派剑士"
        end
        ____temp_20 = tostring(____53C2_6570__5251_58EB_59FF_6001Boss_540D_18)
    else
        local ____53C2_6570__5B66_8005_59FF_6001Boss_540D_19 = _____53C2_6570["学者姿态Boss名"]
        if ____53C2_6570__5B66_8005_59FF_6001Boss_540D_19 == nil then
            ____53C2_6570__5B66_8005_59FF_6001Boss_540D_19 = "教派学者"
        end
        ____temp_20 = tostring(____53C2_6570__5B66_8005_59FF_6001Boss_540D_19)
    end
    local ____boss_540D = ____temp_20
    local ____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E_22 = _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E
    local ____53C2_6570_Boss_952E_21 = _____53C2_6570["Boss键"]
    if ____53C2_6570_Boss_952E_21 == nil then
        ____53C2_6570_Boss_952E_21 = "Boss.蒙面人"
    end
    ____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E_22({
        ["Boss键"] = tostring(____53C2_6570_Boss_952E_21),
        ["Boss名"] = ____boss_540D,
        X = __TS__Number(_____53C2_6570["出生X"]) or 0,
        Y = __TS__Number(_____53C2_6570["出生Y"]) or 0,
        ["朝向"] = __TS__Number(_____53C2_6570["朝向"]) or 0,
        ["预创建后暂停"] = true,
        ["预创建后无敌"] = true
    })
end
____exports["第一章最终Boss教派前置剧情动作注册表"] = {
    ["JLC精灵村_护卫试炼后回村"] = ____exports["执行护卫试炼后回村"],
    ["JLC精灵村_教派袭击预置"] = ____exports["执行教派袭击预置"],
    ["JLC精灵村_教派Boss随机姿态"] = ____exports["执行教派Boss随机姿态"],
    ["JLC精灵村_教派玩家入场"] = _____6267_884C_6559_6D3E_73B0_573A_73A9_5BB6_5165_573A,
    ["JLC精灵村_教派玩家恢复"] = _____6267_884C_6559_6D3E_73B0_573A_73A9_5BB6_6062_590D,
    ["JLC精灵村_教派战斗收束"] = _____6267_884C_6559_6D3E_6218_6597_6536_675F
}
_____6CE8_518C_5267_60C5_7247_6BB5_6E05_7406("jlc_return_village_after_guard_duel", _____6E05_7406_6559_6D3E_88AD_51FB_73B0_573A)
return ____exports
