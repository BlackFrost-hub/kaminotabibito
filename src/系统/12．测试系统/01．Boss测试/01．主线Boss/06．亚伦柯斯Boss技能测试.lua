--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local globals = require("jass.globals")
local ____require_result_0 = require("系统.12．测试系统.00．Boss测试系统.index")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_0["Boss测试单位存活"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_0["设置Boss测试单位满血"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_0["获取Boss测试玩家基准英雄"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175 = ____require_result_0["准备Boss测试固定步兵"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B = ____require_result_0["准备Boss测试固定山丘之王"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_0["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_0["注册Boss测试命令组"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_2.SelectUnitForPlayerSingle
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_3.StarOther_PanCameraToTimedForPlayer
local ____require_result_4 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_4["标记测试Boss跳过死亡结算"]
local ____require_result_5 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_5["应用Boss战启动属性配置"]
local ____require_result_6 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文")
local _____521B_5EFABoss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_6["创建Boss战运行上下文"]
local _____8BB0_5F55Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_6["记录Boss战运行上下文"]
local _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_6["读取Boss战运行上下文"]
local _____6E05_7406Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_6["清理Boss战运行上下文"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.00．配置")
local _____4E9A_4F26_67EF_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_7["亚伦柯斯单位技能配置"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.06．被动效果")
local _____6CE8_518C_4E9A_4F26_67EF_65AF_88AB_52A8_6548_679C = ____require_result_8["注册亚伦柯斯被动效果"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_4E9A_4F26_67EF_65AF_8FD0_884C_65F6_4E0A_4E0B_6587 = ____require_result_9["获取或创建亚伦柯斯运行时上下文"]
local _____6E05_7406_4E9A_4F26_67EF_65AF_8FD0_884C_65F6_4E0A_4E0B_6587 = ____require_result_9["清理亚伦柯斯运行时上下文"]
local _____8FDB_5165_4E9A_4F26_67EF_65AFP3 = ____require_result_9["进入亚伦柯斯P3"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.03．亡冥英斩")
local _____91CA_653E_4E9A_4F26_67EF_65AF_4EA1_51A5_82F1_65A9 = ____require_result_10["释放亚伦柯斯亡冥英斩"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.04．英灵陨星")
local _____91CA_653E_4E9A_4F26_67EF_65AF_82F1_7075_9668_661F = ____require_result_11["释放亚伦柯斯英灵陨星"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.07．亡者凝视")
local _____91CA_653E_4E9A_4F26_67EF_65AF_4EA1_8005_51DD_89C6 = ____require_result_12["释放亚伦柯斯亡者凝视"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.08．旧誓墓碑")
local _____542F_52A8_4E9A_4F26_67EF_65AF_65E7_8A93_5893_7891 = ____require_result_13["启动亚伦柯斯旧誓墓碑"]
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.09．不灭军魂")
local _____542F_7528_4E9A_4F26_67EF_65AF_4E0D_706D_519B_9B42 = ____require_result_14["启用亚伦柯斯不灭军魂"]
local _____89E6_53D1_4E9A_4F26_67EF_65AF_6700_7EC8_5F3A_5316 = ____require_result_14["触发亚伦柯斯最终强化"]
local CreateUnit = jass.CreateUnit
local GetPlayerId = jass.GetPlayerId
local SetHeroLevel = jass.SetHeroLevel
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local Rect = jass.Rect
local RemoveRect = jass.RemoveRect
local _____4E9A_4F26_67EF_65AF_5355_4F4DID = stringToFourCCSafe(_____4E9A_4F26_67EF_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____6D4B_8BD5_4E2D_5FC3X = -540.6
local _____6D4B_8BD5_4E2D_5FC3Y = -2495.2
local _____73A9_5BB6_6D4B_8BD5X = -540.6
local _____73A9_5BB6_6D4B_8BD5Y = -3055.2
local _____6B63_5F0F_573A_5730_534A_5BBD = (_____4E9A_4F26_67EF_65AF_5355_4F4D_6280_80FD_914D_7F6E["正式场地"]["右边界"] - _____4E9A_4F26_67EF_65AF_5355_4F4D_6280_80FD_914D_7F6E["正式场地"]["左边界"]) * 0.5
local _____6B63_5F0F_573A_5730_534A_9AD8 = (_____4E9A_4F26_67EF_65AF_5355_4F4D_6280_80FD_914D_7F6E["正式场地"]["上边界"] - _____4E9A_4F26_67EF_65AF_5355_4F4D_6280_80FD_914D_7F6E["正式场地"]["下边界"]) * 0.5
local _____6700_8FD1_6D4B_8BD5Boss = {}
local _____6700_8FD1_6D4B_8BD5_6B65_5175 = {}
local _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B = {}
local _____6D4B_8BD5_573A_5730_77E9_5F62 = {}
local function _____83B7_53D6_6216_521B_5EFA_4E9A_4F26_67EF_65AF_6D4B_8BD5_77E9_5F62(player)
    local pid = GetPlayerId(player)
    local rect = _____6D4B_8BD5_573A_5730_77E9_5F62[pid]
    if rect == nil or rect == 0 then
        rect = Rect(_____6D4B_8BD5_4E2D_5FC3X - _____6B63_5F0F_573A_5730_534A_5BBD, _____6D4B_8BD5_4E2D_5FC3Y - _____6B63_5F0F_573A_5730_534A_9AD8, _____6D4B_8BD5_4E2D_5FC3X + _____6B63_5F0F_573A_5730_534A_5BBD, _____6D4B_8BD5_4E2D_5FC3Y + _____6B63_5F0F_573A_5730_534A_9AD8)
        _____6D4B_8BD5_573A_5730_77E9_5F62[pid] = rect
    end
    return rect
end
local function _____83B7_53D6_6216_521B_5EFA_4E9A_4F26_67EF_65AF_6D4B_8BD5Boss(player)
    local pid = GetPlayerId(player)
    local boss = _____6700_8FD1_6D4B_8BD5Boss[pid]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        boss = CreateUnit(
            player,
            _____4E9A_4F26_67EF_65AF_5355_4F4DID,
            _____6D4B_8BD5_4E2D_5FC3X,
            _____6D4B_8BD5_4E2D_5FC3Y,
            270
        )
        _____6700_8FD1_6D4B_8BD5Boss[pid] = boss
        if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
            SetHeroLevel(boss, 40, false)
        end
    end
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        SetUnitPosition(boss, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y)
        SetUnitFacing(boss, 270)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(boss)
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
        globals.udg_Boss = boss
    end
    return boss
end
local function _____83B7_53D6_6216_521B_5EFA_4E9A_4F26_67EF_65AF_6D4B_8BD5_6B65_5175(cache, player, x, y)
    local pid = GetPlayerId(player)
    local unit = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(cache[pid], x, y, 90)
    cache[pid] = unit
    return unit
end
local function _____786E_4FDD_4E9A_4F26_67EF_65AF_6D4B_8BD5_6218_6597_77E9_5F62(player, boss)
    if _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587(boss) ~= nil then
        return
    end
    local battle = _____521B_5EFABoss_6218_8FD0_884C_4E0A_4E0B_6587(
        boss,
        _____83B7_53D6_6216_521B_5EFA_4E9A_4F26_67EF_65AF_6D4B_8BD5_77E9_5F62(player),
        nil,
        nil
    )
    if battle ~= nil then
        _____8BB0_5F55Boss_6218_8FD0_884C_4E0A_4E0B_6587(battle)
    end
end
local function _____521B_5EFA_6216_83B7_53D6_4E9A_4F26_67EF_65AF_6D4B_8BD5_4E0A_4E0B_6587(player)
    local pid = GetPlayerId(player)
    local hero = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    local boss = _____83B7_53D6_6216_521B_5EFA_4E9A_4F26_67EF_65AF_6D4B_8BD5Boss(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(hero) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return nil
    end
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    local target = _____83B7_53D6_6216_521B_5EFA_4E9A_4F26_67EF_65AF_6D4B_8BD5_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_5175, player, _____73A9_5BB6_6D4B_8BD5X - 220, _____73A9_5BB6_6D4B_8BD5Y + 180)
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid], _____73A9_5BB6_6D4B_8BD5X + 220, _____73A9_5BB6_6D4B_8BD5Y + 180, 90)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        return nil
    end
    _____6CE8_518C_4E9A_4F26_67EF_65AF_88AB_52A8_6548_679C()
    _____786E_4FDD_4E9A_4F26_67EF_65AF_6D4B_8BD5_6218_6597_77E9_5F62(player, boss)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(boss)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(boss)
    local runtime = _____83B7_53D6_6216_521B_5EFA_4E9A_4F26_67EF_65AF_8FD0_884C_65F6_4E0A_4E0B_6587(boss)
    if runtime == nil then
        return nil
    end
    SelectUnitForPlayerSingle(boss, player)
    StarOther_PanCameraToTimedForPlayer(player, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y, 0.2)
    return {["运行时"] = runtime, ["目标单位"] = target, ["Boss单位"] = boss}
end
local function _____6E05_7406_4E9A_4F26_67EF_65AF_6D4B_8BD5_4E0A_4E0B_6587(player, context)
    local pid = GetPlayerId(player)
    if context ~= nil and context["Boss单位"] ~= nil then
        _____6E05_7406_4E9A_4F26_67EF_65AF_8FD0_884C_65F6_4E0A_4E0B_6587(context["Boss单位"])
        _____6E05_7406Boss_6218_8FD0_884C_4E0A_4E0B_6587(context["Boss单位"])
    end
    local rect = _____6D4B_8BD5_573A_5730_77E9_5F62[pid]
    if rect ~= nil and rect ~= 0 then
        RemoveRect(rect)
    end
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_6B65_5175[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5Boss[pid])
    _____6D4B_8BD5_573A_5730_77E9_5F62[pid] = nil
    _____6700_8FD1_6D4B_8BD5_6B65_5175[pid] = nil
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = nil
    _____6700_8FD1_6D4B_8BD5Boss[pid] = nil
    if globals.udg_Boss == (context and context["Boss单位"]) then
        globals.udg_Boss = nil
    end
end
local function _____51C6_5907_4E9A_4F26_67EF_65AFP1(context)
    context["运行时"]["阶段"] = "P1守墓者苏醒"
    context["运行时"]["当前大型技能"] = nil
end
local function _____51C6_5907_4E9A_4F26_67EF_65AFP3(context)
    context["运行时"]["阶段"] = "P2旧誓回响"
    context["运行时"]["未安魂墓碑数量"] = 0
    context["运行时"]["当前大型技能"] = nil
    _____8FDB_5165_4E9A_4F26_67EF_65AFP3(context["运行时"])
end
local function _____6D4B_8BD5_4E9A_4F26_67EF_65AF_4EA1_51A5_82F1_65A9(_player, context)
    _____51C6_5907_4E9A_4F26_67EF_65AFP1(context)
    _____91CA_653E_4E9A_4F26_67EF_65AF_4EA1_51A5_82F1_65A9(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_4E9A_4F26_67EF_65AF_82F1_7075_9668_661F(_player, context)
    _____51C6_5907_4E9A_4F26_67EF_65AFP1(context)
    _____91CA_653E_4E9A_4F26_67EF_65AF_82F1_7075_9668_661F(context["运行时"])
end
local function _____6D4B_8BD5_4E9A_4F26_67EF_65AF_4EA1_8005_51DD_89C6(_player, context)
    _____51C6_5907_4E9A_4F26_67EF_65AFP1(context)
    _____91CA_653E_4E9A_4F26_67EF_65AF_4EA1_8005_51DD_89C6(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_4E9A_4F26_67EF_65AF_65E7_8A93_5893_7891(_player, context)
    context["运行时"]["阶段"] = "P2旧誓回响"
    context["运行时"]["当前大型技能"] = nil
    _____542F_52A8_4E9A_4F26_67EF_65AF_65E7_8A93_5893_7891(context["运行时"])
end
local function _____6D4B_8BD5_4E9A_4F26_67EF_65AF_8FDB_5165P3(_player, context)
    _____51C6_5907_4E9A_4F26_67EF_65AFP3(context)
end
local function _____6D4B_8BD5_4E9A_4F26_67EF_65AFP3_4EA1_51A5_82F1_65A9(_player, context)
    _____51C6_5907_4E9A_4F26_67EF_65AFP3(context)
    _____91CA_653E_4E9A_4F26_67EF_65AF_4EA1_51A5_82F1_65A9(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_4E9A_4F26_67EF_65AFP3_82F1_7075_9668_661F(_player, context)
    _____51C6_5907_4E9A_4F26_67EF_65AFP3(context)
    _____91CA_653E_4E9A_4F26_67EF_65AF_82F1_7075_9668_661F(context["运行时"])
end
local function _____6D4B_8BD5_4E9A_4F26_67EF_65AF_4E0D_706D_519B_9B42(_player, context)
    _____51C6_5907_4E9A_4F26_67EF_65AFP3(context)
    _____542F_7528_4E9A_4F26_67EF_65AF_4E0D_706D_519B_9B42(context["运行时"])
end
local function _____6D4B_8BD5_4E9A_4F26_67EF_65AF_6700_7EC8_5F3A_5316(_player, context)
    _____51C6_5907_4E9A_4F26_67EF_65AFP3(context)
    _____89E6_53D1_4E9A_4F26_67EF_65AF_6700_7EC8_5F3A_5316(context["运行时"])
end
local _____4E9A_4F26_67EF_65AF_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["名称"] = "P1亡冥英斩", ["执行"] = _____6D4B_8BD5_4E9A_4F26_67EF_65AF_4EA1_51A5_82F1_65A9},
    {["序号"] = 2, ["名称"] = "P1英灵陨星", ["执行"] = _____6D4B_8BD5_4E9A_4F26_67EF_65AF_82F1_7075_9668_661F},
    {["序号"] = 3, ["名称"] = "亡者凝视", ["执行"] = _____6D4B_8BD5_4E9A_4F26_67EF_65AF_4EA1_8005_51DD_89C6},
    {["序号"] = 4, ["名称"] = "P2旧誓墓碑", ["执行"] = _____6D4B_8BD5_4E9A_4F26_67EF_65AF_65E7_8A93_5893_7891},
    {["序号"] = 5, ["名称"] = "进入P3最后誓约", ["执行"] = _____6D4B_8BD5_4E9A_4F26_67EF_65AF_8FDB_5165P3},
    {["序号"] = 6, ["名称"] = "P3亡冥英斩归魂", ["执行"] = _____6D4B_8BD5_4E9A_4F26_67EF_65AFP3_4EA1_51A5_82F1_65A9},
    {["序号"] = 7, ["名称"] = "P3英灵陨星送葬", ["执行"] = _____6D4B_8BD5_4E9A_4F26_67EF_65AFP3_82F1_7075_9668_661F},
    {["序号"] = 8, ["名称"] = "不灭军魂", ["执行"] = _____6D4B_8BD5_4E9A_4F26_67EF_65AF_4E0D_706D_519B_9B42},
    {["序号"] = 9, ["名称"] = "最终强化", ["执行"] = _____6D4B_8BD5_4E9A_4F26_67EF_65AF_6700_7EC8_5F3A_5316}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "亚伦柯斯",
    ["Boss名称"] = "亚伦柯斯",
    ["场地"] = {["正式中心"] = {x = _____4E9A_4F26_67EF_65AF_5355_4F4D_6280_80FD_914D_7F6E["正式场地"]["中心X"], y = _____4E9A_4F26_67EF_65AF_5355_4F4D_6280_80FD_914D_7F6E["正式场地"]["中心Y"]}, ["测试空地中心"] = {x = _____6D4B_8BD5_4E2D_5FC3X, y = _____6D4B_8BD5_4E2D_5FC3Y}},
    ["创建或获取上下文"] = _____521B_5EFA_6216_83B7_53D6_4E9A_4F26_67EF_65AF_6D4B_8BD5_4E0A_4E0B_6587,
    ["清理上下文"] = _____6E05_7406_4E9A_4F26_67EF_65AF_6D4B_8BD5_4E0A_4E0B_6587,
    ["技能命令列表"] = _____4E9A_4F26_67EF_65AF_6D4B_8BD5_6280_80FD_5217_8868
})
return ____exports
