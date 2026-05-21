--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_653B_51FB_6548_679C_5DE5_5177 = require("系统.02．物品系统.15．装备技能.08．攻击效果.00．公共.01．攻击效果工具")
local _____5355_4F4D_6301_6709_653B_51FB_6548_679C_88C5_5907 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["单位持有攻击效果装备"]
local _____5355_4F4D_6709_6548_5B58_6D3B = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["单位有效存活"]
local _____653B_51FB_8005_7C7B_578B_6EE1_8DB3 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["攻击者类型满足"]
local _____8DDD_79BB_6EE1_8DB3_9650_5236 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["距离满足限制"]
local _____53D6_653B_51FB_529B = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["取攻击力"]
local _____653B_51FB_6548_679C_9020_6210_4F24_5BB3 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["攻击效果造成伤害"]
local ____22_FF0E_5E78_8FD0_503C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.index")
local _____88C5_5907_89E6_53D1_6982_7387_901A_8FC7 = ____22_FF0E_5E78_8FD0_503C["装备触发概率通过"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口")
local SFB_setCurse = ____require_result_2.SFB_setCurse
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local _____88C5_5907_540D = "|cffcc99ff黑暗猎人手套|r"
local _____89E6_53D1_6982_7387 = 0.15
local _____51B7_5374_6BEB_79D2 = 8000
local _____6700_5927_653B_51FB_8DDD_79BB = 200
local _____653B_51FB_529B_7CFB_6570 = 2
local _____8BC5_5492_6301_7EED_79D2 = 1.5
local _____51B7_5374_8868 = {}
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit)
end
local function _____51B7_5374_901A_8FC7(attacker)
    local id = _____53D6_5355_4F4D_53E5_67C4ID(attacker)
    if id == 0 then
        return false
    end
    local now = getServerTime()
    local last = _____51B7_5374_8868[id]
    if last ~= nil and now - last < _____51B7_5374_6BEB_79D2 then
        return false
    end
    _____51B7_5374_8868[id] = now
    return true
end
local function ____on_9ED1_6697_730E_4EBA_624B_5957_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied > 0) then
        return
    end
    if snapshot == nil or snapshot.isNormalAttack ~= true or snapshot.isTrueDamage == true then
        return
    end
    if not _____5355_4F4D_6709_6548_5B58_6D3B(attacker) or not _____5355_4F4D_6709_6548_5B58_6D3B(target) then
        return
    end
    if not _____5355_4F4D_6301_6709_653B_51FB_6548_679C_88C5_5907(attacker, _____88C5_5907_540D) then
        return
    end
    if not _____653B_51FB_8005_7C7B_578B_6EE1_8DB3(attacker, "近战") then
        return
    end
    if not _____8DDD_79BB_6EE1_8DB3_9650_5236(attacker, target, nil, _____6700_5927_653B_51FB_8DDD_79BB) then
        return
    end
    if not _____88C5_5907_89E6_53D1_6982_7387_901A_8FC7(_____89E6_53D1_6982_7387, attacker) then
        return
    end
    if not _____51B7_5374_901A_8FC7(attacker) then
        return
    end
    SFB_setCurse(attacker, target, _____8BC5_5492_6301_7EED_79D2)
    _____653B_51FB_6548_679C_9020_6210_4F24_5BB3(
        attacker,
        target,
        _____53D6_653B_51FB_529B(attacker) * _____653B_51FB_529B_7CFB_6570,
        "暗影"
    )
end
registerAppliedFinalDamageListener(____on_9ED1_6697_730E_4EBA_624B_5957_6700_7EC8_4F24_5BB3)
return ____exports
