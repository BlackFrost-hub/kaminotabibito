local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____53D6_82F1_96C4_72B6_6001, _____542F_52A8_9690_533F_8BA1_65F6, addDelayedCallbackSafe, removeDelayedCallbackSafe, getGameTime, registerManualBuff, _____5355_4F4D_5B58_6D3B, debugLogForce, _____9690_533FBuffID, _____88AB_52A8_914D_7F6E, GetHandleId, _____82F1_96C4_72B6_6001_8868, _____9690_533F_8BA1_65F6_56DE_8C03_8868, addDelayedCallback, removeDelayedCallback
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.00．配置")
local _____8299_8389_83B2_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲技能配置"]
local _____8299_8389_83B2Buff_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲Buff配置"]
local _____8299_8389_83B2_88AB_52A8_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲被动配置"]
local _____8299_8389_83B2_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲表现配置"]
function _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    local id = GetHandleId(_____82F1_96C4)
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[id]
    if _____72B6_6001 == nil then
        _____72B6_6001 = {
            ["芙莉莲"] = _____82F1_96C4,
            ["隐匿"] = false,
            ["最后活动时间"] = getGameTime(),
            ["重点目标"] = nil,
            ["解析到期"] = {["攻击"] = 0, ["防御"] = 0, ["位置"] = 0},
            ["解析完成"] = false,
            ["演算普攻到期"] = 0,
            ["技能清理表"] = {}
        }
        _____82F1_96C4_72B6_6001_8868[id] = _____72B6_6001
    end
    return _____72B6_6001
