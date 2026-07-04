local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
local ____02_FF0EBoss_6B7B_4EA1_975EUI_6389_843D_4E0E_6E05_7406_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.05．Boss死亡结算.02．Boss死亡非UI掉落与清理配置表")
local ____Boss_6B7B_4EA1_975EUI_6389_843D_4E0E_6E05_7406_914D_7F6E_8868 = ____02_FF0EBoss_6B7B_4EA1_975EUI_6389_843D_4E0E_6E05_7406_914D_7F6E_8868["Boss死亡非UI掉落与清理配置表"]
local ____Boss_6B7B_4EA1_7ED3_7B97_63D0_793A_6587_672C_8868 = ____02_FF0EBoss_6B7B_4EA1_975EUI_6389_843D_4E0E_6E05_7406_914D_7F6E_8868["Boss死亡结算提示文本表"]
local ____01_FF0E_5E38_91CF_5B9A_4E49 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.05．Boss死亡结算.01．常量定义")
local ____Boss_6B7B_4EA1_7ED3_7B97_7279_6B8A_903B_8F91_6807_7B7E = ____01_FF0E_5E38_91CF_5B9A_4E49["Boss死亡结算特殊逻辑标签"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local YDUserDataClearSafe = ____require_result_0.YDUserDataClearSafe
local ____require_result_1 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataClearTable = ____require_result_1.YDUserDataClearTable
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_3["按名字反查Boss单位ID"]
local ____require_result_4 = require("系统.01．单位系统.08．单位配置表.04．总单位配置表")
local _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID = ____require_result_4["按名字反查总单位ID"]
local ____require_result_5 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_5["按名字反查物品ID"]
local ____require_result_6 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_6.QuestMessageBJ
local ____require_result_7 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_7.GetPlayersAll
local ____require_result_8 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local ModifyHeroStat = ____require_result_8.ModifyHeroStat
local AddHeroXPSwapped = ____require_result_8.AddHeroXPSwapped
local bj_HEROSTAT_STR = ____require_result_8.bj_HEROSTAT_STR
local bj_HEROSTAT_AGI = ____require_result_8.bj_HEROSTAT_AGI
local bj_HEROSTAT_INT = ____require_result_8.bj_HEROSTAT_INT
local ____require_result_9 = require("lib.扩展函数.自定义扩展函数.index")
local _____589E_52A0_82F1_96C4_57FA_7840_5168_5C5E_6027 = ____require_result_9["增加英雄基础全属性"]
local ____require_result_10 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_10.SGSS_SetState
local ____require_result_11 = require("lib.扩展函数.封装函数.01．通用工具.index")
local AdjustPlayerStateBJ = ____require_result_11.AdjustPlayerStateBJ
local ____require_result_12 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_12["调整玩家属性"]
local ____require_result_13 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_13.addDelayedCallback
local ____require_result_14 = require("系统.02．物品系统.18．首领奖励选择.05．奖励选择界面")
local _____6253_5F00_9996_9886_5956_52B1_9009_62E9_754C_9762 = ____require_result_14["打开首领奖励选择界面"]
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local CreateItem = jass.CreateItem
local Player = jass.Player
local ForGroup = jass.ForGroup
local GetEnumUnit = jass.GetEnumUnit
local GetRandomInt = jass.GetRandomInt
local GetHeroLevel = jass.GetHeroLevel
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
local _____653B_51FB_529B_5C5E_6027ID = 1
local ____BJ_4FEE_6539_589E_52A0 = 0
local _____5F53_524D_5168_5458_5956_52B1
local _____5F53_524DBoss_6B7B_4EA1_9996_9886_5956_52B1_6C60ID = ""
local _____8C7A_72FC_5F02_53D8_7D2F_8BA1_6B21_6570 = 0
local function _____8BFB_53D6_73A9_5BB6_82F1_96C4_7EC4()
    return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
end
local function _____53D6_7ED3_7B97_6D88_606F_679A_4E3E(_____63D0_793A_7C7B_578B)
    repeat
        local ____switch4 = _____63D0_793A_7C7B_578B
        local ____cond4 = ____switch4 == "UNITACQUIRED"
        if ____cond4 then
            return jglobals.bj_QUESTMESSAGE_UNITACQUIRED
        end
        ____cond4 = ____cond4 or ____switch4 == "ITEMACQUIRED"
        if ____cond4 then
            return jglobals.bj_QUESTMESSAGE_ITEMACQUIRED
        end
        ____cond4 = ____cond4 or ____switch4 == "COMPLETED"
        if ____cond4 then
            return jglobals.bj_QUESTMESSAGE_COMPLETED
        end
        ____cond4 = ____cond4 or ____switch4 == "ALWAYSHINT"
        if ____cond4 then
            return jglobals.bj_QUESTMESSAGE_ALWAYSHINT
        end
        ____cond4 = ____cond4 or ____switch4 == "WARNING"
        if ____cond4 then
            return jglobals.bj_QUESTMESSAGE_WARNING
        end
        ____cond4 = ____cond4 or ____switch4 == "UPDATED"
        do
            return jglobals.bj_QUESTMESSAGE_UPDATED
        end
    until true
end
local function _____53D1_9001Boss_6B7B_4EA1_7ED3_7B97_63D0_793A(_____914D_7F6E)
    if _____914D_7F6E["提示文本键"] == nil or _____914D_7F6E["提示文本键"] == "" then
        return
    end
    local _____63D0_793A_6587_672C_952E = _____914D_7F6E["提示文本键"]
    local _____6587_672C = ____Boss_6B7B_4EA1_7ED3_7B97_63D0_793A_6587_672C_8868[_____63D0_793A_6587_672C_952E]
    if _____6587_672C == nil then
        return
    end
    QuestMessageBJ(
        GetPlayersAll(),
        _____53D6_7ED3_7B97_6D88_606F_679A_4E3E(_____914D_7F6E["提示类型"]),
        _____6587_672C
    )
end
local function ____on_53D1_653EBoss_6B7B_4EA1_5168_5458_5956_52B1()
    local _____82F1_96C4 = GetEnumUnit()
    local _____5956_52B1 = _____5F53_524D_5168_5458_5956_52B1
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or _____5956_52B1 == nil then
        return
    end
    if _____5956_52B1["经验"] ~= nil and _____5956_52B1["经验"] ~= 0 then
        AddHeroXPSwapped(_____5956_52B1["经验"], _____82F1_96C4, true)
    end
    if _____5956_52B1["基础全属性"] ~= nil and _____5956_52B1["基础全属性"] ~= 0 then
        _____589E_52A0_82F1_96C4_57FA_7840_5168_5C5E_6027(_____82F1_96C4, _____5956_52B1["基础全属性"])
    end
    if _____5956_52B1["力量"] ~= nil and _____5956_52B1["力量"] ~= 0 then
        ModifyHeroStat(bj_HEROSTAT_STR, _____82F1_96C4, ____BJ_4FEE_6539_589E_52A0, _____5956_52B1["力量"])
    end
    if _____5956_52B1["敏捷"] ~= nil and _____5956_52B1["敏捷"] ~= 0 then
        ModifyHeroStat(bj_HEROSTAT_AGI, _____82F1_96C4, ____BJ_4FEE_6539_589E_52A0, _____5956_52B1["敏捷"])
    end
    if _____5956_52B1["智力"] ~= nil and _____5956_52B1["智力"] ~= 0 then
        ModifyHeroStat(bj_HEROSTAT_INT, _____82F1_96C4, ____BJ_4FEE_6539_589E_52A0, _____5956_52B1["智力"])
    end
    if _____5956_52B1["攻击力"] ~= nil and _____5956_52B1["攻击力"] ~= 0 then
        SGSS_SetState(_____82F1_96C4, _____653B_51FB_529B_5C5E_6027ID, _____5956_52B1["攻击力"])
    end
    if _____5956_52B1["魔法恢复"] ~= nil and _____5956_52B1["魔法恢复"] ~= 0 then
        _____8C03_6574_73A9_5BB6_5C5E_6027(_____82F1_96C4, "魔法恢复", _____5956_52B1["魔法恢复"])
    end
    if _____5956_52B1["金币"] ~= nil and _____5956_52B1["金币"] ~= 0 then
        AdjustPlayerStateBJ(
            nil,
            _____5956_52B1["金币"],
            GetOwningPlayer(_____82F1_96C4),
            jass.PLAYER_STATE_RESOURCE_GOLD
        )
    end
end
local function _____53D1_653EBoss_6B7B_4EA1_5168_5458_5956_52B1(_____5956_52B1)
    if _____5956_52B1 == nil then
        return
    end
    _____5F53_524D_5168_5458_5956_52B1 = _____5956_52B1
    local _____73A9_5BB6_82F1_96C4_7EC4 = _____8BFB_53D6_73A9_5BB6_82F1_96C4_7EC4()
    if _____73A9_5BB6_82F1_96C4_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_7EC4 ~= 0 then
        ForGroup(_____73A9_5BB6_82F1_96C4_7EC4, ____on_53D1_653EBoss_6B7B_4EA1_5168_5458_5956_52B1)
    end
    _____5F53_524D_5168_5458_5956_52B1 = nil
end
local function _____53D1_653EBoss_6B7B_4EA1_51FB_6740_8005_5956_52B1(_____5956_52B1, _____51FB_6740_8005)
    if _____5956_52B1 == nil or _____51FB_6740_8005 == nil or _____51FB_6740_8005 == 0 then
        return
    end
    if _____5956_52B1["金币"] ~= nil and _____5956_52B1["金币"] ~= 0 then
        AdjustPlayerStateBJ(
            nil,
            _____5956_52B1["金币"],
            GetOwningPlayer(_____51FB_6740_8005),
            jass.PLAYER_STATE_RESOURCE_GOLD
        )
    end
    local _____7269_54C1_5217_8868 = _____5956_52B1["物品名列表"]
    if _____7269_54C1_5217_8868 == nil or #_____7269_54C1_5217_8868 <= 0 then
        return
    end
    local x = GetUnitX(_____51FB_6740_8005)
    local y = GetUnitY(_____51FB_6740_8005)
    do
        local i = 0
        while i < #_____7269_54C1_5217_8868 do
            local _____7269_54C1ID = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____7269_54C1_5217_8868[i + 1]))
            if _____7269_54C1ID > 0 then
                CreateItem(_____7269_54C1ID, x, y)
            end
            i = i + 1
        end
    end
