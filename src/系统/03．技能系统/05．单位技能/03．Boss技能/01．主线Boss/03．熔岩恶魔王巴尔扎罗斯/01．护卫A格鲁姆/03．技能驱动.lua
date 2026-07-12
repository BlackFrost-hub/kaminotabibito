--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7194_5CA9_91CD_9524 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.01．护卫A格鲁姆.01．熔岩重锤")
local _____91CA_653E_683C_9C81_59C6_91CD_9524 = ____01_FF0E_7194_5CA9_91CD_9524["释放格鲁姆重锤"]
local ____02_FF0E_7194_5CA9_706B_5F84 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.01．护卫A格鲁姆.02．熔岩火径")
local _____91CA_653E_683C_9C81_59C6_706B_5F84 = ____02_FF0E_7194_5CA9_706B_5F84["释放格鲁姆火径"]
local ____00_FF0E_516C_5171 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.01．护卫A格鲁姆.00．公共")
local _____683C_9C81_59C6_516C_5171 = ____00_FF0E_516C_5171["格鲁姆公共"]
local ____683C_9C81_59C6_516C_5171_0 = _____683C_9C81_59C6_516C_5171
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____683C_9C81_59C6_516C_5171_0["巴尔扎罗斯技能数值配置"]
local addPeriodicCallback = ____683C_9C81_59C6_516C_5171_0.addPeriodicCallback
local getServerTime = ____683C_9C81_59C6_516C_5171_0.getServerTime
local GetUnitX = ____683C_9C81_59C6_516C_5171_0.GetUnitX
local GetUnitY = ____683C_9C81_59C6_516C_5171_0.GetUnitY
local _____5355_4F4D_6709_6548 = ____683C_9C81_59C6_516C_5171_0["单位有效"]
local _____53D6_5355_4F4DID = ____683C_9C81_59C6_516C_5171_0["取单位ID"]
local _____53D6_76EE_6807_5355_4F4D = ____683C_9C81_59C6_516C_5171_0["取目标单位"]
local _____70B9_5230_5355_4F4D_8DDD_79BB_5E73_65B9 = ____683C_9C81_59C6_516C_5171_0["点到单位距离平方"]
local _____683C_9C81_59C6_91CD_9524_4E0B_6B21Ms_8868 = ____683C_9C81_59C6_516C_5171_0["格鲁姆重锤下次Ms表"]
local _____683C_9C81_59C6_706B_5F84_4E0B_6B21Ms_8868 = ____683C_9C81_59C6_516C_5171_0["格鲁姆火径下次Ms表"]
local function _____5C1D_8BD5_91CA_653E_683C_9C81_59C6_6280_80FD(context)
    local grum = context["格鲁姆"]
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) or not _____5355_4F4D_6709_6548(grum) then
        return
    end
    local target = _____53D6_76EE_6807_5355_4F4D(context)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local id = _____53D6_5355_4F4DID(grum)
    local now = getServerTime()
    local hammer = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩重锤"]
    local firePath = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩火径"]
    if now >= (_____683C_9C81_59C6_91CD_9524_4E0B_6B21Ms_8868[id] or 0) and _____70B9_5230_5355_4F4D_8DDD_79BB_5E73_65B9(
        target,
        GetUnitX(grum),
        GetUnitY(grum)
    ) <= hammer["施法距离"] * hammer["施法距离"] then
        _____683C_9C81_59C6_91CD_9524_4E0B_6B21Ms_8868[id] = now + hammer["冷却秒"] * 1000
        _____91CA_653E_683C_9C81_59C6_91CD_9524(context, target)
        return
    end
    if now >= (_____683C_9C81_59C6_706B_5F84_4E0B_6B21Ms_8868[id] or 0) then
        _____683C_9C81_59C6_706B_5F84_4E0B_6B21Ms_8868[id] = now + firePath["冷却秒"] * 1000
        _____91CA_653E_683C_9C81_59C6_706B_5F84(context, target)
    end
end
____exports["初始化巴尔扎罗斯格鲁姆技能"] = function(context)
    if context["格鲁姆技能已初始化"] then
        return
    end
    context["格鲁姆技能已初始化"] = true
    local tickId = addPeriodicCallback(
        500,
        function()
            _____5C1D_8BD5_91CA_653E_683C_9C81_59C6_6280_80FD(context)
        end
    )
    local ____self_1 = context["清理"]
    ____self_1["登记周期回调"](____self_1, "巴尔扎罗斯-格鲁姆技能驱动", tickId)
end
____exports["注册巴尔扎罗斯护卫格鲁姆"] = function()
end
return ____exports