end
function _____542F_52A8_9690_533F_8BA1_65F6(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local id = GetHandleId(_____82F1_96C4)
    local _____65E7ID = _____9690_533F_8BA1_65F6_56DE_8C03_8868[id]
    if _____65E7ID ~= nil then
        removeDelayedCallbackSafe(_____65E7ID)
    end
    local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    local _____9759_6B62_500D_7387 = ____exports["花田判定接口"]["在花田内静止"](_____82F1_96C4) and _____88AB_52A8_914D_7F6E["花田隐匿恢复倍率"] or 1
    local _____9700_8981_6BEB_79D2 = _____88AB_52A8_914D_7F6E["隐匿静默秒"] / (_____9759_6B62_500D_7387 > 0 and _____9759_6B62_500D_7387 or 1) * 1000
    local _____56DE_8C03ID = addDelayedCallbackSafe(
        _____9700_8981_6BEB_79D2,
        function()
            _____9690_533F_8BA1_65F6_56DE_8C03_8868[id] = nil
            local s = _____82F1_96C4_72B6_6001_8868[id]
            if s == nil or s["隐匿"] then
                return
            end
            if not _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
                return
            end
            if getGameTime() - s["最后活动时间"] < _____88AB_52A8_914D_7F6E["隐匿静默秒"] / (_____9759_6B62_500D_7387 > 0 and _____9759_6B62_500D_7387 or 1) - 0.05 then
                return
            end
            debugLogForce(
                "芙莉莲-被动",
                "状态",
                "进入隐匿",
                "英雄",
                _____82F1_96C4
            )
            s["隐匿"] = true
            debugLogForce(
                "芙莉莲-被动",
                "Buff",
                "操作",
                "施加",
                "目标",
                _____82F1_96C4,
                "BuffID",
                _____9690_533FBuffID
            )
            registerManualBuff(
                _____82F1_96C4,
                _____9690_533FBuffID,
                9999,
                1,
                {stack = 1}
            )
        end
    )
    _____9690_533F_8BA1_65F6_56DE_8C03_8868[id] = _____56DE_8C03ID
    local ____ = _____72B6_6001
end
function addDelayedCallbackSafe(delayMs, callback)
    return addDelayedCallback(delayMs, callback)
end
function removeDelayedCallbackSafe(id)
    removeDelayedCallback(id)
end
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
getGameTime = ____require_result_1.getGameTime
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_2.registerDeathListener
local ____require_result_3 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local registerPlayerHeroListener = ____require_result_3.registerPlayerHeroListener
local ____require_result_4 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_4.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_4["移除单位指定Buff"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_5["创建点特效"]
local _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_5["创建单位坐标跟随特效"]
local _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_5["销毁单位坐标跟随特效"]
local ____require_result_6 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_6.registerAppliedFinalDamageListener
local ____require_result_7 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_7["造成技能伤害"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
_____5355_4F4D_5B58_6D3B = ____require_result_8["单位存活"]
local _____53D6_5355_4F4DID = ____require_result_8["取单位ID"]
local platformAbilityApi = require("平台扩展API取值")
local platformAbilityAction = require("平台扩展API动作")
local ____require_result_9 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_9.debugLogForce
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____8299_8389_83B2_6280_80FD_914D_7F6E["单位类型ID"])
local ____Q_6280_80FDID = stringToFourCCSafe(_____8299_8389_83B2_6280_80FD_914D_7F6E.Q["技能ID"])
local ____W_6280_80FDID = stringToFourCCSafe(_____8299_8389_83B2_6280_80FD_914D_7F6E.W["技能ID"])
_____9690_533FBuffID = _____8299_8389_83B2Buff_914D_7F6E["魔力隐匿"]
local _____89E3_6790_4E2DBuffID = _____8299_8389_83B2Buff_914D_7F6E["解析中"]
local _____89E3_6790_5B8C_6210BuffID = _____8299_8389_83B2Buff_914D_7F6E["解析完成"]
local _____6F14_7B97BuffID = _____8299_8389_83B2Buff_914D_7F6E["演算魔弹"]
_____88AB_52A8_914D_7F6E = _____8299_8389_83B2_88AB_52A8_914D_7F6E
GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
_____82F1_96C4_72B6_6001_8868 = {}
--- 花田判定接口（D 模块注入；默认无花田）
____exports["花田判定接口"] = {
    ["在花田内"] = function(______82F1_96C4)
        return false
    end,
    ["在花田内静止"] = function(______82F1_96C4)
        return false
    end
}
____exports["是芙莉莲"] = function(unit)
    return unit ~= nil and unit ~= 0 and jass.GetUnitTypeId(unit) == _____82F1_96C4_5355_4F4D_7C7B_578BID
end
____exports["登记芙莉莲清理"] = function(_____82F1_96C4, _____540D_79F0, _____6E05_7406)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)["技能清理表"][_____540D_79F0] = _____6E05_7406
end
--- 施法/普攻活动：解除隐匿并重置静默计时（Q/W/E/R/D 释放与普攻监听调用）
____exports["记录芙莉莲活动"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    if _____72B6_6001["隐匿"] then
        debugLogForce(
            "芙莉莲-被动",
            "Buff",
            "操作",
            "移除",
            "目标",
            _____82F1_96C4,
            "BuffID",
            _____9690_533FBuffID
        )
        _____72B6_6001["隐匿"] = false
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____9690_533FBuffID)
    end
    _____72B6_6001["最后活动时间"] = getGameTime()
    _____542F_52A8_9690_533F_8BA1_65F6(_____82F1_96C4)
end
--- 重新安排隐匿计时（D 花田静止检测变化时调用；按当前静止倍率重算静默期满，幂等）
____exports["重新安排隐匿计时"] = function(_____82F1_96C4)
    _____542F_52A8_9690_533F_8BA1_65F6(_____82F1_96C4)
end
--- Q/R 释放时快照隐匿状态（快照后由 记录芙莉莲活动 解除；本函数不改变状态）
____exports["快照隐匿"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return false
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____82F1_96C4)]
    return _____72B6_6001 ~= nil and _____72B6_6001["隐匿"]
end
_____9690_533F_8BA1_65F6_56DE_8C03_8868 = {}
local ____require_result_10 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_10.addDelayedCallback
removeDelayedCallback = ____require_result_10.removeDelayedCallback
--- 解析标记特效键（挂重点目标；目标切换/清理销毁）
local function _____89E3_6790_6807_8BB0_952E(_____8299_8389_83B2)
    return "芙莉莲解析标记-" .. tostring(GetHandleId(_____8299_8389_83B2))