end
local function ____on_6253_5F00Boss_6B7B_4EA1_9996_9886_5956_52B1UI()
    local _____82F1_96C4 = GetEnumUnit()
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or _____5F53_524DBoss_6B7B_4EA1_9996_9886_5956_52B1_6C60ID == "" then
        return
    end
    _____6253_5F00_9996_9886_5956_52B1_9009_62E9_754C_9762(
        _____5F53_524DBoss_6B7B_4EA1_9996_9886_5956_52B1_6C60ID,
        GetOwningPlayer(_____82F1_96C4)
    )
end
local function _____6253_5F00Boss_6B7B_4EA1_9996_9886_5956_52B1UI(_____5956_52B1_6C60ID)
    if _____5956_52B1_6C60ID == nil or _____5956_52B1_6C60ID == "" then
        return
    end
    local _____73A9_5BB6_82F1_96C4_7EC4 = _____8BFB_53D6_73A9_5BB6_82F1_96C4_7EC4()
    if _____73A9_5BB6_82F1_96C4_7EC4 == nil or _____73A9_5BB6_82F1_96C4_7EC4 == 0 then
        return
    end
    _____5F53_524DBoss_6B7B_4EA1_9996_9886_5956_52B1_6C60ID = _____5956_52B1_6C60ID
    ForGroup(_____73A9_5BB6_82F1_96C4_7EC4, ____on_6253_5F00Boss_6B7B_4EA1_9996_9886_5956_52B1UI)
    _____5F53_524DBoss_6B7B_4EA1_9996_9886_5956_52B1_6C60ID = ""
