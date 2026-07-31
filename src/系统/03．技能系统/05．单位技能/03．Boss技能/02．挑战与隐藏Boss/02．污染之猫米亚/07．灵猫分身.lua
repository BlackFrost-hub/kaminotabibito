--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.00．配置")
local _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["米亚单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚技能数值配置"]
local _____7C73_4E9A_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚音效配置"]
local _____7C73_4E9A_8FD0_884C_65F6_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚运行时配置"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.15．台词播放")
local _____64AD_653E_7C73_4E9A_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放米亚台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["延迟播放Boss坐标音效"]
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI = require("系统.09．表现系统.15．世界坐标进度UI.index")
local _____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI = ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI["创建世界坐标进度UI"]
local _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI = ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI["更新世界坐标进度UI"]
local _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI = ____15_FF0E_4E16_754C_5750_6807_8FDB_5EA6UI["销毁世界坐标进度UI"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
local _____521B_5EFA_53EC_5524_7269 = ____require_result_0["创建召唤物"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_2.registerDeathListener
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_3["创建点特效"]
local _____521B_5EFA_5355_4F4D_811A_4E0B_70B9_7279_6548 = ____require_result_3["创建单位脚下点特效"]
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local X_FixUnitStandingSafe = ____require_result_4.X_FixUnitStandingSafe
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_5["读取单位攻击力"]
local ____require_result_6 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_6.doHeal
local ____require_result_7 = require("lib.扩展函数.BJ函数.12．数学函数")
local CosBJ = ____require_result_7.CosBJ
local SinBJ = ____require_result_7.SinBJ
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
local RemoveUnit = jass.RemoveUnit
local IsUnitType = jass.IsUnitType
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____7C73_4E9A_7075_732B_5206_8EAB_5012_8BA1_65F6_8868 = {}
local _____7C73_4E9A_7075_732B_5206_8EAB_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____6E05_7406_7C73_4E9A_7075_732B_5206_8EAB_5012_8BA1_65F6(data)
    if data == nil then
        return
    end
    if data["周期ID"] ~= 0 then
        removePeriodicCallback(data["周期ID"])
        data["周期ID"] = 0
    end
    _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI(data.UI)
    data.UI = nil
    if data["单位"] ~= nil and data["单位"] ~= 0 then
        local unitId = GetHandleId(data["单位"])
        if _____7C73_4E9A_7075_732B_5206_8EAB_5012_8BA1_65F6_8868[unitId] == data then
            _____7C73_4E9A_7075_732B_5206_8EAB_5012_8BA1_65F6_8868[unitId] = nil
        end
    end
end
local function _____6E05_7406_7C73_4E9A_7075_732B_5206_8EAB_5355_4F4D_5012_8BA1_65F6(unit)
    if unit == nil or unit == 0 then
        return
    end
    _____6E05_7406_7C73_4E9A_7075_732B_5206_8EAB_5012_8BA1_65F6(_____7C73_4E9A_7075_732B_5206_8EAB_5012_8BA1_65F6_8868[GetHandleId(unit)])
end
local function ____on_7C73_4E9A_7075_732B_5206_8EAB_6B7B_4EA1(dyingUnit, _killingUnit)
    _____6E05_7406_7C73_4E9A_7075_732B_5206_8EAB_5355_4F4D_5012_8BA1_65F6(dyingUnit)
end
local function _____786E_4FDD_7C73_4E9A_7075_732B_5206_8EAB_6B7B_4EA1_76D1_542C()
    if _____7C73_4E9A_7075_732B_5206_8EAB_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____7C73_4E9A_7075_732B_5206_8EAB_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
    registerDeathListener(____on_7C73_4E9A_7075_732B_5206_8EAB_6B7B_4EA1)
end
local function _____66F4_65B0_7C73_4E9A_7075_732B_5206_8EAB_5012_8BA1_65F6(variable)
    local data = variable
    if data == nil then
        return
    end
    if not _____5355_4F4D_6709_6548(data["单位"]) or not _____5355_4F4D_6709_6548(data.context["Boss单位"]) then
        _____6E05_7406_7C73_4E9A_7075_732B_5206_8EAB_5012_8BA1_65F6(data)
        return
    end
    local remaining = (data["到期时间毫秒"] - getServerTime()) / 1000
    if remaining < 0 then
        remaining = 0
    end
    _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI(data.UI, remaining)
    if not (remaining > 0) then
        _____6E05_7406_7C73_4E9A_7075_732B_5206_8EAB_5012_8BA1_65F6(data)
    end
end
local function _____521B_5EFA_7C73_4E9A_7075_732B_5206_8EAB_5012_8BA1_65F6(context, unit, x, y)
    local ____temp_9 = context == nil or context["清理"] == nil
    if not ____temp_9 then
        local ____self_8 = context["清理"]
        ____temp_9 = ____self_8["已清理"](____self_8)
    end
    if ____temp_9 or not _____5355_4F4D_6709_6548(unit) then
        return
    end
    _____786E_4FDD_7C73_4E9A_7075_732B_5206_8EAB_6B7B_4EA1_76D1_542C()
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["灵猫分身"]
    local data = {
        context = context,
        ["单位"] = unit,
        UI = _____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI({
            X = x,
            Y = y,
            Z = 220,
            ["最大值"] = config["持续秒"],
            ["当前值"] = config["持续秒"],
            ["标题"] = "灵猫分身",
            ["数值后缀"] = "秒",
            ["类型"] = "危险",
            ["平滑过渡秒"] = 0.1,
            ["初始显示"] = true,
            ["雾中可见"] = false
        }),
        ["周期ID"] = 0,
        ["到期时间毫秒"] = getServerTime() + config["持续秒"] * 1000
    }
    if data.UI == nil then
        return
    end
    _____7C73_4E9A_7075_732B_5206_8EAB_5012_8BA1_65F6_8868[GetHandleId(unit)] = data
    data["周期ID"] = addPeriodicCallback(100, _____66F4_65B0_7C73_4E9A_7075_732B_5206_8EAB_5012_8BA1_65F6, data)
    local ____self_10 = context["清理"]
    ____self_10["登记周期回调"](____self_10, "米亚-灵猫分身倒计时", data["周期ID"])
    local ____self_11 = context["清理"]
    ____self_11["登记清理"](____self_11, "米亚-灵猫分身倒计时UI", _____6E05_7406_7C73_4E9A_7075_732B_5206_8EAB_5012_8BA1_65F6, data)
end
local function _____64AD_653E_5206_8EAB_51FA_751F_8868_73B0(x, y)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = "Common\\Effect\\Element\\magic\\WhiteElement.mdx",
        X = x,
        Y = y,
        ["持续秒"] = 1.5,
        ["缩放"] = 1
    })
