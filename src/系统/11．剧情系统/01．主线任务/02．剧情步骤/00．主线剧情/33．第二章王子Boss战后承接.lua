local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入剧情进度"]
local ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E = ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5["创建并冻结剧情Boss预置"]
local _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90 = ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5["剧情Boss预置暂停来源"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["注册剧情运行时单位"]
local ____33A_FF0E_738B_5BAB_5BC6_5BA4_573A_666F_5355_4F4D = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.33A．王宫密室场景单位")
local _____5B9A_4F4D_5E76_767B_8BB0_738B_5BAB_5BC6_5BA4_5267_60C5_5355_4F4D = ____33A_FF0E_738B_5BAB_5BC6_5BA4_573A_666F_5355_4F4D["定位并登记王宫密室剧情单位"]
local _____738B_5BAB_5BC6_5BA4_5BF9_5CD9_955C_5934_9884_8BBE = ____33A_FF0E_738B_5BAB_5BC6_5BA4_573A_666F_5355_4F4D["王宫密室对峙镜头预设"]
local _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868 = ____33A_FF0E_738B_5BAB_5BC6_5BA4_573A_666F_5355_4F4D["王宫密室场景站位表"]
local _____64AD_653E_738B_5BAB_5BC6_5BA4_6F14_51FA_7279_6548 = ____33A_FF0E_738B_5BAB_5BC6_5BA4_573A_666F_5355_4F4D["播放王宫密室演出特效"]
local _____64AD_653E_738B_5BAB_4F20_9001_95E8_5C01_5370_7279_6548 = ____33A_FF0E_738B_5BAB_5BC6_5BA4_573A_666F_5355_4F4D["播放王宫传送门封印特效"]
local _____8BFB_53D6_6216_521B_5EFA_5E76_5B9A_4F4D_738B_5BAB_5BC6_5BA4_5267_60C5_5355_4F4D = ____33A_FF0E_738B_5BAB_5BC6_5BA4_573A_666F_5355_4F4D["读取或创建并定位王宫密室剧情单位"]
local ____12_FF0E_5267_60C5_7535_5F71_955C_5934 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.12．剧情电影镜头")
local _____5E94_7528_5267_60C5_7535_5F71_955C_5934 = ____12_FF0E_5267_60C5_7535_5F71_955C_5934["应用剧情电影镜头"]
local _____8FDB_5165_5267_60C5_7535_5F71_6A21_5F0F = ____12_FF0E_5267_60C5_7535_5F71_955C_5934["进入剧情电影模式"]
do
    local ____33_FF0E_7B2C_4E8C_7AE0_738B_5B50Boss_6218_540E_627F_63A5 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.33．第二章王子Boss战后承接")
    ____exports["章节末战后承接剧情片段"] = ____33_FF0E_7B2C_4E8C_7AE0_738B_5B50Boss_6218_540E_627F_63A5["章节末战后承接剧情片段"]
end
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_0.getRegisteredPlayerHero
local ____require_result_1 = require("系统.11．剧情系统.01．主线任务.01．主线剧情入口.02．主线剧情入口初始化")
local _____6CE8_518C_4E3B_7EBF_5267_60C5_8FD0_884C_65F6_5355_4F4D_8303_56F4_5165_53E3 = ____require_result_1["注册主线剧情运行时单位范围入口"]
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_2.YDUserDataGetSafe
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local ____require_result_4 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑")
local _____6253_5F00Boss_6B7B_4EA1_9996_9886_5956_52B1UI = ____require_result_4["打开Boss死亡首领奖励UI"]
local ____require_result_5 = require("系统.02．物品系统.18．首领奖励选择.01．奖励配置表.14．主线_菲利斯战利品")
local _____83F2_5229_65AF_5956_52B1_6C60ID = ____require_result_5["菲利斯奖励池ID"]
local ____require_result_6 = require("lib.扩展函数.封装函数.02．音效系统.07．原生任务音效")
local _____64AD_653E_539F_751F_4EFB_52A1_97F3_6548 = ____require_result_6["播放原生任务音效"]
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_7.createTimedEffect
local ____require_result_8 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_8["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_8["移除单位暂停"]
local ____require_result_9 = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.09．世界地图单位缓存")
local _____6D88_8D39_4E16_754C_5730_56FE_5355_4F4D_7F13_5B58 = ____require_result_9["消费世界地图单位缓存"]
local _____738B_5BAB_7981_536B_7F13_5B58_952E_8868 = ____require_result_9["王宫禁卫缓存键表"]
local GetDestructableX = jass.GetDestructableX
local GetDestructableY = jass.GetDestructableY
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IssueImmediateOrder = jass.IssueImmediateOrder
local IssuePointOrder = jass.IssuePointOrder
local Player = jass.Player
local ShowDestructable = jass.ShowDestructable
local ShowUnit = jass.ShowUnit
local SetUnitAnimation = jass.SetUnitAnimation
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitFacing = jass.SetUnitFacing
local KillUnit = jass.KillUnit
local _____91CC_79D1_7279_767B_573A_7279_6548 = "war3mapImported\\BlueRitualTarget.mdx"
local _____738B_5BAB_6F5C_5165_955C_5934_9884_8BBE = {
    X = 15925.86,
    Y = -24806.4,
    ["高度偏移"] = 0,
    ["旋转角度"] = 100,
    ["攻角"] = 324,
    ["距离到目标"] = 2500,
    ["滚动角度"] = 0,
    ["观察区域"] = 70,
    ["远景剪裁"] = 5000
}
local _____738B_5BAB_95E8_53E3_8FD1_666F_955C_5934_9884_8BBE = {
    X = 15864.2,
    Y = -24381.7,
    ["高度偏移"] = 200,
    ["旋转角度"] = 40,
    ["攻角"] = 344,
    ["距离到目标"] = 1000.61,
    ["滚动角度"] = 0,
    ["观察区域"] = 70,
    ["远景剪裁"] = 5000
}
local _____7B2C_4E8C_7AE0_6218_540E_5BF9_767D_73A9_5BB6_5F15_7528 = "剧情运行时.第二章战后对白玩家"
local _____5DF2_6CE8_518C_738B_5BAB_5BC6_5BA4_627F_63A5_5165_53E3 = false
local _____738B_5BAB_7981_536B_5355_4F4D_5217_8868 = {}
local _____738B_5BAB_5BC6_5BA4_95E8_5916_5BF9_767D_6807_8BB0_8868 = "主线剧情标记"
local _____738B_5BAB_5BC6_5BA4_95E8_5916_5BF9_767D_6807_8BB0_952E = "第二章王宫密室门外对白已完成"
local function _____738B_5BAB_5BC6_5BA4_95E8_5916_5BF9_767D_5C1A_672A_5B8C_6210()
    return __TS__Number(YDUserDataGetSafe("string", _____738B_5BAB_5BC6_5BA4_95E8_5916_5BF9_767D_6807_8BB0_8868, _____738B_5BAB_5BC6_5BA4_95E8_5916_5BF9_767D_6807_8BB0_952E, "integer")) ~= 1
end
local _____738B_5BAB_7981_536B_51FB_6740_7279_6548 = "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl"
local function _____6267_884C_91CC_79D1_7279_51FB_6740_738B_5BAB_7981_536B()
    do
        local i = 0
        while i < #_____738B_5BAB_7981_536B_5355_4F4D_5217_8868 do
            do
                local _____7981_536B = _____738B_5BAB_7981_536B_5355_4F4D_5217_8868[i + 1]
                if _____7981_536B == nil or _____7981_536B == 0 then
                    goto __continue5
                end
                IssueImmediateOrder(_____7981_536B, "stop")
                SetUnitAnimation(_____7981_536B, "death")
                createTimedEffect(
                    _____738B_5BAB_7981_536B_51FB_6740_7279_6548,
                    GetUnitX(_____7981_536B),
                    GetUnitY(_____7981_536B),
                    0,
                    1
                )
                KillUnit(_____7981_536B)
            end
            ::__continue5::
            i = i + 1
        end
    end
end
local function _____767B_8BB0_7B2C_4E8C_7AE0_6218_540E_5BF9_767D_73A9_5BB6()
    local _____73A9_5BB6_5355_4F4D = getRegisteredPlayerHero(Player(0))
    if _____73A9_5BB6_5355_4F4D ~= nil and _____73A9_5BB6_5355_4F4D ~= 0 then
        _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____7B2C_4E8C_7AE0_6218_540E_5BF9_767D_73A9_5BB6_5F15_7528, _____73A9_5BB6_5355_4F4D)
    end
end
local function _____767B_8BB0_738B_5BAB_56DB_540D_9884_7F6E_7981_536B()
    _____738B_5BAB_7981_536B_5355_4F4D_5217_8868 = {}
    do
        local i = 0
        while i < #_____738B_5BAB_7981_536B_7F13_5B58_952E_8868 do
            do
                local _____7F13_5B58_952E = _____738B_5BAB_7981_536B_7F13_5B58_952E_8868[i + 1]
                local _____7981_536B = _____6D88_8D39_4E16_754C_5730_56FE_5355_4F4D_7F13_5B58(_____7F13_5B58_952E)
                if _____7981_536B == nil or _____7981_536B == 0 then
                    goto __continue11
                end
                _____738B_5BAB_7981_536B_5355_4F4D_5217_8868[#_____738B_5BAB_7981_536B_5355_4F4D_5217_8868 + 1] = _____7981_536B
                IssueImmediateOrder(_____7981_536B, "stop")
                _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____7F13_5B58_952E, _____7981_536B)
            end
            ::__continue11::
            i = i + 1
        end
    end
end
local function _____4F7F_738B_5BAB_7981_536B_9762_5411_91CC_79D1_7279()
    local _____91CC_79D1_7279_7AD9_4F4D = _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["里科特王宫异变"]
    do
        local i = 0
        while i < #_____738B_5BAB_7981_536B_5355_4F4D_5217_8868 do
            do
                local _____7981_536B = _____738B_5BAB_7981_536B_5355_4F4D_5217_8868[i + 1]
                if _____7981_536B == nil or _____7981_536B == 0 then
                    goto __continue15
                end
                SetUnitFacing(
                    _____7981_536B,
                    math.atan(
                        _____91CC_79D1_7279_7AD9_4F4D.Y - GetUnitY(_____7981_536B),
                        _____91CC_79D1_7279_7AD9_4F4D.X - GetUnitX(_____7981_536B)
                    ) * 180 / math.pi
                )
                IssueImmediateOrder(_____7981_536B, "stop")
            end
            ::__continue15::
            i = i + 1
        end
    end
end
____exports["执行章节末长对白承接"] = function(_____53C2_6570)
    _____8FDB_5165_5267_60C5_7535_5F71_6A21_5F0F()
    _____767B_8BB0_7B2C_4E8C_7AE0_6218_540E_5BF9_767D_73A9_5BB6()
    _____5199_5165_5267_60C5_8FDB_5EA6(__TS__Number(_____53C2_6570["设置剧情进度"]) or __TS__Number(_____53C2_6570["目标进度"]) or 33)
end
____exports["执行章节末紧急警告"] = function(______53C2_6570)
    _____64AD_653E_539F_751F_4EFB_52A1_97F3_6548("警告")
end
local function _____6267_884C_5E03_7F6E_738B_5BAB_6F5C_5165_73B0_573A()
    _____767B_8BB0_738B_5BAB_56DB_540D_9884_7F6E_7981_536B()
    _____8BFB_53D6_6216_521B_5EFA_5E76_5B9A_4F4D_738B_5BAB_5BC6_5BA4_5267_60C5_5355_4F4D("主线NPC.伪装卫兵", "精灵王卫", _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["伪装卫兵王宫异变"])
    local _____7687_5BB6_7981_536B = _____8BFB_53D6_6216_521B_5EFA_5E76_5B9A_4F4D_738B_5BAB_5BC6_5BA4_5267_60C5_5355_4F4D("主线NPC.皇家禁卫", "虔诚的高等精灵骑士", _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["皇家禁卫王宫异变"])
    if _____7687_5BB6_7981_536B ~= nil and _____7687_5BB6_7981_536B ~= 0 then
        _____738B_5BAB_7981_536B_5355_4F4D_5217_8868[#_____738B_5BAB_7981_536B_5355_4F4D_5217_8868 + 1] = _____7687_5BB6_7981_536B
    end
    local _____91CC_79D1_7279 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("Boss.里科特")
    if _____91CC_79D1_7279 == nil or _____91CC_79D1_7279 == 0 then
        _____91CC_79D1_7279 = _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E({
            ["Boss键"] = "Boss.里科特",
            ["Boss名"] = "里科特",
            X = _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["里科特王宫异变"].X,
            Y = _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["里科特王宫异变"].Y,
            ["朝向"] = _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["里科特王宫异变"]["朝向"],
            ["预创建后暂停"] = true,
            ["预创建后无敌"] = true
        })
    end
    if _____91CC_79D1_7279 == nil or _____91CC_79D1_7279 == 0 then
        return
    end
    _____5B9A_4F4D_5E76_767B_8BB0_738B_5BAB_5BC6_5BA4_5267_60C5_5355_4F4D("Boss.里科特", "Boss.里科特", _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["里科特王宫异变"])
    ShowUnit(_____91CC_79D1_7279, false)
    _____4F7F_738B_5BAB_7981_536B_9762_5411_91CC_79D1_7279()
    _____5E94_7528_5267_60C5_7535_5F71_955C_5934(_____738B_5BAB_6F5C_5165_955C_5934_9884_8BBE, 0)
end
local function _____6267_884C_91CC_79D1_7279_73B0_8EAB()
    local _____91CC_79D1_7279 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("Boss.里科特")
    if _____91CC_79D1_7279 == nil or _____91CC_79D1_7279 == 0 then
        return
    end
    local _____7AD9_4F4D = _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["里科特王宫异变"]
    createTimedEffect(
        _____91CC_79D1_7279_767B_573A_7279_6548,
        _____7AD9_4F4D.X,
        _____7AD9_4F4D.Y,
        0,
        1.2
    )
    ShowUnit(_____91CC_79D1_7279, true)
    _____4F7F_738B_5BAB_7981_536B_9762_5411_91CC_79D1_7279()
end
local function _____6267_884C_91CC_79D1_7279_5A01_6151_7981_536B()
    local _____91CC_79D1_7279 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("Boss.里科特")
    if _____91CC_79D1_7279 ~= nil and _____91CC_79D1_7279 ~= 0 then
        SetUnitAnimationByIndex(_____91CC_79D1_7279, 4)
    end
end
local function _____6267_884C_5207_6362_738B_5BAB_95E8_53E3_8FD1_666F_955C_5934()
    _____5E94_7528_5267_60C5_7535_5F71_955C_5934(_____738B_5BAB_95E8_53E3_8FD1_666F_955C_5934_9884_8BBE, 0)
end
local function _____6267_884C_91CC_79D1_7279_8D70_5411_738B_5BAB_4F20_9001_95E8()
    local _____91CC_79D1_7279 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("Boss.里科特")
    local _____4F20_9001_95E8 = jglobals.gg_dest_B00K_5466
    if _____4F20_9001_95E8 == nil or _____4F20_9001_95E8 == 0 or _____91CC_79D1_7279 == nil or _____91CC_79D1_7279 == 0 then
        return
    end
    ShowDestructable(_____4F20_9001_95E8, true)
    local _____4F20_9001_95E8X = GetDestructableX(_____4F20_9001_95E8)
    local _____4F20_9001_95E8Y = GetDestructableY(_____4F20_9001_95E8)
    local dx = GetUnitX(_____91CC_79D1_7279) - _____4F20_9001_95E8X
    local dy = GetUnitY(_____91CC_79D1_7279) - _____4F20_9001_95E8Y
    local distance = math.sqrt(dx * dx + dy * dy)
    local scale = distance > 0.01 and 50 / distance or 0
    local _____76EE_6807X = _____4F20_9001_95E8X + dx * scale
    local _____76EE_6807Y = distance > 0.01 and _____4F20_9001_95E8Y + dy * scale or _____4F20_9001_95E8Y + 50
    _____79FB_9664_5355_4F4D_6682_505C(_____91CC_79D1_7279, _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90)
    IssuePointOrder(_____91CC_79D1_7279, "move", _____76EE_6807X, _____76EE_6807Y)
end
local function _____6267_884C_5E03_7F6E_4F20_627F_5BC6_5BA4_5BF9_5CD9_573A_666F()
    _____5B9A_4F4D_5E76_767B_8BB0_738B_5BAB_5BC6_5BA4_5267_60C5_5355_4F4D("ZX.克林姆德王", "主线NPC.克林姆德王", _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["克林姆德王对峙"])
    _____5B9A_4F4D_5E76_767B_8BB0_738B_5BAB_5BC6_5BA4_5267_60C5_5355_4F4D("ZX.赫克提尔", "主线NPC.赫克提尔", _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["赫克提尔对峙"])
    _____5B9A_4F4D_5E76_767B_8BB0_738B_5BAB_5BC6_5BA4_5267_60C5_5355_4F4D("Boss.里科特", "Boss.里科特", _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["里科特密室"])
    _____5E94_7528_5267_60C5_7535_5F71_955C_5934(_____738B_5BAB_5BC6_5BA4_5BF9_5CD9_955C_5934_9884_8BBE, 0)
end
local function _____6267_884C_91CC_79D1_7279_8FDB_5165_4F20_627F_5BC6_5BA4()
    _____64AD_653E_738B_5BAB_5BC6_5BA4_6F14_51FA_7279_6548("里科特进入传承密室", _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["里科特密室"])
end
local function _____6267_884C_5E03_7F6E_738B_5BAB_95E8_5916_56DE_63F4_4EBA_5458()
    local _____827E_4F26 = _____8BFB_53D6_6216_521B_5EFA_5E76_5B9A_4F4D_738B_5BAB_5BC6_5BA4_5267_60C5_5355_4F4D("主线NPC.艾伦", "王宫卫队长-艾伦", _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["艾伦密室门外"])
    local _____91CC_51E1_7279 = _____8BFB_53D6_6216_521B_5EFA_5E76_5B9A_4F4D_738B_5BAB_5BC6_5BA4_5267_60C5_5355_4F4D("主线NPC.里凡特", "第一王子-里凡特", _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["里凡特密室门外"])
    _____8BFB_53D6_6216_521B_5EFA_5E76_5B9A_4F4D_738B_5BAB_5BC6_5BA4_5267_60C5_5355_4F4D("主线NPC.耶提尔", "防卫部长-耶提尔", _____738B_5BAB_5BC6_5BA4_573A_666F_7AD9_4F4D_8868["耶提尔返回王宫"])
    if _____91CC_51E1_7279 ~= nil and _____91CC_51E1_7279 ~= 0 then
        do
            local i = 0
            while i < #_____738B_5BAB_7981_536B_5355_4F4D_5217_8868 do
                do
                    local _____7981_536B = _____738B_5BAB_7981_536B_5355_4F4D_5217_8868[i + 1]
                    if _____7981_536B == nil or _____7981_536B == 0 then
                        goto __continue35
                    end
                    IssuePointOrder(
                        _____7981_536B,
                        "move",
                        GetUnitX(_____91CC_51E1_7279),
                        GetUnitY(_____91CC_51E1_7279)
                    )
                end
                ::__continue35::
                i = i + 1
            end
        end
    end
    if _____5DF2_6CE8_518C_738B_5BAB_5BC6_5BA4_627F_63A5_5165_53E3 then
        return
    end
    _____5DF2_6CE8_518C_738B_5BAB_5BC6_5BA4_627F_63A5_5165_53E3 = true
    local _____5165_53E3_57FA_7840_914D_7F6E = {
        ["剧情片段ID"] = "elven_city_prince_boss_start",
        ["注册范围"] = 400,
        ["需要剧情进度"] = 33,
        ["触发后注销"] = true,
        ["运行时条件"] = _____738B_5BAB_5BC6_5BA4_95E8_5916_5BF9_767D_5C1A_672A_5B8C_6210
    }
    _____6CE8_518C_4E3B_7EBF_5267_60C5_8FD0_884C_65F6_5355_4F4D_8303_56F4_5165_53E3(
        _____827E_4F26,
        __TS__ObjectAssign({}, _____5165_53E3_57FA_7840_914D_7F6E, {["配置名"] = "艾伦密室承接"})
    )
    _____6CE8_518C_4E3B_7EBF_5267_60C5_8FD0_884C_65F6_5355_4F4D_8303_56F4_5165_53E3(
        _____91CC_51E1_7279,
        __TS__ObjectAssign({}, _____5165_53E3_57FA_7840_914D_7F6E, {["配置名"] = "里凡特密室承接"})
    )
end
local function _____6267_884C_91CC_79D1_7279_5F00_542F_4F20_627F_5BC6_5BA4_95E8()
    _____64AD_653E_738B_5BAB_4F20_9001_95E8_5C01_5370_7279_6548()
end
local function _____6267_884C_5B8C_6210_91CC_79D1_7279_4F20_9001_5165_5BC6_5BA4()
    local _____91CC_79D1_7279 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("Boss.里科特")
    if _____91CC_79D1_7279 ~= nil and _____91CC_79D1_7279 ~= 0 then
        IssueImmediateOrder(_____91CC_79D1_7279, "stop")
        _____6DFB_52A0_5355_4F4D_6682_505C(_____91CC_79D1_7279, _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90)
        ShowUnit(_____91CC_79D1_7279, false)
    end
    _____6267_884C_5E03_7F6E_4F20_627F_5BC6_5BA4_5BF9_5CD9_573A_666F()
    if _____91CC_79D1_7279 ~= nil and _____91CC_79D1_7279 ~= 0 then
        ShowUnit(_____91CC_79D1_7279, true)
    end
    _____6267_884C_91CC_79D1_7279_8FDB_5165_4F20_627F_5BC6_5BA4()
    _____6267_884C_5E03_7F6E_738B_5BAB_95E8_5916_56DE_63F4_4EBA_5458()
end
local function _____6267_884C_6253_5F00_83F2_5229_65AF_9996_9886_5956_52B1()
    addDelayedCallback(
        100,
        function()
            _____6253_5F00Boss_6B7B_4EA1_9996_9886_5956_52B1UI(_____83F2_5229_65AF_5956_52B1_6C60ID)
        end
    )
end
____exports["第二章王子Boss战后承接剧情动作注册表"] = {
    ["SW01死亡事件_章节末长对白承接"] = ____exports["执行章节末长对白承接"],
    ["SW01死亡事件_章节末紧急警告"] = ____exports["执行章节末紧急警告"],
    ["JLC精灵城_布置王宫潜入现场"] = _____6267_884C_5E03_7F6E_738B_5BAB_6F5C_5165_73B0_573A,
    ["JLC精灵城_里科特现身"] = _____6267_884C_91CC_79D1_7279_73B0_8EAB,
    ["JLC精灵城_里科特威慑禁卫"] = _____6267_884C_91CC_79D1_7279_5A01_6151_7981_536B,
    ["JLC精灵城_里科特击杀王宫禁卫"] = _____6267_884C_91CC_79D1_7279_51FB_6740_738B_5BAB_7981_536B,
    ["JLC精灵城_切换王宫门口近景镜头"] = _____6267_884C_5207_6362_738B_5BAB_95E8_53E3_8FD1_666F_955C_5934,
    ["JLC精灵城_里科特开启传承密室门"] = _____6267_884C_91CC_79D1_7279_5F00_542F_4F20_627F_5BC6_5BA4_95E8,
    ["JLC精灵城_里科特走向王宫传送门"] = _____6267_884C_91CC_79D1_7279_8D70_5411_738B_5BAB_4F20_9001_95E8,
    ["JLC精灵城_布置传承密室对峙场景"] = _____6267_884C_5E03_7F6E_4F20_627F_5BC6_5BA4_5BF9_5CD9_573A_666F,
    ["JLC精灵城_里科特进入传承密室"] = _____6267_884C_91CC_79D1_7279_8FDB_5165_4F20_627F_5BC6_5BA4,
    ["JLC精灵城_布置王宫门外回援人员"] = _____6267_884C_5E03_7F6E_738B_5BAB_95E8_5916_56DE_63F4_4EBA_5458,
    ["JLC精灵城_完成里科特传送入密室"] = _____6267_884C_5B8C_6210_91CC_79D1_7279_4F20_9001_5165_5BC6_5BA4,
    ["主线.打开菲利斯首领奖励"] = _____6267_884C_6253_5F00_83F2_5229_65AF_9996_9886_5956_52B1
}
return ____exports
