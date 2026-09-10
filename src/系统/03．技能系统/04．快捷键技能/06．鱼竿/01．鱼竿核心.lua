--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____533A_95F4_547D_4E2D, _____70B9_5728_9493_70B9_77E9_5F62_5185, _____53D6_9493_70B9_533A_57DF, _____7C73_4E9A_6C34_6E90_5DF2_51C0_5316, _____53D6_9493_70B9_9C7C_6C60, _____6620_5C04_56DE_843D_503C, _____8BFB_53D6_91CD_590D_5237_65B0_6807_8BB0, _____5199_5165_91CD_590D_5237_65B0_6807_8BB0, _____8BFB_53D6_5355_4F4D_7ED3_679C_6240_6709_8005, _____82F1_96C4_7B49_7EA7_6EE1_8DB3, _____521B_5EFA_9C7C_7AFF_5355_4F4D_7ED3_679C, _____5904_7406_9690_85CF_906D_9047, _____663E_793A_9C7C_7AFF_63D0_793A, _____663E_793A_9C7C_7AFF_5931_8D25, _____9C7C_7AFF_6536_7AFF_6807_8BB0_6E05_9664, _____7ED3_7B97_901A_7528_7ED3_679C, _____7ED3_7B97_9493_70B9_4EA7_7269, _____7ED3_7B97_9C7C_7AFF_7ED3_679C, _____89E3_7ED1_9C7C_7AFF_6536_7AFF_76D1_542C, _____9C7C_7AFF_6536_7AFF_7ED3_7B97, _____5C1D_8BD5_9C7C_7AFF_6307_4EE4_6536_7AFF, ____on_9C7C_7AFF_7ACB_5373_6307_4EE4, ____on_9C7C_7AFF_70B9_6307_4EE4, ____on_9C7C_7AFF_76EE_6807_6307_4EE4, _____5904_7406_9C7C_7AFF_6536_7AFF_8D85_65F6, _____5904_7406_9C7C_7AFF_7B49_5F85_7ED3_675F, jass, jassGlobals, _____89E3_6790_914D_7F6E_5185_90E8ID, _____73A9_5BB6_4E3B_526F_80CC_5305_6301_6709_7269_54C1, ConsumeItemTypeCountByChargesBJ, _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168, YDUserDataSetSafe, _____521B_5EFA_7269_54C1_5E76_7ED9_4E88_5355_4F4D, createTimedEffect, _____4E24_70B9_89D2_5EA6, _____505C_6B62_5355_4F4D_5145_80FD, unregisterImmediateOrderListener, unregisterPointOrderListener, unregisterTargetOrderListener, addDelayedCallback, questDB, QuestStatus, _____7C73_4E9A_4EFB_52A1ID, GetHeroLevel, IsUnitType, GetOwningPlayer, GetUnitX, GetUnitY, GetRandomInt, SetUnitPosition, DisplayTimedTextToPlayer, Player, PLAYER_NEUTRAL_AGGRESSIVE, PLAYER_NEUTRAL_PASSIVE, _____672C_5730_91CD_590D_5237_65B0_6807_8BB0, _____9690_85CF_906D_9047_5DF2_89E6_53D1, _____5F53_524D_9C7C_7AFF_7B49_5F85, _____672C_6B21_6536_7AFF_5355_4F4D, _____6536_7AFF_76D1_542C_5DF2_6CE8_518C
local ____00_FF0E_9C7C_7AFF_914D_7F6E = require("系统.03．技能系统.04．快捷键技能.06．鱼竿.00．鱼竿配置")
local _____9C7C_7AFF_914D_7F6E = ____00_FF0E_9C7C_7AFF_914D_7F6E["鱼竿配置"]
local ____00A_FF0E_9493_70B9_533A_57DF_914D_7F6E = require("系统.03．技能系统.04．快捷键技能.06．鱼竿.00A．钓点区域配置")
local _____9493_70B9_533A_57DF_914D_7F6E_8868 = ____00A_FF0E_9493_70B9_533A_57DF_914D_7F6E["钓点区域配置表"]
local _____9493_70B9_9C7C_6C60_914D_7F6E_8868 = ____00A_FF0E_9493_70B9_533A_57DF_914D_7F6E["钓点鱼池配置表"]
local _____7CBE_7075_57CE_6C34_6C60_952E = ____00A_FF0E_9493_70B9_533A_57DF_914D_7F6E["精灵城水池键"]
local _____7194_6D46_9493_70B9_952E = ____00A_FF0E_9493_70B9_533A_57DF_914D_7F6E["熔浆钓点键"]
local _____7C73_4E9A_6C61_67D3_6C60_952E = ____00A_FF0E_9493_70B9_533A_57DF_914D_7F6E["米亚污染池键"]
local _____7C73_4E9A_51C0_6C34_6C60_952E = ____00A_FF0E_9493_70B9_533A_57DF_914D_7F6E["米亚净水池键"]
function _____533A_95F4_547D_4E2D(_____968F_673A_503C, _____6700_5C0F_503C, _____6700_5927_503C)
    return _____968F_673A_503C >= _____6700_5C0F_503C and _____968F_673A_503C <= _____6700_5927_503C