end
local function _____6267_884C_6E05_7406_9879(_____6E05_7406_9879, ____Boss_5355_4F4D)
    if _____6E05_7406_9879["表名"] == nil or _____6E05_7406_9879["表名"] == "" then
        return
    end
    if _____6E05_7406_9879["表名"] == "当前Boss单位表" then
        if ____Boss_5355_4F4D == nil or ____Boss_5355_4F4D == 0 then
            return
        end
        if _____6E05_7406_9879["清理整表"] == true or _____6E05_7406_9879["字段名"] == nil and _____6E05_7406_9879["键名"] == nil then
            YDUserDataClearTable("unit", ____Boss_5355_4F4D)
            return
        end
        if _____6E05_7406_9879["字段名"] ~= nil and _____6E05_7406_9879["字段名"] ~= "" then
            YDUserDataClearSafe("unit", ____Boss_5355_4F4D, _____6E05_7406_9879["字段名"], _____6E05_7406_9879["值类型名"] or "unit")
        end
        return
    end
    if _____6E05_7406_9879["键名"] == nil or _____6E05_7406_9879["键名"] == "" then
        return
    end
    YDUserDataClearSafe("string", _____6E05_7406_9879["表名"], _____6E05_7406_9879["键名"], _____6E05_7406_9879["值类型名"] or "unit")
