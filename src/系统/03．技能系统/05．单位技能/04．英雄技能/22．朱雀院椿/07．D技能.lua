local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.22．朱雀院椿.00．配置")
local _____6731_96C0_9662_693F_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿技能配置"]
local _____6731_96C0_9662_693F_52A8_4F5C_69FD = ____00_FF0E_914D_7F6E["朱雀院椿动作槽"]
local _____6731_96C0_9662_693FD_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿D配置"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local removeDelayedCallback = ____require_result_1.removeDelayedCallback
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_2["注册单位技能壳监听"]
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.04．英雄技能.22．朱雀院椿.02．被动效果")
local _____662F_6731_96C0_9662_693F = ____require_result_3["是朱雀院椿"]
local _____83B7_53D6_59FF_6001 = ____require_result_3["获取姿态"]
local _____8BBE_7F6E_59FF_6001 = ____require_result_3["设置姿态"]
local _____59FF_6001_662F_5426_9501_5B9A = ____require_result_3["姿态是否锁定"]
local _____6263_9664VF = ____require_result_3["扣除VF"]
local _____6062_590DVF = ____require_result_3["恢复VF"]
local _____767B_8BB0_693F_6E05_7406 = ____require_result_3["登记椿清理"]
local _____64AD_653E_693F_52A8_4F5C = ____require_result_3["播放椿动作"]
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6731_96C0_9662_693F_6280_80FD_914D_7F6E["单位类型ID"])
local ____D_914D_7F6E = _____6731_96C0_9662_693FD_914D_7F6E
local _____4E8C_5200_72B6_6001_8868 = {}
local function _____505C_6B62_4E8C_5200_6D88_8017(_____82F1_96C4)
    local id = jass.GetHandleId(_____82F1_96C4)
    local _____72B6_6001 = _____4E8C_5200_72B6_6001_8868[id]
    if _____72B6_6001 == nil then
        return
    end
    if _____72B6_6001["到期回调ID"] ~= 0 then
        removeDelayedCallback(_____72B6_6001["到期回调ID"])
    end
    if _____72B6_6001["消耗周期ID"] ~= 0 then
        removePeriodicCallback(_____72B6_6001["消耗周期ID"])
    end
    __TS__Delete(_____4E8C_5200_72B6_6001_8868, id)
end
local function _____8FDB_5165_4E8C_5200_653B_52BF(_____65BD_6CD5_8005)
    _____8BBE_7F6E_59FF_6001(_____65BD_6CD5_8005, "二刀")
    _____505C_6B62_4E8C_5200_6D88_8017(_____65BD_6CD5_8005)
    local _____72B6_6001 = {["到期回调ID"] = 0, ["消耗周期ID"] = 0}
    _____72B6_6001["到期回调ID"] = addDelayedCallback(
        ____D_914D_7F6E["二刀持续秒"] * 1000,
        function()
            _____505C_6B62_4E8C_5200_6D88_8017(_____65BD_6CD5_8005)
            _____8BBE_7F6E_59FF_6001(_____65BD_6CD5_8005, "一刀")
        end
    )
    _____72B6_6001["消耗周期ID"] = addPeriodicCallback(
        1000,
        function()
            if not _____662F_6731_96C0_9662_693F(_____65BD_6CD5_8005) then
                _____505C_6B62_4E8C_5200_6D88_8017(_____65BD_6CD5_8005)
                return
            end
            local _____5269_4F59 = _____6263_9664VF(_____65BD_6CD5_8005, ____D_914D_7F6E["二刀每秒VF消耗"])
            if ____D_914D_7F6E["VF归零强制回一刀"] and _____5269_4F59 <= 0 then
                _____505C_6B62_4E8C_5200_6D88_8017(_____65BD_6CD5_8005)
                _____8BBE_7F6E_59FF_6001(_____65BD_6CD5_8005, "一刀")
            end
        end
    )
    _____4E8C_5200_72B6_6001_8868[jass.GetHandleId(_____65BD_6CD5_8005)] = _____72B6_6001
    _____767B_8BB0_693F_6E05_7406(
        _____65BD_6CD5_8005,
        "椿D二刀",
        function()
            _____505C_6B62_4E8C_5200_6D88_8017(_____65BD_6CD5_8005)
        end
    )
end
local function _____91CA_653ED_59FF_6001_5207_6362(_context, _____65BD_6CD5_8005, ______6280_80FD_5B9E_4F8BID)
    if not _____662F_6731_96C0_9662_693F(_____65BD_6CD5_8005) then
        return
    end
    if _____59FF_6001_662F_5426_9501_5B9A(_____65BD_6CD5_8005) then
        return
    end
    _____64AD_653E_693F_52A8_4F5C(_____65BD_6CD5_8005, _____6731_96C0_9662_693F_52A8_4F5C_69FD["D切换"])
    local _____5F53_524D = _____83B7_53D6_59FF_6001(_____65BD_6CD5_8005)
    if _____5F53_524D == "一刀" then
        _____8FDB_5165_4E8C_5200_653B_52BF(_____65BD_6CD5_8005)
    else
        _____505C_6B62_4E8C_5200_6D88_8017(_____65BD_6CD5_8005)
        _____8BBE_7F6E_59FF_6001(_____65BD_6CD5_8005, "一刀")
        _____6062_590DVF(_____65BD_6CD5_8005, ____D_914D_7F6E["切回一刀恢复VF"])
    end
end
local _____5DF2_6CE8_518C = false
____exports["注册朱雀院椿D"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "朱雀院椿-浴火鸟·二刀解放（D）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = "ATD1",
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653ED_59FF_6001_5207_6362,
        ["创建独立技能实例"] = false
    })
end
____exports["朱雀院椿D模块"] = {["技能ID"] = _____6731_96C0_9662_693F_6280_80FD_914D_7F6E.D["技能ID"], ["注册"] = ____exports["注册朱雀院椿D"]}
return ____exports