end
--- 清理指定芙莉莲的重点目标解析（标记/Buff/完成状态；不触碰技能清理器）
local function _____6E05_7406_91CD_70B9_76EE_6807_89E3_6790(_____8299_8389_83B2, _____72B6_6001)
    if _____72B6_6001["重点目标"] ~= nil and _____72B6_6001["重点目标"] ~= 0 then
        debugLogForce(
            "芙莉莲-被动",
            "特效",
            "类型",
            "销毁",
            "路径",
            _____8299_8389_83B2_8868_73B0_914D_7F6E["解析标记"]["模型路径"]
        )
        _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(
            _____72B6_6001["重点目标"],
            _____89E3_6790_6807_8BB0_952E(_____8299_8389_83B2)
        )
        debugLogForce(
            "芙莉莲-被动",
            "Buff",
            "操作",
            "移除",
            "目标",
            _____72B6_6001["重点目标"],
            "BuffID",
            _____89E3_6790_4E2DBuffID
        )
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____72B6_6001["重点目标"], _____89E3_6790_4E2DBuffID)
        debugLogForce(
            "芙莉莲-被动",
            "Buff",
            "操作",
            "移除",
            "目标",
            _____72B6_6001["重点目标"],
            "BuffID",
            _____89E3_6790_5B8C_6210BuffID
        )
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____72B6_6001["重点目标"], _____89E3_6790_5B8C_6210BuffID)
    end
    _____72B6_6001["重点目标"] = nil
    _____72B6_6001["解析到期"] = {["攻击"] = 0, ["防御"] = 0, ["位置"] = 0}
    _____72B6_6001["解析完成"] = false
end
--- 施加解析：新重点目标先清理旧目标（解析/Buff/标记）；相同类型只刷新；
-- 两种不同解析记录后进入解析完成（Buff + 完成特效一次）。
____exports["施加解析"] = function(_____8299_8389_83B2, _____76EE_6807, _____7C7B_578B)
    if _____8299_8389_83B2 == nil or _____8299_8389_83B2 == 0 then
        return
    end
    if _____76EE_6807 == nil or _____76EE_6807 == 0 or not _____5355_4F4D_5B58_6D3B(_____76EE_6807) then
        return
    end
    local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____8299_8389_83B2)
    if _____72B6_6001["重点目标"] ~= nil and _____72B6_6001["重点目标"] ~= 0 and _____72B6_6001["重点目标"] ~= _____76EE_6807 then
        _____6E05_7406_91CD_70B9_76EE_6807_89E3_6790(_____8299_8389_83B2, _____72B6_6001)
    end
    _____72B6_6001["重点目标"] = _____76EE_6807
    local _____5230_671F = getGameTime() + _____88AB_52A8_914D_7F6E["解析持续秒"]
    local _____73B0_5728 = getGameTime()
    local _____5DF2_6709_7C7B_578B_6570 = (_____72B6_6001["解析到期"]["攻击"] > _____73B0_5728 and 1 or 0) + (_____72B6_6001["解析到期"]["防御"] > _____73B0_5728 and 1 or 0) + (_____72B6_6001["解析到期"]["位置"] > _____73B0_5728 and 1 or 0)
    if _____5DF2_6709_7C7B_578B_6570 >= 2 and not (_____72B6_6001["解析到期"][_____7C7B_578B] > _____73B0_5728) then
        return
    end
    _____72B6_6001["解析到期"][_____7C7B_578B] = _____5230_671F
    local _____6709_6548_7C7B_578B_6570 = (_____72B6_6001["解析到期"]["攻击"] > _____73B0_5728 and 1 or 0) + (_____72B6_6001["解析到期"]["防御"] > _____73B0_5728 and 1 or 0) + (_____72B6_6001["解析到期"]["位置"] > _____73B0_5728 and 1 or 0)
    _____72B6_6001["解析完成"] = _____6709_6548_7C7B_578B_6570 >= 2
    if _____72B6_6001["解析完成"] then
        debugLogForce(
            "芙莉莲-被动",
            "Buff",
            "操作",
            "施加",
            "目标",
            _____76EE_6807,
            "BuffID",
            _____89E3_6790_5B8C_6210BuffID
        )
        registerManualBuff(
            _____76EE_6807,
            _____89E3_6790_5B8C_6210BuffID,
            _____88AB_52A8_914D_7F6E["解析持续秒"],
            1,
            {stack = 1}
        )
        debugLogForce(
            "芙莉莲-被动",
            "特效",
            "类型",
            "创建",
            "路径",
            _____8299_8389_83B2_8868_73B0_914D_7F6E["解析完成"]["模型路径"]
        )
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["解析完成"]["模型路径"],
            RGB = _____8299_8389_83B2_8868_73B0_914D_7F6E["解析完成"].RGB,
            X = GetUnitX(_____76EE_6807),
            Y = GetUnitY(_____76EE_6807),
            Z = _____8299_8389_83B2_8868_73B0_914D_7F6E["解析完成"]["高度"],
            ["缩放"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["解析完成"]["缩放"],
            ["持续秒"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["解析完成"]["持续秒"]
        })
    else
        if _____6709_6548_7C7B_578B_6570 >= 1 then
            debugLogForce(
                "芙莉莲-被动",
                "Buff",
                "操作",
                "施加",
                "目标",
                _____76EE_6807,
                "BuffID",
                _____89E3_6790_4E2DBuffID
            )
            registerManualBuff(
                _____76EE_6807,
                _____89E3_6790_4E2DBuffID,
                _____88AB_52A8_914D_7F6E["解析持续秒"],
                _____6709_6548_7C7B_578B_6570,
                {stack = _____6709_6548_7C7B_578B_6570}
            )
        end
    end
    if _____6709_6548_7C7B_578B_6570 >= 1 then
        debugLogForce(
            "芙莉莲-被动",
            "特效",
            "类型",
            "创建",
            "路径",
            _____8299_8389_83B2_8868_73B0_914D_7F6E["解析标记"]["模型路径"]
        )
        local _____6807_8BB0 = _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548(
            _____76EE_6807,
            _____8299_8389_83B2_8868_73B0_914D_7F6E["解析标记"]["模型路径"],
            _____89E3_6790_6807_8BB0_952E(_____8299_8389_83B2),
            _____8299_8389_83B2_8868_73B0_914D_7F6E["解析标记"]["缩放"],
            _____8299_8389_83B2_8868_73B0_914D_7F6E["解析标记"]["高度"],
            nil,
            _____8299_8389_83B2_8868_73B0_914D_7F6E["解析标记"]["动画索引"],
            _____8299_8389_83B2_8868_73B0_914D_7F6E["解析标记"]["面向角度"],
            _____8299_8389_83B2_8868_73B0_914D_7F6E["解析标记"].RGB
        )
        local ____ = _____6807_8BB0
    end
