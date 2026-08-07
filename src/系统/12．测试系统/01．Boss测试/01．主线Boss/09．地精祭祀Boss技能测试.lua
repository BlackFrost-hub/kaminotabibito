--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____767B_8BB0_5730_7CBE_5EF6_8FDF_6D4B_8BD5, ____on_5730_7CBE_5EF6_8FDF_6D4B_8BD5, addDelayedCallback, SetUnitPosition, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y
function _____767B_8BB0_5730_7CBE_5EF6_8FDF_6D4B_8BD5(context, _____64CD_4F5C, delayMs)
    local callbackId = addDelayedCallback(delayMs, ____on_5730_7CBE_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = _____64CD_4F5C})
    local ____opt_16 = context["运行时"]
    if ____opt_16 ~= nil then
        ____opt_16 = ____opt_16["清理"]
    end
    local ____opt_result_18
    if ____opt_16 ~= nil then
        ____opt_result_18 = ____opt_16["登记延迟回调"]
    end
    if ____opt_result_18 ~= nil then
        ____opt_result_18(____opt_16, "地精祭祀测试-" .. _____64CD_4F5C, callbackId)
    end
end
function ____on_5730_7CBE_5EF6_8FDF_6D4B_8BD5(variable)
    local data = variable
    if data == nil then
        return
    end
    if data["操作"] == "移开血爆目标" then
        SetUnitPosition(data["上下文"]["玩家英雄"], _____6D4B_8BD5_4E2D_5FC3X + 1000, _____6D4B_8BD5_4E2D_5FC3Y + 1000)
        _____767B_8BB0_5730_7CBE_5EF6_8FDF_6D4B_8BD5(data["上下文"], "血爆结算检查", 1200)
        return
    end