end
local function _____6267_884CBoss_6B7B_4EA1_6E05_7406(_____914D_7F6E, ____Boss_5355_4F4D)
    local _____6E05_7406_5217_8868 = _____914D_7F6E["清理列表"]
    if _____6E05_7406_5217_8868 == nil or #_____6E05_7406_5217_8868 <= 0 then
        return
    end
    do
        local i = 0
        while i < #_____6E05_7406_5217_8868 do
            _____6267_884C_6E05_7406_9879(_____6E05_7406_5217_8868[i + 1], ____Boss_5355_4F4D)
            i = i + 1
        end
    end
end
local function _____53D6Boss_6B7B_4EA1_4F4D_7F6E(____Boss_5355_4F4D, _____51FB_6740_8005)
    if ____Boss_5355_4F4D ~= nil and ____Boss_5355_4F4D ~= 0 then
        return {
            x = GetUnitX(____Boss_5355_4F4D),
            y = GetUnitY(____Boss_5355_4F4D)
        }
    end
    if _____51FB_6740_8005 ~= nil and _____51FB_6740_8005 ~= 0 then
        return {
            x = GetUnitX(_____51FB_6740_8005),
            y = GetUnitY(_____51FB_6740_8005)
        }
    end
    return {x = 0, y = 0}
end
local function ____Boss_6B7B_4EA1_7ED3_7B97_547D_4E2D_6807_7B7E(_____914D_7F6E, _____6807_7B7E)
    local _____5217_8868 = _____914D_7F6E["特殊逻辑标签"]
    return _____5217_8868 ~= nil and __TS__ArrayIndexOf(_____5217_8868, _____6807_7B7E) >= 0
end
local function _____5168_5458_5956_52B1_6EE1_8DB3_51FB_6740_8005_7B49_7EA7_9650_5236(_____5956_52B1, _____51FB_6740_8005)
    if _____5956_52B1 == nil or _____5956_52B1["击杀者最高等级限制"] == nil then
        return true
    end
    return _____51FB_6740_8005 ~= nil and _____51FB_6740_8005 ~= 0 and IsUnitType(_____51FB_6740_8005, UNIT_TYPE_HERO) == true and GetHeroLevel(_____51FB_6740_8005) <= _____5956_52B1["击杀者最高等级限制"]
end
local function _____5904_7406Boss_6B7B_4EA1_7279_6B8A_903B_8F91_524D_7F6E(_____914D_7F6E, _____51FB_6740_8005)
    if ____Boss_6B7B_4EA1_7ED3_7B97_547D_4E2D_6807_7B7E(_____914D_7F6E, ____Boss_6B7B_4EA1_7ED3_7B97_7279_6B8A_903B_8F91_6807_7B7E["豺狼异变累计"]) then
        _____8C7A_72FC_5F02_53D8_7D2F_8BA1_6B21_6570 = _____8C7A_72FC_5F02_53D8_7D2F_8BA1_6B21_6570 + 1
        if _____8C7A_72FC_5F02_53D8_7D2F_8BA1_6B21_6570 <= 1 then
            return false
        end
    end
    if ____Boss_6B7B_4EA1_7ED3_7B97_547D_4E2D_6807_7B7E(_____914D_7F6E, ____Boss_6B7B_4EA1_7ED3_7B97_7279_6B8A_903B_8F91_6807_7B7E["沙漠宝藏击杀者非中立"]) then
        if _____51FB_6740_8005 == nil or _____51FB_6740_8005 == 0 then
            return false
        end
        local _____51FB_6740_8005_73A9_5BB6 = GetOwningPlayer(_____51FB_6740_8005)
        if _____51FB_6740_8005_73A9_5BB6 == Player(PLAYER_NEUTRAL_AGGRESSIVE) then
            return false
        end
    end
    return true
