--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.24．塞莉亚·克莱尔.00．配置")
local _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔技能配置"]
local _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔Q配置"]
local _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔表现配置"]
local _____585E_8389_4E9A_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚音效配置"]
local ____02_FF0E_88AB_52A8_6548_679C = require("系统.03．技能系统.05．单位技能.04．英雄技能.24．塞莉亚·克莱尔.02．被动效果")
local _____6388_4E88_585E_8389_4E9A_6F14_7B97_7A97_53E3 = ____02_FF0E_88AB_52A8_6548_679C["授予塞莉亚演算窗口"]
local _____521B_5EFA_585E_8389_4E9A_8282_70B9 = ____02_FF0E_88AB_52A8_6548_679C["创建塞莉亚节点"]
local _____767B_8BB0_585E_8389_4E9A_6280_80FD_6E05_7406 = ____02_FF0E_88AB_52A8_6548_679C["登记塞莉亚技能清理"]
local _____67E5_8BE2_585E_8389_4E9A_8282_70B9 = ____02_FF0E_88AB_52A8_6548_679C["查询塞莉亚节点"]
local _____67E5_8BE2_585E_8389_4E9A_6709_6548_8FDE_63A5 = ____02_FF0E_88AB_52A8_6548_679C["查询塞莉亚有效连接"]
local ____05_FF0EE_6280_80FD = require("系统.03．技能系统.05．单位技能.04．英雄技能.24．塞莉亚·克莱尔.05．E技能")
local _____67E5_8BE2_585E_8389_4E9A_951A_5B9A_533A_57DF = ____05_FF0EE_6280_80FD["查询塞莉亚锚定区域"]
local _____53D6_585E_8389_4E9A_951A_5B9A_533A_57DF_5185_6700_8FD1_654C_4EBA = ____05_FF0EE_6280_80FD["取塞莉亚锚定区域内最近敌人"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local fourCCToStringSafe = ____require_result_1.fourCCToStringSafe
local GetUnitName = jass.GetUnitName
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local SetUnitFacing = jass.SetUnitFacing
local SquareRoot = jass.SquareRoot
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_3["注册单位技能壳监听"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂")
local _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_4["创建战斗技能实例"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.09．复杂战斗模板.05．弹道编排工厂")
local _____53D1_5C04_5F39_9053 = ____require_result_5["发射弹道"]
local ____require_result_6 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_6["造成技能伤害"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_7["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_7["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_7["两点角度"]
local _____8DDD_79BB_5E73_65B9XY = ____require_result_7["距离平方XY"]
local ____require_result_8 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_8["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_8["移除单位暂停"]
local ____require_result_9 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_CooPlayReuse = ____require_result_9.Sound3DII_CooPlayReuse
local ____require_result_10 = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话")
local _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD = ____require_result_10["播放英雄技能喊话"]
local ____require_result_11 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_11.debugLogForce
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E["单位类型ID"]
local ____Q_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.Q["技能ID"])
local function _____9020_6210Q_4F24_5BB3(_____65BD_6CD5_8005, _____76EE_6807, _____4F24_5BB3_503C, _____6280_80FD_5B9E_4F8BID, _____6807_7B7E, _____5F62_6001)
    return _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = _____65BD_6CD5_8005,
        ["目标"] = _____76EE_6807,
        ["伤害"] = _____4F24_5BB3_503C,
        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____Q_6280_80FD_7C7B_578BID,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["标签"] = _____6807_7B7E,
        ["伤害形态"] = _____5F62_6001,
        ["参与技能伤害加成"] = true
    })
end
--- 真实终点创建棱晶节点：命中与到达两路径共用，只建一次。
local function _____5C1D_8BD5_5EFA_7ACB_7EC8_70B9_8282_70B9(_____65BD_6CD5_8005, _____6570_636E, X, Y)
    if _____6570_636E["已建节点"] then
        return
    end
    _____6570_636E["已建节点"] = true
    _____521B_5EFA_585E_8389_4E9A_8282_70B9(
        _____65BD_6CD5_8005,
        "棱晶",
        X,
        Y,
        _____6570_636E["技能实例ID"]
    )
end
local function _____5904_7406Q_547D_4E2D(_____65BD_6CD5_8005, _____76EE_6807, _____6570_636E)
    if not _____5355_4F4D_5B58_6D3B(_____76EE_6807) then
        debugLogForce(
            "塞莉亚-Q",
            "命中失败",
            "目标无效",
            "玩家",
            GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
            "handle",
            _____76EE_6807
        )
        return
    end
    local X = GetUnitX(_____76EE_6807)
    local Y = GetUnitY(_____76EE_6807)
    local _____4F24_5BB3 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["主伤害攻击力倍率"]
    local ____debugLogForce_15 = debugLogForce
    local ____temp_13 = GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1
    local ____fourCCToStringSafe_result_14 = fourCCToStringSafe(____Q_6280_80FD_7C7B_578BID)
    local ____6570_636E__6280_80FD_5B9E_4F8BID_12 = _____6570_636E["技能实例ID"]
    if ____6570_636E__6280_80FD_5B9E_4F8BID_12 == nil then
        ____6570_636E__6280_80FD_5B9E_4F8BID_12 = "-"
    end
    ____debugLogForce_15(
        "塞莉亚-Q",
        "命中",
        "玩家",
        ____temp_13,
        "四码",
        ____fourCCToStringSafe_result_14,
        "实例",
        ____6570_636E__6280_80FD_5B9E_4F8BID_12,
        "目标",
        GetUnitName(_____76EE_6807),
        "handle",
        _____76EE_6807,
        "X",
        math.floor(X),
        "Y",
        math.floor(Y),
        "伤害",
        _____4F24_5BB3
    )
    _____9020_6210Q_4F24_5BB3(
        _____65BD_6CD5_8005,
        _____76EE_6807,
        _____4F24_5BB3,
        _____6570_636E["技能实例ID"],
        "塞莉亚-棱晶魔弹",
        "单体"
    )
    _____5C1D_8BD5_5EFA_7ACB_7EC8_70B9_8282_70B9(_____65BD_6CD5_8005, _____6570_636E, X, Y)
end
--- 折射：本次方向 d 与节点径向 n 的镜像反射 r = d − 2(d·n)n，
-- 从节点位置沿 r 追加一枚折射弹（每次 Q 最多一次）。
local function _____5C1D_8BD5_68F1_6676_6298_5C04(_____65BD_6CD5_8005, _____6570_636E, _____5F53_524DX, _____5F53_524DY)
    if _____6570_636E["已读折射"] or not _____6570_636E["有方向向量"] then
        return
    end
    local _____8282_70B9_5217_8868 = _____67E5_8BE2_585E_8389_4E9A_8282_70B9(_____65BD_6CD5_8005)
    do
        local i = 0
        while i < #_____8282_70B9_5217_8868 do
            do
                local _____8282_70B9 = _____8282_70B9_5217_8868[i + 1]
                if _____8282_70B9["类型"] ~= "棱晶" then
                    goto __continue10
                end
                if _____8DDD_79BB_5E73_65B9XY(_____5F53_524DX, _____5F53_524DY, _____8282_70B9.X, _____8282_70B9.Y) > _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["折射触发半径"] * _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["折射触发半径"] then
                    goto __continue10
                end
                _____6570_636E["已读折射"] = true
                local nx = _____5F53_524DX - _____8282_70B9.X
                local ny = _____5F53_524DY - _____8282_70B9.Y
                local nl = SquareRoot(nx * nx + ny * ny)
                if nl <= 1 then
                    return
                end
                nx = nx / nl
                ny = ny / nl
                local dot = _____6570_636E.dirX * nx + _____6570_636E.dirY * ny
                local rx = _____6570_636E.dirX - 2 * dot * nx
                local ry = _____6570_636E.dirY - 2 * dot * ny
                local rl = SquareRoot(rx * rx + ry * ry)
                if rl <= 1 then
                    return
                end
                rx = rx / rl
                ry = ry / rl
                _____53D1_5C04_5F39_9053({
                    ["名称"] = "塞莉亚-棱晶折射",
                    ["所有者"] = _____65BD_6CD5_8005,
                    ["发射X"] = _____8282_70B9.X,
                    ["发射Y"] = _____8282_70B9.Y,
                    ["发射方向角"] = _____4E24_70B9_89D2_5EA6(0, 0, rx, ry),
                    ["速度"] = _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["弹道速度"],
                    ["轨迹"] = {["类型"] = "直线", ["距离"] = _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["最大距离"]},
                    ["命中半径"] = _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["命中半径"],
                    ["飞行高度"] = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["Q弹道"]["高度"],
                    ["影响目标"] = "敌方",
                    ["碰撞消失"] = true,
                    ["每单位最大命中次数"] = 1,
                    ["伤害值"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["折射伤害攻击力倍率"],
                    ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                    ["攻击类型"] = ATTACK_TYPE_NORMAL,
                    ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "单位技能",
                    ["技能ID"] = ____Q_6280_80FD_7C7B_578BID,
                    ["技能实例ID"] = _____6570_636E["技能实例ID"],
                    ["技能标签"] = "塞莉亚-棱晶折射",
                    ["伤害形态"] = "单体",
                    ["参与技能伤害加成"] = false,
                    ["模型"] = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["Q弹道"]["模型路径"],
                    RGB = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["Q弹道"].RGB,
                    ["缩放"] = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["Q弹道"]["缩放"]
                })
                Sound3DII_CooPlayReuse(
                    _____585E_8389_4E9A_97F3_6548_914D_7F6E["Q折射"]["路径"],
                    _____8282_70B9.X,
                    _____8282_70B9.Y,
                    _____585E_8389_4E9A_97F3_6548_914D_7F6E["Q折射"]["高度"],
                    _____585E_8389_4E9A_97F3_6548_914D_7F6E["Q折射"]["裁断距离"]
                )
                return
            end
            ::__continue10::
            i = i + 1
        end
    end
end
--- 棱晶+结界连接 → 穿透追加（每次 Q 最多一次）。
local function _____5C1D_8BD5_7A7F_900F_8FFD_52A0(_____65BD_6CD5_8005, _____6570_636E)
    if _____6570_636E["已读穿透"] then
        return
    end
    local _____8FDE_63A5 = _____67E5_8BE2_585E_8389_4E9A_6709_6548_8FDE_63A5(_____65BD_6CD5_8005)
    if _____8FDE_63A5 == nil or not _____8FDE_63A5["可读取"] then
        return
    end
    local _____6709_68F1_6676 = _____8FDE_63A5["A类型"] == "棱晶" or _____8FDE_63A5["B类型"] == "棱晶"
    local _____6709_7ED3_754C = _____8FDE_63A5["A类型"] == "结界" or _____8FDE_63A5["B类型"] == "结界"
    if not _____6709_68F1_6676 or not _____6709_7ED3_754C then
        return
    end
    _____6570_636E["已读穿透"] = true
    _____53D1_5C04_5F39_9053({
        ["名称"] = "塞莉亚-棱晶·解析穿透",
        ["所有者"] = _____65BD_6CD5_8005,
        ["发射X"] = _____6570_636E["发射X"],
        ["发射Y"] = _____6570_636E["发射Y"],
        ["发射方向角"] = _____6570_636E["方向角"],
        ["速度"] = _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["弹道速度"],
        ["轨迹"] = {["类型"] = "直线", ["距离"] = _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["棱晶结界穿透距离"]},
        ["命中半径"] = _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["命中半径"],
        ["飞行高度"] = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["Q弹道"]["高度"],
        ["影响目标"] = "敌方",
        ["碰撞消失"] = false,
        ["每单位最大命中次数"] = 1,
        ["最大总命中次数"] = _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["棱晶结界最大命中数"],
        ["伤害值"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["棱晶结界穿透倍率"],
        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____Q_6280_80FD_7C7B_578BID,
        ["技能实例ID"] = _____6570_636E["技能实例ID"],
        ["技能标签"] = "塞莉亚-棱晶·解析穿透",
        ["伤害形态"] = "AOE",
        ["参与技能伤害加成"] = false,
        ["模型"] = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["Q弹道"]["模型路径"],
        RGB = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["Q弹道"].RGB,
        ["缩放"] = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["Q弹道"]["缩放"]
    })
end
--- 棱晶+锚定连接 → 对锚定阵内最近敌人发射短追踪追迹弹（每次 Q 最多一次）。
local function _____5C1D_8BD5_951A_5B9A_8FFD_8FF9(_____65BD_6CD5_8005, _____6570_636E)
    if _____6570_636E["已读追迹"] then
        return
    end
    local _____8FDE_63A5 = _____67E5_8BE2_585E_8389_4E9A_6709_6548_8FDE_63A5(_____65BD_6CD5_8005)
    if _____8FDE_63A5 == nil or not _____8FDE_63A5["可读取"] then
        return
    end
    local _____6709_68F1_6676 = _____8FDE_63A5["A类型"] == "棱晶" or _____8FDE_63A5["B类型"] == "棱晶"
    local _____6709_951A_5B9A = _____8FDE_63A5["A类型"] == "锚定" or _____8FDE_63A5["B类型"] == "锚定"
    if not _____6709_68F1_6676 or not _____6709_951A_5B9A then
        return
    end
    local _____533A_57DF = _____67E5_8BE2_585E_8389_4E9A_951A_5B9A_533A_57DF(_____65BD_6CD5_8005)
    if _____533A_57DF == nil then
        return
    end
    local _____6700_8FD1_654C_4EBA = _____53D6_585E_8389_4E9A_951A_5B9A_533A_57DF_5185_6700_8FD1_654C_4EBA(_____65BD_6CD5_8005, _____533A_57DF.X, _____533A_57DF.Y, _____533A_57DF["半径"])
    if _____6700_8FD1_654C_4EBA == nil then
        return
    end
    _____6570_636E["已读追迹"] = true
    _____53D1_5C04_5F39_9053({
        ["名称"] = "塞莉亚-棱晶·锚定追迹",
        ["所有者"] = _____65BD_6CD5_8005,
        ["发射X"] = _____6570_636E["最后已知X"],
        ["发射Y"] = _____6570_636E["最后已知Y"],
        ["发射方向角"] = _____6570_636E["方向角"],
        ["速度"] = _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["弹道速度"],
        ["轨迹"] = {["类型"] = "追踪", ["目标"] = _____6700_8FD1_654C_4EBA, ["追踪转向速度"] = _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["锚定追迹转向速度"], ["追踪保持秒"] = _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["锚定追迹保持秒"]},
        ["命中半径"] = _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["命中半径"],
        ["飞行高度"] = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["Q弹道"]["高度"],
        ["影响目标"] = "敌方",
        ["碰撞消失"] = true,
        ["每单位最大命中次数"] = 1,
        ["伤害值"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["锚定追迹倍率"],
        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____Q_6280_80FD_7C7B_578BID,
        ["技能实例ID"] = _____6570_636E["技能实例ID"],
        ["技能标签"] = "塞莉亚-棱晶·锚定追迹",
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = false,
        ["模型"] = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["Q弹道"]["模型路径"],
        RGB = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["Q弹道"].RGB,
        ["缩放"] = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["Q弹道"]["缩放"]
    })
end
local function _____91CA_653EQ_68F1_6676_9B54_5F39(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        return
    end
    local _____76EE_6807_5355_4F4D = GetSpellTargetUnit()
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    local _____6709_76EE_6807 = _____76EE_6807_5355_4F4D ~= nil and _____76EE_6807_5355_4F4D ~= 0 and _____5355_4F4D_5B58_6D3B(_____76EE_6807_5355_4F4D)
    if _____6709_76EE_6807 and _____76EE_6807X == 0 and _____76EE_6807Y == 0 then
        _____76EE_6807X = GetUnitX(_____76EE_6807_5355_4F4D)
        _____76EE_6807Y = GetUnitY(_____76EE_6807_5355_4F4D)
    end
    debugLogForce(
        "塞莉亚-Q",
        "释放",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(____Q_6280_80FD_7C7B_578BID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "目标",
        _____6709_76EE_6807 and GetUnitName(_____76EE_6807_5355_4F4D) or "点施放",
        "X",
        math.floor(_____76EE_6807X),
        "Y",
        math.floor(_____76EE_6807Y)
    )
    local _____6570_636E = {
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["已建节点"] = false,
        ["已读折射"] = false,
        ["已读穿透"] = false,
        ["已读追迹"] = false,
        ["方向角"] = _____4E24_70B9_89D2_5EA6(
            GetUnitX(_____65BD_6CD5_8005),
            GetUnitY(_____65BD_6CD5_8005),
            _____76EE_6807X,
            _____76EE_6807Y
        ),
        dirX = 0,
        dirY = 0,
        ["有方向向量"] = false,
        ["发射X"] = GetUnitX(_____65BD_6CD5_8005),
        ["发射Y"] = GetUnitY(_____65BD_6CD5_8005),
        ["最后已知X"] = GetUnitX(_____65BD_6CD5_8005),
        ["最后已知Y"] = GetUnitY(_____65BD_6CD5_8005)
    }
    local ____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B_18 = _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B
    local ____65BD_6CD5_8005_17 = _____65BD_6CD5_8005
    local _____6709_76EE_6807_16
    if _____6709_76EE_6807 then
        _____6709_76EE_6807_16 = _____76EE_6807_5355_4F4D
    else
        _____6709_76EE_6807_16 = nil
    end
    local _____5B9E_4F8B = ____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B_18({
        ["技能键"] = "Q棱晶魔弹",
        ["施法者"] = ____65BD_6CD5_8005_17,
        ["目标"] = _____6709_76EE_6807_16,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["数据"] = _____6570_636E,
        ["结束回调"] = function(______539F_56E0, ______63A7_5236_5668)
            debugLogForce(
                "塞莉亚-Q",
                "结束",
                "玩家",
                GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
                "四码",
                fourCCToStringSafe(____Q_6280_80FD_7C7B_578BID),
                "原因",
                ______539F_56E0
            )
            local ____ = ______539F_56E0
            local ____ = ______63A7_5236_5668
        end
    })
    _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD(_____65BD_6CD5_8005, "塞莉亚·克莱尔", _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.Q["技能ID"])
    local _____786C_76F4_6765_6E90 = "塞莉亚-Q硬直"
    if _____6DFB_52A0_5355_4F4D_6682_505C(_____65BD_6CD5_8005, _____786C_76F4_6765_6E90) then
        SetUnitFacing(_____65BD_6CD5_8005, _____6570_636E["方向角"])
    end
    _____5B9E_4F8B["登记延迟回调"](
        _____5B9E_4F8B,
        addDelayedCallback(
            _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["硬直秒"] * 1000,
            function()
                _____79FB_9664_5355_4F4D_6682_505C(_____65BD_6CD5_8005, _____786C_76F4_6765_6E90)
            end
        )
    )
    _____5B9E_4F8B["登记延迟回调"](
        _____5B9E_4F8B,
        addDelayedCallback(
            _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["发射延迟秒"] * 1000,
            function()
                if _____5B9E_4F8B["已结束"](_____5B9E_4F8B) then
                    return
                end
                if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
                    return
                end
                local dx = _____76EE_6807X - _____6570_636E["发射X"]
                local dy = _____76EE_6807Y - _____6570_636E["发射Y"]
                local dl = SquareRoot(dx * dx + dy * dy)
                if dl > 1 then
                    _____6570_636E.dirX = dx / dl
                    _____6570_636E.dirY = dy / dl
                    _____6570_636E["有方向向量"] = true
                end
                local _____53D1_5C04_65F6_76EE_6807_6709_6548 = _____6709_76EE_6807 and _____5355_4F4D_5B58_6D3B(_____76EE_6807_5355_4F4D)
                local _____5F39_9053 = _____53D1_5C04_5F39_9053({
                    ["名称"] = "塞莉亚-棱晶魔弹",
                    ["所有者"] = _____65BD_6CD5_8005,
                    ["发射X"] = _____6570_636E["发射X"],
                    ["发射Y"] = _____6570_636E["发射Y"],
                    ["发射方向角"] = _____6570_636E["方向角"],
                    ["速度"] = _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["弹道速度"],
                    ["轨迹"] = _____53D1_5C04_65F6_76EE_6807_6709_6548 and ({["类型"] = "追踪", ["目标"] = _____76EE_6807_5355_4F4D, ["追踪转向速度"] = _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["追踪转向速度"], ["追踪保持秒"] = _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["追踪保持秒"]}) or ({["类型"] = "直线", ["距离"] = _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["最大距离"]}),
                    ["命中半径"] = _____585E_8389_4E9A_514B_83B1_5C14Q_914D_7F6E["命中半径"],
                    ["飞行高度"] = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["Q弹道"]["高度"],
                    ["影响目标"] = "敌方",
                    ["碰撞消失"] = true,
                    ["每单位最大命中次数"] = 1,
                    ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                    ["来源类型"] = "单位技能",
                    ["技能ID"] = ____Q_6280_80FD_7C7B_578BID,
                    ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                    ["技能标签"] = "塞莉亚-棱晶魔弹",
                    ["伤害形态"] = "单体",
                    ["参与技能伤害加成"] = true,
                    ["模型"] = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["Q弹道"]["模型路径"],
                    RGB = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["Q弹道"].RGB,
                    ["缩放"] = _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["Q弹道"]["缩放"],
                    ["on命中"] = function(_____547D_4E2D_76EE_6807, ______5F39_5E55ID)
                        if not _____5B9E_4F8B["仍有效"](_____5B9E_4F8B) then
                            return
                        end
                        _____5904_7406Q_547D_4E2D(_____65BD_6CD5_8005, _____547D_4E2D_76EE_6807, _____6570_636E)
                    end,
                    onTick = function(_____5F39_5E55_5B9E_4F8B, _delta)
                        if not _____5B9E_4F8B["仍有效"](_____5B9E_4F8B) or _____5F39_5E55_5B9E_4F8B == nil then
                            return
                        end
                        _____6570_636E["最后已知X"] = _____5F39_5E55_5B9E_4F8B["当前X"]
                        _____6570_636E["最后已知Y"] = _____5F39_5E55_5B9E_4F8B["当前Y"]
                        _____5C1D_8BD5_68F1_6676_6298_5C04(_____65BD_6CD5_8005, _____6570_636E, _____5F39_5E55_5B9E_4F8B["当前X"], _____5F39_5E55_5B9E_4F8B["当前Y"])
                        _____5C1D_8BD5_7A7F_900F_8FFD_52A0(_____65BD_6CD5_8005, _____6570_636E)
                        _____5C1D_8BD5_951A_5B9A_8FFD_8FF9(_____65BD_6CD5_8005, _____6570_636E)
                    end,
                    ["on到达点"] = function(______5F39_5E55ID, ______539F_56E0)
                        if not _____5B9E_4F8B["仍有效"](_____5B9E_4F8B) then
                            return
                        end
                        _____5C1D_8BD5_5EFA_7ACB_7EC8_70B9_8282_70B9(_____65BD_6CD5_8005, _____6570_636E, _____6570_636E["最后已知X"], _____6570_636E["最后已知Y"])
                    end
                })
                local ____ = _____5F39_9053
                Sound3DII_CooPlayReuse(
                    _____585E_8389_4E9A_97F3_6548_914D_7F6E["Q发射"]["路径"],
                    GetUnitX(_____65BD_6CD5_8005),
                    GetUnitY(_____65BD_6CD5_8005),
                    _____585E_8389_4E9A_97F3_6548_914D_7F6E["Q发射"]["高度"],
                    _____585E_8389_4E9A_97F3_6548_914D_7F6E["Q发射"]["裁断距离"]
                )
                _____6388_4E88_585E_8389_4E9A_6F14_7B97_7A97_53E3(_____65BD_6CD5_8005)
                local _____6CE8_9500 = _____767B_8BB0_585E_8389_4E9A_6280_80FD_6E05_7406(
                    _____65BD_6CD5_8005,
                    "Q弹道-" .. tostring(_____6280_80FD_5B9E_4F8BID or 0),
                    function()
                        if _____5F39_9053 ~= nil and not _____5F39_9053["已中断"](_____5F39_9053) then
                            _____5F39_9053["中断"](_____5F39_9053)
                        end
                    end
                )
                local ____ = _____6CE8_9500
            end
        )
    )
end
local _____5DF2_6CE8_518C = false
____exports["注册塞莉亚Q"] = function()
    debugLogForce("塞莉亚-Q", "注册", "名称", "注册塞莉亚Q")
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "塞莉亚·克莱尔-棱晶魔弹（Q）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.Q["技能ID"],
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EQ_68F1_6676_9B54_5F39,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 6
    })
end
return ____exports
