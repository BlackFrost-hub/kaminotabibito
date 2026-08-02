--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____505C_6B62_5973_5996_54ED_568E_8DEF_5F84_7279_6548
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_6A21_578B_52A8_753B_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹模型动画配置"]
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.01．固定组合技能执行器")
local _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668["创建固定组合技能执行器"]
local ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.01．多阶段技能编排.06．技能阶段链执行器")
local _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5 = ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668["创建立即执行阶段"]
local _____521B_5EFA_5EF6_8FDF_9636_6BB5 = ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668["创建延迟阶段"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____01_FF0E_53EF_653B_51FB_673A_5236_5355_4F4D["创建可攻击机制单位"]
local ____06_FF0E_5355_4F4D_505C_7559_89E6_53D1_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.06．单位停留触发器")
local _____521B_5EFA_5355_4F4D_505C_7559_89E6_53D1_5668 = ____06_FF0E_5355_4F4D_505C_7559_89E6_53D1_5668["创建单位停留触发器"]
local ____03_FF0E_7279_6548 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_5FAA_73AF_70B9_7279_6548 = ____03_FF0E_7279_6548["创建循环点特效"]
local _____505C_6B62_5FAA_73AF_70B9_7279_6548 = ____03_FF0E_7279_6548["停止循环点特效"]
local _____521B_5EFA_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548 = ____03_FF0E_7279_6548["创建逐段直线路径点特效"]
local ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI = require("系统.09．表现系统.15．世界坐标进度UI.index")
local _____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI = ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI["创建世界坐标进度UI"]
local _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI = ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI["更新世界坐标进度UI"]
local _____8BBE_7F6E_4E16_754C_5750_6807_8FDB_5EA6UI_663E_793A = ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI["设置世界坐标进度UI显示"]
local _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI = ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI["销毁世界坐标进度UI"]
local ____01_FF0E_5B89_5179_4E4C_5C14_606D = require("系统.05．Buff系统.03．Buff表.01．Boss.03．异界Boss.01．安兹乌尔恭")
local _____5B89_5179_4E4C_5C14_606DBuffID = ____01_FF0E_5B89_5179_4E4C_5C14_606D["安兹乌尔恭BuffID"]
local ____06_FF0E_751F_547D_951A_70B9_5C01_9501 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.06．生命锚点封锁")
local _____542F_52A8_96C5_513F_8D1D_5FB7_751F_547D_951A_70B9_5C01_9501 = ____06_FF0E_751F_547D_951A_70B9_5C01_9501["启动雅儿贝德生命锚点封锁"]
local ____12_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.12．台词播放")
local _____64AD_653E_5B89_5179_53F0_8BCD = ____12_FF0E_53F0_8BCD_64AD_653E["播放安兹台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
function _____505C_6B62_5973_5996_54ED_568E_8DEF_5F84_7279_6548(instance)
    do
        local i = 0
        while i < #instance["女妖哭嚎路径特效列表"] do
            local ____self_13 = instance["女妖哭嚎路径特效列表"][i + 1]
            ____self_13["停止"](____self_13)
            i = i + 1
        end
    end
    instance["女妖哭嚎路径特效列表"] = {}
end
local ____require_result_0 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_0["获取Boss技能敌对英雄列表"]
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local ____require_result_2 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_2["广播单位提示"]
local ____require_result_3 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5927_62DB_541F_5531_6761 = ____require_result_3["显示大招吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_3["关闭吟唱条"]
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_4.YDWETimerDestroyEffectSafe
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_5.getServerTime
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local IsUnitType = jass.IsUnitType
local Player = jass.Player
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local PauseUnit = jass.PauseUnit
local SetUnitPathing = jass.SetUnitPathing
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local Cos = jass.Cos
local Sin = jass.Sin
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_UNIVERSAL = jass.DAMAGE_TYPE_UNIVERSAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local EXSetEffectSize = japi.EXSetEffectSize
local EXSetEffectXY = japi.EXSetEffectXY
local EXEffectMatRotateZ = japi.EXEffectMatRotateZ
local DEG_TO_RAD = 0.017453292519943295
local _____4E00_5207_751F_547D_7684_7EC8_70B9_5927_578B_6280_80FDKey = "一切生命的终点"
local function _____9500_6BC1_7279_6548(effect)
    if effect ~= nil and effect ~= 0 then
        DestroyEffect(effect)
    end
end
local function _____6E05_7406_751F_547D_951A_70B9(anchor)
    if anchor["停留控制器"] ~= nil then
        local ____self_6 = anchor["停留控制器"]
        ____self_6["停止"](____self_6)
        anchor["停留控制器"] = nil
    end
    _____505C_6B62_5FAA_73AF_70B9_7279_6548(anchor["地面环循环特效"])
    _____9500_6BC1_7279_6548(anchor["圣光特效"])
    _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI(anchor["激活进度UI"])
    anchor["圣光特效"] = 0
    anchor["激活进度UI"] = nil
    local ____self_7 = anchor["单位实例"]
    ____self_7["销毁"](____self_7)
end
local function _____6E05_7406_4E00_5207_751F_547D_7684_7EC8_70B9_5B9E_4F8B(instance)
    if instance["已清理"] then
        return
    end
    instance["已清理"] = true
    _____5173_95ED_541F_5531_6761("大招")
    _____9500_6BC1_7279_6548(instance["倒计时特效"])
    instance["倒计时特效"] = 0
    _____505C_6B62_5973_5996_54ED_568E_8DEF_5F84_7279_6548(instance)
    local ____opt_8 = instance["锚点封锁"]
    if ____opt_8 ~= nil then
        ____opt_8["结束"]("一切生命的终点清理")
    end
    instance["锚点封锁"] = nil
    do
        local i = 0
        while i < #instance["锚点列表"] do
            _____6E05_7406_751F_547D_951A_70B9(instance["锚点列表"][i + 1])
            i = i + 1
        end
    end
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(instance.context["安兹单位"])
    do
        local i = 0
        while i < #heroes do
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(heroes[i + 1], _____5B89_5179_4E4C_5C14_606DBuffID["生命庇护"])
            i = i + 1
        end
    end
    if instance.context["当前大型技能"] == _____4E00_5207_751F_547D_7684_7EC8_70B9_5927_578B_6280_80FDKey then
        instance.context["当前大型技能"] = nil
        instance.context["上次大型技能结束Ms"] = getServerTime()
    end
end
local function _____53D6_5DF2_6FC0_6D3B_951A_70B9_6570_91CF(instance)
    local count = 0
    do
        local i = 0
        while i < #instance["锚点列表"] do
            if instance["锚点列表"][i + 1]["已激活"] then
                count = count + 1
            end
            i = i + 1
        end
    end
    return count
end
local function _____6388_4E88_5168_961F_751F_547D_5E87_62A4(instance)
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段技能"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(instance.context["安兹单位"])
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue19
                end
                instance["庇护单位表"][GetHandleId(hero)] = true
                registerManualBuff(
                    hero,
                    _____5B89_5179_4E4C_5C14_606DBuffID["生命庇护"],
                    cfg["一切生命的终点倒计时秒"] + 2,
                    1,
                    {sourceName = "安兹-一切生命的终点"}
                )
            end
            ::__continue19::
            i = i + 1
        end
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(
        instance.context["安兹单位"],
        ((((("|cffffff99" .. tostring(cfg["生命锚点数量"])) .. "座生命锚点已全部激活：获得持续") .. tostring(cfg["一切生命的终点倒计时秒"] + 2)) .. "秒的生命庇护，可抵挡本轮女妖哭嚎1次。（女妖哭嚎后有") .. tostring(cfg["一切生命的终点破解输出窗口秒"])) .. "秒输出窗口，立即集中攻击安兹。）|r",
        3600
    )
end
local function _____6FC0_6D3B_751F_547D_951A_70B9(instance, anchor)
    if instance["已清理"] or anchor["已激活"] or anchor["已封锁"] then
        return
    end
    anchor["已激活"] = true
    if anchor["停留控制器"] ~= nil then
        local ____self_10 = anchor["停留控制器"]
        ____self_10["停止"](____self_10)
        anchor["停留控制器"] = nil
    end
    _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI(anchor["激活进度UI"])
    anchor["激活进度UI"] = nil
    local count = _____53D6_5DF2_6FC0_6D3B_951A_70B9_6570_91CF(instance)
    local required = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段技能"]["生命锚点数量"]
    local stage = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段技能"]
    _____5E7F_64AD_5355_4F4D_63D0_793A(
        instance.context["安兹单位"],
        ((((((("|cffffff99生命锚点已激活（" .. tostring(count)) .. "/") .. tostring(required)) .. "）；本锚点要求在") .. tostring(stage["生命锚点激活半径"])) .. "码内停留") .. tostring(stage["生命锚点激活停留秒"])) .. "秒。（继续前往下一个未激活锚点。）|r",
        2200
    )
    if #instance["锚点列表"] == required and count >= required then
        _____6388_4E88_5168_961F_751F_547D_5E87_62A4(instance)
    end
end
local function _____521B_5EFA_751F_547D_951A_70B9(instance, x, y, index)
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local stage = cfg["阶段技能"]
    local unitInstance = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["名称"] = "安兹-生命锚点-" .. tostring(index + 1),
        ["主人单位"] = instance.context["安兹单位"],
        ["所属玩家"] = Player(15),
        ["单位类型"] = stage["生命锚点单位ID"],
        ["模型路径"] = cfg["表现资源"]["生命锚点特效路径"],
        X = x,
        Y = y,
        ["最大生命"] = 1,
        ["生命值受小怪倍率"] = false,
        ["缩放"] = stage["生命锚点缩放"]
    })
    if unitInstance == nil then
        return
    end
    SetUnitInvulnerable(unitInstance["单位"], true)
    PauseUnit(unitInstance["单位"], true)
    SetUnitPathing(unitInstance["单位"], false)
    local function _____751F_547D_951A_70B9_5730_9762_73AF_5B58_6D3B()
        return not instance["已清理"] and not instance.context["挑战已结束"]
    end
    local ground = _____521B_5EFA_5FAA_73AF_70B9_7279_6548({
        ["模型路径"] = cfg["表现资源"]["生命锚点地面层特效路径"],
        X = x,
        Y = y,
        ["缩放"] = stage["生命锚点地面层缩放"],
        ["重建间隔秒"] = stage["生命锚点地面层播放间隔秒"],
        ["总持续秒"] = stage["生命锚点地面层播放次数"] * stage["生命锚点地面层播放间隔秒"],
        ["存活条件"] = _____751F_547D_951A_70B9_5730_9762_73AF_5B58_6D3B
    })
    local holy = AddSpecialEffect(cfg["表现资源"]["生命锚点圣光层特效路径"], x, y)
    if holy ~= nil and holy ~= 0 then
        EXSetEffectSize(holy, stage["生命锚点圣光层缩放"])
    end
    local anchor = {
        ["单位实例"] = unitInstance,
        ["地面环循环特效"] = ground,
        ["圣光特效"] = holy,
        ["激活进度UI"] = _____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI({
            X = x,
            Y = y,
            Z = 220,
            ["最大值"] = stage["生命锚点激活停留秒"],
            ["当前值"] = 0,
            ["标题"] = "激活锚点",
            ["数值后缀"] = "秒",
            ["类型"] = "自然",
            ["平滑过渡秒"] = 0.1,
            ["初始显示"] = false,
            ["雾中可见"] = false
        }),
        ["已激活"] = false,
        ["已封锁"] = false
    }
    local ____instance__951A_70B9_5217_8868_11 = instance["锚点列表"]
    ____instance__951A_70B9_5217_8868_11[#____instance__951A_70B9_5217_8868_11 + 1] = anchor
    anchor["停留控制器"] = _____521B_5EFA_5355_4F4D_505C_7559_89E6_53D1_5668({
        ["名称"] = "安兹-生命锚点停留-" .. tostring(index + 1),
        ["中心单位"] = unitInstance["单位"],
        ["半径"] = stage["生命锚点激活半径"],
        ["需求持续毫秒"] = stage["生命锚点激活停留秒"] * 1000,
        ["检查间隔毫秒"] = 100,
        ["离开后重置"] = true,
        ["只触发一次"] = true,
        ["读取单位列表"] = function()
            return _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(instance.context["安兹单位"])
        end,
        ["过滤单位"] = function()
            return not anchor["已封锁"]
        end,
        ["on触发"] = function()
            _____6FC0_6D3B_751F_547D_951A_70B9(instance, anchor)
        end,
        ["on刷新完成"] = function(_____8303_56F4_5185_72B6_6001_5217_8868)
            local _____6700_5927_505C_7559_6BEB_79D2 = 0
            do
                local i = 0
                while i < #_____8303_56F4_5185_72B6_6001_5217_8868 do
                    local _____72B6_6001 = _____8303_56F4_5185_72B6_6001_5217_8868[i + 1]
                    if _____72B6_6001["已持续毫秒"] > _____6700_5927_505C_7559_6BEB_79D2 then
                        _____6700_5927_505C_7559_6BEB_79D2 = _____72B6_6001["已持续毫秒"]
                    end
                    i = i + 1
                end
            end
            _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI(anchor["激活进度UI"], _____6700_5927_505C_7559_6BEB_79D2 / 1000)
            _____8BBE_7F6E_4E16_754C_5750_6807_8FDB_5EA6UI_663E_793A(anchor["激活进度UI"], #_____8303_56F4_5185_72B6_6001_5217_8868 > 0 and not anchor["已封锁"] and not anchor["已激活"])
        end
    })
end
local function _____521B_5EFA_751F_547D_951A_70B9_5C01_9501_76EE_6807(anchor)
    return {
        ["单位"] = anchor["单位实例"]["单位"],
        ["是否已激活"] = function()
            return anchor["已激活"]
        end,
        ["设置封锁"] = function(blocked)
            anchor["已封锁"] = blocked
        end
    }
end
local function _____521B_5EFA_4E00_5207_751F_547D_7684_7EC8_70B9_9884_8B66(instance)
    local context = instance.context
    local boss = context["安兹单位"]
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local stage = cfg["阶段技能"]
    local originX = GetUnitX(boss)
    local originY = GetUnitY(boss)
    instance["倒计时特效"] = AddSpecialEffectTarget(cfg["表现资源"]["一切生命的终点倒计时特效路径"], boss, "origin")
    do
        local i = 0
        while i < stage["生命锚点数量"] do
            local angle = (90 + i * 360 / stage["生命锚点数量"]) * DEG_TO_RAD
            _____521B_5EFA_751F_547D_951A_70B9(
                instance,
                originX + Cos(angle) * stage["生命锚点距离"],
                originY + Sin(angle) * stage["生命锚点距离"],
                i
            )
            i = i + 1
        end
    end
    local blockTargets = {}
    do
        local i = 0
        while i < #instance["锚点列表"] do
            blockTargets[#blockTargets + 1] = _____521B_5EFA_751F_547D_951A_70B9_5C01_9501_76EE_6807(instance["锚点列表"][i + 1])
            i = i + 1
        end
    end
    instance["锚点封锁"] = _____542F_52A8_96C5_513F_8D1D_5FB7_751F_547D_951A_70B9_5C01_9501(context, blockTargets, stage["一切生命的终点倒计时秒"])
    _____5E7F_64AD_5355_4F4D_63D0_793A(
        boss,
        ((((((("|cffff6666一切生命的终点开始" .. tostring(stage["一切生命的终点倒计时秒"])) .. "秒倒计时：需激活") .. tostring(stage["生命锚点数量"])) .. "座生命锚点，每座在") .. tostring(stage["生命锚点激活半径"])) .. "码内停留") .. tostring(stage["生命锚点激活停留秒"])) .. "秒。（分工踩点，优先处理被暗金屏障封锁的锚点。）|r",
        4200
    )
end
local function _____64AD_653E_5973_5996_54ED_568E_8868_73B0(instance)
    local boss = instance.context["安兹单位"]
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local stage = cfg["阶段技能"]
    local x = GetUnitX(boss)
    local y = GetUnitY(boss)
    _____505C_6B62_5973_5996_54ED_568E_8DEF_5F84_7279_6548(instance)
    do
        local i = 0
        while i < stage["女妖哭嚎死亡波数量"] do
            local effect = AddSpecialEffect(cfg["表现资源"]["女妖哭嚎死亡波特效路径"], x, y)
            if effect ~= nil and effect ~= 0 then
                EXSetEffectXY(effect, x, y)
                EXEffectMatRotateZ(effect, i * 360 / stage["女妖哭嚎死亡波数量"])
                EXSetEffectSize(effect, stage["女妖哭嚎死亡波缩放"])
                YDWETimerDestroyEffectSafe(stage["女妖哭嚎特效持续秒"], effect)
            end
            local ____instance__5973_5996_54ED_568E_8DEF_5F84_7279_6548_5217_8868_12 = instance["女妖哭嚎路径特效列表"]
            ____instance__5973_5996_54ED_568E_8DEF_5F84_7279_6548_5217_8868_12[#____instance__5973_5996_54ED_568E_8DEF_5F84_7279_6548_5217_8868_12 + 1] = _____521B_5EFA_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548({
                ["模型路径"] = cfg["表现资源"]["女妖哭嚎路径叠加特效路径"],
                ["起点X"] = x,
                ["起点Y"] = y,
                ["方向弧度"] = i * 360 / stage["女妖哭嚎死亡波数量"] * DEG_TO_RAD,
                ["路径长度"] = stage["女妖哭嚎路径长度"],
                ["段间距"] = stage["女妖哭嚎路径段间距"],
                ["铺设间隔秒"] = stage["女妖哭嚎路径铺设间隔秒"],
                ["缩放"] = stage["女妖哭嚎路径叠加特效缩放"],
                ["持续秒"] = stage["女妖哭嚎路径叠加特效持续秒"]
            })
            i = i + 1
        end
    end
end
local function _____7ED3_7B97_5973_5996_54ED_568E(instance)
    if instance["已清理"] or instance.context["挑战已结束"] then
        return false
    end
    _____64AD_653E_5973_5996_54ED_568E_8868_73B0(instance)
    local boss = instance.context["安兹单位"]
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["一切生命终点"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
    )
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段技能"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local solved = #instance["锚点列表"] == cfg["生命锚点数量"] and _____53D6_5DF2_6FC0_6D3B_951A_70B9_6570_91CF(instance) >= cfg["生命锚点数量"]
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) or instance["庇护单位表"][GetHandleId(hero)] == true then
                    goto __continue54
                end
                _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = hero,
                    ["伤害公式"] = {["目标最大生命比例"] = cfg["女妖哭嚎致命伤害最大生命比例"]},
                    attack = false,
                    ranged = true,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_UNIVERSAL,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["标签"] = "安兹·女妖哭嚎"
                })
            end
            ::__continue54::
            i = i + 1
        end
    end
    if solved then
        _____5E7F_64AD_5355_4F4D_63D0_793A(
            boss,
            ((("|cffffff99" .. tostring(cfg["生命锚点数量"])) .. "座生命锚点已全部激活，生命庇护抵挡本次女妖哭嚎；随后开放") .. tostring(cfg["一切生命的终点破解输出窗口秒"])) .. "秒输出窗口。（立即集中攻击安兹。）|r",
            3600
        )
    else
        _____5E7F_64AD_5355_4F4D_63D0_793A(
            boss,
            ("|cffff4444生命锚点未能在" .. tostring(cfg["一切生命的终点倒计时秒"])) .. "秒内全部激活，女妖哭嚎已完成致命裁定。（下一轮分工提前踩点，优先处理封锁屏障。）|r",
            3200
        )
    end
    return solved
