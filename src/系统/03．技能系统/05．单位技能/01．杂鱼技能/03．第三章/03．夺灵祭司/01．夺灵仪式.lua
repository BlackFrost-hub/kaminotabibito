--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.03．夺灵祭司.00．配置")
local _____593A_7075_796D_53F8_914D_7F6E = ____00_FF0E_914D_7F6E["夺灵祭司配置"]
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.00．封印守卫战公共.01．共享")
local _____5355_4F4D_5904_4E8E_786C_63A7_5236 = ____01_FF0E_5171_4EAB["单位处于硬控制"]
local _____53D6_4E24_70B9_8DDD_79BB_5E73_65B9 = ____01_FF0E_5171_4EAB["取两点距离平方"]
local _____53D6_5355_4F4DX = ____01_FF0E_5171_4EAB["取单位X"]
local _____53D6_5355_4F4DY = ____01_FF0E_5171_4EAB["取单位Y"]
local _____547D_4EE4_505C_6B62 = ____01_FF0E_5171_4EAB["命令停止"]
local _____547D_4EE4_79FB_52A8_5230_70B9 = ____01_FF0E_5171_4EAB["命令移动到点"]
local _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548 = ____01_FF0E_5171_4EAB["创建封印守卫战点特效"]
local _____6E05_7406_8BB0_5F55_951A_70B9_538B_5236 = ____01_FF0E_5171_4EAB["清理记录锚点压制"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55 = ____01_FF0E_5171_4EAB["读取封印守卫战敌人记录"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_951A_70B9_72B6_6001 = ____01_FF0E_5171_4EAB["读取封印守卫战锚点状态"]
local _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B = ____01_FF0E_5171_4EAB["封印守卫战单位存活"]
local _____8BBE_7F6E_8BB0_5F55_951A_70B9_538B_5236 = ____01_FF0E_5171_4EAB["设置记录锚点压制"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_0["开始充能"]
local _____505C_6B62_5355_4F4D_5145_80FD = ____require_result_0["停止单位充能"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_1.getServerTime
local function _____796D_53F8_4ECD_5728_951A_70B9_8303_56F4(record)
    local anchor = _____8BFB_53D6_5C01_5370_5B88_536B_6218_951A_70B9_72B6_6001(record["锚点编号"])
    if anchor == nil or anchor["已完成"] then
        return false
    end
    return _____53D6_4E24_70B9_8DDD_79BB_5E73_65B9(
        _____53D6_5355_4F4DX(record["单位"]),
        _____53D6_5355_4F4DY(record["单位"]),
        anchor.X,
        anchor.Y
    ) <= _____593A_7075_796D_53F8_914D_7F6E["引导范围"] * _____593A_7075_796D_53F8_914D_7F6E["引导范围"]
end
local function ____on_593A_7075_796D_53F8_5145_80FD_5468_671F(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "夺灵祭司" or record["充能ID"] ~= chargeId then
        return
    end
    if not _____796D_53F8_4ECD_5728_951A_70B9_8303_56F4(record) or _____5355_4F4D_5904_4E8E_786C_63A7_5236(unit) then
        _____505C_6B62_5355_4F4D_5145_80FD(unit)
    end
end
local function ____on_593A_7075_796D_53F8_5145_80FD_5B8C_6210(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "夺灵祭司" or record["充能ID"] ~= chargeId then
        return
    end
    record["充能ID"] = 0
    if not _____796D_53F8_4ECD_5728_951A_70B9_8303_56F4(record) then
        return
    end
    local anchor = _____8BFB_53D6_5C01_5370_5B88_536B_6218_951A_70B9_72B6_6001(record["锚点编号"])
    if anchor == nil then
        return
    end
    _____547D_4EE4_505C_6B62(unit)
    record["压制特效"] = _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548({
        ["模型路径"] = _____593A_7075_796D_53F8_914D_7F6E["压制法阵特效"],
        X = anchor.X,
        Y = anchor.Y,
        Z = 0,
        ["缩放"] = 0.8
    })
    _____8BBE_7F6E_8BB0_5F55_951A_70B9_538B_5236(record, true)
end
local function ____on_593A_7075_796D_53F8_5145_80FD_7ED3_675F(unit, reason, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "夺灵祭司" then
        return
    end
    if record["充能ID"] == chargeId then
        record["充能ID"] = 0
    end
    if reason ~= "完成" then
        record["下次技能毫秒"] = getServerTime() + _____593A_7075_796D_53F8_914D_7F6E["失败重试毫秒"]
    end
end
local function _____5F00_59CB_593A_7075_796D_53F8_5F15_5BFC(record)
    if record["充能ID"] ~= 0 or _____5355_4F4D_5904_4E8E_786C_63A7_5236(record["单位"]) then
        return false
    end
    local id = _____5F00_59CB_5145_80FD(record["单位"], {
        ["持续时间"] = _____593A_7075_796D_53F8_914D_7F6E["引导持续秒"],
        ["强制硬直"] = true,
        ["显示进度条特效"] = true,
        ["周期回调间隔"] = 0.1,
        ["周期回调"] = ____on_593A_7075_796D_53F8_5145_80FD_5468_671F,
        ["充能完成回调"] = ____on_593A_7075_796D_53F8_5145_80FD_5B8C_6210,
        ["结束回调"] = ____on_593A_7075_796D_53F8_5145_80FD_7ED3_675F
    })
    record["充能ID"] = id
    return id > 0
end
local function _____9009_62E9_6700_8FD1_672A_5B8C_6210_951A_70B9(record)
    local x = _____53D6_5355_4F4DX(record["单位"])
    local y = _____53D6_5355_4F4DY(record["单位"])
    local bestId = 0
    local bestDistance = 999999999
    do
        local i = 1
        while i <= _____593A_7075_796D_53F8_914D_7F6E["锚点数量"] do
            do
                local anchor = _____8BFB_53D6_5C01_5370_5B88_536B_6218_951A_70B9_72B6_6001(i)
                if anchor == nil or anchor["已完成"] then
                    goto __continue19
                end
                local distance = _____53D6_4E24_70B9_8DDD_79BB_5E73_65B9(x, y, anchor.X, anchor.Y)
                if distance >= bestDistance then
                    goto __continue19
                end
                bestDistance = distance
                bestId = i
            end
            ::__continue19::
            i = i + 1
        end
    end
    return bestId
end
____exports["刷新夺灵祭司AI"] = function(record, _____5F53_524D_6BEB_79D2)
    if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"]) then
        return
    end
    if record["正在压制锚点"] then
        if not _____796D_53F8_4ECD_5728_951A_70B9_8303_56F4(record) or _____5355_4F4D_5904_4E8E_786C_63A7_5236(record["单位"]) then
            _____6E05_7406_8BB0_5F55_951A_70B9_538B_5236(record)
            record["下次技能毫秒"] = _____5F53_524D_6BEB_79D2 + _____593A_7075_796D_53F8_914D_7F6E["失败重试毫秒"]
        elseif _____5F53_524D_6BEB_79D2 >= record["下次AI毫秒"] then
            record["下次AI毫秒"] = _____5F53_524D_6BEB_79D2 + _____593A_7075_796D_53F8_914D_7F6E["AI刷新毫秒"]
            _____547D_4EE4_505C_6B62(record["单位"])
        end
        return
    end
    if record["充能ID"] ~= 0 or _____5F53_524D_6BEB_79D2 < record["下次AI毫秒"] then
        return
    end
    record["下次AI毫秒"] = _____5F53_524D_6BEB_79D2 + _____593A_7075_796D_53F8_914D_7F6E["AI刷新毫秒"]
    local anchorId = _____9009_62E9_6700_8FD1_672A_5B8C_6210_951A_70B9(record)
    if anchorId == 0 then
        return
    end
    record["锚点编号"] = anchorId
    local anchor = _____8BFB_53D6_5C01_5370_5B88_536B_6218_951A_70B9_72B6_6001(anchorId)
    if anchor == nil then
        return
    end
    local inRange = _____53D6_4E24_70B9_8DDD_79BB_5E73_65B9(
        _____53D6_5355_4F4DX(record["单位"]),
        _____53D6_5355_4F4DY(record["单位"]),
        anchor.X,
        anchor.Y
    ) <= _____593A_7075_796D_53F8_914D_7F6E["引导范围"] * _____593A_7075_796D_53F8_914D_7F6E["引导范围"]
    if inRange and _____5F53_524D_6BEB_79D2 >= record["下次技能毫秒"] then
        _____5F00_59CB_593A_7075_796D_53F8_5F15_5BFC(record)
    elseif not inRange then
        _____547D_4EE4_79FB_52A8_5230_70B9(record["单位"], anchor.X, anchor.Y)
    end
end
____exports["清理夺灵祭司机制"] = function(record)
    if record["充能ID"] ~= 0 and _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"]) then
        _____505C_6B62_5355_4F4D_5145_80FD(record["单位"])
    end
    record["充能ID"] = 0
    _____6E05_7406_8BB0_5F55_951A_70B9_538B_5236(record)
end
return ____exports
