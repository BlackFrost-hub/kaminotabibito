local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E = ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5["创建并冻结剧情Boss预置"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.KK扩展API.00．装饰物函数")
local DzDoodadCreate = ____require_result_2.DzDoodadCreate
local ____require_result_3 = require("lib.扩展函数.BJ函数.07．杂项")
local GetRandomDirectionDeg = ____require_result_3.GetRandomDirectionDeg
local ____require_result_4 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_4.GetPlayersAll
local ____require_result_5 = require("lib.扩展函数.BJ函数.05A．电影函数")
local CinematicModeBJ = ____require_result_5.CinematicModeBJ
do
    local ____16_FF0E_7B2C_4E00_7AE0_6700_7EC8Boss_6559_6D3E_524D_7F6E = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.16．第一章最终Boss教派前置")
    ____exports["护卫试炼后回村剧情片段"] = ____16_FF0E_7B2C_4E00_7AE0_6700_7EC8Boss_6559_6D3E_524D_7F6E["护卫试炼后回村剧情片段"]
    ____exports["教派最终Boss启动剧情片段"] = ____16_FF0E_7B2C_4E00_7AE0_6700_7EC8Boss_6559_6D3E_524D_7F6E["教派最终Boss启动剧情片段"]
end
local CreateUnit = jass.CreateUnit
local GetRandomInt = jass.GetRandomInt
local Player = jass.Player
local RemoveUnit = jass.RemoveUnit
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local function _____6E05_7406_8BED_4E49_5355_4F4D(_____8868, _____952E)
    local ____require_result_6 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
    local YDUserDataGetSafe = ____require_result_6.YDUserDataGetSafe
    local ____require_result_7 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
    local YDUserDataClearTable = ____require_result_7.YDUserDataClearTable
    local unit = YDUserDataGetSafe("string", _____8868, _____952E, "unit")
    if unit ~= nil and unit ~= 0 then
        RemoveUnit(unit)
    end
    YDUserDataClearTable("string", _____8868)
end
____exports["执行护卫试炼后回村"] = function(_____53C2_6570)
    _____6E05_7406_8BED_4E49_5355_4F4D("ZXCS", "DW")
    _____6E05_7406_8BED_4E49_5355_4F4D("ZXCS2", "DW")
    CinematicModeBJ(
        true,
        GetPlayersAll()
    )
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
    local _____795E_79D8_4EBAID = stringToFourCCSafe("n05H")
    local _____7CBE_7075_62A4_536BID = stringToFourCCSafe("nhef")
    local _____7CBE_7075_5B88_536BID = stringToFourCCSafe("n01H")
    if not (_____795E_79D8_4EBAID > 0) or not (_____7CBE_7075_62A4_536BID > 0) or not (_____7CBE_7075_5B88_536BID > 0) then
        return
    end
    CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____795E_79D8_4EBAID,
        -26755.1,
        -28618.6,
        0
    )
    CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____7CBE_7075_62A4_536BID,
        -25907.1,
        -28413,
        178
    )
    CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____7CBE_7075_62A4_536BID,
        -25888.1,
        -28937.1,
        185.47
    )
    CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____7CBE_7075_5B88_536BID,
        -26119.9,
        -28926.5,
        123.7
    )
    CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____7CBE_7075_5B88_536BID,
        -25965.7,
        -29021.4,
        180
    )
    CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____7CBE_7075_5B88_536BID,
        -26065.8,
        -28460.5,
        180
    )
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
            DzDoodadCreate(
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
end
____exports["执行教派Boss随机姿态"] = function(_____53C2_6570)
    local roll = GetRandomInt(1, 2)
    local ____temp_10
    if roll == 1 then
        local ____53C2_6570__5251_58EB_59FF_6001Boss_540D_8 = _____53C2_6570["剑士姿态Boss名"]
        if ____53C2_6570__5251_58EB_59FF_6001Boss_540D_8 == nil then
            ____53C2_6570__5251_58EB_59FF_6001Boss_540D_8 = "教派剑士"
        end
        ____temp_10 = tostring(____53C2_6570__5251_58EB_59FF_6001Boss_540D_8)
    else
        local ____53C2_6570__5B66_8005_59FF_6001Boss_540D_9 = _____53C2_6570["学者姿态Boss名"]
        if ____53C2_6570__5B66_8005_59FF_6001Boss_540D_9 == nil then
            ____53C2_6570__5B66_8005_59FF_6001Boss_540D_9 = "教派学者"
        end
        ____temp_10 = tostring(____53C2_6570__5B66_8005_59FF_6001Boss_540D_9)
    end
    local ____boss_540D = ____temp_10
    local ____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E_12 = _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E
    local ____53C2_6570_Boss_952E_11 = _____53C2_6570["Boss键"]
    if ____53C2_6570_Boss_952E_11 == nil then
        ____53C2_6570_Boss_952E_11 = "Boss.蒙面人"
    end
    ____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E_12({
        ["Boss键"] = tostring(____53C2_6570_Boss_952E_11),
        ["Boss名"] = ____boss_540D,
        X = __TS__Number(_____53C2_6570["出生X"]) or 0,
        Y = __TS__Number(_____53C2_6570["出生Y"]) or 0,
        ["朝向"] = __TS__Number(_____53C2_6570["朝向"]) or 0,
        ["预创建后暂停"] = true,
        ["预创建后无敌"] = true
    })
end
____exports["第一章最终Boss教派前置剧情动作注册表"] = {["JLC精灵村_护卫试炼后回村"] = ____exports["执行护卫试炼后回村"], ["JLC精灵村_教派袭击预置"] = ____exports["执行教派袭击预置"], ["JLC精灵村_教派Boss随机姿态"] = ____exports["执行教派Boss随机姿态"]}
return ____exports
