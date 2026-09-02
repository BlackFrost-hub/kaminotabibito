local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.00．配置")
local _____8299_8389_83B2_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲技能配置"]
local _____8299_8389_83B2E_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲E配置"]
local _____8299_8389_83B2_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲表现配置"]
local _____8299_8389_83B2_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲音效配置"]
local ____require_result_0 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_0.Sound3DII_UnitPlayReuse
local Sound3DII_CooPlayReuse = ____require_result_0.Sound3DII_CooPlayReuse
local ____require_result_1 = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话")
local _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD = ____require_result_1["播放英雄技能喊话"]
local jass = require("jass.common")
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local getGameTime = ____require_result_3.getGameTime
local addDelayedCallback = ____require_result_3.addDelayedCallback
local removeDelayedCallback = ____require_result_3.removeDelayedCallback
local addPeriodicCallback = ____require_result_3.addPeriodicCallback
local removePeriodicCallback = ____require_result_3.removePeriodicCallback
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_4["注册单位技能壳监听"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂")
local _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_5["创建战斗技能实例"]
local _____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_5["查询战斗技能实例"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_6["开始冲锋"]
local _____505C_6B62_4F4D_79FB = ____require_result_6["停止位移"]
local ____require_result_7 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_7.registerDamageModifier
local unregisterDamageModifier = ____require_result_7.unregisterDamageModifier
local ____require_result_8 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_8["造成技能伤害"]
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_9["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_9["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_9["两点角度"]
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_10["创建点特效"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.01A．动作表现")
local _____64AD_653E_9650_65F6_52A8_4F5C = ____require_result_11["播放限时动作"]
local _____5F00_59CB_5FAA_73AF_5B88_62A4 = ____require_result_11["开始循环守护"]
local _____505C_6B62_5FAA_73AF_5B88_62A4 = ____require_result_11["停止循环守护"]
local _____8299_8389_83B2_52A8_4F5C_69FD = ____require_result_11["芙莉莲动作槽"]
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
local ____E_6280_80FDID = stringToFourCCSafe(_____8299_8389_83B2_6280_80FD_914D_7F6E.E["技能ID"])
local ____E_914D_7F6E = _____8299_8389_83B2E_914D_7F6E
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitZ = jass.GetUnitFlyHeight
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitEnemy = jass.IsUnitEnemy
local AddLightningEx = jass.AddLightningEx
local MoveLightningEx = jass.MoveLightningEx
local DestroyLightning = jass.DestroyLightning
local function _____7ED3_7B97E_843D_70B9(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
    if _____6570_636E["已结算"] then
        return
    end
    _____6570_636E["已结算"] = true
    local _____51B2_51FB_500D_7387 = ____E_914D_7F6E["落点冲击倍率"]
    if _____6570_636E["花田修正"] and _____82B1_7530_8054_52A8["尝试消费花田修正"] ~= nil and _____82B1_7530_8054_52A8["尝试消费花田修正"](_____65BD_6CD5_8005) then
        _____51B2_51FB_500D_7387 = _____51B2_51FB_500D_7387 + _____8299_8389_83B2D_914D_7F6E["修正E落点倍率加成"]
    end
    local _____7EC4 = jass.CreateGroup()
    jass.GroupEnumUnitsInRange(
        _____7EC4,
        _____6570_636E["终点X"],
        _____6570_636E["终点Y"],
        ____E_914D_7F6E["落点冲击半径"],
        nil
    )
    while true do
        do
            local u = jass.FirstOfGroup(_____7EC4)
            if u == nil or u == 0 then
                break
            end
            jass.GroupRemoveUnit(_____7EC4, u)
            if u == _____65BD_6CD5_8005 or not _____5355_4F4D_5B58_6D3B(u) then
                goto __continue5
            end
            if not IsUnitEnemy(
                u,
                GetOwningPlayer(_____65BD_6CD5_8005)
            ) then
                goto __continue5
            end
            debugLogForce(
                "芙莉莲-E",
                "伤害",
                "标签",
                "芙莉莲-E落点冲击",
                "数值",
                _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____51B2_51FB_500D_7387,
                "目标",
                u
            )
            _____9020_6210_6280_80FD_4F24_5BB3({
                ["来源"] = _____65BD_6CD5_8005,
                ["目标"] = u,
                ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____51B2_51FB_500D_7387,
                ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                ["攻击类型"] = ATTACK_TYPE_NORMAL,
                ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
                ["来源类型"] = "单位技能",
                ["技能ID"] = ____E_6280_80FDID,
                ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                ["标签"] = "芙莉莲-E落点冲击",
                ["伤害形态"] = "AOE",
                ["参与技能伤害加成"] = true
            })
            _____65BD_52A0_89E3_6790(_____65BD_6CD5_8005, u, "位置")
        end
        ::__continue5::
    end
    jass.DestroyGroup(_____7EC4)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["E观察落点"]["模型路径"],
        X = _____6570_636E["终点X"],
        Y = _____6570_636E["终点Y"],
        Z = _____8299_8389_83B2_8868_73B0_914D_7F6E["E观察落点"]["高度"],
        ["面向角度"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["E观察落点"]["面向角度"],
        ["动画索引"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["E观察落点"]["动画索引"],
        ["缩放"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["E观察落点"]["缩放"],
        ["持续秒"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["E观察落点"]["持续秒"],
        RGB = _____8299_8389_83B2_8868_73B0_914D_7F6E["E观察落点"].RGB
    })
    _____63D0_4F9B_6F14_7B97_666E_653B(_____65BD_6CD5_8005)
end
local function _____6E05_7406_89C2_5BDF_95EA_7535(_____6570_636E)
    do
        local i = 0
        while i < #_____6570_636E["观察闪电列表"] do
            local _____95EA_7535 = _____6570_636E["观察闪电列表"][i + 1]
            if _____95EA_7535["句柄"] ~= nil and _____95EA_7535["句柄"] ~= 0 then
                DestroyLightning(_____95EA_7535["句柄"])
            end
            i = i + 1
        end
    end
    _____6570_636E["观察闪电列表"] = {}
end
--- 完成收尾（停观察 Tick/销毁闪电/停动作守护/注销减伤/恢复高度；幂等）
local function _____5B8C_6210E_6536_5C3E(_____65BD_6CD5_8005, _____6570_636E)
    if _____6570_636E["观察守护"] ~= nil then
        _____505C_6B62_5FAA_73AF_5B88_62A4(_____6570_636E["观察守护"])
        _____6570_636E["观察守护"] = nil
    end
    if _____6570_636E["减伤ID"] ~= 0 then
        unregisterDamageModifier(_____6570_636E["减伤ID"])
        _____6570_636E["减伤ID"] = 0
    end
    if _____6570_636E["观察TickID"] ~= 0 then
        removePeriodicCallback(_____6570_636E["观察TickID"])
        _____6570_636E["观察TickID"] = 0
    end
    _____6E05_7406_89C2_5BDF_95EA_7535(_____6570_636E)
    if _____65BD_6CD5_8005 ~= nil and _____65BD_6CD5_8005 ~= 0 then
        SetUnitFlyHeight(_____65BD_6CD5_8005, _____6570_636E["起点高度"], ____E_914D_7F6E["高度变化率"])
    end
end
--- 结束位移阶段：自然到达 → 结算落点 + 进入观察期（观察持续秒 后收尾）；
-- 中断/死亡/主单位死亡 → 只清理不结算。
local function _____7ED3_675FE(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E, _____81EA_7136_5230_8FBE)
    if _____6570_636E["已结束"] then
        return
    end
    _____6570_636E["已结束"] = true
    if _____6570_636E["位移ID"] ~= 0 then
        _____505C_6B62_4F4D_79FB(_____6570_636E["位移ID"], "中断")
        _____6570_636E["位移ID"] = 0
    end
    if _____81EA_7136_5230_8FBE then
        _____7ED3_7B97E_843D_70B9(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E)
        if _____6570_636E["减伤ID"] ~= 0 then
            unregisterDamageModifier(_____6570_636E["减伤ID"])
            _____6570_636E["减伤ID"] = 0
        end
        _____6570_636E["观察截止"] = getGameTime() + ____E_914D_7F6E["观察持续秒"]
        if _____6570_636E["观察守护"] == nil then
            _____6570_636E["观察守护"] = _____5F00_59CB_5FAA_73AF_5B88_62A4(
                _____65BD_6CD5_8005,
                __TS__ObjectAssign({}, _____8299_8389_83B2_52A8_4F5C_69FD["E观察保持"], {["持续秒"] = ____E_914D_7F6E["观察持续秒"]}),
                "芙莉莲E观察"
            )
        end
    else
        _____5B8C_6210E_6536_5C3E(_____65BD_6CD5_8005, _____6570_636E)
    end
end
--- 观察期纳入实例生命周期：观察截止回调统一收尾并完成实例（打断/死亡由实例收束清理）
local function ____E_5B89_6392_89C2_5BDF_671F_6536_5C3E(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6570_636E)
    local _____89C2_5BDF_622A_6B62ID = addDelayedCallback(
        ____E_914D_7F6E["观察持续秒"] * 1000,
        function()
            _____5B8C_6210E_6536_5C3E(_____65BD_6CD5_8005, _____6570_636E)
            _____63A7_5236_5668["完成"](_____63A7_5236_5668)
        end
    )
    _____63A7_5236_5668["登记延迟回调"](_____63A7_5236_5668, _____89C2_5BDF_622A_6B62ID)
end
local function _____91CA_653EE(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    debugLogForce("芙莉莲-E", "释放", "技能实例ID", _____6280_80FD_5B9E_4F8BID or "-")
    if not _____662F_8299_8389_83B2(_____65BD_6CD5_8005) then
        return
    end
    if #_____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B(_____65BD_6CD5_8005, "芙莉莲E") > 0 then
        return
    end
    _____8BB0_5F55_8299_8389_83B2_6D3B_52A8(_____65BD_6CD5_8005)
    local ____temp_15
    if _____82B1_7530_8054_52A8["尝试消费花田修正"] ~= nil and _____82B1_7530_8054_52A8["在花田内"] ~= nil then
        ____temp_15 = _____82B1_7530_8054_52A8["在花田内"](_____65BD_6CD5_8005)
    else
        ____temp_15 = false
    end
    local _____82B1_7530_4FEE_6B63 = ____temp_15
    _____64AD_653E_9650_65F6_52A8_4F5C(_____65BD_6CD5_8005, _____8299_8389_83B2_52A8_4F5C_69FD["E起飞"], "芙莉莲E起飞")
    local _____8D77_70B9X = GetUnitX(_____65BD_6CD5_8005)
    local _____8D77_70B9Y = GetUnitY(_____65BD_6CD5_8005)
    local _____6570_636E = {
        ["起点X"] = _____8D77_70B9X,
        ["起点Y"] = _____8D77_70B9Y,
        ["起点高度"] = GetUnitZ(_____65BD_6CD5_8005),
        ["终点X"] = GetSpellTargetX(),
        ["终点Y"] = GetSpellTargetY(),
        ["方向角"] = _____4E24_70B9_89D2_5EA6(
            _____8D77_70B9X,
            _____8D77_70B9Y,
            GetSpellTargetX(),
            GetSpellTargetY()
        ),
        ["位移ID"] = 0,
        ["减伤ID"] = 0,
        ["观察TickID"] = 0,
        ["观察闪电列表"] = {},
        ["花田修正"] = _____82B1_7530_4FEE_6B63,
        ["观察守护"] = nil,
        ["观察截止"] = 0,
        ["已结束"] = false,
        ["已结算"] = false
    }
    local _____63A7_5236_5668 = _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B({
        ["技能键"] = "芙莉莲E",
        ["施法者"] = _____65BD_6CD5_8005,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["数据"] = _____6570_636E,
        ["结束回调"] = function(______539F_56E0, _c)
            debugLogForce("芙莉莲-E", "结束", "原因", ______539F_56E0 or "-")
            if _____6570_636E["已结束"] then
                _____5B8C_6210E_6536_5C3E(_____65BD_6CD5_8005, _____6570_636E)
                return
            end
            _____6570_636E["已结束"] = true
            if _____6570_636E["位移ID"] ~= 0 then
                _____505C_6B62_4F4D_79FB(_____6570_636E["位移ID"], "中断")
                _____6570_636E["位移ID"] = 0
            end
            _____5B8C_6210E_6536_5C3E(_____65BD_6CD5_8005, _____6570_636E)
        end
    })
    SetUnitFlyHeight(_____65BD_6CD5_8005, _____6570_636E["起点高度"] + ____E_914D_7F6E["飞行高度"], ____E_914D_7F6E["高度变化率"])
    Sound3DII_UnitPlayReuse(_____8299_8389_83B2_97F3_6548_914D_7F6E["E升空"]["路径"], _____65BD_6CD5_8005, _____8299_8389_83B2_97F3_6548_914D_7F6E["E升空"]["裁断距离"])
    _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD(_____65BD_6CD5_8005, "芙莉莲", _____8299_8389_83B2_6280_80FD_914D_7F6E.E["技能ID"])
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["E起落风压"]["模型路径"],
        X = _____8D77_70B9X,
        Y = _____8D77_70B9Y,
        Z = _____8299_8389_83B2_8868_73B0_914D_7F6E["E起落风压"]["高度"],
        ["面向角度"] = _____6570_636E["方向角"],
        ["动画索引"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["E起落风压"]["动画索引"],
        ["缩放"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["E起落风压"]["缩放"],
        ["持续秒"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["E起落风压"]["持续秒"],
        RGB = _____8299_8389_83B2_8868_73B0_914D_7F6E["E起落风压"].RGB
    })
    _____6570_636E["减伤ID"] = registerDamageModifier(
        function(context)
            if _____6570_636E["已结束"] then
                return context.currentDamage
            end
            if context.target ~= _____65BD_6CD5_8005 then
                return context.currentDamage
            end
            if context.currentDamage <= 0 then
                return context.currentDamage
            end
            return context.currentDamage * (1 - ____E_914D_7F6E["位移减伤比例"])
        end,
        45
    )
    local _____8D77_70B9_504F_79FB = _____8299_8389_83B2_8868_73B0_914D_7F6E["E闪电"]["起点高度偏移"]
    local _____7EC8_70B9_9AD8_5EA6 = _____8299_8389_83B2_8868_73B0_914D_7F6E["E闪电"]["终点高度"]
    _____6570_636E["观察TickID"] = addPeriodicCallback(
        250,
        function()
            if _____6570_636E["已结束"] then
                if getGameTime() > _____6570_636E["观察截止"] then
                    _____5B8C_6210E_6536_5C3E(_____65BD_6CD5_8005, _____6570_636E)
                end
                return
            end
            if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
                return
            end
            local _____73B0X = GetUnitX(_____65BD_6CD5_8005)
            local _____73B0Y = GetUnitY(_____65BD_6CD5_8005)
            local _____9AD8_5EA6 = GetUnitZ(_____65BD_6CD5_8005)
            do
                local i = #_____6570_636E["观察闪电列表"] - 1
                while i >= 0 do
                    local _____95EA_7535 = _____6570_636E["观察闪电列表"][i + 1]
                    if _____95EA_7535["目标"] == nil or _____95EA_7535["目标"] == 0 or not _____5355_4F4D_5B58_6D3B(_____95EA_7535["目标"]) then
                        if _____95EA_7535["句柄"] ~= nil and _____95EA_7535["句柄"] ~= 0 then
                            DestroyLightning(_____95EA_7535["句柄"])
                        end
                        __TS__ArraySplice(_____6570_636E["观察闪电列表"], i, 1)
                    end
                    i = i - 1
                end
            end
            do
                local i = 0
                while i < #_____6570_636E["观察闪电列表"] do
                    local _____95EA_7535 = _____6570_636E["观察闪电列表"][i + 1]
                    MoveLightningEx(
                        _____95EA_7535["句柄"],
                        false,
                        _____73B0X,
                        _____73B0Y,
                        _____9AD8_5EA6 + _____8D77_70B9_504F_79FB,
                        GetUnitX(_____95EA_7535["目标"]),
                        GetUnitY(_____95EA_7535["目标"]),
                        _____7EC8_70B9_9AD8_5EA6
                    )
                    i = i + 1
                end
            end
            if #_____6570_636E["观察闪电列表"] < 5 then
                local _____7EC4 = jass.CreateGroup()
                jass.GroupEnumUnitsInRange(
                    _____7EC4,
                    _____73B0X,
                    _____73B0Y,
                    ____E_914D_7F6E["观察半径"],
                    nil
                )
                while true do
                    do
                        local u = jass.FirstOfGroup(_____7EC4)
                        if u == nil or u == 0 then
                            break
                        end
                        jass.GroupRemoveUnit(_____7EC4, u)
                        if u == _____65BD_6CD5_8005 or not _____5355_4F4D_5B58_6D3B(u) then
                            goto __continue48
                        end
                        if not IsUnitEnemy(
                            u,
                            GetOwningPlayer(_____65BD_6CD5_8005)
                        ) then
                            goto __continue48
                        end
                        local _____5DF2_6709 = false
                        do
                            local i = 0
                            while i < #_____6570_636E["观察闪电列表"] do
                                if _____6570_636E["观察闪电列表"][i + 1]["目标"] == u then
                                    _____5DF2_6709 = true
                                    break
                                end
                                i = i + 1
                            end
                        end
                        if _____5DF2_6709 then
                            goto __continue48
                        end
                        local _____53E5_67C4 = AddLightningEx(
                            _____8299_8389_83B2_8868_73B0_914D_7F6E["E观察闪电ID"],
                            false,
                            _____73B0X,
                            _____73B0Y,
                            _____9AD8_5EA6 + _____8D77_70B9_504F_79FB,
                            GetUnitX(u),
                            GetUnitY(u),
                            _____7EC8_70B9_9AD8_5EA6
                        )
                        if _____53E5_67C4 == nil or _____53E5_67C4 == 0 then
                            goto __continue48
                        end
                        local ____6570_636E__89C2_5BDF_95EA_7535_5217_8868_16 = _____6570_636E["观察闪电列表"]
                        ____6570_636E__89C2_5BDF_95EA_7535_5217_8868_16[#____6570_636E__89C2_5BDF_95EA_7535_5217_8868_16 + 1] = {["目标"] = u, ["句柄"] = _____53E5_67C4}
                        Sound3DII_CooPlayReuse(
                            _____8299_8389_83B2_97F3_6548_914D_7F6E["E观察"]["路径"],
                            GetUnitX(u),
                            GetUnitY(u),
                            _____8299_8389_83B2_97F3_6548_914D_7F6E["E观察"]["高度"],
                            _____8299_8389_83B2_97F3_6548_914D_7F6E["E观察"]["裁断距离"]
                        )
                        _____65BD_52A0_89E3_6790(_____65BD_6CD5_8005, u, "位置")
                        if #_____6570_636E["观察闪电列表"] >= 5 then
                            break
                        end
                    end
                    ::__continue48::
                end
                jass.DestroyGroup(_____7EC4)
            end
        end
    )
    debugLogForce(
        "芙莉莲-E",
        "位移",
        "类型",
        "冲锋",
        "距离",
        ____E_914D_7F6E["位移距离"]
    )
    _____6570_636E["位移ID"] = _____5F00_59CB_51B2_950B(
        _____65BD_6CD5_8005,
        {
            ["距离"] = ____E_914D_7F6E["位移距离"],
            ["每秒速度"] = ____E_914D_7F6E["位移速度"],
            ["角度"] = _____6570_636E["方向角"],
            ["检查地形"] = true,
            ["朝向跟随位移"] = true,
            ["暂停单位"] = false,
            ["位移特效"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["E起落风压"]["模型路径"],
            RGB = _____8299_8389_83B2_8868_73B0_914D_7F6E["E起落风压"].RGB,
            ["位移特效缩放"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["E起落风压"]["缩放"],
            ["位移特效高度"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["E起落风压"]["高度"],
            ["位移特效持续秒"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["E起落风压"]["持续秒"],
            ["撞墙回调"] = function(_____79FB_52A8_5355_4F4D, ______4F4D_79FBID)
                if _____6570_636E["已结束"] then
                    return
                end
                _____6570_636E["终点X"] = GetUnitX(_____79FB_52A8_5355_4F4D)
                _____6570_636E["终点Y"] = GetUnitY(_____79FB_52A8_5355_4F4D)
                _____7ED3_675FE(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E, true)
                ____E_5B89_6392_89C2_5BDF_671F_6536_5C3E(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6570_636E)
            end,
            ["结束回调"] = function(_____5355_4F4D, _____539F_56E0, ______4F4D_79FBID)
                if _____6570_636E["已结束"] then
                    return
                end
                if _____539F_56E0 == "完成" then
                    _____6570_636E["终点X"] = GetUnitX(_____5355_4F4D)
                    _____6570_636E["终点Y"] = GetUnitY(_____5355_4F4D)
                    _____7ED3_675FE(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E, true)
                    ____E_5B89_6392_89C2_5BDF_671F_6536_5C3E(_____65BD_6CD5_8005, _____63A7_5236_5668, _____6570_636E)
                else
                    _____7ED3_675FE(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____6570_636E, false)
                    _____63A7_5236_5668["完成"](_____63A7_5236_5668)
                end
            end
        }
    )
    if _____6570_636E["位移ID"] == 0 then
        _____5B8C_6210E_6536_5C3E(_____65BD_6CD5_8005, _____6570_636E)
        _____63A7_5236_5668["完成"](_____63A7_5236_5668)
    end
end
local _____5DF2_6CE8_518C = false
____exports["注册芙莉莲E"] = function()
    debugLogForce("芙莉莲-E", "注册", "名称", "注册芙莉莲E")
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "芙莉莲-飞行魔法·高处观察（E）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____8299_8389_83B2_6280_80FD_914D_7F6E.E["技能ID"],
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653EE,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = ____E_914D_7F6E["位移距离"] / ____E_914D_7F6E["位移速度"] + ____E_914D_7F6E["观察持续秒"] + 2
    })
end
return ____exports