end
local function _____5904_7406Boss_6B7B_4EA1_7279_6B8A_903B_8F91_6389_843D(_____914D_7F6E, ____Boss_5355_4F4D, _____51FB_6740_8005)
    if not ____Boss_6B7B_4EA1_7ED3_7B97_547D_4E2D_6807_7B7E(_____914D_7F6E, ____Boss_6B7B_4EA1_7ED3_7B97_7279_6B8A_903B_8F91_6807_7B7E["沙漠宝藏击杀者非中立"]) then
        return
    end
    local _____4F4D_7F6E = _____53D6Boss_6B7B_4EA1_4F4D_7F6E(____Boss_5355_4F4D, _____51FB_6740_8005)
    if _____914D_7F6E["非装备批量掉落物品名"] == nil or _____914D_7F6E["非装备批量掉落物品名"] == "" then
        return
    end
    local _____91D1_5E01_7269_54C1ID = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____914D_7F6E["非装备批量掉落物品名"]))
    local _____6389_843D_6B21_6570_6700_5C0F_503C = _____914D_7F6E["非装备批量掉落最小数量"] or 15
    local _____6389_843D_6B21_6570_6700_5927_503C = _____914D_7F6E["非装备批量掉落最大数量"] or 25
    local _____6389_843D_6B21_6570 = GetRandomInt(_____6389_843D_6B21_6570_6700_5C0F_503C, _____6389_843D_6B21_6570_6700_5927_503C)
    do
        local i = 0
        while i < _____6389_843D_6B21_6570 do
            if _____91D1_5E01_7269_54C1ID > 0 then
                CreateItem(_____91D1_5E01_7269_54C1ID, _____4F4D_7F6E.x, _____4F4D_7F6E.y)
            end
            i = i + 1
        end
    end
end
local function _____6389_843DBoss_6B7B_4EA1_76F4_63A5_7269_54C1(_____914D_7F6E, ____Boss_5355_4F4D, _____51FB_6740_8005)
    local _____7269_54C1_5217_8868 = _____914D_7F6E["直接掉落物品名列表"]
    local _____7269_54C1ID_5217_8868 = _____914D_7F6E["直接掉落物品ID列表"]
    if (_____7269_54C1_5217_8868 == nil or #_____7269_54C1_5217_8868 <= 0) and (_____7269_54C1ID_5217_8868 == nil or #_____7269_54C1ID_5217_8868 <= 0) then
        return
    end
    local _____4F4D_7F6E = _____53D6Boss_6B7B_4EA1_4F4D_7F6E(____Boss_5355_4F4D, _____51FB_6740_8005)
    if _____7269_54C1_5217_8868 ~= nil then
        do
            local i = 0
            while i < #_____7269_54C1_5217_8868 do
                local _____7269_54C1ID = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____7269_54C1_5217_8868[i + 1]))
                if _____7269_54C1ID > 0 then
                    CreateItem(_____7269_54C1ID, _____4F4D_7F6E.x, _____4F4D_7F6E.y)
                end
                i = i + 1
            end
        end
    end
    if _____7269_54C1ID_5217_8868 ~= nil then
        do
            local i = 0
            while i < #_____7269_54C1ID_5217_8868 do
                local _____7269_54C1ID = stringToFourCCSafe(_____7269_54C1ID_5217_8868[i + 1])
                if _____7269_54C1ID > 0 then
                    CreateItem(_____7269_54C1ID, _____4F4D_7F6E.x, _____4F4D_7F6E.y)
                end
                i = i + 1
            end
        end
    end
end
local function _____5EF6_8FDF_6267_884CBoss_6B7B_4EA1_5956_52B1_4E0E_63D0_793A(_____914D_7F6E, _____5168_5458_5956_52B1)
    if _____5168_5458_5956_52B1 ~= nil then
        _____53D1_653EBoss_6B7B_4EA1_5168_5458_5956_52B1(_____5168_5458_5956_52B1)
    end
    _____53D1_9001Boss_6B7B_4EA1_7ED3_7B97_63D0_793A(_____914D_7F6E)
