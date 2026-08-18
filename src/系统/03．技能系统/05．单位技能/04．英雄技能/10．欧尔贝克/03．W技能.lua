local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.10．欧尔贝克.00．配置")
local _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["欧尔贝克单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.10．欧尔贝克.00A．表现工具")
local _____64AD_653E_6B27_5C14_8D1D_514B_5355_4F4D_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放欧尔贝克单位音效"]
local ____00B_FF0E_79EF_6512_72B6_6001 = require("系统.03．技能系统.05．单位技能.04．英雄技能.10．欧尔贝克.00B．积攒状态")
local _____83B7_53D6_6B27_5C14_8D1D_514B_79EF_6512_8BA1_6570 = ____00B_FF0E_79EF_6512_72B6_6001["获取欧尔贝克积攒计数"]
local _____8BBE_7F6E_6B27_5C14_8D1D_514B_79EF_6512_8BA1_6570 = ____00B_FF0E_79EF_6512_72B6_6001["设置欧尔贝克积攒计数"]
local ____17_FF0E_6B27_5C14_8D1D_514B = require("系统.05．Buff系统.03．Buff表.02．英雄.17．欧尔贝克")
local _____6B27_5C14_8D1D_514BBuffID = ____17_FF0E_6B27_5C14_8D1D_514B["欧尔贝克BuffID"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_1.registerSpellEffectListener
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local removeDelayedCallback = ____require_result_2.removeDelayedCallback
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
local removePeriodicCallback = ____require_result_2.removePeriodicCallback
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____4E34_65F6_8C03_6574_653B_51FB = ____require_result_3["临时调整攻击"]
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_3["调整玩家属性"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_4["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_4["单位存活"]
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____5355_4F4D_62E5_6709_539F_751FBuff = ____require_result_5["单位拥有原生Buff"]
local _____5355_4F4D_662F_6307_5B9A_7C7B_578B = ____require_result_5["单位是指定类型"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_6["创建点特效"]
local ____require_result_7 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_7.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_7["移除单位指定Buff"]
local ____W_6280_80FDID = stringToFourCCSafe(_____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E["W技能ID"])
local _____6B27_5C14_8D1D_514B_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local _____79EF_6512Buff_7C7B_578BID = stringToFourCCSafe(_____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E["积攒BuffID"])
local GetHandleId = jass.GetHandleId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
--- 每单位同时只保留一份积攒效果（重复施法先还原再重开）
local _____79EF_6512_72B6_6001_7F13_5B58 = {}
local function _____7ED3_675F_79EF_6512(id, record)
    if _____79EF_6512_72B6_6001_7F13_5B58[id] ~= record then
        return
    end
    if record["周期回调ID"] ~= 0 then
        removePeriodicCallback(record["周期回调ID"])
    end
    if record["到期回调ID"] ~= 0 then
        removeDelayedCallback(record["到期回调ID"])
    end
    _____4E34_65F6_8C03_6574_653B_51FB(record["单位"], -record["攻击加成"])
    _____8C03_6574_73A9_5BB6_5C5E_6027(record["单位"], "暴击率", -record["暴击加成"])
    _____8BBE_7F6E_6B27_5C14_8D1D_514B_79EF_6512_8BA1_6570(record["单位"], 0)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(record["单位"], _____6B27_5C14_8D1D_514BBuffID["积攒"])
    __TS__Delete(_____79EF_6512_72B6_6001_7F13_5B58, id)
end
local function ____on_6B27_5C14_8D1D_514BW(caster, abilityId)
    if abilityId ~= ____W_6280_80FDID then
        return
    end
    if not _____5355_4F4D_662F_6307_5B9A_7C7B_578B(caster, _____6B27_5C14_8D1D_514B_5355_4F4D_7C7B_578BID) then
        return
    end
    local cfg = _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E.W
    local level = GetUnitAbilityLevel(caster, ____W_6280_80FDID)
    local _____653B_51FB_52A0_6210 = math.floor(_____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * (cfg["基础攻击力倍率"] + cfg["每级攻击力倍率"] * level))
    local _____66B4_51FB_52A0_6210 = cfg["基础暴击率"] + cfg["每级暴击率"] * level
    local id = GetHandleId(caster)
    local old = _____79EF_6512_72B6_6001_7F13_5B58[id]
    if old ~= nil and old["单位"] == caster then
        _____7ED3_675F_79EF_6512(id, old)
    end
    _____8BBE_7F6E_6B27_5C14_8D1D_514B_79EF_6512_8BA1_6570(caster, _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E["积攒计数初始值"])
    _____4E34_65F6_8C03_6574_653B_51FB(caster, _____653B_51FB_52A0_6210)
    _____8C03_6574_73A9_5BB6_5C5E_6027(caster, "暴击率", _____66B4_51FB_52A0_6210)
    _____64AD_653E_6B27_5C14_8D1D_514B_5355_4F4D_97F3_6548(caster, cfg["全局音效键"])
    local record = {
        ["单位"] = caster,
        ["周期"] = 0,
        ["周期回调ID"] = 0,
        ["到期回调ID"] = 0,
        ["攻击加成"] = _____653B_51FB_52A0_6210,
        ["暴击加成"] = _____66B4_51FB_52A0_6210
    }
    _____79EF_6512_72B6_6001_7F13_5B58[id] = record
    registerManualBuff(
        caster,
        _____6B27_5C14_8D1D_514BBuffID["积攒"],
        cfg["持续秒"],
        0,
        {sourceUnit = caster, sourceName = "积攒"}
    )
    record["周期回调ID"] = addPeriodicCallback(
        cfg["周期秒"] * 1000,
        function()
            if _____79EF_6512_72B6_6001_7F13_5B58[id] ~= record then
                return
            end
            if _____83B7_53D6_6B27_5C14_8D1D_514B_79EF_6512_8BA1_6570(caster) <= 0 or _____5355_4F4D_62E5_6709_539F_751FBuff(caster, _____79EF_6512Buff_7C7B_578BID) ~= true or not _____5355_4F4D_5B58_6D3B(caster) or record["周期"] >= cfg["周期计数上限"] then
                _____7ED3_675F_79EF_6512(id, record)
                return
            end
            record["周期"] = record["周期"] + 1
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = cfg["周期特效模型"],
                X = GetUnitX(caster),
                Y = GetUnitY(caster),
                Z = 0,
                ["缩放"] = cfg["周期特效缩放"],
                ["持续秒"] = cfg["周期特效持续秒"]
            })
        end
    )
    record["到期回调ID"] = addDelayedCallback(
        cfg["持续秒"] * 1000,
        function()
            _____7ED3_675F_79EF_6512(id, record)
        end
    )
end
registerSpellEffectListener(____on_6B27_5C14_8D1D_514BW)
return ____exports
