--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5E27_521B_5EFA = require("系统.09．表现系统.01．UI工具.01．帧创建")
local _____521B_5EFA_5E27 = ____01_FF0E_5E27_521B_5EFA.createFrame
local ____02_FF0E_4F4D_7F6E_5C3A_5BF8 = require("系统.09．表现系统.01．UI工具.02．位置尺寸")
local _____8BBE_7F6E_5E27_76F8_5BF9_4F4D_7F6E = ____02_FF0E_4F4D_7F6E_5C3A_5BF8.setFramePointRelative
local _____8BBE_7F6E_5E27_5C3A_5BF8 = ____02_FF0E_4F4D_7F6E_5C3A_5BF8.setFrameSize
local ____03_FF0E_5185_5BB9_8BBE_7F6E = require("系统.09．表现系统.01．UI工具.03．内容设置")
local _____8BBE_7F6E_6309_94AE_6587_672C = ____03_FF0E_5185_5BB9_8BBE_7F6E.setButtonText
local _____8BBE_7F6E_5E27_70B9_51FB_4E8B_4EF6 = ____03_FF0E_5185_5BB9_8BBE_7F6E.setFrameClickEvent
local _____8BBE_7F6E_5E27_8D34_56FE = ____03_FF0E_5185_5BB9_8BBE_7F6E.setFrameTexture
local ____05_FF0E_5E27_63A7_5236 = require("系统.09．表现系统.01．UI工具.05．帧控制")
local _____9690_85CF_5E27 = ____05_FF0E_5E27_63A7_5236.hideFrame
local _____663E_793A_5E27 = ____05_FF0E_5E27_63A7_5236.showFrame
local ____00_FF0E_7C7B_578B_5B9A_4E49 = require("系统.09．表现系统.01．UI工具.00．类型定义")
local FramePoint = ____00_FF0E_7C7B_578B_5B9A_4E49.FramePoint
local FrameType = ____00_FF0E_7C7B_578B_5B9A_4E49.FrameType
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local _____5168_5C40_53D8_91CF = require("jass.globals")
local _____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____9996_9886_5956_52B1_754C_9762 = require("系统.02．物品系统.18．首领奖励选择.05．奖励选择界面")
local _____9996_9886_5956_52B1_914D_7F6E = require("系统.02．物品系统.18．首领奖励选择.01．奖励配置表")
local _____9996_9886_5956_52B1_53D1_653E = require("系统.02．物品系统.18．首领奖励选择.03．奖励发放")
local _____9996_9886_5956_52B1_9886_53D6_72B6_6001 = require("系统.02．物品系统.18．首领奖励选择.02．领取状态")
local _____7269_54C1_540D_53CD_67E5 = require("系统.02．物品系统.13．物品名反查")
local _____56DB_5B57_7B26_8F6C_6362 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local _____521B_5EFA_7269_54C1_6A21_5757 = require("lib.扩展函数.物品相关函数.创建物品函数")
local Player = jass.Player
local GetPlayerId = jass.GetPlayerId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local UnitAddItem = jass.UnitAddItem
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local _____6D4B_8BD5_547D_4EE4 = "brtest"
local _____91CD_7F6E_6D4B_8BD5_547D_4EE4 = "brreset"
local _____9009_9879_6309_94AE = {}
local _____9009_9879_56FE_6807 = {}
local _____9009_9879_56FE_6807_6309_94AE = {}
local _____9009_4E2D_8FB9_6846 = {}
local _____52FE_9009_6807_8BB0 = {}
local _____5DF2_9009_62E9 = {}
local _____8BE6_60C5_56FE_6807 = 0
local _____8BE6_60C5_6807_9898 = 0
local _____8BE6_60C5_5206_7C7B = 0
local _____8BE6_60C5_8BC4_5206 = 0
local _____8BE6_60C5_63CF_8FF0 = 0
local _____8BE6_60C5_5C5E_6027 = 0
local _____8BE6_60C5_7279_6548 = 0
local _____786E_8BA4_6309_94AE = 0
local _____5173_95ED_6309_94AE = 0
local _____6D4B_8BD5_754C_9762_5DF2_521B_5EFA = false
local _____5F53_524D_73A9_5BB6 = nil
local _____5F53_524D_8BE6_60C5_5E8F_53F7 = 0
local _____5956_52B1_56FE_6807_8DEF_5F84_8868 = {
    ["执法者徽记"] = "Equipment\\Icon\\Item\\enforcer_badge.blp",
    ["月光锁链护腕"] = "Equipment\\Icon\\Item\\moonlight_chain_bracer.blp",
    ["审判之锋长剑"] = "Equipment\\Icon\\MainWeapon\\Sword\\judgement_edge_longsword.blp",
    ["精灵执法披风"] = "Equipment\\Icon\\Clothes\\elven_enforcer_cloak.blp",
    ["瑟兰迪尔的决心"] = "Equipment\\Icon\\Soul\\thranduil_resolve.blp"
}
local _____9009_4E2D_8FB9_6846_8D34_56FE = "UI\\BossReward\\reward_selected_border.tga"
local _____52FE_9009_6807_8BB0_8D34_56FE = "UI\\BossReward\\reward_check_badge.tga"
local _____989C_8272_6807_9898 = "|cff4b1f08"
local _____989C_8272_6B63_6587 = "|cff21140a"
local _____989C_8272_5C0F_6807_9898 = "|cff6a3608"
local _____989C_8272_7ED3_675F = "|r"
local _____5956_52B1_8BE6_60C5_8D44_6599_8868 = {
    ["执法者徽记"] = {
        ["分类"] = "饰品",
        ["等级"] = "B-",
        ["评分"] = "6400",
        ["描述"] = "象征精灵执法者权威的徽记，冷月与秩序铭刻其上。",
        ["属性"] = "全属性 +32\n护甲 +15\n冷却缩减 +10%",
        ["特效"] = "秩序守护：攻击时有 10% 概率使目标沉默 2 秒；同一目标 8 秒内只触发一次。"
    },
    ["月光锁链护腕"] = {
        ["分类"] = "饰品",
        ["等级"] = "B-",
        ["评分"] = "6200",
        ["描述"] = "银蓝色锁链护腕，能在束缚降临时反噬敌意。",
        ["属性"] = "敏捷 +45\n攻击速度 +50%\n生命值 +600",
        ["特效"] = "束缚反击：自身受到控制时，获得 2 秒 30% 减伤，并反弹本次伤害 30%；冷却 12 秒。"
    },
    ["审判之锋长剑"] = {
        ["分类"] = "主武器 · 剑",
        ["等级"] = "B",
        ["评分"] = "6500",
        ["描述"] = "为审判而锻造的长剑，锋刃会先斩向仍未低头的敌人。",
        ["属性"] = "攻击力 +160\n力量 +22\n护甲穿透 +20%",
        ["特效"] = "罪与罚：攻击生命值高于 70% 的目标时，额外造成 18% 物理伤害。"
    },
    ["精灵执法披风"] = {
        ["分类"] = "衣服",
        ["等级"] = "B",
        ["评分"] = "6500",
        ["描述"] = "披风展开时如同一片肃穆领域，令靠近者不敢轻举妄动。",
        ["属性"] = "生命值 +2600\n护甲 +28\n魔抗 +18%\n移动速度 +6%",
        ["特效"] = "秩序领域：周围 300 范围内敌方单位攻击速度降低 15%。"
    },
    ["瑟兰迪尔的决心"] = {
        ["分类"] = "灵魂",
        ["等级"] = "B-",
        ["评分"] = "6100",
        ["描述"] = "残留着瑟兰迪尔执念的灵魂印记，只在精灵城回应召唤。",
        ["属性"] = "全属性 +15",
        ["特效"] = "使用：召唤瑟兰迪尔幻影协助战斗 30 秒，仅精灵城内可用。"
    }
}
local _____69FD_4F4D_4E2D_5FC3X = {
    -0.216,
    -0.144,
    -0.073,
    0,
    0.071
}
local _____69FD_4F4D_56FE_6807Y = 0.076
local _____69FD_4F4D_6309_94AEY = 0.053
local _____69FD_4F4D_56FE_6807_5C3A_5BF8 = 0.055
local _____69FD_4F4D_6309_94AE_5BBD_5EA6 = 0.04
local _____69FD_4F4D_6309_94AE_9AD8_5EA6 = 0.015
local _____786E_8BA4_6309_94AEY = -0.126
local function _____83B7_53D6_5927_6CD5_5E08()
    return _____5168_5C40_53D8_91CF.gg_unit_Hamg_0002
