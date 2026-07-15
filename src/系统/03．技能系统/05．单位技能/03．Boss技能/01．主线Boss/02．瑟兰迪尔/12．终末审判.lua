local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local _____8DDD_79BB_5E73_65B9 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["距离平方XY"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.02．数值与表现配置")
local _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["瑟兰迪尔数值与表现配置"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.15．台词播放")
local _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放瑟兰迪尔台词"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBoss_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行Boss技能伤害"]
local ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.01．固定组合技能执行器")
local _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668["创建固定组合技能执行器"]
local ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.02．固定时间轴阶段工厂")
local _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868 = ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382["创建固定时间轴阶段列表"]
local ____require_result_0 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_0["获取Boss技能敌对英雄列表"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_1["创建点特效"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_2["开始硬直"]
local ____require_result_3 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5927_62DB_541F_5531_6761 = ____require_result_3["显示大招吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_3["关闭吟唱条"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_4["创建技能提示圈"]
local ____require_result_5 = require("lib.扩展函数.封装函数.02．音效系统.index")
local Sound3DII_CooPlayReuse = ____require_result_5.Sound3DII_CooPlayReuse
local ____require_result_6 = require("系统.04．伤害系统.08．技能伤害系统")
local _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_6["创建独立技能伤害实例"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local function _____64AD_653E_70B9_7279_6548(model, x, y, duration, scale)
    if duration == nil then
        duration = 1
    end
    if scale == nil then
        scale = 1
    end
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = model,
        X = x,
        Y = y,
        ["缩放"] = scale,
        ["持续秒"] = duration
    })
end
local function _____64AD_653EBoss_84C4_529BTick(boss)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["终末审判"]
    local x = GetUnitX(boss)
    local y = GetUnitY(boss)
    SetUnitTimeScale(boss, config["蓄力动画速度"])
    SetUnitAnimationByIndex(boss, config["蓄力动画编号"])
    _____64AD_653E_70B9_7279_6548(
        config["蓄力特效"],
        x,
        y,
        0.6,
        config["蓄力法阵缩放"]
    )
    _____64AD_653E_70B9_7279_6548(
        config["法阵叠加特效"],
        x,
        y,
        0.6,
        config["蓄力法阵缩放"]
    )
end
local function _____521B_5EFA_7EC8_672B_5BA1_5224_7206_70B8_7279_6548(x, y)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["终末审判"]
    _____64AD_653E_70B9_7279_6548(config["爆炸特效"], x, y, 2)
    _____64AD_653E_70B9_7279_6548(config["爆炸特效2"], x, y, 2)
    _____64AD_653E_70B9_7279_6548(config["爆炸特效3"], x, y, 2)
end
local function _____64AD_653E_7EC8_672B_5BA1_5224_4E3B_7ED3_7B97_97F3_6548(x, y)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["终末审判"]
    Sound3DII_CooPlayReuse(
        config["结算主冲击音效"],
        x,
        y,
        0,
        config["结算音效裁断距离"]
    )
end
local function _____64AD_653E_7EC8_672B_5BA1_5224_6269_6563_97F3_6548(x, y)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["终末审判"]
    Sound3DII_CooPlayReuse(
        config["结算扩散音效"],
        x,
        y,
        0,
        config["结算音效裁断距离"]
    )
end
local function _____8BA1_7B97_7206_70B8_7279_6548_524D_7F6E_5EF6_8FDF_6BEB_79D2()
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["终末审判"]
    local delayMs = config["爆炸延迟秒"] * 1000 - config["爆炸特效提前毫秒"]
    if delayMs < 0 then
        return 0
    end
    return delayMs
end
local function _____521B_5EFA_7EC8_672B_5BA1_5224_65F6_95F4_8F74_4E8B_4EF6(context)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["终末审判"]
    local boss = context["Boss单位"]
    local _____5F15_5BFC_6BEB_79D2 = config["引导秒"] * 1000
    local _____7206_70B8_6BEB_79D2 = _____5F15_5BFC_6BEB_79D2 + config["爆炸延迟秒"] * 1000
    local _____4E8B_4EF6_5217_8868 = {}
    local xs = {}
    local ys = {}
    local targets = {}
    local _____6280_80FD_5B9E_4F8BID = 0
    local _____7ED3_7B97X = 0
    local _____7ED3_7B97Y = 0
    do
        local _____65F6_70B9_6BEB_79D2 = 0
        while _____65F6_70B9_6BEB_79D2 < _____5F15_5BFC_6BEB_79D2 do
            _____4E8B_4EF6_5217_8868[#_____4E8B_4EF6_5217_8868 + 1] = {
                ["时点毫秒"] = _____65F6_70B9_6BEB_79D2,
                ["名称"] = "终末审判蓄力",
                ["执行"] = function()
                    if _____5355_4F4D_6709_6548(boss) then
                        _____64AD_653EBoss_84C4_529BTick(boss)
                    end
                end
            }
            _____65F6_70B9_6BEB_79D2 = _____65F6_70B9_6BEB_79D2 + config["蓄力Tick毫秒"]
        end
    end
    __TS__ArraySplice(
        _____4E8B_4EF6_5217_8868,
        0,
        0,
        {
            ["时点毫秒"] = 0,
            ["名称"] = "终末审判开始",
            ["执行"] = function()
                if not _____5355_4F4D_6709_6548(boss) then
                    return
                end
                _____6280_80FD_5B9E_4F8BID = _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B({["来源类型"] = "Boss技能", ["标签"] = "瑟兰迪尔终末审判", ["持续时间秒"] = config["引导秒"] + config["爆炸延迟秒"] + 2})
                _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD(boss, "终末审判")
                _____5F00_59CB_786C_76F4(boss, config["引导秒"])
                _____663E_793A_5927_62DB_541F_5531_6761({["总时长"] = config["引导秒"], ["颜色ID"] = config["吟唱条颜色ID"], ["标题文本"] = config["吟唱条标题文本"], ["提示文本"] = config["吟唱条提示文本"]})
            end
        }
    )
    _____4E8B_4EF6_5217_8868[#_____4E8B_4EF6_5217_8868 + 1] = {
        ["时点毫秒"] = _____5F15_5BFC_6BEB_79D2,
        ["名称"] = "终末审判布阵",
        ["执行"] = function()
            _____5173_95ED_541F_5531_6761("大招")
            if not _____5355_4F4D_6709_6548(boss) then
                return
            end
            SetUnitTimeScale(boss, config["结算动画速度"])
            SetUnitAnimationByIndex(boss, config["结算动画编号"])
            _____7ED3_7B97X = GetUnitX(boss)
            _____7ED3_7B97Y = GetUnitY(boss)
            _____64AD_653E_70B9_7279_6548(
                config["蓄力完成特效"],
                _____7ED3_7B97X,
                _____7ED3_7B97Y,
                2,
                config["蓄力完成冲击缩放"]
            )
            _____64AD_653E_70B9_7279_6548(
                config["警示特效"],
                _____7ED3_7B97X,
                _____7ED3_7B97Y,
                config["爆炸延迟秒"] + 0.5,
                config["场地法阵缩放"]
            )
            _____64AD_653E_70B9_7279_6548(
                config["法阵叠加特效"],
                _____7ED3_7B97X,
                _____7ED3_7B97Y,
                config["爆炸延迟秒"] + 0.5,
                config["场地法阵缩放"]
            )
            _____521B_5EFA_6280_80FD_63D0_793A_5708({
                ["类型"] = "白色安全圆",
                X = _____7ED3_7B97X,
                Y = _____7ED3_7B97Y,
                ["半径"] = config["安全区半径"],
                ["持续时间"] = config["爆炸延迟秒"] + 0.5
            })
            local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
            do
                local i = 0
                while i < #heroes do
                    local target = heroes[i + 1]
                    xs[#xs + 1] = GetUnitX(target)
                    ys[#ys + 1] = GetUnitY(target)
                    targets[#targets + 1] = target
                    i = i + 1
                end
            end
        end
    }
    _____4E8B_4EF6_5217_8868[#_____4E8B_4EF6_5217_8868 + 1] = {
        ["时点毫秒"] = _____5F15_5BFC_6BEB_79D2 + config["恢复动作延迟Ms"],
        ["名称"] = "终末审判恢复动作",
        ["执行"] = function()
            if not _____5355_4F4D_6709_6548(boss) then
                return
            end
            SetUnitTimeScale(boss, config["恢复动画速度"])
            SetUnitAnimationByIndex(boss, config["恢复动画编号"])
        end
    }
    _____4E8B_4EF6_5217_8868[#_____4E8B_4EF6_5217_8868 + 1] = {
        ["时点毫秒"] = _____5F15_5BFC_6BEB_79D2 + _____8BA1_7B97_7206_70B8_7279_6548_524D_7F6E_5EF6_8FDF_6BEB_79D2(),
        ["名称"] = "终末审判爆炸预表现",
        ["执行"] = function()
            if not _____5355_4F4D_6709_6548(boss) then
                return
            end
            do
                local i = 0
                while i < #targets do
                    do
                        if not _____5355_4F4D_6709_6548(targets[i + 1]) then
                            goto __continue25
                        end
                        _____521B_5EFA_7EC8_672B_5BA1_5224_7206_70B8_7279_6548(xs[i + 1], ys[i + 1])
                    end
                    ::__continue25::
                    i = i + 1
                end
            end
        end
    }
    _____4E8B_4EF6_5217_8868[#_____4E8B_4EF6_5217_8868 + 1] = {
        ["时点毫秒"] = _____7206_70B8_6BEB_79D2,
        ["名称"] = "终末审判伤害结算",
        ["执行"] = function()
            if not _____5355_4F4D_6709_6548(boss) then
                return
            end
            local bossX = GetUnitX(boss)
            local bossY = GetUnitY(boss)
            _____7ED3_7B97X = bossX
            _____7ED3_7B97Y = bossY
            _____64AD_653E_7EC8_672B_5BA1_5224_4E3B_7ED3_7B97_97F3_6548(bossX, bossY)
            local safeRadius2 = config["安全区半径"] * config["安全区半径"]
            do
                local i = 0
                while i < #targets do
                    do
                        local target = targets[i + 1]
                        if not _____5355_4F4D_6709_6548(target) then
                            goto __continue30
                        end
                        if _____8DDD_79BB_5E73_65B9(
                            GetUnitX(target),
                            GetUnitY(target),
                            bossX,
                            bossY
                        ) > safeRadius2 then
                            _____6267_884CBoss_6280_80FD_4F24_5BB3({
                                ["来源"] = boss,
                                ["目标"] = target,
                                ["伤害公式"] = {["来源攻击力比例"] = config["爆炸伤害Boss攻击力比例"], ["目标最大生命比例"] = config["爆炸伤害目标最大生命比例"], ["总倍率"] = config["爆炸伤害总倍率"]},
                                attack = false,
                                ranged = false,
                                attackType = jass.ATTACK_TYPE_NORMAL,
                                ["伤害类型"] = jass.DAMAGE_TYPE_MAGIC,
                                weaponType = jass.WEAPON_TYPE_WHOKNOWS,
                                ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                                ["标签"] = "瑟兰迪尔终末审判",
                                ["伤害形态"] = "AOE"
                            })
                        end
                    end
                    ::__continue30::
                    i = i + 1
                end
            end
        end
    }
    _____4E8B_4EF6_5217_8868[#_____4E8B_4EF6_5217_8868 + 1] = {
        ["时点毫秒"] = _____7206_70B8_6BEB_79D2 + config["结算扩散音效延迟毫秒"],
        ["名称"] = "终末审判扩散音效",
        ["执行"] = function()
            if _____5355_4F4D_6709_6548(boss) then
                _____64AD_653E_7EC8_672B_5BA1_5224_6269_6563_97F3_6548(_____7ED3_7B97X, _____7ED3_7B97Y)
            end
        end
    }
    return _____4E8B_4EF6_5217_8868
end
____exports["释放瑟兰迪尔终末审判"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return false
    end
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["终末审判"]
    if context["终末审判组合执行器"] == nil then
        context["终末审判组合执行器"] = _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668({["名称"] = "瑟兰迪尔-终末审判", ["清理"] = context["清理"], ["互斥组"] = "瑟兰迪尔大型技能"})
    end
    local ____self_7 = context["终末审判组合执行器"]
    local _____6267_884CID = ____self_7["开始"](
        ____self_7,
        {
            key = "终末审判",
            ["单位"] = boss,
            ["上下文"] = context,
            ["最大持续毫秒"] = (config["引导秒"] + config["爆炸延迟秒"]) * 1000 + config["结算扩散音效延迟毫秒"] + 1000,
            ["阶段列表"] = _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868(_____521B_5EFA_7EC8_672B_5BA1_5224_65F6_95F4_8F74_4E8B_4EF6(context)),
            ["结束回调"] = function(event)
                if event["原因"] == "完成" then
                    return
                end
                _____5173_95ED_541F_5531_6761("大招")
                if not _____5355_4F4D_6709_6548(boss) then
                    return
                end
                SetUnitTimeScale(boss, config["恢复动画速度"])
                SetUnitAnimationByIndex(boss, config["恢复动画编号"])
            end
        }
    )
    return _____6267_884CID ~= 0
end
return ____exports
