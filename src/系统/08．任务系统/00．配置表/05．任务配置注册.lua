local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__StringSplit = ____lualib.__TS__StringSplit
local ____exports = {}
local ____00_FF0EYDWE_51FD_6570 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local getObjectProperty = ____00_FF0EYDWE_51FD_6570.getObjectProperty
local ObjectType = ____00_FF0EYDWE_51FD_6570.ObjectType
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local QuestStatus = ____01_FF0E_4EFB_52A1_6570_636E.QuestStatus
local _____5956_52B1_76EE_6807_524D_7F00_5217_8868 = {"所有玩家", "完成任务的玩家", "Player"}
local function _____53BB_9664_5956_52B1_76EE_6807_524D_7F00(_____539F_6587)
    local _____6587_672C = __TS__StringTrim(_____539F_6587)
    for ____, _____524D_7F00 in ipairs(_____5956_52B1_76EE_6807_524D_7F00_5217_8868) do
        do
            if (string.find(_____6587_672C, _____524D_7F00, nil, true) or 0) - 1 ~= 0 then
                goto __continue3
            end
            _____6587_672C = __TS__StringTrim(__TS__StringSubstring(_____6587_672C, #_____524D_7F00))
            while string.sub(_____6587_672C, 1, 1) == "+" or string.sub(_____6587_672C, 1, 1) == "＋" do
                _____6587_672C = __TS__StringTrim(__TS__StringSubstring(_____6587_672C, 1))
            end
            break
        end
        ::__continue3::
    end
    return _____6587_672C
end
local function _____53BB_9664_5B8C_6574_5916_62EC_53F7(_____539F_6587)
    local _____6587_672C = __TS__StringTrim(_____539F_6587)
    if #_____6587_672C >= 2 and string.sub(_____6587_672C, 1, 1) == "(" and __TS__StringCharAt(_____6587_672C, #_____6587_672C - 1) == ")" then
        return __TS__StringTrim(__TS__StringSubstring(_____6587_672C, 1, #_____6587_672C - 1))
    end
    return _____6587_672C
end
local function _____67E5_627E_6700_540E_5B57_7B26_4F4D_7F6E(_____6587_672C, _____76EE_6807_5B57_7B26)
    do
        local i = #_____6587_672C - 1
        while i >= 0 do
            if __TS__StringCharAt(_____6587_672C, i) == _____76EE_6807_5B57_7B26 then
                return i
            end
            i = i - 1
        end
    end
    return -1
end
local function _____7FFB_8BD1_6570_503C_8868_8FBE_5F0F(_____539F_6587)
    local _____6587_672C = _____53BB_9664_5B8C_6574_5916_62EC_53F7(_____539F_6587)
    if (string.find(_____6587_672C, "IMaxBJ(", nil, true) or 0) - 1 == 0 then
        local _____9017_53F7_4F4D_7F6E = _____67E5_627E_6700_540E_5B57_7B26_4F4D_7F6E(_____6587_672C, ",")
        local _____53F3_62EC_53F7_4F4D_7F6E = _____67E5_627E_6700_540E_5B57_7B26_4F4D_7F6E(_____6587_672C, ")")
        if _____9017_53F7_4F4D_7F6E >= 0 and _____53F3_62EC_53F7_4F4D_7F6E > _____9017_53F7_4F4D_7F6E then
            return ("根据英雄等级计算（最低" .. __TS__StringTrim(__TS__StringSubstring(_____6587_672C, _____9017_53F7_4F4D_7F6E + 1, _____53F3_62EC_53F7_4F4D_7F6E))) .. "）"
        end
        return "根据英雄等级动态计算"
    end
    _____6587_672C = table.concat(
        __TS__StringSplit(_____6587_672C, "*"),
        "×"
    )
    _____6587_672C = table.concat(
        __TS__StringSplit(_____6587_672C, "等级"),
        "英雄等级"
    )
    _____6587_672C = table.concat(
        __TS__StringSplit(_____6587_672C, "英雄英雄等级"),
        "英雄等级"
    )
    _____6587_672C = table.concat(
        __TS__StringSplit(_____6587_672C, "(英雄等级)"),
        "英雄等级"
    )
    return _____6587_672C
end
local function _____63D0_53D6_5C5E_6027_5956_52B1_6570_503C(_____6587_672C, _____5C5E_6027_540D)
    local _____5C5E_6027_4F4D_7F6E = (string.find(_____6587_672C, _____5C5E_6027_540D, nil, true) or 0) - 1
    if _____5C5E_6027_4F4D_7F6E < 0 then
        return ""
    end
    local _____5C5E_6027_524D = __TS__StringTrim(__TS__StringSubstring(_____6587_672C, 0, _____5C5E_6027_4F4D_7F6E))
    local _____5C5E_6027_540E = __TS__StringTrim(__TS__StringSubstring(_____6587_672C, _____5C5E_6027_4F4D_7F6E + #_____5C5E_6027_540D))
    if _____5C5E_6027_524D ~= "" then
        return __TS__StringTrim(table.concat(
            __TS__StringSplit(_____5C5E_6027_524D, "%"),
            ""
        ))
    end
    local _____540E_6BB5 = _____5C5E_6027_540E
    while string.sub(_____540E_6BB5, 1, 1) == ":" or string.sub(_____540E_6BB5, 1, 1) == "+" or string.sub(_____540E_6BB5, 1, 1) == "＋" do
        _____540E_6BB5 = __TS__StringTrim(__TS__StringSubstring(_____540E_6BB5, 1))
    end
    return __TS__StringTrim(table.concat(
        __TS__StringSplit(_____540E_6BB5, "%"),
        ""
    ))
end
local function _____7FFB_8BD1_5355_6761_5956_52B1(_____539F_6587)
    local _____6587_672C = _____53BB_9664_5956_52B1_76EE_6807_524D_7F00(_____539F_6587)
    if _____6587_672C == "" or _____6587_672C == "null" then
        return ""
    end
    local _____767E_5206_6BD4_5C5E_6027 = {"金属性抗性", "魔法伤害", "暴击伤害", "暴击率"}
    for ____, _____5C5E_6027_540D in ipairs(_____767E_5206_6BD4_5C5E_6027) do
        do
            if (string.find(_____6587_672C, _____5C5E_6027_540D, nil, true) or 0) - 1 < 0 then
                goto __continue22
            end
            local _____6570_503C = _____63D0_53D6_5C5E_6027_5956_52B1_6570_503C(_____6587_672C, _____5C5E_6027_540D)
            return _____6570_503C ~= "" and ((_____5C5E_6027_540D .. "提升") .. _____7FFB_8BD1_6570_503C_8868_8FBE_5F0F(_____6570_503C)) .. "%" or _____5C5E_6027_540D .. "提升"
        end
        ::__continue22::
    end
    if (string.find(_____6587_672C, "智力成长", nil, true) or 0) - 1 >= 0 then
        local _____6570_503C = _____63D0_53D6_5C5E_6027_5956_52B1_6570_503C(_____6587_672C, "智力成长")
        return ("智力成长提升" .. _____7FFB_8BD1_6570_503C_8868_8FBE_5F0F(_____6570_503C)) .. "点"
    end
    local _____5347_7EA7_6240_9700_7ECF_9A8C_6807_8BB0 = "升级所需经验的"
    local _____5347_7EA7_6240_9700_7ECF_9A8C_4F4D_7F6E = (string.find(_____6587_672C, _____5347_7EA7_6240_9700_7ECF_9A8C_6807_8BB0, nil, true) or 0) - 1
    if _____5347_7EA7_6240_9700_7ECF_9A8C_4F4D_7F6E >= 0 then
        local _____767E_5206_6BD4_5F00_59CB = _____5347_7EA7_6240_9700_7ECF_9A8C_4F4D_7F6E + #_____5347_7EA7_6240_9700_7ECF_9A8C_6807_8BB0
        local _____767E_5206_53F7_4F4D_7F6E = (string.find(
            _____6587_672C,
            "%",
            math.max(_____767E_5206_6BD4_5F00_59CB + 1, 1),
            true
        ) or 0) - 1
        if _____767E_5206_53F7_4F4D_7F6E >= _____767E_5206_6BD4_5F00_59CB then
            return ("按当前英雄等级获得升级所需经验的" .. __TS__StringTrim(__TS__StringSubstring(_____6587_672C, _____767E_5206_6BD4_5F00_59CB, _____767E_5206_53F7_4F4D_7F6E))) .. "%"
        end
        return "按当前英雄等级获得升级所需经验"
    end
    local _____7ECF_9A8C_4F4D_7F6E = (string.find(_____6587_672C, "经验", nil, true) or 0) - 1
    if _____7ECF_9A8C_4F4D_7F6E >= 0 then
        local _____6570_503C = _____7FFB_8BD1_6570_503C_8868_8FBE_5F0F(__TS__StringSubstring(_____6587_672C, 0, _____7ECF_9A8C_4F4D_7F6E))
        if (string.find(_____6570_503C, "根据英雄等级计算", nil, true) or 0) - 1 == 0 then
            return "根据英雄等级获得经验（最低10000点）"
        end
        return _____6570_503C .. "点经验"
    end
    local _____91D1_5E01_4F4D_7F6E = (string.find(_____6587_672C, "金币", nil, true) or 0) - 1
    if _____91D1_5E01_4F4D_7F6E >= 0 then
        return _____7FFB_8BD1_6570_503C_8868_8FBE_5F0F(__TS__StringSubstring(_____6587_672C, 0, _____91D1_5E01_4F4D_7F6E)) .. "金币"
    end
    local _____80FD_91CF_788E_7247_4F4D_7F6E = (string.find(_____6587_672C, "能量碎片", nil, true) or 0) - 1
    if _____80FD_91CF_788E_7247_4F4D_7F6E >= 0 then
        return _____7FFB_8BD1_6570_503C_8868_8FBE_5F0F(__TS__StringSubstring(_____6587_672C, 0, _____80FD_91CF_788E_7247_4F4D_7F6E)) .. "枚能量碎片"
    end
    local _____653B_51FB_529B_4F4D_7F6E = (string.find(_____6587_672C, "攻击力", nil, true) or 0) - 1
    if _____653B_51FB_529B_4F4D_7F6E >= 0 then
        return ("攻击力提升" .. _____7FFB_8BD1_6570_503C_8868_8FBE_5F0F(__TS__StringSubstring(_____6587_672C, 0, _____653B_51FB_529B_4F4D_7F6E))) .. "点"
    end
    local _____57FA_7840_5C5E_6027_540D_5217_8868 = {"力量", "敏捷", "智力"}
    for ____, _____5C5E_6027_540D in ipairs(_____57FA_7840_5C5E_6027_540D_5217_8868) do
        do
            local _____5C5E_6027_4F4D_7F6E = (string.find(_____6587_672C, _____5C5E_6027_540D, nil, true) or 0) - 1
            if _____5C5E_6027_4F4D_7F6E < 0 then
                goto __continue33
            end
            return ((_____5C5E_6027_540D .. "提升") .. _____7FFB_8BD1_6570_503C_8868_8FBE_5F0F(__TS__StringSubstring(_____6587_672C, 0, _____5C5E_6027_4F4D_7F6E))) .. "点"
        end
        ::__continue33::
    end
    local _____7B49_7EA7_4F4D_7F6E = #_____6587_672C - #"等级"
    if _____7B49_7EA7_4F4D_7F6E > 0 and __TS__StringSubstring(_____6587_672C, _____7B49_7EA7_4F4D_7F6E) == "等级" then
        return ("英雄等级提升" .. _____7FFB_8BD1_6570_503C_8868_8FBE_5F0F(__TS__StringSubstring(_____6587_672C, 0, _____7B49_7EA7_4F4D_7F6E))) .. "级"
    end
    return _____6587_672C
end
local function _____8BFB_53D6_6761_4EF6_6570_5B57(_____6587_672C)
    local _____6570_5B57 = 0
    local _____5DF2_5F00_59CB = false
    do
        local i = 0
        while i < #_____6587_672C do
            local _____5B57_7B26 = __TS__StringCharAt(_____6587_672C, i)
            if _____5B57_7B26 >= "0" and _____5B57_7B26 <= "9" then
                _____5DF2_5F00_59CB = true
                _____6570_5B57 = _____6570_5B57 * 10 + (string.byte(_____5B57_7B26, 1) or 0 / 0) - 48
            elseif _____5DF2_5F00_59CB then
                break
            end
            i = i + 1
        end
    end
    return _____6570_5B57
end
local function _____7FFB_8BD1_5956_52B1_6761_4EF6(_____539F_6587)
    local _____6587_672C = __TS__StringTrim(_____539F_6587)
    local _____7B49_7EA7 = _____8BFB_53D6_6761_4EF6_6570_5B57(_____6587_672C)
    if (string.find(_____6587_672C, "英雄等级≤", nil, true) or 0) - 1 == 0 or (string.find(_____6587_672C, "英雄等级<=", nil, true) or 0) - 1 == 0 then
        return ("英雄等级" .. tostring(nil, _____7B49_7EA7)) .. "级及以下"
    end
    if (string.find(_____6587_672C, "英雄等级＞", nil, true) or 0) - 1 == 0 or (string.find(_____6587_672C, "英雄等级>", nil, true) or 0) - 1 == 0 then
        return ("英雄等级高于" .. tostring(nil, _____7B49_7EA7)) .. "级"
    end
    if (string.find(_____6587_672C, "装备等级", nil, true) or 0) - 1 == 0 then
        return "提交符合要求的装备时"
    end
    if (string.find(_____6587_672C, "|", nil, true) or 0) - 1 >= 0 and (string.find(_____6587_672C, "I", nil, true) or 0) - 1 >= 0 then
        return "提交指定珍贵物品时"
    end
    return _____6587_672C
end
local function _____662F_5426_5956_52B1_6761_4EF6_6587_672C(_____539F_6587)
    local _____6587_672C = __TS__StringTrim(_____539F_6587)
    if (string.find(_____6587_672C, "英雄等级", nil, true) or 0) - 1 == 0 then
        return true
    end
    if (string.find(_____6587_672C, "装备等级", nil, true) or 0) - 1 == 0 then
        return true
    end
    return (string.find(_____6587_672C, "|", nil, true) or 0) - 1 >= 0 and (string.find(_____6587_672C, "I", nil, true) or 0) - 1 >= 0
end
____exports["解析任务奖励展示文本"] = function(_____539F_6587)
    if not _____539F_6587 or _____539F_6587 == "" then
        return "无"
    end
    local _____8F93_51FA_884C = {}
    local _____539F_59CB_884C = __TS__StringSplit(_____539F_6587, "\n")
    for ____, _____884C_6587_672C in ipairs(_____539F_59CB_884C) do
        do
            local _____884C = __TS__StringTrim(_____884C_6587_672C)
            if _____884C == "" or _____884C == "外部：" or _____884C == "内部：" then
                goto __continue52
            end
            local _____5192_53F7_4F4D_7F6E = (string.find(_____884C, ":", nil, true) or 0) - 1
            if _____5192_53F7_4F4D_7F6E > 0 and _____662F_5426_5956_52B1_6761_4EF6_6587_672C(__TS__StringSubstring(_____884C, 0, _____5192_53F7_4F4D_7F6E)) then
                local _____6761_4EF6 = __TS__StringTrim(__TS__StringSubstring(_____884C, 0, _____5192_53F7_4F4D_7F6E))
                local _____5956_52B1_90E8_5206 = __TS__StringTrim(__TS__StringSubstring(_____884C, _____5192_53F7_4F4D_7F6E + 1))
                if _____5956_52B1_90E8_5206 == "" then
                    goto __continue52
                end
                local _____5956_52B1_5217_8868 = __TS__StringSplit(_____5956_52B1_90E8_5206, ";")
                local _____5C55_793A_5956_52B1 = {}
                for ____, _____5956_52B1 in ipairs(_____5956_52B1_5217_8868) do
                    local _____7ED3_679C = _____7FFB_8BD1_5355_6761_5956_52B1(_____5956_52B1)
                    if _____7ED3_679C ~= "" then
                        _____5C55_793A_5956_52B1[#_____5C55_793A_5956_52B1 + 1] = _____7ED3_679C
                    end
                end
                if #_____5C55_793A_5956_52B1 > 0 then
                    _____8F93_51FA_884C[#_____8F93_51FA_884C + 1] = (_____7FFB_8BD1_5956_52B1_6761_4EF6(_____6761_4EF6) .. "：") .. table.concat(_____5C55_793A_5956_52B1, "、")
                end
                goto __continue52
            end
            local _____5956_52B1_5217_8868 = __TS__StringSplit(_____884C, ";")
            local _____5C55_793A_5956_52B1 = {}
            for ____, _____5956_52B1 in ipairs(_____5956_52B1_5217_8868) do
                local _____7ED3_679C = _____7FFB_8BD1_5355_6761_5956_52B1(_____5956_52B1)
                if _____7ED3_679C ~= "" then
                    _____5C55_793A_5956_52B1[#_____5C55_793A_5956_52B1 + 1] = _____7ED3_679C
                end
            end
            if #_____5C55_793A_5956_52B1 > 0 then
                _____8F93_51FA_884C[#_____8F93_51FA_884C + 1] = table.concat(_____5C55_793A_5956_52B1, "、")
            end
        end
        ::__continue52::
    end
    return #_____8F93_51FA_884C > 0 and table.concat(_____8F93_51FA_884C, "\n") or "无"
end
function ____exports.resolveRewardDisplayText(quest)
    if not quest then
        return "无"
    end
    local reward = quest["奖励显示"] and quest["奖励显示"] ~= "" and quest["奖励显示"] or (quest["奖励"] or "")
    return ____exports["解析任务奖励展示文本"](reward)
end
local function normalizeRequireCount(count)
    return count ~= nil and count > 1 and count or 1
end
local function _____6784_5EFA_4EFB_52A1_76EE_6807(cfg)
    if cfg["击杀目标组"] and #cfg["击杀目标组"] > 0 then
        local _____76EE_6807_5217_8868 = {}
        do
            local i = 0
            while i < #cfg["击杀目标组"] do
                do
                    local _____76EE_6807_7EC4 = cfg["击杀目标组"][i + 1]
                    if not _____76EE_6807_7EC4 or not _____76EE_6807_7EC4["目标单位"] or _____76EE_6807_7EC4["需求数量"] <= 0 then
                        goto __continue71
                    end
                    _____76EE_6807_5217_8868[#_____76EE_6807_5217_8868 + 1] = {
                        id = "kill_group_" .. tostring(nil, i),
                        description = "击杀" .. _____76EE_6807_7EC4["显示名"],
                        current = 0,
                        required = _____76EE_6807_7EC4["需求数量"],
                        completed = false
                    }
                end
                ::__continue71::
                i = i + 1
            end
        end
        return _____76EE_6807_5217_8868
    end
    if cfg["目标单位分别击杀"] == true and cfg["目标单位"] then
        local _____5355_4F4D_5217_8868 = __TS__StringSplit(cfg["目标单位"], "|")
        local _____663E_793A_540D_5217_8868 = __TS__StringSplit(cfg["目标单位显示名"] or "", "|")
        local _____76EE_6807_5217_8868 = {}
        do
            local i = 0
            while i < #_____5355_4F4D_5217_8868 do
                do
                    local _____5355_4F4D_4EE3_7801 = __TS__StringTrim(_____5355_4F4D_5217_8868[i + 1])
                    if _____5355_4F4D_4EE3_7801 == "" then
                        goto __continue75
                    end
                    local _____663E_793A_540D = __TS__StringTrim(_____663E_793A_540D_5217_8868[i + 1] or _____5355_4F4D_4EE3_7801)
                    _____76EE_6807_5217_8868[#_____76EE_6807_5217_8868 + 1] = {
                        id = "kill_" .. _____5355_4F4D_4EE3_7801,
                        description = "击杀" .. _____663E_793A_540D,
                        current = 0,
                        required = 1,
                        completed = false
                    }
                end
                ::__continue75::
                i = i + 1
            end
        end
        return _____76EE_6807_5217_8868
    end
    if (cfg["类型"] == "调查" or cfg["类型"] == "防守") and cfg["需求数量"] ~= nil and cfg["需求数量"] > 0 then
        return {{
            id = "obj1",
            description = cfg["进度文本"] or cfg["描述"] or cfg["名称"] or "",
            current = 0,
            required = cfg["需求数量"],
            completed = false
        }}
    end
    if not cfg["需求物品"] and not cfg["目标单位"] then
        return {}
    end
    return {{
        id = "obj1",
        description = cfg["进度文本"] or cfg["描述"] or cfg["名称"] or "",
        current = 0,
        required = normalizeRequireCount(cfg["需求数量"]),
        completed = false
    }}
end
____exports["注册单个任务配置到任务库"] = function(cfg, npcCfg)
    if cfg["启用"] ~= true or not cfg["任务ID"] then
        return false
    end
    local questId = tostring(cfg["任务ID"])
    if questDB:getQuest(questId) then
        return true
    end
    local iconPath = ""
    if npcCfg and npcCfg["单位ID"] then
        iconPath = getObjectProperty(nil, ObjectType.UNIT, npcCfg["单位ID"], "Art")
    end
    questDB:registerQuest({
        id = questId,
        type = QuestType.DAILY,
        title = cfg["名称"] or questId,
        description = cfg["描述"] or cfg["名称"] or "",
        objectives = _____6784_5EFA_4EFB_52A1_76EE_6807(cfg),
        rewards = {{
            type = "gold",
            value = 0,
            description = ____exports.resolveRewardDisplayText(cfg)
        }},
        status = QuestStatus.UNDISCOVERED,
        startNpc = cfg["开始NPC"],
        requiredQuests = cfg["前置任务ID"] ~= nil and ({tostring(cfg["前置任务ID"])}) or nil,
        icon = iconPath or nil,
        ["内部限时秒"] = cfg["内部限时秒"],
        createdAt = 0,
        updatedAt = 0
    })
    return true
end
return ____exports
