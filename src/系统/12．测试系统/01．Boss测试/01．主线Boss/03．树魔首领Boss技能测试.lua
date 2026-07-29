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
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_2.debugLogForce
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local ____require_result_4 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_4["应用Boss战启动属性配置"]
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587 = ____require_result_5["获取或创建树魔首领上下文"]
local _____6E05_7406_6811_9B54_9996_9886_4E0A_4E0B_6587 = ____require_result_5["清理树魔首领上下文"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.10．被动效果")
local _____6CE8_518C_6811_9B54_9996_9886_88AB_52A8_6548_679C = ____require_result_6["注册树魔首领被动效果"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.03．随从特性")
local _____521D_59CB_5316_6811_9B54_9996_9886_968F_4ECE_7279_6027 = ____require_result_7["初始化树魔首领随从特性"]
local _____7ACB_5373_8865_5145_6811_9B54_9996_9886_968F_4ECE = ____require_result_7["立即补充树魔首领随从"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.04．扩散冲击波")
local _____91CA_653E_6811_9B54_9996_9886_6269_6563_51B2_51FB_6CE2 = ____require_result_8["释放树魔首领扩散冲击波"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.05．消耗反击")
local _____91CA_653E_6811_9B54_9996_9886_6D88_8017_53CD_51FB = ____require_result_9["释放树魔首领消耗反击"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.06．远古诅咒")
local _____91CA_653E_6811_9B54_9996_9886_8FDC_53E4_8BC5_5492 = ____require_result_10["释放树魔首领远古诅咒"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.07．树魔图腾")
local _____91CA_653E_6811_9B54_9996_9886_6811_9B54_56FE_817E = ____require_result_11["释放树魔首领树魔图腾"]
local ____require_result_12 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_12["标记测试Boss跳过死亡结算"]
local ____require_result_13 = require("系统.12．测试系统.00．Boss测试系统.index")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_13["Boss测试单位存活"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_13["设置Boss测试单位满血"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_13["获取Boss测试玩家基准英雄"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175 = ____require_result_13["准备Boss测试固定步兵"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B = ____require_result_13["准备Boss测试固定山丘之王"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_13["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_13["注册Boss测试命令组"]
local _____6811_9B54_9996_9886_5355_4F4DID = stringToFourCC("N05S")
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X = -540.6
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y = -2495.2
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y = -3055.2
local CreateUnit = jass.CreateUnit
local SetHeroLevel = jass.SetHeroLevel
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local GetPlayerId = jass.GetPlayerId
local GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
local GetUnitTypeId = jass.GetUnitTypeId
local KillUnit = jass.KillUnit
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local _____6700_8FD1_6D4B_8BD5Boss = {}
local _____6700_8FD1_6D4B_8BD5_6B65_5175 = {}
local _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B = {}
local _____6811_9B54_9996_9886_6D4B_8BD5_8C03_8BD5_6A21_5757 = "树魔首领测试"
local _____6280_80FD6_5F85_68C0_67E5_4E0A_4E0B_6587 = nil
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
        _____6811_9B54_9996_9886_5355_4F4DID,
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X,
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y,
        270
    )
    if boss ~= nil and boss ~= 0 then
        _____6700_8FD1_6D4B_8BD5Boss[pid] = boss
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
        SetHeroLevel(boss, 35, false)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(boss)
        globals.udg_Boss = boss
    end
    return boss
end
local function _____51C6_5907_6811_9B54_9996_9886_6D4B_8BD5_573A_666F(player, hero, boss)
    local pid = GetPlayerId(player)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    _____6700_8FD1_6D4B_8BD5_6B65_5175[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_5175[pid], _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X - 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 180, 90)
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid], _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X + 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 180, 90)
    SelectUnitForPlayerSingle(boss, player)
    StarOther_PanCameraToTimedForPlayer(player, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y, 0.2)
    local context = _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587(boss)
    if context ~= nil then
        _____521D_59CB_5316_6811_9B54_9996_9886_968F_4ECE_7279_6027(context)
    end
    return context
end
local function _____521B_5EFA_5E76_521D_59CB_5316_6811_9B54_9996_9886_6D4B_8BD5(player)
    local hero = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(hero) then
        return nil
    end
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return nil
    end
    _____6CE8_518C_6811_9B54_9996_9886_88AB_52A8_6548_679C()
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(boss)
    return _____51C6_5907_6811_9B54_9996_9886_6D4B_8BD5_573A_666F(player, hero, boss)
end
local function _____6E05_7406_6811_9B54_9996_9886_6D4B_8BD5(player, _context)
    local pid = GetPlayerId(player)
    local boss = _____6700_8FD1_6D4B_8BD5Boss[pid]
    if boss ~= nil and boss ~= 0 then
        _____6E05_7406_6811_9B54_9996_9886_4E0A_4E0B_6587(boss)
    end
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_6B65_5175[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(boss)
    _____6700_8FD1_6D4B_8BD5_6B65_5175[pid] = nil
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = nil
    _____6700_8FD1_6D4B_8BD5Boss[pid] = nil
    if globals.udg_Boss == boss then
        globals.udg_Boss = nil
    end
end
local function ____on_6811_9B54_9996_9886_6280_80FD1_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_6811_9B54_9996_9886_6269_6563_51B2_51FB_6CE2(context)
    end
end
local function ____on_6811_9B54_9996_9886_6280_80FD2_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_6811_9B54_9996_9886_6D88_8017_53CD_51FB(context)
    end
end
local function ____on_6811_9B54_9996_9886_6280_80FD3_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_6811_9B54_9996_9886_8FDC_53E4_8BC5_5492(context)
    end
end
local function ____on_6811_9B54_9996_9886_6280_80FD4_6D4B_8BD5_547D_4EE4(_player, context)
    if context ~= nil then
        _____91CA_653E_6811_9B54_9996_9886_6811_9B54_56FE_817E(context)
    end
end
local function ____on_6811_9B54_9996_9886_6280_80FD5_6D4B_8BD5_547D_4EE4(_player, context)
    if context == nil then
        return
    end
    _____7ACB_5373_8865_5145_6811_9B54_9996_9886_968F_4ECE(context)
end
local function _____8BB0_5F55_6811_9B54_9996_9886_6280_80FD6_968F_4ECE_72B6_6001(_____9636_6BB5, context)
    local ____opt_result_18
    if context ~= nil then
        ____opt_result_18 = context["随从组"]
    end
    local ____opt_result_19
    if ____opt_result_18 ~= nil then
        ____opt_result_19 = ____opt_result_18["取单位列表"](____opt_result_18)
    end
    local list = ____opt_result_19
    if list == nil then
        debugLogForce(_____6811_9B54_9996_9886_6D4B_8BD5_8C03_8BD5_6A21_5757, "命令6", _____9636_6BB5, "随从列表=nil")
        return 0
    end
    local _____5B58_6D3B_6570_91CF = 0
    debugLogForce(
        _____6811_9B54_9996_9886_6D4B_8BD5_8C03_8BD5_6A21_5757,
        "命令6",
        _____9636_6BB5,
        "列表数量=",
        #list,
        "下次补员Ms=",
        context["下一次召唤Ms"]
    )
    do
        local i = 0
        while i < #list do
            local minion = list[i + 1]
            local _____5B58_6D3B = ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(minion)
            if _____5B58_6D3B then
                _____5B58_6D3B_6570_91CF = _____5B58_6D3B_6570_91CF + 1
            end
            debugLogForce(
                _____6811_9B54_9996_9886_6D4B_8BD5_8C03_8BD5_6A21_5757,
                "命令6",
                _____9636_6BB5,
                "序号=",
                i,
                "句柄=",
                (minion == nil or minion == 0) and 0 or GetHandleId(minion),
                "类型=",
                (minion == nil or minion == 0) and 0 or GetUnitTypeId(minion),
                "生命=",
                (minion == nil or minion == 0) and 0 or GetUnitState(minion, UNIT_STATE_LIFE),
                "存活=",
                _____5B58_6D3B
            )
            i = i + 1
        end
    end
    return _____5B58_6D3B_6570_91CF
end
local function ____on_6811_9B54_9996_9886_6280_80FD6_5EF6_8FDF_68C0_67E5()
    local context = _____6280_80FD6_5F85_68C0_67E5_4E0A_4E0B_6587
    _____6280_80FD6_5F85_68C0_67E5_4E0A_4E0B_6587 = nil
    if context == nil or context["随从组"] == nil then
        return
    end
    local _____5B58_6D3B_6570_91CF = _____8BB0_5F55_6811_9B54_9996_9886_6280_80FD6_968F_4ECE_72B6_6001("延迟100ms后", context)
    debugLogForce(_____6811_9B54_9996_9886_6D4B_8BD5_8C03_8BD5_6A21_5757, "命令6", "延迟检查存活随从数=", _____5B58_6D3B_6570_91CF)
end
local function ____on_6811_9B54_9996_9886_6280_80FD6_6D4B_8BD5_547D_4EE4(_player, context)
    if context == nil or context["随从组"] == nil then
        return
    end
    _____8BB0_5F55_6811_9B54_9996_9886_6280_80FD6_968F_4ECE_72B6_6001("击杀前", context)
    context["下一次召唤Ms"] = 0
    local ____self_20 = context["随从组"]
    local list = ____self_20["取单位列表"](____self_20)
    local _____6267_884C_51FB_6740_6570_91CF = 0
    do
        local i = 0
        while i < #list do
            do
                local minion = list[i + 1]
                if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(minion) then
                    debugLogForce(
                        _____6811_9B54_9996_9886_6D4B_8BD5_8C03_8BD5_6A21_5757,
                        "命令6",
                        "跳过非存活随从",
                        "序号=",
                        i
                    )
                    goto __continue34
                end
                KillUnit(minion)
                _____6267_884C_51FB_6740_6570_91CF = _____6267_884C_51FB_6740_6570_91CF + 1
            end
            ::__continue34::
            i = i + 1
        end
    end
    debugLogForce(_____6811_9B54_9996_9886_6D4B_8BD5_8C03_8BD5_6A21_5757, "命令6", "已调用KillUnit数量=", _____6267_884C_51FB_6740_6570_91CF)
    _____6280_80FD6_5F85_68C0_67E5_4E0A_4E0B_6587 = context
    addDelayedCallback(100, ____on_6811_9B54_9996_9886_6280_80FD6_5EF6_8FDF_68C0_67E5)
end
local _____6811_9B54_9996_9886_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["名称"] = "扩散冲击波", ["执行"] = ____on_6811_9B54_9996_9886_6280_80FD1_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["名称"] = "消耗反击", ["执行"] = ____on_6811_9B54_9996_9886_6280_80FD2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 3, ["名称"] = "远古诅咒", ["执行"] = ____on_6811_9B54_9996_9886_6280_80FD3_6D4B_8BD5_547D_4EE4},
    {["序号"] = 4, ["名称"] = "树魔图腾", ["执行"] = ____on_6811_9B54_9996_9886_6280_80FD4_6D4B_8BD5_547D_4EE4},
    {["序号"] = 5, ["名称"] = "立即补齐随从编制", ["执行"] = ____on_6811_9B54_9996_9886_6280_80FD5_6D4B_8BD5_547D_4EE4},
    {["序号"] = 6, ["名称"] = "杀死所有随从并暂停补员（测试无从暴怒）", ["执行"] = ____on_6811_9B54_9996_9886_6280_80FD6_6D4B_8BD5_547D_4EE4}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "树魔首领",
    ["Boss名称"] = "树魔首领",
    ["创建或获取上下文"] = _____521B_5EFA_5E76_521D_59CB_5316_6811_9B54_9996_9886_6D4B_8BD5,
    ["清理上下文"] = _____6E05_7406_6811_9B54_9996_9886_6D4B_8BD5,
    ["技能命令列表"] = _____6811_9B54_9996_9886_6D4B_8BD5_6280_80FD_5217_8868
})
return ____exports
