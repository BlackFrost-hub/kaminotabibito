--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.02．精英技能.03．第三章.03．失律号令者.00．配置")
local _____5931_5F8B_53F7_4EE4_8005_914D_7F6E = ____00_FF0E_914D_7F6E["失律号令者配置"]
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.00．封印守卫战公共.01．共享")
local _____5355_4F4D_5904_4E8E_786C_63A7_5236 = ____01_FF0E_5171_4EAB["单位处于硬控制"]
local _____521B_5EFA_5C01_5370_5B88_536B_6218_5355_4F4D_5E38_9A7B_7279_6548 = ____01_FF0E_5171_4EAB["创建封印守卫战单位常驻特效"]
local _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548 = ____01_FF0E_5171_4EAB["创建封印守卫战点特效"]
local _____53D6_5355_4F4DX = ____01_FF0E_5171_4EAB["取单位X"]
local _____53D6_5355_4F4DY = ____01_FF0E_5171_4EAB["取单位Y"]
local _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9 = ____01_FF0E_5171_4EAB["取单位距离平方"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_5217_8868 = ____01_FF0E_5171_4EAB["读取封印守卫战敌人列表"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55 = ____01_FF0E_5171_4EAB["读取封印守卫战敌人记录"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_6838_5FC3 = ____01_FF0E_5171_4EAB["读取封印守卫战核心"]
local _____547D_4EE4_653B_51FB_76EE_6807 = ____01_FF0E_5171_4EAB["命令攻击目标"]
local _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B = ____01_FF0E_5171_4EAB["封印守卫战单位存活"]
local _____9500_6BC1_5C01_5370_5B88_536B_6218_5355_4F4D_5E38_9A7B_7279_6548 = ____01_FF0E_5171_4EAB["销毁封印守卫战单位常驻特效"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_0["开始充能"]
local _____505C_6B62_5355_4F4D_5145_80FD = ____require_result_0["停止单位充能"]
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_1.SGSS_SetState
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_2.getServerTime
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_3.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_3["移除单位指定Buff"]
local ____require_result_4 = require("系统.05．Buff系统.03．Buff表.04．单位.01．封印守卫战")
local _____5C01_5370_5B88_536B_6218BuffID = ____require_result_4["封印守卫战BuffID"]
local GetUnitDefaultMoveSpeed = jass.GetUnitDefaultMoveSpeed
local _____79FB_52A8_901F_5EA6_5C5E_6027ID = 9
local _____653B_51FB_901F_5EA6_5C5E_6027ID = 10
local _____53F7_4EE4_5F3A_5316_7279_6548_952E = "封印守卫战-失律号令强化"
local function _____6E05_9664_5355_4E2A_53F7_4EE4_5F3A_5316(record)
    if record["号令属性已施加"] and _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"]) then
        SGSS_SetState(record["单位"], _____79FB_52A8_901F_5EA6_5C5E_6027ID, -record["号令移动速度增量"])
        SGSS_SetState(record["单位"], _____653B_51FB_901F_5EA6_5C5E_6027ID, -_____5931_5F8B_53F7_4EE4_8005_914D_7F6E["攻击速度提高"])
    end
    record["号令属性已施加"] = false
    record["号令结束毫秒"] = 0
    record["号令移动速度增量"] = 0
    _____9500_6BC1_5C01_5370_5B88_536B_6218_5355_4F4D_5E38_9A7B_7279_6548(record["单位"], _____53F7_4EE4_5F3A_5316_7279_6548_952E)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(record["单位"], _____5C01_5370_5B88_536B_6218BuffID["失律号令强化"])
end
local function _____65BD_52A0_5355_4E2A_53F7_4EE4_5F3A_5316(record, _____5F53_524D_6BEB_79D2, sourceUnit)
    if not record["号令属性已施加"] then
        record["号令移动速度增量"] = GetUnitDefaultMoveSpeed(record["单位"]) * _____5931_5F8B_53F7_4EE4_8005_914D_7F6E["移动速度提高"]
        SGSS_SetState(record["单位"], _____79FB_52A8_901F_5EA6_5C5E_6027ID, record["号令移动速度增量"])
        SGSS_SetState(record["单位"], _____653B_51FB_901F_5EA6_5C5E_6027ID, _____5931_5F8B_53F7_4EE4_8005_914D_7F6E["攻击速度提高"])
        record["号令属性已施加"] = true
        _____521B_5EFA_5C01_5370_5B88_536B_6218_5355_4F4D_5E38_9A7B_7279_6548(record["单位"], _____5931_5F8B_53F7_4EE4_8005_914D_7F6E["强化特效"], _____53F7_4EE4_5F3A_5316_7279_6548_952E)
    end
    record["号令结束毫秒"] = _____5F53_524D_6BEB_79D2 + _____5931_5F8B_53F7_4EE4_8005_914D_7F6E["持续毫秒"]
    registerManualBuff(
        record["单位"],
        _____5C01_5370_5B88_536B_6218BuffID["失律号令强化"],
        _____5931_5F8B_53F7_4EE4_8005_914D_7F6E["持续毫秒"] / 1000,
        _____5931_5F8B_53F7_4EE4_8005_914D_7F6E["移动速度提高"],
        {sourceUnit = sourceUnit, effectSourceName = "失律号令者-失律号令", effectSourceType = "技能", effectValue2 = _____5931_5F8B_53F7_4EE4_8005_914D_7F6E["攻击速度提高"]}
    )
end
local function _____91CA_653E_5931_5F8B_53F7_4EE4(casterRecord, _____5F53_524D_6BEB_79D2)
    local list = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_5217_8868()
    local count = 0
    do
        local i = 0
        while i < #list do
            do
                local targetRecord = list[i + 1]
                if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(targetRecord["单位"]) then
                    goto __continue8
                end
                if _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9(casterRecord["单位"], targetRecord["单位"]) > _____5931_5F8B_53F7_4EE4_8005_914D_7F6E["号令范围"] * _____5931_5F8B_53F7_4EE4_8005_914D_7F6E["号令范围"] then
                    goto __continue8
                end
                _____65BD_52A0_5355_4E2A_53F7_4EE4_5F3A_5316(targetRecord, _____5F53_524D_6BEB_79D2, casterRecord["单位"])
                count = count + 1
            end
            ::__continue8::
            i = i + 1
        end
    end
    _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548({
        ["模型路径"] = _____5931_5F8B_53F7_4EE4_8005_914D_7F6E["脉冲特效"],
        X = _____53D6_5355_4F4DX(casterRecord["单位"]),
        Y = _____53D6_5355_4F4DY(casterRecord["单位"]),
        Z = 0,
        ["缩放"] = 0.8,
        ["持续秒"] = 2
    })
    return count
end
local function ____on_5931_5F8B_53F7_4EE4_5145_80FD_5468_671F(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "失律号令者" or record["充能ID"] ~= chargeId then
        return
    end
    if _____5355_4F4D_5904_4E8E_786C_63A7_5236(unit) then
        _____505C_6B62_5355_4F4D_5145_80FD(unit)
    end
end
local function ____on_5931_5F8B_53F7_4EE4_5145_80FD_5B8C_6210(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "失律号令者" or record["充能ID"] ~= chargeId then
        return
    end
    record["充能ID"] = 0
    local now = getServerTime()
    _____91CA_653E_5931_5F8B_53F7_4EE4(record, now)
    record["下次技能毫秒"] = now + _____5931_5F8B_53F7_4EE4_8005_914D_7F6E["技能冷却毫秒"]
end
local function ____on_5931_5F8B_53F7_4EE4_5145_80FD_7ED3_675F(unit, reason, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "失律号令者" then
        return
    end
    if record["充能ID"] == chargeId then
        record["充能ID"] = 0
    end
    if reason ~= "完成" then
        record["下次技能毫秒"] = getServerTime() + _____5931_5F8B_53F7_4EE4_8005_914D_7F6E["技能冷却毫秒"]
    end
end
local function _____5F00_59CB_5931_5F8B_53F7_4EE4(record)
    if record["充能ID"] ~= 0 or _____5355_4F4D_5904_4E8E_786C_63A7_5236(record["单位"]) then
        return false
    end
    local id = _____5F00_59CB_5145_80FD(record["单位"], {
        ["持续时间"] = _____5931_5F8B_53F7_4EE4_8005_914D_7F6E["引导持续秒"],
        ["强制硬直"] = true,
        ["显示进度条特效"] = true,
        ["周期回调间隔"] = 0.1,
        ["周期回调"] = ____on_5931_5F8B_53F7_4EE4_5145_80FD_5468_671F,
        ["充能完成回调"] = ____on_5931_5F8B_53F7_4EE4_5145_80FD_5B8C_6210,
        ["结束回调"] = ____on_5931_5F8B_53F7_4EE4_5145_80FD_7ED3_675F
    })
    record["充能ID"] = id
    return id > 0
end
____exports["刷新全部号令强化"] = function(_____5F53_524D_6BEB_79D2)
    local list = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_5217_8868()
    do
        local i = 0
        while i < #list do
            local record = list[i + 1]
            if record["号令属性已施加"] and (not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"]) or _____5F53_524D_6BEB_79D2 >= record["号令结束毫秒"]) then
                _____6E05_9664_5355_4E2A_53F7_4EE4_5F3A_5316(record)
            end
            i = i + 1
        end
    end
end
____exports["修正失律号令减伤"] = function(context)
    local ____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55_8 = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55
    local ____opt_result_7
    if context ~= nil then
        ____opt_result_7 = context.target
    end
    local record = ____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55_8(____opt_result_7)
    if record == nil or not record["号令属性已施加"] or getServerTime() >= record["号令结束毫秒"] then
        return context.currentDamage
    end
    return context.currentDamage * (1 - _____5931_5F8B_53F7_4EE4_8005_914D_7F6E["减伤比例"])
end
____exports["刷新失律号令者AI"] = function(record, _____5F53_524D_6BEB_79D2)
    if record["充能ID"] ~= 0 or _____5F53_524D_6BEB_79D2 < record["下次AI毫秒"] then
        return
    end
    record["下次AI毫秒"] = _____5F53_524D_6BEB_79D2 + _____5931_5F8B_53F7_4EE4_8005_914D_7F6E["AI刷新毫秒"]
    if _____5F53_524D_6BEB_79D2 >= record["下次技能毫秒"] and _____5F00_59CB_5931_5F8B_53F7_4EE4(record) then
        return
    end
    local core = _____8BFB_53D6_5C01_5370_5B88_536B_6218_6838_5FC3()
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(core) then
        _____547D_4EE4_653B_51FB_76EE_6807(record["单位"], core)
    end
end
____exports["清理失律号令记录"] = function(record)
    if record["充能ID"] ~= 0 and _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"]) then
        _____505C_6B62_5355_4F4D_5145_80FD(record["单位"])
    end
    record["充能ID"] = 0
    _____6E05_9664_5355_4E2A_53F7_4EE4_5F3A_5316(record)
end
____exports["清理全部失律号令强化"] = function()
    local list = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_5217_8868()
    do
        local i = 0
        while i < #list do
            _____6E05_9664_5355_4E2A_53F7_4EE4_5F3A_5316(list[i + 1])
            i = i + 1
        end
    end
end
return ____exports