end
local function _____63D0_793A(_____6587_672C)
    local _____73A9_5BB6 = _____5F53_524D_73A9_5BB6 or Player(0)
    DisplayTimedTextToPlayer(
        _____73A9_5BB6,
        0,
        0,
        8,
        "[首领奖励测试] " .. _____6587_672C
    )
end
local function _____83B7_53D6_5956_52B1_88C5_5907_540D(_____5E8F_53F7)
    local _____5956_52B1_6C60 = _____9996_9886_5956_52B1_914D_7F6E["查找首领奖励池"](_____9996_9886_5956_52B1_914D_7F6E["瑟兰迪尔奖励池ID"])
    if _____5956_52B1_6C60 == nil then
        return ""
    end
    local _____9009_9879 = _____5956_52B1_6C60["选项"][_____5E8F_53F7 + 1]
    if _____9009_9879 == nil then
        return ""
    end
    return _____9009_9879["装备名"] or ""
end
local function _____83B7_53D6_5956_52B1_56FE_6807_8DEF_5F84(_____5E8F_53F7)
    local _____88C5_5907_540D = _____83B7_53D6_5956_52B1_88C5_5907_540D(_____5E8F_53F7)
    return _____5956_52B1_56FE_6807_8DEF_5F84_8868[_____88C5_5907_540D] or "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"
