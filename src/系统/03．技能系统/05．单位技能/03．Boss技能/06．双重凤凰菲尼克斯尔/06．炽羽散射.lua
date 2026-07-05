--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建菲尼克斯尔上下文"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.00．配置")
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["菲尼克斯尔单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.02．数值与表现配置")
local _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔数值与表现配置"]
local ____17_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.17．台词播放")
local _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD = ____17_FF0E_53F0_8BCD_64AD_653E["播放菲尼克斯尔台词"]
local ____19_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.19．公共工具")
local stringToFourCC = ____19_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_516C_5171_5DE5_5177["单位存活"]
local _____53D6_5355_4F4DX = ____19_FF0E_516C_5171_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____19_FF0E_516C_5171_5DE5_5177["取单位Y"]
local _____53D6_76EE_6807_6216_968F_673A_73A9_5BB6 = ____19_FF0E_516C_5171_5DE5_5177["取目标或随机玩家"]
local _____9762_5411_5355_4F4D = ____19_FF0E_516C_5171_5DE5_5177["面向单位"]
local _____8BBE_7F6E_5355_4F4D_52A8_753B = ____19_FF0E_516C_5171_5DE5_5177["设置单位动画"]
local _____663E_793A_5E38_89C4_8BFB_6761 = ____19_FF0E_516C_5171_5DE5_5177["显示常规读条"]
local _____5F00_59CB_65BD_6CD5_786C_76F4 = ____19_FF0E_516C_5171_5DE5_5177["开始施法硬直"]
local _____5EF6_8FDF = ____19_FF0E_516C_5171_5DE5_5177["延迟"]
local _____5468_671F = ____19_FF0E_516C_5171_5DE5_5177["周期"]
local _____505C_6B62_5468_671F = ____19_FF0E_516C_5171_5DE5_5177["停止周期"]
local _____521B_5EFA_9884_8B66_5706 = ____19_FF0E_516C_5171_5DE5_5177["创建预警圆"]
local _____64AD_653E_70B9_7279_6548 = ____19_FF0E_516C_5171_5DE5_5177["播放点特效"]
local _____8303_56F4_654C_4EBA = ____19_FF0E_516C_5171_5DE5_5177["范围敌人"]
local _____8BA1_7B97_653B_51FB_6700_5927_751F_547D_4F24_5BB3 = ____19_FF0E_516C_5171_5DE5_5177["计算攻击最大生命伤害"]
local _____9020_6210_706B_7130_4F24_5BB3 = ____19_FF0E_516C_5171_5DE5_5177["造成火焰伤害"]
local _____6DFB_52A0_5143_7D20_5C42_6570 = ____19_FF0E_516C_5171_5DE5_5177["添加元素层数"]
local _____6781_5750_6807X = ____19_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetRandomReal = jass.GetRandomReal
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_7C7B_578BID = stringToFourCC(_____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____70BD_7FBD_6563_5C04_6280_80FDID = stringToFourCC(_____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["炽羽散射"])
local _____70BD_7FBD_6563_5C04_5DF2_6CE8_518C = false
local function _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_71C3_70E7_533A(context, x, y, _____4F24_5BB3_4E0A_4E0B_6587)
    local config = _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["炽羽散射"]
    _____64AD_653E_70B9_7279_6548(_____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["燃烧区"], x, y, config["燃烧区持续秒"] * 1000)
    local elapsed = 0
    local tick
    tick = _____5468_671F(
        config["燃烧Tick秒"] * 1000,
        function()
            elapsed = elapsed + config["燃烧Tick秒"]
            local enemies = _____8303_56F4_654C_4EBA(context.Boss, x, y, config["燃烧区半径"])
            do
                local i = 0
                while i < #enemies do
                    local u = enemies[i + 1]
                    _____9020_6210_706B_7130_4F24_5BB3(
                        context.Boss,
                        u,
                        _____8BA1_7B97_653B_51FB_6700_5927_751F_547D_4F24_5BB3(context.Boss, u, 0, config["燃烧Tick目标最大生命比例"]),
                        "AOE",
                        _____4F24_5BB3_4E0A_4E0B_6587
                    )
                    _____6DFB_52A0_5143_7D20_5C42_6570(u, "火", config["火印层数"])
                    i = i + 1
                end
            end
            if elapsed >= config["燃烧区持续秒"] then
                _____505C_6B62_5468_671F(tick)
            end
        end
    )
    local ____self_0 = context["清理"]
    ____self_0["登记周期回调"](____self_0, "菲尼克斯尔燃烧区", tick)
end
____exports["释放菲尼克斯尔炽羽散射"] = function(context, target, _____6280_80FD_5B9E_4F8BID)
    if context["当前形态"] ~= "第一形态" or not _____5355_4F4D_5B58_6D3B(context.Boss) then
        return
    end
    local boss = context.Boss
    local realTarget = _____53D6_76EE_6807_6216_968F_673A_73A9_5BB6(boss, target)
    if not _____5355_4F4D_5B58_6D3B(realTarget) then
        return
    end
    local config = _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["炽羽散射"]
    local _____4F24_5BB3_4E0A_4E0B_6587 = {["技能ID"] = _____70BD_7FBD_6563_5C04_6280_80FDID, ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID, ["标签"] = "菲尼克斯尔炽羽散射"}
    _____9762_5411_5355_4F4D(boss, realTarget)
    _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD(boss, "炽羽散射")
    _____5F00_59CB_65BD_6CD5_786C_76F4(boss, config["读条秒"])
    _____8BBE_7F6E_5355_4F4D_52A8_753B(boss, _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第一形态"]["振翅"]["编号"], _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第一形态"]["振翅"]["倍速"])
    _____663E_793A_5E38_89C4_8BFB_6761(config["读条秒"], config["吟唱条颜色ID"], config["吟唱条标题文本"], config["吟唱条提示文本"])
    local centerX = _____53D6_5355_4F4DX(realTarget)
    local centerY = _____53D6_5355_4F4DY(realTarget)
    do
        local i = 0
        while i < config["羽毛数量"] do
            local angle = GetRandomReal(0, 360)
            local dist = GetRandomReal(80, config["扩散半径"])
            local x = _____6781_5750_6807X(centerX, dist, angle)
            local y = _____6781_5750_6807Y(centerY, dist, angle)
            _____521B_5EFA_9884_8B66_5706(x, y, config["落点半径"], config["读条秒"])
            _____5EF6_8FDF(
                config["读条秒"] * 1000,
                function()
                    _____64AD_653E_70B9_7279_6548(_____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["羽毛弹体"], x, y, 900)
                    local enemies = _____8303_56F4_654C_4EBA(boss, x, y, config["落点半径"])
                    do
                        local j = 0
                        while j < #enemies do
                            local u = enemies[j + 1]
                            _____9020_6210_706B_7130_4F24_5BB3(
                                boss,
                                u,
                                _____8BA1_7B97_653B_51FB_6700_5927_751F_547D_4F24_5BB3(boss, u, config["羽毛伤害Boss攻击力比例"], config["羽毛伤害目标最大生命比例"]),
                                "AOE",
                                _____4F24_5BB3_4E0A_4E0B_6587
                            )
                            _____6DFB_52A0_5143_7D20_5C42_6570(u, "火", config["火印层数"])
                            j = j + 1
                        end
                    end
                    _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_71C3_70E7_533A(context, x, y, _____4F24_5BB3_4E0A_4E0B_6587)
                end
            )
            i = i + 1
        end
    end
end
local function ____on_83F2_5C3C_514B_65AF_5C14_70BD_7FBD_6563_5C04_751F_6548(castingUnit, spellAbilityId, _____6280_80FD_5B9E_4F8BID)
    if spellAbilityId ~= _____70BD_7FBD_6563_5C04_6280_80FDID then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(castingUnit) or GetUnitTypeId(castingUnit) ~= _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587(castingUnit)
    if context ~= nil then
        ____exports["释放菲尼克斯尔炽羽散射"](context, nil, _____6280_80FD_5B9E_4F8BID)
    end
end
____exports["注册菲尼克斯尔炽羽散射"] = function()
    if _____70BD_7FBD_6563_5C04_5DF2_6CE8_518C then
        return
    end
    _____70BD_7FBD_6563_5C04_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "菲尼克斯尔炽羽散射",
        ["单位类型ID"] = _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____70BD_7FBD_6563_5C04_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss, _____6280_80FD_5B9E_4F8BID)
            ____on_83F2_5C3C_514B_65AF_5C14_70BD_7FBD_6563_5C04_751F_6548(boss, _____70BD_7FBD_6563_5C04_6280_80FDID, _____6280_80FD_5B9E_4F8BID)
        end
    })
end
return ____exports
