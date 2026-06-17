--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____6309_9A71_6563_7B49_7EA7_6E05_9664_5355_4F4DBuff = ____01_FF0E_63A7_5236_4E0EBuff["按驱散等级清除单位Buff"]
local _____6E05_9664_5355_4F4D_63A7_5236_7C7B_8D1F_9762Buff = ____01_FF0E_63A7_5236_4E0EBuff["清除单位控制类负面Buff"]
local _____6E05_9664_5355_4F4D_786C_63A7_5236Buff_5408_96C6 = ____01_FF0E_63A7_5236_4E0EBuff["清除单位硬控制Buff合集"]
local _____6E05_9664_5355_4F4D_8F6F_63A7_5236Buff_5408_96C6 = ____01_FF0E_63A7_5236_4E0EBuff["清除单位软控制Buff合集"]
local ____01_FF0E_65E0_89C6_63A7_5236_547D_4EE4_8F93_5165 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.26．无视控制输入.01．无视控制命令输入")
local _____914D_7F6E_65E0_89C6_63A7_5236_6280_80FD_58F3_5B50 = ____01_FF0E_65E0_89C6_63A7_5236_547D_4EE4_8F93_5165["配置无视控制技能壳子"]
local _____6CE8_518C_65E0_89C6_63A7_5236_8F93_5165_76D1_542C = ____01_FF0E_65E0_89C6_63A7_5236_547D_4EE4_8F93_5165["注册无视控制输入监听"]
local _____6CE8_9500_65E0_89C6_63A7_5236_8F93_5165_76D1_542C = ____01_FF0E_65E0_89C6_63A7_5236_547D_4EE4_8F93_5165["注销无视控制输入监听"]
local function _____8F93_5165_7C7B_578B_5339_914D(_____5B9E_9645_7C7B_578B, _____914D_7F6E_7C7B_578B)
    if _____914D_7F6E_7C7B_578B == nil then
        return true
    end
    if type(_____914D_7F6E_7C7B_578B) == "string" then
        return _____5B9E_9645_7C7B_578B == _____914D_7F6E_7C7B_578B
    end
    do
        local i = 0
        while i < #_____914D_7F6E_7C7B_578B do
            if _____5B9E_9645_7C7B_578B == _____914D_7F6E_7C7B_578B[i + 1] then
                return true
            end
            i = i + 1
        end
    end
    return false
end
____exports["执行无视控制解控驱散"] = function(_____5355_4F4D, _____914D_7F6E)
    if _____914D_7F6E == nil then
        _____914D_7F6E = {}
    end
    local result = {
        ["控制Buff池数量"] = 0,
        ["原生硬控制数量"] = 0,
        ["原生软控制数量"] = 0,
        ["负面驱散数量"] = 0,
        ["总数"] = 0
    }
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return result
    end
    if _____914D_7F6E["清除控制"] ~= false then
        result["控制Buff池数量"] = _____6E05_9664_5355_4F4D_63A7_5236_7C7B_8D1F_9762Buff(_____5355_4F4D, _____914D_7F6E["控制只清可驱散"] ~= false)
        result["原生硬控制数量"] = _____6E05_9664_5355_4F4D_786C_63A7_5236Buff_5408_96C6(_____5355_4F4D)
    end
    if _____914D_7F6E["清除软控制"] == true then
        result["原生软控制数量"] = _____6E05_9664_5355_4F4D_8F6F_63A7_5236Buff_5408_96C6(_____5355_4F4D)
    end
    if _____914D_7F6E["清除负面"] ~= false then
        local _____9A71_6563_7B49_7EA7 = _____914D_7F6E["驱散等级"] or 1
        local _____8D1F_9762_7C7B_578B_524D_7F00 = _____914D_7F6E["负面类型前缀"] or "Debuff:"
        result["负面驱散数量"] = _____6309_9A71_6563_7B49_7EA7_6E05_9664_5355_4F4DBuff(_____5355_4F4D, _____9A71_6563_7B49_7EA7, _____8D1F_9762_7C7B_578B_524D_7F00, _____914D_7F6E["负面只清可驱散"] ~= false)
    end
    result["总数"] = result["控制Buff池数量"] + result["原生硬控制数量"] + result["原生软控制数量"] + result["负面驱散数量"]
    return result
end
____exports["绑定无视控制解控驱散输入"] = function(_____914D_7F6E)
    if _____914D_7F6E == nil then
        _____914D_7F6E = {}
    end
    local function callback(event)
        if not _____8F93_5165_7C7B_578B_5339_914D(event["输入类型"], _____914D_7F6E["输入类型"]) then
            return
        end
        if _____914D_7F6E["单位"] ~= nil and _____914D_7F6E["单位"] ~= 0 and event["单位"] ~= _____914D_7F6E["单位"] then
            return
        end
        if _____914D_7F6E["过滤"] ~= nil and not _____914D_7F6E["过滤"](event) then
            return
        end
        local result = ____exports["执行无视控制解控驱散"](event["单位"], _____914D_7F6E)
        if _____914D_7F6E["完成"] ~= nil then
            _____914D_7F6E["完成"](event, result)
        end
    end
    _____6CE8_518C_65E0_89C6_63A7_5236_8F93_5165_76D1_542C(callback)
    return callback
end
____exports["解绑无视控制解控驱散输入"] = function(callback)
    _____6CE8_9500_65E0_89C6_63A7_5236_8F93_5165_76D1_542C(callback)
end
____exports["配置简单无视控制解控驱散技能"] = function(_____914D_7F6E)
    local _____6280_80FDID = _____914D_7F6E_65E0_89C6_63A7_5236_6280_80FD_58F3_5B50({
        ["单位"] = _____914D_7F6E["单位"],
        ["技能ID"] = _____914D_7F6E["技能ID"],
        ["输入类型"] = _____914D_7F6E["输入类型"],
        ["命令"] = _____914D_7F6E["命令"],
        ["图标"] = _____914D_7F6E["图标"] or "ReplaceableTextures\\CommandButtons\\BTNDispelMagic.blp",
        ["提示"] = _____914D_7F6E["提示"] or "解控驱散",
        ["扩展提示"] = _____914D_7F6E["扩展提示"] or "无视控制立即使用，解除自身控制，并驱散可驱散负面效果。",
        ["热键"] = _____914D_7F6E["热键"] or "D",
        ["按钮X"] = _____914D_7F6E["按钮X"],
        ["按钮Y"] = _____914D_7F6E["按钮Y"],
        ["冷却"] = _____914D_7F6E["冷却"],
        ["魔法消耗"] = _____914D_7F6E["魔法消耗"],
        ["持续时间"] = 0.01,
        ["英雄持续时间"] = 0.01
    })
    local _____8F93_5165_76D1_542C = ____exports["绑定无视控制解控驱散输入"](_____914D_7F6E)
    return {["技能ID"] = _____6280_80FDID, ["输入监听"] = _____8F93_5165_76D1_542C}
end
return ____exports