end
____exports["释放安兹一切生命的终点"] = function(context)
    local boss = context["安兹单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["一切生命的终点已释放"] or context["当前大型技能"] ~= nil then
        return false
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段技能"]
    local executor = _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668({["名称"] = "安兹·一切生命的终点固定序列", ["清理"] = context["清理"], ["互斥组"] = "安兹大型技能"})
    local instance = {
        context = context,
        ["锚点列表"] = {},
        ["庇护单位表"] = {},
        ["倒计时特效"] = 0,
        ["女妖哭嚎路径特效列表"] = {},
        ["已清理"] = false
    }
    context["一切生命的终点已释放"] = true
    context["当前大型技能"] = _____4E00_5207_751F_547D_7684_7EC8_70B9_5927_578B_6280_80FDKey
    _____64AD_653E_5B89_5179_53F0_8BCD(boss, "一切生命的终点")
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["死亡倒计时"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
    )
    local ____self_14 = context["清理"]
    ____self_14["登记清理"](
        ____self_14,
        "安兹-一切生命的终点实例",
        function()
            _____6E05_7406_4E00_5207_751F_547D_7684_7EC8_70B9_5B9E_4F8B(instance)
        end
    )
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({
        ["单位"] = boss,
        ["动画编号"] = cfg["一切生命的终点动画编号"],
        ["动画速度"] = cfg["一切生命的终点动画速度"],
        ["持续秒"] = cfg["一切生命的终点倒计时秒"],
        ["恢复动画编号"] = _____5B89_5179_6A21_578B_52A8_753B_914D_7F6E["待机编号"]
    })
    _____663E_793A_5927_62DB_541F_5531_6761({
        ["通道"] = "大招",
        ["总时长"] = cfg["一切生命的终点倒计时秒"],
        ["颜色ID"] = 2,
        ["标题文本"] = "一切生命的终点",
        ["提示文本"] = "12秒内激活3座生命锚；每座需在230码内停留0.8秒"
    })
    local solved = false
    local executionId = executor["开始"](
        executor,
        {
            key = _____4E00_5207_751F_547D_7684_7EC8_70B9_5927_578B_6280_80FDKey,
            ["单位"] = boss,
            ["上下文"] = context,
            ["最大持续毫秒"] = (cfg["一切生命的终点倒计时秒"] + cfg["一切生命的终点破解输出窗口秒"] + 2) * 1000,
            ["阶段列表"] = {
                _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5(
                    function()
                        _____521B_5EFA_4E00_5207_751F_547D_7684_7EC8_70B9_9884_8B66(instance)
                    end,
                    "死亡倒计时与生命锚点"
                ),
                _____521B_5EFA_5EF6_8FDF_9636_6BB5(cfg["一切生命的终点倒计时秒"] * 1000, "十二秒死亡倒计时"),
                _____521B_5EFA_7ACB_5373_6267_884C_9636_6BB5(
                    function()
                        solved = _____7ED3_7B97_5973_5996_54ED_568E(instance)
                    end,
                    "女妖哭嚎"
                ),
                _____521B_5EFA_5EF6_8FDF_9636_6BB5(cfg["一切生命的终点破解输出窗口秒"] * 1000, "死亡法则破解输出窗口")
            },
            ["结束回调"] = function()
                if not solved then
                    context["上次大型技能结束Ms"] = getServerTime()
                end
                _____6E05_7406_4E00_5207_751F_547D_7684_7EC8_70B9_5B9E_4F8B(instance)
            end
        }
    )
    if executionId == 0 then
        _____6E05_7406_4E00_5207_751F_547D_7684_7EC8_70B9_5B9E_4F8B(instance)
        return false
    end
    return true
end
____exports["一切生命的终点技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["类型"] = "死亡法则阶段技",
    ["语义"] = "十二秒倒计时内激活生命锚点，借亚伦柯斯英魂庇护承受最终女妖哭嚎。",
    ["实现要求"] = "缺少生命庇护才进入致命结算；成功破解后给予主要输出窗口。"
}
return ____exports
