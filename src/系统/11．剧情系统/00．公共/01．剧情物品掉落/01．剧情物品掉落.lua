local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____00_FF0E_914D_7F6E_8868 = require("系统.11．剧情系统.00．公共.01．剧情物品掉落.00．配置表")
local _____5267_60C5_7269_54C1_6389_843D_914D_7F6E_8868 = ____00_FF0E_914D_7F6E_8868["剧情物品掉落配置表"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local ____require_result_1 = require("lib.扩展函数.物品相关函数.创建物品函数")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_1["创建物品并注册排泄监听"]
local ____require_result_2 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_2["按名字反查物品ID"]
local ____require_result_3 = require("系统.02．物品系统.19．掉落次数限制表")
local _____662F_5426_5141_8BB8_9650_6B21_7269_54C1_6389_843D = ____require_result_3["是否允许限次物品掉落"]
local _____8BB0_5F55_9650_6B21_7269_54C1_6389_843D = ____require_result_3["记录限次物品掉落"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_4.stringToFourCCSafe
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_5.YDUserDataGetSafe
local ____require_result_6 = require("lib.扩展函数.BJ函数.07．杂项")
local ModifyGateBJ = ____require_result_6.ModifyGateBJ
local ____require_result_7 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_7.GetPlayersAll
local ____require_result_8 = require("lib.扩展函数.BJ函数.05A．电影函数")
local TransmissionFromUnitWithNameBJ = ____require_result_8.TransmissionFromUnitWithNameBJ
local ____require_result_9 = require("系统.01．单位系统.08．单位配置表.00．杂鱼配置表")
local _____6309_540D_5B57_53CD_67E5_6742_9C7C_5355_4F4DID = ____require_result_9["按名字反查杂鱼单位ID"]
local ____require_result_10 = require("系统.01．单位系统.08．单位配置表.01．精英配置表")
local _____6309_540D_5B57_53CD_67E5_7CBE_82F1_5355_4F4DID = ____require_result_10["按名字反查精英单位ID"]
local ____require_result_11 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_11["按名字反查Boss单位ID"]
local ____require_result_12 = require("系统.01．单位系统.08．单位配置表.03．异界Boss配置表")
local _____6309_540D_5B57_53CD_67E5_5F02_754CBoss_5355_4F4DID = ____require_result_12["按名字反查异界Boss单位ID"]
local ____require_result_13 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置")
local _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID = ____require_result_13["按名字反查玩家英雄单位ID"]
local GetOwningPlayer = jass.GetOwningPlayer
local GetRandomInt = jass.GetRandomInt
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local IsUnitIllusion = jass.IsUnitIllusion
local Player = jass.Player
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local UNIT_TYPE_SUMMONED = jass.UNIT_TYPE_SUMMONED
local bj_GATEOPERATION_OPEN = jglobals.bj_GATEOPERATION_OPEN
local bj_TIMETYPE_SET = jglobals.bj_TIMETYPE_SET
local _____5DF2_89E3_6790_914D_7F6E_8868 = {}
local _____5DF2_521D_59CB_5316_5267_60C5_7269_54C1_6389_843D = false
local function _____6309_540D_5B57_53CD_67E5_4EFB_610F_5355_4F4DID(name)
    return _____6309_540D_5B57_53CD_67E5_6742_9C7C_5355_4F4DID(name) or _____6309_540D_5B57_53CD_67E5_7CBE_82F1_5355_4F4DID(name) or _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID(name) or _____6309_540D_5B57_53CD_67E5_5F02_754CBoss_5355_4F4DID(name) or _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID(name)
end
local function _____521D_59CB_5316_914D_7F6E_7F13_5B58()
    if #_____5DF2_89E3_6790_914D_7F6E_8868 > 0 then
        return
    end
    do
        local i = 0
        while i < #_____5267_60C5_7269_54C1_6389_843D_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____5267_60C5_7269_54C1_6389_843D_914D_7F6E_8868[i + 1]
                local _____89E6_53D1_5355_4F4D_539F_59CBID = _____6309_540D_5B57_53CD_67E5_4EFB_610F_5355_4F4DID(_____914D_7F6E["触发单位名"])
                local _____89E6_53D1_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____89E6_53D1_5355_4F4D_539F_59CBID)
                if _____89E6_53D1_5355_4F4D_7C7B_578BID == 0 then
                    goto __continue6
                end
                local _____52A8_4F5C_5217_8868 = {}
                do
                    local j = 0
                    while j < #_____914D_7F6E["动作列表"] do
                        do
                            local _____52A8_4F5C = _____914D_7F6E["动作列表"][j + 1]
                            if _____52A8_4F5C["动作类型"] == "掉落物品" then
                                local _____7269_54C1ID = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____52A8_4F5C["物品名"] or "")
                                _____52A8_4F5C_5217_8868[#_____52A8_4F5C_5217_8868 + 1] = __TS__ObjectAssign(
                                    {},
                                    _____52A8_4F5C,
                                    {
                                        ["物品ID"] = _____7269_54C1ID,
                                        ["物品类型ID"] = stringToFourCCSafe(_____7269_54C1ID)
                                    }
                                )
                                goto __continue9
                            end
                            _____52A8_4F5C_5217_8868[#_____52A8_4F5C_5217_8868 + 1] = __TS__ObjectAssign({}, _____52A8_4F5C)
                        end
                        ::__continue9::
                        j = j + 1
                    end
                end
                _____5DF2_89E3_6790_914D_7F6E_8868[#_____5DF2_89E3_6790_914D_7F6E_8868 + 1] = __TS__ObjectAssign({}, _____914D_7F6E, {["触发单位类型ID"] = _____89E6_53D1_5355_4F4D_7C7B_578BID, ["动作列表"] = _____52A8_4F5C_5217_8868})
            end
            ::__continue6::
            i = i + 1
        end
    end
end
local function _____8BFB_53D6_5267_60C5_8FDB_5EA6()
    return __TS__Number(YDUserDataGetSafe("string", "剧情进度", "整数", "integer")) or 0
end
local function _____5FB7_9C81_4F0A_5B66_8005_5C5E_4E8E_4E2D_7ACB_88AB_52A8()
    local _____5B66_8005_5355_4F4D = YDUserDataGetSafe("string", "支线NPC", "德鲁伊学者", "unit")
    if _____5B66_8005_5355_4F4D == nil or _____5B66_8005_5355_4F4D == 0 then
        return false
    end
    return GetOwningPlayer(_____5B66_8005_5355_4F4D) == Player(PLAYER_NEUTRAL_PASSIVE)
end
local function _____6EE1_8DB3_52A8_4F5C_524D_7F6E(_____52A8_4F5C)
    if (_____52A8_4F5C["要求剧情进度至少"] or 0) > 0 and _____8BFB_53D6_5267_60C5_8FDB_5EA6() < (_____52A8_4F5C["要求剧情进度至少"] or 0) then
        return false
    end
    if _____52A8_4F5C["屏蔽条件"] == "德鲁伊学者属于中立被动" and _____5FB7_9C81_4F0A_5B66_8005_5C5E_4E8E_4E2D_7ACB_88AB_52A8() then
        return false
    end
    local _____6982_7387 = _____52A8_4F5C["掉落概率"] or 100
    if _____6982_7387 < 100 and GetRandomInt(1, 100) > _____6982_7387 then
        return false
    end
    return true
end
local function _____6267_884C_6389_843D_7269_54C1_52A8_4F5C(dyingUnit, _____52A8_4F5C)
    local _____7269_54C1ID = _____52A8_4F5C["物品ID"]
    if _____7269_54C1ID == nil or not _____662F_5426_5141_8BB8_9650_6B21_7269_54C1_6389_843D(_____7269_54C1ID) then
        return
    end
    if (_____52A8_4F5C["物品类型ID"] or 0) == 0 then
        return
    end
    local createdItem = _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(
        _____52A8_4F5C["物品类型ID"] or 0,
        GetUnitX(dyingUnit),
        GetUnitY(dyingUnit)
    )
    if createdItem ~= nil and createdItem ~= 0 then
        _____8BB0_5F55_9650_6B21_7269_54C1_6389_843D(_____7269_54C1ID)
    end
end
local function _____8BFB_53D6_5168_5C40_53EF_7834_574F_7269(_____5168_5C40_540D)
    return jglobals[_____5168_5C40_540D]
end
local function _____6267_884C_5F00_542F_5927_95E8_52A8_4F5C(_____52A8_4F5C)
    local _____5927_95E8_5217_8868 = _____52A8_4F5C["大门全局名列表"] or ({})
    do
        local i = 0
        while i < #_____5927_95E8_5217_8868 do
            do
                local _____5927_95E8 = _____8BFB_53D6_5168_5C40_53EF_7834_574F_7269(_____5927_95E8_5217_8868[i + 1])
                if _____5927_95E8 == nil or _____5927_95E8 == 0 then
                    goto __continue25
                end
                ModifyGateBJ(bj_GATEOPERATION_OPEN, _____5927_95E8)
            end
            ::__continue25::
            i = i + 1
        end
    end
end
local function _____6267_884C_7535_5F71_6D88_606F_52A8_4F5C(_____52A8_4F5C)
    local _____53D1_8A00_540D = _____52A8_4F5C["消息发言名"] or ""
    local _____6587_672C = _____52A8_4F5C["消息文本"] or ""
    if _____6587_672C == "" then
        return
    end
    TransmissionFromUnitWithNameBJ(
        GetPlayersAll(),
        nil,
        _____53D1_8A00_540D,
        nil,
        _____6587_672C,
        bj_TIMETYPE_SET,
        _____52A8_4F5C["持续时间"] or 10,
        false
    )
end
local function _____6267_884C_52A8_4F5C(dyingUnit, _____52A8_4F5C)
    if not _____6EE1_8DB3_52A8_4F5C_524D_7F6E(_____52A8_4F5C) then
        return
    end
    if _____52A8_4F5C["动作类型"] == "掉落物品" then
        _____6267_884C_6389_843D_7269_54C1_52A8_4F5C(dyingUnit, _____52A8_4F5C)
        return
    end
    if _____52A8_4F5C["动作类型"] == "开启大门" then
        _____6267_884C_5F00_542F_5927_95E8_52A8_4F5C(_____52A8_4F5C)
        return
    end
    if _____52A8_4F5C["动作类型"] == "电影消息" then
        _____6267_884C_7535_5F71_6D88_606F_52A8_4F5C(_____52A8_4F5C)
    end
end
local function _____5904_7406_5267_60C5_7269_54C1_6389_843D(dyingUnit)
    local dyingTypeId = GetUnitTypeId(dyingUnit)
    do
        local i = 0
        while i < #_____5DF2_89E3_6790_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____5DF2_89E3_6790_914D_7F6E_8868[i + 1]
                if _____914D_7F6E["触发单位类型ID"] ~= dyingTypeId then
                    goto __continue36
                end
                do
                    local j = 0
                    while j < #_____914D_7F6E["动作列表"] do
                        _____6267_884C_52A8_4F5C(dyingUnit, _____914D_7F6E["动作列表"][j + 1])
                        j = j + 1
                    end
                end
            end
            ::__continue36::
            i = i + 1
        end
    end
end
local function ____on_5267_60C5_5355_4F4D_6B7B_4EA1(dyingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    if IsUnitType(dyingUnit, UNIT_TYPE_SUMMONED) then
        return
    end
    if IsUnitIllusion(dyingUnit) then
        return
    end
    _____521D_59CB_5316_914D_7F6E_7F13_5B58()
    _____5904_7406_5267_60C5_7269_54C1_6389_843D(dyingUnit)
end
____exports["init剧情物品掉落"] = function()
    if _____5DF2_521D_59CB_5316_5267_60C5_7269_54C1_6389_843D then
        return
    end
    _____5DF2_521D_59CB_5316_5267_60C5_7269_54C1_6389_843D = true
    _____521D_59CB_5316_914D_7F6E_7F13_5B58()
    registerDeathListener(____on_5267_60C5_5355_4F4D_6B7B_4EA1)
end
return ____exports