end
--- 取当前重点解析目标（R 的 t0 解析快照用；无则 null）
____exports["取芙莉莲重点目标"] = function(_____8299_8389_83B2)
    if _____8299_8389_83B2 == nil or _____8299_8389_83B2 == 0 then
        return nil
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____8299_8389_83B2)]
    if _____72B6_6001 == nil or _____72B6_6001["重点目标"] == nil or _____72B6_6001["重点目标"] == 0 then
        return nil
    end
    if not _____5355_4F4D_5B58_6D3B(_____72B6_6001["重点目标"]) then
        return nil
    end
    local _____73B0_5728 = getGameTime()
    local _____6709_6548_7C7B_578B_6570 = (_____72B6_6001["解析到期"]["攻击"] > _____73B0_5728 and 1 or 0) + (_____72B6_6001["解析到期"]["防御"] > _____73B0_5728 and 1 or 0) + (_____72B6_6001["解析到期"]["位置"] > _____73B0_5728 and 1 or 0)
    if _____6709_6548_7C7B_578B_6570 <= 0 then
        return nil
    end
    return _____72B6_6001["重点目标"]
end
--- 目标是否持有指定解析（重点目标匹配且未到期）
____exports["有解析"] = function(_____8299_8389_83B2, _____76EE_6807, _____7C7B_578B)
    if _____8299_8389_83B2 == nil or _____76EE_6807 == nil or _____76EE_6807 == 0 then
        return false
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____8299_8389_83B2)]
    if _____72B6_6001 == nil or _____72B6_6001["重点目标"] == nil or _____72B6_6001["重点目标"] ~= _____76EE_6807 then
        return false
    end
    return _____72B6_6001["解析到期"][_____7C7B_578B] > getGameTime()
end
--- 目标是否解析完成（重点目标匹配 + 两种未到期解析；惰性，到期自动失效）
____exports["目标解析完成"] = function(_____8299_8389_83B2, _____76EE_6807)
    if _____8299_8389_83B2 == nil or _____76EE_6807 == nil or _____76EE_6807 == 0 then
        return false
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____8299_8389_83B2)]
    if _____72B6_6001 == nil or _____72B6_6001["重点目标"] ~= _____76EE_6807 then
        return false
    end
    local _____73B0_5728 = getGameTime()
    local _____6709_6548_7C7B_578B_6570 = (_____72B6_6001["解析到期"]["攻击"] > _____73B0_5728 and 1 or 0) + (_____72B6_6001["解析到期"]["防御"] > _____73B0_5728 and 1 or 0) + (_____72B6_6001["解析到期"]["位置"] > _____73B0_5728 and 1 or 0)
    return _____6709_6548_7C7B_578B_6570 >= 2
