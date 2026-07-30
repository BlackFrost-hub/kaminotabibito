local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.00．配置")
local _____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["莫尔特斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建莫尔特斯上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.02．数值与表现配置")
local _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯数值与表现配置"]
local _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯音效配置"]
local ____03_FF0E_8150_8D25_503C_4E0E_6839_987B_9886_57DF = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.03．腐败值与根须领域")
local _____5E94_7528_83AB_5C14_7279_65AF_8150_8D25_503C = ____03_FF0E_8150_8D25_503C_4E0E_6839_987B_9886_57DF["应用莫尔特斯腐败值"]
local ____13_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.13．台词播放")
local _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD = ____13_FF0E_53F0_8BCD_64AD_653E["播放莫尔特斯台词"]
local ____16_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.16．公共工具")
local _____5355_4F4D_6709_6548 = ____16_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____64AD_653E_83AB_5C14_7279_65AF_9650_65F6_52A8_4F5C = ____16_FF0E_516C_5171_5DE5_5177["播放莫尔特斯限时动作"]
local _____5F00_59CB_83AB_5C14_7279_65AF_5E38_89C4_65BD_6CD5 = ____16_FF0E_516C_5171_5DE5_5177["开始莫尔特斯常规施法"]
local _____6781_5750_6807X = ____16_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____16_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9 = ____16_FF0E_516C_5171_5DE5_5177["点到线段距离平方"]
local stringToFourCC = ____16_FF0E_516C_5171_5DE5_5177.stringToFourCC
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.01．固定组合技能执行器")
local _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668["创建固定组合技能执行器"]
local ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.02．固定时间轴阶段工厂")
local _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868 = ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382["创建固定时间轴阶段列表"]
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_0["造成AOE技能伤害"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_1["创建点特效"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local GetRandomInt = jass.GetRandomInt
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_2["创建技能提示圈"]
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_3["获取Boss技能敌对英雄列表"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.18．周期范围效果.06．对外接口")
local _____65BD_52A0_5BC4_751F = ____require_result_4["施加寄生"]
local ____require_result_5 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_5.registerManualBuff
local ____require_result_6 = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.03．莫尔特斯")
local _____83AB_5C14_7279_65AFBuffID = ____require_result_6["莫尔特斯BuffID"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_7["读取单位攻击力"]
local _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____626D_66F2_8346_68D8_97AD_7B1E_6280_80FDID = stringToFourCC(_____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["扭曲荆棘鞭笞"]["技能槽位"])
local _____5DF2_6CE8_518C = false
local function _____6784_9020_97AD_7B1E_901A_9053_5217_8868(context)
    local grid = context["根须宫格"]
    local result = {}
    if grid == nil then
        return result
    end
    do
        local col = 0
        while col < 3 do
            local top = grid["获取格子"](grid, 2, col)
            local bottom = grid["获取格子"](grid, 0, col)
            if top ~= nil then
                result[#result + 1] = {X = top["中心X"], Y = top["上"], ["朝向"] = 270}
            end
            if bottom ~= nil then
                result[#result + 1] = {X = bottom["中心X"], Y = bottom["下"], ["朝向"] = 90}
            end
            col = col + 1
        end
    end
    do
        local row = 0
        while row < 3 do
            local left = grid["获取格子"](grid, row, 0)
            local right = grid["获取格子"](grid, row, 2)
            if left ~= nil then
                result[#result + 1] = {X = left["左"], Y = left["中心Y"], ["朝向"] = 0}
            end
            if right ~= nil then
                result[#result + 1] = {X = right["右"], Y = right["中心Y"], ["朝向"] = 180}
            end
            row = row + 1
        end
    end
    return result
end
local function _____9009_62E9_672C_6CE2_901A_9053(context)
    local pool = _____6784_9020_97AD_7B1E_901A_9053_5217_8868(context)
    local result = {}
    local count = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["扭曲荆棘鞭笞"]["藤蔓数量"]
    do
        local i = 0
        while i < count and #pool > 0 do
            local index = GetRandomInt(0, #pool - 1)
            result[#result + 1] = pool[index + 1]
            __TS__ArraySplice(pool, index, 1)
            i = i + 1
        end
    end
    return result
end
local function _____5355_901A_9053_97AD_7B1E_547D_4E2D(context, channel, _____547D_4E2D_6B21_6570_8868)
    local boss = context["Boss单位"]
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["扭曲荆棘鞭笞"]
    local endX = _____6781_5750_6807X(channel.X, channel["朝向"], cfg["矩形长度"])
    local endY = _____6781_5750_6807Y(channel.Y, channel["朝向"], cfg["矩形长度"])
    _____521B_5EFA_70B9_7279_6548({["模型路径"] = cfg["藤蔓模型路径"], X = channel.X, Y = channel.Y, ["持续秒"] = cfg["瞬时特效持续秒"]})
    do
        local i = 1
        while i <= 3 do
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = cfg["路径爆点特效路径"],
                X = _____6781_5750_6807X(channel.X, channel["朝向"], i * 512),
                Y = _____6781_5750_6807Y(channel.Y, channel["朝向"], i * 512),
                ["持续秒"] = cfg["瞬时特效持续秒"]
            })
            i = i + 1
        end
    end
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue19
                end
                local dist2 = _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9(
                    GetUnitX(hero),
                    GetUnitY(hero),
                    channel.X,
                    channel.Y,
                    endX,
                    endY
                )
                if dist2 > cfg["矩形宽度"] * cfg["矩形宽度"] / 4 then
                    goto __continue19
                end
                local hid = GetHandleId(hero) or 0
                local oldHits = _____547D_4E2D_6B21_6570_8868[hid] or 0
                _____547D_4E2D_6B21_6570_8868[hid] = oldHits + 1
                local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["Boss攻击力比例"] * (1 + oldHits * cfg["重复命中增伤比例"])
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["技能ID"] = _____626D_66F2_8346_68D8_97AD_7B1E_6280_80FDID,
                    ["来源"] = boss,
                    ["目标"] = hero,
                    ["伤害"] = damage,
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_PLANT,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "Boss技能"
                })
                _____5E94_7528_83AB_5C14_7279_65AF_8150_8D25_503C(context, hero, 8)
                _____65BD_52A0_5BC4_751F({
                    ["来源单位"] = boss,
                    ["目标单位"] = hero,
                    ["持续时间"] = cfg["寄生持续秒"],
                    ["伤害"] = cfg["寄生每跳伤害"],
                    ["伤害间隔"] = cfg["寄生伤害间隔秒"]
                })
                registerManualBuff(
                    hero,
                    _____83AB_5C14_7279_65AFBuffID["荆棘寄生"],
                    cfg["寄生持续秒"],
                    cfg["寄生每跳伤害"],
                    {sourceName = "莫尔特斯-荆棘寄生"}
                )
            end
            ::__continue19::
            i = i + 1
        end
    end
end
local function _____8FFD_52A0_97AD_7B1E_6CE2_6B21_65F6_95F4_8F74(_____4E8B_4EF6_5217_8868, context, _____547D_4E2D_6B21_6570_8868, _____6CE2_6B21_7D22_5F15)
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["扭曲荆棘鞭笞"]
    local _____6CE2_6B21_5E8F_53F7 = _____6CE2_6B21_7D22_5F15 + 1
    local _____9884_8B66_65F6_70B9_6BEB_79D2 = (cfg["开始延迟秒"] + _____6CE2_6B21_7D22_5F15 * cfg["波次间隔秒"]) * 1000
    local _____901A_9053_5217_8868 = {}
    _____4E8B_4EF6_5217_8868[#_____4E8B_4EF6_5217_8868 + 1] = {
        ["时点毫秒"] = _____9884_8B66_65F6_70B9_6BEB_79D2,
        ["名称"] = ("扭曲荆棘鞭笞第" .. tostring(_____6CE2_6B21_5E8F_53F7)) .. "波预警",
        ["执行"] = function()
            if not _____5355_4F4D_6709_6548(context["Boss单位"]) then
                return
            end
            local selected = _____9009_62E9_672C_6CE2_901A_9053(context)
            do
                local i = 0
                while i < #selected do
                    local channel = selected[i + 1]
                    _____901A_9053_5217_8868[#_____901A_9053_5217_8868 + 1] = channel
                    _____521B_5EFA_6280_80FD_63D0_793A_5708({
                        ["类型"] = "矩形",
                        X = channel.X,
                        Y = channel.Y,
                        ["宽度"] = cfg["矩形宽度"],
                        ["长度"] = cfg["矩形长度"],
                        ["朝向"] = channel["朝向"],
                        ["持续时间"] = cfg["预警秒"]
                    })
                    i = i + 1
                end
            end
        end
    }
    _____4E8B_4EF6_5217_8868[#_____4E8B_4EF6_5217_8868 + 1] = {
        ["时点毫秒"] = _____9884_8B66_65F6_70B9_6BEB_79D2 + cfg["预警秒"] * 1000,
        ["名称"] = ("扭曲荆棘鞭笞第" .. tostring(_____6CE2_6B21_5E8F_53F7)) .. "波结算",
        ["执行"] = function()
            local boss = context["Boss单位"]
            if not _____5355_4F4D_6709_6548(boss) or #_____901A_9053_5217_8868 <= 0 then
                return
            end
            _____64AD_653EBoss_5750_6807_97F3_6548(
                _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["扭曲荆棘鞭笞"]["扫击"],
                GetUnitX(boss),
                GetUnitY(boss),
                _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
            )
            do
                local i = 0
                while i < #_____901A_9053_5217_8868 do
                    _____5355_901A_9053_97AD_7B1E_547D_4E2D(context, _____901A_9053_5217_8868[i + 1], _____547D_4E2D_6B21_6570_8868)
                    i = i + 1
                end
            end
        end
    }
end
____exports["释放莫尔特斯扭曲荆棘鞭笞"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["扭曲荆棘鞭笞"]
    if cfg["扫击次数"] <= 0 then
        return
    end
    if context["扭曲荆棘鞭笞组合执行器"] == nil then
        context["扭曲荆棘鞭笞组合执行器"] = _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668({["名称"] = "莫尔特斯-扭曲荆棘鞭笞", ["清理"] = context["清理"], ["互斥组"] = "莫尔特斯扭曲荆棘鞭笞"})
    end
    local ____self_8 = context["扭曲荆棘鞭笞组合执行器"]
    if ____self_8["是否运行中"](____self_8) then
        return
    end
    local hitMap = {}
    local _____4E8B_4EF6_5217_8868 = {}
    do
        local wave = 0
        while wave < cfg["扫击次数"] do
            _____8FFD_52A0_97AD_7B1E_6CE2_6B21_65F6_95F4_8F74(_____4E8B_4EF6_5217_8868, context, hitMap, wave)
            wave = wave + 1
        end
    end
    local _____6700_540E_7ED3_7B97_79D2 = cfg["开始延迟秒"] + (cfg["扫击次数"] - 1) * cfg["波次间隔秒"] + cfg["预警秒"]
    local ____self_9 = context["扭曲荆棘鞭笞组合执行器"]
    local _____6267_884CID = ____self_9["开始"](
        ____self_9,
        {
            key = "扭曲荆棘鞭笞",
            ["单位"] = boss,
            ["上下文"] = context,
            ["最大持续毫秒"] = _____6700_540E_7ED3_7B97_79D2 * 1000 + 1000,
            ["阶段列表"] = _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868(_____4E8B_4EF6_5217_8868)
        }
    )
    if _____6267_884CID == 0 then
        return
    end
    _____5F00_59CB_83AB_5C14_7279_65AF_5E38_89C4_65BD_6CD5(boss, cfg["开始延迟秒"], "扭曲荆棘鞭笞", "荆棘将从场地边缘连续扫过")
    _____64AD_653E_83AB_5C14_7279_65AF_9650_65F6_52A8_4F5C(boss, cfg["动画编号"], cfg["动画速度"], cfg["动作播放秒"])
    _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD(boss, "扭曲荆棘鞭笞")
end
local function ____on_83AB_5C14_7279_65AF_626D_66F2_8346_68D8_97AD_7B1E_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____626D_66F2_8346_68D8_97AD_7B1E_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放莫尔特斯扭曲荆棘鞭笞"](context)
end
____exports["注册莫尔特斯扭曲荆棘鞭笞"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "06．扭曲荆棘鞭笞",
        ["单位类型ID"] = _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____626D_66F2_8346_68D8_97AD_7B1E_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_83AB_5C14_7279_65AF_626D_66F2_8346_68D8_97AD_7B1E_65BD_6CD5(boss, _____626D_66F2_8346_68D8_97AD_7B1E_6280_80FDID)
        end
    })
end
return ____exports