end
local jass = require("jass.common")
local globals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_1["应用Boss战启动属性配置"]
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local directRegisterPlayerHero = ____require_result_2.directRegisterPlayerHero
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.07．技能入口")
local _____6CE8_518C_5730_7CBE_796D_7940_6280_80FD_7ED3_6784 = ____require_result_3["注册地精祭祀技能结构"]
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5730_7CBE_796D_7940_4E0A_4E0B_6587 = ____require_result_4["获取或创建地精祭祀上下文"]
local _____6E05_7406_5730_7CBE_796D_7940_4E0A_4E0B_6587 = ____require_result_4["清理地精祭祀上下文"]
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.04．破坏死光")
local _____91CA_653E_5730_7CBE_796D_7940_7834_574F_6B7B_5149 = ____require_result_5["释放地精祭祀破坏死光"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.05．血爆")
local _____91CA_653E_5730_7CBE_796D_7940_8840_7206 = ____require_result_6["释放地精祭祀血爆"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.06．毒蕴")
local _____91CA_653E_5730_7CBE_796D_7940_6BD2_8574 = ____require_result_7["释放地精祭祀毒蕴"]
local ____require_result_8 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____6CE8_518CBoss_6280_80FD_6D4B_8BD5_76EE_6807 = ____require_result_8["注册Boss技能测试目标"]
local _____6CE8_9500Boss_6280_80FD_6D4B_8BD5_76EE_6807 = ____require_result_8["注销Boss技能测试目标"]
local ____require_result_9 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_9.addDelayedCallback
local ____require_result_10 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_10["标记测试Boss跳过死亡结算"]
local ____require_result_11 = require("系统.12．测试系统.00．Boss测试系统.index")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_11["Boss测试单位存活"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_11["获取Boss测试玩家基准英雄"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175 = ____require_result_11["准备Boss测试固定步兵"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_11["设置Boss测试单位满血"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_11["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_11["注册Boss测试命令组"]
local CreateUnit = jass.CreateUnit
local Player = jass.Player
local GetPlayerId = jass.GetPlayerId
SetUnitPosition = jass.SetUnitPosition
local SetUnitFacing = jass.SetUnitFacing
local UnitDamageTarget = jass.UnitDamageTarget
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____5730_7CBE_796D_7940_5355_4F4DID = stringToFourCCSafe("N00C")
local _____6D4B_8BD5_6B65_5175_5355_4F4DID = stringToFourCCSafe("hfoo")
_____6D4B_8BD5_4E2D_5FC3X = -540.6
_____6D4B_8BD5_4E2D_5FC3Y = -2495.2
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = 12
local _____6700_8FD1_5730_7CBE_796D_7940 = {}
local _____6700_8FD1_6D4B_8BD5_6B65_5175 = {}
local _____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C = {}
local function _____521B_5EFA_6216_83B7_53D6_5730_7CBE_796D_7940_6D4B_8BD5_4E0A_4E0B_6587(player)
    local playerId = GetPlayerId(player)
    local _____73A9_5BB6_82F1_96C4 = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____73A9_5BB6_82F1_96C4) then
        return nil
    end
    _____6CE8_518C_5730_7CBE_796D_7940_6280_80FD_7ED3_6784()
    directRegisterPlayerHero(player, _____73A9_5BB6_82F1_96C4)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(_____73A9_5BB6_82F1_96C4)
    SetUnitPosition(_____73A9_5BB6_82F1_96C4, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y - 420)
    SetUnitFacing(_____73A9_5BB6_82F1_96C4, 90)
    local boss = _____6700_8FD1_5730_7CBE_796D_7940[playerId]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        boss = CreateUnit(
            Player(_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
            _____5730_7CBE_796D_7940_5355_4F4DID,
            _____6D4B_8BD5_4E2D_5FC3X,
            _____6D4B_8BD5_4E2D_5FC3Y,
            270
        )
        _____6700_8FD1_5730_7CBE_796D_7940[playerId] = boss
    end
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return nil
    end
    SetUnitPosition(boss, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitFacing(boss, 270)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(boss)
    _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
    _____6700_8FD1_6D4B_8BD5_6B65_5175[playerId] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_5175[playerId], _____6D4B_8BD5_4E2D_5FC3X + 450, _____6D4B_8BD5_4E2D_5FC3Y, 90)
    local _____7B2C_4E8C_6B65_5175 = _____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C[playerId]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____7B2C_4E8C_6B65_5175) then
        _____7B2C_4E8C_6B65_5175 = CreateUnit(
            Player(_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
            _____6D4B_8BD5_6B65_5175_5355_4F4DID,
            _____6D4B_8BD5_4E2D_5FC3X - 450,
            _____6D4B_8BD5_4E2D_5FC3Y,
            90
        )
    end
    _____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C[playerId] = _____7B2C_4E8C_6B65_5175
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____7B2C_4E8C_6B65_5175) then
        SetUnitPosition(_____7B2C_4E8C_6B65_5175, _____6D4B_8BD5_4E2D_5FC3X - 450, _____6D4B_8BD5_4E2D_5FC3Y)
        SetUnitFacing(_____7B2C_4E8C_6B65_5175, 90)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(_____7B2C_4E8C_6B65_5175)
        _____6CE8_518CBoss_6280_80FD_6D4B_8BD5_76EE_6807(_____7B2C_4E8C_6B65_5175)
    end
    local _____8FD0_884C_65F6 = _____83B7_53D6_6216_521B_5EFA_5730_7CBE_796D_7940_4E0A_4E0B_6587(boss)
    if _____8FD0_884C_65F6 == nil then
        return nil
    end
    globals.udg_Boss = boss
    return {
        ["Boss单位"] = boss,
        ["玩家英雄"] = _____73A9_5BB6_82F1_96C4,
        ["运行时"] = _____8FD0_884C_65F6,
        ["测试步兵一"] = _____6700_8FD1_6D4B_8BD5_6B65_5175[playerId],
        ["测试步兵二"] = _____7B2C_4E8C_6B65_5175
    }
end
local function _____6E05_7406_5730_7CBE_796D_7940_6D4B_8BD5_4E0A_4E0B_6587(player, context)
    local playerId = GetPlayerId(player)
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context and context["Boss单位"]) then
        _____6E05_7406_5730_7CBE_796D_7940_4E0A_4E0B_6587(context["Boss单位"])
    end
    _____6CE8_9500Boss_6280_80FD_6D4B_8BD5_76EE_6807(_____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C[playerId])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_6B65_5175[playerId])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C[playerId])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_5730_7CBE_796D_7940[playerId])
    _____6700_8FD1_6D4B_8BD5_6B65_5175[playerId] = nil
    _____6700_8FD1_6D4B_8BD5_6B65_5175_4E8C[playerId] = nil
    _____6700_8FD1_5730_7CBE_796D_7940[playerId] = nil
    if globals.udg_Boss == (context and context["Boss单位"]) then
        globals.udg_Boss = nil
    end
end
local function _____6D4B_8BD5_7834_574F_6B7B_5149(_player, context)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["Boss单位"], 100000)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["玩家英雄"], 100000)
    local _____662F_5426_5F00_59CB = _____91CA_653E_5730_7CBE_796D_7940_7834_574F_6B7B_5149(context["运行时"], context["玩家英雄"])
    if _____662F_5426_5F00_59CB then
        _____767B_8BB0_5730_7CBE_5EF6_8FDF_6D4B_8BD5(context, "破坏死光结算检查", 1600)
    end
