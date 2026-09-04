--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____8299_8389_83B2D_6570_503C_5F15_7528
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.00．配置")
local _____8299_8389_83B2_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲技能配置"]
local _____8299_8389_83B2Q_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲Q配置"]
local _____8299_8389_83B2_88AB_52A8_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲被动配置"]
local _____8299_8389_83B2_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲表现配置"]
local _____8299_8389_83B2_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲音效配置"]
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.01A．动作表现")
local _____64AD_653E_9650_65F6_52A8_4F5C = ____require_result_0["播放限时动作"]
local _____8299_8389_83B2_52A8_4F5C_69FD = ____require_result_0["芙莉莲动作槽"]
--- 本文件内使用简写；与上方导入的完整配置同源（仅别名，无重复定义）。
local _____88AB_52A8_914D_7F6E = _____8299_8389_83B2_88AB_52A8_914D_7F6E
local jass = require("jass.common")
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local fourCCToStringSafe = ____require_result_1.fourCCToStringSafe
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
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_8["创建点特效"]
local ____require_result_9 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_9.Sound3DII_UnitPlayReuse
local ____require_result_10 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_CooPlayReuse = ____require_result_10.Sound3DII_CooPlayReuse
local ____require_result_11 = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话")
local _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD = ____require_result_11["播放英雄技能喊话"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.02．被动效果")
local _____662F_8299_8389_83B2 = ____require_result_12["是芙莉莲"]
local _____8BB0_5F55_8299_8389_83B2_6D3B_52A8 = ____require_result_12["记录芙莉莲活动"]
local _____5FEB_7167_9690_533F = ____require_result_12["快照隐匿"]
local _____65BD_52A0_89E3_6790 = ____require_result_12["施加解析"]
local _____6709_89E3_6790 = ____require_result_12["有解析"]
local _____76EE_6807_89E3_6790_5B8C_6210 = ____require_result_12["目标解析完成"]
local _____5C1D_8BD5_6D88_8D39_89E3_6790_5B8C_6210 = ____require_result_12["尝试消费解析完成"]
local _____63D0_4F9B_6F14_7B97_666E_653B = ____require_result_12["提供演算普攻"]
local _____82B1_7530_8054_52A8 = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.07．D技能")
local ____require_result_13 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_13.debugLogForce
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____8299_8389_83B2_6280_80FD_914D_7F6E["单位类型ID"])
local ____Q_6280_80FDID = stringToFourCCSafe(_____8299_8389_83B2_6280_80FD_914D_7F6E.Q["技能ID"])
local ____Q_914D_7F6E = _____8299_8389_83B2Q_914D_7F6E
local ____Q_97F3_6548 = _____8299_8389_83B2_97F3_6548_914D_7F6E["Q发射"]
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitName = jass.GetUnitName
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local function _____7ED3_7B97Q_547D_4E2D(_____65BD_6CD5_8005, _____76EE_6807, _____6280_80FD_5B9E_4F8BID, _____9690_533F_5F3A_5316)
    local _____653B_51FB_529B = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005)
    local _____57FA_7840_500D_7387 = ____Q_914D_7F6E["伤害倍率"] + (_____9690_533F_5F3A_5316 and _____88AB_52A8_914D_7F6E["隐匿首击加成倍率"] or 0)
    local _____500D_7387 = _____57FA_7840_500D_7387
    local _____6807_7B7E = "芙莉莲-QZoltraak"
    if _____76EE_6807_89E3_6790_5B8C_6210(_____65BD_6CD5_8005, _____76EE_6807) then
        if _____5C1D_8BD5_6D88_8D39_89E3_6790_5B8C_6210(_____65BD_6CD5_8005, _____76EE_6807) then
            _____500D_7387 = _____500D_7387 + ____Q_914D_7F6E["破防追加倍率"]
            _____6807_7B7E = "芙莉莲-Q破防"
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["解析完成"]["模型路径"],
                X = GetUnitX(_____76EE_6807),
                Y = GetUnitY(_____76EE_6807),
                Z = _____8299_8389_83B2_8868_73B0_914D_7F6E["解析完成"]["高度"],
                ["面向角度"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["解析完成"]["面向角度"],
                ["动画索引"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["解析完成"]["动画索引"],
                ["缩放"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["解析完成"]["缩放"],
                ["持续秒"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["解析完成"]["持续秒"],
                RGB = _____8299_8389_83B2_8868_73B0_914D_7F6E["解析完成"].RGB
            })
            Sound3DII_CooPlayReuse(
                _____8299_8389_83B2_97F3_6548_914D_7F6E["R破防"]["路径"],
                GetUnitX(_____76EE_6807),
                GetUnitY(_____76EE_6807),
                _____8299_8389_83B2_97F3_6548_914D_7F6E["R破防"]["高度"],
                _____8299_8389_83B2_97F3_6548_914D_7F6E["R破防"]["裁断距离"]
            )
        end
    elseif _____6709_89E3_6790(_____65BD_6CD5_8005, _____76EE_6807, "防御") then
        _____500D_7387 = _____500D_7387 + ____Q_914D_7F6E["穿透追加倍率"]
        _____6807_7B7E = "芙莉莲-Q穿透"
    end
    debugLogForce(
        "芙莉莲-Q",
        "命中",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(____Q_6280_80FDID),
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
        _____653B_51FB_529B * _____500D_7387,
        "标签",
        _____6807_7B7E
    )
    _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = _____65BD_6CD5_8005,
        ["目标"] = _____76EE_6807,
        ["伤害"] = _____653B_51FB_529B * _____500D_7387,
        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____Q_6280_80FDID,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["标签"] = _____6807_7B7E,
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = true
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q命中反馈"]["模型路径"],
        X = GetUnitX(_____76EE_6807),
        Y = GetUnitY(_____76EE_6807),
        Z = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q命中反馈"]["高度"],
        ["面向角度"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q命中反馈"]["面向角度"],
        ["动画索引"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q命中反馈"]["动画索引"],
        ["缩放"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q命中反馈"]["缩放"],
        ["持续秒"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q命中反馈"]["持续秒"],
        RGB = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q命中反馈"].RGB
    })
    Sound3DII_CooPlayReuse(
        _____8299_8389_83B2_97F3_6548_914D_7F6E["Q命中"]["路径"],
        GetUnitX(_____76EE_6807),
        GetUnitY(_____76EE_6807),
        _____8299_8389_83B2_97F3_6548_914D_7F6E["Q命中"]["高度"],
        _____8299_8389_83B2_97F3_6548_914D_7F6E["Q命中"]["裁断距离"]
    )
    _____65BD_52A0_89E3_6790(_____65BD_6CD5_8005, _____76EE_6807, "攻击")
    _____63D0_4F9B_6F14_7B97_666E_653B(_____65BD_6CD5_8005)
end
local function _____91CA_653EQ(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    if not _____662F_8299_8389_83B2(_____65BD_6CD5_8005) then
        debugLogForce(
            "芙莉莲-Q",
            "释放被拒",
            "原因",
            "非芙莉莲施法者",
            "施法者",
            _____65BD_6CD5_8005,
            "handle",
            _____65BD_6CD5_8005,
            "实例",
            _____6280_80FD_5B9E_4F8BID or "-"
        )
        return
    end
    debugLogForce(
        "芙莉莲-Q",
        "释放",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(____Q_6280_80FDID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "英雄",
        _____65BD_6CD5_8005,
        "handle",
        _____65BD_6CD5_8005,
        "目标",
        "点施放",
        "X",
        math.floor(GetSpellTargetX()),
        "Y",
        math.floor(GetSpellTargetY())
    )
    local _____9690_533F_5F3A_5316 = _____5FEB_7167_9690_533F(_____65BD_6CD5_8005)
    _____8BB0_5F55_8299_8389_83B2_6D3B_52A8(_____65BD_6CD5_8005)
    _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD(_____65BD_6CD5_8005, "芙莉莲", _____8299_8389_83B2_6280_80FD_914D_7F6E.Q["技能ID"])
    _____64AD_653E_9650_65F6_52A8_4F5C(_____65BD_6CD5_8005, _____8299_8389_83B2_52A8_4F5C_69FD["Q发射"], "芙莉莲Q动作")
    Sound3DII_UnitPlayReuse(____Q_97F3_6548["路径"], _____65BD_6CD5_8005, ____Q_97F3_6548["裁断距离"])
    local _____65B9_5411_89D2 = _____4E24_70B9_89D2_5EA6(
        GetUnitX(_____65BD_6CD5_8005),
        GetUnitY(_____65BD_6CD5_8005),
        GetSpellTargetX(),
        GetSpellTargetY()
    )
    local _____5C04_7A0B = ____Q_914D_7F6E["射程"] + (_____9690_533F_5F3A_5316 and _____88AB_52A8_914D_7F6E["隐匿射程加成"] or 0)
    if _____82B1_7530_8054_52A8["尝试消费花田修正"] ~= nil and _____82B1_7530_8054_52A8["尝试消费花田修正"](_____65BD_6CD5_8005) then
        _____5C04_7A0B = _____5C04_7A0B + _____8299_8389_83B2D_6570_503C_5F15_7528["修正Q射程加成"]
    end
    local _____63A7_5236_5668 = _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B({
        ["技能键"] = "芙莉莲Q",
        ["施法者"] = _____65BD_6CD5_8005,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["数据"] = {["已发射"] = false},
        ["结束回调"] = function(______539F_56E0, _c)
            debugLogForce(
                "芙莉莲-Q",
                "结束",
                "原因",
                ______539F_56E0 or "-",
                "玩家",
                GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
                "四码",
                fourCCToStringSafe(____Q_6280_80FDID),
                "实例",
                _____6280_80FD_5B9E_4F8BID or "-",
                "英雄",
                _____65BD_6CD5_8005,
                "handle",
                _____65BD_6CD5_8005
            )
        end
    })
    local _____53D1_5C04ID = addDelayedCallback(
        ____Q_914D_7F6E["发射延迟毫秒"],
        function()
            if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
                return
            end
            _____53D1_5C04_5F39_9053({
                ["名称"] = "芙莉莲-QZoltraak",
                ["所有者"] = _____65BD_6CD5_8005,
                ["发射方向角"] = _____65B9_5411_89D2,
                ["速度"] = ____Q_914D_7F6E["弹道速度"],
                ["轨迹"] = {["类型"] = "直线", ["距离"] = _____5C04_7A0B},
                ["发射高度来源"] = "发射者",
                ["命中半径"] = ____Q_914D_7F6E["命中半径"],
                ["影响目标"] = "敌方",
                ["碰撞消失"] = true,
                ["每单位最大命中次数"] = 1,
                ["最大总命中次数"] = 1,
                ["来源类型"] = "单位技能",
                ["技能ID"] = ____Q_6280_80FDID,
                ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                ["技能标签"] = "芙莉莲-QZoltraak",
                ["模型"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q弹道"]["模型路径"],
                RGB = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q弹道"].RGB,
                ["缩放"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q弹道"]["缩放"],
                ["飞行高度"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q弹道"]["高度"],
                ["附加特效1"] = {
                    ["模型"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q弹道附加特效"]["模型路径"],
                    ["跟随主弹幕参数"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q弹道附加特效"]["跟随主弹幕参数"],
                    ["跟随轨迹俯仰"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q弹道附加特效"]["跟随轨迹俯仰"],
                    ["动画索引"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q弹道附加特效"]["动画索引"],
                    ["缩放"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q弹道附加特效"]["缩放"],
                    ["红"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q弹道附加特效"].RGB["红"],
                    ["绿"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q弹道附加特效"].RGB["绿"],
                    ["蓝"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q弹道附加特效"].RGB["蓝"],
                    ["透明度"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["Q弹道附加特效"].RGB["透明度"]
                },
                ["on命中"] = function(_____76EE_6807, ______5F39_9053)
                    _____7ED3_7B97Q_547D_4E2D(_____65BD_6CD5_8005, _____76EE_6807, _____6280_80FD_5B9E_4F8BID, _____9690_533F_5F3A_5316)
                end
            })
            _____63A7_5236_5668["完成"](_____63A7_5236_5668)
        end
    )
    _____63A7_5236_5668["登记延迟回调"](_____63A7_5236_5668, _____53D1_5C04ID)
end
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.00．配置")
_____8299_8389_83B2D_6570_503C_5F15_7528 = ____require_result_14["芙莉莲D配置"]
local _____5DF2_6CE8_518C = false
____exports["注册芙莉莲Q"] = function()
    debugLogForce("芙莉莲-Q", "注册", "名称", "注册芙莉莲Q")
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "芙莉莲-普通攻击魔法·Zoltraak（Q）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____8299_8389_83B2_6280_80FD_914D_7F6E.Q["技能ID"],
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EQ,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 3
    })
end
return ____exports