end
local function _____6062_590DBoss_751F_547D(boss, amount)
    if not _____5355_4F4D_6709_6548(boss) or amount <= 0 then
        return
    end
    doHeal({
        HealSource = boss,
        HealTarget = boss,
        HealAmount = amount,
        ItemHeal = false,
        HealEffect = false
    })
end
local function _____5B89_6392_5206_8EAB_5230_671F_7ED3_7B97(context, summons)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["灵猫分身"]
    addDelayedCallback(
        (config["持续秒"] - 5) * 1000,
        function()
            do
                local i = 0
                while i < #summons do
                    if _____5355_4F4D_6709_6548(summons[i + 1]) then
                        _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "灵猫分身", 2)
                        break
                    end
                    i = i + 1
                end
            end
        end
    )
    addDelayedCallback(
        config["持续秒"] * 1000,
        function()
            local boss = context["Boss单位"]
            if not _____5355_4F4D_6709_6548(boss) then
                return
            end
            local healPerSummon = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * config["未击杀每只恢复生命比例"]
            local aliveCount = 0
            do
                local i = 0
                while i < #summons do
                    do
                        local summon = summons[i + 1]
                        if not _____5355_4F4D_6709_6548(summon) then
                            goto __continue31
                        end
                        aliveCount = aliveCount + 1
                        _____521B_5EFA_5355_4F4D_811A_4E0B_70B9_7279_6548(summon, {["模型路径"] = "Common\\Effect\\Form\\Illusion\\MirrorImageIllusion.mdx", ["持续秒"] = 1.2, ["缩放"] = 1})
                        RemoveUnit(summon)
                    end
                    ::__continue31::
                    i = i + 1
                end
            end
            if aliveCount > 0 then
                _____6062_590DBoss_751F_547D(boss, healPerSummon * aliveCount)
                _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "灵猫分身", 3)
            else
                _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "灵猫分身", 4)
            end
        end
    )
