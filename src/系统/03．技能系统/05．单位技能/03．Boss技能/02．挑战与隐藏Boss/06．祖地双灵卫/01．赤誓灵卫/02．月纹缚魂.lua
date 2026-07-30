--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．运行时上下文")
local _____5F00_59CB_7956_5730_53CC_7075_536B_5E38_89C4_65BD_6CD5 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["开始祖地双灵卫常规施法"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．数值与表现配置")
local _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["祖地双灵卫数值与表现配置"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411 = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["立即设置单位朝向"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____01_FF0E_63A7_5236_4E0EBuff["开始硬直"]
local ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3["计算组合技能伤害"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_0["创建技能提示圈"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
local _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = ____require_result_2["取当前有效玩家人数"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_3["造成AOE技能伤害"]
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_4.addDelayedCallback
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_5.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local IsUnitType = jass.IsUnitType
local AddSpecialEffect = jass.AddSpecialEffect
local Atan2 = jass.Atan2
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local RAD_TO_DEG = 57.29577951308232
local function _____6784_5EFA_6708_7EB9_76EE_6807_5217_8868(boss, preferred)
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local playerCount = _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570()
    local wanted = playerCount <= 2 and 1 or 2
    local result = {}
    do
        local i = 0
        while i < #heroes do
            if heroes[i + 1] == preferred and _____5355_4F4D_6709_6548(preferred) then
                result[#result + 1] = preferred
            end
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #heroes and #result < wanted do
            local hero = heroes[i + 1]
            local exists = false
            do
                local j = 0
                while j < #result do
                    if result[j + 1] == hero then
                        exists = true
                    end
                    j = j + 1
                end
            end
            if not exists and _____5355_4F4D_6709_6548(hero) then
                result[#result + 1] = hero
            end
            i = i + 1
        end
    end
    return result
end
____exports["释放月纹缚魂"] = function(context, preferredTarget)
    local boss = context["赤誓灵卫单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] or context["赤誓灵卫形态"] ~= "正常" then
        return false
    end
    local targets = _____6784_5EFA_6708_7EB9_76EE_6807_5217_8868(boss, preferredTarget)
    if #targets == 0 then
        return false
    end
    local cfg = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P1["月纹缚魂"]
    local points = {}
    _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(
        boss,
        Atan2(
            GetUnitY(targets[1]) - GetUnitY(boss),
            GetUnitX(targets[1]) - GetUnitX(boss)
        ) * RAD_TO_DEG
    )
    _____5F00_59CB_7956_5730_53CC_7075_536B_5E38_89C4_65BD_6CD5(boss, cfg["预警秒"], "月纹缚魂", "锁定位置将生成月纹并禁锢范围内玩家")
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["动画编号"], ["持续秒"] = cfg["预警秒"] + 0.2, ["恢复动画编号"] = cfg["恢复动画编号"]})
    do
        local i = 0
        while i < #targets do
            local point = {
                X = GetUnitX(targets[i + 1]),
                Y = GetUnitY(targets[i + 1])
            }
            points[#points + 1] = point
            _____521B_5EFA_6280_80FD_63D0_793A_5708({
                ["类型"] = "渐变圆形",
                X = point.X,
                Y = point.Y,
                ["半径"] = cfg["半径"],
                ["持续时间"] = cfg["预警秒"],
                ["来源单位"] = boss
            })
            local moon = AddSpecialEffect(_____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["月纹缚魂"]["月纹地面特效路径"], point.X, point.Y)
            if moon ~= nil and moon ~= 0 then
                YDWETimerDestroyEffectSafe(cfg["预警秒"] + 0.2, moon)
            end
            i = i + 1
        end
    end
    local delayedId = addDelayedCallback(
        cfg["预警秒"] * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] then
                return
            end
            local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
            local radius2 = cfg["半径"] * cfg["半径"]
            local damaged = {}
            do
                local i = 0
                while i < #points do
                    local point = points[i + 1]
                    local impact = AddSpecialEffect(_____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["月纹缚魂"]["禁锢生效特效路径"], point.X, point.Y)
                    if impact ~= nil and impact ~= 0 then
                        YDWETimerDestroyEffectSafe(0.8, impact)
                    end
                    do
                        local j = 0
                        while j < #heroes do
                            do
                                local hit = heroes[j + 1]
                                local hid = GetHandleId(hit) or 0
                                if hid == 0 or damaged[hid] == true then
                                    goto __continue24
                                end
                                local dx = GetUnitX(hit) - point.X
                                local dy = GetUnitY(hit) - point.Y
                                if dx * dx + dy * dy > radius2 then
                                    goto __continue24
                                end
                                damaged[hid] = true
                                local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, hit, {["来源攻击力比例"] = cfg["伤害攻击力比例"], ["目标最大生命比例"] = cfg["伤害目标最大生命比例"]})
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
                                    ["标签"] = "祖地双灵卫·月纹缚魂"
                                })
                                _____5F00_59CB_786C_76F4(hit, cfg["硬直秒"])
                            end
                            ::__continue24::
                            j = j + 1
                        end
                    end
                    i = i + 1
                end
            end
        end
    )
    local ____self_6 = context["清理"]
    ____self_6["登记延迟回调"](____self_6, "祖地双灵卫-月纹缚魂结算", delayedId)
    return true
end
____exports["月纹缚魂技能状态"] = {
    ["所属守卫"] = "赤誓灵卫",
    ["所属形态"] = "正常",
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["需要独立技能实例ID"] = false,
    ["包含战斗自身位移"] = false,
    ["实现要求"] = "按当前有效玩家人数锁定一至两处当前位置；提示圈、伤害和硬直共用同一半径。"
}
return ____exports