end
local function _____6D4B_8BD5_8840_7206(_player, context)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["Boss单位"], 100000)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["玩家英雄"], 100000)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["测试步兵二"], 100000)
    SetUnitPosition(context["玩家英雄"], _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y - 420)
    SetUnitPosition(context["测试步兵二"], _____6D4B_8BD5_4E2D_5FC3X + 150, _____6D4B_8BD5_4E2D_5FC3Y - 420)
    local _____662F_5426_5F00_59CB = _____91CA_653E_5730_7CBE_796D_7940_8840_7206(context["运行时"], context["玩家英雄"])
    if _____662F_5426_5F00_59CB then
        _____767B_8BB0_5730_7CBE_5EF6_8FDF_6D4B_8BD5(context, "血爆结算检查", 1500)
    end
end
local function _____6D4B_8BD5_8840_7206_9884_8B66_540E_79FB_4F4D(_player, context)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["Boss单位"], 100000)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["玩家英雄"], 100000)
    SetUnitPosition(context["玩家英雄"], _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y - 420)
    local _____662F_5426_5F00_59CB = _____91CA_653E_5730_7CBE_796D_7940_8840_7206(context["运行时"], context["玩家英雄"])
    if _____662F_5426_5F00_59CB then
        local callbackId = addDelayedCallback(200, ____on_5730_7CBE_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = "移开血爆目标"})
        local ____opt_27 = context["运行时"]
        if ____opt_27 ~= nil then
            ____opt_27 = ____opt_27["清理"]
        end
        local ____opt_result_29
        if ____opt_27 ~= nil then
            ____opt_result_29 = ____opt_27["登记延迟回调"]
        end
        if ____opt_result_29 ~= nil then
            ____opt_result_29(____opt_27, "地精祭祀测试-移开血爆目标", callbackId)
        end
    end
end
local function _____6D4B_8BD5_6BD2_8574(_player, context)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["Boss单位"], 100000)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["玩家英雄"], 100000)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["测试步兵二"], 100000)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(
        _____6700_8FD1_6D4B_8BD5_6B65_5175[GetPlayerId(_player)],
        100000
    )
    SetUnitPosition(context["玩家英雄"], _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y - 420)
    SetUnitPosition(context["测试步兵二"], _____6D4B_8BD5_4E2D_5FC3X - 450, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitPosition(
        _____6700_8FD1_6D4B_8BD5_6B65_5175[GetPlayerId(_player)],
        _____6D4B_8BD5_4E2D_5FC3X + 450,
        _____6D4B_8BD5_4E2D_5FC3Y
    )
    local _____662F_5426_5F00_59CB = _____91CA_653E_5730_7CBE_796D_7940_6BD2_8574(context["运行时"])
    if _____662F_5426_5F00_59CB then
        _____767B_8BB0_5730_7CBE_5EF6_8FDF_6D4B_8BD5(context, "毒蕴结算检查", 1500)
    end
end
local function _____6D4B_8BD5_53D7_51FB_53EC_5524(_player, context)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["Boss单位"])
    UnitDamageTarget(
        context["玩家英雄"],
        context["Boss单位"],
        1000,
        true,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    )
end
local _____5730_7CBE_796D_7940_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["命令"] = "地精1", ["名称"] = "破坏死光", ["执行"] = _____6D4B_8BD5_7834_574F_6B7B_5149},
    {["序号"] = 2, ["命令"] = "地精2", ["名称"] = "血爆命中范围", ["执行"] = _____6D4B_8BD5_8840_7206},
    {["序号"] = 2, ["命令"] = "地精2-2", ["名称"] = "血爆预警后移位", ["执行"] = _____6D4B_8BD5_8840_7206_9884_8B66_540E_79FB_4F4D},
    {["序号"] = 3, ["命令"] = "地精3", ["名称"] = "毒蕴", ["执行"] = _____6D4B_8BD5_6BD2_8574},
    {["序号"] = 4, ["命令"] = "地精4", ["名称"] = "受击召唤（真实伤害）", ["执行"] = _____6D4B_8BD5_53D7_51FB_53EC_5524}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "地精祭祀",
    ["Boss名称"] = "地精祭祀",
    ["场地"] = {["正式中心"] = {x = _____6D4B_8BD5_4E2D_5FC3X, y = _____6D4B_8BD5_4E2D_5FC3Y}, ["测试空地中心"] = {x = _____6D4B_8BD5_4E2D_5FC3X, y = _____6D4B_8BD5_4E2D_5FC3Y}},
    ["创建或获取上下文"] = _____521B_5EFA_6216_83B7_53D6_5730_7CBE_796D_7940_6D4B_8BD5_4E0A_4E0B_6587,
    ["清理上下文"] = _____6E05_7406_5730_7CBE_796D_7940_6D4B_8BD5_4E0A_4E0B_6587,
    ["技能命令列表"] = _____5730_7CBE_796D_7940_6D4B_8BD5_6280_80FD_5217_8868
})
return ____exports
