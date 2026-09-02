local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local _____53D6_5176_4ED6_5B58_6D3B_8282_70B9, _____4E24_7AEF_5230_671F_4E0A_754C, _____56DE_9988Q_51B7_5374, getGameTime, platformAbilityApi, platformAbilityAction, ____Q_6280_80FD_7C7B_578BID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.24．塞莉亚·克莱尔.00．配置")
local _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔技能配置"]
local _____585E_8389_4E9A_514B_83B1_5C14_8282_70B9_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔节点配置"]
local _____585E_8389_4E9A_514B_83B1_5C14_6F14_7B97_666E_653B_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔演算普攻配置"]
local _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔表现配置"]
local _____585E_8389_4E9A_514B_83B1_5C14_8FDE_63A5_8868_73B0 = ____00_FF0E_914D_7F6E["塞莉亚克莱尔连接表现"]
local _____585E_8389_4E9A_514B_83B1_5C14E_914D_7F6E = ____00_FF0E_914D_7F6E["塞莉亚克莱尔E配置"]
local ____24_FF0E_585E_8389_4E9A_B7_514B_83B1_5C14 = require("系统.05．Buff系统.03．Buff表.02．英雄.24．塞莉亚·克莱尔")
local _____585E_8389_4E9ABuffID = ____24_FF0E_585E_8389_4E9A_B7_514B_83B1_5C14["塞莉亚BuffID"]
function _____53D6_5176_4ED6_5B58_6D3B_8282_70B9(_____72B6_6001, _____81EA_8EAB)
    local now = getGameTime()
    do
        local i = 0
        while i < #_____72B6_6001["节点列表"] do
            do
                local _____8282_70B9 = _____72B6_6001["节点列表"][i + 1]
                if _____8282_70B9["序号"] == _____81EA_8EAB["序号"] then
                    goto __continue18
                end
                if _____8282_70B9["类型"] == _____81EA_8EAB["类型"] then
                    goto __continue18
                end
                if now >= _____8282_70B9["到期时间"] then
                    goto __continue18
                end
                return _____8282_70B9
            end
            ::__continue18::
            i = i + 1
        end
    end
    return nil
end
function _____4E24_7AEF_5230_671F_4E0A_754C(_____72B6_6001)
    local _____6700_5927 = 0
    do
        local i = 0
        while i < #_____72B6_6001["节点列表"] do
            if _____72B6_6001["节点列表"][i + 1]["到期时间"] > _____6700_5927 then
                _____6700_5927 = _____72B6_6001["节点列表"][i + 1]["到期时间"]
            end
            i = i + 1
        end
    end
    return _____6700_5927 + _____585E_8389_4E9A_514B_83B1_5C14_8282_70B9_914D_7F6E["存续毫秒"] / 2
end
function _____56DE_9988Q_51B7_5374(_____82F1_96C4, _____72B6_6001)
    local now = getGameTime()
    if now < _____72B6_6001["回馈下次可用时间"] then
        return
    end
    _____72B6_6001["回馈下次可用时间"] = now + _____585E_8389_4E9A_514B_83B1_5C14_6F14_7B97_666E_653B_914D_7F6E["回馈内部冷却毫秒"]
    local _____5F53_524D = platformAbilityApi["技能_获取技能当前冷却时间"](_____82F1_96C4, ____Q_6280_80FD_7C7B_578BID)
    if _____5F53_524D <= 0 then
        return
    end
    local _____7F29_51CF = _____5F53_524D - _____585E_8389_4E9A_514B_83B1_5C14_6F14_7B97_666E_653B_914D_7F6E["冷却缩减秒"]
    local _____6700_5927_51B7_5374 = platformAbilityApi["技能_获取技能最大冷却时间"](_____82F1_96C4, ____Q_6280_80FD_7C7B_578BID)
    platformAbilityAction["技能_设置技能冷却时间"](_____82F1_96C4, ____Q_6280_80FD_7C7B_578BID, _____7F29_51CF > 0 and _____7F29_51CF or 0, _____6700_5927_51B7_5374)
