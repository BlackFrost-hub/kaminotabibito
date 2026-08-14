--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["注册剧情运行时单位"]
local ____02_FF0E_5267_60C5NPC_521B_5EFA = require("系统.11．剧情系统.00．公共.02．剧情NPC创建")
local _____521B_5EFA_5267_60C5_573A_666F_5355_4F4D = ____02_FF0E_5267_60C5NPC_521B_5EFA["创建剧情场景单位"]
local _____5B9A_4F4D_5267_60C5_5355_4F4D = ____02_FF0E_5267_60C5NPC_521B_5EFA["定位剧情单位"]
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.01．单位系统.08．单位配置表.04．总单位配置表")
local _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID = ____require_result_1["按名字反查总单位ID"]
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_2.YDUserDataGetSafe
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_3.createTimedEffect
local ForGroup = jass.ForGroup
local GetDestructableX = jass.GetDestructableX
local GetDestructableY = jass.GetDestructableY
local GetEnumUnit = jass.GetEnumUnit
local _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID = 15
local _____738B_5BAB_4F20_9001_95E8_5C01_5370_7279_6548 = "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl"
____exports["王宫密室场景站位表"] = {
    ["伪装卫兵王宫异变"] = {X = 16116.2, Y = -24363.8, ["朝向"] = 180},
    ["里科特王宫异变"] = {X = 15635.6, Y = -24270.9, ["朝向"] = 360},
    ["皇家禁卫王宫异变"] = {X = 15906.5, Y = -24655.4, ["朝向"] = 270},
    ["克林姆德王对峙"] = {X = 14507.6, Y = -28132.3, ["朝向"] = 90},
    ["赫克提尔对峙"] = {X = 14911.8, Y = -28141.4, ["朝向"] = 90},
    ["玩家队伍密室对白"] = {X = 14691.2, Y = -28537, ["朝向"] = 90},
    ["耶提尔密室内"] = {X = 14312.1, Y = -28371.4, ["朝向"] = 45},
    ["里凡特密室内"] = {X = 15114.9, Y = -28421.5, ["朝向"] = 135},
    ["克林姆德王受伤"] = {X = 14510.1, Y = -28134.6, ["朝向"] = 90},
    ["赫克提尔受伤"] = {X = 14936, Y = -28143.7, ["朝向"] = 90},
    ["里科特密室"] = {X = 14711.8, Y = -27896.9, ["朝向"] = 270},
    ["艾伦密室门外"] = {X = 15709.1, Y = -24275.2, ["朝向"] = 270},
    ["里凡特密室门外"] = {X = 16102, Y = -24243.5, ["朝向"] = 270},
    ["耶提尔返回王宫"] = {X = 15947.6, Y = -24545.3, ["朝向"] = 90}
}
____exports["王宫密室对峙镜头预设"] = {
    X = 14646.39,
    Y = -28294.6,
    ["高度偏移"] = 220,
    ["旋转角度"] = 110,
    ["攻角"] = 324,
    ["距离到目标"] = 2000,
    ["滚动角度"] = 0,
    ["观察区域"] = 70,
    ["远景剪裁"] = 3000
}
____exports["王宫密室演出特效表"] = {["里科特进入传承密室"] = {["模型路径"] = "Common\\Effect\\Form\\Portal\\RicketSecretRoomShift.mdx", ["持续秒"] = 3}, ["里科特战后撤离"] = {["模型路径"] = "Common\\Effect\\Form\\Portal\\RicketVoidEscape.mdx", ["持续秒"] = 3}, ["玩家队伍抵达传承密室"] = {["模型路径"] = "Common\\Effect\\Form\\Portal\\PalaceSecretRoomArrival.mdx", ["持续秒"] = 4}, ["里凡特开启传承密室门"] = {["模型路径"] = "Common\\Effect\\Form\\Portal\\RoyalBloodlineGate.mdx", ["持续秒"] = 8}}
local _____5F53_524D_73A9_5BB6_961F_4F0D_8F6C_573A_7AD9_4F4D
local function _____5B9A_4F4D_5355_4F4D(unit, _____7AD9_4F4D)
    _____5B9A_4F4D_5267_60C5_5355_4F4D(unit, _____7AD9_4F4D)
