--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.00．配置")
local _____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["影骨莫特斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建影骨莫特斯上下文"]
local _____5237_65B0_5F71_9AA8_76D7_8D3C_9057_4EA7Buff = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["刷新影骨盗贼遗产Buff"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.02．数值与表现配置")
local _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯数值与表现配置"]
local _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯表现配置"]
local _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["影骨莫特斯音效配置"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.08．台词播放")
local _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放影骨莫特斯台词"]
local ____11_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.11．公共工具")
local _____5355_4F4D_6709_6548 = ____11_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____64AD_653E_5F71_9AA8_83AB_7279_65AF_9650_65F6_52A8_4F5C = ____11_FF0E_516C_5171_5DE5_5177["播放影骨莫特斯限时动作"]
local stringToFourCC = ____11_FF0E_516C_5171_5DE5_5177.stringToFourCC
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.01．固定组合技能执行器")
local _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668["创建固定组合技能执行器"]
local ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.02．固定时间轴阶段工厂")
local _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868 = ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382["创建固定时间轴阶段列表"]
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_0["创建点特效"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IssueTargetOrder = jass.IssueTargetOrder
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.12．交互宝箱桥接")
local _____521B_5EFA_4EA4_4E92_5B9D_7BB1 = ____require_result_1["创建交互宝箱"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容")
local _____4E34_65F6_8C03_6574_653B_51FB = ____require_result_2["临时调整攻击"]
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_3["读取单位攻击力"]
local _____5F71_9AA8_5355_4F4D_7C7B_578BID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____76D7_8D3C_9057_4EA7_6280_80FDID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["盗贼的遗产"])
local _____5DF2_6CE8_518C_76D7_8D3C_9057_4EA7 = false
local function _____7ED9Boss_53E0_52A0_76D7_8D3C_9057_4EA7(context)
    context["已开启遗产宝箱数"] = context["已开启遗产宝箱数"] + 1
    local bonus = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(context["Boss单位"]) * _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["盗贼的遗产"]["每个宝箱Boss攻击提高"]
    _____4E34_65F6_8C03_6574_653B_51FB(context["Boss单位"], bonus)
    _____5237_65B0_5F71_9AA8_76D7_8D3C_9057_4EA7Buff(context)
end
local function _____5F00_542F_5F71_9AA8_5B9D_7BB1(context, x, y)
    _____7ED9Boss_53E0_52A0_76D7_8D3C_9057_4EA7(context)
    _____521B_5EFA_70B9_7279_6548({["模型路径"] = _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["宝箱出现"], X = x, Y = y, ["持续秒"] = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["盗贼的遗产"]["瞬时特效持续秒"]})
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["盗贼的遗产"]["增益回流"],
        GetUnitX(context["Boss单位"]),
        GetUnitY(context["Boss单位"]),
        _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
end
local function _____5F71_9AA8_9057_4EA7_5B9D_7BB1_5F00_542F_4E2D(opener, _chest, _elapsed, _config, variable)
    if variable == nil or not _____5355_4F4D_6709_6548(opener) then
        return
    end
    local context = variable.context
    if _____5355_4F4D_6709_6548(context["Boss单位"]) then
        IssueTargetOrder(context["Boss单位"], "attack", opener)
    end
    do
        local i = 0
        while i < #context["幽影召唤物"] do
            local summon = context["幽影召唤物"][i + 1]
            if _____5355_4F4D_6709_6548(summon) then
                IssueTargetOrder(summon, "attack", opener)
            end
            i = i + 1
        end
    end
end
local function _____5F71_9AA8_9057_4EA7_5B9D_7BB1_5F00_542F_5B8C_6210(opener, _chest, _config, variable)
    if variable == nil or not _____5355_4F4D_6709_6548(opener) then
        return
    end
    _____5F00_542F_5F71_9AA8_5B9D_7BB1(variable.context, variable.X, variable.Y)
end
local function _____521B_5EFA_5F71_9AA8_5B9D_7BB1(context, index)
    local point = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["盗贼的遗产"]["宝箱点"][index + 1]
    if point == nil then
        return
    end
    _____521B_5EFA_70B9_7279_6548({["模型路径"] = _____5F71_9AA8_83AB_7279_65AF_8868_73B0_914D_7F6E["宝箱出现"], X = point.X, Y = point.Y, ["持续秒"] = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["盗贼的遗产"]["瞬时特效持续秒"]})
    _____64AD_653EBoss_5750_6807_97F3_6548(_____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["盗贼的遗产"]["宝箱出现"], point.X, point.Y, _____5F71_9AA8_83AB_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"])
    _____521B_5EFA_4EA4_4E92_5B9D_7BB1({
        ["清理"] = context["清理"],
        ["名称"] = "影骨-盗贼遗产宝箱",
        ["可破坏物ID"] = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["盗贼的遗产"]["宝箱可破坏物ID"],
        X = point.X,
        Y = point.Y,
        ["朝向"] = point["朝向"],
        ["变量"] = {context = context, X = point.X, Y = point.Y},
        ["on开启中"] = _____5F71_9AA8_9057_4EA7_5B9D_7BB1_5F00_542F_4E2D,
        ["on开启完成"] = _____5F71_9AA8_9057_4EA7_5B9D_7BB1_5F00_542F_5B8C_6210
    })
end
local function _____8FFD_52A0_9057_4EA7_5B9D_7BB1_751F_6210_65F6_95F4_8F74(_____4E8B_4EF6_5217_8868, context, index)
    _____4E8B_4EF6_5217_8868[#_____4E8B_4EF6_5217_8868 + 1] = {
        ["时点毫秒"] = index * 500,
        ["名称"] = ("盗贼遗产第" .. tostring(index + 1)) .. "个宝箱",
        ["执行"] = function()
            _____521B_5EFA_5F71_9AA8_5B9D_7BB1(context, index)
        end
    }
end
____exports["释放影骨盗贼遗产"] = function(context)
    if context["遗产宝箱已生成"] then
        return
    end
    local cfg = _____5F71_9AA8_83AB_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["盗贼的遗产"]
    local count = cfg["宝箱数量"]
    if count <= 0 then
        return
    end
    if context["盗贼遗产组合执行器"] == nil then
        context["盗贼遗产组合执行器"] = _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668({["名称"] = "影骨莫特斯-盗贼遗产", ["清理"] = context["清理"], ["互斥组"] = "影骨莫特斯盗贼遗产"})
    end
    local ____self_4 = context["盗贼遗产组合执行器"]
    if ____self_4["是否运行中"](____self_4) then
        return
    end
    local _____4E8B_4EF6_5217_8868 = {}
    do
        local i = 0
        while i < count do
            _____8FFD_52A0_9057_4EA7_5B9D_7BB1_751F_6210_65F6_95F4_8F74(_____4E8B_4EF6_5217_8868, context, i)
            i = i + 1
        end
    end
    context["遗产宝箱已生成"] = true
    _____64AD_653E_5F71_9AA8_83AB_7279_65AF_9650_65F6_52A8_4F5C(context["Boss单位"], cfg["动画编号"], cfg["动画速度"], cfg["动画播放秒"])
    _____64AD_653E_5F71_9AA8_83AB_7279_65AF_53F0_8BCD(context["Boss单位"], "盗贼的遗产")
    local ____self_5 = context["盗贼遗产组合执行器"]
    local _____6267_884CID = ____self_5["开始"](
        ____self_5,
        {
            key = "盗贼的遗产",
            ["单位"] = context["Boss单位"],
            ["上下文"] = context,
            ["最大持续毫秒"] = count * 500 + 500,
            ["阶段列表"] = _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868(_____4E8B_4EF6_5217_8868)
        }
    )
    if _____6267_884CID == 0 then
        context["遗产宝箱已生成"] = false
    end
end
local function ____on_5F71_9AA8_76D7_8D3C_9057_4EA7_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____76D7_8D3C_9057_4EA7_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____5F71_9AA8_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587(castingUnit)
    if context ~= nil then
        ____exports["释放影骨盗贼遗产"](context)
    end
end
____exports["注册影骨莫特斯盗贼的遗产"] = function()
    if _____5DF2_6CE8_518C_76D7_8D3C_9057_4EA7 then
        return
    end
    _____5DF2_6CE8_518C_76D7_8D3C_9057_4EA7 = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "07．盗贼的遗产",
        ["单位类型ID"] = _____5F71_9AA8_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____76D7_8D3C_9057_4EA7_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_5F71_9AA8_76D7_8D3C_9057_4EA7_65BD_6CD5(boss, _____76D7_8D3C_9057_4EA7_6280_80FDID)
        end
    })
end
return ____exports
