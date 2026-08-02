--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____6E05_7406_83AB_5C14_7279_65AF_8150_8D25_79CD_5B50_5F3A_5316_5012_8BA1_65F6, _____521B_5EFA_8150_8D25_5E7C_6811, _____5E7C_6811_6CE2_52A8Tick, _____521B_5EFA_70B9_7279_6548, GetUnitX, GetUnitY, GetHandleId, GetOwningPlayer, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_PLANT, WEAPON_TYPE_WHOKNOWS, _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, _____8150_8D25_4E4B_79CD_6280_80FDID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.00．配置")
local _____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["莫尔特斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建莫尔特斯上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.02．数值与表现配置")
local _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯数值与表现配置"]
local _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯音效配置"]
local ____03_FF0E_8150_8D25_503C_4E0E_6839_987B_9886_57DF = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.03．腐败值与根须领域")
local _____5E94_7528_83AB_5C14_7279_65AF_8150_8D25_503C = ____03_FF0E_8150_8D25_503C_4E0E_6839_987B_9886_57DF["应用莫尔特斯腐败值"]
local ____13_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.13．台词播放")
local _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD = ____13_FF0E_53F0_8BCD_64AD_653E["播放莫尔特斯台词"]
local ____16_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.16．公共工具")
local _____5355_4F4D_6709_6548 = ____16_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____53D6_5750_6807_89D2_5EA6 = ____16_FF0E_516C_5171_5DE5_5177["取坐标角度"]
local _____6781_5750_6807X = ____16_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____16_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local stringToFourCC = ____16_FF0E_516C_5171_5DE5_5177.stringToFourCC
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI = require("系统.09．表现系统.15．世界坐标进度UI.index")
local _____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI = ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI["创建世界坐标进度UI"]
local _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI = ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI["更新世界坐标进度UI"]
local _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI = ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI["销毁世界坐标进度UI"]
local ____01_FF0ETS_539F_751F_5F39_5E55 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_4E8C_9636_8D1D_585E_5C14XYZ_8F68_8FF9 = ____01_FF0ETS_539F_751F_5F39_5E55["创建二阶贝塞尔XYZ轨迹"]
local _____521B_5EFA_539F_751F_5F39_5E55 = ____01_FF0ETS_539F_751F_5F39_5E55["创建原生弹幕"]
local ____01_FF0E_6301_7EED_5371_9669_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域")
local _____521B_5EFA_6301_7EED_5371_9669_533A_57DF = ____01_FF0E_6301_7EED_5371_9669_533A_57DF["创建持续危险区域"]
local ____22_FF0E_9650_6B21_5468_671F_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.22．限次周期执行器")
local _____521B_5EFA_9650_6B21_5468_671F_6267_884C_5668 = ____22_FF0E_9650_6B21_5468_671F_6267_884C_5668["创建限次周期执行器"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
function _____6E05_7406_83AB_5C14_7279_65AF_8150_8D25_79CD_5B50_5F3A_5316_5012_8BA1_65F6(data)
    if data == nil then
        return
    end
    if data["周期"] ~= nil then
        local ____self_8 = data["周期"]
        ____self_8["停止"](____self_8)
        data["周期"] = nil
    end
    _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI(data.UI)
    data.UI = nil
end
function _____521B_5EFA_8150_8D25_5E7C_6811(context, x, y)
    local boss = context["Boss单位"]
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败之种"]
    local data = {context = context, ["幼树单位"] = nil, ["机制单位实例"] = nil, ["剩余跳数"] = cfg["持续秒"] / cfg["波动间隔秒"]}
    local instance = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = "莫尔特斯-腐败幼树",
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["单位类型"] = cfg["幼树单位类型"],
        ["模型路径"] = cfg["幼树模型路径"],
        X = x,
        Y = y,
        ["最大生命"] = cfg["幼树生命值"],
        ["缩放"] = cfg["幼树缩放"],
        ["固定站桩"] = true,
        ["禁止普攻"] = true,
        ["持续时间"] = 0,
        ["on死亡"] = function()
            local ____opt_11 = data["区域实例"]
            if ____opt_11 ~= nil then
                ____opt_11["销毁"]()
            end
        end
    })
    if instance == nil or not _____5355_4F4D_6709_6548(instance["单位"]) then
        return
    end
    data["机制单位实例"] = instance
    data["幼树单位"] = instance["单位"]
    data["区域实例"] = _____521B_5EFA_6301_7EED_5371_9669_533A_57DF({
        X = GetUnitX(instance["单位"]),
        Y = GetUnitY(instance["单位"]),
        ["锚点单位"] = instance["单位"],
        ["半径"] = cfg["波动半径"],
        ["持续时间"] = cfg["持续秒"] + cfg["波动间隔秒"],
        ["检测间隔"] = cfg["波动间隔秒"],
        ["所有者"] = boss,
        ["影响目标"] = "敌方",
        ["提示圈"] = {
            ["类型"] = "敌方圆形",
            ["锚点单位"] = instance["单位"],
            ["半径"] = cfg["波动半径"],
            ["持续时间"] = cfg["持续秒"] + cfg["波动间隔秒"],
            ["来源单位"] = boss,
            ["可手动销毁"] = true
        },
        ["on周期"] = function(_____533A_57DF_5185_5355_4F4D)
            _____5E7C_6811_6CE2_52A8Tick(data, _____533A_57DF_5185_5355_4F4D)
        end,
        ["on销毁"] = function()
            local ____self_13 = data["机制单位实例"]
            if ____self_13["是否存活"](____self_13) then
                local ____self_14 = data["机制单位实例"]
                ____self_14["销毁"](____self_14)
            end
        end
    })
    local ____self_17 = context["清理"]
    ____self_17["登记清理"](
        ____self_17,
        "莫尔特斯-腐败幼树区域",
        function()
            local ____opt_15 = data["区域实例"]
            if ____opt_15 ~= nil then
                ____opt_15["销毁"]()
            end
        end
    )