end
local function _____6267_884CBoss_6B7B_4EA1_5956_52B1_4E0E_63D0_793A(_____914D_7F6E, _____51FB_6740_8005)
    local _____5168_5458_5956_52B1 = _____914D_7F6E["全员奖励"]
    if not _____5168_5458_5956_52B1_6EE1_8DB3_51FB_6740_8005_7B49_7EA7_9650_5236(_____5168_5458_5956_52B1, _____51FB_6740_8005) then
        _____5168_5458_5956_52B1 = nil
    end
    if _____914D_7F6E["延迟提示秒数"] ~= nil and _____914D_7F6E["延迟提示秒数"] > 0 then
        addDelayedCallback(
            _____914D_7F6E["延迟提示秒数"] * 1000,
            function()
                _____5EF6_8FDF_6267_884CBoss_6B7B_4EA1_5956_52B1_4E0E_63D0_793A(_____914D_7F6E, _____5168_5458_5956_52B1)
            end
        )
        return
    end
    _____5EF6_8FDF_6267_884CBoss_6B7B_4EA1_5956_52B1_4E0E_63D0_793A(_____914D_7F6E, _____5168_5458_5956_52B1)
end
local function _____89E3_6790Boss_5355_4F4D(_____914D_7F6E, ____Boss_5355_4F4D)
    if ____Boss_5355_4F4D ~= nil and ____Boss_5355_4F4D ~= 0 then
        return ____Boss_5355_4F4D
    end
    if _____914D_7F6E["Boss引用键"] == nil or _____914D_7F6E["Boss引用键"] == "" then
        return nil
    end
    local _____70B9_4F4D = (string.find(_____914D_7F6E["Boss引用键"], ".", nil, true) or 0) - 1
    if _____70B9_4F4D <= 0 or _____70B9_4F4D >= #_____914D_7F6E["Boss引用键"] - 1 then
        return nil
    end
    local _____8868_540D = __TS__StringSubstring(_____914D_7F6E["Boss引用键"], 0, _____70B9_4F4D)
    local _____952E_540D = __TS__StringSubstring(_____914D_7F6E["Boss引用键"], _____70B9_4F4D + 1)
    return YDUserDataGetSafe("string", _____8868_540D, _____952E_540D, "unit")
end
local function _____53D6_5355_4F4D_540D_5339_914D_539F_59CBID(_____5355_4F4D_540D)
    local ____Boss_539F_59CBID = _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID(_____5355_4F4D_540D)
    if ____Boss_539F_59CBID ~= nil and ____Boss_539F_59CBID ~= "" then
        return stringToFourCCSafe(____Boss_539F_59CBID)
    end
    local _____603B_8868_539F_59CBID = _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID(_____5355_4F4D_540D)
    if _____603B_8868_539F_59CBID ~= nil and _____603B_8868_539F_59CBID ~= "" then
        return stringToFourCCSafe(_____603B_8868_539F_59CBID)
    end
    return 0
end
local function ____Boss_5355_4F4D_5339_914D_914D_7F6E(_____914D_7F6E, ____Boss_5355_4F4D)
    if ____Boss_5355_4F4D == nil or ____Boss_5355_4F4D == 0 then
        return false
    end
    if _____914D_7F6E["Boss引用键"] ~= nil and _____914D_7F6E["Boss引用键"] ~= "" then
        local _____5F15_7528_5355_4F4D = _____89E3_6790Boss_5355_4F4D(_____914D_7F6E)
        return _____5F15_7528_5355_4F4D ~= nil and _____5F15_7528_5355_4F4D ~= 0 and _____5F15_7528_5355_4F4D == ____Boss_5355_4F4D
    end
    local _____5355_4F4D_7C7B_578BID = GetUnitTypeId(____Boss_5355_4F4D)
    if _____5355_4F4D_7C7B_578BID <= 0 then
        return false
    end
    if _____914D_7F6E["Boss单位名"] ~= nil and _____914D_7F6E["Boss单位名"] ~= "" then
        return _____53D6_5355_4F4D_540D_5339_914D_539F_59CBID(_____914D_7F6E["Boss单位名"]) == _____5355_4F4D_7C7B_578BID
    end
    local _____540D_79F0_5217_8868 = _____914D_7F6E["Boss单位名列表"]
    if _____540D_79F0_5217_8868 == nil or #_____540D_79F0_5217_8868 <= 0 then
        return false
    end
    do
        local i = 0
        while i < #_____540D_79F0_5217_8868 do
            if _____53D6_5355_4F4D_540D_5339_914D_539F_59CBID(_____540D_79F0_5217_8868[i + 1]) == _____5355_4F4D_7C7B_578BID then
                return true
            end
            i = i + 1
        end
    end
    return false
