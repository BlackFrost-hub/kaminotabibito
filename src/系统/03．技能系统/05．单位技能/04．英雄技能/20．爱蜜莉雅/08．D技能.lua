local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.00．配置")
local _____7231_871C_8389_96C5_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["爱蜜莉雅技能配置"]
local _____7231_871C_8389_96C5D_914D_7F6E = ____00_FF0E_914D_7F6E["爱蜜莉雅D配置"]
local _____7231_871C_8389_96C5_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["爱蜜莉雅表现配置"]
local _____7231_871C_8389_96C5_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["爱蜜莉雅音效配置"]
local ____20_FF0E_7231_871C_8389_96C5 = require("系统.05．Buff系统.03．Buff表.02．英雄.20．爱蜜莉雅")
local _____7231_871C_8389_96C5BuffID = ____20_FF0E_7231_871C_8389_96C5["爱蜜莉雅BuffID"]
local ____02_FF0E_516C_5171_72B6_6001_4E0E_51B0_6676 = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.02．公共状态与冰晶")
local _____8BBE_7F6E_7231_871C_8389_96C5D_5F3A_5316 = ____02_FF0E_516C_5171_72B6_6001_4E0E_51B0_6676["设置爱蜜莉雅D强化"]
local _____6E05_7406_7231_871C_8389_96C5D_5F3A_5316 = ____02_FF0E_516C_5171_72B6_6001_4E0E_51B0_6676["清理爱蜜莉雅D强化"]
local _____767B_8BB0_7231_871C_8389_96C5_6280_80FD_6E05_7406 = ____02_FF0E_516C_5171_72B6_6001_4E0E_51B0_6676["登记爱蜜莉雅技能清理"]
local ____02_FF0E_516C_5171_72B6_6001_4E0E_51B0_6676 = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.02．公共状态与冰晶")
local _____64AD_653E_7231_871C_8389_96C5_52A8_4F5C = ____02_FF0E_516C_5171_72B6_6001_4E0E_51B0_6676["播放爱蜜莉雅动作"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.00．配置")
local _____7231_871C_8389_96C5_52A8_4F5C_69FD = ____00_FF0E_914D_7F6E["爱蜜莉雅动作槽"]
local ____require_result_0 = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话")
local _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD = ____require_result_0["播放英雄技能喊话"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_2["创建点特效"]
local createUnitEffect = ____require_result_2.createUnitEffect
local destroyUnitEffect = ____require_result_2.destroyUnitEffect
local _____8BBE_7F6E_7279_6548_7F29_653E = ____require_result_2["设置特效缩放"]
local ____require_result_3 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_3.Sound3DII_UnitPlayReuse
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_4["注册单位技能壳监听"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_5.addDelayedCallback
local removeDelayedCallback = ____require_result_5.removeDelayedCallback
local getGameTime = ____require_result_5.getGameTime
local _____82F1_96C4_5355_4F4D_7C7B_578BID = jass.FourCC(_____7231_871C_8389_96C5_6280_80FD_914D_7F6E["单位类型ID"])
local _____73AF_7ED5_7279_6548_952E = "爱蜜莉雅D环绕"
--- 每英雄 D 到期回调 ID（重复开启时先取消旧回调，防止旧回调提前清掉新 D 状态）
local ____D_5230_671F_56DE_8C03_8868 = {}
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____53D6_5355_4F4DID = ____require_result_6["取单位ID"]
--- 清理 D 表现与状态（到期/打断/死亡/R 收束共用；幂等）
____exports["结束爱蜜莉雅D"] = function(_____65BD_6CD5_8005)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 then
        return
    end
    local _____65E7ID = ____D_5230_671F_56DE_8C03_8868[_____53D6_5355_4F4DID(_____65BD_6CD5_8005)]
    if _____65E7ID ~= nil and _____65E7ID ~= 0 then
        removeDelayedCallback(_____65E7ID)
        __TS__Delete(
            ____D_5230_671F_56DE_8C03_8868,
            _____53D6_5355_4F4DID(_____65BD_6CD5_8005)
        )
    end
    destroyUnitEffect(_____65BD_6CD5_8005, _____73AF_7ED5_7279_6548_952E)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____65BD_6CD5_8005, _____7231_871C_8389_96C5BuffID["帕克显现"])
    _____6E05_7406_7231_871C_8389_96C5D_5F3A_5316(_____65BD_6CD5_8005)
end
local function _____91CA_653ED_5E15_514B_663E_73B0(_context, _____65BD_6CD5_8005, ______6280_80FD_5B9E_4F8BID)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 then
        return
    end
    local _____82F1_96C4ID = _____53D6_5355_4F4DID(_____65BD_6CD5_8005)
    _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD(_____65BD_6CD5_8005, "爱蜜莉雅", _____7231_871C_8389_96C5_6280_80FD_914D_7F6E.D["技能ID"])
    _____64AD_653E_7231_871C_8389_96C5_52A8_4F5C(_____65BD_6CD5_8005, _____7231_871C_8389_96C5_52A8_4F5C_69FD.D)
    local _____65E7_5230_671FID = ____D_5230_671F_56DE_8C03_8868[_____82F1_96C4ID]
    if _____65E7_5230_671FID ~= nil and _____65E7_5230_671FID ~= 0 then
        removeDelayedCallback(_____65E7_5230_671FID)
    end
    __TS__Delete(____D_5230_671F_56DE_8C03_8868, _____82F1_96C4ID)
    destroyUnitEffect(_____65BD_6CD5_8005, _____73AF_7ED5_7279_6548_952E)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____65BD_6CD5_8005, _____7231_871C_8389_96C5BuffID["帕克显现"])
    local _____6301_7EED_6BEB_79D2 = _____7231_871C_8389_96C5D_914D_7F6E["持续秒"] * 1000
    _____8BBE_7F6E_7231_871C_8389_96C5D_5F3A_5316(_____65BD_6CD5_8005, _____7231_871C_8389_96C5D_914D_7F6E["强化次数"], _____6301_7EED_6BEB_79D2)
    registerManualBuff(
        _____65BD_6CD5_8005,
        _____7231_871C_8389_96C5BuffID["帕克显现"],
        _____7231_871C_8389_96C5D_914D_7F6E["持续秒"],
        _____7231_871C_8389_96C5D_914D_7F6E["强化次数"],
        {stack = _____7231_871C_8389_96C5D_914D_7F6E["强化次数"]}
    )
    local _____73AF_7ED5_7279_6548 = createUnitEffect(
        _____65BD_6CD5_8005,
        "origin",
        _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["帕克环绕"]["模型路径"],
        _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["帕克环绕"]["持续秒"],
        _____73AF_7ED5_7279_6548_952E
    )
    _____8BBE_7F6E_7279_6548_7F29_653E(_____73AF_7ED5_7279_6548, _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["帕克环绕"]["缩放"])
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["扩散"]["模型路径"],
        RGB = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["扩散"].RGB,
        X = GetUnitX(_____65BD_6CD5_8005),
        Y = GetUnitY(_____65BD_6CD5_8005),
        Z = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["扩散"]["高度"],
        ["缩放"] = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["扩散"]["缩放"],
        ["持续秒"] = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["扩散"]["持续秒"]
    })
    Sound3DII_UnitPlayReuse(_____7231_871C_8389_96C5_97F3_6548_914D_7F6E["D显现"]["路径"], _____65BD_6CD5_8005, _____7231_871C_8389_96C5_97F3_6548_914D_7F6E["D显现"]["裁断距离"])
    local _____5230_671FID = addDelayedCallback(
        _____6301_7EED_6BEB_79D2,
        function()
            __TS__Delete(____D_5230_671F_56DE_8C03_8868, _____82F1_96C4ID)
            ____exports["结束爱蜜莉雅D"](_____65BD_6CD5_8005)
        end
    )
    ____D_5230_671F_56DE_8C03_8868[_____82F1_96C4ID] = _____5230_671FID
    local _____6CE8_9500 = _____767B_8BB0_7231_871C_8389_96C5_6280_80FD_6E05_7406(
        _____65BD_6CD5_8005,
        "D到期",
        function()
            local _____5F53_524DID = ____D_5230_671F_56DE_8C03_8868[_____82F1_96C4ID]
            if _____5F53_524DID ~= nil and _____5F53_524DID == _____5230_671FID then
                removeDelayedCallback(_____5F53_524DID)
                __TS__Delete(____D_5230_671F_56DE_8C03_8868, _____82F1_96C4ID)
            end
            ____exports["结束爱蜜莉雅D"](_____65BD_6CD5_8005)
        end
    )
    local ____ = _____6CE8_9500
end
____exports["注册爱蜜莉雅D"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "爱蜜莉雅-帕克显现（D）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____7231_871C_8389_96C5_6280_80FD_914D_7F6E.D["技能ID"],
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653ED_5E15_514B_663E_73B0,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = _____7231_871C_8389_96C5D_914D_7F6E["持续秒"]
    })
end
return ____exports
