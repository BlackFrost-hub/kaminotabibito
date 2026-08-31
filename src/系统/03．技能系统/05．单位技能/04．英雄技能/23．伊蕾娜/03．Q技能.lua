--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.23．伊蕾娜.00．配置")
local _____4F0A_857E_5A1C_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜技能配置"]
local _____4F0A_857E_5A1CQ_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜Q配置"]
local _____4F0A_857E_5A1C_53D8_5F0F_6548_679C_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜变式效果配置"]
local _____4F0A_857E_5A1C_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜表现配置"]
local _____4F0A_857E_5A1C_6A21_578B_52A8_4F5C_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜模型动作配置"]
local _____4F0A_857E_5A1C_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["伊蕾娜音效配置"]
local ____01A_FF0E_52A8_4F5C_8868_73B0 = require("系统.03．技能系统.05．单位技能.04．英雄技能.23．伊蕾娜.01A．动作表现")
local _____64AD_653E_4F0A_857E_5A1C_9636_6BB5_52A8_4F5C = ____01A_FF0E_52A8_4F5C_8868_73B0["播放伊蕾娜阶段动作"]
local ____02_FF0E_88AB_52A8_6548_679C = require("系统.03．技能系统.05．单位技能.04．英雄技能.23．伊蕾娜.02．被动效果")
local _____8BB0_5F55_4F0A_857E_5A1C_89C1_95FB = ____02_FF0E_88AB_52A8_6548_679C["记录伊蕾娜见闻"]
local _____83B7_53D6_4F0A_857E_5A1C_53D8_5F0F = ____02_FF0E_88AB_52A8_6548_679C["获取伊蕾娜变式"]
local _____6D88_8D39_4F0A_857E_5A1C_53D8_5F0F_7528_4E8E = ____02_FF0E_88AB_52A8_6548_679C["消费伊蕾娜变式用于"]
local _____767B_8BB0_4F0A_857E_5A1C_6280_80FD_6E05_7406 = ____02_FF0E_88AB_52A8_6548_679C["登记伊蕾娜技能清理"]
local _____8BFB_53D6_4F0A_857E_5A1C_626B_5E1A_8DEF_7EBF = ____02_FF0E_88AB_52A8_6548_679C["读取伊蕾娜扫帚路线"]
local ____04_FF0EW_6280_80FD = require("系统.03．技能系统.05．单位技能.04．英雄技能.23．伊蕾娜.04．W技能")
local _____67E5_8BE2_4F0A_857E_5A1CW_6298_5C04_53EF_7528 = ____04_FF0EW_6280_80FD["查询伊蕾娜W折射可用"]
local _____6D88_8D39_4F0A_857E_5A1CW_6298_5C04 = ____04_FF0EW_6280_80FD["消费伊蕾娜W折射"]
local ____require_result_0 = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话")
local _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD = ____require_result_0["播放英雄技能喊话"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local SetUnitFacing = jass.SetUnitFacing
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_2["注册单位技能壳监听"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂")
local _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_3["创建战斗技能实例"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.09．复杂战斗模板.05．弹道编排工厂")
local _____53D1_5C04_5F39_9053 = ____require_result_4["发射弹道"]
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_5["造成技能伤害"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_6["读取单位攻击力"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_6["两点角度"]
local _____5355_4F4D_5B58_6D3B = ____require_result_6["单位存活"]
local _____8DDD_79BB_5E73_65B9XY = ____require_result_6["距离平方XY"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围")
local _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA = ____require_result_7["获取坐标范围敌人"]
local ____require_result_8 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_8["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_8["移除单位暂停"]
local ____require_result_9 = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口")
local SFB_setSlow = ____require_result_9.SFB_setSlow
local ____require_result_10 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_CooPlayReuse = ____require_result_10.Sound3DII_CooPlayReuse
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____4F0A_857E_5A1C_6280_80FD_914D_7F6E["单位类型ID"]
local ____Q_6280_80FD_7C7B_578BID = jass.FourCC(_____4F0A_857E_5A1C_6280_80FD_914D_7F6E.Q["技能ID"])
local function _____9020_6210Q_6280_80FD_4F24_5BB3(_____65BD_6CD5_8005, _____76EE_6807, _____4F24_5BB3_503C, _____6280_80FD_5B9E_4F8BID, _____6807_7B7E, _____5F62_6001)
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
--- 命中共用：主伤害 + 追迹减速 + 风行见闻 + 灰烬爆发（按需）。
local function _____5904_7406Q_547D_4E2D(_____65BD_6CD5_8005, _____76EE_6807, _____6570_636E)
    if not _____5355_4F4D_5B58_6D3B(_____76EE_6807) then
        return
    end
    local _____4F24_5BB3 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____4F0A_857E_5A1CQ_914D_7F6E["主伤害攻击力倍率"]
    _____9020_6210Q_6280_80FD_4F24_5BB3(
        _____65BD_6CD5_8005,
        _____76EE_6807,
        _____4F24_5BB3,
        _____6570_636E["技能实例ID"],
        "伊蕾娜-旅风·追迹",
        "单体"
    )
    SFB_setSlow(
        _____65BD_6CD5_8005,
        _____76EE_6807,
        0,
        _____4F0A_857E_5A1CQ_914D_7F6E["追迹减速比例"],
        _____4F0A_857E_5A1CQ_914D_7F6E["追迹减速秒"],
        "伊蕾娜-追迹标记",
        "技能"
    )
    Sound3DII_CooPlayReuse(
        _____4F0A_857E_5A1C_97F3_6548_914D_7F6E["Q命中"]["路径"],
        GetUnitX(_____76EE_6807),
        GetUnitY(_____76EE_6807),
        _____4F0A_857E_5A1C_97F3_6548_914D_7F6E["Q命中"]["高度"],
        _____4F0A_857E_5A1C_97F3_6548_914D_7F6E["Q命中"]["裁断距离"]
    )
    _____8BB0_5F55_4F0A_857E_5A1C_89C1_95FB(_____65BD_6CD5_8005, "风行", _____6570_636E["技能实例ID"])
    if _____6570_636E["灰烬爆发"] and _____4F0A_857E_5A1C_53D8_5F0F_6548_679C_914D_7F6E["灰烬_爆发半径"] > 0 then
        local _____654C_4EBA_5217_8868 = _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA(
            _____65BD_6CD5_8005,
            GetUnitX(_____76EE_6807),
            GetUnitY(_____76EE_6807),
            _____4F0A_857E_5A1C_53D8_5F0F_6548_679C_914D_7F6E["灰烬_爆发半径"]
        )
        local _____7206_53D1_4F24_5BB3 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____4F0A_857E_5A1C_53D8_5F0F_6548_679C_914D_7F6E["灰烬_爆发伤害攻击力倍率"]
        do
            local i = 0
            while i < #_____654C_4EBA_5217_8868 do
                do
                    local _____654C_4EBA = _____654C_4EBA_5217_8868[i + 1]
                    if not _____5355_4F4D_5B58_6D3B(_____654C_4EBA) then
                        goto __continue7
                    end
                    _____9020_6210Q_6280_80FD_4F24_5BB3(
                        _____65BD_6CD5_8005,
                        _____654C_4EBA,
                        _____7206_53D1_4F24_5BB3,
                        _____6570_636E["技能实例ID"],
                        "伊蕾娜-灰烬爆发",
                        "AOE"
                    )
                end
                ::__continue7::
                i = i + 1
            end
        end
    end
end
--- W 折射联动：从结界当前位置向快照目标点追加一枚折射魔弹。
local function _____5C1D_8BD5W_6298_5C04_8054_52A8(_____65BD_6CD5_8005, _____6570_636E)
    if _____6570_636E["已读W折射"] then
        return
    end
    if not _____67E5_8BE2_4F0A_857E_5A1CW_6298_5C04_53EF_7528(_____65BD_6CD5_8005) then
        return
    end
    if not _____6D88_8D39_4F0A_857E_5A1CW_6298_5C04(_____65BD_6CD5_8005) then
        return
    end
    _____6570_636E["已读W折射"] = true
    _____53D1_5C04_5F39_9053({
        ["名称"] = "伊蕾娜-旅风·折射",
        ["所有者"] = _____65BD_6CD5_8005,
        ["发射X"] = GetUnitX(_____65BD_6CD5_8005),
        ["发射Y"] = GetUnitY(_____65BD_6CD5_8005),
        ["发射方向角"] = _____4E24_70B9_89D2_5EA6(
            GetUnitX(_____65BD_6CD5_8005),
            GetUnitY(_____65BD_6CD5_8005),
            _____6570_636E["目标X"],
            _____6570_636E["目标Y"]
        ),
        ["速度"] = _____4F0A_857E_5A1CQ_914D_7F6E["折射弹速度"],
        ["轨迹"] = {["类型"] = "直线", ["距离"] = _____4F0A_857E_5A1CQ_914D_7F6E["最大距离"]},
        ["命中半径"] = _____4F0A_857E_5A1CQ_914D_7F6E["命中半径"],
        ["影响目标"] = "敌方",
        ["碰撞消失"] = true,
        ["每单位最大命中次数"] = 1,
        ["伤害值"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____4F0A_857E_5A1CQ_914D_7F6E["折射伤害攻击力倍率"],
        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____Q_6280_80FD_7C7B_578BID,
        ["技能实例ID"] = _____6570_636E["技能实例ID"],
        ["技能标签"] = "伊蕾娜-旅风·折射",
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = false,
        ["模型"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q联动弹道"]["模型路径"],
        RGB = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q联动弹道"].RGB,
        ["缩放"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q联动弹道"]["缩放"],
        ["飞行高度"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q联动弹道"]["高度"],
        ["生命周期"] = _____4F0A_857E_5A1CQ_914D_7F6E["最大距离"] / _____4F0A_857E_5A1CQ_914D_7F6E["折射弹速度"] + 0.5
    })
end
--- E 路线联动：穿越扫帚路线时从当前点追加一枚风径魔弹。
local function _____5C1D_8BD5E_8DEF_7EBF_8FFD_52A0(_____65BD_6CD5_8005, _____6570_636E, _____5F53_524DX, _____5F53_524DY)
    if _____6570_636E["已读E路线"] then
        return
    end
    local _____8DEF_7EBF = _____8BFB_53D6_4F0A_857E_5A1C_626B_5E1A_8DEF_7EBF(_____65BD_6CD5_8005)
    if _____8DEF_7EBF == nil then
        return
    end
    local _____6BB5_957F_5E73_65B9 = _____8DDD_79BB_5E73_65B9XY(_____8DEF_7EBF["起点X"], _____8DEF_7EBF["起点Y"], _____8DEF_7EBF["终点X"], _____8DEF_7EBF["终点Y"])
    local _____5728_8DEF_7EBF_4E0A = false
    if _____6BB5_957F_5E73_65B9 <= 1 then
        _____5728_8DEF_7EBF_4E0A = _____8DDD_79BB_5E73_65B9XY(_____5F53_524DX, _____5F53_524DY, _____8DEF_7EBF["起点X"], _____8DEF_7EBF["起点Y"]) <= _____4F0A_857E_5A1CQ_914D_7F6E["路线判定半径"] * _____4F0A_857E_5A1CQ_914D_7F6E["路线判定半径"]
    else
        local t = ((_____5F53_524DX - _____8DEF_7EBF["起点X"]) * (_____8DEF_7EBF["终点X"] - _____8DEF_7EBF["起点X"]) + (_____5F53_524DY - _____8DEF_7EBF["起点Y"]) * (_____8DEF_7EBF["终点Y"] - _____8DEF_7EBF["起点Y"])) / _____6BB5_957F_5E73_65B9
        local _____622A_53D6 = t < 0 and 0 or (t > 1 and 1 or t)
        local _____6295_5F71X = _____8DEF_7EBF["起点X"] + (_____8DEF_7EBF["终点X"] - _____8DEF_7EBF["起点X"]) * _____622A_53D6
        local _____6295_5F71Y = _____8DEF_7EBF["起点Y"] + (_____8DEF_7EBF["终点Y"] - _____8DEF_7EBF["起点Y"]) * _____622A_53D6
        _____5728_8DEF_7EBF_4E0A = _____8DDD_79BB_5E73_65B9XY(_____5F53_524DX, _____5F53_524DY, _____6295_5F71X, _____6295_5F71Y) <= _____4F0A_857E_5A1CQ_914D_7F6E["路线判定半径"] * _____4F0A_857E_5A1CQ_914D_7F6E["路线判定半径"]
    end
    if not _____5728_8DEF_7EBF_4E0A then
        return
    end
    _____6570_636E["已读E路线"] = true
    _____53D1_5C04_5F39_9053({
        ["名称"] = "伊蕾娜-旅风·风径",
        ["所有者"] = _____65BD_6CD5_8005,
        ["发射X"] = _____5F53_524DX,
        ["发射Y"] = _____5F53_524DY,
        ["发射方向角"] = _____8DEF_7EBF["方向角"],
        ["速度"] = _____4F0A_857E_5A1CQ_914D_7F6E["弹道速度"],
        ["轨迹"] = {["类型"] = "直线", ["距离"] = _____4F0A_857E_5A1CQ_914D_7F6E["最大距离"]},
        ["命中半径"] = _____4F0A_857E_5A1CQ_914D_7F6E["命中半径"],
        ["影响目标"] = "敌方",
        ["碰撞消失"] = true,
        ["每单位最大命中次数"] = 1,
        ["伤害值"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____4F0A_857E_5A1CQ_914D_7F6E["路线追加伤害攻击力倍率"],
        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____Q_6280_80FD_7C7B_578BID,
        ["技能实例ID"] = _____6570_636E["技能实例ID"],
        ["技能标签"] = "伊蕾娜-旅风·风径",
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = false,
        ["模型"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q联动弹道"]["模型路径"],
        RGB = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q联动弹道"].RGB,
        ["缩放"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q联动弹道"]["缩放"],
        ["飞行高度"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q联动弹道"]["高度"],
        ["生命周期"] = _____4F0A_857E_5A1CQ_914D_7F6E["最大距离"] / _____4F0A_857E_5A1CQ_914D_7F6E["弹道速度"] + 0.5
    })
end
local function _____91CA_653EQ_65C5_98CE_8FFD_8FF9(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        return
    end
    _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD(_____65BD_6CD5_8005, "伊蕾娜", _____4F0A_857E_5A1C_6280_80FD_914D_7F6E.Q["技能ID"])
    local _____76EE_6807_5355_4F4D = GetSpellTargetUnit()
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    local _____6709_76EE_6807 = _____76EE_6807_5355_4F4D ~= nil and _____76EE_6807_5355_4F4D ~= 0 and _____5355_4F4D_5B58_6D3B(_____76EE_6807_5355_4F4D)
    if _____6709_76EE_6807 and _____76EE_6807X == 0 and _____76EE_6807Y == 0 then
        _____76EE_6807X = GetUnitX(_____76EE_6807_5355_4F4D)
        _____76EE_6807Y = GetUnitY(_____76EE_6807_5355_4F4D)
    end
    local _____786C_76F4_6765_6E90 = "伊蕾娜-Q硬直"
    local _____6570_636E = {
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["目标X"] = _____76EE_6807X,
        ["目标Y"] = _____76EE_6807Y,
        ["已读W折射"] = false,
        ["已读E路线"] = false,
        ["灰烬爆发"] = false
    }
    local function _____6CE8_9500_7EDF_4E00_6E05_7406()
    end
    local ____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B_13 = _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B
    local ____65BD_6CD5_8005_12 = _____65BD_6CD5_8005
    local _____6709_76EE_6807_11
    if _____6709_76EE_6807 then
        _____6709_76EE_6807_11 = _____76EE_6807_5355_4F4D
    else
        _____6709_76EE_6807_11 = nil
    end
    local _____5B9E_4F8B = ____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B_13({
        ["技能键"] = "Q旅风追迹",
        ["施法者"] = ____65BD_6CD5_8005_12,
        ["目标"] = _____6709_76EE_6807_11,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["数据"] = _____6570_636E,
        ["结束回调"] = function(______539F_56E0, ______63A7_5236_5668)
            _____79FB_9664_5355_4F4D_6682_505C(_____65BD_6CD5_8005, _____786C_76F4_6765_6E90)
            _____6CE8_9500_7EDF_4E00_6E05_7406()
        end
    })
    _____6CE8_9500_7EDF_4E00_6E05_7406 = _____767B_8BB0_4F0A_857E_5A1C_6280_80FD_6E05_7406(
        _____65BD_6CD5_8005,
        "Q弹道-" .. tostring(_____5B9E_4F8B["实例ID"]),
        function()
            if not _____5B9E_4F8B["已结束"](_____5B9E_4F8B) then
                _____5B9E_4F8B["结束"](_____5B9E_4F8B, "中断")
            end
        end
    )
    local _____9884_8BFB_53D8_5F0F = _____83B7_53D6_4F0A_857E_5A1C_53D8_5F0F(_____65BD_6CD5_8005)
    local _____7528_8FC5_884C = _____9884_8BFB_53D8_5F0F == "迅行"
    local _____6700_7EC8_8DDD_79BB = _____4F0A_857E_5A1CQ_914D_7F6E["最大距离"] + (_____7528_8FC5_884C and _____4F0A_857E_5A1C_53D8_5F0F_6548_679C_914D_7F6E["迅行_Q射程增加"] or 0)
    if _____6DFB_52A0_5355_4F4D_6682_505C(_____65BD_6CD5_8005, _____786C_76F4_6765_6E90) then
        SetUnitFacing(
            _____65BD_6CD5_8005,
            _____4E24_70B9_89D2_5EA6(
                GetUnitX(_____65BD_6CD5_8005),
                GetUnitY(_____65BD_6CD5_8005),
                _____76EE_6807X,
                _____76EE_6807Y
            )
        )
        _____64AD_653E_4F0A_857E_5A1C_9636_6BB5_52A8_4F5C(_____65BD_6CD5_8005, _____4F0A_857E_5A1C_6A21_578B_52A8_4F5C_914D_7F6E["技能动作"]["Q施法"])
    end
    _____5B9E_4F8B["登记延迟回调"](
        _____5B9E_4F8B,
        addDelayedCallback(
            _____4F0A_857E_5A1CQ_914D_7F6E["硬直秒"] * 1000,
            function()
                _____79FB_9664_5355_4F4D_6682_505C(_____65BD_6CD5_8005, _____786C_76F4_6765_6E90)
            end
        )
    )
    _____5B9E_4F8B["登记延迟回调"](
        _____5B9E_4F8B,
        addDelayedCallback(
            _____4F0A_857E_5A1CQ_914D_7F6E["发射延迟秒"] * 1000,
            function()
                if _____5B9E_4F8B["已结束"](_____5B9E_4F8B) then
                    return
                end
                if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
                    return
                end
                if not _____7528_8FC5_884C then
                    local _____7070_70EC_52A0_6210 = _____6D88_8D39_4F0A_857E_5A1C_53D8_5F0F_7528_4E8E(_____65BD_6CD5_8005, "Q")
                    _____6570_636E["灰烬爆发"] = _____7070_70EC_52A0_6210 ~= nil
                    local ____ = _____7070_70EC_52A0_6210
                end
                local _____53D1_5C04_65F6_76EE_6807_6709_6548 = _____6709_76EE_6807 and _____5355_4F4D_5B58_6D3B(_____76EE_6807_5355_4F4D)
                local _____8FFD_8E2A_4FDD_6301_79D2 = _____7528_8FC5_884C and _____4F0A_857E_5A1CQ_914D_7F6E["追踪保持秒"] + 0.5 or _____4F0A_857E_5A1CQ_914D_7F6E["追踪保持秒"]
                Sound3DII_CooPlayReuse(
                    _____4F0A_857E_5A1C_97F3_6548_914D_7F6E["Q发射"]["路径"],
                    GetUnitX(_____65BD_6CD5_8005),
                    GetUnitY(_____65BD_6CD5_8005),
                    _____4F0A_857E_5A1C_97F3_6548_914D_7F6E["Q发射"]["高度"],
                    _____4F0A_857E_5A1C_97F3_6548_914D_7F6E["Q发射"]["裁断距离"]
                )
                local _____5F39_9053 = _____53D1_5C04_5F39_9053({
                    ["名称"] = "伊蕾娜-旅风·追迹",
                    ["所有者"] = _____65BD_6CD5_8005,
                    ["发射X"] = GetUnitX(_____65BD_6CD5_8005),
                    ["发射Y"] = GetUnitY(_____65BD_6CD5_8005),
                    ["发射方向角"] = _____4E24_70B9_89D2_5EA6(
                        GetUnitX(_____65BD_6CD5_8005),
                        GetUnitY(_____65BD_6CD5_8005),
                        _____76EE_6807X,
                        _____76EE_6807Y
                    ),
                    ["速度"] = _____4F0A_857E_5A1CQ_914D_7F6E["弹道速度"],
                    ["轨迹"] = _____53D1_5C04_65F6_76EE_6807_6709_6548 and ({["类型"] = "追踪", ["目标"] = _____76EE_6807_5355_4F4D, ["追踪转向速度"] = _____4F0A_857E_5A1CQ_914D_7F6E["追踪转向速度"], ["追踪保持秒"] = _____8FFD_8E2A_4FDD_6301_79D2}) or ({["类型"] = "直线", ["距离"] = _____6700_7EC8_8DDD_79BB}),
                    ["命中半径"] = _____4F0A_857E_5A1CQ_914D_7F6E["命中半径"],
                    ["影响目标"] = "敌方",
                    ["碰撞消失"] = true,
                    ["每单位最大命中次数"] = 1,
                    ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                    ["来源类型"] = "单位技能",
                    ["技能ID"] = ____Q_6280_80FD_7C7B_578BID,
                    ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                    ["技能标签"] = "伊蕾娜-旅风·追迹",
                    ["伤害形态"] = "单体",
                    ["参与技能伤害加成"] = true,
                    ["模型"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q主弹道"]["模型路径"],
                    RGB = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q主弹道"].RGB,
                    ["缩放"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q主弹道"]["缩放"],
                    ["飞行高度"] = _____4F0A_857E_5A1C_8868_73B0_914D_7F6E["Q主弹道"]["高度"],
                    ["生命周期"] = _____6700_7EC8_8DDD_79BB / _____4F0A_857E_5A1CQ_914D_7F6E["弹道速度"] + 1,
                    ["实例控制器"] = _____5B9E_4F8B,
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
                        _____5C1D_8BD5W_6298_5C04_8054_52A8(_____65BD_6CD5_8005, _____6570_636E)
                        _____5C1D_8BD5E_8DEF_7EBF_8FFD_52A0(_____65BD_6CD5_8005, _____6570_636E, _____5F39_5E55_5B9E_4F8B["当前X"], _____5F39_5E55_5B9E_4F8B["当前Y"])
                    end,
                    ["on结束"] = function(______539F_56E0, ______5F39_5E55ID)
                        if not _____5B9E_4F8B["已结束"](_____5B9E_4F8B) then
                            _____5B9E_4F8B["完成"](_____5B9E_4F8B)
                        end
                    end
                })
                local ____ = _____5F39_9053
                if _____7528_8FC5_884C then
                    local _____5DF2_6D88_8D39 = _____6D88_8D39_4F0A_857E_5A1C_53D8_5F0F_7528_4E8E(_____65BD_6CD5_8005, "Q")
                    local ____ = _____5DF2_6D88_8D39
                end
            end
        )
    )
end
local _____5DF2_6CE8_518C = false
____exports["注册伊蕾娜Q"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "伊蕾娜-旅风·追迹（Q）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____4F0A_857E_5A1C_6280_80FD_914D_7F6E.Q["技能ID"],
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EQ_65C5_98CE_8FFD_8FF9,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 6
    })
end
return ____exports
