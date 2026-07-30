local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．运行时上下文")
local _____5F00_59CB_7956_5730_53CC_7075_536B_5E38_89C4_65BD_6CD5 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["开始祖地双灵卫常规施法"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．数值与表现配置")
local _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["祖地双灵卫数值与表现配置"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411 = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["立即设置单位朝向"]
local ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3["计算组合技能伤害"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____4E24_70B9_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["两点角度"]
local _____6781_5750_6807X = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标Y"]
local _____8DDD_79BB_5E73_65B9XY = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["距离平方XY"]
local _____9650_5236_6570_503C = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["限制数值"]
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位有效"]
local ____01_FF0E_6301_7EED_5371_9669_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域")
local _____521B_5EFA_6301_7EED_5371_9669_533A_57DF = ____01_FF0E_6301_7EED_5371_9669_533A_57DF["创建持续危险区域"]
local ____12_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.12．台词播放")
local _____64AD_653E_82CD_5F71_7075_536B_53F0_8BCD = ____12_FF0E_53F0_8BCD_64AD_653E["播放苍影灵卫台词"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_0["创建技能提示圈"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_2["造成AOE技能伤害"]
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local getServerTime = ____require_result_3.getServerTime
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local function _____79FB_9664_7A7A_767D_7075_57DF_72B6_6001(context, state)
    do
        local i = #context["空白灵域列表"] - 1
        while i >= 0 do
            if context["空白灵域列表"][i + 1] == state then
                __TS__ArraySplice(context["空白灵域列表"], i, 1)
            end
            i = i - 1
        end
    end
end
local function _____6E05_7406_8FC7_671F_7A7A_767D_7075_57DF(context)
    local now = getServerTime()
    do
        local i = #context["空白灵域列表"] - 1
        while i >= 0 do
            if context["空白灵域列表"][i + 1]["到期Ms"] <= now then
                __TS__ArraySplice(context["空白灵域列表"], i, 1)
            end
            i = i - 1
        end
    end
end
local function _____8C03_6574_5230_573A_5185_4E14_907F_5F00_9547_9B42_5370(context, x, y)
    local radius = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["记忆剥落"]["半径"]
    local resultX = _____9650_5236_6570_503C(x, context["场地中心X"] - context["场地半宽"] + radius, context["场地中心X"] + context["场地半宽"] - radius)
    local resultY = _____9650_5236_6570_503C(y, context["场地中心Y"] - context["场地半高"] + radius, context["场地中心Y"] + context["场地半高"] - radius)
    local seal = context["镇魂印"]
    if seal ~= nil and seal["到期Ms"] > getServerTime() then
        local safeDistance = radius + seal["半径"] + 80
        if _____8DDD_79BB_5E73_65B9XY(resultX, resultY, seal.X, seal.Y) < safeDistance * safeDistance then
            local facing = _____4E24_70B9_89D2_5EA6(seal.X, seal.Y, resultX, resultY)
            resultX = _____9650_5236_6570_503C(
                _____6781_5750_6807X(seal.X, facing, safeDistance),
                context["场地中心X"] - context["场地半宽"] + radius,
                context["场地中心X"] + context["场地半宽"] - radius
            )
            resultY = _____9650_5236_6570_503C(
                _____6781_5750_6807Y(seal.Y, facing, safeDistance),
                context["场地中心Y"] - context["场地半高"] + radius,
                context["场地中心Y"] + context["场地半高"] - radius
            )
        end
    end
    return {X = resultX, Y = resultY}
end
local function _____521B_5EFA_7A7A_767D_7075_57DF(context, boss, x, y)
    local cfg = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["记忆剥落"]
    local state = {
        X = x,
        Y = y,
        ["半径"] = cfg["半径"],
        ["到期Ms"] = getServerTime() + cfg["持续秒"] * 1000
    }
    local ____context__7A7A_767D_7075_57DF_5217_8868_4 = context["空白灵域列表"]
    ____context__7A7A_767D_7075_57DF_5217_8868_4[#____context__7A7A_767D_7075_57DF_5217_8868_4 + 1] = state
    local instance
    instance = _____521B_5EFA_6301_7EED_5371_9669_533A_57DF({
        X = x,
        Y = y,
        ["半径"] = cfg["半径"],
        ["持续时间"] = cfg["持续秒"],
        ["检测间隔"] = cfg["检查间隔秒"],
        ["影响目标"] = "敌方",
        ["所有者"] = boss,
        ["模型路径"] = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["记忆剥落"]["空白灵域地面特效路径"],
        ["提示圈"] = {["类型"] = "敌方圆形", ["来源单位"] = boss},
        ["on周期"] = function(units)
            do
                local i = 0
                while i < #units do
                    do
                        local hit = units[i + 1]
                        if not _____5355_4F4D_6709_6548(hit) then
                            goto __continue16
                        end
                        local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, hit, {["来源攻击力比例"] = cfg["每跳攻击力比例"], ["目标最大生命比例"] = cfg["每跳目标最大生命比例"]})
                        _____9020_6210AOE_6280_80FD_4F24_5BB3({
                            ["来源"] = boss,
                            ["目标"] = hit,
                            ["伤害"] = damage,
                            attack = false,
                            ranged = true,
                            attackType = ATTACK_TYPE_NORMAL,
                            ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                            weaponType = WEAPON_TYPE_WHOKNOWS,
                            ["来源类型"] = "Boss技能",
                            ["标签"] = "祖地双灵卫·记忆剥落"
                        })
                    end
                    ::__continue16::
                    i = i + 1
                end
            end
        end,
        ["on销毁"] = function()
            _____79FB_9664_7A7A_767D_7075_57DF_72B6_6001(context, state)
        end
    })
    local ____self_7 = context["清理"]
    ____self_7["登记清理"](
        ____self_7,
        "祖地双灵卫-空白灵域",
        function()
            if instance ~= nil then
                instance["销毁"]()
            end
        end
    )
end
____exports["释放记忆剥落"] = function(context, target)
    local boss = context["苍影灵卫单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] then
        return false
    end
    _____6E05_7406_8FC7_671F_7A7A_767D_7075_57DF(context)
    local cfg = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P2["记忆剥落"]
    local available = cfg["同时存在上限"] - #context["空白灵域列表"]
    if available <= 0 then
        return false
    end
    _____64AD_653E_82CD_5F71_7075_536B_53F0_8BCD(boss, "记忆剥落")
    local baseX = _____5355_4F4D_6709_6548(target) and GetUnitX(target) or context["场地中心X"]
    local baseY = _____5355_4F4D_6709_6548(target) and GetUnitY(target) or context["场地中心Y"]
    local bossFacing = _____4E24_70B9_89D2_5EA6(
        GetUnitX(boss),
        GetUnitY(boss),
        baseX,
        baseY
    )
    local sideFacing = bossFacing + 90
    local points = {}
    local count = available < 2 and available or 2
    do
        local i = 0
        while i < count do
            local signedOffset = (i == 0 and -1 or 1) * cfg["半径"] * 0.9
            points[#points + 1] = _____8C03_6574_5230_573A_5185_4E14_907F_5F00_9547_9B42_5370(
                context,
                _____6781_5750_6807X(baseX, sideFacing, signedOffset),
                _____6781_5750_6807Y(baseY, sideFacing, signedOffset)
            )
            i = i + 1
        end
    end
    context["大型机制忙碌到Ms"] = getServerTime() + (cfg["预警秒"] + cfg["持续秒"]) * 1000
    _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(boss, bossFacing)
    _____5F00_59CB_7956_5730_53CC_7075_536B_5E38_89C4_65BD_6CD5(boss, cfg["预警秒"], "记忆剥落", "两块空白灵域将在锁定位置生成并持续侵蚀")
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["动画编号"], ["持续秒"] = cfg["预警秒"] + 0.25, ["恢复动画编号"] = cfg["恢复动画编号"]})
    do
        local i = 0
        while i < #points do
            _____521B_5EFA_6280_80FD_63D0_793A_5708({
                ["类型"] = "敌方圆形",
                X = points[i + 1].X,
                Y = points[i + 1].Y,
                ["半径"] = cfg["半径"],
                ["持续时间"] = cfg["预警秒"],
                ["来源单位"] = boss
            })
            i = i + 1
        end
    end
    local createId = addDelayedCallback(
        cfg["预警秒"] * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] then
                return
            end
            do
                local i = 0
                while i < #points do
                    _____521B_5EFA_7A7A_767D_7075_57DF(context, boss, points[i + 1].X, points[i + 1].Y)
                    i = i + 1
                end
            end
        end
    )
    local ____self_8 = context["清理"]
    ____self_8["登记延迟回调"](____self_8, "祖地双灵卫-记忆剥落生成", createId)
    return true
end
____exports["记忆剥落技能状态"] = {
    ["所属形态"] = "无面祷影",
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["需要独立技能实例ID"] = false,
    ["包含战斗自身位移"] = false,
    ["实现要求"] = "复用持续危险区域生成最多两块空白灵域，并在选点时避开当前镇魂印处理区。"
}
return ____exports