end
____exports["获取Boss死亡结算配置"] = function(____Boss_5355_4F4D)
    if ____Boss_5355_4F4D == nil or ____Boss_5355_4F4D == 0 then
        return nil
    end
    do
        local i = 0
        while i < #____Boss_6B7B_4EA1_975EUI_6389_843D_4E0E_6E05_7406_914D_7F6E_8868 do
            local _____914D_7F6E = ____Boss_6B7B_4EA1_975EUI_6389_843D_4E0E_6E05_7406_914D_7F6E_8868[i + 1]
            if ____Boss_5355_4F4D_5339_914D_914D_7F6E(_____914D_7F6E, ____Boss_5355_4F4D) then
                return _____914D_7F6E
            end
            i = i + 1
        end
    end
    return nil
end
____exports["按结算键获取Boss死亡结算配置"] = function(_____7ED3_7B97_952E)
    do
        local i = 0
        while i < #____Boss_6B7B_4EA1_975EUI_6389_843D_4E0E_6E05_7406_914D_7F6E_8868 do
            if ____Boss_6B7B_4EA1_975EUI_6389_843D_4E0E_6E05_7406_914D_7F6E_8868[i + 1]["键"] == _____7ED3_7B97_952E then
                return ____Boss_6B7B_4EA1_975EUI_6389_843D_4E0E_6E05_7406_914D_7F6E_8868[i + 1]
            end
            i = i + 1
        end
    end
    return nil
end
____exports["执行Boss死亡结算"] = function(_____914D_7F6E, ____Boss_5355_4F4D, _____51FB_6740_8005)
    local _____8FD0_884CBoss_5355_4F4D = _____89E3_6790Boss_5355_4F4D(_____914D_7F6E, ____Boss_5355_4F4D)
    if not _____5904_7406Boss_6B7B_4EA1_7279_6B8A_903B_8F91_524D_7F6E(_____914D_7F6E, _____51FB_6740_8005) then
        return false
    end
    _____6253_5F00Boss_6B7B_4EA1_9996_9886_5956_52B1UI(_____914D_7F6E["首领奖励池ID"])
    _____6389_843DBoss_6B7B_4EA1_76F4_63A5_7269_54C1(_____914D_7F6E, _____8FD0_884CBoss_5355_4F4D, _____51FB_6740_8005)
    _____5904_7406Boss_6B7B_4EA1_7279_6B8A_903B_8F91_6389_843D(_____914D_7F6E, _____8FD0_884CBoss_5355_4F4D, _____51FB_6740_8005)
    _____6267_884CBoss_6B7B_4EA1_6E05_7406(_____914D_7F6E, _____8FD0_884CBoss_5355_4F4D)
    _____53D1_653EBoss_6B7B_4EA1_51FB_6740_8005_5956_52B1(_____914D_7F6E["击杀者奖励"], _____51FB_6740_8005)
    _____6267_884CBoss_6B7B_4EA1_5956_52B1_4E0E_63D0_793A(_____914D_7F6E, _____51FB_6740_8005)
    return true
end
____exports["尝试执行Boss死亡结算"] = function(____Boss_5355_4F4D, _____51FB_6740_8005)
    local _____914D_7F6E = ____exports["获取Boss死亡结算配置"](____Boss_5355_4F4D)
    if _____914D_7F6E == nil then
        return false
    end
    return ____exports["执行Boss死亡结算"](_____914D_7F6E, ____Boss_5355_4F4D, _____51FB_6740_8005)
end
return ____exports