end
function _____70B9_5728_9493_70B9_77E9_5F62_5185(_____533A_57DF, x, y)
    return x >= _____533A_57DF["左"] and x <= _____533A_57DF["右"] and y >= _____533A_57DF["下"] and y <= _____533A_57DF["上"]
end
function _____53D6_9493_70B9_533A_57DF(x, y)
    do
        local i = 0
        while i < #_____9493_70B9_533A_57DF_914D_7F6E_8868 do
            local _____533A_57DF = _____9493_70B9_533A_57DF_914D_7F6E_8868[i + 1]
            if _____70B9_5728_9493_70B9_77E9_5F62_5185(_____533A_57DF, x, y) then
                return _____533A_57DF
            end
            i = i + 1
        end
    end
    return nil
end
function _____7C73_4E9A_6C34_6E90_5DF2_51C0_5316()
    local _____72B6_6001 = questDB:getPlayerQuestStatus(
        0,
        tostring(_____7C73_4E9A_4EFB_52A1ID)
    )
    return _____72B6_6001 == QuestStatus.COMPLETED
end
function _____53D6_9493_70B9_9C7C_6C60(_____533A_57DF)
    if _____533A_57DF["键"] == _____7CBE_7075_57CE_6C34_6C60_952E then
        local _____6C60_952E = _____7C73_4E9A_6C34_6E90_5DF2_51C0_5316() and _____7C73_4E9A_51C0_6C34_6C60_952E or _____7C73_4E9A_6C61_67D3_6C60_952E
        return _____9493_70B9_9C7C_6C60_914D_7F6E_8868[_____6C60_952E] or ({})
    end
    return _____9493_70B9_9C7C_6C60_914D_7F6E_8868[_____533A_57DF["键"]] or ({})
end
function _____6620_5C04_56DE_843D_503C(_____968F_673A_503C, _____6700_5C0F_503C, _____6700_5927_503C)
    local _____8DE8_5EA6 = _____6700_5927_503C - _____6700_5C0F_503C + 1
    if _____8DE8_5EA6 <= 0 then
        return 1
    end
    local _____6620_5C04_503C = math.floor((_____968F_673A_503C - _____6700_5C0F_503C) * 100 / _____8DE8_5EA6) + 1
    if _____6620_5C04_503C < 1 then
        return 1
    end
    if _____6620_5C04_503C > 100 then
        return 100
    end
    return _____6620_5C04_503C
end
function _____8BFB_53D6_91CD_590D_5237_65B0_6807_8BB0(_____7D22_5F15)
    local _____5916_90E8_6807_8BB0_8868 = jassGlobals.udg_WYDW
    if _____5916_90E8_6807_8BB0_8868 ~= nil then
        local _____5916_90E8_6807_8BB0 = _____5916_90E8_6807_8BB0_8868[_____7D22_5F15]
        if _____5916_90E8_6807_8BB0 ~= nil then
            return _____5916_90E8_6807_8BB0 > 0
        end
    end
    return _____672C_5730_91CD_590D_5237_65B0_6807_8BB0[_____7D22_5F15] == true
end
function _____5199_5165_91CD_590D_5237_65B0_6807_8BB0(_____7D22_5F15)
    _____672C_5730_91CD_590D_5237_65B0_6807_8BB0[_____7D22_5F15] = true
    local _____5916_90E8_6807_8BB0_8868 = jassGlobals.udg_WYDW
    if _____5916_90E8_6807_8BB0_8868 ~= nil then
        _____5916_90E8_6807_8BB0_8868[_____7D22_5F15] = 1
    end
end
function _____8BFB_53D6_5355_4F4D_7ED3_679C_6240_6709_8005(_____6240_6709_8005)
    if _____6240_6709_8005 == "中立敌对" then
        return Player(PLAYER_NEUTRAL_AGGRESSIVE)
    end
    if _____6240_6709_8005 == "中立被动" then
        return Player(PLAYER_NEUTRAL_PASSIVE)
    end
    return Player(6)
