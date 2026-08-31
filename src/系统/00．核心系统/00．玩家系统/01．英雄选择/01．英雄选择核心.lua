local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_82F1_96C4_9009_62E9_914D_7F6E_8868 = require("系统.00．核心系统.00．玩家系统.01．英雄选择.00．英雄选择配置表")
local _____82F1_96C4_9009_62E9_914D_7F6E_8868 = ____00_FF0E_82F1_96C4_9009_62E9_914D_7F6E_8868.default
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.07．地形系统.09．动态矩形区域注册表.index")
local _____83B7_53D6_77E9_5F62_533A_57DF = ____require_result_0["获取矩形区域"]
local centerTimer = require("系统.00．核心系统.05．中心计时器")
local selectionCenter = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心")
local bridge = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local ydSafe = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local ____require_result_1 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_1.QuestMessageBJ
local ____require_result_2 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_2.GetPlayersAll
local ____require_result_3 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local ModifyHeroSkillPoints = ____require_result_3.ModifyHeroSkillPoints
local ____require_result_4 = require("lib.扩展函数.BJ函数.04．矩形与区域")
local RectContainsUnitBJ = ____require_result_4.RectContainsUnit
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_5["创建单位并登记排泄安全"]
local ____require_result_6 = require("系统.01．单位系统.08．单位配置表.04．总单位配置表")
local _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID = ____require_result_6["按名字反查总单位ID"]
local ____require_result_7 = require("系统.03．技能系统.08．技能数据表.01．技能名反查")
local _____6309_540D_5B57_53CD_67E5_6280_80FDID = ____require_result_7["按名字反查技能ID"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_8.stringToFourCCSafe
local ____require_result_9 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_9.StarOther_PanCameraToTimedForPlayer
local GroupAddUnit = jass.GroupAddUnit
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local initPlayerHeroGetBridge = bridge.initPlayerHeroGetBridge
local directRegisterPlayerHero = bridge.directRegisterPlayerHero
local _____9ED8_8BA4_82F1_96C4_7981_7528_6280_80FD_539F_59CBID = "Ane2"
local _____9ED8_8BA4BB_5355_4F4D_539F_59CBID = "ewsp"
local _____82F1_96C4_9009_62E9_8F6E_8BE2_95F4_9694_6BEB_79D2 = 50
local function _____83B7_53D6_53E5_67C4ID(_____53E5_67C4)
    if _____53E5_67C4 == nil or _____53E5_67C4 == 0 or type(jass.GetHandleId) ~= "function" then
        return 0
    end
    return jass.GetHandleId(_____53E5_67C4)
end
local _____5F53_524D_72B6_6001 = {["是否已初始化"] = false, ["是否已关闭"] = false, ["已确认玩家数"] = 0, ["正在等待二击确认玩家数"] = 0}
local _____70B9_51FB_6B21_6570_8FC7_671F_65F6_95F4_8868 = {}
local _____70B9_51FB_6B21_6570_8F6E_8BE2ID
local _____82F1_96C4_6CE8_518C_6865_63A5_5DF2_521D_59CB_5316 = false
--- 迁移设计说明：
-- 1. 入口改为“玩家选中单位事件中心”，不再直接依赖 EVENT_PLAYER_UNIT_SELECTED 的旧触发。
-- 2. 确认英雄后，直接调用 `directRegisterPlayerHero`。
-- 3. 不再依赖 STES 的“玩家英雄注册”桥接。
-- 4. 旧 JASS 里那批 `TriggerRegisterUnitEvent` 必须保留，确认英雄后仍按配置表原生注册。
-- 5. `TriggerExecute(gg_trg__u)` 也保持原样执行，不追溯其来源。
____exports["获取英雄选择配置"] = function()
    return _____82F1_96C4_9009_62E9_914D_7F6E_8868
end
____exports["获取英雄选择状态"] = function()
    return _____5F53_524D_72B6_6001
end
local function _____83B7_53D6_65E7_89E6_53D1_5BF9_8C61(_____65E7_89E6_53D1_540D)
    return jglobals[_____65E7_89E6_53D1_540D]
end
local function _____83B7_53D6_539F_751F_5355_4F4D_4E8B_4EF6(_____4E8B_4EF6_540D)
    return jass[_____4E8B_4EF6_540D]
end
local function _____83B7_53D6_6CE8_518C_76EE_6807_5355_4F4D(_____5DF2_786E_8BA4_5355_4F4D, _____76EE_6807_5355_4F4D)
    if _____76EE_6807_5355_4F4D == "BB" then
        return _____5DF2_786E_8BA4_5355_4F4D.BB
    end
    return _____5DF2_786E_8BA4_5355_4F4D["英雄"]
end
____exports["注册英雄选择旧单位事件"] = function(_____5DF2_786E_8BA4_5355_4F4D)
    local _____5DF2_6CE8_518C_6570_91CF = 0
    local _____6CE8_518C_9879_5217_8868 = _____82F1_96C4_9009_62E9_914D_7F6E_8868["必须保留的旧单位事件注册项"]
    do
        local i = 0
        while i < #_____6CE8_518C_9879_5217_8868 do
            do
                local _____6CE8_518C_9879 = _____6CE8_518C_9879_5217_8868[i + 1]
                local _____76EE_6807_5355_4F4D = _____83B7_53D6_6CE8_518C_76EE_6807_5355_4F4D(_____5DF2_786E_8BA4_5355_4F4D, _____6CE8_518C_9879["目标单位"])
                local _____65E7_89E6_53D1 = _____83B7_53D6_65E7_89E6_53D1_5BF9_8C61(_____6CE8_518C_9879["旧触发名"])
                local _____539F_751F_4E8B_4EF6 = _____83B7_53D6_539F_751F_5355_4F4D_4E8B_4EF6(_____6CE8_518C_9879["事件名"])
                if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
                    goto __continue12
                end
                if _____65E7_89E6_53D1 == nil or _____65E7_89E6_53D1 == 0 then
                    goto __continue12
                end
                if _____539F_751F_4E8B_4EF6 == nil then
                    goto __continue12
                end
                jass.TriggerRegisterUnitEvent(_____65E7_89E6_53D1, _____76EE_6807_5355_4F4D, _____539F_751F_4E8B_4EF6)
                _____5DF2_6CE8_518C_6570_91CF = _____5DF2_6CE8_518C_6570_91CF + 1
            end
            ::__continue12::
            i = i + 1
        end
    end
    return _____5DF2_6CE8_518C_6570_91CF
end
local function _____5F53_524D_6E38_620F_6BEB_79D2()
    return __TS__Number(centerTimer.getGameElapsedTime()) * 1000
end
local function _____83B7_53D6_70B9_51FB_6B21_6570(_____73A9_5BB6)
    return __TS__Number(ydSafe.YDUserDataGetSafe("player", _____73A9_5BB6, _____82F1_96C4_9009_62E9_914D_7F6E_8868["英雄点击次数键"], "real")) or 0
end
local function _____8BBE_7F6E_70B9_51FB_6B21_6570(_____73A9_5BB6, _____503C)
    ydSafe.YDUserDataSetSafe(
        "player",
        _____73A9_5BB6,
        _____82F1_96C4_9009_62E9_914D_7F6E_8868["英雄点击次数键"],
        "real",
        _____503C
    )
end
local function _____589E_52A0_70B9_51FB_6B21_6570(_____73A9_5BB6)
    local _____65B0_503C = _____83B7_53D6_70B9_51FB_6B21_6570(_____73A9_5BB6) + 1
    _____8BBE_7F6E_70B9_51FB_6B21_6570(_____73A9_5BB6, _____65B0_503C)
    return _____65B0_503C
end
local function _____51CF_5C11_70B9_51FB_6B21_6570(_____73A9_5BB6)
    local _____5F53_524D_503C = _____83B7_53D6_70B9_51FB_6B21_6570(_____73A9_5BB6)
    local _____65B0_503C = _____5F53_524D_503C > 0 and _____5F53_524D_503C - 1 or 0
    _____8BBE_7F6E_70B9_51FB_6B21_6570(_____73A9_5BB6, _____65B0_503C)
    return _____65B0_503C
end
local function _____6E05_7A7A_70B9_51FB_6B21_6570(_____73A9_5BB6)
    ydSafe.YDUserDataClearSafe("player", _____73A9_5BB6, _____82F1_96C4_9009_62E9_914D_7F6E_8868["英雄点击次数键"], "real")
end
local function _____66F4_65B0_7B49_5F85_786E_8BA4_73A9_5BB6_6570()
    local _____6570_91CF = 0
    do
        local i = 0
        while i < #_____82F1_96C4_9009_62E9_914D_7F6E_8868["可选玩家ID列表"] do
            local _____73A9_5BB6ID = _____82F1_96C4_9009_62E9_914D_7F6E_8868["可选玩家ID列表"][i + 1]
            local _____8FC7_671F_5217_8868 = _____70B9_51FB_6B21_6570_8FC7_671F_65F6_95F4_8868[_____73A9_5BB6ID]
            if _____8FC7_671F_5217_8868 ~= nil and #_____8FC7_671F_5217_8868 > 0 then
                _____6570_91CF = _____6570_91CF + 1
            end
            i = i + 1
        end
    end
    _____5F53_524D_72B6_6001["正在等待二击确认玩家数"] = _____6570_91CF
end
local function _____505C_6B62_70B9_51FB_6B21_6570_8F6E_8BE2()
    if _____70B9_51FB_6B21_6570_8F6E_8BE2ID == nil then
        return
    end
    centerTimer.removePeriodicCallback(_____70B9_51FB_6B21_6570_8F6E_8BE2ID)
    _____70B9_51FB_6B21_6570_8F6E_8BE2ID = nil
end
local function _____8F6E_8BE2_70B9_51FB_6B21_6570_8870_51CF()
    local _____73B0_5728_6BEB_79D2 = _____5F53_524D_6E38_620F_6BEB_79D2()
    local _____4ECD_6709_5F85_5904_7406_4EFB_52A1 = false
    do
        local i = 0
        while i < #_____82F1_96C4_9009_62E9_914D_7F6E_8868["可选玩家ID列表"] do
            do
                local _____73A9_5BB6ID = _____82F1_96C4_9009_62E9_914D_7F6E_8868["可选玩家ID列表"][i + 1]
                local _____8FC7_671F_5217_8868 = _____70B9_51FB_6B21_6570_8FC7_671F_65F6_95F4_8868[_____73A9_5BB6ID]
                if _____8FC7_671F_5217_8868 == nil or #_____8FC7_671F_5217_8868 <= 0 then
                    goto __continue30
                end
                while #_____8FC7_671F_5217_8868 > 0 and _____8FC7_671F_5217_8868[1] <= _____73B0_5728_6BEB_79D2 do
                    local _____8FC7_671F_65F6_95F4 = _____8FC7_671F_5217_8868[1]
                    table.remove(_____8FC7_671F_5217_8868, 1)
                    local _____8870_51CF_540E_6B21_6570 = _____51CF_5C11_70B9_51FB_6B21_6570(jass.Player(_____73A9_5BB6ID))
                end
                if #_____8FC7_671F_5217_8868 > 0 then
                    _____4ECD_6709_5F85_5904_7406_4EFB_52A1 = true
                end
            end
            ::__continue30::
            i = i + 1
        end
    end
    _____66F4_65B0_7B49_5F85_786E_8BA4_73A9_5BB6_6570()
    if not _____4ECD_6709_5F85_5904_7406_4EFB_52A1 then
        _____505C_6B62_70B9_51FB_6B21_6570_8F6E_8BE2()
    end
end
local function _____786E_4FDD_70B9_51FB_6B21_6570_8F6E_8BE2_5DF2_542F_52A8()
    if _____70B9_51FB_6B21_6570_8F6E_8BE2ID ~= nil then
        return
    end
    _____70B9_51FB_6B21_6570_8F6E_8BE2ID = centerTimer.addPeriodicCallback(_____82F1_96C4_9009_62E9_8F6E_8BE2_95F4_9694_6BEB_79D2, _____8F6E_8BE2_70B9_51FB_6B21_6570_8870_51CF)
end
local function _____8BB0_5F55_4E00_6B21_70B9_51FB_786E_8BA4_7A97_53E3(_____73A9_5BB6)
    local _____73A9_5BB6ID = jass.GetPlayerId(_____73A9_5BB6)
    local _____8FC7_671F_65F6_95F4 = _____5F53_524D_6E38_620F_6BEB_79D2() + _____82F1_96C4_9009_62E9_914D_7F6E_8868["双击确认窗口秒数"] * 1000
    local _____5217_8868 = _____70B9_51FB_6B21_6570_8FC7_671F_65F6_95F4_8868[_____73A9_5BB6ID]
    if _____5217_8868 == nil then
        _____5217_8868 = {}
        _____70B9_51FB_6B21_6570_8FC7_671F_65F6_95F4_8868[_____73A9_5BB6ID] = _____5217_8868
    end
    _____5217_8868[#_____5217_8868 + 1] = _____8FC7_671F_65F6_95F4
    local _____65B0_70B9_51FB_6B21_6570 = _____589E_52A0_70B9_51FB_6B21_6570(_____73A9_5BB6)
    _____66F4_65B0_7B49_5F85_786E_8BA4_73A9_5BB6_6570()
    _____786E_4FDD_70B9_51FB_6B21_6570_8F6E_8BE2_5DF2_542F_52A8()
end
local function _____662F_53EF_9009_73A9_5BB6(_____73A9_5BB6ID)
    return __TS__ArrayIndexOf(_____82F1_96C4_9009_62E9_914D_7F6E_8868["可选玩家ID列表"], _____73A9_5BB6ID) >= 0
end
local function _____83B7_53D6_914D_7F6E_77E9_5F62(_____533A_57DF_540D_79F0)
    return _____83B7_53D6_77E9_5F62_533A_57DF(_____533A_57DF_540D_79F0)
end
local function _____662F_82F1_96C4_9009_62E9_533A_57DF_5185_5355_4F4D(_____5355_4F4D)
    local _____9009_62E9_533A_57DF = _____83B7_53D6_914D_7F6E_77E9_5F62(_____82F1_96C4_9009_62E9_914D_7F6E_8868["选择区域名称"])
    if _____9009_62E9_533A_57DF == nil or _____9009_62E9_533A_57DF == 0 then
        return false
    end
    return RectContainsUnitBJ(_____9009_62E9_533A_57DF, _____5355_4F4D) == true
end
local function _____73A9_5BB6_662F_5426_5DF2_9009_62E9_82F1_96C4(_____73A9_5BB6)
    return ydSafe.YDUserDataGetSafe("player", _____73A9_5BB6, _____82F1_96C4_9009_62E9_914D_7F6E_8868["英雄已选择标记键"], "boolean") == true
end
local function _____89E3_6790_6280_80FD_7C7B_578BID(_____6280_80FD_540D)
    local ____temp_10
    if _____6280_80FD_540D == nil then
        ____temp_10 = nil
    else
        ____temp_10 = _____6309_540D_5B57_53CD_67E5_6280_80FDID(_____6280_80FD_540D)
    end
    local _____539F_59CBID = ____temp_10
    if _____539F_59CBID ~= nil and _____539F_59CBID ~= "" then
        return stringToFourCCSafe(_____539F_59CBID)
    end
    return stringToFourCCSafe(_____9ED8_8BA4_82F1_96C4_7981_7528_6280_80FD_539F_59CBID)
end
local function _____89E3_6790_5355_4F4D_7C7B_578BID(_____5355_4F4D_540D)
    local ____temp_11
    if _____5355_4F4D_540D == nil then
        ____temp_11 = nil
    else
        ____temp_11 = _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID(_____5355_4F4D_540D)
    end
    local _____539F_59CBID = ____temp_11
    if _____539F_59CBID ~= nil and _____539F_59CBID ~= "" then
        return stringToFourCCSafe(_____539F_59CBID)
    end
    return stringToFourCCSafe(_____9ED8_8BA4BB_5355_4F4D_539F_59CBID)
end
local function _____83B7_53D6_82F1_96C4_51FA_751F_70B9()
    return {X = _____82F1_96C4_9009_62E9_914D_7F6E_8868["英雄出生坐标"].X, Y = _____82F1_96C4_9009_62E9_914D_7F6E_8868["英雄出生坐标"].Y}
end
local function _____5199_5165_73A9_5BB6_82F1_96C4_540D_5B57_7B26_4E32(_____73A9_5BB6, _____82F1_96C4)
    local _____5B57_7B26_4E32_6570_7EC4 = jglobals.udg_String
    if _____5B57_7B26_4E32_6570_7EC4 == nil then
        return
    end
    local _____7D22_5F15 = jass.GetPlayerId(_____73A9_5BB6) + _____82F1_96C4_9009_62E9_914D_7F6E_8868["玩家英雄名写入字符串数组偏移"]
    _____5B57_7B26_4E32_6570_7EC4[_____7D22_5F15] = jass.GetUnitName(_____82F1_96C4)
end
local function _____83B7_53D6_82F1_96C4_5355_51FB_4ECB_7ECD_6587_672C(_____82F1_96C4)
    local _____5355_4F4D_540D = jass.GetUnitName(_____82F1_96C4)
    return _____82F1_96C4_9009_62E9_914D_7F6E_8868["英雄单击介绍表"][_____5355_4F4D_540D]
end
local function _____663E_793A_82F1_96C4_5355_51FB_4ECB_7ECD(_____73A9_5BB6, _____82F1_96C4)
    local _____6587_672C = _____83B7_53D6_82F1_96C4_5355_51FB_4ECB_7ECD_6587_672C(_____82F1_96C4)
    if _____6587_672C == nil or _____6587_672C == "" then
        return
    end
    DisplayTimedTextToPlayer(
        _____73A9_5BB6,
        0,
        0,
        _____82F1_96C4_9009_62E9_914D_7F6E_8868["单击介绍显示秒数"],
        _____6587_672C
    )
end
local function _____6267_884C_9009_62E9_786E_8BA4_516C_5171_89E6_53D1()
    local _____89E6_53D1_540D = _____82F1_96C4_9009_62E9_914D_7F6E_8868["选择确认后直接执行触发名"]
    if _____89E6_53D1_540D == nil or _____89E6_53D1_540D == "" then
        return
    end
    local _____89E6_53D1_5668 = _____83B7_53D6_65E7_89E6_53D1_5BF9_8C61(_____89E6_53D1_540D)
    if _____89E6_53D1_5668 == nil or _____89E6_53D1_5668 == 0 then
        return
    end
    if type(jass.TriggerExecute) == "function" then
        jass.TriggerExecute(_____89E6_53D1_5668)
    end
end
local function _____53D1_9001_82F1_96C4_786E_8BA4_516C_544A(_____73A9_5BB6, _____82F1_96C4)
    local _____6587_672C = ((((_____82F1_96C4_9009_62E9_914D_7F6E_8868["英雄确认公告前缀"] .. "|cffffcc99『") .. tostring(jass.GetPlayerName(_____73A9_5BB6))) .. "』|r使用角色『") .. tostring(jass.GetUnitName(_____82F1_96C4))) .. "』开始了旅途！"
    QuestMessageBJ(
        GetPlayersAll(),
        jglobals.bj_QUESTMESSAGE_UPDATED,
        _____6587_672C
    )
end
local function _____786E_4FDD_82F1_96C4_6CE8_518C_6865_63A5_5DF2_521D_59CB_5316()
    if _____82F1_96C4_6CE8_518C_6865_63A5_5DF2_521D_59CB_5316 then
        return
    end
    if type(initPlayerHeroGetBridge) == "function" then
        initPlayerHeroGetBridge()
    end
    _____82F1_96C4_6CE8_518C_6865_63A5_5DF2_521D_59CB_5316 = true
end
local function _____786E_8BA4_82F1_96C4_9009_62E9(_____73A9_5BB6, _____82F1_96C4)
    local _____51FA_751F_70B9 = _____83B7_53D6_82F1_96C4_51FA_751F_70B9()
    if _____51FA_751F_70B9 == nil then
        return
    end
    local ____BB_5355_4F4D_7C7B_578BID = _____89E3_6790_5355_4F4D_7C7B_578BID(_____82F1_96C4_9009_62E9_914D_7F6E_8868["BB单位名"])
    local _____7981_7528_6280_80FDID = _____89E3_6790_6280_80FD_7C7B_578BID(_____82F1_96C4_9009_62E9_914D_7F6E_8868["英雄禁用技能名"])
    local _____82F1_96C4_7EC4 = ydSafe.YDUserDataGetSafe("string", _____82F1_96C4_9009_62E9_914D_7F6E_8868["玩家英雄单位组表名"], _____82F1_96C4_9009_62E9_914D_7F6E_8868["玩家英雄单位组键"], "group")
    if type(ModifyHeroSkillPoints) == "function" then
        ModifyHeroSkillPoints(_____82F1_96C4, jglobals.bj_MODIFYMETHOD_ADD, 1)
    end
    _____53D1_9001_82F1_96C4_786E_8BA4_516C_544A(_____73A9_5BB6, _____82F1_96C4)
    if _____7981_7528_6280_80FDID ~= 0 then
        jass.UnitRemoveAbility(_____82F1_96C4, _____7981_7528_6280_80FDID)
    end
    ydSafe.YDUserDataSetSafe(
        "player",
        _____73A9_5BB6,
        _____82F1_96C4_9009_62E9_914D_7F6E_8868["英雄已选择标记键"],
        "boolean",
        true
    )
    if _____82F1_96C4_7EC4 ~= nil and _____82F1_96C4_7EC4 ~= 0 then
        GroupAddUnit(_____82F1_96C4_7EC4, _____82F1_96C4)
    end
    ydSafe.YDUserDataSetSafe(
        "player",
        _____73A9_5BB6,
        "英雄",
        "unit",
        _____82F1_96C4
    )
    jass.SetUnitOwner(_____82F1_96C4, _____73A9_5BB6, true)
    local BB = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        _____73A9_5BB6,
        ____BB_5355_4F4D_7C7B_578BID,
        _____51FA_751F_70B9.X,
        _____51FA_751F_70B9.Y,
        0
    )
    ydSafe.YDUserDataSetSafe(
        "player",
        _____73A9_5BB6,
        _____82F1_96C4_9009_62E9_914D_7F6E_8868["记录玩家BB键"],
        "unit",
        BB
    )
    jass.SetUnitPosition(_____82F1_96C4, _____51FA_751F_70B9.X, _____51FA_751F_70B9.Y)
    StarOther_PanCameraToTimedForPlayer(_____73A9_5BB6, _____51FA_751F_70B9.X, _____51FA_751F_70B9.Y, 0.5)
    _____5199_5165_73A9_5BB6_82F1_96C4_540D_5B57_7B26_4E32(_____73A9_5BB6, _____82F1_96C4)
    ____exports["注册英雄选择旧单位事件"]({["英雄"] = _____82F1_96C4, BB = BB})
    ydSafe.YDUserDataSetSafe(
        "string",
        _____82F1_96C4_9009_62E9_914D_7F6E_8868["记录已选英雄表名"],
        _____82F1_96C4_9009_62E9_914D_7F6E_8868["记录已选英雄键"],
        "unit",
        _____82F1_96C4
    )
    _____6267_884C_9009_62E9_786E_8BA4_516C_5171_89E6_53D1()
    _____786E_4FDD_82F1_96C4_6CE8_518C_6865_63A5_5DF2_521D_59CB_5316()
    directRegisterPlayerHero(_____73A9_5BB6, _____82F1_96C4)
    _____5F53_524D_72B6_6001["已确认玩家数"] = _____5F53_524D_72B6_6001["已确认玩家数"] + 1
end
local function _____5E94_5FFD_7565_672C_6B21_9009_62E9(_____73A9_5BB6, _____73A9_5BB6ID, _____5355_4F4D, isSelected)
    if _____5F53_524D_72B6_6001["是否已关闭"] then
        return true
    end
    if isSelected ~= true then
        return true
    end
    if not _____662F_53EF_9009_73A9_5BB6(_____73A9_5BB6ID) then
        return true
    end
    local _____9009_62E9_533A_57DF = _____83B7_53D6_914D_7F6E_77E9_5F62(_____82F1_96C4_9009_62E9_914D_7F6E_8868["选择区域名称"])
    if _____9009_62E9_533A_57DF == nil or _____9009_62E9_533A_57DF == 0 then
        return true
    end
    if not _____662F_82F1_96C4_9009_62E9_533A_57DF_5185_5355_4F4D(_____5355_4F4D) then
        return true
    end
    if jass.IsUnitType(_____5355_4F4D, jass.UNIT_TYPE_HERO) ~= true then
        return true
    end
    local _____5355_4F4D_6240_6709_8005 = jass.GetOwningPlayer(_____5355_4F4D)
    local _____4E2D_7ACB_88AB_52A8_73A9_5BB6 = jass.Player(jass.PLAYER_NEUTRAL_PASSIVE)
    if _____5355_4F4D_6240_6709_8005 ~= _____4E2D_7ACB_88AB_52A8_73A9_5BB6 then
        return true
    end
    if _____73A9_5BB6_662F_5426_5DF2_9009_62E9_82F1_96C4(_____73A9_5BB6) then
        return true
    end
    return false
end
local function ____on_82F1_96C4_9009_62E9_4E8B_4EF6(_____73A9_5BB6, _____73A9_5BB6ID, _____5355_4F4D, isSelected)
    if _____5E94_5FFD_7565_672C_6B21_9009_62E9(_____73A9_5BB6, _____73A9_5BB6ID, _____5355_4F4D, isSelected) then
        return
    end
    local _____5F53_524D_70B9_51FB_6B21_6570 = _____83B7_53D6_70B9_51FB_6B21_6570(_____73A9_5BB6)
    if _____5F53_524D_70B9_51FB_6B21_6570 >= 1 then
        _____786E_8BA4_82F1_96C4_9009_62E9(_____73A9_5BB6, _____5355_4F4D)
        return
    end
    _____663E_793A_82F1_96C4_5355_51FB_4ECB_7ECD(_____73A9_5BB6, _____5355_4F4D)
    _____8BB0_5F55_4E00_6B21_70B9_51FB_786E_8BA4_7A97_53E3(_____73A9_5BB6)
end
local function _____5173_95ED_82F1_96C4_9009_62E9_7CFB_7EDF()
    if _____5F53_524D_72B6_6001["是否已关闭"] then
        return
    end
    _____5F53_524D_72B6_6001["是否已关闭"] = true
    do
        local i = 0
        while i < #_____82F1_96C4_9009_62E9_914D_7F6E_8868["可选玩家ID列表"] do
            local _____73A9_5BB6ID = _____82F1_96C4_9009_62E9_914D_7F6E_8868["可选玩家ID列表"][i + 1]
            local _____73A9_5BB6 = jass.Player(_____73A9_5BB6ID)
            _____6E05_7A7A_70B9_51FB_6B21_6570(_____73A9_5BB6)
            __TS__Delete(_____70B9_51FB_6B21_6570_8FC7_671F_65F6_95F4_8868, _____73A9_5BB6ID)
            i = i + 1
        end
    end
    _____66F4_65B0_7B49_5F85_786E_8BA4_73A9_5BB6_6570()
    _____505C_6B62_70B9_51FB_6B21_6570_8F6E_8BE2()
    QuestMessageBJ(
        GetPlayersAll(),
        jglobals.bj_QUESTMESSAGE_ALWAYSHINT,
        _____82F1_96C4_9009_62E9_914D_7F6E_8868["选择系统关闭提示文本"]
    )
end
local function _____521D_59CB_5316_9009_4E2D_4E8B_4EF6_4E2D_5FC3()
    do
        local i = 0
        while i < #_____82F1_96C4_9009_62E9_914D_7F6E_8868["可选玩家ID列表"] do
            local _____73A9_5BB6ID = _____82F1_96C4_9009_62E9_914D_7F6E_8868["可选玩家ID列表"][i + 1]
            local _____73A9_5BB6 = jass.Player(_____73A9_5BB6ID)
            selectionCenter.initPlayerSelectionCenter(_____73A9_5BB6)
            i = i + 1
        end
    end
    selectionCenter.addSelectionListener(____on_82F1_96C4_9009_62E9_4E8B_4EF6)
end
____exports["初始化英雄选择系统"] = function()
    if _____5F53_524D_72B6_6001["是否已初始化"] then
        return
    end
    _____5F53_524D_72B6_6001["是否已初始化"] = true
    _____521D_59CB_5316_9009_4E2D_4E8B_4EF6_4E2D_5FC3()
    if _____82F1_96C4_9009_62E9_914D_7F6E_8868["选择系统关闭秒数"] > 0 then
        centerTimer.addDelayedCallback(_____82F1_96C4_9009_62E9_914D_7F6E_8868["选择系统关闭秒数"] * 1000, _____5173_95ED_82F1_96C4_9009_62E9_7CFB_7EDF)
    end
end
return ____exports