end
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local japi = require("jass.japi")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local AddLightningEx = jass.AddLightningEx
local DestroyLightning = jass.DestroyLightning
local SetLightningColor = jass.SetLightningColor
--- 特效坐标迁移暂无项目封装；按局部别名约定直接绑定 japi（仅 D 节点移动使用）。
local EXSetEffectXY = japi.EXSetEffectXY
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
getGameTime = ____require_result_2.getGameTime
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_3.addPeriodicCallback
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____53D6_5355_4F4DID = ____require_result_4["取单位ID"]
local _____5355_4F4D_5B58_6D3B = ____require_result_4["单位存活"]
local _____8DDD_79BB_5E73_65B9XY = ____require_result_4["距离平方XY"]
local _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9 = ____require_result_4["点到线段距离平方"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_4["读取单位攻击力"]
local ____require_result_5 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_5.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_5["移除单位指定Buff"]
local ____require_result_6 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_6.registerAppliedFinalDamageListener
local ____require_result_7 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_7["造成技能伤害"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_8["创建点特效"]
local _____9500_6BC1_70B9_7279_6548 = ____require_result_8["销毁点特效"]
local ____require_result_9 = require("系统.09．表现系统.15．世界坐标进度UI.01．世界坐标进度UI")
local _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI = ____require_result_9["销毁世界坐标进度UI"]
platformAbilityApi = require("平台扩展API取值")
platformAbilityAction = require("平台扩展API动作")
local ____require_result_10 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_10.debugLogForce
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E["单位类型ID"]
____Q_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____585E_8389_4E9A_514B_83B1_5C14_6280_80FD_914D_7F6E.Q["技能ID"])
local _____585E_8389_4E9A_72B6_6001_8868 = {}
local _____4E0B_4E00_5168_5C40_8282_70B9_5E8F_53F7 = 1
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
--- E 区域成员标记（目标句柄 → 覆盖区域数）。
-- 计数制：同一目标可能同时处于多名塞莉亚的阵内，进入 +1、离开 −1，归零摘除。
-- 由 05 区域周期维护，02/A3 只读查询。
local ____E_533A_57DF_76EE_6807_8868 = {}
local function _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    local id = _____53D6_5355_4F4DID(_____82F1_96C4)
    local _____72B6_6001 = _____585E_8389_4E9A_72B6_6001_8868[id]
    if _____72B6_6001 == nil then
        _____72B6_6001 = {
            ["节点列表"] = {},
            ["连接"] = nil,
            ["强化次数"] = 0,
            ["回馈下次可用时间"] = 0,
            ["R锁定"] = false,
            ["转写中"] = false,
            ["技能清理表"] = {},
            ["进度UI列表"] = {},
            ["已清理"] = false
        }
        _____585E_8389_4E9A_72B6_6001_8868[id] = _____72B6_6001
    end
    return _____72B6_6001
end
local function _____67E5_627E_72B6_6001(_____82F1_96C4)
    return _____585E_8389_4E9A_72B6_6001_8868[_____53D6_5355_4F4DID(_____82F1_96C4)]
end
--- 判断单位是否为塞莉亚·克莱尔
____exports["是塞莉亚克莱尔"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    return GetUnitTypeId(unit) == stringToFourCCSafe(_____82F1_96C4_5355_4F4D_7C7B_578BID)
end
local function _____5EFA_7ACB_8FDE_63A5_7EBF(_____8FDE_63A5, A, B)
    local z = _____585E_8389_4E9A_514B_83B1_5C14_8282_70B9_914D_7F6E["连接Z高度"]
    local _____53E5_67C4 = AddLightningEx(
        _____585E_8389_4E9A_514B_83B1_5C14_8FDE_63A5_8868_73B0["效果代码"],
        false,
        A.X,
        A.Y,
        z,
        B.X,
        B.Y,
        z
    )
    if _____53E5_67C4 ~= nil and _____53E5_67C4 ~= 0 then
        SetLightningColor(
            _____53E5_67C4,
            _____585E_8389_4E9A_514B_83B1_5C14_8FDE_63A5_8868_73B0.RGB["红"] / 255,
            _____585E_8389_4E9A_514B_83B1_5C14_8FDE_63A5_8868_73B0.RGB["绿"] / 255,
            _____585E_8389_4E9A_514B_83B1_5C14_8FDE_63A5_8868_73B0.RGB["蓝"] / 255,
            _____585E_8389_4E9A_514B_83B1_5C14_8FDE_63A5_8868_73B0.RGB["透明度"] / 255
        )
    end
    _____8FDE_63A5["闪电句柄"] = _____53E5_67C4
end
--- 关闭当前连接：可读取位先失效，再销毁连线。
local function _____5173_95ED_8FDE_63A5(_____72B6_6001)
    local _____8FDE_63A5 = _____72B6_6001["连接"]
    if _____8FDE_63A5 == nil then
        return
    end
    _____8FDE_63A5["可读取"] = false
    if _____8FDE_63A5["闪电句柄"] ~= nil and _____8FDE_63A5["闪电句柄"] ~= 0 then
        DestroyLightning(_____8FDE_63A5["闪电句柄"])
        _____8FDE_63A5["闪电句柄"] = nil
    end
    _____72B6_6001["连接"] = nil
end
--- 在新节点与其余异型存活节点之间尝试建立唯一连接（距离须合法）。
local function _____5C1D_8BD5_5EFA_7ACB_8FDE_63A5(_____72B6_6001, _____65B0_8282_70B9)
    if _____72B6_6001["连接"] ~= nil then
        return
    end
    local _____5176_4ED6 = _____53D6_5176_4ED6_5B58_6D3B_8282_70B9(_____72B6_6001, _____65B0_8282_70B9)
    if _____5176_4ED6 == nil then
        return
    end
    local maxDistSq = _____585E_8389_4E9A_514B_83B1_5C14_8282_70B9_914D_7F6E["连接距离"] * _____585E_8389_4E9A_514B_83B1_5C14_8282_70B9_914D_7F6E["连接距离"]
    if _____8DDD_79BB_5E73_65B9XY(_____65B0_8282_70B9.X, _____65B0_8282_70B9.Y, _____5176_4ED6.X, _____5176_4ED6.Y) > maxDistSq then
        return
    end
    local _____8FDE_63A5 = {
        ["A序号"] = _____65B0_8282_70B9["序号"],
        ["B序号"] = _____5176_4ED6["序号"],
        ["A类型"] = _____65B0_8282_70B9["类型"],
        ["B类型"] = _____5176_4ED6["类型"],
        ["可读取"] = true,
        ["闪电句柄"] = nil
    }
    _____5EFA_7ACB_8FDE_63A5_7EBF(_____8FDE_63A5, _____65B0_8282_70B9, _____5176_4ED6)
    _____72B6_6001["连接"] = _____8FDE_63A5
end
local function _____53D6_5185_90E8_8282_70B9(_____72B6_6001, _____5E8F_53F7)
    do
        local i = 0
        while i < #_____72B6_6001["节点列表"] do
            if _____72B6_6001["节点列表"][i + 1]["序号"] == _____5E8F_53F7 then
                return _____72B6_6001["节点列表"][i + 1]
            end
            i = i + 1
        end
    end
    return nil
end
--- 内部销毁：仅操作状态对象（供周期清扫使用，无需英雄句柄）。
local function _____9500_6BC1_5185_90E8_8282_70B9(_____72B6_6001, _____5E8F_53F7)
    local _____76EE_6807_7D22_5F15 = -1
    do
        local i = 0
        while i < #_____72B6_6001["节点列表"] do
            if _____72B6_6001["节点列表"][i + 1]["序号"] == _____5E8F_53F7 then
                _____76EE_6807_7D22_5F15 = i
                break
            end
            i = i + 1
        end
    end
    if _____76EE_6807_7D22_5F15 < 0 then
        return false
    end
    local _____8FDE_63A5 = _____72B6_6001["连接"]
    if _____8FDE_63A5 ~= nil and (_____8FDE_63A5["A序号"] == _____5E8F_53F7 or _____8FDE_63A5["B序号"] == _____5E8F_53F7) then
        _____5173_95ED_8FDE_63A5(_____72B6_6001)
    end
    local _____8282_70B9 = __TS__ArraySplice(_____72B6_6001["节点列表"], _____76EE_6807_7D22_5F15, 1)[1]
    _____9500_6BC1_70B9_7279_6548(_____8282_70B9["特效句柄"])
    return true
end
--- 安全销毁单个节点：其所在连接先失效关闭，再销毁特效与引用。
____exports["销毁塞莉亚节点按序号"] = function(_____82F1_96C4, _____5E8F_53F7)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    if _____72B6_6001 == nil then
        return false
    end
    return _____9500_6BC1_5185_90E8_8282_70B9(_____72B6_6001, _____5E8F_53F7)
end
local function _____6E05_7406_8FC7_671F_8282_70B9(_____72B6_6001)
    local now = getGameTime()
    local i = 0
    while i < #_____72B6_6001["节点列表"] do
        if now >= _____72B6_6001["节点列表"][i + 1]["到期时间"] then
            _____9500_6BC1_5185_90E8_8282_70B9(_____72B6_6001, _____72B6_6001["节点列表"][i + 1]["序号"])
        else
            i = i + 1
        end
    end
end
--- 全体过期清扫（周期驱动）：玩家不操作时节点也会按 存续毫秒 自动消失，
-- 连接线随节点销毁一并关闭，不再依赖后续查询惰性清理。
local function ____on_585E_8389_4E9A_8282_70B9_6E05_626B()
    for id in pairs(_____585E_8389_4E9A_72B6_6001_8868) do
        do
            local _____72B6_6001 = _____585E_8389_4E9A_72B6_6001_8868[id]
            if _____72B6_6001 == nil or _____72B6_6001["已清理"] then
                goto __continue39
            end
            _____6E05_7406_8FC7_671F_8282_70B9(_____72B6_6001)
        end
        ::__continue39::
    end
end
--- 在真实坐标创建节点；超上限时安全替换最旧节点及其连接，再加入新节点，
-- 最后尝试与其余异型存活节点建立连接。
____exports["创建塞莉亚节点"] = function(_____82F1_96C4, _____7C7B_578B, X, Y, _____6765_6E90_5B9E_4F8BID, _____5B58_7EED_6BEB_79D2)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or not _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
        return nil
    end
    local _____72B6_6001 = _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    if _____72B6_6001["已清理"] then
        return nil
    end
    _____6E05_7406_8FC7_671F_8282_70B9(_____72B6_6001)
    while #_____72B6_6001["节点列表"] >= _____585E_8389_4E9A_514B_83B1_5C14_8282_70B9_914D_7F6E["上限"] do
        _____9500_6BC1_5185_90E8_8282_70B9(_____72B6_6001, _____72B6_6001["节点列表"][1]["序号"])
    end
    local _____8282_70B9_8868_73B0 = _____7C7B_578B == "棱晶" and _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["公式节点棱晶"] or (_____7C7B_578B == "结界" and _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["公式节点结界"] or _____585E_8389_4E9A_514B_83B1_5C14_8868_73B0_914D_7F6E["公式节点锚定"])
    debugLogForce("塞莉亚-被动", "特效", "路径", _____8282_70B9_8868_73B0["模型路径"])
    local _____7279_6548_53E5_67C4 = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____8282_70B9_8868_73B0["模型路径"],
        RGB = _____8282_70B9_8868_73B0.RGB,
        X = X,
        Y = Y,
        Z = _____8282_70B9_8868_73B0["高度"],
        ["缩放"] = _____8282_70B9_8868_73B0["缩放"],
        ["持续秒"] = _____8282_70B9_8868_73B0["持续秒"]
    })
    if _____7279_6548_53E5_67C4 == nil or _____7279_6548_53E5_67C4 == 0 then
        return nil
    end
    local ____4E0B_4E00_5168_5C40_8282_70B9_5E8F_53F7_11 = _____4E0B_4E00_5168_5C40_8282_70B9_5E8F_53F7
    _____4E0B_4E00_5168_5C40_8282_70B9_5E8F_53F7 = ____4E0B_4E00_5168_5C40_8282_70B9_5E8F_53F7_11 + 1
    local _____8282_70B9 = {
        ["序号"] = ____4E0B_4E00_5168_5C40_8282_70B9_5E8F_53F7_11,
        ["类型"] = _____7C7B_578B,
        X = X,
        Y = Y,
        ["来源实例ID"] = _____6765_6E90_5B9E_4F8BID,
        ["到期时间"] = getGameTime() + (_____5B58_7EED_6BEB_79D2 ~= nil and _____5B58_7EED_6BEB_79D2 > 0 and _____5B58_7EED_6BEB_79D2 or _____585E_8389_4E9A_514B_83B1_5C14_8282_70B9_914D_7F6E["存续毫秒"]),
        ["特效句柄"] = _____7279_6548_53E5_67C4
    }
    local ____72B6_6001__8282_70B9_5217_8868_12 = _____72B6_6001["节点列表"]
    ____72B6_6001__8282_70B9_5217_8868_12[#____72B6_6001__8282_70B9_5217_8868_12 + 1] = _____8282_70B9
    _____5C1D_8BD5_5EFA_7ACB_8FDE_63A5(_____72B6_6001, _____8282_70B9)
    return _____8282_70B9
end
--- 查询存活节点副本（惰性剔除过期）。
____exports["查询塞莉亚节点"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    if _____72B6_6001 == nil then
        return {}
    end
    _____6E05_7406_8FC7_671F_8282_70B9(_____72B6_6001)
    local _____7ED3_679C = {}
    do
        local i = 0
        while i < #_____72B6_6001["节点列表"] do
            _____7ED3_679C[#_____7ED3_679C + 1] = _____72B6_6001["节点列表"][i + 1]
            i = i + 1
        end
    end
    return _____7ED3_679C
end
____exports["取塞莉亚节点按序号"] = function(_____82F1_96C4, _____5E8F_53F7)
    local _____5217_8868 = ____exports["查询塞莉亚节点"](_____82F1_96C4)
    do
        local i = 0
        while i < #_____5217_8868 do
            if _____5217_8868[i + 1]["序号"] == _____5E8F_53F7 then
                return _____5217_8868[i + 1]
            end
            i = i + 1
        end
    end
    return nil
end
--- 读取当前有效连接的只读快照（两端节点必须仍在有效期内）。
____exports["查询塞莉亚有效连接"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    if _____72B6_6001 == nil or _____72B6_6001["连接"] == nil then
        return nil
    end
    _____6E05_7406_8FC7_671F_8282_70B9(_____72B6_6001)
    local _____8FDE_63A5 = _____72B6_6001["连接"]
    if _____8FDE_63A5 == nil then
        return nil
    end
    local A = _____53D6_5185_90E8_8282_70B9(_____72B6_6001, _____8FDE_63A5["A序号"])
    local B = _____53D6_5185_90E8_8282_70B9(_____72B6_6001, _____8FDE_63A5["B序号"])
    if A == nil or B == nil then
        return nil
    end
    return {
        ["A序号"] = A["序号"],
        ["B序号"] = B["序号"],
        ["A类型"] = A["类型"],
        ["B类型"] = B["类型"],
        ["可读取"] = _____8FDE_63A5["可读取"]
    }
end
--- 原子消费连接：只有一次调用能把 可读取 从 true 翻转为 false 并关闭连线。
-- R 分支入口必须走这里，防止多个异步回调重复消费同一条连接。
____exports["消费塞莉亚连接"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    if _____72B6_6001 == nil or _____72B6_6001["连接"] == nil or not _____72B6_6001["连接"]["可读取"] then
        return nil
    end
    local _____5FEB_7167 = ____exports["查询塞莉亚有效连接"](_____82F1_96C4)
    if _____5FEB_7167 == nil then
        return nil
    end
    _____72B6_6001["连接"]["可读取"] = false
    _____5173_95ED_8FDE_63A5(_____72B6_6001)
    return _____5FEB_7167
end
--- D 术式转写事务：校验 → R 锁检查 → 关闭旧连接 → 更新坐标与特效 → 重算连接 → 解锁。
-- 任一步失败恢复原状或安全收口，不留半条连接。
____exports["转写塞莉亚节点事务"] = function(_____82F1_96C4, _____8282_70B9_5E8F_53F7, _____65B0X, _____65B0Y)
    local _____72B6_6001 = _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    if _____72B6_6001["已清理"] or _____72B6_6001["R锁定"] or _____72B6_6001["转写中"] then
        return false
    end
    _____6E05_7406_8FC7_671F_8282_70B9(_____72B6_6001)
    local _____8282_70B9 = _____53D6_5185_90E8_8282_70B9(_____72B6_6001, _____8282_70B9_5E8F_53F7)
    if _____8282_70B9 == nil then
        return false
    end
    _____72B6_6001["转写中"] = true
    _____5173_95ED_8FDE_63A5(_____72B6_6001)
    _____8282_70B9.X = _____65B0X
    _____8282_70B9.Y = _____65B0Y
    if EXSetEffectXY ~= nil then
        EXSetEffectXY(_____8282_70B9["特效句柄"], _____65B0X, _____65B0Y)
    end
    _____5C1D_8BD5_5EFA_7ACB_8FDE_63A5(_____72B6_6001, _____8282_70B9)
    _____72B6_6001["转写中"] = false
    return true
end
____exports["锁定塞莉亚R"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    if _____72B6_6001["R锁定"] then
        return false
    end
    _____72B6_6001["R锁定"] = true
    return true
end
____exports["解除塞莉亚R锁定"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    if _____72B6_6001 == nil then
        return
    end
    _____72B6_6001["R锁定"] = false
end
____exports["是否塞莉亚R锁定中"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    return _____72B6_6001 ~= nil and _____72B6_6001["R锁定"]
end
--- Q/W/E 施法真正成功后调用：累积一次演算窗口（受上限约束）并同步 Buff。
____exports["授予塞莉亚演算窗口"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    if _____72B6_6001["已清理"] then
        return
    end
    if _____72B6_6001["强化次数"] >= _____585E_8389_4E9A_514B_83B1_5C14_6F14_7B97_666E_653B_914D_7F6E["强化上限"] then
        return
    end
    _____72B6_6001["强化次数"] = _____72B6_6001["强化次数"] + 1
    debugLogForce(
        "塞莉亚-被动",
        "Buff",
        "操作",
        "施加",
        "目标",
        _____82F1_96C4
    )
    registerManualBuff(
        _____82F1_96C4,
        _____585E_8389_4E9ABuffID["演算魔弹"],
        8,
        _____72B6_6001["强化次数"],
        {stack = _____72B6_6001["强化次数"]}
    )
end
local function _____6D88_8017_585E_8389_4E9A_6F14_7B97_7A97_53E3(_____82F1_96C4, _____72B6_6001)
    if _____72B6_6001["强化次数"] <= 0 then
        return
    end
    _____72B6_6001["强化次数"] = _____72B6_6001["强化次数"] - 1
    if _____72B6_6001["强化次数"] <= 0 then
        _____72B6_6001["强化次数"] = 0
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____585E_8389_4E9ABuffID["演算魔弹"])
    else
        registerManualBuff(
            _____82F1_96C4,
            _____585E_8389_4E9ABuffID["演算魔弹"],
            8,
            _____72B6_6001["强化次数"],
            {stack = _____72B6_6001["强化次数"]}
        )
    end
end
--- E 区域进入/离开维护（05 调用）；成员死亡由统一死亡入口递减。
____exports["标记目标在塞莉亚E区域"] = function(_____76EE_6807)
    if _____76EE_6807 == nil or _____76EE_6807 == 0 then
        return
    end
    local id = _____53D6_5355_4F4DID(_____76EE_6807)
    ____E_533A_57DF_76EE_6807_8868[id] = (____E_533A_57DF_76EE_6807_8868[id] or 0) + 1
end
____exports["取消标记目标在塞莉亚E区域"] = function(_____76EE_6807)
    if _____76EE_6807 == nil or _____76EE_6807 == 0 then
        return
    end
    local id = _____53D6_5355_4F4DID(_____76EE_6807)
    local _____8BA1_6570 = ____E_533A_57DF_76EE_6807_8868[id]
    if _____8BA1_6570 == nil then
        return
    end
    if _____8BA1_6570 <= 1 then
        __TS__Delete(____E_533A_57DF_76EE_6807_8868, id)
    else
        ____E_533A_57DF_76EE_6807_8868[id] = _____8BA1_6570 - 1
    end
end
____exports["目标在塞莉亚E区域"] = function(_____76EE_6807)
    if _____76EE_6807 == nil or _____76EE_6807 == 0 then
        return false
    end
    return (____E_533A_57DF_76EE_6807_8868[_____53D6_5355_4F4DID(_____76EE_6807)] or 0) > 0
end
local _____9635_5185_89E3_6790_4E0A_6B21_65F6_95F4 = {}
local function _____9020_6210_585E_8389_4E9A_6F14_7B97_4F24_5BB3(_____65BD_6CD5_8005, _____76EE_6807, _____4F24_5BB3_503C, _____6807_7B7E)
    return _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = _____65BD_6CD5_8005,
        ["目标"] = _____76EE_6807,
        ["伤害"] = _____4F24_5BB3_503C,
        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["标签"] = _____6807_7B7E,
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = false
    })
end
local function _____5904_7406_585E_8389_4E9A_6F14_7B97_666E_653B(target, attacker, snapshot, _____72B6_6001)
    if target == nil or target == 0 then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    local ____opt_result_15
    if snapshot ~= nil then
        ____opt_result_15 = snapshot.isNormalAttack
    end
    if ____opt_result_15 ~= true then
        return
    end
    local ____opt_result_18
    if snapshot ~= nil then
        ____opt_result_18 = snapshot.isWrappedSkillDamage
    end
    if ____opt_result_18 == true then
        return
    end
    local ____opt_result_21
    if snapshot ~= nil then
        ____opt_result_21 = snapshot.originalAttacker
    end
    if ____opt_result_21 ~= nil and snapshot.originalAttacker ~= attacker then
        return
    end
    if _____72B6_6001["已清理"] or _____72B6_6001["强化次数"] <= 0 then
        return
    end
    _____6E05_7406_8FC7_671F_8282_70B9(_____72B6_6001)
    if #_____72B6_6001["节点列表"] <= 0 then
        return
    end
    local px = GetUnitX(target)
    local py = GetUnitY(target)
    local _____5224_5B9A_5E73_65B9 = _____585E_8389_4E9A_514B_83B1_5C14_6F14_7B97_666E_653B_914D_7F6E["判定半径"] * _____585E_8389_4E9A_514B_83B1_5C14_6F14_7B97_666E_653B_914D_7F6E["判定半径"]
    local _____8FD1_8282_70B9 = false
    do
        local i = 0
        while i < #_____72B6_6001["节点列表"] do
            if _____8DDD_79BB_5E73_65B9XY(px, py, _____72B6_6001["节点列表"][i + 1].X, _____72B6_6001["节点列表"][i + 1].Y) <= _____5224_5B9A_5E73_65B9 then
                _____8FD1_8282_70B9 = true
                break
            end
            i = i + 1
        end
    end
    local _____8FD1_8FDE_63A5 = false
    local _____8FDE_63A5 = _____72B6_6001["连接"]
    if not _____8FD1_8282_70B9 and _____8FDE_63A5 ~= nil then
        local A = _____53D6_5185_90E8_8282_70B9(_____72B6_6001, _____8FDE_63A5["A序号"])
        local B = _____53D6_5185_90E8_8282_70B9(_____72B6_6001, _____8FDE_63A5["B序号"])
        if A ~= nil and B ~= nil then
            _____8FD1_8FDE_63A5 = _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9(
                px,
                py,
                A.X,
                A.Y,
                B.X,
                B.Y
            ) <= _____5224_5B9A_5E73_65B9
        end
    end
    if not _____8FD1_8282_70B9 and not _____8FD1_8FDE_63A5 then
        return
    end
    local _____653B_51FB_529B = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(attacker)
    local _____8FFD_52A0_4F24_5BB3 = _____653B_51FB_529B * _____585E_8389_4E9A_514B_83B1_5C14_6F14_7B97_666E_653B_914D_7F6E["追加伤害攻击力倍率"]
    _____9020_6210_585E_8389_4E9A_6F14_7B97_4F24_5BB3(attacker, target, _____8FFD_52A0_4F24_5BB3, "塞莉亚-演算完成")
    if _____8FD1_8FDE_63A5 and _____72B6_6001["连接"] ~= nil then
        local _____4E24_7AEF_6700_665A_4E0A_754C = _____4E24_7AEF_5230_671F_4E0A_754C(_____72B6_6001)
        local _____65B0A = _____53D6_5185_90E8_8282_70B9(_____72B6_6001, _____72B6_6001["连接"]["A序号"])
        local _____65B0B = _____53D6_5185_90E8_8282_70B9(_____72B6_6001, _____72B6_6001["连接"]["B序号"])
        if _____65B0A ~= nil and _____65B0A["到期时间"] + _____585E_8389_4E9A_514B_83B1_5C14_6F14_7B97_666E_653B_914D_7F6E["连接延长毫秒"] <= _____4E24_7AEF_6700_665A_4E0A_754C then
            _____65B0A["到期时间"] = _____65B0A["到期时间"] + _____585E_8389_4E9A_514B_83B1_5C14_6F14_7B97_666E_653B_914D_7F6E["连接延长毫秒"]
        end
        if _____65B0B ~= nil and _____65B0B["到期时间"] + _____585E_8389_4E9A_514B_83B1_5C14_6F14_7B97_666E_653B_914D_7F6E["连接延长毫秒"] <= _____4E24_7AEF_6700_665A_4E0A_754C then
            _____65B0B["到期时间"] = _____65B0B["到期时间"] + _____585E_8389_4E9A_514B_83B1_5C14_6F14_7B97_666E_653B_914D_7F6E["连接延长毫秒"]
        end
        _____56DE_9988Q_51B7_5374(attacker, _____72B6_6001)
    end
    if ____exports["目标在塞莉亚E区域"](target) then
        local tid = _____53D6_5355_4F4DID(target)
        local now = getGameTime()
        local _____4E0A_6B21 = _____9635_5185_89E3_6790_4E0A_6B21_65F6_95F4[tid] or 0
        if now - _____4E0A_6B21 >= _____585E_8389_4E9A_514B_83B1_5C14E_914D_7F6E["阵内解析内部冷却毫秒"] then
            _____9635_5185_89E3_6790_4E0A_6B21_65F6_95F4[tid] = now
            _____9020_6210_585E_8389_4E9A_6F14_7B97_4F24_5BB3(attacker, target, _____653B_51FB_529B * _____585E_8389_4E9A_514B_83B1_5C14E_914D_7F6E["阵内追加解析倍率"], "塞莉亚-阵内解析")
        end
    end
    _____6D88_8017_585E_8389_4E9A_6F14_7B97_7A97_53E3(attacker, _____72B6_6001)
end
____exports["登记塞莉亚技能清理"] = function(_____82F1_96C4, _____6807_7B7E, _____6E05_7406)
    local _____72B6_6001 = _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    _____72B6_6001["技能清理表"][_____6807_7B7E] = _____6E05_7406
    return function()
        local _____5F53_524D = _____585E_8389_4E9A_72B6_6001_8868[_____53D6_5355_4F4DID(_____82F1_96C4)]
        if _____5F53_524D ~= nil and _____5F53_524D["技能清理表"][_____6807_7B7E] == _____6E05_7406 then
            __TS__Delete(_____5F53_524D["技能清理表"], _____6807_7B7E)
        end
    end
end
____exports["登记塞莉亚进度UI"] = function(_____82F1_96C4, ui)
    if ui == nil or ui == 0 then
        return
    end
    local _____72B6_6001 = _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    do
        local i = 0
        while i < #_____72B6_6001["进度UI列表"] do
            if _____72B6_6001["进度UI列表"][i + 1] == ui then
                return
            end
            i = i + 1
        end
    end
    local ____72B6_6001__8FDB_5EA6UI_5217_8868_22 = _____72B6_6001["进度UI列表"]
    ____72B6_6001__8FDB_5EA6UI_5217_8868_22[#____72B6_6001__8FDB_5EA6UI_5217_8868_22 + 1] = ui
end
____exports["销毁塞莉亚进度UI"] = function(_____82F1_96C4, ui)
    if ui == nil or ui == 0 then
        return
    end
    _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI(ui)
    local _____72B6_6001 = _____67E5_627E_72B6_6001(_____82F1_96C4)
    if _____72B6_6001 == nil then
        return
    end
    do
        local i = 0
        while i < #_____72B6_6001["进度UI列表"] do
            if _____72B6_6001["进度UI列表"][i + 1] == ui then
                __TS__ArraySplice(_____72B6_6001["进度UI列表"], i, 1)
                return
            end
            i = i + 1
        end
    end
end
local function _____6E05_7406_5168_90E8_8FDB_5EA6UI(_____72B6_6001)
    while #_____72B6_6001["进度UI列表"] > 0 do
        local ui = _____72B6_6001["进度UI列表"][1]
        __TS__ArraySplice(_____72B6_6001["进度UI列表"], 0, 1)
        _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI(ui)
    end
end
local function _____6267_884C_5168_90E8_6280_80FD_6E05_7406(_____72B6_6001)
    for _____6807_7B7E in pairs(_____72B6_6001["技能清理表"]) do
        local _____6E05_7406 = _____72B6_6001["技能清理表"][_____6807_7B7E]
        if _____6E05_7406 ~= nil then
            _____6E05_7406()
        end
    end
    for _____6807_7B7E in pairs(_____72B6_6001["技能清理表"]) do
        __TS__Delete(_____72B6_6001["技能清理表"], _____6807_7B7E)
    end
end
--- 复位单个状态数据。英雄可为 null（地图清理场景无句柄反查能力，
-- TSTL 不提供 id→unit 反查）：此时跳过依赖存活判定的 Buff 移除。
local function _____590D_4F4D_72B6_6001_6570_636E(_____82F1_96C4, _____72B6_6001)
    _____6267_884C_5168_90E8_6280_80FD_6E05_7406(_____72B6_6001)
    _____5173_95ED_8FDE_63A5(_____72B6_6001)
    while #_____72B6_6001["节点列表"] > 0 do
        local _____8282_70B9 = _____72B6_6001["节点列表"][1]
        __TS__ArraySplice(_____72B6_6001["节点列表"], 0, 1)
        _____9500_6BC1_70B9_7279_6548(_____8282_70B9["特效句柄"])
    end
    _____72B6_6001["强化次数"] = 0
    _____72B6_6001["R锁定"] = false
    _____72B6_6001["转写中"] = false
    _____6E05_7406_5168_90E8_8FDB_5EA6UI(_____72B6_6001)
    if _____82F1_96C4 ~= nil and _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____585E_8389_4E9ABuffID["演算魔弹"])
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____585E_8389_4E9ABuffID["解析结界"])
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____585E_8389_4E9ABuffID["高阶术式蓄力"])
    end
end
____exports["清理塞莉亚状态"] = function(_____82F1_96C4, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "主动清理"
    end
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return false
    end
    local id = _____53D6_5355_4F4DID(_____82F1_96C4)
    local _____72B6_6001 = _____585E_8389_4E9A_72B6_6001_8868[id]
    if _____72B6_6001 == nil then
        return false
    end
    if _____72B6_6001["已清理"] then
        return true
    end
    _____72B6_6001["已清理"] = true
    local ____ = _____539F_56E0
    _____590D_4F4D_72B6_6001_6570_636E(_____82F1_96C4, _____72B6_6001)
    __TS__Delete(_____585E_8389_4E9A_72B6_6001_8868, id)
    return true
end
____exports["清理全部塞莉亚状态"] = function(_____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "地图清理"
    end
    local _____6570_91CF = 0
    local ids = {}
    for id in pairs(_____585E_8389_4E9A_72B6_6001_8868) do
        ids[#ids + 1] = __TS__Number(id)
    end
    do
        local i = 0
        while i < #ids do
            do
                local _____72B6_6001 = _____585E_8389_4E9A_72B6_6001_8868[ids[i + 1]]
                if _____72B6_6001 == nil or _____72B6_6001["已清理"] then
                    goto __continue147
                end
                _____72B6_6001["已清理"] = true
                local ____ = _____539F_56E0
                _____590D_4F4D_72B6_6001_6570_636E(nil, _____72B6_6001)
                __TS__Delete(_____585E_8389_4E9A_72B6_6001_8868, ids[i + 1])
                _____6570_91CF = _____6570_91CF + 1
            end
            ::__continue147::
            i = i + 1
        end
    end
    return _____6570_91CF
end
--- 仅供测试/调试：登记中的塞莉亚数量、节点总数与活跃连接数。
____exports["获取塞莉亚状态统计"] = function()
    local _____82F1_96C4_6570 = 0
    local _____8282_70B9_603B_6570 = 0
    local _____8FDE_63A5_6570 = 0
    for id in pairs(_____585E_8389_4E9A_72B6_6001_8868) do
        local _____72B6_6001 = _____585E_8389_4E9A_72B6_6001_8868[id]
        if _____72B6_6001 ~= nil then
            _____82F1_96C4_6570 = _____82F1_96C4_6570 + 1
            _____8282_70B9_603B_6570 = _____8282_70B9_603B_6570 + #_____72B6_6001["节点列表"]
            if _____72B6_6001["连接"] ~= nil then
                _____8FDE_63A5_6570 = _____8FDE_63A5_6570 + 1
            end
        end
    end
    return {["英雄数"] = _____82F1_96C4_6570, ["节点总数"] = _____8282_70B9_603B_6570, ["连接数"] = _____8FDE_63A5_6570}
end
local function _____786E_4FDD_6B7B_4EA1_76D1_542C()
    if _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
    registerDeathListener(function(dyingUnit, _killingUnit)
        if dyingUnit == nil or dyingUnit == 0 then
            return
        end
        if ____exports["是塞莉亚克莱尔"](dyingUnit) then
            debugLogForce(
                "塞莉亚-被动",
                "回调",
                "类型",
                "死亡",
                "单位",
                dyingUnit
            )
            ____exports["清理塞莉亚状态"](dyingUnit, "英雄死亡")
        end
        local diedId = _____53D6_5355_4F4DID(dyingUnit)
        __TS__Delete(____E_533A_57DF_76EE_6807_8868, diedId)
        __TS__Delete(_____9635_5185_89E3_6790_4E0A_6B21_65F6_95F4, diedId)
    end)
end
local _____666E_653B_8054_52A8_5DF2_6CE8_518C = false
local _____6E05_626B_5468_671F_5DF2_6CE8_518C = false
--- 注册被动入口（幂等）：死亡清理 + 演算普攻监听。
____exports["注册塞莉亚被动效果"] = function()
    debugLogForce("塞莉亚-被动", "注册", "名称", "注册塞莉亚被动效果")
    _____786E_4FDD_6B7B_4EA1_76D1_542C()
    if not _____6E05_626B_5468_671F_5DF2_6CE8_518C then
        _____6E05_626B_5468_671F_5DF2_6CE8_518C = true
        addPeriodicCallback(1000, ____on_585E_8389_4E9A_8282_70B9_6E05_626B)
    end
    if _____666E_653B_8054_52A8_5DF2_6CE8_518C then
        return
    end
    _____666E_653B_8054_52A8_5DF2_6CE8_518C = true
    registerAppliedFinalDamageListener(function(target, attacker, applied, snapshot)
        if attacker == nil or attacker == 0 then
            return
        end
        local _____72B6_6001 = _____585E_8389_4E9A_72B6_6001_8868[_____53D6_5355_4F4DID(attacker)]
        if _____72B6_6001 == nil then
            return
        end
        _____5904_7406_585E_8389_4E9A_6F14_7B97_666E_653B(target, attacker, snapshot, _____72B6_6001)
    end)
end
return ____exports