end
function _____82F1_96C4_7B49_7EA7_6EE1_8DB3(_____914D_7F6E, _____82F1_96C4_7B49_7EA7)
    if _____914D_7F6E["最高英雄等级"] ~= nil and _____82F1_96C4_7B49_7EA7 > _____914D_7F6E["最高英雄等级"] then
        return false
    end
    if _____914D_7F6E["最低英雄等级"] ~= nil and _____82F1_96C4_7B49_7EA7 <= _____914D_7F6E["最低英雄等级"] then
        return false
    end
    return true
end
function _____521B_5EFA_9C7C_7AFF_5355_4F4D_7ED3_679C(_____65BD_6CD5_5355_4F4D, _____76EE_6807X, _____76EE_6807Y, _____914D_7F6E)
    if _____914D_7F6E["重复刷新标记索引"] ~= nil and _____8BFB_53D6_91CD_590D_5237_65B0_6807_8BB0(_____914D_7F6E["重复刷新标记索引"]) then
        return nil
    end
    local _____4F7F_7528_76EE_6807_70B9 = _____914D_7F6E["使用目标点"] == true
    local _____521B_5EFAX = _____4F7F_7528_76EE_6807_70B9 and _____76EE_6807X or _____914D_7F6E["创建X"]
    local _____521B_5EFAY = _____4F7F_7528_76EE_6807_70B9 and _____76EE_6807Y or _____914D_7F6E["创建Y"]
    local _____9762_5411_89D2_5EA6 = _____4F7F_7528_76EE_6807_70B9 and _____4E24_70B9_89D2_5EA6(
        _____76EE_6807X,
        _____76EE_6807Y,
        GetUnitX(_____65BD_6CD5_5355_4F4D),
        GetUnitY(_____65BD_6CD5_5355_4F4D)
    ) or _____914D_7F6E["创建面向角度"]
    local _____5355_4F4D_7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID(_____914D_7F6E["单位ID"])
    if _____5355_4F4D_7C7B_578BID == 0 then
        return nil
    end
    local _____5355_4F4D = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        _____8BFB_53D6_5355_4F4D_7ED3_679C_6240_6709_8005(_____914D_7F6E["所有者"]),
        _____5355_4F4D_7C7B_578BID,
        _____521B_5EFAX,
        _____521B_5EFAY,
        _____9762_5411_89D2_5EA6
    )
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    if _____914D_7F6E["魔抗"] ~= nil then
        YDUserDataSetSafe(
            "unit",
            _____5355_4F4D,
            "魔抗",
            "real",
            _____914D_7F6E["魔抗"]
        )
    end
    if _____914D_7F6E["重复刷新标记索引"] ~= nil then
        _____5199_5165_91CD_590D_5237_65B0_6807_8BB0(_____914D_7F6E["重复刷新标记索引"])
    end
    if _____914D_7F6E["是否把施法者移动到创建点"] == true and _____914D_7F6E["施法者移动X"] ~= nil and _____914D_7F6E["施法者移动Y"] ~= nil then
        SetUnitPosition(_____65BD_6CD5_5355_4F4D, _____914D_7F6E["施法者移动X"], _____914D_7F6E["施法者移动Y"])
    end
    return _____5355_4F4D
end
function _____5904_7406_9690_85CF_906D_9047(_____65BD_6CD5_5355_4F4D, _____533A_57DF, _____76EE_6807X, _____76EE_6807Y)
    local _____914D_7F6E = _____9C7C_7AFF_914D_7F6E["隐藏遭遇"]
    if _____914D_7F6E == nil then
        return false
    end
    if _____533A_57DF["键"] ~= _____7194_6D46_9493_70B9_952E then
        return false
    end
    if _____914D_7F6E["整局仅一次"] == true and _____9690_85CF_906D_9047_5DF2_89E6_53D1 then
        return false
    end
    local _____6750_6599_7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID(_____914D_7F6E["要求材料物品ID"])
    if _____6750_6599_7C7B_578BID == 0 then
        return false
    end
    if not _____73A9_5BB6_4E3B_526F_80CC_5305_6301_6709_7269_54C1(_____65BD_6CD5_5355_4F4D, _____6750_6599_7C7B_578BID) then
        return false
    end
    if not ConsumeItemTypeCountByChargesBJ(_____65BD_6CD5_5355_4F4D, _____6750_6599_7C7B_578BID, _____914D_7F6E["消耗数量"]) then
        return false
    end
    _____9690_85CF_906D_9047_5DF2_89E6_53D1 = true
    local _____5355_4F4D_7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID(_____914D_7F6E["产出单位ID"])
    if _____5355_4F4D_7C7B_578BID ~= 0 then
        local _____9762_5411_89D2_5EA6 = _____4E24_70B9_89D2_5EA6(
            _____76EE_6807X,
            _____76EE_6807Y,
            GetUnitX(_____65BD_6CD5_5355_4F4D),
            GetUnitY(_____65BD_6CD5_5355_4F4D)
        )
        _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
            _____8BFB_53D6_5355_4F4D_7ED3_679C_6240_6709_8005("中立敌对"),
            _____5355_4F4D_7C7B_578BID,
            _____76EE_6807X,
            _____76EE_6807Y,
            _____9762_5411_89D2_5EA6
        )
    end
    createTimedEffect(
        _____9C7C_7AFF_914D_7F6E["成功特效路径"],
        _____76EE_6807X,
        _____76EE_6807Y,
        0,
        _____9C7C_7AFF_914D_7F6E["成功特效持续秒"]
    )
    _____663E_793A_9C7C_7AFF_63D0_793A(_____65BD_6CD5_5355_4F4D, _____914D_7F6E["触发提示"])
    return true
