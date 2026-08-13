--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.02．数值与表现配置")
local _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["亚伦柯斯正式设计配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.11．台词播放")
local _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放亚伦柯斯台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____01_FF0E_63A7_5236_4E0EBuff["开始硬直"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_0["创建技能提示圈"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_2.getServerTime
local addDelayedCallback = ____require_result_2.addDelayedCallback
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_3.YDWETimerDestroyEffectSafe
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_4["创建点特效"]
local ____require_result_5 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文")
local _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_5["读取Boss战运行上下文"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRectCenterX = jass.GetRectCenterX
local GetRectCenterY = jass.GetRectCenterY
local GetRectMinX = jass.GetRectMinX
local GetRectMaxX = jass.GetRectMaxX
local GetRectMinY = jass.GetRectMinY
local GetRectMaxY = jass.GetRectMaxY
local GetRandomInt = jass.GetRandomInt
local GetRandomReal = jass.GetRandomReal
local Cos = jass.Cos
local Sin = jass.Sin
local SquareRoot = jass.SquareRoot
local AddSpecialEffect = jass.AddSpecialEffect
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____82F1_7075_9668_661F_6280_80FDKey = "英灵陨星"
local _____89D2_5EA6_8F6C_5F27_5EA6 = 0.017453292519943295
local function _____53D6_6279_6B21_6570_91CF(context)
    local cfg = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["英灵陨星"]
    if context["阶段"] == "P3最后的誓约" then
        return cfg["P3批次数量"]
    end
    if context["阶段"] == "P2旧誓回响" then
        return cfg["P2批次数量"]
    end
    return cfg["P1批次数量"]
end
local function _____53D6_6BCF_6279_843D_70B9_6570_91CF(context)
    local cfg = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["英灵陨星"]
    if context["阶段"] == "P3最后的誓约" then
        return cfg["P3落点数量"]
    end
    if context["阶段"] == "P2旧誓回响" then
        return cfg["P2落点数量"]
    end
    return cfg["P1落点数量"]
end
local function _____7ED3_675F_82F1_7075_9668_661F(context)
    if context["当前大型技能"] == _____82F1_7075_9668_661F_6280_80FDKey then
        context["当前大型技能"] = nil
    end
end
local function _____53D6_82F1_7075_9668_661F_573A_5730(boss)
    local battle = _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587(boss)
    local ____opt_result_8
    if battle ~= nil then
        ____opt_result_8 = battle["地点矩形"]
    end
    local rect = ____opt_result_8
    if rect == nil or rect == 0 then
        return {
            ["中心X"] = GetUnitX(boss),
            ["中心Y"] = GetUnitY(boss)
        }
    end
    return {
        ["中心X"] = GetRectCenterX(rect),
        ["中心Y"] = GetRectCenterY(rect),
        ["左边界"] = GetRectMinX(rect),
        ["右边界"] = GetRectMaxX(rect),
        ["下边界"] = GetRectMinY(rect),
        ["上边界"] = GetRectMaxY(rect)
    }
end
local function _____9650_5236_5230_573A_5730_5185(point, field, padding)
    local x = point.X
    local y = point.Y
    if field["左边界"] ~= nil and field["右边界"] ~= nil and field["左边界"] + padding < field["右边界"] - padding then
        if x < field["左边界"] + padding then
            x = field["左边界"] + padding
        elseif x > field["右边界"] - padding then
            x = field["右边界"] - padding
        end
    end
    if field["下边界"] ~= nil and field["上边界"] ~= nil and field["下边界"] + padding < field["上边界"] - padding then
        if y < field["下边界"] + padding then
            y = field["下边界"] + padding
        elseif y > field["上边界"] - padding then
            y = field["上边界"] - padding
        end
    end
    return {X = x, Y = y}
end
local function _____53D6_672A_5B89_9B42_5893_7891_5217_8868(context)
    local result = {}
    do
        local i = 0
        while i < #context["墓碑状态列表"] do
            local state = context["墓碑状态列表"][i + 1]
            if state ~= nil and state["已安魂"] ~= true then
                result[#result + 1] = state
            end
            i = i + 1
        end
    end
    return result
end
local function _____843D_70B9_907F_5F00_5B89_9B42_533A_57DF(point, tombstones, radius)
    local cfg = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E
    local safeDistance = cfg["旧誓墓碑"]["安魂范围"] + radius + cfg["英灵陨星"]["P2墓碑安全间隔"]
    local safeDistanceSquared = safeDistance * safeDistance
    do
        local i = 0
        while i < #tombstones do
            local dx = point.X - tombstones[i + 1].X
            local dy = point.Y - tombstones[i + 1].Y
            if dx * dx + dy * dy < safeDistanceSquared then
                return false
            end
            i = i + 1
        end
    end
    return true
end
local function _____53D6_666E_901A_968F_673A_843D_70B9(field, tombstones, radius)
    local cfg = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["英灵陨星"]
    local fallback = _____9650_5236_5230_573A_5730_5185({X = field["中心X"], Y = field["中心Y"]}, field, radius + 32)
    do
        local attempt = 0
        while attempt < 10 do
            local angle = GetRandomReal(0, 360)
            local distance = SquareRoot(GetRandomReal(0, 1)) * cfg["生成半径"]
            local radians = angle * _____89D2_5EA6_8F6C_5F27_5EA6
            local point = _____9650_5236_5230_573A_5730_5185(
                {
                    X = field["中心X"] + Cos(radians) * distance,
                    Y = field["中心Y"] + Sin(radians) * distance
                },
                field,
                radius + 32
            )
            if _____843D_70B9_907F_5F00_5B89_9B42_533A_57DF(point, tombstones, radius) then
                return point
            end
            attempt = attempt + 1
        end
    end
    return fallback
end
local function _____53D6_5893_7891_5916_56F4_52A0_6743_843D_70B9(field, tombstones, radius)
    if #tombstones <= 0 then
        return _____53D6_666E_901A_968F_673A_843D_70B9(field, tombstones, radius)
    end
    local cfg = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E
    local tombstone = tombstones[GetRandomInt(0, #tombstones - 1) + 1]
    local toCenterFacing = jass:Atan2(field["中心Y"] - tombstone.Y, field["中心X"] - tombstone.X) * 57.29577951308232
    local minDistance = cfg["旧誓墓碑"]["安魂范围"] + radius + cfg["英灵陨星"]["P2墓碑安全间隔"]
    do
        local attempt = 0
        while attempt < 10 do
            local angle = toCenterFacing + GetRandomReal(-70, 70)
            local distance = GetRandomReal(minDistance, minDistance + cfg["英灵陨星"]["P2墓碑加权外环宽度"])
            local radians = angle * _____89D2_5EA6_8F6C_5F27_5EA6
            local point = _____9650_5236_5230_573A_5730_5185(
                {
                    X = tombstone.X + Cos(radians) * distance,
                    Y = tombstone.Y + Sin(radians) * distance
                },
                field,
                radius + 32
            )
            if _____843D_70B9_907F_5F00_5B89_9B42_533A_57DF(point, tombstones, radius) then
                return point
            end
            attempt = attempt + 1
        end
    end
    return _____53D6_666E_901A_968F_673A_843D_70B9(field, tombstones, radius)
end
local function _____7ED3_7B97_82F1_7075_9668_661F(context, x, y, radius, isP3)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] then
        return
    end
    local cfg = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E
    local meteor = AddSpecialEffect(cfg["表现资源"]["英灵陨星正式特效路径"], x, y)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["表现资源"]["英灵陨星落地特效路径"],
        X = x,
        Y = y,
        ["缩放"] = cfg["表现资源"]["英灵陨星落地特效缩放"],
        ["持续秒"] = 0.8
    })
    _____64AD_653EBoss_5750_6807_97F3_6548(cfg["音效"]["英灵陨星命中"], x, y, cfg["音效默认裁断距离"])
    if meteor ~= nil and meteor ~= 0 then
        YDWETimerDestroyEffectSafe(0.8, meteor)
    end
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local target = heroes[i + 1]
                local dx = GetUnitX(target) - x
                local dy = GetUnitY(target) - y
                if dx * dx + dy * dy > radius * radius then
                    goto __continue40
                end
                _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = target,
                    ["伤害公式"] = {["来源攻击力比例"] = isP3 and cfg["英灵陨星"]["P3伤害攻击力比例"] or cfg["英灵陨星"]["伤害攻击力比例"], ["目标最大生命比例"] = isP3 and cfg["英灵陨星"]["P3伤害目标最大生命比例"] or cfg["英灵陨星"]["伤害目标最大生命比例"]},
                    attack = false,
                    ranged = true,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["标签"] = isP3 and "亚伦柯斯·英灵陨星-送葬" or "亚伦柯斯·英灵陨星"
                })
            end
            ::__continue40::
            i = i + 1
        end
    end
    local aftershock = AddSpecialEffect(cfg["表现资源"]["英灵陨星余波特效路径"], x, y)
    if aftershock ~= nil and aftershock ~= 0 then
        YDWETimerDestroyEffectSafe(0.7, aftershock)
    end
end
local function _____5B89_6392_82F1_7075_9668_661F_843D_70B9(context, point, radius, isP3)
    local boss = context["Boss单位"]
    local cfg = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "敌方圆形",
        X = point.X,
        Y = point.Y,
        ["半径"] = radius,
        ["持续时间"] = cfg["英灵陨星"]["预警秒"],
        ["来源单位"] = boss
    })
    local warning = AddSpecialEffect(cfg["表现资源"]["英灵陨星预警特效路径"], point.X, point.Y)
    if warning ~= nil and warning ~= 0 then
        YDWETimerDestroyEffectSafe(cfg["英灵陨星"]["预警秒"], warning)
    end
    local impactId = addDelayedCallback(
        cfg["英灵陨星"]["预警秒"] * 1000,
        function()
            _____7ED3_7B97_82F1_7075_9668_661F(
                context,
                point.X,
                point.Y,
                radius,
                isP3
            )
        end
    )
    local ____self_9 = context["清理"]
    ____self_9["登记延迟回调"](____self_9, "亚伦柯斯-英灵陨星单点结算", impactId)
