--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7AE0_8282_88C5_5907_6C60 = require("系统.02．物品系统.20．普通小怪额外掉落.01．章节装备池")
local _____83B7_53D6_7AE0_8282_666E_901A_5C0F_602A_989D_5916_88C5_5907_6C60 = ____01_FF0E_7AE0_8282_88C5_5907_6C60["获取章节普通小怪额外装备池"]
local ____02_FF0E_5C0F_602A_5F3A_5EA6_8D44_683C_8868 = require("系统.02．物品系统.20．普通小怪额外掉落.02．小怪强度资格表")
local _____83B7_53D6_666E_901A_5C0F_602A_989D_5916_6389_843D_8D44_683C = ____02_FF0E_5C0F_602A_5F3A_5EA6_8D44_683C_8868["获取普通小怪额外掉落资格"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local ____require_result_1 = require("lib.扩展函数.物品相关函数.创建物品函数")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_1["创建物品并注册排泄监听"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local _____603B_6389_843D_5224_5B9A_5206_6BCD = 10000
local _____603B_6389_843D_547D_4E2D_503C = 100
local _____5DF2_521D_59CB_5316_666E_901A_5C0F_602A_989D_5916_6389_843D = false
local function ____on_666E_901A_5C0F_602A_6B7B_4EA1_5C1D_8BD5_989D_5916_6389_843D(_____6B7B_4EA1_5355_4F4D, ______51FB_6740_8005)
    if _____6B7B_4EA1_5355_4F4D == nil or _____6B7B_4EA1_5355_4F4D == 0 then
        return
    end
    local _____8D44_683C = _____83B7_53D6_666E_901A_5C0F_602A_989D_5916_6389_843D_8D44_683C(jass:GetUnitTypeId(_____6B7B_4EA1_5355_4F4D))
    if _____8D44_683C == nil then
        return
    end
    if jass:GetRandomInt(1, _____603B_6389_843D_5224_5B9A_5206_6BCD) > _____603B_6389_843D_547D_4E2D_503C then
        return
    end
    local _____7AE0_8282_88C5_5907_6C60 = _____83B7_53D6_7AE0_8282_666E_901A_5C0F_602A_989D_5916_88C5_5907_6C60(_____8D44_683C["章节"])
    local _____53EF_6389_843D_88C5_5907 = {}
    do
        local i = 0
        while i < #_____7AE0_8282_88C5_5907_6C60 do
            local _____88C5_5907 = _____7AE0_8282_88C5_5907_6C60[i + 1]
            if _____88C5_5907["评分"] <= _____8D44_683C["最高可掉评分"] then
                _____53EF_6389_843D_88C5_5907[#_____53EF_6389_843D_88C5_5907 + 1] = _____88C5_5907
            end
            i = i + 1
        end
    end
    if #_____53EF_6389_843D_88C5_5907 == 0 then
        return
    end
    local _____968F_673A_4E0B_6807 = jass:GetRandomInt(1, #_____53EF_6389_843D_88C5_5907) - 1
    local _____6389_843D_7269_54C1_7C7B_578BID = stringToFourCCSafe(_____53EF_6389_843D_88C5_5907[_____968F_673A_4E0B_6807 + 1]["物品ID"])
    if _____6389_843D_7269_54C1_7C7B_578BID == 0 then
        return
    end
    _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(
        _____6389_843D_7269_54C1_7C7B_578BID,
        jass:GetUnitX(_____6B7B_4EA1_5355_4F4D),
        jass:GetUnitY(_____6B7B_4EA1_5355_4F4D)
    )
end
____exports["初始化普通小怪额外掉落"] = function()
    if _____5DF2_521D_59CB_5316_666E_901A_5C0F_602A_989D_5916_6389_843D then
        return
    end
    _____5DF2_521D_59CB_5316_666E_901A_5C0F_602A_989D_5916_6389_843D = true
    registerDeathListener(____on_666E_901A_5C0F_602A_6B7B_4EA1_5C1D_8BD5_989D_5916_6389_843D)
end
____exports["初始化普通小怪额外掉落"]()
return ____exports