end
function _____663E_793A_9C7C_7AFF_63D0_793A(_____65BD_6CD5_5355_4F4D, _____6587_672C)
    local _____73A9_5BB6 = GetOwningPlayer(_____65BD_6CD5_5355_4F4D)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    DisplayTimedTextToPlayer(
        _____73A9_5BB6,
        0,
        0,
        5,
        "|cFFFFFF00『系统提示』：|r" .. _____6587_672C
    )
end
function _____663E_793A_9C7C_7AFF_5931_8D25(_____65BD_6CD5_5355_4F4D)
    _____663E_793A_9C7C_7AFF_63D0_793A(_____65BD_6CD5_5355_4F4D, _____9C7C_7AFF_914D_7F6E["失败提示"])
end
function _____9C7C_7AFF_6536_7AFF_6807_8BB0_6E05_9664()
    _____672C_6B21_6536_7AFF_5355_4F4D = nil
end
function _____7ED3_7B97_901A_7528_7ED3_679C(_____65BD_6CD5_5355_4F4D, _____968F_673A_503C, _____76EE_6807X, _____76EE_6807Y, _____542B_5355_4F4D_7ED3_679C)
    if _____968F_673A_503C <= 5 then
        _____663E_793A_9C7C_7AFF_5931_8D25(_____65BD_6CD5_5355_4F4D)
        return
    end
    createTimedEffect(
        _____9C7C_7AFF_914D_7F6E["成功特效路径"],
        _____76EE_6807X,
        _____76EE_6807Y,
        0,
        _____9C7C_7AFF_914D_7F6E["成功特效持续秒"]
    )
    do
        local i = 0
        while i < #_____9C7C_7AFF_914D_7F6E["物品结果列表"] do
            do
                local _____7ED3_679C = _____9C7C_7AFF_914D_7F6E["物品结果列表"][i + 1]
                if not _____533A_95F4_547D_4E2D(_____968F_673A_503C, _____7ED3_679C["随机最小值"], _____7ED3_679C["随机最大值"]) then
                    goto __continue49
                end
                local _____7269_54C1_7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID(_____7ED3_679C["物品ID"])
                if _____7269_54C1_7C7B_578BID ~= 0 then
                    _____521B_5EFA_7269_54C1_5E76_7ED9_4E88_5355_4F4D(_____65BD_6CD5_5355_4F4D, _____7269_54C1_7C7B_578BID)
                end
                break
            end
            ::__continue49::
            i = i + 1
        end
    end
    if not _____542B_5355_4F4D_7ED3_679C then
        return
    end
    local _____82F1_96C4_7B49_7EA7 = GetHeroLevel(_____65BD_6CD5_5355_4F4D)
    do
        local i = 0
        while i < #_____9C7C_7AFF_914D_7F6E["单位结果列表"] do
            do
                local _____7ED3_679C = _____9C7C_7AFF_914D_7F6E["单位结果列表"][i + 1]
                if not _____533A_95F4_547D_4E2D(_____968F_673A_503C, _____7ED3_679C["随机最小值"], _____7ED3_679C["随机最大值"]) then
                    goto __continue54
                end
                if not _____82F1_96C4_7B49_7EA7_6EE1_8DB3(_____7ED3_679C, _____82F1_96C4_7B49_7EA7) then
                    goto __continue54
                end
                _____521B_5EFA_9C7C_7AFF_5355_4F4D_7ED3_679C(_____65BD_6CD5_5355_4F4D, _____76EE_6807X, _____76EE_6807Y, _____7ED3_679C)
            end
            ::__continue54::
            i = i + 1
        end
    end