end
function _____5E7C_6811_6CE2_52A8Tick(data, _____533A_57DF_5185_5355_4F4D)
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败之种"]
    local boss = data.context["Boss单位"]
    local tree = data["幼树单位"]
    local ____temp_19 = not _____5355_4F4D_6709_6548(boss)
    if not ____temp_19 then
        local ____self_18 = data["机制单位实例"]
        ____temp_19 = not ____self_18["是否存活"](____self_18)
    end
    if ____temp_19 or not _____5355_4F4D_6709_6548(tree) or data["剩余跳数"] <= 0 then
        local ____opt_20 = data["区域实例"]
        if ____opt_20 ~= nil then
            ____opt_20["销毁"]()
        end
        return
    end
    data["剩余跳数"] = data["剩余跳数"] - 1
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["幼树Tick特效路径"],
        X = GetUnitX(tree),
        Y = GetUnitY(tree),
        ["持续秒"] = cfg["幼树Tick特效持续秒"]
    })
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local _____533A_57DF_5355_4F4D_8868 = {}
    do
        local i = 0
        while i < #_____533A_57DF_5185_5355_4F4D do
            local unit = _____533A_57DF_5185_5355_4F4D[i + 1]
            if _____5355_4F4D_6709_6548(unit) then
                _____533A_57DF_5355_4F4D_8868[GetHandleId(unit)] = true
            end
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue27
                end
                if not _____533A_57DF_5355_4F4D_8868[GetHandleId(hero)] then
                    goto __continue27
                end
                _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                    ["技能ID"] = _____8150_8D25_4E4B_79CD_6280_80FDID,
                    ["来源"] = boss,
                    ["目标"] = hero,
                    ["伤害公式"] = {["来源攻击力比例"] = cfg["每跳Boss攻击力比例"]},
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_PLANT,
                    weaponType = WEAPON_TYPE_WHOKNOWS
                })
                _____5E94_7528_83AB_5C14_7279_65AF_8150_8D25_503C(data.context, hero, cfg["每跳腐败值"])
            end
            ::__continue27::
            i = i + 1
        end
    end
    if data["剩余跳数"] <= 0 then
        local ____opt_22 = data["区域实例"]
        if ____opt_22 ~= nil then
            ____opt_22["销毁"]()
        end
    end
