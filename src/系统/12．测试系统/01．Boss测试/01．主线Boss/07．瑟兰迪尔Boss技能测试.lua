--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local stringToFourCC
function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
local jass = require("jass.common")
local globals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_0.SelectUnitForPlayerSingle
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_1.StarOther_PanCameraToTimedForPlayer
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587 = ____require_result_2["获取或创建瑟兰迪尔上下文"]
local _____6E05_7406_745F_5170_8FEA_5C14_4E0A_4E0B_6587 = ____require_result_2["清理瑟兰迪尔上下文"]
local _____6CE8_518C_745F_5170_8FEA_5C14_8FD0_884C_65F6 = ____require_result_2["注册瑟兰迪尔运行时"]
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.07．秩序领域")
local _____5237_65B0_745F_5170_8FEA_5C14_79E9_5E8F_9886_57DF = ____require_result_3["刷新瑟兰迪尔秩序领域"]
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.04．执法印记")
local _____91CA_653E_745F_5170_8FEA_5C14_6267_6CD5_5370_8BB0 = ____require_result_4["释放瑟兰迪尔执法印记"]
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.05．月光枷锁")
local _____91CA_653E_745F_5170_8FEA_5C14_6708_5149_67B7_9501_6548_679C = ____require_result_5["释放瑟兰迪尔月光枷锁效果"]
local _____7ACB_5373_6253_65AD_745F_5170_8FEA_5C14_6708_5149_67B7_9501 = ____require_result_5["立即打断瑟兰迪尔月光枷锁"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.06．精灵箭阵")
local _____91CA_653E_745F_5170_8FEA_5C14_7CBE_7075_7BAD_9635 = ____require_result_6["释放瑟兰迪尔精灵箭阵"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.08．审判之环")
local _____91CA_653E_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF = ____require_result_7["释放瑟兰迪尔审判之环"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.09．罪与罚")
local _____91CA_653E_745F_5170_8FEA_5C14_7F6A_4E0E_7F5A = ____require_result_8["释放瑟兰迪尔罪与罚"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.10．律法召唤")
local _____91CA_653E_745F_5170_8FEA_5C14_5F8B_6CD5_53EC_5524 = ____require_result_9["释放瑟兰迪尔律法召唤"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.11．月光灌注")
local _____91CA_653E_745F_5170_8FEA_5C14_6708_5149_704C_6CE8 = ____require_result_10["释放瑟兰迪尔月光灌注"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.12．终末审判")
local _____91CA_653E_745F_5170_8FEA_5C14_7EC8_672B_5BA1_5224 = ____require_result_11["释放瑟兰迪尔终末审判"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.02．数值与表现配置")
local _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____require_result_12["瑟兰迪尔数值与表现配置"]
local ____require_result_13 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_13["创建单位坐标跟随特效"]
local _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_13["销毁单位坐标跟随特效"]
local _____521B_5EFA_5FAA_73AF_70B9_7279_6548 = ____require_result_13["创建循环点特效"]
local _____505C_6B62_5FAA_73AF_70B9_7279_6548 = ____require_result_13["停止循环点特效"]
local ____require_result_14 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_14["标记测试Boss跳过死亡结算"]
local ____require_result_15 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_15["应用Boss战启动属性配置"]
local ____require_result_16 = require("系统.12．测试系统.00．Boss测试系统.index")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_16["Boss测试单位存活"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_16["设置Boss测试单位满血"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_16["获取Boss测试玩家基准英雄"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175 = ____require_result_16["准备Boss测试固定步兵"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_16["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_16["注册Boss测试命令组"]
local _____745F_5170_8FEA_5C14_5355_4F4DID = stringToFourCC("N057")
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X = -540.6
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y = -2495.2
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y = -3055.2
local _____79E9_5E8F_9886_57DF_7F29_653E_6D4B_8BD5_7279_6548_952E = "thranduil-order-aura-scale-test"
local CreateUnit = jass.CreateUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetHeroLevel = jass.SetHeroLevel
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local GetPlayerId = jass.GetPlayerId
local _____6700_8FD1_6D4B_8BD5Boss = {}
local _____6700_8FD1_6D4B_8BD5_6B65_51751 = {}
local _____6700_8FD1_6D4B_8BD5_6B65_51752 = {}
local _____6700_8FD1_6D4B_8BD5_4E0A_4E0B_6587 = {}
local function _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    local pid = GetPlayerId(player)
    local cached = _____6700_8FD1_6D4B_8BD5Boss[pid]
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
        _____745F_5170_8FEA_5C14_5355_4F4DID,
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X,
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y,
        270
    )
    if boss ~= nil and boss ~= 0 then
        _____6700_8FD1_6D4B_8BD5Boss[pid] = boss
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
        SetHeroLevel(boss, 10, false)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(boss)
        globals.udg_Boss = boss
    end
    return boss
end
local function _____521B_5EFA_6216_83B7_53D6_745F_5170_8FEA_5C14_6D4B_8BD5(player)
    local pid = GetPlayerId(player)
    local hero = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(hero) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return nil
    end
    SetUnitPosition(hero, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y)
    SetUnitFacing(hero, 90)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    local target = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_51751[pid], _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X - 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 180, 90)
    _____6700_8FD1_6D4B_8BD5_6B65_51751[pid] = target
    _____6700_8FD1_6D4B_8BD5_6B65_51752[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_51752[pid], _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X + 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 180, 90)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        return nil
    end
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(boss)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(boss)
    _____6CE8_518C_745F_5170_8FEA_5C14_8FD0_884C_65F6()
    local runtime = _____83B7_53D6_6216_521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587(boss)
    if runtime == nil then
        return nil
    end
    _____5237_65B0_745F_5170_8FEA_5C14_79E9_5E8F_9886_57DF(runtime)
    local context = _____6700_8FD1_6D4B_8BD5_4E0A_4E0B_6587[pid]
    if context == nil or context["Boss单位"] ~= boss then
        context = {["Boss单位"] = boss, ["运行时"] = runtime, ["目标单位"] = target, ["基准英雄"] = hero}
        _____6700_8FD1_6D4B_8BD5_4E0A_4E0B_6587[pid] = context
    else
        context["运行时"] = runtime
        context["目标单位"] = target
        context["基准英雄"] = hero
    end
    SelectUnitForPlayerSingle(boss, player)
    StarOther_PanCameraToTimedForPlayer(player, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y, 0.2)
    return context
end
local function _____6E05_7406_745F_5170_8FEA_5C14_6D4B_8BD5(player, context)
    local pid = GetPlayerId(player)
    local cached = _____6700_8FD1_6D4B_8BD5_4E0A_4E0B_6587[pid] or context
    local boss = _____6700_8FD1_6D4B_8BD5Boss[pid]
    if cached ~= nil and cached["审判之环法阵句柄"] ~= nil then
        _____505C_6B62_5FAA_73AF_70B9_7279_6548(cached["审判之环法阵句柄"])
    end
    if cached ~= nil and cached["基准英雄"] ~= nil then
        _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(cached["基准英雄"], _____79E9_5E8F_9886_57DF_7F29_653E_6D4B_8BD5_7279_6548_952E)
    end
    if boss ~= nil and boss ~= 0 then
        _____6E05_7406_745F_5170_8FEA_5C14_4E0A_4E0B_6587(boss)
    end
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_6B65_51751[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_6B65_51752[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(boss)
    _____6700_8FD1_6D4B_8BD5_4E0A_4E0B_6587[pid] = nil
    _____6700_8FD1_6D4B_8BD5_6B65_51751[pid] = nil
    _____6700_8FD1_6D4B_8BD5_6B65_51752[pid] = nil
    _____6700_8FD1_6D4B_8BD5Boss[pid] = nil
    if globals.udg_Boss == boss then
        globals.udg_Boss = nil
    end
end
local function ____on_745F_5170_8FEA_5C14_6280_80FD1_6D4B_8BD5_547D_4EE4(_player, context)
    _____91CA_653E_745F_5170_8FEA_5C14_6708_5149_67B7_9501_6548_679C(context["Boss单位"], context["目标单位"])
end
local function ____on_745F_5170_8FEA_5C14_6280_80FD2_6D4B_8BD5_547D_4EE4(_player, context)
    _____91CA_653E_745F_5170_8FEA_5C14_7CBE_7075_7BAD_9635(context["运行时"])
end
local function ____on_745F_5170_8FEA_5C14_6280_80FD3_6D4B_8BD5_547D_4EE4(_player, context)
    _____91CA_653E_745F_5170_8FEA_5C14_5BA1_5224_4E4B_73AF(context["运行时"])
end
local function ____on_745F_5170_8FEA_5C14_6280_80FD4_6D4B_8BD5_547D_4EE4(_player, context)
    _____91CA_653E_745F_5170_8FEA_5C14_7F6A_4E0E_7F5A(context["运行时"], context["目标单位"])
end
local function ____on_745F_5170_8FEA_5C14_6280_80FD5_6D4B_8BD5_547D_4EE4(_player, context)
    _____91CA_653E_745F_5170_8FEA_5C14_5F8B_6CD5_53EC_5524(context["运行时"])
end
local function ____on_745F_5170_8FEA_5C14_6280_80FD6_6D4B_8BD5_547D_4EE4(_player, context)
    _____91CA_653E_745F_5170_8FEA_5C14_6708_5149_704C_6CE8(context["运行时"])
end
local function ____on_745F_5170_8FEA_5C14_6280_80FD7_6D4B_8BD5_547D_4EE4(_player, context)
    _____91CA_653E_745F_5170_8FEA_5C14_7EC8_672B_5BA1_5224(context["运行时"])
end
local function ____on_745F_5170_8FEA_5C14_6280_80FD8_6D4B_8BD5_547D_4EE4(_player, context)
    _____7ACB_5373_6253_65AD_745F_5170_8FEA_5C14_6708_5149_67B7_9501(context["Boss单位"], context["目标单位"])
end
local function ____on_5BA1_5224_4E4B_73AF_6CD5_9635_7279_6548_6D4B_8BD5_547D_4EE4(_player, context)
    if context["审判之环法阵句柄"] ~= nil then
        _____505C_6B62_5FAA_73AF_70B9_7279_6548(context["审判之环法阵句柄"])
    end
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["审判之环"]
    context["审判之环法阵句柄"] = _____521B_5EFA_5FAA_73AF_70B9_7279_6548({
        ["模型路径"] = config["特效"],
        X = GetUnitX(context["基准英雄"]),
        Y = GetUnitY(context["基准英雄"]),
        ["缩放"] = config["法阵缩放"],
        ["顶点颜色"] = 4294955104,
        ["重建间隔秒"] = config["法阵重建间隔秒"],
        ["单次持续秒"] = config["法阵单次持续秒"],
        ["总持续秒"] = config["周期秒"]
    })
end
local function ____on_79E9_5E8F_9886_57DF_7ED1_5B9A_7F29_653E_6D4B_8BD5_547D_4EE4(_player, context)
    _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548(
        context["基准英雄"],
        _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["秩序领域"]["特效"],
        _____79E9_5E8F_9886_57DF_7F29_653E_6D4B_8BD5_7279_6548_952E,
        1,
        50
    )
end
local function ____on_745F_5170_8FEA_5C14_6267_6CD5_5370_8BB0_6D4B_8BD5_547D_4EE4(_player, context)
    _____91CA_653E_745F_5170_8FEA_5C14_6267_6CD5_5370_8BB0(context["运行时"], context["目标单位"])
end
local _____745F_5170_8FEA_5C14_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["名称"] = "月光枷锁", ["执行"] = ____on_745F_5170_8FEA_5C14_6280_80FD1_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["名称"] = "精灵箭阵", ["执行"] = ____on_745F_5170_8FEA_5C14_6280_80FD2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 3, ["名称"] = "审判之环", ["执行"] = ____on_745F_5170_8FEA_5C14_6280_80FD3_6D4B_8BD5_547D_4EE4},
    {["序号"] = 4, ["名称"] = "罪与罚", ["执行"] = ____on_745F_5170_8FEA_5C14_6280_80FD4_6D4B_8BD5_547D_4EE4},
    {["序号"] = 5, ["名称"] = "律法召唤", ["执行"] = ____on_745F_5170_8FEA_5C14_6280_80FD5_6D4B_8BD5_547D_4EE4},
    {["序号"] = 6, ["名称"] = "月光灌注", ["执行"] = ____on_745F_5170_8FEA_5C14_6280_80FD6_6D4B_8BD5_547D_4EE4},
    {["序号"] = 7, ["名称"] = "终末审判", ["执行"] = ____on_745F_5170_8FEA_5C14_6280_80FD7_6D4B_8BD5_547D_4EE4},
    {["序号"] = 8, ["名称"] = "月光枷锁立即打断", ["执行"] = ____on_745F_5170_8FEA_5C14_6280_80FD8_6D4B_8BD5_547D_4EE4},
    {["序号"] = 9, ["名称"] = "审判之环法阵特效", ["执行"] = ____on_5BA1_5224_4E4B_73AF_6CD5_9635_7279_6548_6D4B_8BD5_547D_4EE4},
    {["序号"] = 10, ["名称"] = "秩序领域绑定缩放", ["执行"] = ____on_79E9_5E8F_9886_57DF_7ED1_5B9A_7F29_653E_6D4B_8BD5_547D_4EE4},
    {["序号"] = 11, ["名称"] = "执法印记", ["执行"] = ____on_745F_5170_8FEA_5C14_6267_6CD5_5370_8BB0_6D4B_8BD5_547D_4EE4}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "瑟兰迪尔",
    ["Boss名称"] = "瑟兰迪尔",
    ["创建或获取上下文"] = _____521B_5EFA_6216_83B7_53D6_745F_5170_8FEA_5C14_6D4B_8BD5,
    ["清理上下文"] = _____6E05_7406_745F_5170_8FEA_5C14_6D4B_8BD5,
    ["技能命令列表"] = _____745F_5170_8FEA_5C14_6D4B_8BD5_6280_80FD_5217_8868
})
return ____exports
