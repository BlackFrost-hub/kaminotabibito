local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.22．朱雀院椿.00．配置")
local _____6731_96C0_9662_693F_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿技能配置"]
local _____6731_96C0_9662_693F_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿表现配置"]
local _____6731_96C0_9662_693F_52A8_4F5C_69FD = ____00_FF0E_914D_7F6E["朱雀院椿动作槽"]
local _____6731_96C0_9662_693FE_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿E配置"]
local _____6731_96C0_9662_693F_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿音效配置"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local fourCCToStringSafe = ____require_result_0.fourCCToStringSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getGameTime = ____require_result_1.getGameTime
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_2["注册单位技能壳监听"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂")
local _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_3["创建战斗技能实例"]
local _____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_3["查询战斗技能实例"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_4["开始硬直"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_5["开始冲锋"]
local _____505C_6B62_4F4D_79FB = ____require_result_5["停止位移"]
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
local _____6D88_8D39_53CD_51FB_51C6_5907 = ____require_result_12["消费反击准备"]
local _____6062_590DVF = ____require_result_12["恢复VF"]
local _____6263_9664VF = ____require_result_12["扣除VF"]
local _____83B7_53D6_59FF_6001 = ____require_result_12["获取姿态"]
local _____8BBE_7F6E_51B3_6597_8DDD_79BB = ____require_result_12["设置决斗距离"]
local _____767B_8BB0_693F_6E05_7406 = ____require_result_12["登记椿清理"]
local _____64AD_653E_693F_52A8_4F5C = ____require_result_12["播放椿动作"]
local ____require_result_13 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_13.debugLogForce
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6731_96C0_9662_693F_6280_80FD_914D_7F6E["单位类型ID"])
local ____E_6280_80FDID = stringToFourCCSafe(_____6731_96C0_9662_693F_6280_80FD_914D_7F6E.E["技能ID"])
local ____E_914D_7F6E = _____6731_96C0_9662_693FE_914D_7F6E
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
local _____56DE_950B_8868 = {}
____exports["获取椿回锋方向"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return nil
    end
    local id = jass.GetHandleId(_____82F1_96C4)
    local _____72B6_6001 = _____56DE_950B_8868[id]
    if _____72B6_6001 == nil or getGameTime() > _____72B6_6001["到期"] then
        return nil
    end
    __TS__Delete(_____56DE_950B_8868, id)
    return _____72B6_6001["方向"]
end
local function _____8BBE_7F6E_56DE_950B_65B9_5411(_____82F1_96C4, _____65B9_5411)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local _____786C_76F4_79D2 = _____6731_96C0_9662_693F_52A8_4F5C_69FD["E终点横斩"]["持续秒"]
    _____56DE_950B_8868[jass.GetHandleId(_____82F1_96C4)] = {
        ["到期"] = getGameTime() + (_____786C_76F4_79D2 + ____E_914D_7F6E["回锋方向有效秒"]) * 1000,
        ["方向"] = _____65B9_5411
    }
    debugLogForce(
        "椿-E",
        "状态",
        "设置回锋方向",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____82F1_96C4)) + 1,
        "方向",
        _____65B9_5411,
        "有效秒",
        ____E_914D_7F6E["回锋方向有效秒"],
        "硬直秒",
        _____786C_76F4_79D2
    )
end
local function _____7ED3_7B97E_7EC8_70B9_6A2A_65A9(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
    local _____73A9_5BB6ID = GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1
    debugLogForce(
        "椿-E",
        "结算",
        "玩家",
        _____73A9_5BB6ID,
        "四码",
        fourCCToStringSafe(____E_6280_80FDID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "标签",
        "朱雀院椿-E横斩",
        "伤害",
        _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____E_914D_7F6E["横斩倍率"],
        "方向",
        _____6570_636E["方向角"],
        "落点X",
        math.floor(_____6570_636E["终点X"]),
        "落点Y",
        math.floor(_____6570_636E["终点Y"])
    )
    _____5F00_59CB_786C_76F4(_____65BD_6CD5_8005, _____6731_96C0_9662_693F_52A8_4F5C_69FD["E终点横斩"]["持续秒"], {["标题"] = "刃道·间合"})
    _____64AD_653E_693F_52A8_4F5C(_____65BD_6CD5_8005, _____6731_96C0_9662_693F_52A8_4F5C_69FD["E终点横斩"])
    if _____6570_636E["已结算"] then
        return
    end
    _____6570_636E["已结算"] = true
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["E终点主斩"]["模型路径"],
        RGB = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["E终点主斩"].RGB,
        X = _____6570_636E["终点X"],
        Y = _____6570_636E["终点Y"],
        Z = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["E终点主斩"]["高度"],
        ["面向角度"] = _____6570_636E["方向角"],
        ["动画索引"] = 0,
        ["缩放"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["E终点主斩"]["缩放"],
        ["持续秒"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["E终点主斩"]["持续秒"]
    })
    Sound3DII_CooPlayReuse(
        _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["E终点横斩"]["路径"],
        _____6570_636E["终点X"],
        _____6570_636E["终点Y"],
        _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["E终点横斩"]["高度"],
        _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["E终点横斩"]["裁断距离"]
    )
    local _____654C_4EBA = _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D({
        X = _____6570_636E["终点X"],
        Y = _____6570_636E["终点Y"],
        ["半径"] = ____E_914D_7F6E["横斩半径"],
        ["方向角"] = _____6570_636E["方向角"],
        ["扇形角度"] = ____E_914D_7F6E["横斩扇形角度"],
        ["单位筛选"] = function(_____5355_4F4D)
            return _____5355_4F4D ~= _____65BD_6CD5_8005 and _____5355_4F4D_5B58_6D3B(_____5355_4F4D) and jass.IsUnitEnemy(
                _____5355_4F4D,
                jass.GetOwningPlayer(_____65BD_6CD5_8005)
            )
        end
    })
    if #_____654C_4EBA == 0 then
        debugLogForce(
            "椿-E",
            "命中失败",
            "原因",
            "无目标",
            "玩家",
            _____73A9_5BB6ID,
            "四码",
            fourCCToStringSafe(____E_6280_80FDID),
            "实例",
            _____6280_80FD_5B9E_4F8BID or "-",
            "方向",
            _____6570_636E["方向角"]
        )
    end
    do
        local i = 0
        while i < #_____654C_4EBA do
            debugLogForce(
                "椿-E",
                "命中",
                "玩家",
                _____73A9_5BB6ID,
                "四码",
                fourCCToStringSafe(____E_6280_80FDID),
                "实例",
                _____6280_80FD_5B9E_4F8BID or "-",
                "标签",
                "朱雀院椿-E横斩",
                "目标",
                GetUnitName(_____654C_4EBA[i + 1]),
                "handle",
                _____654C_4EBA[i + 1],
                "X",
                math.floor(GetUnitX(_____654C_4EBA[i + 1])),
                "Y",
                math.floor(GetUnitY(_____654C_4EBA[i + 1])),
                "伤害",
                _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____E_914D_7F6E["横斩倍率"]
            )
            _____9020_6210_6280_80FD_4F24_5BB3({
                ["来源"] = _____65BD_6CD5_8005,
                ["目标"] = _____654C_4EBA[i + 1],
                ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____E_914D_7F6E["横斩倍率"],
                ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                ["攻击类型"] = ATTACK_TYPE_NORMAL,
                ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
                ["来源类型"] = "单位技能",
                ["技能ID"] = ____E_6280_80FDID,
                ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                ["标签"] = "朱雀院椿-E横斩",
                ["伤害形态"] = "AOE",
                ["参与技能伤害加成"] = true
            })
            i = i + 1
        end
    end
    if _____6570_636E["精确回锋"] then
        _____8BBE_7F6E_56DE_950B_65B9_5411(_____65BD_6CD5_8005, _____6570_636E["方向角"])
    end
    if _____83B7_53D6_59FF_6001(_____65BD_6CD5_8005) == "一刀" then
        _____6062_590DVF(_____65BD_6CD5_8005, ____E_914D_7F6E["一刀VF恢复"])
    else
        local _____5269_4F59VF = _____6263_9664VF(_____65BD_6CD5_8005, ____E_914D_7F6E["二刀VF代价"])
        debugLogForce(
            "椿-E",
            "状态",
            "二刀横斩扣VF",
            "玩家",
            GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
            "量",
            ____E_914D_7F6E["二刀VF代价"],
            "剩余VF",
            _____5269_4F59VF
        )
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["E二刀第二斩"]["模型路径"],
            RGB = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["E二刀第二斩"].RGB,
            X = _____6570_636E["终点X"],
            Y = _____6570_636E["终点Y"],
            Z = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["E二刀第二斩"]["高度"],
            ["面向角度"] = _____6570_636E["方向角"],
            ["缩放"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["E二刀第二斩"]["缩放"],
            ["持续秒"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["E二刀第二斩"]["持续秒"]
        })
        do
            local i = 0
            while i < #_____654C_4EBA do
                debugLogForce(
                    "椿-E",
                    "命中",
                    "玩家",
                    _____73A9_5BB6ID,
                    "四码",
                    fourCCToStringSafe(____E_6280_80FDID),
                    "实例",
                    _____6280_80FD_5B9E_4F8BID or "-",
                    "标签",
                    "朱雀院椿-E二刀横斩",
                    "目标",
                    GetUnitName(_____654C_4EBA[i + 1]),
                    "handle",
                    _____654C_4EBA[i + 1],
                    "X",
                    math.floor(GetUnitX(_____654C_4EBA[i + 1])),
                    "Y",
                    math.floor(GetUnitY(_____654C_4EBA[i + 1])),
                    "伤害",
                    _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____E_914D_7F6E["二刀追加倍率"]
                )
                _____9020_6210_6280_80FD_4F24_5BB3({
                    ["来源"] = _____65BD_6CD5_8005,
                    ["目标"] = _____654C_4EBA[i + 1],
                    ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____E_914D_7F6E["二刀追加倍率"],
                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                    ["攻击类型"] = ATTACK_TYPE_NORMAL,
                    ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "单位技能",
                    ["技能ID"] = ____E_6280_80FDID,
                    ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                    ["标签"] = "朱雀院椿-E二刀横斩",
                    ["伤害形态"] = "AOE",
                    ["参与技能伤害加成"] = true
                })
                _____521B_5EFA_70B9_7279_6548({
                    ["模型路径"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["命中星爆"]["模型路径"],
                    RGB = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["命中星爆"].RGB,
                    X = GetUnitX(_____654C_4EBA[i + 1]),
                    Y = GetUnitY(_____654C_4EBA[i + 1]),
                    Z = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["命中星爆"]["高度"],
                    ["面向角度"] = _____6570_636E["方向角"],
                    ["缩放"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["命中星爆"]["缩放"],
                    ["持续秒"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["命中星爆"]["持续秒"]
                })
                i = i + 1
            end
        end
    end
    _____8BBE_7F6E_51B3_6597_8DDD_79BB(
        _____65BD_6CD5_8005,
        _____6570_636E["方向角"],
        ____E_914D_7F6E["决斗距离持续秒"],
        _____6570_636E["命中目标"],
        _____6570_636E["目标X"],
        _____6570_636E["目标Y"]
    )
end
local function _____91CA_653EE_95F4_5408(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    if not _____662F_6731_96C0_9662_693F(_____65BD_6CD5_8005) then
        debugLogForce(
            "椿-E",
            "释放被拒",
            "原因",
            "非朱雀院椿",
            "玩家",
            GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
            "四码",
            fourCCToStringSafe(____E_6280_80FDID),
            "实例",
            _____6280_80FD_5B9E_4F8BID or "-"
        )
        return
    end
    debugLogForce(
        "椿-E",
        "释放",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(____E_6280_80FDID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "目标",
        "点施放",
        "X",
        math.floor(GetSpellTargetX()),
        "Y",
        math.floor(GetSpellTargetY())
    )
    if #_____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B(_____65BD_6CD5_8005, "椿E") > 0 then
        debugLogForce(
            "椿-E",
            "释放被拒",
            "原因",
            "已有活跃位移",
            "玩家",
            GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
            "四码",
            fourCCToStringSafe(____E_6280_80FDID),
            "实例",
            _____6280_80FD_5B9E_4F8BID or "-"
        )
        return
    end
    _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD(_____65BD_6CD5_8005, "朱雀院椿", _____6731_96C0_9662_693F_6280_80FD_914D_7F6E.E["技能ID"])
    _____64AD_653E_693F_52A8_4F5C(_____65BD_6CD5_8005, _____6731_96C0_9662_693F_52A8_4F5C_69FD["E冲刺"])
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    local _____53CD_51FB = _____6D88_8D39_53CD_51FB_51C6_5907(_____65BD_6CD5_8005)
    local _____7CBE_786E_56DE_950B = _____53CD_51FB ~= nil
    local _____65B9_5411 = _____4E24_70B9_89D2_5EA6(
        GetUnitX(_____65BD_6CD5_8005),
        GetUnitY(_____65BD_6CD5_8005),
        _____76EE_6807X,
        _____76EE_6807Y
    )
    if _____7CBE_786E_56DE_950B and _____53CD_51FB ~= nil and _____53CD_51FB["来源"] ~= nil and _____53CD_51FB["来源"] ~= 0 and _____5355_4F4D_5B58_6D3B(_____53CD_51FB["来源"]) then
        _____65B9_5411 = _____4E24_70B9_89D2_5EA6(
            GetUnitX(_____65BD_6CD5_8005),
            GetUnitY(_____65BD_6CD5_8005),
            GetUnitX(_____53CD_51FB["来源"]),
            GetUnitY(_____53CD_51FB["来源"])
        )
    end
    if _____7CBE_786E_56DE_950B then
        debugLogForce(
            "椿-E",
            "状态",
            "精确回锋",
            "玩家",
            GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
            "四码",
            fourCCToStringSafe(____E_6280_80FDID),
            "位移方向",
            _____65B9_5411
        )
    end
    local _____7EC8_70B9X = GetUnitX(_____65BD_6CD5_8005) + (_____76EE_6807X - GetUnitX(_____65BD_6CD5_8005))
    local _____7EC8_70B9Y = GetUnitY(_____65BD_6CD5_8005) + (_____76EE_6807Y - GetUnitY(_____65BD_6CD5_8005))
    local _____6570_636E = {
        ["位移ID"] = 0,
        ["已结束"] = false,
        ["已结算"] = false,
        ["终点X"] = _____7EC8_70B9X,
        ["终点Y"] = _____7EC8_70B9Y,
        ["方向角"] = _____65B9_5411,
        ["目标X"] = _____76EE_6807X,
        ["目标Y"] = _____76EE_6807Y,
        ["命中目标"] = nil,
        ["精确回锋"] = _____7CBE_786E_56DE_950B
    }
    debugLogForce(
        "椿-E",
        "状态",
        "创建战斗技能实例",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(____E_6280_80FDID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-"
    )
    local _____63A7_5236_5668 = _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B({
        ["技能键"] = "椿E",
        ["施法者"] = _____65BD_6CD5_8005,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["数据"] = _____6570_636E,
        ["结束回调"] = function(______539F_56E0, _c)
            debugLogForce(
                "椿-E",
                "结束",
                "玩家",
                GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
                "四码",
                fourCCToStringSafe(____E_6280_80FDID),
                "实例",
                _____6280_80FD_5B9E_4F8BID or "-",
                "原因",
                ______539F_56E0 or "-"
            )
            if _____6570_636E["已结束"] then
                return
            end
            _____6570_636E["已结束"] = true
            if _____6570_636E["位移ID"] ~= 0 then
                _____505C_6B62_4F4D_79FB(_____6570_636E["位移ID"], "中断")
                _____6570_636E["位移ID"] = 0
            end
        end
    })
    debugLogForce(
        "椿-E",
        "位移",
        "类型",
        "冲锋",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(____E_6280_80FDID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "距离",
        ____E_914D_7F6E["位移距离"]
    )
    _____6570_636E["位移ID"] = _____5F00_59CB_51B2_950B(
        _____65BD_6CD5_8005,
        {
            ["角度"] = _____65B9_5411,
            ["距离"] = ____E_914D_7F6E["位移距离"],
            ["每秒速度"] = ____E_914D_7F6E["位移速度"],
            ["检查地形"] = true,
            ["朝向跟随位移"] = true,
            ["暂停单位"] = true,
            ["命中半径"] = ____E_914D_7F6E["冲锋命中半径"],
            ["只命中敌人"] = true,
            ["命中后结束"] = false,
            ["允许重复命中"] = false,
            ["命中回调"] = function(______79FB_52A8_5355_4F4D, _____76EE_6807, ______4F4D_79FBID)
                if _____6570_636E["命中目标"] == nil then
                    _____6570_636E["命中目标"] = _____76EE_6807
                    debugLogForce(
                        "椿-E",
                        "状态",
                        "决斗目标记录",
                        "玩家",
                        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
                        "目标",
                        GetUnitName(_____76EE_6807),
                        "handle",
                        _____76EE_6807,
                        "X",
                        math.floor(GetUnitX(_____76EE_6807)),
                        "Y",
                        math.floor(GetUnitY(_____76EE_6807))
                    )
                end
                local _____547D_4E2D_4F24_5BB3 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____E_914D_7F6E["冲锋命中倍率"]
                debugLogForce(
                    "椿-E",
                    "冲锋命中",
                    "玩家",
                    GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
                    "四码",
                    fourCCToStringSafe(____E_6280_80FDID),
                    "实例",
                    _____6280_80FD_5B9E_4F8BID or "-",
                    "目标",
                    GetUnitName(_____76EE_6807),
                    "handle",
                    _____76EE_6807,
                    "X",
                    math.floor(GetUnitX(_____76EE_6807)),
                    "Y",
                    math.floor(GetUnitY(_____76EE_6807)),
                    "伤害",
                    _____547D_4E2D_4F24_5BB3
                )
                _____9020_6210_6280_80FD_4F24_5BB3({
                    ["来源"] = _____65BD_6CD5_8005,
                    ["目标"] = _____76EE_6807,
                    ["伤害"] = _____547D_4E2D_4F24_5BB3,
                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                    ["攻击类型"] = ATTACK_TYPE_NORMAL,
                    ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "单位技能",
                    ["技能ID"] = ____E_6280_80FDID,
                    ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                    ["标签"] = "朱雀院椿-E冲锋命中",
                    ["伤害形态"] = "AOE",
                    ["参与技能伤害加成"] = true
                })
            end,
            ["位移特效"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["E冲锋主层"]["模型路径"][1],
            ["附加位移特效"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["E冲锋主层"]["模型路径"][2],
            ["位移特效缩放"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["E冲锋主层"]["缩放"],
            ["位移特效高度"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["E冲锋主层"]["高度"],
            ["位移特效持续秒"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["E冲锋主层"]["持续秒"],
            ["附加位移特效缩放"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["E冲锋主层"]["缩放"],
            ["附加位移特效高度"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["E冲锋主层"]["高度"],
            ["附加位移特效持续秒"] = _____6731_96C0_9662_693F_8868_73B0_914D_7F6E["E冲锋主层"]["持续秒"],
            ["位移特效面向角度"] = _____65B9_5411,
            ["附加位移特效面向角度"] = _____65B9_5411,
            ["附加位移特效偏移角度"] = _____65B9_5411 + 180,
            ["附加位移特效偏移距离"] = 300,
            ["撞墙回调"] = function(_____79FB_52A8_5355_4F4D, ______4F4D_79FBID)
                _____6570_636E["终点X"] = GetUnitX(_____79FB_52A8_5355_4F4D)
                _____6570_636E["终点Y"] = GetUnitY(_____79FB_52A8_5355_4F4D)
                _____7ED3_7B97E_7EC8_70B9_6A2A_65A9(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
                _____63A7_5236_5668["完成"]()
            end,
            ["结束回调"] = function(_____5355_4F4D, _____539F_56E0, ______4F4D_79FBID)
                if _____6570_636E["已结束"] then
                    return
                end
                local ____debugLogForce_16 = debugLogForce
                local ____array_15 = __TS__SparseArrayNew(
                    "椿-E",
                    "位移结束",
                    "玩家",
                    GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
                    "四码",
                    fourCCToStringSafe(____E_6280_80FDID),
                    "实例",
                    _____6280_80FD_5B9E_4F8BID or "-",
                    "单位",
                    _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and GetUnitName(_____5355_4F4D) or "-",
                    "handle"
                )
                local ____5355_4F4D_14 = _____5355_4F4D
                if ____5355_4F4D_14 == nil then
                    ____5355_4F4D_14 = "-"
                end
                __TS__SparseArrayPush(
                    ____array_15,
                    ____5355_4F4D_14,
                    "X",
                    math.floor(GetUnitX(_____5355_4F4D)),
                    "Y",
                    math.floor(GetUnitY(_____5355_4F4D)),
                    "原因",
                    _____539F_56E0 or "-"
                )
                ____debugLogForce_16(__TS__SparseArraySpread(____array_15))
                local _____843D_70B9X = GetUnitX(_____5355_4F4D)
                local _____843D_70B9Y = GetUnitY(_____5355_4F4D)
                _____6570_636E["终点X"] = _____843D_70B9X
                _____6570_636E["终点Y"] = _____843D_70B9Y
                _____7ED3_7B97E_7EC8_70B9_6A2A_65A9(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
                _____63A7_5236_5668["完成"]()
                local ____ = _____539F_56E0
            end
        }
    )
    if _____6570_636E["位移ID"] ~= 0 then
        Sound3DII_UnitPlayReuse(_____6731_96C0_9662_693F_97F3_6548_914D_7F6E["E冲锋"]["路径"], _____65BD_6CD5_8005, _____6731_96C0_9662_693F_97F3_6548_914D_7F6E["E冲锋"]["裁断距离"])
    end
    _____767B_8BB0_693F_6E05_7406(
        _____65BD_6CD5_8005,
        "椿E",
        function()
            if _____6570_636E["位移ID"] ~= 0 then
                _____505C_6B62_4F4D_79FB(_____6570_636E["位移ID"], "中断")
                _____6570_636E["位移ID"] = 0
            end
        end
    )
end
local _____5DF2_6CE8_518C = false
____exports["注册朱雀院椿E"] = function()
    debugLogForce("椿-E", "注册", "名称", "注册朱雀院椿E")
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "朱雀院椿-刃道·间合（E）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = "ATE1",
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EE_95F4_5408,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 1.5
    })
end
____exports["朱雀院椿E模块"] = {["技能ID"] = _____6731_96C0_9662_693F_6280_80FD_914D_7F6E.E["技能ID"], ["注册"] = ____exports["注册朱雀院椿E"]}
return ____exports