end
function _____7ED3_7B97_9493_70B9_4EA7_7269(_____65BD_6CD5_5355_4F4D, _____533A_57DF, _____968F_673A_503C, _____76EE_6807X, _____76EE_6807Y)
    if _____5904_7406_9690_85CF_906D_9047(_____65BD_6CD5_5355_4F4D, _____533A_57DF, _____76EE_6807X, _____76EE_6807Y) then
        return
    end
    local _____6863_5217_8868 = _____53D6_9493_70B9_9C7C_6C60(_____533A_57DF)
    do
        local i = 0
        while i < #_____6863_5217_8868 do
            do
                local _____6863 = _____6863_5217_8868[i + 1]
                if not _____533A_95F4_547D_4E2D(_____968F_673A_503C, _____6863["随机最小值"], _____6863["随机最大值"]) then
                    goto __continue60
                end
                if _____6863["物品ID"] == nil then
                    local _____56DE_843D_503C = _____6620_5C04_56DE_843D_503C(_____968F_673A_503C, _____6863["随机最小值"], _____6863["随机最大值"])
                    _____7ED3_7B97_901A_7528_7ED3_679C(
                        _____65BD_6CD5_5355_4F4D,
                        _____56DE_843D_503C,
                        _____76EE_6807X,
                        _____76EE_6807Y,
                        false
                    )
                    return
                end
                createTimedEffect(
                    _____9C7C_7AFF_914D_7F6E["成功特效路径"],
                    _____76EE_6807X,
                    _____76EE_6807Y,
                    0,
                    _____9C7C_7AFF_914D_7F6E["成功特效持续秒"]
                )
                local _____7269_54C1_7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID(_____6863["物品ID"])
                if _____7269_54C1_7C7B_578BID ~= 0 then
                    _____521B_5EFA_7269_54C1_5E76_7ED9_4E88_5355_4F4D(_____65BD_6CD5_5355_4F4D, _____7269_54C1_7C7B_578BID)
                end
                return
            end
            ::__continue60::
            i = i + 1
        end
    end
end
function _____7ED3_7B97_9C7C_7AFF_7ED3_679C(_____65BD_6CD5_5355_4F4D, _____76EE_6807X, _____76EE_6807Y)
    local _____968F_673A_503C = GetRandomInt(_____9C7C_7AFF_914D_7F6E["随机最小值"], _____9C7C_7AFF_914D_7F6E["随机最大值"])
    local _____533A_57DF = _____53D6_9493_70B9_533A_57DF(_____76EE_6807X, _____76EE_6807Y)
    if _____533A_57DF ~= nil then
        _____7ED3_7B97_9493_70B9_4EA7_7269(
            _____65BD_6CD5_5355_4F4D,
            _____533A_57DF,
            _____968F_673A_503C,
            _____76EE_6807X,
            _____76EE_6807Y
        )
        return
    end
    _____7ED3_7B97_901A_7528_7ED3_679C(
        _____65BD_6CD5_5355_4F4D,
        _____968F_673A_503C,
        _____76EE_6807X,
        _____76EE_6807Y,
        true
    )
end
function _____89E3_7ED1_9C7C_7AFF_6536_7AFF_76D1_542C()
    if not _____6536_7AFF_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____6536_7AFF_76D1_542C_5DF2_6CE8_518C = false
    unregisterImmediateOrderListener(____on_9C7C_7AFF_7ACB_5373_6307_4EE4)
    unregisterPointOrderListener(____on_9C7C_7AFF_70B9_6307_4EE4)
    unregisterTargetOrderListener(____on_9C7C_7AFF_76EE_6807_6307_4EE4)
end
function _____9C7C_7AFF_6536_7AFF_7ED3_7B97(_____4F1A_8BDD)
    _____89E3_7ED1_9C7C_7AFF_6536_7AFF_76D1_542C()
    _____5F53_524D_9C7C_7AFF_7B49_5F85 = nil
    _____672C_6B21_6536_7AFF_5355_4F4D = _____4F1A_8BDD["施法者"]
    addDelayedCallback(200, _____9C7C_7AFF_6536_7AFF_6807_8BB0_6E05_9664)
    _____505C_6B62_5355_4F4D_5145_80FD(_____4F1A_8BDD["施法者"])
    _____7ED3_7B97_9C7C_7AFF_7ED3_679C(_____4F1A_8BDD["施法者"], _____4F1A_8BDD["目标X"], _____4F1A_8BDD["目标Y"])
end
function _____5C1D_8BD5_9C7C_7AFF_6307_4EE4_6536_7AFF(_____5355_4F4D)
    local _____4F1A_8BDD = _____5F53_524D_9C7C_7AFF_7B49_5F85
    if _____4F1A_8BDD == nil or _____4F1A_8BDD["阶段"] ~= "收竿" or _____4F1A_8BDD["施法者"] ~= _____5355_4F4D then
        return
    end
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or IsUnitType(_____5355_4F4D, jass.UNIT_TYPE_DEAD) then
        return
    end
    _____9C7C_7AFF_6536_7AFF_7ED3_7B97(_____4F1A_8BDD)
