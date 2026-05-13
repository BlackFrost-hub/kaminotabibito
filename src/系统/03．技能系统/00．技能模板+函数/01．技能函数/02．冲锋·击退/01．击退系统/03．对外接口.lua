local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____00_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.00．共享")
local X_GAFC = ____00_FF0E_5171_4EAB.X_GAFC
local jass = ____00_FF0E_5171_4EAB.jass
local SetUnitAnimation = ____00_FF0E_5171_4EAB.SetUnitAnimation
local SetUnitTimeScale = ____00_FF0E_5171_4EAB.SetUnitTimeScale
local _____96F6_79D2_540E_64AD_653E_5355_4F4D_52A8_4F5C = ____00_FF0E_5171_4EAB["零秒后播放单位动作"]
local _____6D3B_52A8_4F4D_79FB_5217_8868 = ____00_FF0E_5171_4EAB["活动位移列表"]
local _____4F4D_79FB_6620_5C04 = ____00_FF0E_5171_4EAB["位移映射"]
local _____5355_4F4D_5F53_524D_4F4D_79FB = ____00_FF0E_5171_4EAB["单位当前位移"]
local _____53D6_53E5_67C4ID = ____00_FF0E_5171_4EAB["取句柄ID"]
local _____5FEB_7167_5355_4F4D_7EC4 = ____00_FF0E_5171_4EAB["快照单位组"]
local ____02_FF0E_9A71_52A8_4E0E_5B9E_4F8B = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.02．驱动与实例")
local _____521B_5EFA_4F4D_79FB_5B9E_4F8B = ____02_FF0E_9A71_52A8_4E0E_5B9E_4F8B["创建位移实例"]
local _____7ED3_675F_4F4D_79FBID = ____02_FF0E_9A71_52A8_4E0E_5B9E_4F8B["结束位移ID"]
local _____505C_6B62_5355_4F4D_4F4D_79FB = ____02_FF0E_9A71_52A8_4E0E_5B9E_4F8B["停止单位位移"]
local function _____8BA1_7B97_51B2_950B_884C_8D70_52A8_753B_500D_7387(_____6301_7EED_65F6_95F4)
    if _____6301_7EED_65F6_95F4 == nil or _____6301_7EED_65F6_95F4 <= 0 then
        return 1.5
    end
    if _____6301_7EED_65F6_95F4 >= 1 then
        return 1.5
    end
    local _____500D_7387 = 1 / _____6301_7EED_65F6_95F4
    if _____500D_7387 > 2.5 then
        return 2.5
    end
    return _____500D_7387
end
local function _____89E3_6790_51B2_950B_89D2_5EA6(_____5355_4F4D, _____53C2_6570)
    if _____53C2_6570["角度"] ~= nil then
        return _____53C2_6570["角度"]
    end
    if _____53C2_6570["目标X"] ~= nil and _____53C2_6570["目标Y"] ~= nil then
        return X_GAFC(
            nil,
            jass:GetUnitX(_____5355_4F4D),
            jass:GetUnitY(_____5355_4F4D),
            _____53C2_6570["目标X"],
            _____53C2_6570["目标Y"]
        )
    end
    return nil
end
local function _____89E3_6790_51FB_9000_89D2_5EA6(_____5355_4F4D, _____53C2_6570)
    if _____53C2_6570["角度"] ~= nil then
        return _____53C2_6570["角度"]
    end
    if _____53C2_6570["来源单位"] ~= nil and _____53C2_6570["来源单位"] ~= 0 then
        return X_GAFC(
            nil,
            jass:GetUnitX(_____53C2_6570["来源单位"]),
            jass:GetUnitY(_____53C2_6570["来源单位"]),
            jass:GetUnitX(_____5355_4F4D),
            jass:GetUnitY(_____5355_4F4D)
        )
    end
    if _____53C2_6570["来源X"] ~= nil and _____53C2_6570["来源Y"] ~= nil then
        return X_GAFC(
            nil,
            _____53C2_6570["来源X"],
            _____53C2_6570["来源Y"],
            jass:GetUnitX(_____5355_4F4D),
            jass:GetUnitY(_____5355_4F4D)
        )
    end
    return nil
