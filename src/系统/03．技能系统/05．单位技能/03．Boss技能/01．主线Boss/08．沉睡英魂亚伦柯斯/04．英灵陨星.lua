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
local ____02_FF0E_5206_6279_70B9_540D_843D_70B9_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.05．点名技能模板.02．分批点名落点模板")
local _____5F00_59CB_5206_6279_70B9_540D_843D_70B9_6A21_677F = ____02_FF0E_5206_6279_70B9_540D_843D_70B9_6A21_677F["开始分批点名落点模板"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3["计算组合技能伤害"]
local ____require_result_0 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_0["获取Boss技能敌对英雄列表"]
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_1["造成AOE技能伤害"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_2.getServerTime
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_3.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local AddSpecialEffect = jass.AddSpecialEffect
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____82F1_7075_9668_661F_6280_80FDKey = "英灵陨星"
local function _____53D6_843D_70B9_6570_91CF(context)
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
local function _____7ED3_7B97_82F1_7075_9668_661F(context, x, y, radius)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] then
        return
    end
    local cfg = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E
    local meteor = AddSpecialEffect(cfg["表现资源"]["英灵陨星正式特效路径"], x, y)
    local impact = AddSpecialEffect(cfg["表现资源"]["英灵陨星落地特效路径"], x, y)
    _____64AD_653EBoss_5750_6807_97F3_6548(cfg["音效"]["英灵陨星命中"], x, y, cfg["音效默认裁断距离"])
    if meteor ~= nil and meteor ~= 0 then
        YDWETimerDestroyEffectSafe(0.8, meteor)
    end
    if impact ~= nil and impact ~= 0 then
        YDWETimerDestroyEffectSafe(0.8, impact)
    end
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local isP3 = context["阶段"] == "P3最后的誓约"
    do
        local i = 0
        while i < #heroes do
            do
                local target = heroes[i + 1]
                local dx = GetUnitX(target) - x
                local dy = GetUnitY(target) - y
                if dx * dx + dy * dy > radius * radius then
                    goto __continue12
                end
                local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, target, {["来源攻击力比例"] = isP3 and cfg["英灵陨星"]["P3伤害攻击力比例"] or cfg["英灵陨星"]["伤害攻击力比例"], ["目标最大生命比例"] = isP3 and cfg["英灵陨星"]["P3伤害目标最大生命比例"] or cfg["英灵陨星"]["伤害目标最大生命比例"]})
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = target,
                    ["伤害"] = damage,
                    attack = false,
                    ranged = true,
                    attackType = ATTACK_TYPE_MAGIC,
                    ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "Boss技能",
                    ["标签"] = isP3 and "亚伦柯斯·英灵陨星-送葬" or "亚伦柯斯·英灵陨星"
                })
            end
            ::__continue12::
            i = i + 1
        end
    end
    local aftershock = AddSpecialEffect(cfg["表现资源"]["英灵陨星余波特效路径"], x, y)
    if aftershock ~= nil and aftershock ~= 0 then
        YDWETimerDestroyEffectSafe(0.7, aftershock)
    end
end
____exports["释放亚伦柯斯英灵陨星"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] or context["当前大型技能"] ~= nil then
        return false
    end
    local cfg = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["英灵陨星"]
    local count = _____53D6_843D_70B9_6570_91CF(context)
    local isP3 = context["阶段"] == "P3最后的誓约"
    local radius = isP3 and cfg["P3伤害半径"] or cfg["常规伤害半径"]
    local totalDuration = (count - 1) * cfg["落点间隔秒"] + cfg["预警秒"]
    context["当前大型技能"] = _____82F1_7075_9668_661F_6280_80FDKey
    context["普通机制忙碌到Ms"] = getServerTime() + (totalDuration + 0.4) * 1000
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["动画编号"], ["持续秒"] = 1, ["恢复动画编号"] = 1})
    _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD(boss, isP3 and "英灵陨星送葬" or "英灵陨星")
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["音效"]["英灵陨星坠落"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["音效默认裁断距离"]
    )
    _____5F00_59CB_5206_6279_70B9_540D_843D_70B9_6A21_677F({
        ["名称"] = "亚伦柯斯-英灵陨星",
        ["清理"] = context["清理"],
        ["轮数"] = count,
        ["轮次间隔秒"] = cfg["落点间隔秒"],
        ["预警秒"] = cfg["预警秒"],
        ["锁定坐标"] = true,
        ["取目标列表"] = function()
            return _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
        end,
        ["提示圈"] = function(result)
            return {
                ["类型"] = "敌方圆形",
                X = result["锁定X"],
                Y = result["锁定Y"],
                ["半径"] = radius,
                ["持续时间"] = cfg["预警秒"],
                ["来源单位"] = boss
            }
        end,
        ["on锁定"] = function(result)
            local warning = AddSpecialEffect(_____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["英灵陨星预警特效路径"], result["锁定X"], result["锁定Y"])
            if warning ~= nil and warning ~= 0 then
                YDWETimerDestroyEffectSafe(cfg["预警秒"], warning)
            end
        end,
        ["on结算"] = function(result)
            _____7ED3_7B97_82F1_7075_9668_661F(context, result["锁定X"], result["锁定Y"], radius)
        end,
        ["on结束"] = function()
            _____7ED3_675F_82F1_7075_9668_661F(context)
        end,
        ["on取消"] = function()
            _____7ED3_675F_82F1_7075_9668_661F(context)
        end
    })
    return true
end
____exports["英灵陨星迁移状态"] = {
    ["旧技能ID"] = "A0F5",
    ["通用技能壳ID"] = "AN00",
    ["已保留旧原型语义"] = true,
    ["已完成TS实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["语义"] = "复用分批点名落点模板，每批重新取得有效玩家并锁定坐标；P3减少落点数量、扩大范围并提高单次冲击。"
}
return ____exports
