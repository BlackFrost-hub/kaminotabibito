--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.00．共享")
local _____6D3B_52A8_8DF3_8DC3_5217_8868 = ____00_FF0E_5171_4EAB["活动跳跃列表"]
local _____8DF3_8DC3_6620_5C04 = ____00_FF0E_5171_4EAB["跳跃映射"]
local _____5355_4F4D_5F53_524D_8DF3_8DC3 = ____00_FF0E_5171_4EAB["单位当前跳跃"]
local _____53D6_53E5_67C4ID = ____00_FF0E_5171_4EAB["取句柄ID"]
local _____5FEB_7167_5355_4F4D_7EC4 = ____00_FF0E_5171_4EAB["快照单位组"]
local ____02_FF0E_9A71_52A8_4E0E_5B9E_4F8B = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.02．驱动与实例")
local _____521B_5EFA_8DF3_8DC3_5B9E_4F8B = ____02_FF0E_9A71_52A8_4E0E_5B9E_4F8B["创建跳跃实例"]
local _____89E3_6790_8DF3_8DC3_89D2_5EA6 = ____02_FF0E_9A71_52A8_4E0E_5B9E_4F8B["解析跳跃角度"]
local _____7ED3_675F_8DF3_8DC3ID = ____02_FF0E_9A71_52A8_4E0E_5B9E_4F8B["结束跳跃ID"]
local _____505C_6B62_5355_4F4D_8DF3_8DC3 = ____02_FF0E_9A71_52A8_4E0E_5B9E_4F8B["停止单位跳跃"]
local ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____5C1D_8BD5_963B_6B62_81EA_8EAB_4F4D_79FB_6280_80FD = ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236["尝试阻止自身位移技能"]
____exports["开始跳跃"] = function(_____5355_4F4D, _____53C2_6570)
    if _____5C1D_8BD5_963B_6B62_81EA_8EAB_4F4D_79FB_6280_80FD(_____5355_4F4D) then
        return 0
    end
    local _____89D2_5EA6 = _____89E3_6790_8DF3_8DC3_89D2_5EA6(_____5355_4F4D, _____53C2_6570)
    if _____89D2_5EA6 == nil then
        return 0
    end
    return _____521B_5EFA_8DF3_8DC3_5B9E_4F8B(_____5355_4F4D, _____89D2_5EA6, _____53C2_6570)
end
____exports["开始定向跳跃"] = function(_____5355_4F4D, _____53C2_6570)
    return ____exports["开始跳跃"](_____5355_4F4D, _____53C2_6570)
end
____exports["开始单位组跳跃"] = function(_____5355_4F4D_7EC4, _____53C2_6570)
    local _____5355_4F4D_5217_8868 = _____5FEB_7167_5355_4F4D_7EC4(_____5355_4F4D_7EC4)
    local _____7ED3_679C = {}
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        local _____8DF3_8DC3ID = ____exports["开始跳跃"](_____5355_4F4D, _____53C2_6570)
        if _____8DF3_8DC3ID > 0 then
            _____7ED3_679C[#_____7ED3_679C + 1] = _____8DF3_8DC3ID
        end
    end
    return _____7ED3_679C
end
____exports["开始单位组定向跳跃"] = function(_____5355_4F4D_7EC4, _____53C2_6570)
    local _____5355_4F4D_5217_8868 = _____5FEB_7167_5355_4F4D_7EC4(_____5355_4F4D_7EC4)
    local _____7ED3_679C = {}
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        local _____8DF3_8DC3ID = ____exports["开始定向跳跃"](_____5355_4F4D, _____53C2_6570)
        if _____8DF3_8DC3ID > 0 then
            _____7ED3_679C[#_____7ED3_679C + 1] = _____8DF3_8DC3ID
        end
    end
    return _____7ED3_679C
end
____exports["停止跳跃"] = function(_____8DF3_8DC3ID, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "中断"
    end
    return _____7ED3_675F_8DF3_8DC3ID(_____8DF3_8DC3ID, _____539F_56E0)
end
____exports["停止单位跳跃"] = _____505C_6B62_5355_4F4D_8DF3_8DC3
____exports["单位是否正在跳跃"] = function(_____5355_4F4D)
    local _____8DF3_8DC3ID = _____5355_4F4D_5F53_524D_8DF3_8DC3[_____53D6_53E5_67C4ID(_____5355_4F4D)]
    return _____8DF3_8DC3ID ~= nil and _____8DF3_8DC3_6620_5C04[_____8DF3_8DC3ID] ~= nil
end
____exports["获取单位当前跳跃ID"] = function(_____5355_4F4D)
    return _____5355_4F4D_5F53_524D_8DF3_8DC3[_____53D6_53E5_67C4ID(_____5355_4F4D)] or 0
end
____exports["获取活跃跳跃数量"] = function()
    return #_____6D3B_52A8_8DF3_8DC3_5217_8868
end
return ____exports
