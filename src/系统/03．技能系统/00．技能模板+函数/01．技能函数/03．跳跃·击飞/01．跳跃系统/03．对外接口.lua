local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____00_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.00．共享")
local _____6D3B_52A8_8DF3_8DC3_5217_8868 = ____00_FF0E_5171_4EAB["活动跳跃列表"]
local _____8DF3_8DC3_6620_5C04 = ____00_FF0E_5171_4EAB["跳跃映射"]
local _____5355_4F4D_5F53_524D_8DF3_8DC3 = ____00_FF0E_5171_4EAB["单位当前跳跃"]
local _____5355_4F4D_5F53_524D_8DF3_8DC3_4F4D_79FB_7C7B_578B = ____00_FF0E_5171_4EAB["单位当前跳跃位移类型"]
local _____53D6_53E5_67C4ID = ____00_FF0E_5171_4EAB["取句柄ID"]
local _____5FEB_7167_5355_4F4D_7EC4 = ____00_FF0E_5171_4EAB["快照单位组"]
local GetUnitX = ____00_FF0E_5171_4EAB.GetUnitX
local GetUnitY = ____00_FF0E_5171_4EAB.GetUnitY
local ____02_FF0E_9A71_52A8_4E0E_5B9E_4F8B = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.02．驱动与实例")
local _____521B_5EFA_8DF3_8DC3_5B9E_4F8B = ____02_FF0E_9A71_52A8_4E0E_5B9E_4F8B["创建跳跃实例"]
local _____89E3_6790_8DF3_8DC3_89D2_5EA6 = ____02_FF0E_9A71_52A8_4E0E_5B9E_4F8B["解析跳跃角度"]
local _____7ED3_675F_8DF3_8DC3ID = ____02_FF0E_9A71_52A8_4E0E_5B9E_4F8B["结束跳跃ID"]
local _____505C_6B62_5355_4F4D_8DF3_8DC3 = ____02_FF0E_9A71_52A8_4E0E_5B9E_4F8B["停止单位跳跃"]
local ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____5C1D_8BD5_963B_6B62_81EA_8EAB_4F4D_79FB_6280_80FD = ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236["尝试阻止自身位移技能"]
local _____901A_77E5_6218_6597_81EA_8EAB_4F4D_79FB_5B8C_6210 = ____20_FF0E_4F4D_79FB_6280_80FD_9650_5236["通知战斗自身位移完成"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.11．技能属性修正.index")
local _____6309_82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63_4E0A_4E0B_6587_4FEE_6B63_8DDD_79BB = ____require_result_0["按英雄技能距离修正上下文修正距离"]
____exports["开始跳跃"] = function(_____5355_4F4D, _____53C2_6570)
    if _____5C1D_8BD5_963B_6B62_81EA_8EAB_4F4D_79FB_6280_80FD(_____5355_4F4D) then
        return 0
    end
    local _____89D2_5EA6 = _____89E3_6790_8DF3_8DC3_89D2_5EA6(_____5355_4F4D, _____53C2_6570)
    if _____89D2_5EA6 == nil then
        return 0
    end
    local _____8D77_70B9X = GetUnitX(_____5355_4F4D)
    local _____8D77_70B9Y = GetUnitY(_____5355_4F4D)
    local _____539F_7ED3_675F_56DE_8C03 = _____53C2_6570["结束回调"]
    local _____8DDD_79BB = _____6309_82F1_96C4_6280_80FD_8DDD_79BB_4FEE_6B63_4E0A_4E0B_6587_4FEE_6B63_8DDD_79BB(_____53C2_6570["距离"], _____53C2_6570["英雄技能距离修正"], "自身位移距离")
    local function ____on_4E3B_52A8_8DF3_8DC3_7ED3_675F(_____79FB_52A8_5355_4F4D, _____539F_56E0, _____8DF3_8DC3ID)
        local _____5355_4F4D_6709_6548 = _____79FB_52A8_5355_4F4D ~= nil and _____79FB_52A8_5355_4F4D ~= 0
        local _____7EC8_70B9X = _____5355_4F4D_6709_6548 and GetUnitX(_____79FB_52A8_5355_4F4D) or _____8D77_70B9X
        local _____7EC8_70B9Y = _____5355_4F4D_6709_6548 and GetUnitY(_____79FB_52A8_5355_4F4D) or _____8D77_70B9Y
        if _____539F_7ED3_675F_56DE_8C03 ~= nil then
            _____539F_7ED3_675F_56DE_8C03(_____79FB_52A8_5355_4F4D, _____539F_56E0, _____8DF3_8DC3ID)
        end
        if _____5355_4F4D_6709_6548 and _____539F_56E0 ~= "中断" and _____539F_56E0 ~= "死亡" and _____539F_56E0 ~= "主单位死亡" then
            _____901A_77E5_6218_6597_81EA_8EAB_4F4D_79FB_5B8C_6210(
                _____79FB_52A8_5355_4F4D,
                _____8D77_70B9X,
                _____8D77_70B9Y,
                _____7EC8_70B9X,
                _____7EC8_70B9Y
            )
        end
    end
    return _____521B_5EFA_8DF3_8DC3_5B9E_4F8B(
        _____5355_4F4D,
        _____89D2_5EA6,
        __TS__ObjectAssign({}, _____53C2_6570, {["距离"] = _____8DDD_79BB, ["结束回调"] = ____on_4E3B_52A8_8DF3_8DC3_7ED3_675F})
    )
end
____exports["开始定向跳跃"] = function(_____5355_4F4D, _____53C2_6570)
    return ____exports["开始跳跃"](_____5355_4F4D, _____53C2_6570)
end
--- 沿指定方向跳跃，并明确标记为可识别的被击退/被击飞效果。
____exports["开始跳跃作为被击退击飞"] = function(_____5355_4F4D, _____53C2_6570)
    return ____exports["开始跳跃"](
        _____5355_4F4D,
        __TS__ObjectAssign({}, _____53C2_6570, {["位移类型"] = "被击退击飞"})
    )
end
--- 沿指定角度反向跳跃，并明确标记为可识别的被击退/被击飞效果。
____exports["开始反向跳跃作为被击退击飞"] = function(_____5355_4F4D, _____53C2_6570)
    if _____53C2_6570["角度"] == nil then
        return 0
    end
    return ____exports["开始跳跃"](
        _____5355_4F4D,
        __TS__ObjectAssign({}, _____53C2_6570, {["角度"] = _____53C2_6570["角度"] + 180, ["位移类型"] = "被击退击飞"})
    )
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
____exports["获取单位当前跳跃位移类型"] = function(_____5355_4F4D)
    return _____5355_4F4D_5F53_524D_8DF3_8DC3_4F4D_79FB_7C7B_578B[_____53D6_53E5_67C4ID(_____5355_4F4D)] or "普通"
end
____exports["单位是否处于被击退击飞"] = function(_____5355_4F4D)
    local id = _____53D6_53E5_67C4ID(_____5355_4F4D)
    return _____5355_4F4D_5F53_524D_8DF3_8DC3[id] ~= nil and _____5355_4F4D_5F53_524D_8DF3_8DC3_4F4D_79FB_7C7B_578B[id] == "被击退击飞"
end
____exports["获取活跃跳跃数量"] = function()
    return #_____6D3B_52A8_8DF3_8DC3_5217_8868
end
return ____exports