end
function ____on_9C7C_7AFF_7ACB_5373_6307_4EE4(_____5355_4F4D, _orderId)
    _____5C1D_8BD5_9C7C_7AFF_6307_4EE4_6536_7AFF(_____5355_4F4D)
end
function ____on_9C7C_7AFF_70B9_6307_4EE4(_____5355_4F4D, _orderId, _x, _y)
    _____5C1D_8BD5_9C7C_7AFF_6307_4EE4_6536_7AFF(_____5355_4F4D)
end
function ____on_9C7C_7AFF_76EE_6807_6307_4EE4(_____5355_4F4D, _orderId, _targetUnit, _targetItem, _targetDestructable)
    _____5C1D_8BD5_9C7C_7AFF_6307_4EE4_6536_7AFF(_____5355_4F4D)
end
function _____5904_7406_9C7C_7AFF_6536_7AFF_8D85_65F6(______65BD_6CD5_5355_4F4D, _____5145_80FDID)
    local _____4F1A_8BDD = _____5F53_524D_9C7C_7AFF_7B49_5F85
    if _____4F1A_8BDD == nil or _____4F1A_8BDD["充能ID"] ~= _____5145_80FDID or _____4F1A_8BDD["阶段"] ~= "收竿" then
        return
    end
    _____5F53_524D_9C7C_7AFF_7B49_5F85 = nil
    _____89E3_7ED1_9C7C_7AFF_6536_7AFF_76D1_542C()
    if _____4F1A_8BDD["施法者"] == nil or _____4F1A_8BDD["施法者"] == 0 then
        return
    end
    if not IsUnitType(_____4F1A_8BDD["施法者"], jass.UNIT_TYPE_DEAD) then
        _____663E_793A_9C7C_7AFF_63D0_793A(_____4F1A_8BDD["施法者"], _____9C7C_7AFF_914D_7F6E["收竿超时提示"])
    end
end
function _____5904_7406_9C7C_7AFF_7B49_5F85_7ED3_675F(______65BD_6CD5_5355_4F4D, _____539F_56E0, _____5145_80FDID)
    local _____4F1A_8BDD = _____5F53_524D_9C7C_7AFF_7B49_5F85
    if _____4F1A_8BDD == nil or _____4F1A_8BDD["充能ID"] ~= _____5145_80FDID then
        return
    end
    _____5F53_524D_9C7C_7AFF_7B49_5F85 = nil
    if _____4F1A_8BDD["阶段"] == "收竿" then
        _____89E3_7ED1_9C7C_7AFF_6536_7AFF_76D1_542C()
        if _____539F_56E0 == "中断" and _____4F1A_8BDD["施法者"] ~= nil and _____4F1A_8BDD["施法者"] ~= 0 and not IsUnitType(_____4F1A_8BDD["施法者"], jass.UNIT_TYPE_DEAD) then
            _____663E_793A_9C7C_7AFF_63D0_793A(_____4F1A_8BDD["施法者"], _____9C7C_7AFF_914D_7F6E["收竿超时提示"])
        end
    end
