--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local globals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_0.SelectUnitForPlayerSingle
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_1.StarOther_PanCameraToTimedForPlayer
local ____require_result_2 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_2["应用Boss战启动属性配置"]
local ____require_result_3 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_3["标记测试Boss跳过死亡结算"]
local ____require_result_4 = require("系统.12．测试系统.00．Boss测试系统.index")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_4["Boss测试单位存活"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_4["设置Boss测试单位满血"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_4["获取Boss测试玩家基准英雄"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175 = ____require_result_4["准备Boss测试固定步兵"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B = ____require_result_4["准备Boss测试固定山丘之王"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_4["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_4["注册Boss测试命令组"]
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83F2_5229_65AF_4E0A_4E0B_6587 = ____require_result_5["获取或创建菲利斯上下文"]
local _____6E05_7406_83F2_5229_65AF_4E0A_4E0B_6587 = ____require_result_5["清理菲利斯上下文"]
local ____require_result_6 = require("系统.01．单位系统.10．护卫系统.index")
local _____521B_5EFA_62A4_536B_5355_4F4D = ____require_result_6["创建护卫单位"]
local _____6CE8_9500_62A4_536B_5355_4F4D = ____require_result_6["注销护卫单位"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.10．被动效果")
local _____6CE8_518C_83F2_5229_65AF_88AB_52A8_6548_679C = ____require_result_7["注册菲利斯被动效果"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.12．第二军团随从")
local _____7ACB_5373_89E6_53D1_83F2_5229_65AF_7B2C_4E8C_519B_56E2_968F_4ECE_6D4B_8BD5 = ____require_result_8["立即触发菲利斯第二军团随从测试"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.04．剑魂杀")
local _____91CA_653E_83F2_5229_65AF_5251_9B42_6740 = ____require_result_9["释放菲利斯剑魂杀"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.05．剑气灵斩")
local _____91CA_653E_83F2_5229_65AF_5251_6C14_7075_65A9 = ____require_result_10["释放菲利斯剑气灵斩"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.06．全力封印斩")
local _____91CA_653E_83F2_5229_65AF_5168_529B_5C01_5370_65A9 = ____require_result_11["释放菲利斯全力封印斩"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.07．异形化")
local _____91CA_653E_83F2_5229_65AF_5F02_5F62_5316 = ____require_result_12["释放菲利斯异形化"]
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X = -540.6
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y = -2495.2
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y = -3055.2
local CreateUnit = jass.CreateUnit
local SetHeroLevel = jass.SetHeroLevel
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local GetPlayerId = jass.GetPlayerId
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local _____83F2_5229_65AF_6D4B_8BD5Boss = {}
local _____83F2_5229_65AF_6D4B_8BD5_6B65_5175 = {}
local _____83F2_5229_65AF_6D4B_8BD5_5C71_4E18_4E4B_738B = {}
local _____83F2_5229_65AF_6D4B_8BD5_62A4_536B = {}
local _____83F2_5229_65AF_6D4B_8BD5_672F_58EB = {}
local function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
local function _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    local pid = GetPlayerId(player)
    local cached = _____83F2_5229_65AF_6D4B_8BD5Boss[pid]
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
        stringToFourCC("N05T"),
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X,
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y,
        270
    )
    if boss ~= nil and boss ~= 0 then
        _____83F2_5229_65AF_6D4B_8BD5Boss[pid] = boss
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
        SetHeroLevel(boss, 38, false)
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
    _____83F2_5229_65AF_6D4B_8BD5_6B65_5175[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(_____83F2_5229_65AF_6D4B_8BD5_6B65_5175[pid], _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X - 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 180, 90)
    _____83F2_5229_65AF_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B(_____83F2_5229_65AF_6D4B_8BD5_5C71_4E18_4E4B_738B[pid], _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X + 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 180, 90)
    SelectUnitForPlayerSingle(boss, player)
    StarOther_PanCameraToTimedForPlayer(player, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y, 0.2)
end
local function _____542F_52A8Boss_6D4B_8BD5_94FE_8DEF(boss)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(boss)
end
local function _____521B_5EFA_83F2_5229_65AF_6D4B_8BD5(player)
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return nil
    end
    _____6CE8_518C_83F2_5229_65AF_88AB_52A8_6548_679C()
    _____51C6_5907_6D4B_8BD5_573A_666F(player, boss)
    _____542F_52A8Boss_6D4B_8BD5_94FE_8DEF(boss)
    return _____83B7_53D6_6216_521B_5EFA_83F2_5229_65AF_4E0A_4E0B_6587(boss)
end
local function _____521B_5EFA_6216_83B7_53D6_83F2_5229_65AF_6D4B_8BD5_968F_4ECE(cache, player, boss, unitType, guardType, x, y)
    local pid = GetPlayerId(player)
    local unit = cache[pid]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(unit) then
        unit = _____521B_5EFA_62A4_536B_5355_4F4D({
            ["主Boss单位"] = boss,
            ["单位类型"] = unitType,
            ["护卫类型"] = guardType,
            ["标记为召唤单位"] = true,
            ["Boss结束处理"] = "移除",
            X = x,
            Y = y,
            ["面向"] = 270
        })
    else
        SetUnitPosition(unit, x, y)
        SetUnitFacing(unit, 270)
    end
    cache[pid] = unit
    return unit
end
local function _____521B_5EFA_83F2_5229_65AF_6D4B_8BD5_7B2C_4E8C_519B_56E2(player, boss)
    local bossX = GetUnitX(boss)
    local bossY = GetUnitY(boss)
    local guard = _____521B_5EFA_6216_83B7_53D6_83F2_5229_65AF_6D4B_8BD5_968F_4ECE(
        _____83F2_5229_65AF_6D4B_8BD5_62A4_536B,
        player,
        boss,
        "n063",
        "菲利斯第二军团护卫",
        bossX - 220,
        bossY
    )
    local warlock = _____521B_5EFA_6216_83B7_53D6_83F2_5229_65AF_6D4B_8BD5_968F_4ECE(
        _____83F2_5229_65AF_6D4B_8BD5_672F_58EB,
        player,
        boss,
        "n062",
        "菲利斯第二军团术士",
        bossX + 220,
        bossY
    )
    return {["护卫"] = guard, ["术士"] = warlock}
end
local function _____6E05_7406_83F2_5229_65AF_6D4B_8BD5(player, _context)
    local pid = GetPlayerId(player)
    local boss = _____83F2_5229_65AF_6D4B_8BD5Boss[pid]
    if boss ~= nil and boss ~= 0 then
        _____6E05_7406_83F2_5229_65AF_4E0A_4E0B_6587(boss)
    end
    if _____83F2_5229_65AF_6D4B_8BD5_62A4_536B[pid] ~= nil and _____83F2_5229_65AF_6D4B_8BD5_62A4_536B[pid] ~= 0 then
        _____6CE8_9500_62A4_536B_5355_4F4D(_____83F2_5229_65AF_6D4B_8BD5_62A4_536B[pid])
        _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____83F2_5229_65AF_6D4B_8BD5_62A4_536B[pid])
    end
    if _____83F2_5229_65AF_6D4B_8BD5_672F_58EB[pid] ~= nil and _____83F2_5229_65AF_6D4B_8BD5_672F_58EB[pid] ~= 0 then
        _____6CE8_9500_62A4_536B_5355_4F4D(_____83F2_5229_65AF_6D4B_8BD5_672F_58EB[pid])
        _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____83F2_5229_65AF_6D4B_8BD5_672F_58EB[pid])
    end
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____83F2_5229_65AF_6D4B_8BD5_6B65_5175[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____83F2_5229_65AF_6D4B_8BD5_5C71_4E18_4E4B_738B[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(boss)
    _____83F2_5229_65AF_6D4B_8BD5_6B65_5175[pid] = nil
    _____83F2_5229_65AF_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = nil
    _____83F2_5229_65AF_6D4B_8BD5_62A4_536B[pid] = nil
    _____83F2_5229_65AF_6D4B_8BD5_672F_58EB[pid] = nil
    _____83F2_5229_65AF_6D4B_8BD5Boss[pid] = nil
    if globals.udg_Boss == boss then
        globals.udg_Boss = nil
    end
end
local function ____on_83F2_5229_65AF_6280_80FD1_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_83F2_5229_65AF_5251_9B42_6740(context)
    end
end
local function ____on_83F2_5229_65AF_6280_80FD2_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_83F2_5229_65AF_5251_6C14_7075_65A9(context)
    end
end
local function ____on_83F2_5229_65AF_6280_80FD3_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_83F2_5229_65AF_5168_529B_5C01_5370_65A9(context)
    end
end
local function ____on_83F2_5229_65AF_6280_80FD4_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_83F2_5229_65AF_5F02_5F62_5316(context)
    end
end
local function ____on_83F2_5229_65AF_7B2C_4E8C_519B_56E2_968F_4ECE_6D4B_8BD5_547D_4EE4(player, context)
    local ____temp_13
    if context ~= nil then
        ____temp_13 = context["Boss单位"]
    else
        ____temp_13 = nil
    end
    local boss = ____temp_13
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return
    end
    local minions = _____521B_5EFA_83F2_5229_65AF_6D4B_8BD5_7B2C_4E8C_519B_56E2(player, boss)
    local guardCreated = ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(minions["护卫"])
    local warlockCreated = ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(minions["术士"])
    local spellStarted = _____7ACB_5373_89E6_53D1_83F2_5229_65AF_7B2C_4E8C_519B_56E2_968F_4ECE_6D4B_8BD5(boss)
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        8,
        "[菲利斯测试] 已创建第二军团护卫与术士；护卫应在600码内提供每层10%减伤，术士已立即尝试开始1秒充能并施放腐蚀法阵。"
    )
    if not guardCreated or not warlockCreated then
        DisplayTimedTextToPlayer(
            player,
            0,
            0,
            8,
            "[菲利斯测试] 随从创建失败，请检查n063/n062物编单位是否可创建。"
        )
    elseif not spellStarted then
        DisplayTimedTextToPlayer(
            player,
            0,
            0,
            8,
            "[菲利斯测试] 随从已创建，但未找到可命中的敌对英雄，术士暂未开始充能。"
        )
    end
end
local function ____on_83F2_5229_65AF_9886_8896_5149_73AF_6D4B_8BD5_547D_4EE4(player, context)
    local ____temp_14
    if context ~= nil then
        ____temp_14 = context["Boss单位"]
    else
        ____temp_14 = nil
    end
    local boss = ____temp_14
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return
    end
    local maxLife = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE)
    if not (maxLife > 0) then
        return
    end
    if GetUnitState(boss, UNIT_STATE_LIFE) > maxLife * 0.5 then
        SetUnitState(boss, UNIT_STATE_LIFE, maxLife * 0.3)
        DisplayTimedTextToPlayer(
            player,
            0,
            0,
            6,
            "[菲利斯-领袖光环] 已切换低血状态：友军攻击降低，剑气灵斩冷却缩短。"
        )
    else
        SetUnitState(boss, UNIT_STATE_LIFE, maxLife)
        DisplayTimedTextToPlayer(
            player,
            0,
            0,
            6,
            "[菲利斯-领袖光环] 已切换高血状态：友军攻击提高。"
        )
    end
end
local _____83F2_5229_65AF_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["名称"] = "领袖光环（高血/低血切换）", ["执行"] = ____on_83F2_5229_65AF_9886_8896_5149_73AF_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["名称"] = "剑魂杀", ["执行"] = ____on_83F2_5229_65AF_6280_80FD1_6D4B_8BD5_547D_4EE4},
    {["序号"] = 3, ["名称"] = "剑气灵斩", ["执行"] = ____on_83F2_5229_65AF_6280_80FD2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 4, ["名称"] = "全力封印斩", ["执行"] = ____on_83F2_5229_65AF_6280_80FD3_6D4B_8BD5_547D_4EE4},
    {["序号"] = 5, ["名称"] = "异形化", ["执行"] = ____on_83F2_5229_65AF_6280_80FD4_6D4B_8BD5_547D_4EE4},
    {["序号"] = 6, ["名称"] = "召唤第二军团护卫与术士并完整测试", ["执行"] = ____on_83F2_5229_65AF_7B2C_4E8C_519B_56E2_968F_4ECE_6D4B_8BD5_547D_4EE4}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "菲利斯",
    ["Boss名称"] = "菲利斯",
    ["创建或获取上下文"] = _____521B_5EFA_83F2_5229_65AF_6D4B_8BD5,
    ["清理上下文"] = _____6E05_7406_83F2_5229_65AF_6D4B_8BD5,
    ["技能命令列表"] = _____83F2_5229_65AF_6D4B_8BD5_6280_80FD_5217_8868
})
return ____exports
