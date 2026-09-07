--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.22．朱雀院椿.00．配置")
local _____6731_96C0_9662_693F_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿技能配置"]
local _____6731_96C0_9662_693F_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿表现配置"]
local _____6731_96C0_9662_693F_52A8_4F5C_69FD = ____00_FF0E_914D_7F6E["朱雀院椿动作槽"]
local _____6731_96C0_9662_693FR_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿R配置"]
local _____6731_96C0_9662_693F_8BFB_6761_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿读条配置"]
local _____6731_96C0_9662_693F_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿音效配置"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local fourCCToStringSafe = ____require_result_0.fourCCToStringSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local GetRandomReal = jass.GetRandomReal
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_2["注册单位技能壳监听"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_3["开始充能"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_4["开始硬直"]
local ____require_result_5 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_5.registerDamageModifier
local unregisterDamageModifier = ____require_result_5.unregisterDamageModifier
local ____require_result_6 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_6["造成技能伤害"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_7["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_7["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_7["两点角度"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域")
local _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D = ____require_result_8["获取扇形区域单位"]
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_9["创建点特效"]
local ____require_result_10 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_10.Sound3DII_UnitPlayReuse
local Sound3DII_CooPlayReuse = ____require_result_10.Sound3DII_CooPlayReuse
local ____require_result_11 = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话")
local _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD = ____require_result_11["播放英雄技能喊话"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.04．英雄技能.22．朱雀院椿.02．被动效果")
local _____662F_6731_96C0_9662_693F = ____require_result_12["是朱雀院椿"]
local _____83B7_53D6_59FF_6001 = ____require_result_12["获取姿态"]
local _____9501_5B9A_59FF_6001 = ____require_result_12["锁定姿态"]
local _____6062_590DVF = ____require_result_12["恢复VF"]
local _____6263_9664VF = ____require_result_12["扣除VF"]
local _____64AD_653E_693F_52A8_4F5C = ____require_result_12["播放椿动作"]
local _____6709_51B3_6597_8DDD_79BB = ____require_result_12["有决斗距离"]
local _____83B7_53D6_51B3_6597_8DDD_79BB_65B9_5411 = ____require_result_12["获取决斗距离方向"]
local _____83B7_53D6_51B3_6597_8DDD_79BB_951A_70B9 = ____require_result_12["获取决斗距离锚点"]
local _____6E05_9664_51B3_6597_8DDD_79BB = ____require_result_12["清除决斗距离"]
local ____require_result_13 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_13.debugLogForce
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6731_96C0_9662_693F_6280_80FD_914D_7F6E["单位类型ID"])
local ____R_6280_80FDID = stringToFourCCSafe(_____6731_96C0_9662_693F_6280_80FD_914D_7F6E.R["技能ID"])
local ____R_914D_7F6E = _____6731_96C0_9662_693FR_914D_7F6E
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitName = jass.GetUnitName
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local _____84C4_529B_4E2D_8868 = {}
--- W 检查：R 蓄力期间禁止开启 W
____exports["椿R蓄力中"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return false
    end
    return _____84C4_529B_4E2D_8868[jass.GetHandleId(_____82F1_96C4)] == true
end
--- 主斩目标点叠加：固定间隔在 R 目标点以随机角度逐层创建（主层 + 叠加层 + 附加层三张同播），单个存活 单次持续秒
local function _____521B_5EFAR_76EE_6807_53E0_52A0(_____914D_7F6E, X, Y)
    local _____5DF2_521B_5EFA_6B21_6570 = 0
    local _____5468_671FID = 0
    local function _____521B_5EFA_4E00_6B21()
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____914D_7F6E["模型路径"],
            RGB = _____914D_7F6E.RGB,
            X = X,
            Y = Y,
            Z = _____914D_7F6E["高度"],
            ["面向角度"] = GetRandomReal(0, 360),
            ["缩放"] = _____914D_7F6E["缩放"],
            ["持续秒"] = _____914D_7F6E["单次持续秒"]
        })
        local _____53E0_52A0_8DEF_5F84 = _____914D_7F6E["叠加模型路径"]
        if _____53E0_52A0_8DEF_5F84 ~= "" then
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = _____53E0_52A0_8DEF_5F84,
                RGB = _____914D_7F6E.RGB,
                X = X,
                Y = Y,
                Z = _____914D_7F6E["高度"],
                ["面向角度"] = GetRandomReal(0, 360),
                ["缩放"] = _____914D_7F6E["缩放"],
                ["持续秒"] = _____914D_7F6E["单次持续秒"]
            })
        end
        local _____9644_52A0_8DEF_5F84 = _____914D_7F6E["附加模型路径"]
        if _____9644_52A0_8DEF_5F84 ~= "" then
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = _____9644_52A0_8DEF_5F84,
                RGB = _____914D_7F6E.RGB,
                X = X,
                Y = Y,
                Z = _____914D_7F6E["高度"],
                ["面向角度"] = GetRandomReal(0, 360),
                ["缩放"] = _____914D_7F6E["缩放"],
                ["持续秒"] = _____914D_7F6E["单次持续秒"]
            })
        end
        _____5DF2_521B_5EFA_6B21_6570 = _____5DF2_521B_5EFA_6B21_6570 + 1
        if _____5DF2_521B_5EFA_6B21_6570 >= _____914D_7F6E["创建次数"] and _____5468_671FID ~= 0 then
            removePeriodicCallback(_____5468_671FID)
            _____5468_671FID = 0
        end
    end
    _____5468_671FID = addPeriodicCallback(_____914D_7F6E["创建间隔秒"] * 1000, _____521B_5EFA_4E00_6B21)
    _____521B_5EFA_4E00_6B21()