end
jass = require("jass.common")
jassGlobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.13．物品技能事件中心")
local _____6CE8_518C_7269_54C1_6280_80FD_4E8B_4EF6_76D1_542C = ____require_result_0["注册物品技能事件监听"]
local ____require_result_1 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
_____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_1["解析配置内部ID"]
local ____require_result_2 = require("系统.03．技能系统.04．快捷键技能.02．按Ctrl切换背包")
_____73A9_5BB6_4E3B_526F_80CC_5305_6301_6709_7269_54C1 = ____require_result_2["玩家主副背包持有物品"]
local ____require_result_3 = require("lib.扩展函数.物品相关函数.物品判断函数")
ConsumeItemTypeCountByChargesBJ = ____require_result_3.ConsumeItemTypeCountByChargesBJ
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
_____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_4["创建单位并登记排泄安全"]
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDUserDataSetSafe = ____require_result_5.YDUserDataSetSafe
local ____require_result_6 = require("lib.扩展函数.物品相关函数.index")
_____521B_5EFA_7269_54C1_5E76_7ED9_4E88_5355_4F4D = ____require_result_6["创建物品并给予单位"]
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
createTimedEffect = ____require_result_7.createTimedEffect
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
_____4E24_70B9_89D2_5EA6 = ____require_result_8["两点角度"]
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_9["开始充能"]
_____505C_6B62_5355_4F4D_5145_80FD = ____require_result_9["停止单位充能"]
local ____require_result_10 = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心")
local registerImmediateOrderListener = ____require_result_10.registerImmediateOrderListener
local registerPointOrderListener = ____require_result_10.registerPointOrderListener
local registerTargetOrderListener = ____require_result_10.registerTargetOrderListener
unregisterImmediateOrderListener = ____require_result_10.unregisterImmediateOrderListener
unregisterPointOrderListener = ____require_result_10.unregisterPointOrderListener
unregisterTargetOrderListener = ____require_result_10.unregisterTargetOrderListener
local ____require_result_11 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_11.addDelayedCallback
local ____require_result_12 = require("系统.08．任务系统.01．任务数据")
questDB = ____require_result_12.questDB
QuestStatus = ____require_result_12.QuestStatus
local ____require_result_13 = require("系统.11．剧情系统.02．支线任务.02．污染之猫米亚.00．常量")
_____7C73_4E9A_4EFB_52A1ID = ____require_result_13["米亚任务ID"]
GetHeroLevel = jass.GetHeroLevel
IsUnitType = jass.IsUnitType
GetOwningPlayer = jass.GetOwningPlayer
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local GetItemTypeId = jass.GetItemTypeId
local IsTerrainPathable = jass.IsTerrainPathable
GetRandomInt = jass.GetRandomInt
SetUnitPosition = jass.SetUnitPosition
DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
Player = jass.Player
PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY
local PATHING_TYPE_FLOATABILITY = jass.PATHING_TYPE_FLOATABILITY
local _____9C7C_7AFF_6280_80FD_7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID(_____9C7C_7AFF_914D_7F6E["技能ID"])
--- 熔浆钓点专属鱼竿的物品类型ID；用物品技能事件带出的物品与之比对。
local _____7194_5CA9_4E13_5C5E_9C7C_7AFF_7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID(_____9C7C_7AFF_914D_7F6E["熔岩专属鱼竿物品ID"])
_____672C_5730_91CD_590D_5237_65B0_6807_8BB0 = {}
local _____5DF2_521D_59CB_5316_9C7C_7AFF = false
local function _____662F_9C7C_7AFF_76EE_6807_6C34_57DF(x, y)
    local _____884C_8D70_4E0D_53EF_901A_884C = IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
    local _____6F02_6D6E_53EF_901A_884C = not IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY)
    return _____884C_8D70_4E0D_53EF_901A_884C == _____9C7C_7AFF_914D_7F6E["行走不可通行"] and _____6F02_6D6E_53EF_901A_884C == _____9C7C_7AFF_914D_7F6E["漂浮可通行"]
end
_____9690_85CF_906D_9047_5DF2_89E6_53D1 = false
_____5F53_524D_9C7C_7AFF_7B49_5F85 = nil
_____672C_6B21_6536_7AFF_5355_4F4D = nil
_____6536_7AFF_76D1_542C_5DF2_6CE8_518C = false
local function _____7ED1_5B9A_9C7C_7AFF_6536_7AFF_76D1_542C()
    if _____6536_7AFF_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____6536_7AFF_76D1_542C_5DF2_6CE8_518C = true
    registerImmediateOrderListener(____on_9C7C_7AFF_7ACB_5373_6307_4EE4)
    registerPointOrderListener(____on_9C7C_7AFF_70B9_6307_4EE4)
    registerTargetOrderListener(____on_9C7C_7AFF_76EE_6807_6307_4EE4)
end
local function _____5904_7406_9C7C_7AFF_54AC_94A9(______65BD_6CD5_5355_4F4D, _____5145_80FDID)
    local _____4F1A_8BDD = _____5F53_524D_9C7C_7AFF_7B49_5F85
    if _____4F1A_8BDD == nil or _____4F1A_8BDD["充能ID"] ~= _____5145_80FDID or _____4F1A_8BDD["阶段"] ~= "等待" then
        return
    end
    if _____4F1A_8BDD["施法者"] == nil or _____4F1A_8BDD["施法者"] == 0 or IsUnitType(_____4F1A_8BDD["施法者"], jass.UNIT_TYPE_DEAD) then
        _____5F53_524D_9C7C_7AFF_7B49_5F85 = nil
        return
    end
    _____4F1A_8BDD["阶段"] = "收竿"
    local _____6536_7AFF_5145_80FDID = _____5F00_59CB_5145_80FD(_____4F1A_8BDD["施法者"], {
        ["持续时间"] = _____9C7C_7AFF_914D_7F6E["收竿窗口毫秒"] / 1000,
        ["指令中断"] = false,
        ["硬控中断"] = true,
        ["显示进度条特效"] = false,
        ["世界坐标进度UI"] = true,
        ["世界坐标进度UI标题"] = _____9C7C_7AFF_914D_7F6E["收竿窗口UI标题"],
        ["世界坐标进度UI类型"] = _____9C7C_7AFF_914D_7F6E["等待窗口UI类型"],
        ["充能完成回调"] = _____5904_7406_9C7C_7AFF_6536_7AFF_8D85_65F6,
        ["结束回调"] = _____5904_7406_9C7C_7AFF_7B49_5F85_7ED3_675F
    })
    if _____6536_7AFF_5145_80FDID <= 0 then
        _____5F53_524D_9C7C_7AFF_7B49_5F85 = nil
        return
    end
    _____4F1A_8BDD["充能ID"] = _____6536_7AFF_5145_80FDID
    _____7ED1_5B9A_9C7C_7AFF_6536_7AFF_76D1_542C()