end
local function _____521B_5EFA_82F1_7075_9668_661F_6279_6B21(context, count, radius, isP2, isP3)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] or context["当前大型技能"] ~= _____82F1_7075_9668_661F_6280_80FDKey then
        return
    end
    local field = _____53D6_82F1_7075_9668_661F_573A_5730(boss)
    local tombstones = isP2 and _____53D6_672A_5B89_9B42_5893_7891_5217_8868(context) or ({})
    local weightedCount = count * _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["英灵陨星"]["P2墓碑加权比例"]
    do
        local i = 0
        while i < count do
            local point = isP2 and i < weightedCount and #tombstones > 0 and _____53D6_5893_7891_5916_56F4_52A0_6743_843D_70B9(field, tombstones, radius) or _____53D6_666E_901A_968F_673A_843D_70B9(field, tombstones, radius)
            _____5B89_6392_82F1_7075_9668_661F_843D_70B9(context, point, radius, isP3)
            i = i + 1
        end
    end
end
____exports["释放亚伦柯斯英灵陨星"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] or context["当前大型技能"] ~= nil then
        return false
    end
    local cfg = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["英灵陨星"]
    local batchCount = _____53D6_6279_6B21_6570_91CF(context)
    local countPerBatch = _____53D6_6BCF_6279_843D_70B9_6570_91CF(context)
    local isP2 = context["阶段"] == "P2旧誓回响"
    local isP3 = context["阶段"] == "P3最后的誓约"
    local radius = isP3 and cfg["P3伤害半径"] or cfg["常规伤害半径"]
    local totalDuration = (batchCount - 1) * cfg["批次间隔秒"] + cfg["预警秒"]
    context["当前大型技能"] = _____82F1_7075_9668_661F_6280_80FDKey
    context["普通机制忙碌到Ms"] = getServerTime() + (totalDuration + 0.4) * 1000
    _____5F00_59CB_786C_76F4(boss, cfg["施法硬直秒"])
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["动画编号"], ["持续秒"] = 1, ["恢复动画编号"] = 1})
    _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD(boss, isP3 and "英灵陨星送葬" or "英灵陨星")
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["音效"]["英灵陨星坠落"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["音效默认裁断距离"]
    )
    _____521B_5EFA_82F1_7075_9668_661F_6279_6B21(
        context,
        countPerBatch,
        radius,
        isP2,
        isP3
    )
    do
        local batch = 1
        while batch < batchCount do
            local batchId = addDelayedCallback(
                batch * cfg["批次间隔秒"] * 1000,
                function()
                    _____521B_5EFA_82F1_7075_9668_661F_6279_6B21(
                        context,
                        countPerBatch,
                        radius,
                        isP2,
                        isP3
                    )
                end
            )
            local ____self_10 = context["清理"]
            ____self_10["登记延迟回调"](____self_10, "亚伦柯斯-英灵陨星后续批次", batchId)
            batch = batch + 1
        end
    end
    local finishId = addDelayedCallback(
        (totalDuration + 0.1) * 1000,
        function()
            _____7ED3_675F_82F1_7075_9668_661F(context)
        end
    )
    local ____self_11 = context["清理"]
    ____self_11["登记延迟回调"](____self_11, "亚伦柯斯-英灵陨星结束", finishId)
    return true
end
____exports["英灵陨星迁移状态"] = {
    ["旧技能ID"] = "A0F5",
    ["通用技能壳ID"] = "AN00",
    ["已保留旧原型语义"] = true,
    ["已完成TS实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["语义"] = "以Boss或正式场地中心生成2-3轮重型落点；P2提高未安魂墓碑外围权重但避开安魂范围，P3减少落点并扩大范围与冲击。"
}
return ____exports
