local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_6A21_578B_52A8_753B_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹模型动画配置"]
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local ____04_FF0E_5BF9_5916_63A5_53E3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
local _____521B_5EFA_53EC_5524_7269 = ____04_FF0E_5BF9_5916_63A5_53E3["创建召唤物"]
local ____12_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.12．台词播放")
local _____64AD_653E_5B89_5179_53F0_8BCD = ____12_FF0E_53F0_8BCD_64AD_653E["播放安兹台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_0["读取单位攻击力"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_1["启动基础施法时间线"]
local ____require_result_2 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_2["获取Boss技能随机敌对英雄"]
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_3.registerDeathListener
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_4.addDelayedCallback
local getServerTime = ____require_result_4.getServerTime
local ____require_result_5 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_5["广播单位提示"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_6["创建点特效"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local AddSpecialEffect = jass.AddSpecialEffect
local RemoveUnit = jass.RemoveUnit
local IssueTargetOrder = jass.IssueTargetOrder
local Cos = jass.Cos
local Sin = jass.Sin
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local EXSetEffectSize = japi.EXSetEffectSize
local DEG_TO_RAD = 0.017453292519943295
local _____9AD8_9636_4EA1_7075_53EC_5524_5927_578B_6280_80FDKey = "高阶亡灵召唤"
local _____9AD8_9636_4EA1_7075_5B9E_4F8B_8868 = {}
local _____9AD8_9636_4EA1_7075_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____6E05_7406_9AD8_9636_4EA1_7075_5B9E_4F8B(instance)
    if instance["已移除"] then
        return
    end
    instance["已移除"] = true
    __TS__Delete(_____9AD8_9636_4EA1_7075_5B9E_4F8B_8868, instance.handleId)
    if instance.context["高阶亡灵召唤物"] == instance.unit then
        instance.context["高阶亡灵召唤物"] = nil
    end
    if instance.unit ~= nil and instance.unit ~= 0 then
        RemoveUnit(instance.unit)
    end
    instance.unit = 0
end
local function ____on_9AD8_9636_4EA1_7075_6B7B_4EA1(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    local instance = _____9AD8_9636_4EA1_7075_5B9E_4F8B_8868[GetHandleId(dyingUnit)]
    if instance == nil or instance["已移除"] then
        return
    end
    __TS__Delete(_____9AD8_9636_4EA1_7075_5B9E_4F8B_8868, instance.handleId)
    local context = instance.context
    if context["高阶亡灵召唤物"] == dyingUnit then
        context["高阶亡灵召唤物"] = nil
    end
    local ____temp_8 = not context["挑战已结束"]
    if ____temp_8 then
        local ____self_7 = context["清理"]
        ____temp_8 = not ____self_7["已清理"](____self_7)
    end
    if ____temp_8 then
        context["亡灵箭削弱到Ms"] = getServerTime() + _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段技能"]["高阶亡灵击败削弱秒"] * 1000
        _____5E7F_64AD_5355_4F4D_63D0_793A(context["安兹单位"], "|cff80d8ff[机制]|r 高阶亡灵已消灭：亡灵箭伤害降低25%，持续12秒。", 3500)
    end
    local removeId = addDelayedCallback(
        3000,
        function()
            _____6E05_7406_9AD8_9636_4EA1_7075_5B9E_4F8B(instance)
        end
    )
    local ____self_9 = context["清理"]
    ____self_9["登记延迟回调"](____self_9, "安兹-高阶亡灵尸体移除", removeId)
end
local function _____786E_4FDD_9AD8_9636_4EA1_7075_6B7B_4EA1_76D1_542C()
    if _____9AD8_9636_4EA1_7075_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____9AD8_9636_4EA1_7075_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
    registerDeathListener(____on_9AD8_9636_4EA1_7075_6B7B_4EA1)
end
local function _____64AD_653E_53EC_5524_7279_6548(model, x, y, scale)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = model,
        X = x,
        Y = y,
        ["缩放"] = scale,
        ["持续秒"] = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段技能"]["高阶亡灵召唤表现持续秒"]
    })
end
local function _____521B_5EFA_9AD8_9636_4EA1_7075(context, x, y, target)
    local boss = context["安兹单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] then
        return
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段技能"]
    local summon = _____521B_5EFA_53EC_5524_7269({
        ["主人单位"] = boss,
        ["单位类型"] = cfg["高阶亡灵召唤单位ID"],
        ["单位名称"] = cfg["高阶亡灵召唤单位名称"],
        ["模型文件"] = cfg["高阶亡灵召唤模型路径"],
        X = x,
        Y = y,
        ["朝向"] = GetUnitFacing(boss),
        ["生命值"] = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * cfg["高阶亡灵召唤生命Boss最大生命比例"],
        ["生命值受小怪倍率"] = false,
        ["攻击力"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["高阶亡灵召唤攻击Boss攻击力比例"],
        ["攻击间隔"] = cfg["高阶亡灵召唤攻击间隔"],
        ["攻击范围"] = cfg["高阶亡灵召唤攻击范围"],
        ["索敌范围"] = cfg["高阶亡灵召唤索敌范围"],
        ["护甲"] = cfg["高阶亡灵召唤护甲"],
        ["缩放"] = cfg["高阶亡灵召唤缩放"],
        ["透明度"] = cfg["高阶亡灵召唤透明度"],
        ["红"] = 150,
        ["绿"] = 205,
        ["蓝"] = 255
    })
    if not _____5355_4F4D_6709_6548(summon) then
        return
    end
    local instance = {
        context = context,
        unit = summon,
        handleId = GetHandleId(summon),
        ["已移除"] = false
    }
    context["高阶亡灵召唤物"] = summon
    _____9AD8_9636_4EA1_7075_5B9E_4F8B_8868[instance.handleId] = instance
    local ____self_10 = context["清理"]
    ____self_10["登记清理"](
        ____self_10,
        "安兹-高阶亡灵召唤物",
        function()
            _____6E05_7406_9AD8_9636_4EA1_7075_5B9E_4F8B(instance)
        end
    )
    if _____5355_4F4D_6709_6548(target) then
        IssueTargetOrder(summon, "attack", target)
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(boss, "|cffff6060[机制]|r 死亡骑士存活期间，安兹的亡灵箭伤害提高35%。", 3500)
end
____exports["取安兹亡灵箭伤害倍率"] = function(context)
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段技能"]
    if _____5355_4F4D_6709_6548(context["高阶亡灵召唤物"]) then
        return cfg["高阶亡灵召唤亡灵箭强化倍率"]
    end
    if getServerTime() < context["亡灵箭削弱到Ms"] then
        return cfg["高阶亡灵击败后亡灵箭倍率"]
    end
    return 1
end
____exports["释放安兹高阶亡灵召唤"] = function(context)
    local boss = context["安兹单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["当前大型技能"] ~= nil then
        return false
    end
    if _____5355_4F4D_6709_6548(context["高阶亡灵召唤物"]) then
        return false
    end
    context["高阶亡灵召唤物"] = nil
    local target = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss)
    if not _____5355_4F4D_6709_6548(target) then
        return false
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local stage = cfg["阶段技能"]
    local angle = GetUnitFacing(boss) * DEG_TO_RAD
    local summonX = GetUnitX(boss) + Cos(angle) * stage["高阶亡灵召唤距离"]
    local summonY = GetUnitY(boss) + Sin(angle) * stage["高阶亡灵召唤距离"]
    context["当前大型技能"] = _____9AD8_9636_4EA1_7075_53EC_5524_5927_578B_6280_80FDKey
    _____64AD_653E_5B89_5179_53F0_8BCD(boss, "高阶亡灵召唤")
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["高阶亡灵召唤"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
    )
    _____786E_4FDD_9AD8_9636_4EA1_7075_6B7B_4EA1_76D1_542C()
    _____64AD_653E_53EC_5524_7279_6548(cfg["表现资源"]["高阶亡灵召唤门特效路径"], summonX, summonY, stage["高阶亡灵召唤门缩放"])
    _____64AD_653E_53EC_5524_7279_6548(cfg["表现资源"]["高阶亡灵召唤外圈特效路径"], summonX, summonY, stage["高阶亡灵召唤外圈缩放"])
    _____64AD_653E_53EC_5524_7279_6548(cfg["表现资源"]["高阶亡灵召唤内圈特效路径"], summonX, summonY, stage["高阶亡灵召唤内圈缩放"])
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["目标X"] = summonX,
        ["目标Y"] = summonY,
        ["硬直秒"] = stage["高阶亡灵召唤施法秒"],
        ["动画编号"] = stage["高阶亡灵召唤动画编号"],
        ["动画速度"] = stage["高阶亡灵召唤动画速度"],
        ["恢复动画编号"] = _____5B89_5179_6A21_578B_52A8_753B_914D_7F6E["待机编号"],
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = stage["高阶亡灵召唤施法秒"],
            ["颜色ID"] = 4,
            ["标题文本"] = "高阶亡灵召唤",
            ["提示文本"] = "击败死亡骑士可暂时削弱亡灵箭法术"
        },
        ["on生效"] = function()
            _____521B_5EFA_9AD8_9636_4EA1_7075(context, summonX, summonY, target)
            local finishId = addDelayedCallback(
                stage["高阶亡灵召唤收尾秒"] * 1000,
                function()
                    if context["当前大型技能"] == _____9AD8_9636_4EA1_7075_53EC_5524_5927_578B_6280_80FDKey then
                        context["当前大型技能"] = nil
                        context["上次大型技能结束Ms"] = getServerTime()
                    end
                end
            )
            local ____self_11 = context["清理"]
            ____self_11["登记延迟回调"](____self_11, "安兹-高阶亡灵召唤收尾", finishId)
        end
    })
    return true
end
____exports["高阶亡灵召唤技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["类型"] = "高威胁单体召唤",
    ["语义"] = "每次只召唤一个高威胁亡灵，只强化安兹的一类法术，击败后给予明确团队收益。"
}
return ____exports