end
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_0["创建点特效"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_1["创建技能提示圈"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_2["启动基础施法时间线"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetSpellTargetUnit = jass.GetSpellTargetUnit
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetHandleId = jass.GetHandleId
GetOwningPlayer = jass.GetOwningPlayer
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local getServerTime = ____require_result_3.getServerTime
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
_____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____require_result_4["创建可攻击机制单位"]
local ____require_result_5 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_5["获取Boss技能随机敌对英雄"]
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_5["获取Boss技能敌对英雄列表"]
local _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____8150_8D25_4E4B_79CD_6280_80FDID = stringToFourCC(_____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败之种"]["技能槽位"])
local _____5DF2_6CE8_518C = false
local function _____83AB_5C14_7279_65AF_8150_8D25_79CD_5B50_6210_957F(variable)
    local data = variable
    if data == nil then
        return
    end
    _____6E05_7406_83AB_5C14_7279_65AF_8150_8D25_79CD_5B50_5F3A_5316_5012_8BA1_65F6(data["强化倒计时"])
    local ____self_6 = data.seed
    if not ____self_6["是否存活"](____self_6) then
        return
    end
    local ____self_7 = data.seed
    ____self_7["销毁"](____self_7)
    _____521B_5EFA_8150_8D25_5E7C_6811(data.context, data.x, data.y)
end
local function ____on_83AB_5C14_7279_65AF_8150_8D25_79CD_5B50_6B7B_4EA1(_unit, _killer, variable)
    _____6E05_7406_83AB_5C14_7279_65AF_8150_8D25_79CD_5B50_5F3A_5316_5012_8BA1_65F6(variable)
end
local function ____on_83AB_5C14_7279_65AF_8150_8D25_79CD_5B50_9500_6BC1(_unit, variable)
    _____6E05_7406_83AB_5C14_7279_65AF_8150_8D25_79CD_5B50_5F3A_5316_5012_8BA1_65F6(variable)
end
local function _____83AB_5C14_7279_65AF_8150_8D25_79CD_5B50_5F3A_5316_5012_8BA1_65F6(variable)
    local data = variable
    if data == nil then
        return false
    end
    local ____temp_10 = data.seed == nil
    if not ____temp_10 then
        local ____self_9 = data.seed
        ____temp_10 = not ____self_9["是否存活"](____self_9)
    end
    if ____temp_10 then
        _____6E05_7406_83AB_5C14_7279_65AF_8150_8D25_79CD_5B50_5F3A_5316_5012_8BA1_65F6(data)
        return false
    end
    local now = getServerTime()
    local remaining = (data["到期时间毫秒"] - now) / 1000
    if remaining < 0 then
        remaining = 0
    end
    _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI(data.UI, remaining)
    return true
end
local function _____521B_5EFA_843D_5730_79CD_5B50(context, x, y)
    local boss = context["Boss单位"]
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败之种"]
    local _____5F3A_5316_5012_8BA1_65F6 = {
        seed = nil,
        UI = nil,
        ["周期"] = nil,
        ["到期时间毫秒"] = getServerTime() + cfg["生长延迟秒"] * 1000
    }
    local seed = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = "莫尔特斯-腐败种子",
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["单位类型"] = cfg["种子单位类型"],
        ["模型路径"] = cfg["投射物模型路径"],
        X = x,
        Y = y,
        ["最大生命"] = cfg["种子生命值"],
        ["缩放"] = cfg["落地种子缩放"],
        ["固定站桩"] = true,
        ["禁止普攻"] = true,
        ["持续时间"] = cfg["生长延迟秒"] + 1,
        ["变量"] = _____5F3A_5316_5012_8BA1_65F6,
        ["on死亡"] = ____on_83AB_5C14_7279_65AF_8150_8D25_79CD_5B50_6B7B_4EA1,
        ["on销毁"] = ____on_83AB_5C14_7279_65AF_8150_8D25_79CD_5B50_9500_6BC1
    })
    if seed == nil then
        return
    end
    _____5F3A_5316_5012_8BA1_65F6.seed = seed
    _____5F3A_5316_5012_8BA1_65F6.UI = _____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI({
        X = x,
        Y = y,
        Z = cfg["强化进度UI高度"],
        ["最大值"] = cfg["生长延迟秒"],
        ["当前值"] = cfg["生长延迟秒"],
        ["标题"] = "强化",
        ["数值后缀"] = "秒",
        ["类型"] = "自然",
        ["平滑过渡秒"] = cfg["强化进度刷新间隔毫秒"] / 1000,
        ["初始显示"] = true,
        ["雾中可见"] = false
    })
    _____5F3A_5316_5012_8BA1_65F6["周期"] = _____521B_5EFA_9650_6B21_5468_671F_6267_884C_5668({
        ["名称"] = "莫尔特斯-腐败种子强化倒计时",
        ["间隔毫秒"] = cfg["强化进度刷新间隔毫秒"],
        ["最大执行次数"] = cfg["生长延迟秒"] * 1000 / cfg["强化进度刷新间隔毫秒"],
        ["变量"] = _____5F3A_5316_5012_8BA1_65F6,
        ["清理"] = context["清理"],
        onTick = function(______6267_884C_6B21_6570, variable)
            return _____83AB_5C14_7279_65AF_8150_8D25_79CD_5B50_5F3A_5316_5012_8BA1_65F6(variable)
        end
    })
    _____64AD_653EBoss_5750_6807_97F3_6548(_____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["腐败之种"]["扎根成长"], x, y, _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"])
    local id = addDelayedCallback(cfg["生长延迟秒"] * 1000, _____83AB_5C14_7279_65AF_8150_8D25_79CD_5B50_6210_957F, {
        context = context,
        seed = seed,
        x = x,
        y = y,
        ["强化倒计时"] = _____5F3A_5316_5012_8BA1_65F6
    })
    local ____self_24 = context["清理"]
    ____self_24["登记延迟回调"](____self_24, "莫尔特斯-腐败种子成长", id)
end
local function _____9500_6BC1_8150_8D25_4E4B_79CD_5F39_5E55(_____5F39_5E55)
    if _____5F39_5E55 == nil or _____5F39_5E55 == 0 or _____5F39_5E55["销毁"] == nil then
        return
    end
    _____5F39_5E55["销毁"](_____5F39_5E55, "手动销毁")
end
local function _____53D1_5C04_8150_8D25_4E4B_79CD(context, tx, ty)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败之种"]
    local sx = GetUnitX(boss)
    local sy = GetUnitY(boss)
    local angle = _____53D6_5750_6807_89D2_5EA6(sx, sy, tx, ty) + 90
    local distance = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["根须领域"]["单格边长"] * cfg["中点偏移比例"]
    local midX = _____6781_5750_6807X((sx + tx) / 2, angle, distance)
    local midY = _____6781_5750_6807Y((sy + ty) / 2, angle, distance)
    local _____5F39_5E55 = _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = boss,
        ["载体模式"] = "特效",
        X = sx,
        Y = sy,
        ["方向角"] = _____53D6_5750_6807_89D2_5EA6(sx, sy, tx, ty),
        ["速度"] = 0,
        ["生命周期"] = cfg["飞行秒"],
        ["命中半径"] = 0,
        ["碰撞消失"] = false,
        ["禁用碰撞"] = true,
        ["不可阻挡"] = true,
        ["飞行高度"] = 0,
        ["附加特效1"] = {["模型"] = cfg["投射物模型路径"], ["跟随主弹幕参数"] = true, ["跟随轨迹俯仰"] = true, ["缩放"] = cfg["投射物缩放"]},
        ["轨迹采样器"] = _____521B_5EFA_4E8C_9636_8D1D_585E_5C14XYZ_8F68_8FF9(
            sx,
            sy,
            0,
            midX,
            midY,
            cfg["弧线高度"] * 2,
            tx,
            ty,
            0
        ),
        ["on到达目标点"] = function(______5F39_5E55ID, ______539F_56E0)
            _____521B_5EFA_843D_5730_79CD_5B50(context, tx, ty)
        end
    })
    local ____self_25 = context["清理"]
    ____self_25["登记清理"](____self_25, "莫尔特斯-腐败之种弹幕", _____9500_6BC1_8150_8D25_4E4B_79CD_5F39_5E55, _____5F39_5E55)
end
____exports["释放莫尔特斯腐败之种"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败之种"]
    local spellTarget = GetSpellTargetUnit()
    local _____5355_4F4D_6709_6548_result_26
    if _____5355_4F4D_6709_6548(spellTarget) then
        _____5355_4F4D_6709_6548_result_26 = spellTarget
    else
        _____5355_4F4D_6709_6548_result_26 = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss)
    end
    local target = _____5355_4F4D_6709_6548_result_26
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local targetX = GetUnitX(target)
    local targetY = GetUnitY(target)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "敌方圆形",
        X = targetX,
        Y = targetY,
        ["半径"] = cfg["波动半径"],
        ["持续时间"] = cfg["动作播放秒"] + cfg["飞行秒"] + cfg["生长延迟秒"],
        ["来源单位"] = boss
    })
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["名称"] = "莫尔特斯-腐败之种",
        ["施法者"] = boss,
        ["目标X"] = targetX,
        ["目标Y"] = targetY,
        ["硬直秒"] = cfg["动作播放秒"],
        ["动画编号"] = cfg["动画编号"],
        ["动画速度"] = cfg["动画速度"],
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = cfg["动作播放秒"],
            ["颜色ID"] = cfg["吟唱条颜色ID"],
            ["标题文本"] = cfg["吟唱条标题文本"],
            ["提示文本"] = cfg["吟唱条提示文本"]
        },
        ["清理"] = context["清理"],
        ["播放台词"] = function()
            _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD(boss, "腐败之种")
        end,
        ["on生效"] = function()
            _____53D1_5C04_8150_8D25_4E4B_79CD(context, targetX, targetY)
        end
    })
end
local function ____on_83AB_5C14_7279_65AF_8150_8D25_4E4B_79CD_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____8150_8D25_4E4B_79CD_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放莫尔特斯腐败之种"](context)
end
____exports["注册莫尔特斯腐败之种"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "07．腐败之种",
        ["单位类型ID"] = _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____8150_8D25_4E4B_79CD_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_83AB_5C14_7279_65AF_8150_8D25_4E4B_79CD_65BD_6CD5(boss, _____8150_8D25_4E4B_79CD_6280_80FDID)
        end
    })
end
return ____exports