end
local function _____83B7_53D6_5956_52B1_8BE6_60C5_8D44_6599(_____5E8F_53F7)
    local _____88C5_5907_540D = _____83B7_53D6_5956_52B1_88C5_5907_540D(_____5E8F_53F7)
    return _____5956_52B1_8BE6_60C5_8D44_6599_8868[_____88C5_5907_540D] or nil
end
local function _____8BBE_7F6E_6587_672C_5E27_6587_5B57(_____5E27, _____6587_672C)
    if _____5E27 ~= 0 then
        japi.DzFrameSetText(_____5E27, _____6587_672C)
    end
end
local function _____521B_5EFA_6D4B_8BD5_6587_672C_5E27(_____540D_5B57, _____7236_5E27, _____6587_672C, x, y, _____5BBD_5EA6, _____9AD8_5EA6)
    local _____6587_672C_5E27 = _____521B_5EFA_5E27(nil, {
        type = FrameType.TEXT,
        name = _____540D_5B57,
        parent = _____7236_5E27,
        template = "template",
        visible = true
    }) or 0
    if _____6587_672C_5E27 == 0 then
        return 0
    end
    _____8BBE_7F6E_5E27_76F8_5BF9_4F4D_7F6E(
        nil,
        _____6587_672C_5E27,
        FramePoint.TOPLEFT,
        _____7236_5E27,
        FramePoint.CENTER,
        x,
        y
    )
    _____8BBE_7F6E_5E27_5C3A_5BF8(nil, _____6587_672C_5E27, {width = _____5BBD_5EA6, height = _____9AD8_5EA6})
    japi.DzFrameSetTextAlignment(_____6587_672C_5E27, 0)
    japi.DzFrameSetFont(_____6587_672C_5E27, "Fonts\\dfst-m3u.ttf", 0.0125, 0)
    japi.DzFrameSetTextColor(
        _____6587_672C_5E27,
        33,
        20,
        10,
        255
    )
    japi.DzFrameSetText(_____6587_672C_5E27, _____6587_672C)
    return _____6587_672C_5E27
end
local function _____5237_65B0_8BE6_60C5_5185_5BB9()
    local _____88C5_5907_540D = _____83B7_53D6_5956_52B1_88C5_5907_540D(_____5F53_524D_8BE6_60C5_5E8F_53F7)
    local _____8BE6_60C5 = _____83B7_53D6_5956_52B1_8BE6_60C5_8D44_6599(_____5F53_524D_8BE6_60C5_5E8F_53F7)
    if _____8BE6_60C5 == nil or _____88C5_5907_540D == "" then
        return
    end
    if _____8BE6_60C5_56FE_6807 ~= 0 then
        _____8BBE_7F6E_5E27_8D34_56FE(
            nil,
            _____8BE6_60C5_56FE_6807,
            _____83B7_53D6_5956_52B1_56FE_6807_8DEF_5F84(_____5F53_524D_8BE6_60C5_5E8F_53F7)
        )
    end
    _____8BBE_7F6E_6587_672C_5E27_6587_5B57(_____8BE6_60C5_6807_9898, (_____989C_8272_6807_9898 .. _____88C5_5907_540D) .. _____989C_8272_7ED3_675F)
    _____8BBE_7F6E_6587_672C_5E27_6587_5B57(_____8BE6_60C5_5206_7C7B, (((_____989C_8272_6B63_6587 .. _____8BE6_60C5["分类"]) .. "    ") .. _____8BE6_60C5["等级"]) .. _____989C_8272_7ED3_675F)
    _____8BBE_7F6E_6587_672C_5E27_6587_5B57(_____8BE6_60C5_8BC4_5206, (((((_____989C_8272_5C0F_6807_9898 .. "装备评分：") .. _____989C_8272_7ED3_675F) .. _____989C_8272_6B63_6587) .. " ") .. _____8BE6_60C5["评分"]) .. _____989C_8272_7ED3_675F)
    _____8BBE_7F6E_6587_672C_5E27_6587_5B57(_____8BE6_60C5_63CF_8FF0, (_____989C_8272_6B63_6587 .. _____8BE6_60C5["描述"]) .. _____989C_8272_7ED3_675F)
    _____8BBE_7F6E_6587_672C_5E27_6587_5B57(_____8BE6_60C5_5C5E_6027, (((((_____989C_8272_5C0F_6807_9898 .. "属性") .. _____989C_8272_7ED3_675F) .. "\n") .. _____989C_8272_6B63_6587) .. _____8BE6_60C5["属性"]) .. _____989C_8272_7ED3_675F)
    _____8BBE_7F6E_6587_672C_5E27_6587_5B57(_____8BE6_60C5_7279_6548, (((((_____989C_8272_5C0F_6807_9898 .. "特效") .. _____989C_8272_7ED3_675F) .. "\n") .. _____989C_8272_6B63_6587) .. _____8BE6_60C5["特效"]) .. _____989C_8272_7ED3_675F)
