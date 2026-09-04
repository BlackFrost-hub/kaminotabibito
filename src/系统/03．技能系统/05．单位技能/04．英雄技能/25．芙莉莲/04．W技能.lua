--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local removeDelayedCallbackSafe, removeDelayedCallback
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.00．配置")
local _____8299_8389_83B2_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲技能配置"]
local _____8299_8389_83B2W_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲W配置"]
local _____8299_8389_83B2_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲表现配置"]
local _____8299_8389_83B2_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲音效配置"]
function removeDelayedCallbackSafe(id)
    removeDelayedCallback(id)
end
local ____require_result_0 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_0.Sound3DII_UnitPlayReuse
local ____require_result_1 = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话")
local _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD = ____require_result_1["播放英雄技能喊话"]
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.01A．动作表现")
local _____5F00_59CB_5FAA_73AF_5B88_62A4 = ____require_result_2["开始循环守护"]
local _____505C_6B62_5FAA_73AF_5B88_62A4 = ____require_result_2["停止循环守护"]
local _____8299_8389_83B2_52A8_4F5C_69FD = ____require_result_2["芙莉莲动作槽"]
local jass = require("jass.common")
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local fourCCToStringSafe = ____require_result_3.fourCCToStringSafe
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local getGameTime = ____require_result_4.getGameTime
local addDelayedCallback = ____require_result_4.addDelayedCallback
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_5["注册单位技能壳监听"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂")
local _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_6["创建战斗技能实例"]
local _____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_6["查询战斗技能实例"]
local ____require_result_7 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_7.registerDamageModifier
local unregisterDamageModifier = ____require_result_7.unregisterDamageModifier
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.07．护盾系统")
local _____5F00_59CB_62A4_76FE = ____require_result_8["开始护盾"]
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____89D2_5EA6_5DEE_7EDD_5BF9_503C = ____require_result_9["角度差绝对值"]
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_10["创建点特效"]
local _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_10["创建单位坐标跟随特效"]
local _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_10["销毁单位坐标跟随特效"]
local ____require_result_11 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_11["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_11["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_11["两点角度"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.02．被动效果")
local _____662F_8299_8389_83B2 = ____require_result_12["是芙莉莲"]
local _____8BB0_5F55_8299_8389_83B2_6D3B_52A8 = ____require_result_12["记录芙莉莲活动"]
local _____65BD_52A0_89E3_6790 = ____require_result_12["施加解析"]
local _____63D0_4F9B_6F14_7B97_666E_653B = ____require_result_12["提供演算普攻"]
local _____767B_8BB0_8299_8389_83B2_6E05_7406 = ____require_result_12["登记芙莉莲清理"]
local _____82B1_7530_8054_52A8 = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.07．D技能")
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.00．配置")
local _____8299_8389_83B2D_914D_7F6E = ____require_result_13["芙莉莲D配置"]
local ____require_result_14 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_14.debugLogForce
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____8299_8389_83B2_6280_80FD_914D_7F6E["单位类型ID"])
local ____W_6280_80FDID = stringToFourCCSafe(_____8299_8389_83B2_6280_80FD_914D_7F6E.W["技能ID"])
local ____W_914D_7F6E = _____8299_8389_83B2W_914D_7F6E
local _____62A4_58C1_7279_6548_952E = "芙莉莲W护壁"
local _____516C_5F0F_5C42_7279_6548_952E = "芙莉莲W公式层"
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetUnitName = jass.GetUnitName
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local function _____7ED3_675FW_62A4_58C1(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E, _____81EA_7136_7ED3_675F)
    if _____6570_636E["已结束"] then
        return
    end
    debugLogForce(
        "芙莉莲-W",
        "结束",
        "原因",
        _____81EA_7136_7ED3_675F and "自然结束" or "成功/中断收束",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(____W_6280_80FDID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "英雄",
        _____65BD_6CD5_8005,
        "handle",
        _____65BD_6CD5_8005
    )
    _____6570_636E["已结束"] = true
    if _____6570_636E["动作守护"] ~= nil then
        _____505C_6B62_5FAA_73AF_5B88_62A4(_____6570_636E["动作守护"])
        _____6570_636E["动作守护"] = nil
    end
    if _____6570_636E["修饰ID"] ~= 0 then
        unregisterDamageModifier(_____6570_636E["修饰ID"])
        _____6570_636E["修饰ID"] = 0
    end
    if _____6570_636E["到期ID"] ~= 0 then
        removeDelayedCallbackSafe(_____6570_636E["到期ID"])
        _____6570_636E["到期ID"] = 0
    end
    _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(_____65BD_6CD5_8005, _____62A4_58C1_7279_6548_952E)
    _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(_____65BD_6CD5_8005, _____516C_5F0F_5C42_7279_6548_952E)
    if _____81EA_7136_7ED3_675F and _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        _____5F00_59CB_62A4_76FE(
            _____65BD_6CD5_8005,
            {
                ["数值"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * ____W_914D_7F6E["自然结束护盾倍率"],
                ["持续时间"] = ____W_914D_7F6E["自然结束护盾持续秒"],
                ["来源单位"] = _____65BD_6CD5_8005,
                ["标签"] = "芙莉莲W自然护盾"
            }
        )
    end
    local ____ = _____6280_80FD_5B9E_4F8BID
end
local ____require_result_15 = require("系统.00．核心系统.05．中心计时器")
removeDelayedCallback = ____require_result_15.removeDelayedCallback
local function _____91CA_653EW(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    if not _____662F_8299_8389_83B2(_____65BD_6CD5_8005) then
        debugLogForce(
            "芙莉莲-W",
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
        "芙莉莲-W",
        "释放",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(____W_6280_80FDID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "英雄",
        _____65BD_6CD5_8005,
        "handle",
        _____65BD_6CD5_8005
    )
    if #_____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B(_____65BD_6CD5_8005, "芙莉莲W") > 0 then
        return
    end
    _____8BB0_5F55_8299_8389_83B2_6D3B_52A8(_____65BD_6CD5_8005)
    _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD(_____65BD_6CD5_8005, "芙莉莲", _____8299_8389_83B2_6280_80FD_914D_7F6E.W["技能ID"])
    local _____65B9_5411_89D2 = GetUnitFacing(_____65BD_6CD5_8005)
    local _____7A97_53E3_79D2 = ____W_914D_7F6E["护壁持续秒"]
    if _____82B1_7530_8054_52A8["尝试消费花田修正"] ~= nil and _____82B1_7530_8054_52A8["尝试消费花田修正"](_____65BD_6CD5_8005) then
        _____7A97_53E3_79D2 = _____7A97_53E3_79D2 + _____8299_8389_83B2D_914D_7F6E["修正W持续加成秒"]
    end
    local _____6570_636E = {
        ["方向角"] = _____65B9_5411_89D2,
        ["修饰ID"] = 0,
        ["已防御"] = false,
        ["已结束"] = false,
        ["到期ID"] = 0,
        ["动作守护"] = nil
    }
    _____6570_636E["动作守护"] = _____5F00_59CB_5FAA_73AF_5B88_62A4(_____65BD_6CD5_8005, _____8299_8389_83B2_52A8_4F5C_69FD["W保持防御"], "芙莉莲W动作")
    local _____63A7_5236_5668 = _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B({
        ["技能键"] = "芙莉莲W",
        ["施法者"] = _____65BD_6CD5_8005,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["数据"] = _____6570_636E,
        ["结束回调"] = function(______539F_56E0, _c)
            _____7ED3_675FW_62A4_58C1(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E, false)
        end
    })
    local _____62A4_58C1_53E5_67C4 = _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548(
        _____65BD_6CD5_8005,
        _____8299_8389_83B2_8868_73B0_914D_7F6E["W护壁"]["模型路径"],
        _____62A4_58C1_7279_6548_952E,
        _____8299_8389_83B2_8868_73B0_914D_7F6E["W护壁"]["缩放"],
        _____8299_8389_83B2_8868_73B0_914D_7F6E["W护壁"]["高度"],
        nil,
        _____8299_8389_83B2_8868_73B0_914D_7F6E["W护壁"]["动画索引"],
        _____8299_8389_83B2_8868_73B0_914D_7F6E["W护壁"]["面向角度"],
        _____8299_8389_83B2_8868_73B0_914D_7F6E["W护壁"].RGB,
        _____8299_8389_83B2_8868_73B0_914D_7F6E["W护壁"]["面向跟随单位"]
    )
    local ____ = _____62A4_58C1_53E5_67C4
    local _____516C_5F0F_5C42_53E5_67C4 = _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548(
        _____65BD_6CD5_8005,
        _____8299_8389_83B2_8868_73B0_914D_7F6E["W公式层"]["模型路径"],
        _____516C_5F0F_5C42_7279_6548_952E,
        _____8299_8389_83B2_8868_73B0_914D_7F6E["W公式层"]["缩放"],
        _____8299_8389_83B2_8868_73B0_914D_7F6E["W公式层"]["高度"],
        nil,
        _____8299_8389_83B2_8868_73B0_914D_7F6E["W公式层"]["动画索引"],
        _____8299_8389_83B2_8868_73B0_914D_7F6E["W公式层"]["面向角度"],
        _____8299_8389_83B2_8868_73B0_914D_7F6E["W公式层"].RGB,
        _____8299_8389_83B2_8868_73B0_914D_7F6E["W公式层"]["面向跟随单位"]
    )
    local ____ = _____516C_5F0F_5C42_53E5_67C4
    Sound3DII_UnitPlayReuse(_____8299_8389_83B2_97F3_6548_914D_7F6E["W展开"]["路径"], _____65BD_6CD5_8005, _____8299_8389_83B2_97F3_6548_914D_7F6E["W展开"]["裁断距离"])
    _____6570_636E["修饰ID"] = registerDamageModifier(
        function(context)
            if _____6570_636E["已防御"] or _____6570_636E["已结束"] then
                return context.currentDamage
            end
            if context.target ~= _____65BD_6CD5_8005 then
                return context.currentDamage
            end
            if context.attacker == nil or context.attacker == 0 then
                return context.currentDamage
            end
            local _____6765_6E90_89D2 = _____4E24_70B9_89D2_5EA6(
                GetUnitX(_____65BD_6CD5_8005),
                GetUnitY(_____65BD_6CD5_8005),
                GetUnitX(context.attacker),
                GetUnitY(context.attacker)
            )
            if _____89D2_5EA6_5DEE_7EDD_5BF9_503C(_____6570_636E["方向角"], _____6765_6E90_89D2) > ____W_914D_7F6E["正面角度"] / 2 then
                return context.currentDamage
            end
            if context.currentDamage <= 0 then
                return context.currentDamage
            end
            _____6570_636E["已防御"] = true
            local _____6765_6E90 = context.attacker
            debugLogForce(
                "芙莉莲-W",
                "命中",
                "玩家",
                GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
                "四码",
                fourCCToStringSafe(____W_6280_80FDID),
                "实例",
                _____6280_80FD_5B9E_4F8BID or "-",
                "目标",
                GetUnitName(_____6765_6E90),
                "handle",
                _____6765_6E90,
                "X",
                math.floor(GetUnitX(_____6765_6E90)),
                "Y",
                math.floor(GetUnitY(_____6765_6E90)),
                "伤害",
                context.currentDamage
            )
            addDelayedCallback(
                0,
                function()
                    _____521B_5EFA_70B9_7279_6548({
                        ["模型路径"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["W受击反馈"]["模型路径"],
                        X = GetUnitX(_____65BD_6CD5_8005),
                        Y = GetUnitY(_____65BD_6CD5_8005),
                        Z = _____8299_8389_83B2_8868_73B0_914D_7F6E["W受击反馈"]["高度"],
                        ["面向角度"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["W受击反馈"]["面向角度"],
                        ["动画索引"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["W受击反馈"]["动画索引"],
                        ["缩放"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["W受击反馈"]["缩放"],
                        ["持续秒"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["W受击反馈"]["持续秒"],
                        RGB = _____8299_8389_83B2_8868_73B0_914D_7F6E["W受击反馈"].RGB
                    })
                    Sound3DII_UnitPlayReuse(_____8299_8389_83B2_97F3_6548_914D_7F6E["W抵挡"]["路径"], _____65BD_6CD5_8005, _____8299_8389_83B2_97F3_6548_914D_7F6E["W抵挡"]["裁断距离"])
                    _____65BD_52A0_89E3_6790(_____65BD_6CD5_8005, _____6765_6E90, "防御")
                    _____63D0_4F9B_6F14_7B97_666E_653B(_____65BD_6CD5_8005)
                    _____7ED3_675FW_62A4_58C1(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E, false)
                    _____63A7_5236_5668["完成"](_____63A7_5236_5668)
                end
            )
            return context.currentDamage * (1 - ____W_914D_7F6E["防御化解比例"])
        end,
        60
    )
    _____6570_636E["到期ID"] = addDelayedCallback(
        _____7A97_53E3_79D2 * 1000,
        function()
            if _____6570_636E["已结束"] then
                return
            end
            _____7ED3_675FW_62A4_58C1(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E, true)
            _____63A7_5236_5668["完成"](_____63A7_5236_5668)
        end
    )
    _____63A7_5236_5668["登记延迟回调"](_____63A7_5236_5668, _____6570_636E["到期ID"])
end
local _____5DF2_6CE8_518C = false
____exports["注册芙莉莲W"] = function()
    debugLogForce("芙莉莲-W", "注册", "名称", "注册芙莉莲W")
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "芙莉莲-防御魔法·魔力护壁（W）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____8299_8389_83B2_6280_80FD_914D_7F6E.W["技能ID"],
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EW,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = ____W_914D_7F6E["护壁持续秒"] + 2
    })
end
return ____exports