end
____exports["触发米亚灵猫分身"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return false
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["灵猫分身"]
    local bossX = GetUnitX(boss)
    local bossY = GetUnitY(boss)
    local facing = GetUnitFacing(boss)
    local maxLife = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE)
    local rawAttack = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss)
    local attack = rawAttack > 0 and rawAttack or _____7C73_4E9A_8FD0_884C_65F6_914D_7F6E["Boss攻击力兜底"]
    local summons = {}
    _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "灵猫分身", 0)
    _____64AD_653EBoss_5750_6807_97F3_6548(_____7C73_4E9A_97F3_6548_914D_7F6E["灵猫分身"]["主辨识音"], bossX, bossY, _____7C73_4E9A_97F3_6548_914D_7F6E["默认裁断距离"])
    _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548(
        _____7C73_4E9A_97F3_6548_914D_7F6E["灵猫分身"]["凝形补层"],
        bossX,
        bossY,
        _____7C73_4E9A_97F3_6548_914D_7F6E["灵猫分身"]["凝形补层延迟Ms"],
        _____7C73_4E9A_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____521B_5EFA_5355_4F4D_811A_4E0B_70B9_7279_6548(boss, {["模型路径"] = "Common\\Effect\\Form\\Illusion\\MirrorImageIllusion.mdx", ["持续秒"] = 1.2, ["缩放"] = 1})
    local offsets = {-1, 1}
    do
        local i = 0
        while i < config["分身数量"] do
            local side = offsets[i % #offsets + 1]
            local angle = facing + 90 * side
            local x = bossX + CosBJ(angle) * config["召唤距离"]
            local y = bossY + SinBJ(angle) * config["召唤距离"]
            _____64AD_653E_5206_8EAB_51FA_751F_8868_73B0(x, y)
            local summon = _____521B_5EFA_53EC_5524_7269({
                ["主人单位"] = boss,
                ["单位名称"] = "腐化灵猫幻影",
                X = x,
                Y = y,
                ["朝向"] = facing,
                ["持续时间"] = config["持续秒"] + 0.5,
                ["模型文件"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["模型"].Boss,
                ["生命值"] = maxLife * config["分身生命比例"],
                ["生命值受小怪倍率"] = false,
                ["攻击力"] = attack * config["分身攻击力比例"],
                ["攻击间隔"] = config["分身攻击间隔"],
                ["攻击范围"] = config["分身攻击范围"],
                ["索敌范围"] = config["分身索敌范围"],
                ["缩放"] = config["分身缩放"]
            })
            if _____5355_4F4D_6709_6548(summon) then
                X_FixUnitStandingSafe(summon)
                _____521B_5EFA_7C73_4E9A_7075_732B_5206_8EAB_5012_8BA1_65F6(context, summon, x, y)
                summons[#summons + 1] = summon
            end
            i = i + 1
        end
    end
    if #summons > 0 then
        _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "灵猫分身", 1)
        _____5B89_6392_5206_8EAB_5230_671F_7ED3_7B97(context, summons)
    end
    return true
end
return ____exports
