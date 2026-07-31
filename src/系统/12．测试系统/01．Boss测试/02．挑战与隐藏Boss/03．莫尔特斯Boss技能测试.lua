--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local globals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("lib.扩展函数.BJ函数.11．贴图函数")
local CreateUbersplatBJ = ____require_result_1.CreateUbersplatBJ
local ShowUbersplatBJ = ____require_result_1.ShowUbersplatBJ
local SetUbersplatRenderAlways = ____require_result_1.SetUbersplatRenderAlways
local ____require_result_2 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_2.SelectUnitForPlayerSingle
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_3.StarOther_PanCameraToTimedForPlayer
local ____require_result_4 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_4["应用Boss战启动属性配置"]
local ____require_result_5 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_5["标记测试Boss跳过死亡结算"]
local ____require_result_6 = require("系统.12．测试系统.00．Boss测试系统.index")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_6["Boss测试单位存活"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_6["设置Boss测试单位满血"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_6["获取Boss测试玩家基准英雄"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175 = ____require_result_6["准备Boss测试固定步兵"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B = ____require_result_6["准备Boss测试固定山丘之王"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_6["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_6["注册Boss测试命令组"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587 = ____require_result_7["获取或创建莫尔特斯上下文"]
local _____6E05_7406_83AB_5C14_7279_65AF_4E0A_4E0B_6587 = ____require_result_7["清理莫尔特斯上下文"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.03．腐败值与根须领域")
local _____786E_4FDD_83AB_5C14_7279_65AF_6839_987B_5BAB_683C = ____require_result_8["确保莫尔特斯根须宫格"]
local _____5E94_7528_83AB_5C14_7279_65AF_8150_8D25_503C = ____require_result_8["应用莫尔特斯腐败值"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.15．被动效果")
local _____6CE8_518C_83AB_5C14_7279_65AF_88AB_52A8_6548_679C = ____require_result_9["注册莫尔特斯被动效果"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.04．腐朽根须穿刺")
local _____91CA_653E_83AB_5C14_7279_65AF_8150_673D_6839_987B_7A7F_523A = ____require_result_10["释放莫尔特斯腐朽根须穿刺"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.05．腐败孢子云")
local _____91CA_653E_83AB_5C14_7279_65AF_8150_8D25_5B62_5B50_4E91 = ____require_result_11["释放莫尔特斯腐败孢子云"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.06．扭曲荆棘鞭笞")
local _____91CA_653E_83AB_5C14_7279_65AF_626D_66F2_8346_68D8_97AD_7B1E = ____require_result_12["释放莫尔特斯扭曲荆棘鞭笞"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.07．腐败之种")
local _____91CA_653E_83AB_5C14_7279_65AF_8150_8D25_4E4B_79CD = ____require_result_13["释放莫尔特斯腐败之种"]
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.08．根系觉醒")
local _____89E6_53D1_83AB_5C14_7279_65AF_6839_7CFB_89C9_9192 = ____require_result_14["触发莫尔特斯根系觉醒"]
local ____require_result_15 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.09．腐朽领域")
local _____89E6_53D1_83AB_5C14_7279_65AF_8150_673D_9886_57DF = ____require_result_15["触发莫尔特斯腐朽领域"]
local ____require_result_16 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.10．共生腐朽虫群")
local _____91CA_653E_83AB_5C14_7279_65AF_5171_751F_8150_673D_866B_7FA4 = ____require_result_16["释放莫尔特斯共生腐朽虫群"]
local _____6D4B_8BD5_91CA_653E_83AB_5C14_7279_65AF_5171_751F_8150_673D_866B_7FA4_5E76_5EF6_8FDF_51FB_6740 = ____require_result_16["测试释放莫尔特斯共生腐朽虫群并延迟击杀"]
local ____require_result_17 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.11．古木悲鸣")
local _____91CA_653E_83AB_5C14_7279_65AF_53E4_6728_60B2_9E23 = ____require_result_17["释放莫尔特斯古木悲鸣"]
local ____require_result_18 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.12．腐败传输")
local _____6D4B_8BD5_89E6_53D1_83AB_5C14_7279_65AF_8150_8D25_4F20_8F93 = ____require_result_18["测试触发莫尔特斯腐败传输"]
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X = -540.6
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y = -2495.2
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y = -3055.2
local CreateUnit = jass.CreateUnit
local SetHeroLevel = jass.SetHeroLevel
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local GetPlayerId = jass.GetPlayerId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local Location = jass.Location
local RemoveLocation = jass.RemoveLocation
local _____83AB_5C14_7279_65AF_6D4B_8BD5Boss = {}
local _____83AB_5C14_7279_65AF_6D4B_8BD5_6B65_5175 = {}
local _____83AB_5C14_7279_65AF_6D4B_8BD5_5C71_4E18_4E4B_738B = {}
local _____83AB_5C14_7279_65AF_6D4B_8BD5ULAR = {}
local _____83AB_5C14_7279_65AFULAR_6D4B_8BD5_6A21_5757 = "莫尔特斯-ULAR测试"
local _____83AB_5C14_7279_65AFULAR_6D4B_8BD5_8986_76D6_8FB9_957F = 1536
local _____83AB_5C14_7279_65AFULAR_6D4B_8BD5_8986_76D6_884C_5217 = 4
local function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
local function _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    local pid = GetPlayerId(player)
    local cached = _____83AB_5C14_7279_65AF_6D4B_8BD5Boss[pid]
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(cached) then
        SetUnitPosition(cached, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y)
        SetUnitFacing(cached, 270)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(cached)
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(cached)
        globals.udg_Boss = cached
        return cached
    end
    local boss = CreateUnit(
        player,
        stringToFourCC("N05W"),
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X,
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y,
        270
    )
    if boss ~= nil and boss ~= 0 then
        _____83AB_5C14_7279_65AF_6D4B_8BD5Boss[pid] = boss
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
        SetHeroLevel(boss, 42, false)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(boss)
        globals.udg_Boss = boss
    end
    return boss
end
local function _____51C6_5907_6D4B_8BD5_573A_666F(player, boss)
    local pid = GetPlayerId(player)
    local hero = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    if hero ~= nil and hero ~= 0 then
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    end
    _____83AB_5C14_7279_65AF_6D4B_8BD5_6B65_5175[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(_____83AB_5C14_7279_65AF_6D4B_8BD5_6B65_5175[pid], _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X - 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 180, 90)
    _____83AB_5C14_7279_65AF_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B(_____83AB_5C14_7279_65AF_6D4B_8BD5_5C71_4E18_4E4B_738B[pid], _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X + 100, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y + 100, 90)
    SelectUnitForPlayerSingle(boss, player)
    StarOther_PanCameraToTimedForPlayer(player, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y, 0.2)
end
local function _____542F_52A8Boss_6D4B_8BD5_94FE_8DEF(boss)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(boss)
end
local function _____6E05_7406_83AB_5C14_7279_65AF_6D4B_8BD5ULAR_7F13_5B58(data)
    if data == nil then
        return
    end
    _____83AB_5C14_7279_65AF_6D4B_8BD5ULAR[data.pid] = nil
end
local function ____on_83AB_5C14_7279_65AFULAR_6D4B_8BD5_547D_4EE4(player, context)
    local archmage = globals.gg_unit_Hamg_0002
    if archmage == nil or archmage == 0 then
        debugLogForce(_____83AB_5C14_7279_65AFULAR_6D4B_8BD5_6A21_5757, "创建失败", "原因=找不到 gg_unit_Hamg_0002")
        return
    end
    local pid = GetPlayerId(player)
    local cached = _____83AB_5C14_7279_65AF_6D4B_8BD5ULAR[pid]
    if cached ~= nil and #cached > 0 then
        do
            local i = 0
            while i < #cached do
                local ubersplat = cached[i + 1]
                SetUbersplatRenderAlways(ubersplat, true)
                ShowUbersplatBJ(true, ubersplat)
                i = i + 1
            end
        end
        debugLogForce(
            _____83AB_5C14_7279_65AFULAR_6D4B_8BD5_6A21_5757,
            "复用已有贴图阵列",
            "数量=",
            #cached,
            "单位=",
            archmage
        )
        return
    end
    if context == nil or context["清理"] == nil then
        debugLogForce(_____83AB_5C14_7279_65AFULAR_6D4B_8BD5_6A21_5757, "创建失败", "原因=莫尔特斯测试上下文不存在")
        return
    end
    local x = GetUnitX(archmage)
    local y = GetUnitY(archmage)
    local _____5DE6 = x - _____83AB_5C14_7279_65AFULAR_6D4B_8BD5_8986_76D6_8FB9_957F / 2
    local _____4E0B = y - _____83AB_5C14_7279_65AFULAR_6D4B_8BD5_8986_76D6_8FB9_957F / 2
    local _____5355_683C_8FB9_957F = _____83AB_5C14_7279_65AFULAR_6D4B_8BD5_8986_76D6_8FB9_957F / _____83AB_5C14_7279_65AFULAR_6D4B_8BD5_8986_76D6_884C_5217
    local _____8D34_56FE_5217_8868 = {}
    do
        local row = 0
        while row < _____83AB_5C14_7279_65AFULAR_6D4B_8BD5_8986_76D6_884C_5217 do
            do
                local col = 0
                while col < _____83AB_5C14_7279_65AFULAR_6D4B_8BD5_8986_76D6_884C_5217 do
                    do
                        local _____8D34_56FEX = _____5DE6 + _____5355_683C_8FB9_957F * (col + 0.5)
                        local _____8D34_56FEY = _____4E0B + _____5355_683C_8FB9_957F * (row + 0.5)
                        local loc = Location(_____8D34_56FEX, _____8D34_56FEY)
                        local ubersplat = CreateUbersplatBJ(
                            loc,
                            "ULAR",
                            100,
                            100,
                            100,
                            0,
                            false,
                            false
                        )
                        RemoveLocation(loc)
                        if ubersplat == nil or ubersplat == 0 then
                            goto __continue20
                        end
                        SetUbersplatRenderAlways(ubersplat, true)
                        ShowUbersplatBJ(true, ubersplat)
                        _____8D34_56FE_5217_8868[#_____8D34_56FE_5217_8868 + 1] = ubersplat
                        local ____self_19 = context["清理"]
                        ____self_19["登记贴图"](____self_19, "莫尔特斯-ULAR测试", ubersplat)
                    end
                    ::__continue20::
                    col = col + 1
                end
            end
            row = row + 1
        end
    end
    if #_____8D34_56FE_5217_8868 == 0 then
        debugLogForce(
            _____83AB_5C14_7279_65AFULAR_6D4B_8BD5_6A21_5757,
            "创建失败",
            "x=",
            x,
            "y=",
            y,
            "数量=",
            #_____8D34_56FE_5217_8868
        )
        return
    end
    _____83AB_5C14_7279_65AF_6D4B_8BD5ULAR[pid] = _____8D34_56FE_5217_8868
    local ____self_20 = context["清理"]
    ____self_20["登记清理"](____self_20, "莫尔特斯-ULAR测试缓存", _____6E05_7406_83AB_5C14_7279_65AF_6D4B_8BD5ULAR_7F13_5B58, {pid = pid})
    debugLogForce(
        _____83AB_5C14_7279_65AFULAR_6D4B_8BD5_6A21_5757,
        "创建成功",
        "x=",
        x,
        "y=",
        y,
        "覆盖网格=",
        _____83AB_5C14_7279_65AFULAR_6D4B_8BD5_8986_76D6_884C_5217,
        "x",
        _____83AB_5C14_7279_65AFULAR_6D4B_8BD5_8986_76D6_884C_5217,
        "数量=",
        #_____8D34_56FE_5217_8868,
        "单位=",
        archmage
    )
end
local function _____521B_5EFA_83AB_5C14_7279_65AF_6D4B_8BD5(player)
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return nil
    end
    _____6CE8_518C_83AB_5C14_7279_65AF_88AB_52A8_6548_679C()
    _____51C6_5907_6D4B_8BD5_573A_666F(player, boss)
    _____542F_52A8Boss_6D4B_8BD5_94FE_8DEF(boss)
    local hero = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    local context = _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587(boss)
    if context ~= nil then
        context["根须领域中心X"] = _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X
        context["根须领域中心Y"] = _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y
        context["根须穿刺测试格子索引"] = {0, 1, 2}
        context["测试额外虫尸拾取单位"] = hero ~= nil and hero ~= 0 and ({hero}) or ({})
        debugLogForce(
            "莫尔特斯测试场景",
            "虫尸拾取测试单位",
            "大法师=",
            hero,
            "有效=",
            hero ~= nil and hero ~= 0,
            "数量=",
            context["测试额外虫尸拾取单位"].length
        )
        _____786E_4FDD_83AB_5C14_7279_65AF_6839_987B_5BAB_683C(context)
        debugLogForce(
            "莫尔特斯测试场景",
            "场景初始化",
            "Boss=",
            boss,
            "中心=",
            context["根须领域中心X"],
            context["根须领域中心Y"],
            "根须宫格=",
            context["根须宫格"] == nil and "nil" or "ready"
        )
    end
    return context
end
local function _____6E05_7406_83AB_5C14_7279_65AF_6D4B_8BD5(player, _context)
    local pid = GetPlayerId(player)
    local boss = _____83AB_5C14_7279_65AF_6D4B_8BD5Boss[pid]
    if boss ~= nil and boss ~= 0 then
        _____6E05_7406_83AB_5C14_7279_65AF_4E0A_4E0B_6587(boss)
    end
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____83AB_5C14_7279_65AF_6D4B_8BD5_6B65_5175[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____83AB_5C14_7279_65AF_6D4B_8BD5_5C71_4E18_4E4B_738B[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(boss)
    _____83AB_5C14_7279_65AF_6D4B_8BD5_6B65_5175[pid] = nil
    _____83AB_5C14_7279_65AF_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = nil
    _____83AB_5C14_7279_65AF_6D4B_8BD5ULAR[pid] = nil
    _____83AB_5C14_7279_65AF_6D4B_8BD5Boss[pid] = nil
    if globals.udg_Boss == boss then
        globals.udg_Boss = nil
    end
end
local function ____on_83AB_5C14_7279_65AF_6280_80FD1_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_83AB_5C14_7279_65AF_8150_673D_6839_987B_7A7F_523A(context)
    end
end
local function ____on_83AB_5C14_7279_65AF_6280_80FD2_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_83AB_5C14_7279_65AF_8150_8D25_5B62_5B50_4E91(context)
    end
end
local function ____on_83AB_5C14_7279_65AF_6280_80FD3_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_83AB_5C14_7279_65AF_626D_66F2_8346_68D8_97AD_7B1E(context)
    end
end
local function ____on_83AB_5C14_7279_65AF_6280_80FD4_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_83AB_5C14_7279_65AF_8150_8D25_4E4B_79CD(context)
    end
end
local function ____on_83AB_5C14_7279_65AF_6280_80FD5_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____89E6_53D1_83AB_5C14_7279_65AF_6839_7CFB_89C9_9192(context)
    end
end
local function ____on_83AB_5C14_7279_65AF_6280_80FD6_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____89E6_53D1_83AB_5C14_7279_65AF_8150_673D_9886_57DF(context)
    end
end
local function ____on_83AB_5C14_7279_65AF_6280_80FD7_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_83AB_5C14_7279_65AF_5171_751F_8150_673D_866B_7FA4(context)
    end
end
local function ____on_83AB_5C14_7279_65AF_6280_80FD7_2_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____6D4B_8BD5_91CA_653E_83AB_5C14_7279_65AF_5171_751F_8150_673D_866B_7FA4_5E76_5EF6_8FDF_51FB_6740(context)
    end
end
local function ____on_83AB_5C14_7279_65AF_6280_80FD8_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_83AB_5C14_7279_65AF_53E4_6728_60B2_9E23(context)
    end
end
local function ____on_83AB_5C14_7279_65AF_88AB_52A8_8150_8D25_6EE1_5C42_6D4B_8BD5_547D_4EE4(player, context)
    local target = _____83AB_5C14_7279_65AF_6D4B_8BD5_6B65_5175[GetPlayerId(player)]
    local targetAlive = target ~= nil and target ~= 0 and ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target)
    if context == nil or not targetAlive then
        return
    end
    SelectUnitForPlayerSingle(target, player)
    StarOther_PanCameraToTimedForPlayer(
        player,
        GetUnitX(target),
        GetUnitY(target),
        0.2
    )
    _____5E94_7528_83AB_5C14_7279_65AF_8150_8D25_503C(context, target, 100)
end
local function ____on_83AB_5C14_7279_65AF_88AB_52A8_8150_8D25_4F20_8F93_6D4B_8BD5_547D_4EE4(player, context)
    local ____temp_21
    if context ~= nil then
        ____temp_21 = context["Boss单位"]
    else
        ____temp_21 = nil
    end
    local boss = ____temp_21
    local bossAlive = boss ~= nil and boss ~= 0 and ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss)
    if context == nil or not bossAlive then
        return
    end
    SelectUnitForPlayerSingle(boss, player)
    StarOther_PanCameraToTimedForPlayer(
        player,
        GetUnitX(boss),
        GetUnitY(boss),
        0.2
    )
    _____6D4B_8BD5_89E6_53D1_83AB_5C14_7279_65AF_8150_8D25_4F20_8F93(context)
end
local _____83AB_5C14_7279_65AF_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 11, ["命令"] = "ular", ["名称"] = "测试大法师位置的ULAR地表贴图", ["执行"] = ____on_83AB_5C14_7279_65AFULAR_6D4B_8BD5_547D_4EE4},
    {["序号"] = 1, ["名称"] = "腐朽根须穿刺", ["执行"] = ____on_83AB_5C14_7279_65AF_6280_80FD1_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["名称"] = "腐败孢子云", ["执行"] = ____on_83AB_5C14_7279_65AF_6280_80FD2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 3, ["名称"] = "扭曲荆棘鞭笞", ["执行"] = ____on_83AB_5C14_7279_65AF_6280_80FD3_6D4B_8BD5_547D_4EE4},
    {["序号"] = 4, ["名称"] = "腐败之种", ["执行"] = ____on_83AB_5C14_7279_65AF_6280_80FD4_6D4B_8BD5_547D_4EE4},
    {["序号"] = 5, ["名称"] = "根系觉醒", ["执行"] = ____on_83AB_5C14_7279_65AF_6280_80FD5_6D4B_8BD5_547D_4EE4},
    {["序号"] = 6, ["名称"] = "腐朽领域", ["执行"] = ____on_83AB_5C14_7279_65AF_6280_80FD6_6D4B_8BD5_547D_4EE4},
    {["序号"] = 7, ["名称"] = "共生腐朽虫群", ["执行"] = ____on_83AB_5C14_7279_65AF_6280_80FD7_6D4B_8BD5_547D_4EE4},
    {["序号"] = 7, ["命令"] = "7-2", ["名称"] = "共生腐朽虫群测试：2秒后逐只击杀并播放爆炸表现", ["执行"] = ____on_83AB_5C14_7279_65AF_6280_80FD7_2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 8, ["名称"] = "古木悲鸣", ["执行"] = ____on_83AB_5C14_7279_65AF_6280_80FD8_6D4B_8BD5_547D_4EE4},
    {["序号"] = 9, ["名称"] = "被动：腐败值满层缠绕", ["执行"] = ____on_83AB_5C14_7279_65AF_88AB_52A8_8150_8D25_6EE1_5C42_6D4B_8BD5_547D_4EE4},
    {["序号"] = 10, ["名称"] = "被动：腐败传输与护盾", ["执行"] = ____on_83AB_5C14_7279_65AF_88AB_52A8_8150_8D25_4F20_8F93_6D4B_8BD5_547D_4EE4}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "莫尔特斯",
    ["Boss名称"] = "莫尔特斯",
    ["创建或获取上下文"] = _____521B_5EFA_83AB_5C14_7279_65AF_6D4B_8BD5,
    ["清理上下文"] = _____6E05_7406_83AB_5C14_7279_65AF_6D4B_8BD5,
    ["技能命令列表"] = _____83AB_5C14_7279_65AF_6D4B_8BD5_6280_80FD_5217_8868
})
return ____exports