end
____exports["开始冲锋"] = function(_____5355_4F4D, _____53C2_6570)
    local _____89D2_5EA6 = _____89E3_6790_51B2_950B_89D2_5EA6(_____5355_4F4D, _____53C2_6570)
    if _____89D2_5EA6 == nil then
        return 0
    end
    local _____539F_5F00_59CB_56DE_8C03 = _____53C2_6570["开始回调"]
    local _____539F_7ED3_675F_56DE_8C03 = _____53C2_6570["结束回调"]
    local _____884C_8D70_52A8_753B_500D_7387 = _____8BA1_7B97_51B2_950B_884C_8D70_52A8_753B_500D_7387(_____53C2_6570["持续时间"])
    local _____5408_5E76_53C2_6570 = __TS__ObjectAssign(
        {},
        _____53C2_6570,
        {
            ["开始回调"] = function(_____79FB_52A8_5355_4F4D, _____4F4D_79FBID)
                if _____79FB_52A8_5355_4F4D ~= nil and _____79FB_52A8_5355_4F4D ~= 0 and type(SetUnitAnimation) == "function" then
                    SetUnitAnimation(_____79FB_52A8_5355_4F4D, "walk")
                else
                    _____96F6_79D2_540E_64AD_653E_5355_4F4D_52A8_4F5C(_____79FB_52A8_5355_4F4D, "walk")
                end
                if type(SetUnitTimeScale) == "function" then
                    SetUnitTimeScale(_____79FB_52A8_5355_4F4D, _____884C_8D70_52A8_753B_500D_7387)
                end
                if _____539F_5F00_59CB_56DE_8C03 ~= nil then
                    _____539F_5F00_59CB_56DE_8C03(_____79FB_52A8_5355_4F4D, _____4F4D_79FBID)
                end
            end,
            ["结束回调"] = function(_____79FB_52A8_5355_4F4D, _____539F_56E0, _____4F4D_79FBID, _____547D_4E2D_76EE_6807)
                if _____79FB_52A8_5355_4F4D ~= nil and _____79FB_52A8_5355_4F4D ~= 0 and type(SetUnitTimeScale) == "function" then
                    SetUnitTimeScale(_____79FB_52A8_5355_4F4D, 1)
                end
                if _____539F_7ED3_675F_56DE_8C03 ~= nil then
                    _____539F_7ED3_675F_56DE_8C03(_____79FB_52A8_5355_4F4D, _____539F_56E0, _____4F4D_79FBID, _____547D_4E2D_76EE_6807)
                end
            end
        }
    )
    return _____521B_5EFA_4F4D_79FB_5B9E_4F8B(_____5355_4F4D, _____89D2_5EA6, _____5408_5E76_53C2_6570)
end
____exports["开始击退"] = function(_____5355_4F4D, _____53C2_6570)
    local _____89D2_5EA6 = _____89E3_6790_51FB_9000_89D2_5EA6(_____5355_4F4D, _____53C2_6570)
    if _____89D2_5EA6 == nil then
        return 0
    end
    if _____53C2_6570["主单位"] == nil and _____53C2_6570["来源单位"] ~= nil and _____53C2_6570["来源单位"] ~= 0 then
        return _____521B_5EFA_4F4D_79FB_5B9E_4F8B(
            _____5355_4F4D,
            _____89D2_5EA6,
            __TS__ObjectAssign({}, _____53C2_6570, {["主单位"] = _____53C2_6570["来源单位"]})
        )
    end
    return _____521B_5EFA_4F4D_79FB_5B9E_4F8B(_____5355_4F4D, _____89D2_5EA6, _____53C2_6570)
end
____exports["开始单位组冲锋"] = function(_____5355_4F4D_7EC4, _____53C2_6570)
    local _____5355_4F4D_5217_8868 = _____5FEB_7167_5355_4F4D_7EC4(_____5355_4F4D_7EC4)
    local _____7ED3_679C = {}
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        local _____4F4D_79FBID = ____exports["开始冲锋"](_____5355_4F4D, _____53C2_6570)
        if _____4F4D_79FBID > 0 then
            _____7ED3_679C[#_____7ED3_679C + 1] = _____4F4D_79FBID
        end
    end
    return _____7ED3_679C
end
____exports["开始单位组击退"] = function(_____5355_4F4D_7EC4, _____53C2_6570)
    local _____5355_4F4D_5217_8868 = _____5FEB_7167_5355_4F4D_7EC4(_____5355_4F4D_7EC4)
    local _____7ED3_679C = {}
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        local _____4F4D_79FBID = ____exports["开始击退"](_____5355_4F4D, _____53C2_6570)
        if _____4F4D_79FBID > 0 then
            _____7ED3_679C[#_____7ED3_679C + 1] = _____4F4D_79FBID
        end
    end
    return _____7ED3_679C
end
____exports["停止位移"] = function(_____4F4D_79FBID, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "中断"
    end
    return _____7ED3_675F_4F4D_79FBID(_____4F4D_79FBID, _____539F_56E0)
end
____exports["停止单位位移"] = _____505C_6B62_5355_4F4D_4F4D_79FB
____exports["单位是否正在位移"] = function(_____5355_4F4D)
    local _____4F4D_79FBID = _____5355_4F4D_5F53_524D_4F4D_79FB[_____53D6_53E5_67C4ID(_____5355_4F4D)]
    return not not (_____4F4D_79FBID and _____4F4D_79FB_6620_5C04[_____4F4D_79FBID])
end
____exports["获取单位当前位移ID"] = function(_____5355_4F4D)
    return _____5355_4F4D_5F53_524D_4F4D_79FB[_____53D6_53E5_67C4ID(_____5355_4F4D)] or 0
end
____exports["获取活跃位移数量"] = function()
    return #_____6D3B_52A8_4F4D_79FB_5217_8868
end
return ____exports