end
local function _____7EDF_8BA1_9009_62E9_6570_91CF()
    local _____6570_91CF = 0
    do
        local _____5E8F_53F7 = 0
        while _____5E8F_53F7 < #_____5DF2_9009_62E9 do
            if _____5DF2_9009_62E9[_____5E8F_53F7 + 1] then
                _____6570_91CF = _____6570_91CF + 1
            end
            _____5E8F_53F7 = _____5E8F_53F7 + 1
        end
    end
    return _____6570_91CF
end
local function _____6536_96C6_5DF2_9009_88C5_5907_540D()
    local _____88C5_5907_540D_5217_8868 = {}
    do
        local _____5E8F_53F7 = 0
        while _____5E8F_53F7 < #_____5DF2_9009_62E9 do
            if _____5DF2_9009_62E9[_____5E8F_53F7 + 1] then
                local _____88C5_5907_540D = _____83B7_53D6_5956_52B1_88C5_5907_540D(_____5E8F_53F7)
                if _____88C5_5907_540D ~= "" then
                    _____88C5_5907_540D_5217_8868[#_____88C5_5907_540D_5217_8868 + 1] = _____88C5_5907_540D
                end
            end
            _____5E8F_53F7 = _____5E8F_53F7 + 1
        end
    end
    return _____88C5_5907_540D_5217_8868
end
local function _____5237_65B0_9009_9879_6309_94AE_6587_5B57()
    do
        local _____5E8F_53F7 = 0
        while _____5E8F_53F7 < #_____9009_9879_6309_94AE do
            local _____6309_94AE = _____9009_9879_6309_94AE[_____5E8F_53F7 + 1]
            local _____88C5_5907_540D = _____83B7_53D6_5956_52B1_88C5_5907_540D(_____5E8F_53F7)
            if _____6309_94AE ~= 0 and _____88C5_5907_540D ~= "" then
                _____8BBE_7F6E_6309_94AE_6587_672C(nil, _____6309_94AE, "")
            end
            if _____9009_4E2D_8FB9_6846[_____5E8F_53F7 + 1] ~= 0 then
                if _____5DF2_9009_62E9[_____5E8F_53F7 + 1] then
                    _____663E_793A_5E27(nil, _____9009_4E2D_8FB9_6846[_____5E8F_53F7 + 1])
                else
                    _____9690_85CF_5E27(nil, _____9009_4E2D_8FB9_6846[_____5E8F_53F7 + 1])
                end
            end
            if _____52FE_9009_6807_8BB0[_____5E8F_53F7 + 1] ~= 0 then
                if _____5DF2_9009_62E9[_____5E8F_53F7 + 1] then
                    _____663E_793A_5E27(nil, _____52FE_9009_6807_8BB0[_____5E8F_53F7 + 1])
                else
                    _____9690_85CF_5E27(nil, _____52FE_9009_6807_8BB0[_____5E8F_53F7 + 1])
                end
            end
            _____5E8F_53F7 = _____5E8F_53F7 + 1
        end
    end
    if _____786E_8BA4_6309_94AE ~= 0 then
        _____8BBE_7F6E_6309_94AE_6587_672C(
            nil,
            _____786E_8BA4_6309_94AE,
            ("确认领取 " .. tostring(_____7EDF_8BA1_9009_62E9_6570_91CF())) .. "/2"
        )
    end
end
local function _____5207_6362_9009_9879(_____5E8F_53F7)
    _____5F53_524D_8BE6_60C5_5E8F_53F7 = _____5E8F_53F7
    _____5237_65B0_8BE6_60C5_5185_5BB9()
    if not _____5DF2_9009_62E9[_____5E8F_53F7 + 1] and _____7EDF_8BA1_9009_62E9_6570_91CF() >= 2 then
        _____63D0_793A("最多只能选择 2 件装备。")
        return
    end
    _____5DF2_9009_62E9[_____5E8F_53F7 + 1] = not _____5DF2_9009_62E9[_____5E8F_53F7 + 1]
    _____5237_65B0_9009_9879_6309_94AE_6587_5B57()
end
local function _____70B9_51FB_9009_9879_4E00()
    _____5207_6362_9009_9879(0)
end
local function _____70B9_51FB_9009_9879_4E8C()
    _____5207_6362_9009_9879(1)
end
local function _____70B9_51FB_9009_9879_4E09()
    _____5207_6362_9009_9879(2)
end
local function _____70B9_51FB_9009_9879_56DB()
    _____5207_6362_9009_9879(3)
end
local function _____70B9_51FB_9009_9879_4E94()
    _____5207_6362_9009_9879(4)
end
local function _____521B_5EFA_6D4B_8BD5_56FE_6807_6309_94AE(_____7236_5E27, _____5E8F_53F7, _____70B9_51FB_51FD_6570)
    local _____56FE_6807 = _____521B_5EFA_5E27(
        nil,
        {
            type = FrameType.BACKDROP,
            name = "首领奖励测试图标" .. tostring(_____5E8F_53F7),
            parent = _____7236_5E27,
            template = "template",
            visible = true
        }
    ) or 0
    if _____56FE_6807 ~= 0 then
        _____8BBE_7F6E_5E27_76F8_5BF9_4F4D_7F6E(
            nil,
            _____56FE_6807,
            FramePoint.CENTER,
            _____7236_5E27,
            FramePoint.CENTER,
            _____69FD_4F4D_4E2D_5FC3X[_____5E8F_53F7 + 1],
            _____69FD_4F4D_56FE_6807Y
        )
        _____8BBE_7F6E_5E27_5C3A_5BF8(nil, _____56FE_6807, {width = _____69FD_4F4D_56FE_6807_5C3A_5BF8, height = _____69FD_4F4D_56FE_6807_5C3A_5BF8})
        _____8BBE_7F6E_5E27_8D34_56FE(
            nil,
            _____56FE_6807,
            _____83B7_53D6_5956_52B1_56FE_6807_8DEF_5F84(_____5E8F_53F7)
        )
        japi.DzFrameSetPriority(_____56FE_6807, 10)
    end
    local _____8FB9_6846 = _____521B_5EFA_5E27(
        nil,
        {
            type = FrameType.BACKDROP,
            name = "首领奖励测试选中边框" .. tostring(_____5E8F_53F7),
            parent = _____7236_5E27,
            template = "template",
            visible = false
        }
    ) or 0
    if _____8FB9_6846 ~= 0 then
        _____8BBE_7F6E_5E27_76F8_5BF9_4F4D_7F6E(
            nil,
            _____8FB9_6846,
            FramePoint.CENTER,
            _____7236_5E27,
            FramePoint.CENTER,
            _____69FD_4F4D_4E2D_5FC3X[_____5E8F_53F7 + 1],
            _____69FD_4F4D_56FE_6807Y
        )
        _____8BBE_7F6E_5E27_5C3A_5BF8(nil, _____8FB9_6846, {width = _____69FD_4F4D_56FE_6807_5C3A_5BF8 + 0.008, height = _____69FD_4F4D_56FE_6807_5C3A_5BF8 + 0.008})
        _____8BBE_7F6E_5E27_8D34_56FE(nil, _____8FB9_6846, _____9009_4E2D_8FB9_6846_8D34_56FE)
        japi.DzFrameSetPriority(_____8FB9_6846, 12)
    end
    local _____52FE_9009 = _____521B_5EFA_5E27(
        nil,
        {
            type = FrameType.BACKDROP,
            name = "首领奖励测试勾选标记" .. tostring(_____5E8F_53F7),
            parent = _____7236_5E27,
            template = "template",
            visible = false
        }
    ) or 0
    if _____52FE_9009 ~= 0 then
        _____8BBE_7F6E_5E27_76F8_5BF9_4F4D_7F6E(
            nil,
            _____52FE_9009,
            FramePoint.CENTER,
            _____7236_5E27,
            FramePoint.CENTER,
            _____69FD_4F4D_4E2D_5FC3X[_____5E8F_53F7 + 1] + 0.021,
            _____69FD_4F4D_56FE_6807Y + 0.021
        )
        _____8BBE_7F6E_5E27_5C3A_5BF8(nil, _____52FE_9009, {width = 0.018, height = 0.018})
        _____8BBE_7F6E_5E27_8D34_56FE(nil, _____52FE_9009, _____52FE_9009_6807_8BB0_8D34_56FE)
        japi.DzFrameSetPriority(_____52FE_9009, 13)
    end
    local _____56FE_6807_6309_94AE = _____521B_5EFA_5E27(
        nil,
        {
            type = FrameType.GLUETEXTBUTTON,
            name = "首领奖励测试图标按钮" .. tostring(_____5E8F_53F7),
            parent = _____56FE_6807 ~= 0 and _____56FE_6807 or _____7236_5E27,
            template = "template",
            visible = true,
            enable = true,
            alpha = 0
        }
    ) or 0
    if _____56FE_6807 ~= 0 and _____56FE_6807_6309_94AE ~= 0 then
        japi.DzFrameSetAllPoints(_____56FE_6807_6309_94AE, _____56FE_6807)
        japi.DzFrameSetPriority(_____56FE_6807_6309_94AE, 14)
        _____8BBE_7F6E_5E27_70B9_51FB_4E8B_4EF6(nil, _____56FE_6807_6309_94AE, _____70B9_51FB_51FD_6570)
    end
    _____9009_9879_56FE_6807[_____5E8F_53F7 + 1] = _____56FE_6807
    _____9009_9879_56FE_6807_6309_94AE[_____5E8F_53F7 + 1] = _____56FE_6807_6309_94AE
    _____9009_4E2D_8FB9_6846[_____5E8F_53F7 + 1] = _____8FB9_6846
    _____52FE_9009_6807_8BB0[_____5E8F_53F7 + 1] = _____52FE_9009
end
local function _____521B_5EFA_6D4B_8BD5_6587_5B57_6309_94AE(_____540D_5B57, _____7236_5E27, _____6587_5B57, x, y, _____5BBD_5EA6, _____9AD8_5EA6, _____70B9_51FB_51FD_6570)
    local _____6309_94AE = _____521B_5EFA_5E27(nil, {
        type = FrameType.GLUETEXTBUTTON,
        name = _____540D_5B57,
        parent = _____7236_5E27,
        template = "template",
        visible = true,
        enable = true
    }) or 0
    if _____6309_94AE == 0 then
        return 0
    end
    _____8BBE_7F6E_5E27_76F8_5BF9_4F4D_7F6E(
        nil,
        _____6309_94AE,
        FramePoint.CENTER,
        _____7236_5E27,
        FramePoint.CENTER,
        x,
        y
    )
    _____8BBE_7F6E_5E27_5C3A_5BF8(nil, _____6309_94AE, {width = _____5BBD_5EA6, height = _____9AD8_5EA6})
    japi.DzFrameSetTextAlignment(_____6309_94AE, 18)
    japi.DzFrameSetFont(_____6309_94AE, "Fonts\\dfst-m3u.ttf", 0.0125, 0)
    _____8BBE_7F6E_6309_94AE_6587_672C(nil, _____6309_94AE, _____6587_5B57)
    _____8BBE_7F6E_5E27_70B9_51FB_4E8B_4EF6(nil, _____6309_94AE, _____70B9_51FB_51FD_6570)
    return _____6309_94AE
end
local function _____53D1_653E_5355_4EF6_88C5_5907(_____88C5_5907_540D, _____5927_6CD5_5E08)
    local _____7269_54C1ID_5B57_7B26_4E32 = _____7269_54C1_540D_53CD_67E5["按名字反查物品ID"](_____88C5_5907_540D)
    local _____7269_54C1_7C7B_578BID = _____56DB_5B57_7B26_8F6C_6362.stringToFourCCSafe(_____7269_54C1ID_5B57_7B26_4E32)
    if _____7269_54C1_7C7B_578BID == 0 then
        _____63D0_793A("物品名反查失败：" .. _____88C5_5907_540D)
        return false
    end
    local _____7269_54C1 = _____521B_5EFA_7269_54C1_6A21_5757["创建物品并注册排泄监听"](
        _____7269_54C1_7C7B_578BID,
        GetUnitX(_____5927_6CD5_5E08),
        GetUnitY(_____5927_6CD5_5E08)
    )
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        _____63D0_793A("创建物品失败：" .. _____88C5_5907_540D)
        return false
    end
    local _____7ED3_679C = UnitAddItem(_____5927_6CD5_5E08, _____7269_54C1)
    if _____7ED3_679C ~= true and _____7ED3_679C ~= 1 then
        _____63D0_793A("大法师背包可能已满，物品已掉在脚下：" .. _____88C5_5907_540D)
    end
    return true
end
local function _____70B9_51FB_786E_8BA4_9886_53D6()
    local _____5927_6CD5_5E08 = _____83B7_53D6_5927_6CD5_5E08()
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        _____63D0_793A("未找到 gg_unit_Hamg_0002，无法发放。")
        return
    end
    local _____5DF2_9009_88C5_5907_540D = _____6536_96C6_5DF2_9009_88C5_5907_540D()
    if #_____5DF2_9009_88C5_5907_540D ~= 2 then
        _____63D0_793A("请先选择 2 件装备。")
        return
    end
    local _____73A9_5BB6ID = _____5F53_524D_73A9_5BB6 ~= nil and GetPlayerId(_____5F53_524D_73A9_5BB6) or 0
    local _____53D1_653E_7ED3_679C = _____9996_9886_5956_52B1_53D1_653E["领取首领奖励选择"](_____9996_9886_5956_52B1_914D_7F6E["瑟兰迪尔奖励池ID"], _____73A9_5BB6ID, _____5DF2_9009_88C5_5907_540D)
    if _____53D1_653E_7ED3_679C ~= "成功" then
        _____63D0_793A("领取校验失败：" .. _____53D1_653E_7ED3_679C)
        return
    end
    local _____6210_529F_6570_91CF = 0
    do
        local _____5E8F_53F7 = 0
        while _____5E8F_53F7 < #_____5DF2_9009_88C5_5907_540D do
            if _____53D1_653E_5355_4EF6_88C5_5907(_____5DF2_9009_88C5_5907_540D[_____5E8F_53F7 + 1], _____5927_6CD5_5E08) then
                _____6210_529F_6570_91CF = _____6210_529F_6570_91CF + 1
            end
            _____5E8F_53F7 = _____5E8F_53F7 + 1
        end
    end
    _____63D0_793A(("已给大法师发放 " .. tostring(_____6210_529F_6570_91CF)) .. " 件装备。")
end
local function _____70B9_51FB_5173_95ED_6D4B_8BD5_754C_9762()
    _____9996_9886_5956_52B1_754C_9762["隐藏首领奖励选择界面"]()
end
local function _____521B_5EFA_6D4B_8BD5_6309_94AE()
    if _____6D4B_8BD5_754C_9762_5DF2_521B_5EFA then
        return
    end
    local _____7236_5E27 = _____9996_9886_5956_52B1_754C_9762["获取首领奖励面板帧"]()
    if _____7236_5E27 == 0 then
        _____63D0_793A("首领奖励面板创建失败。")
        return
    end
    local _____70B9_51FB_51FD_6570_5217_8868 = {
        _____70B9_51FB_9009_9879_4E00,
        _____70B9_51FB_9009_9879_4E8C,
        _____70B9_51FB_9009_9879_4E09,
        _____70B9_51FB_9009_9879_56DB,
        _____70B9_51FB_9009_9879_4E94
    }
    do
        local _____5E8F_53F7 = 0
        while _____5E8F_53F7 < 5 do
            _____5DF2_9009_62E9[_____5E8F_53F7 + 1] = false
            _____521B_5EFA_6D4B_8BD5_56FE_6807_6309_94AE(_____7236_5E27, _____5E8F_53F7, _____70B9_51FB_51FD_6570_5217_8868[_____5E8F_53F7 + 1])
            local _____6309_94AE = _____521B_5EFA_6D4B_8BD5_6587_5B57_6309_94AE(
                "首领奖励测试选项" .. tostring(_____5E8F_53F7),
                _____7236_5E27,
                "",
                _____69FD_4F4D_4E2D_5FC3X[_____5E8F_53F7 + 1],
                _____69FD_4F4D_6309_94AEY,
                _____69FD_4F4D_6309_94AE_5BBD_5EA6,
                _____69FD_4F4D_6309_94AE_9AD8_5EA6,
                _____70B9_51FB_51FD_6570_5217_8868[_____5E8F_53F7 + 1]
            )
            _____9009_9879_6309_94AE[_____5E8F_53F7 + 1] = _____6309_94AE
            _____5E8F_53F7 = _____5E8F_53F7 + 1
        end
    end
    _____8BE6_60C5_56FE_6807 = _____521B_5EFA_5E27(nil, {
        type = FrameType.BACKDROP,
        name = "首领奖励测试详情图标",
        parent = _____7236_5E27,
        template = "template",
        visible = true
    }) or 0
    if _____8BE6_60C5_56FE_6807 ~= 0 then
        _____8BBE_7F6E_5E27_76F8_5BF9_4F4D_7F6E(
            nil,
            _____8BE6_60C5_56FE_6807,
            FramePoint.CENTER,
            _____7236_5E27,
            FramePoint.CENTER,
            -0.211,
            -0.017
        )
        _____8BBE_7F6E_5E27_5C3A_5BF8(nil, _____8BE6_60C5_56FE_6807, {width = 0.046, height = 0.046})
    end
    _____8BE6_60C5_6807_9898 = _____521B_5EFA_6D4B_8BD5_6587_672C_5E27(
        "首领奖励测试详情标题",
        _____7236_5E27,
        "",
        -0.168,
        0.017,
        0.125,
        0.02
    )
    _____8BE6_60C5_5206_7C7B = _____521B_5EFA_6D4B_8BD5_6587_672C_5E27(
        "首领奖励测试详情分类",
        _____7236_5E27,
        "",
        -0.168,
        -0.008,
        0.125,
        0.018
    )
    _____8BE6_60C5_8BC4_5206 = _____521B_5EFA_6D4B_8BD5_6587_672C_5E27(
        "首领奖励测试详情评分",
        _____7236_5E27,
        "",
        -0.168,
        -0.034,
        0.125,
        0.018
    )
    _____8BE6_60C5_63CF_8FF0 = _____521B_5EFA_6D4B_8BD5_6587_672C_5E27(
        "首领奖励测试详情描述",
        _____7236_5E27,
        "",
        -0.239,
        -0.069,
        0.19,
        0.034
    )
    _____8BE6_60C5_5C5E_6027 = _____521B_5EFA_6D4B_8BD5_6587_672C_5E27(
        "首领奖励测试详情属性",
        _____7236_5E27,
        "",
        -0.02,
        0.022,
        0.245,
        0.083
    )
    _____8BE6_60C5_7279_6548 = _____521B_5EFA_6D4B_8BD5_6587_672C_5E27(
        "首领奖励测试详情特效",
        _____7236_5E27,
        "",
        -0.02,
        -0.062,
        0.25,
        0.074
    )
    _____5F53_524D_8BE6_60C5_5E8F_53F7 = 0
    _____5237_65B0_8BE6_60C5_5185_5BB9()
    _____786E_8BA4_6309_94AE = _____521B_5EFA_6D4B_8BD5_6587_5B57_6309_94AE(
        "首领奖励测试确认",
        _____7236_5E27,
        "确认领取 0/2",
        -0.126,
        _____786E_8BA4_6309_94AEY,
        0.135,
        0.023,
        _____70B9_51FB_786E_8BA4_9886_53D6
    )
    _____5173_95ED_6309_94AE = _____521B_5EFA_6D4B_8BD5_6587_5B57_6309_94AE(
        "首领奖励测试关闭",
        _____7236_5E27,
        "关闭",
        0.168,
        _____786E_8BA4_6309_94AEY,
        0.115,
        0.023,
        _____70B9_51FB_5173_95ED_6D4B_8BD5_754C_9762
    )
    _____6D4B_8BD5_754C_9762_5DF2_521B_5EFA = true
end
local function _____91CD_7F6E_6D4B_8BD5_9009_62E9()
    do
        local _____5E8F_53F7 = 0
        while _____5E8F_53F7 < 5 do
            _____5DF2_9009_62E9[_____5E8F_53F7 + 1] = false
            if _____9009_9879_56FE_6807[_____5E8F_53F7 + 1] ~= 0 then
                _____663E_793A_5E27(nil, _____9009_9879_56FE_6807[_____5E8F_53F7 + 1])
            end
            if _____9009_9879_56FE_6807_6309_94AE[_____5E8F_53F7 + 1] ~= 0 then
                _____663E_793A_5E27(nil, _____9009_9879_56FE_6807_6309_94AE[_____5E8F_53F7 + 1])
            end
            if _____9009_9879_6309_94AE[_____5E8F_53F7 + 1] ~= 0 then
                _____663E_793A_5E27(nil, _____9009_9879_6309_94AE[_____5E8F_53F7 + 1])
            end
            _____5E8F_53F7 = _____5E8F_53F7 + 1
        end
    end
    if _____786E_8BA4_6309_94AE ~= 0 then
        _____663E_793A_5E27(nil, _____786E_8BA4_6309_94AE)
    end
    if _____5173_95ED_6309_94AE ~= 0 then
        _____663E_793A_5E27(nil, _____5173_95ED_6309_94AE)
    end
    _____5237_65B0_9009_9879_6309_94AE_6587_5B57()
end
local function _____6253_5F00_5956_52B1_9009_62E9_6D4B_8BD5(_____73A9_5BB6)
    _____5F53_524D_73A9_5BB6 = _____73A9_5BB6
    _____9996_9886_5956_52B1_754C_9762["显示首领奖励选择界面"]()
    _____521B_5EFA_6D4B_8BD5_6309_94AE()
    _____91CD_7F6E_6D4B_8BD5_9009_62E9()
    _____63D0_793A("已打开测试界面：选择 2 件后点确认领取。")
end
local function _____91CD_7F6E_5956_52B1_9009_62E9_6D4B_8BD5_9886_53D6_72B6_6001(_____73A9_5BB6)
    _____5F53_524D_73A9_5BB6 = _____73A9_5BB6
    local _____73A9_5BB6ID = GetPlayerId(_____73A9_5BB6)
    local _____5DF2_6E05_9664 = _____9996_9886_5956_52B1_9886_53D6_72B6_6001["清除首领奖励领取记录"](_____9996_9886_5956_52B1_914D_7F6E["瑟兰迪尔奖励池ID"], _____73A9_5BB6ID)
    _____63D0_793A(_____5DF2_6E05_9664 and "已重置本局领取记录，可再次测试。" or "当前没有领取记录。")
end
_____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3["注册聊天命令监听"](_____6D4B_8BD5_547D_4EE4, _____6253_5F00_5956_52B1_9009_62E9_6D4B_8BD5)
_____804A_5929_547D_4EE4_4E8B_4EF6_4E2D_5FC3["注册聊天命令监听"](_____91CD_7F6E_6D4B_8BD5_547D_4EE4, _____91CD_7F6E_5956_52B1_9009_62E9_6D4B_8BD5_9886_53D6_72B6_6001)
return ____exports