end
--- 鱼竿入口：走「物品技能事件」而不是裸 SPELL_EFFECT。
-- 
-- 该事件天然同时携带**物品**（来自 `GetManipulatedItem()`）与**技能ID**（事件中心在
-- SPELL_EFFECT 阶段按施法者缓存后补上），目标坐标也是当时即时捕获的。
-- 于是"用的是哪根鱼竿"无需扫描背包即可判定 —— 这正是熔岩专属鱼竿的天然判据。
local function _____5904_7406_9C7C_7AFF_7269_54C1_6280_80FD(_____4E0A_4E0B_6587)
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    local _____65BD_6CD5_5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
        return
    end
    if _____4E0A_4E0B_6587["技能ID"] ~= _____9C7C_7AFF_6280_80FD_7C7B_578BID then
        return
    end
    if _____672C_6B21_6536_7AFF_5355_4F4D ~= nil and _____672C_6B21_6536_7AFF_5355_4F4D == _____65BD_6CD5_5355_4F4D then
        return
    end
    local _____76EE_6807X = _____4E0A_4E0B_6587["目标X"]
    local _____76EE_6807Y = _____4E0A_4E0B_6587["目标Y"]
    local _____533A_57DF = _____53D6_9493_70B9_533A_57DF(_____76EE_6807X, _____76EE_6807Y)
    if _____533A_57DF == nil and not _____662F_9C7C_7AFF_76EE_6807_6C34_57DF(_____76EE_6807X, _____76EE_6807Y) then
        return
    end
    if _____533A_57DF ~= nil and _____533A_57DF["键"] == _____7194_6D46_9493_70B9_952E then
        if GetItemTypeId(_____4E0A_4E0B_6587["物品"]) ~= _____7194_5CA9_4E13_5C5E_9C7C_7AFF_7C7B_578BID then
            _____663E_793A_9C7C_7AFF_63D0_793A(_____65BD_6CD5_5355_4F4D, _____9C7C_7AFF_914D_7F6E["熔岩专属鱼竿提示"])
            return
        end
    end
    local _____7B49_5F85_6BEB_79D2 = GetRandomInt(_____9C7C_7AFF_914D_7F6E["等待窗口毫秒最小值"], _____9C7C_7AFF_914D_7F6E["等待窗口毫秒最大值"])
    if _____7B49_5F85_6BEB_79D2 <= 0 then
        return
    end
    _____505C_6B62_5355_4F4D_5145_80FD(_____65BD_6CD5_5355_4F4D)
    local _____5145_80FDID = _____5F00_59CB_5145_80FD(_____65BD_6CD5_5355_4F4D, {
        ["持续时间"] = _____7B49_5F85_6BEB_79D2 / 1000,
        ["指令中断"] = true,
        ["显示进度条特效"] = false,
        ["世界坐标进度UI"] = true,
        ["世界坐标进度UI标题"] = _____9C7C_7AFF_914D_7F6E["等待窗口UI标题"],
        ["世界坐标进度UI类型"] = _____9C7C_7AFF_914D_7F6E["等待窗口UI类型"],
        ["充能完成回调"] = _____5904_7406_9C7C_7AFF_54AC_94A9,
        ["结束回调"] = _____5904_7406_9C7C_7AFF_7B49_5F85_7ED3_675F
    })
    if _____5145_80FDID > 0 then
        _____5F53_524D_9C7C_7AFF_7B49_5F85 = {
            ["施法者"] = _____65BD_6CD5_5355_4F4D,
            ["目标X"] = _____76EE_6807X,
            ["目标Y"] = _____76EE_6807Y,
            ["充能ID"] = _____5145_80FDID,
            ["阶段"] = "等待"
        }
    end
end
____exports["init鱼竿"] = function()
    if _____5DF2_521D_59CB_5316_9C7C_7AFF then
        return
    end
    _____5DF2_521D_59CB_5316_9C7C_7AFF = true
    _____6CE8_518C_7269_54C1_6280_80FD_4E8B_4EF6_76D1_542C(_____5904_7406_9C7C_7AFF_7269_54C1_6280_80FD)
end
return ____exports