end
--- 原子消费解析完成（仅合法 Q/R 调用）：目标匹配且完成 → 清除该目标全部解析与完成状态。
-- 返回 true = 消费成功（调用方执行破防/穿透强化）。
____exports["尝试消费解析完成"] = function(_____8299_8389_83B2, _____76EE_6807)
    if _____8299_8389_83B2 == nil or _____76EE_6807 == nil or _____76EE_6807 == 0 then
        return false
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____8299_8389_83B2)]
    if _____72B6_6001 == nil or _____72B6_6001["重点目标"] ~= _____76EE_6807 then
        return false
    end
    local _____73B0_5728 = getGameTime()
    local _____6709_6548_7C7B_578B_6570 = (_____72B6_6001["解析到期"]["攻击"] > _____73B0_5728 and 1 or 0) + (_____72B6_6001["解析到期"]["防御"] > _____73B0_5728 and 1 or 0) + (_____72B6_6001["解析到期"]["位置"] > _____73B0_5728 and 1 or 0)
    if _____6709_6548_7C7B_578B_6570 < 2 then
        return false
    end
    _____6E05_7406_91CD_70B9_76EE_6807_89E3_6790(_____8299_8389_83B2, _____72B6_6001)
    return true
end
--- Q/W/E 真正成功后提供一次待强化普攻（演算魔弹窗口）
____exports["提供演算普攻"] = function(_____8299_8389_83B2)
    if _____8299_8389_83B2 == nil or _____8299_8389_83B2 == 0 then
        return
    end
    local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____8299_8389_83B2)
    _____72B6_6001["演算普攻到期"] = getGameTime() + _____88AB_52A8_914D_7F6E["演算普攻窗口秒"]
    debugLogForce(
        "芙莉莲-被动",
        "Buff",
        "操作",
        "施加",
        "目标",
        _____8299_8389_83B2,
        "BuffID",
        _____6F14_7B97BuffID
    )
    registerManualBuff(
        _____8299_8389_83B2,
        _____6F14_7B97BuffID,
        _____88AB_52A8_914D_7F6E["演算普攻窗口秒"],
        1,
        {stack = 1}
    )
end
--- 减少指定技能当前冷却（演算魔弹命中反馈）
local function _____51CF_5C11_6280_80FD_51B7_5374(_____82F1_96C4, _____6280_80FD_4EE3_7801, _____51CF_5C11_79D2)
    local _____5F53_524D = platformAbilityApi["技能_获取技能当前冷却时间"](_____82F1_96C4, _____6280_80FD_4EE3_7801)
    if _____5F53_524D <= 0 then
        return
    end
    local _____5269_4F59 = _____5F53_524D - _____51CF_5C11_79D2
    local _____65B0_51B7_5374 = _____5269_4F59 > 0 and _____5269_4F59 or 0
    local _____6700_5927_51B7_5374 = platformAbilityApi["技能_获取技能最大冷却时间"](_____82F1_96C4, _____6280_80FD_4EE3_7801)
    platformAbilityAction["技能_设置技能冷却时间"](_____82F1_96C4, _____6280_80FD_4EE3_7801, _____65B0_51B7_5374, _____6700_5927_51B7_5374)
