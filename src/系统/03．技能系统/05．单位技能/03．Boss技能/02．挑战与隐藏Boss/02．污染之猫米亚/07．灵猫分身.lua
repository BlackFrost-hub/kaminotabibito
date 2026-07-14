--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.00．配置")
local _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["米亚单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚技能数值配置"]
local _____7C73_4E9A_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚音效配置"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.15．台词播放")
local _____64AD_653E_7C73_4E9A_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放米亚台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["延迟播放Boss坐标音效"]
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
local _____521B_5EFA_53EC_5524_7269 = ____require_result_0["创建召唤物"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_2["创建点特效"]
local _____521B_5EFA_5355_4F4D_811A_4E0B_70B9_7279_6548 = ____require_result_2["创建单位脚下点特效"]
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local X_FixUnitStandingSafe = ____require_result_3.X_FixUnitStandingSafe
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local RemoveUnit = jass.RemoveUnit
local IsUnitType = jass.IsUnitType
local CosBJ = jass.CosBJ
local SinBJ = jass.SinBJ
local ConvertUnitState = jass.ConvertUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local GetUnitStateJapi = japi.GetUnitState
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____53D6_5355_4F4D_653B_51FB_529B(unit)
    if not _____5355_4F4D_6709_6548(unit) or type(GetUnitStateJapi) ~= "function" then
        return 1000
    end
    local value = GetUnitStateJapi(
        unit,
        ConvertUnitState(21)
    )
    return value > 0 and value or 1000
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
    local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    local current = GetUnitState(boss, UNIT_STATE_LIFE)
    local next = current + amount > maxLife and maxLife or current + amount
    SetUnitState(boss, UNIT_STATE_LIFE, next)
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
            local healPerSummon = GetUnitState(boss, UNIT_STATE_MAX_LIFE) * config["未击杀每只恢复生命比例"]
            local aliveCount = 0
            do
                local i = 0
                while i < #summons do
                    do
                        local summon = summons[i + 1]
                        if not _____5355_4F4D_6709_6548(summon) then
                            goto __continue16
                        end
                        aliveCount = aliveCount + 1
                        _____521B_5EFA_5355_4F4D_811A_4E0B_70B9_7279_6548(summon, {["模型路径"] = "Common\\Effect\\Form\\Illusion\\MirrorImageIllusion.mdx", ["持续秒"] = 1.2, ["缩放"] = 1})
                        RemoveUnit(summon)
                    end
                    ::__continue16::
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
local function _____89E6_53D1_7C73_4E9A_7075_732B_5206_8EAB(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["灵猫分身"]
    local bossX = GetUnitX(boss)
    local bossY = GetUnitY(boss)
    local facing = GetUnitFacing(boss)
    local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    local attack = _____53D6_5355_4F4D_653B_51FB_529B(boss)
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
                summons[#summons + 1] = summon
            end
            i = i + 1
        end
    end
    if #summons > 0 then
        _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "灵猫分身", 1)
        _____5B89_6392_5206_8EAB_5230_671F_7ED3_7B97(context, summons)
    end
end
____exports["注册米亚灵猫分身"] = function()
end
____exports["尝试触发米亚灵猫分身"] = function(context)
    if context["阶段"] ~= 1 then
        return
    end
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    if maxLife <= 0 then
        return
    end
    local ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife
    local thresholds = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["灵猫分身"]["触发生命比例"]
    if not context["已触发分身80"] and ratio <= thresholds[1] then
        context["已触发分身80"] = true
        _____89E6_53D1_7C73_4E9A_7075_732B_5206_8EAB(context)
        return
    end
    if not context["已触发分身50"] and ratio <= thresholds[2] then
        context["已触发分身50"] = true
        _____89E6_53D1_7C73_4E9A_7075_732B_5206_8EAB(context)
    end
end
return ____exports
