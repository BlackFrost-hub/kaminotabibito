--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.04．锚蚀兽.00．配置")
local _____951A_8680_517D_914D_7F6E = ____00_FF0E_914D_7F6E["锚蚀兽配置"]
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.00．封印守卫战公共.01．共享")
local _____5355_4F4D_5904_4E8E_786C_63A7_5236 = ____01_FF0E_5171_4EAB["单位处于硬控制"]
local _____547D_4EE4_653B_51FB_76EE_6807 = ____01_FF0E_5171_4EAB["命令攻击目标"]
local _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548 = ____01_FF0E_5171_4EAB["创建封印守卫战点特效"]
local _____53D6_5355_4F4DX = ____01_FF0E_5171_4EAB["取单位X"]
local _____53D6_5355_4F4DY = ____01_FF0E_5171_4EAB["取单位Y"]
local _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9 = ____01_FF0E_5171_4EAB["取单位距离平方"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____01_FF0E_5171_4EAB["读取单位攻击力"]
local _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D = ____01_FF0E_5171_4EAB["读取单位最大生命"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55 = ____01_FF0E_5171_4EAB["读取封印守卫战敌人记录"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_6838_5FC3 = ____01_FF0E_5171_4EAB["读取封印守卫战核心"]
local _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B = ____01_FF0E_5171_4EAB["封印守卫战单位存活"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_0["开始充能"]
local _____505C_6B62_5355_4F4D_5145_80FD = ____require_result_0["停止单位充能"]
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_1["造成单体技能伤害"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_2.getServerTime
local KillUnit = jass.KillUnit
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local function _____951A_8680_517D_4ECD_5728_81EA_7206_8303_56F4(record)
    local core = _____8BFB_53D6_5C01_5370_5B88_536B_6218_6838_5FC3()
    return _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(core) and _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9(record["单位"], core) <= _____951A_8680_517D_914D_7F6E["自爆范围"] * _____951A_8680_517D_914D_7F6E["自爆范围"]
end
local function ____on_951A_8680_517D_5145_80FD_5468_671F(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "锚蚀兽" or record["充能ID"] ~= chargeId then
        return
    end
    if not _____951A_8680_517D_4ECD_5728_81EA_7206_8303_56F4(record) or _____5355_4F4D_5904_4E8E_786C_63A7_5236(unit) then
        _____505C_6B62_5355_4F4D_5145_80FD(unit)
    end
end
local function ____on_951A_8680_517D_5145_80FD_5B8C_6210(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "锚蚀兽" or record["充能ID"] ~= chargeId then
        return
    end
    record["充能ID"] = 0
    local core = _____8BFB_53D6_5C01_5370_5B88_536B_6218_6838_5FC3()
    if not _____951A_8680_517D_4ECD_5728_81EA_7206_8303_56F4(record) or not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(core) then
        return
    end
    local damage = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(core) * _____951A_8680_517D_914D_7F6E["核心最大生命伤害比例"] + _____8BFB_53D6_5355_4F4D_653B_51FB_529B(unit) * _____951A_8680_517D_914D_7F6E["自身攻击力伤害比例"]
    _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548({
        ["模型路径"] = _____951A_8680_517D_914D_7F6E["自爆特效"],
        X = _____53D6_5355_4F4DX(unit),
        Y = _____53D6_5355_4F4DY(unit),
        Z = 0,
        ["缩放"] = 0.8,
        ["持续秒"] = 2
    })
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = unit,
        ["目标"] = core,
        ["伤害"] = damage,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        ["来源类型"] = "单位技能",
        ["标签"] = "封印守卫战-锚蚀自爆",
        ["参与技能伤害加成"] = false
    })
    KillUnit(unit)
end
local function ____on_951A_8680_517D_5145_80FD_7ED3_675F(unit, reason, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "锚蚀兽" then
        return
    end
    if record["充能ID"] == chargeId then
        record["充能ID"] = 0
    end
    if reason ~= "完成" then
        record["下次技能毫秒"] = getServerTime() + _____951A_8680_517D_914D_7F6E["失败重试毫秒"]
    end
end
local function _____5F00_59CB_951A_8680_517D_81EA_7206(record)
    if record["充能ID"] ~= 0 or _____5355_4F4D_5904_4E8E_786C_63A7_5236(record["单位"]) then
        return false
    end
    local id = _____5F00_59CB_5145_80FD(record["单位"], {
        ["持续时间"] = _____951A_8680_517D_914D_7F6E["蓄力持续秒"],
        ["强制硬直"] = true,
        ["显示进度条特效"] = true,
        ["周期回调间隔"] = 0.1,
        ["周期回调"] = ____on_951A_8680_517D_5145_80FD_5468_671F,
        ["充能完成回调"] = ____on_951A_8680_517D_5145_80FD_5B8C_6210,
        ["结束回调"] = ____on_951A_8680_517D_5145_80FD_7ED3_675F
    })
    record["充能ID"] = id
    return id > 0
end
____exports["刷新锚蚀兽AI"] = function(record, _____5F53_524D_6BEB_79D2)
    if record["充能ID"] ~= 0 or _____5F53_524D_6BEB_79D2 < record["下次AI毫秒"] then
        return
    end
    record["下次AI毫秒"] = _____5F53_524D_6BEB_79D2 + _____951A_8680_517D_914D_7F6E["AI刷新毫秒"]
    local core = _____8BFB_53D6_5C01_5370_5B88_536B_6218_6838_5FC3()
    if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(core) then
        return
    end
    record["当前目标"] = core
    if _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9(record["单位"], core) <= _____951A_8680_517D_914D_7F6E["自爆范围"] * _____951A_8680_517D_914D_7F6E["自爆范围"] then
        if _____5F53_524D_6BEB_79D2 >= record["下次技能毫秒"] then
            _____5F00_59CB_951A_8680_517D_81EA_7206(record)
        end
        return
    end
    _____547D_4EE4_653B_51FB_76EE_6807(record["单位"], core)
end
____exports["清理锚蚀兽机制"] = function(record)
    if record["充能ID"] ~= 0 and _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"]) then
        _____505C_6B62_5355_4F4D_5145_80FD(record["单位"])
    end
    record["充能ID"] = 0
end
return ____exports