end
local function _____5904_7406_8299_8389_83B2_666E_653B(target, attacker, appliedDamage, snapshot)
    if not ____exports["是芙莉莲"](attacker) then
        return
    end
    if snapshot == nil then
        return
    end
    if snapshot.isNormalAttack ~= true then
        return
    end
    if snapshot.isWrappedSkillDamage == true then
        return
    end
    if snapshot.originalAttacker ~= nil and snapshot.originalAttacker ~= attacker then
        return
    end
    ____exports["记录芙莉莲活动"](attacker)
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(attacker)]
    if _____72B6_6001 == nil or _____72B6_6001["演算普攻到期"] <= getGameTime() then
        return
    end
    if _____72B6_6001["重点目标"] == nil or _____72B6_6001["重点目标"] ~= target then
        return
    end
    local _____73B0_5728 = getGameTime()
    local _____6709_6548_7C7B_578B_6570 = (_____72B6_6001["解析到期"]["攻击"] > _____73B0_5728 and 1 or 0) + (_____72B6_6001["解析到期"]["防御"] > _____73B0_5728 and 1 or 0) + (_____72B6_6001["解析到期"]["位置"] > _____73B0_5728 and 1 or 0)
    if _____6709_6548_7C7B_578B_6570 <= 0 then
        return
    end
    _____72B6_6001["演算普攻到期"] = 0
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(attacker, _____6F14_7B97BuffID)
    local _____500D_7387 = _____6709_6548_7C7B_578B_6570 >= 2 and _____88AB_52A8_914D_7F6E["演算完成目标倍率"] or _____88AB_52A8_914D_7F6E["演算伤害倍率"]
    _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = attacker,
        ["目标"] = target,
        ["伤害"] = appliedDamage * _____500D_7387,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["标签"] = "芙莉莲-演算魔弹",
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = false
    })
    _____51CF_5C11_6280_80FD_51B7_5374(attacker, ____Q_6280_80FDID, _____88AB_52A8_914D_7F6E["演算冷却缩减秒"])
    _____51CF_5C11_6280_80FD_51B7_5374(attacker, ____W_6280_80FDID, _____88AB_52A8_914D_7F6E["演算冷却缩减秒"])
end
____exports["清理芙莉莲状态"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local id = GetHandleId(_____82F1_96C4)
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[id]
    if _____72B6_6001 == nil then
        return
    end
    local _____8BA1_65F6ID = _____9690_533F_8BA1_65F6_56DE_8C03_8868[id]
    if _____8BA1_65F6ID ~= nil then
        removeDelayedCallback(_____8BA1_65F6ID)
    end
    _____9690_533F_8BA1_65F6_56DE_8C03_8868[id] = nil
    _____6E05_7406_91CD_70B9_76EE_6807_89E3_6790(_____82F1_96C4, _____72B6_6001)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____9690_533FBuffID)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____6F14_7B97BuffID)
    for key in pairs(_____72B6_6001["技能清理表"]) do
        local _____6E05_7406 = _____72B6_6001["技能清理表"][key]
        if _____6E05_7406 ~= nil then
            _____6E05_7406()
        end
    end
    __TS__Delete(_____82F1_96C4_72B6_6001_8868, id)
end
local _____5DF2_6CE8_518C = false
____exports["注册芙莉莲被动"] = function()
    debugLogForce("芙莉莲-被动", "注册", "名称", "注册芙莉莲被动")
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    registerDeathListener(function(dyingUnit, _killingUnit)
        if dyingUnit == nil or dyingUnit == 0 then
            return
        end
        if ____exports["是芙莉莲"](dyingUnit) then
            ____exports["清理芙莉莲状态"](dyingUnit)
            return
        end
        for id in pairs(_____82F1_96C4_72B6_6001_8868) do
            do
                local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[id]
                if _____72B6_6001 == nil or _____72B6_6001["重点目标"] == nil then
                    goto __continue76
                end
                if _____72B6_6001["重点目标"] == dyingUnit or _____53D6_5355_4F4DID(_____72B6_6001["重点目标"]) == _____53D6_5355_4F4DID(dyingUnit) then
                    if _____72B6_6001["芙莉莲"] ~= nil then
                        _____6E05_7406_91CD_70B9_76EE_6807_89E3_6790(_____72B6_6001["芙莉莲"], _____72B6_6001)
                    end
                end
            end
            ::__continue76::
        end
    end)
    registerPlayerHeroListener(function(_player, hero)
        if ____exports["是芙莉莲"](hero) then
            _____53D6_82F1_96C4_72B6_6001(hero)
            _____542F_52A8_9690_533F_8BA1_65F6(hero)
        end
    end)
    registerAppliedFinalDamageListener(_____5904_7406_8299_8389_83B2_666E_653B)
end
____exports["芙莉莲被动模块"] = {["英雄ID"] = _____8299_8389_83B2_6280_80FD_914D_7F6E["单位类型ID"], ["注册"] = ____exports["注册芙莉莲被动"]}
return ____exports