end
local function _____7ED3_7B97R_4F24_5BB3(_____65BD_6CD5_8005, _____76EE_6807, _____6280_80FD_5B9E_4F8BID, _____4F24_5BB3_503C, _____6807_7B7E)
    debugLogForce(
        "椿-R",
        "命中",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(____R_6280_80FDID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "标签",
        _____6807_7B7E,
        "目标",
        GetUnitName(_____76EE_6807),
        "handle",
        _____76EE_6807,
        "X",
        math.floor(GetUnitX(_____76EE_6807)),
        "Y",
        math.floor(GetUnitY(_____76EE_6807)),
        "伤害",
        _____4F24_5BB3_503C
    )
    _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = _____65BD_6CD5_8005,
        ["目标"] = _____76EE_6807,
        ["伤害"] = _____4F24_5BB3_503C,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____R_6280_80FDID,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["标签"] = _____6807_7B7E,
        ["伤害形态"] = "AOE",
        ["参与技能伤害加成"] = true
    })
end
local function ____R_521B_5EFA_7EC8_5F0F(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____65B9_5411_89D2, _____53D7_51FB_8BB0_5F55, _____76EE_6807X, _____76EE_6807Y)
    if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        debugLogForce(
            "椿-R",
            "命中失败",
            "原因",
            "施法者已死亡",
            "玩家",
            GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
            "四码",
            fourCCToStringSafe(____R_6280_80FDID),
            "实例",
            _____6280_80FD_5B9E_4F8BID or "-"
        )
        return
    end
    local _____73A9_5BB6ID = GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1
    debugLogForce(
        "椿-R",
        "结算",
        "玩家",
        _____73A9_5BB6ID,
        "四码",
        fourCCToStringSafe(____R_6280_80FDID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "标签",
        "朱雀院椿-R终式",
        "姿态",
        _____83B7_53D6_59FF_6001(_____65BD_6CD5_8005),
        "方向",
        _____65B9_5411_89D2,
        "受击记录",
        _____53D7_51FB_8BB0_5F55,
        "伤害",
        _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____R_914D_7F6E["主斩倍率"]
    )
    local _____653B_51FB_529B = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005)
    local _____59FF_6001 = _____83B7_53D6_59FF_6001(_____65BD_6CD5_8005)
    _____64AD_653E_693F_52A8_4F5C(_____65BD_6CD5_8005, _____59FF_6001 == "二刀" and _____6731_96C0_9662_693F_52A8_4F5C_69FD["R二刀释放"] or _____6731_96C0_9662_693F_52A8_4F5C_69FD["R一刀释放"])
    local _____654C_4EBA = _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D({
        X = GetUnitX(_____65BD_6CD5_8005),
        Y = GetUnitY(_____65BD_6CD5_8005),
        ["半径"] = ____R_914D_7F6E["距离"],
        ["方向角"] = _____65B9_5411_89D2,
        ["扇形角度"] = _____59FF_6001 == "二刀" and ____R_914D_7F6E["二刀扇形角度"] or ____R_914D_7F6E["一刀窄线角度"],
        ["单位筛选"] = function(_____5355_4F4D)
            return _____5355_4F4D ~= _____65BD_6CD5_8005 and _____5355_4F4D_5B58_6D3B(_____5355_4F4D) and jass.IsUnitEnemy(
                _____5355_4F4D,
                jass.GetOwningPlayer(_____65BD_6CD5_8005)
            )
        end
    })
    if #_____654C_4EBA == 0 then
        debugLogForce(
            "椿-R",
            "命中失败",
            "原因",
            "无目标",
            "玩家",
            _____73A9_5BB6ID,
            "四码",
            fourCCToStringSafe(____R_6280_80FDID),
            "实例",
            _____6280_80FD_5B9E_4F8BID or "-",
            "方向",
            _____65B9_5411_89D2
        )
    end
    do
        local i = 0
        while i < #_____654C_4EBA do
            _____7ED3_7B97R_4F24_5BB3(
                _____65BD_6CD5_8005,
                _____654C_4EBA[i + 1],
                _____6280_80FD_5B9E_4F8BID,
                _____653B_51FB_529B * ____R_914D_7F6E["主斩倍率"],
                "朱雀院椿-R主斩"
            )
            i = i + 1
        end
    end
    if _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R主斩"]["模型路径"] ~= "" then
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R主斩"]["模型路径"],
            RGB = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R主斩"].RGB,
            X = _____76EE_6807X,
            Y = _____76EE_6807Y,
            Z = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R主斩"]["高度"],
            ["面向角度"] = _____65B9_5411_89D2,
            ["动画索引"] = 0,
            ["缩放"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R主斩"]["缩放"],
            ["持续秒"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R主斩"]["持续秒"]
        })
    end
    if _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R主斩叠加"]["模型路径"] ~= "" then
        _____521B_5EFAR_76EE_6807_53E0_52A0(_____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R主斩叠加"], _____76EE_6807X, _____76EE_6807Y)
    end
    if _____59FF_6001 == "一刀" and _____53D7_51FB_8BB0_5F55 then
        do
            local i = 0
            while i < #_____654C_4EBA do
                _____7ED3_7B97R_4F24_5BB3(
                    _____65BD_6CD5_8005,
                    _____654C_4EBA[i + 1],
                    _____6280_80FD_5B9E_4F8BID,
                    _____653B_51FB_529B * ____R_914D_7F6E["反击斩倍率"],
                    "朱雀院椿-R后之先反击"
                )
                i = i + 1
            end
        end
        _____6062_590DVF(_____65BD_6CD5_8005, ____R_914D_7F6E["一刀受击恢复VF"])
    end
    if _____59FF_6001 == "二刀" then
        local _____5269_4F59VF = _____6263_9664VF(_____65BD_6CD5_8005, ____R_914D_7F6E["二刀VF代价"])
        debugLogForce(
            "椿-R",
            "状态",
            "二刀终式扣VF",
            "玩家",
            _____73A9_5BB6ID,
            "量",
            ____R_914D_7F6E["二刀VF代价"],
            "剩余VF",
            _____5269_4F59VF
        )
        do
            local i = 0
            while i < #_____654C_4EBA do
                _____7ED3_7B97R_4F24_5BB3(
                    _____65BD_6CD5_8005,
                    _____654C_4EBA[i + 1],
                    _____6280_80FD_5B9E_4F8BID,
                    _____653B_51FB_529B * ____R_914D_7F6E["二刀交错倍率"],
                    "朱雀院椿-R交错斩"
                )
                i = i + 1
            end
        end
        if _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R交错斩"]["模型路径"] ~= "" then
            local _____4EA4_53C9_968F_673A_89D2 = GetRandomReal(0, 360)
            local function _____521B_5EFA_4EA4_9519_5200(_____89D2_5EA6)
                _____521B_5EFA_70B9_7279_6548({
                    ["模型路径"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R交错斩"]["模型路径"],
                    RGB = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R交错斩"].RGB,
                    X = _____76EE_6807X,
                    Y = _____76EE_6807Y,
                    Z = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R交错斩"]["高度"],
                    ["面向角度"] = _____89D2_5EA6,
                    ["动画索引"] = 0,
                    ["缩放"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R交错斩"]["缩放"],
                    ["持续秒"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R交错斩"]["持续秒"]
                })
            end
            _____521B_5EFA_4EA4_9519_5200(_____4EA4_53C9_968F_673A_89D2)
            addDelayedCallback(
                150,
                function()
                    if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
                        return
                    end
                    _____521B_5EFA_4EA4_9519_5200(_____4EA4_53C9_968F_673A_89D2 + 90)
                end
            )
        end
        Sound3DII_CooPlayReuse(
            _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["二刀交错"]["路径"],
            _____76EE_6807X,
            _____76EE_6807Y,
            _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["二刀交错"]["高度"],
            _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["二刀交错"]["裁断距离"]
        )
    end
end
local function _____91CA_653ER_708E_59EC(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    if not _____662F_6731_96C0_9662_693F(_____65BD_6CD5_8005) then
        debugLogForce(
            "椿-R",
            "释放被拒",
            "原因",
            "非朱雀院椿",
            "玩家",
            GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
            "四码",
            fourCCToStringSafe(____R_6280_80FDID),
            "实例",
            _____6280_80FD_5B9E_4F8BID or "-"
        )
        return
    end
    debugLogForce(
        "椿-R",
        "释放",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(____R_6280_80FDID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "目标",
        "点施放",
        "X",
        math.floor(GetSpellTargetX()),
        "Y",
        math.floor(GetSpellTargetY()),
        "姿态",
        _____83B7_53D6_59FF_6001(_____65BD_6CD5_8005)
    )
    if _____84C4_529B_4E2D_8868[jass.GetHandleId(_____65BD_6CD5_8005)] == true then
        debugLogForce(
            "椿-R",
            "释放被拒",
            "原因",
            "已有蓄力/终式",
            "玩家",
            GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
            "四码",
            fourCCToStringSafe(____R_6280_80FDID),
            "实例",
            _____6280_80FD_5B9E_4F8BID or "-"
        )
        return
    end
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    local _____65B9_5411_89D2 = _____4E24_70B9_89D2_5EA6(
        GetUnitX(_____65BD_6CD5_8005),
        GetUnitY(_____65BD_6CD5_8005),
        _____76EE_6807X,
        _____76EE_6807Y
    )
    _____5F00_59CB_786C_76F4(_____65BD_6CD5_8005, _____6731_96C0_9662_693FR_914D_7F6E["施法硬直秒"])
    _____64AD_653E_693F_52A8_4F5C(_____65BD_6CD5_8005, _____6731_96C0_9662_693F_52A8_4F5C_69FD["R蓄力"])
    _____9501_5B9A_59FF_6001(_____65BD_6CD5_8005, true)
    _____84C4_529B_4E2D_8868[jass.GetHandleId(_____65BD_6CD5_8005)] = true
    debugLogForce(
        "椿-R",
        "状态",
        "蓄力开始",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(____R_6280_80FDID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "方向",
        _____65B9_5411_89D2
    )
    local _____51B3_6597_8DDD_79BB_5FEB_7167 = {
        ["有效"] = _____6709_51B3_6597_8DDD_79BB(_____65BD_6CD5_8005),
        ["方向"] = _____83B7_53D6_51B3_6597_8DDD_79BB_65B9_5411(_____65BD_6CD5_8005)
    }
    local _____53D7_51FB_8BB0_5F55 = false
    local _____53D7_51FB_4FEE_6539_5668ID = 0
    if _____83B7_53D6_59FF_6001(_____65BD_6CD5_8005) == "一刀" then
        _____53D7_51FB_4FEE_6539_5668ID = registerDamageModifier(
            function(context)
                if context.target ~= _____65BD_6CD5_8005 then
                    return context.currentDamage
                end
                if context.currentDamage <= 0 then
                    return context.currentDamage
                end
                if context.attacker == nil or context.attacker == 0 or context.attacker == _____65BD_6CD5_8005 then
                    return context.currentDamage
                end
                if not jass.IsUnitEnemy(
                    context.attacker,
                    jass.GetOwningPlayer(_____65BD_6CD5_8005)
                ) then
                    return context.currentDamage
                end
                if _____53D7_51FB_8BB0_5F55 then
                    return context.currentDamage
                end
                _____53D7_51FB_8BB0_5F55 = true
                debugLogForce(
                    "椿-R",
                    "状态",
                    "后之先受击记录",
                    "玩家",
                    GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
                    "四码",
                    fourCCToStringSafe(____R_6280_80FDID),
                    "来源",
                    GetUnitName(context.attacker),
                    "handle",
                    context.attacker
                )
                return context.currentDamage
            end,
            50
        )
    end
    local _____9884_8B66_7279_6548 = nil
    local _____84C4_529B_53E0_52A0_7279_6548 = nil
    local _____5145_80FDID = _____5F00_59CB_5145_80FD(
        _____65BD_6CD5_8005,
        {
            ["持续时间"] = ____R_914D_7F6E["蓄力秒"],
            ["指令中断"] = true,
            ["世界坐标进度UI"] = true,
            ["世界坐标进度UI类型"] = _____6731_96C0_9662_693F_8BFB_6761_914D_7F6E["UI类型"],
            ["世界坐标进度UI标题"] = "炎姬·黄泉凤凰",
            ["世界坐标进度UI数值后缀"] = "",
            ["世界坐标进度UI高度偏移"] = _____6731_96C0_9662_693F_8BFB_6761_914D_7F6E["跟随Z偏移"],
            ["世界坐标进度UI屏幕Y偏移"] = _____6731_96C0_9662_693F_8BFB_6761_914D_7F6E["蓄力条"]["屏幕Y偏移"],
            ["显示进度条特效"] = false,
            ["开始回调"] = function(______5355_4F4D, ______5145_80FDID)
                local _____53E0_52A0 = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R蓄力叠加"]
                _____84C4_529B_53E0_52A0_7279_6548 = _____521B_5EFA_70B9_7279_6548({
                    ["模型路径"] = _____53E0_52A0["模型路径"],
                    RGB = _____53E0_52A0.RGB,
                    X = GetUnitX(_____65BD_6CD5_8005),
                    Y = GetUnitY(_____65BD_6CD5_8005),
                    Z = _____53E0_52A0["高度"],
                    ["面向角度"] = _____65B9_5411_89D2,
                    ["动画索引"] = _____53E0_52A0["动画索引"],
                    ["缩放"] = _____53E0_52A0["缩放"],
                    ["持续秒"] = _____53E0_52A0["持续秒"],
                    ["动画速度"] = 1 / ____R_914D_7F6E["蓄力秒"]
                })
                Sound3DII_UnitPlayReuse(_____6731_96C0_9662_693F_97F3_6548_914D_7F6E["R蓄力"]["路径"], _____65BD_6CD5_8005, _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["R蓄力"]["裁断距离"])
                if _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R蓄力提示"]["模型路径"] ~= "" then
                    _____9884_8B66_7279_6548 = _____521B_5EFA_70B9_7279_6548({
                        ["模型路径"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R蓄力提示"]["模型路径"],
                        RGB = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R蓄力提示"].RGB,
                        X = _____76EE_6807X,
                        Y = _____76EE_6807Y,
                        Z = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R蓄力提示"]["高度"],
                        ["缩放"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R蓄力提示"]["缩放"],
                        ["持续秒"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["R蓄力提示"]["持续秒"]
                    })
                end
            end,
            ["充能完成回调"] = function(______5355_4F4D, ______5145_80FDID)
                Sound3DII_CooPlayReuse(
                    _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["R终式"]["路径"],
                    GetUnitX(_____65BD_6CD5_8005),
                    GetUnitY(_____65BD_6CD5_8005),
                    _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["R终式"]["高度"],
                    _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["R终式"]["裁断距离"]
                )
                local _____7EC8_5F0F_65B9_5411 = _____51B3_6597_8DDD_79BB_5FEB_7167["有效"] and _____51B3_6597_8DDD_79BB_5FEB_7167["方向"] or _____65B9_5411_89D2
                local _____7EC8_5F0F_951A_70B9X = _____76EE_6807X
                local _____7EC8_5F0F_951A_70B9Y = _____76EE_6807Y
                if _____51B3_6597_8DDD_79BB_5FEB_7167["有效"] then
                    debugLogForce(
                        "椿-R",
                        "状态",
                        "决斗距离锁定",
                        "玩家",
                        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
                        "四码",
                        fourCCToStringSafe(____R_6280_80FDID),
                        "方向",
                        _____51B3_6597_8DDD_79BB_5FEB_7167["方向"]
                    )
                    local _____51B3_6597_951A_70B9 = _____83B7_53D6_51B3_6597_8DDD_79BB_951A_70B9(_____65BD_6CD5_8005)
                    if _____51B3_6597_951A_70B9 ~= nil then
                        _____7EC8_5F0F_951A_70B9X = _____51B3_6597_951A_70B9.X
                        _____7EC8_5F0F_951A_70B9Y = _____51B3_6597_951A_70B9.Y
                        debugLogForce(
                            "椿-R",
                            "状态",
                            "决斗距离锚点",
                            "玩家",
                            GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
                            "X",
                            math.floor(_____51B3_6597_951A_70B9.X),
                            "Y",
                            math.floor(_____51B3_6597_951A_70B9.Y)
                        )
                    end
                    _____6E05_9664_51B3_6597_8DDD_79BB(_____65BD_6CD5_8005)
                end
                ____R_521B_5EFA_7EC8_5F0F(
                    _____65BD_6CD5_8005,
                    _____6280_80FD_5B9E_4F8BID,
                    _____7EC8_5F0F_65B9_5411,
                    _____53D7_51FB_8BB0_5F55,
                    _____7EC8_5F0F_951A_70B9X,
                    _____7EC8_5F0F_951A_70B9Y
                )
            end,
            ["结束回调"] = function(______5355_4F4D, ______539F_56E0, ______5145_80FDID)
                debugLogForce(
                    "椿-R",
                    "结束",
                    "玩家",
                    GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
                    "四码",
                    fourCCToStringSafe(____R_6280_80FDID),
                    "实例",
                    _____6280_80FD_5B9E_4F8BID or "-",
                    "原因",
                    ______539F_56E0 or "-"
                )
                if _____9884_8B66_7279_6548 ~= nil and _____9884_8B66_7279_6548 ~= 0 then
                    jass.DestroyEffect(_____9884_8B66_7279_6548)
                    _____9884_8B66_7279_6548 = nil
                end
                if _____84C4_529B_53E0_52A0_7279_6548 ~= nil and _____84C4_529B_53E0_52A0_7279_6548 ~= 0 then
                    jass.DestroyEffect(_____84C4_529B_53E0_52A0_7279_6548)
                    _____84C4_529B_53E0_52A0_7279_6548 = nil
                end
                if _____53D7_51FB_4FEE_6539_5668ID ~= 0 then
                    unregisterDamageModifier(_____53D7_51FB_4FEE_6539_5668ID)
                    _____53D7_51FB_4FEE_6539_5668ID = 0
                end
                _____84C4_529B_4E2D_8868[jass.GetHandleId(_____65BD_6CD5_8005)] = false
                _____9501_5B9A_59FF_6001(_____65BD_6CD5_8005, false)
            end
        }
    )
    if _____5145_80FDID > 0 then
        _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD(_____65BD_6CD5_8005, "朱雀院椿", _____6731_96C0_9662_693F_6280_80FD_914D_7F6E.R["技能ID"])
    end
end
local _____5DF2_6CE8_518C = false
____exports["注册朱雀院椿R"] = function()
    debugLogForce("椿-R", "注册", "名称", "注册朱雀院椿R")
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "朱雀院椿-炎姬·黄泉凤凰（R）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = "ATR1",
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653ER_708E_59EC,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = ____R_914D_7F6E["蓄力秒"] + 1
    })
end
____exports["朱雀院椿R模块"] = {["技能ID"] = _____6731_96C0_9662_693F_6280_80FD_914D_7F6E.R["技能ID"], ["蓄力秒"] = ____R_914D_7F6E["蓄力秒"], ["世界坐标读条"] = _____6731_96C0_9662_693F_8BFB_6761_914D_7F6E, ["注册"] = ____exports["注册朱雀院椿R"]}
return ____exports