end
local function ____on_79FB_52A8_679A_4E3E_73A9_5BB6_82F1_96C4_81F3_5BC6_5BA4()
    local _____7AD9_4F4D = _____5F53_524D_73A9_5BB6_961F_4F0D_8F6C_573A_7AD9_4F4D
    if _____7AD9_4F4D == nil then
        return
    end
    _____5B9A_4F4D_5355_4F4D(
        GetEnumUnit(),
        _____7AD9_4F4D
    )
end
____exports["定位并登记王宫密室剧情单位"] = function(_____8BFB_53D6_5F15_7528, _____767B_8BB0_5F15_7528, _____7AD9_4F4D)
    local unit = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(_____8BFB_53D6_5F15_7528)
    if unit == nil or unit == 0 then
        return nil
    end
    _____5B9A_4F4D_5355_4F4D(unit, _____7AD9_4F4D)
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____767B_8BB0_5F15_7528, unit)
    return unit
end
____exports["读取或创建并定位王宫密室剧情单位"] = function(_____8BED_4E49_5F15_7528, _____5355_4F4D_540D, _____7AD9_4F4D)
    local unit = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528(_____8BED_4E49_5F15_7528)
    if unit == nil or unit == 0 then
        local _____5355_4F4DID = _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID(_____5355_4F4D_540D)
        local _____5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____5355_4F4DID)
        if not (_____5355_4F4D_7C7B_578BID > 0) then
            return nil
        end
        unit = _____521B_5EFA_5267_60C5_573A_666F_5355_4F4D({
            ["单位ID"] = _____5355_4F4DID,
            X = _____7AD9_4F4D.X,
            Y = _____7AD9_4F4D.Y,
            ["朝向"] = _____7AD9_4F4D["朝向"],
            ["玩家ID"] = _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID,
            ["登记死亡排泄"] = true
        })
    end
    if unit == nil or unit == 0 then
        return nil
    end
    _____5B9A_4F4D_5355_4F4D(unit, _____7AD9_4F4D)
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8BED_4E49_5F15_7528, unit)
    return unit
end
____exports["播放王宫密室演出特效"] = function(_____7279_6548_952E, _____7AD9_4F4D)
    local _____7279_6548 = ____exports["王宫密室演出特效表"][_____7279_6548_952E]
    createTimedEffect(
        _____7279_6548["模型路径"],
        _____7AD9_4F4D.X,
        _____7AD9_4F4D.Y,
        0,
        _____7279_6548["持续秒"]
    )
end
____exports["播放王宫传送门封印特效"] = function()
    local _____4F20_9001_95E8 = jglobals.gg_dest_B00K_5466
    if _____4F20_9001_95E8 == nil or _____4F20_9001_95E8 == 0 then
        return
    end
    createTimedEffect(
        _____738B_5BAB_4F20_9001_95E8_5C01_5370_7279_6548,
        GetDestructableX(_____4F20_9001_95E8),
        GetDestructableY(_____4F20_9001_95E8),
        0,
        1
    )
end
____exports["移动玩家英雄组到王宫密室"] = function()
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    if _____73A9_5BB6_82F1_96C4_7EC4 == nil or _____73A9_5BB6_82F1_96C4_7EC4 == 0 then
        return
    end
    _____5F53_524D_73A9_5BB6_961F_4F0D_8F6C_573A_7AD9_4F4D = ____exports["王宫密室场景站位表"]["玩家队伍密室对白"]
    ForGroup(_____73A9_5BB6_82F1_96C4_7EC4, ____on_79FB_52A8_679A_4E3E_73A9_5BB6_82F1_96C4_81F3_5BC6_5BA4)
    _____5F53_524D_73A9_5BB6_961F_4F0D_8F6C_573A_7AD9_4F4D = nil
end
return ____exports
