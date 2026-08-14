--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.09．欧菲莉亚.00．配置")
local _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["欧菲莉亚单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.09．欧菲莉亚.00A．表现工具")
local _____64AD_653E_6B27_83F2_8389_4E9A_5355_4F4D_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放欧菲莉亚单位音效"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local _____6781_5750_6807X = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标Y"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_0["创建点特效"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.11．地形步进")
local _____6CBF_89D2_5EA6_6B65_8FDB_76F4_5230_5730_5F62_963B_6321 = ____require_result_2["沿角度步进直到地形阻挡"]
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_3.addPeriodicCallback
local removePeriodicCallback = ____require_result_3.removePeriodicCallback
local ____require_result_4 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_4.registerSpellEffectListener
local ____require_result_5 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.04．英雄复活系统")
local _____76F4_63A5_590D_6D3B_73A9_5BB6_82F1_96C4 = ____require_result_5["直接复活玩家英雄"]
local ____require_result_6 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_6.getRegisteredPlayerHero
local ____require_result_7 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_7.StarOther_PanCameraToTimedForPlayer
local ____require_result_8 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_8.YDUserDataGetSafe
local ____require_result_9 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文")
local _____8BFB_53D6_5F53_524DBoss_6218_8FD0_884C_5355_4F4D = ____require_result_9["读取当前Boss战运行单位"]
local _____6B27_83F2_8389_4E9A_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local _____6B27_83F2_8389_4E9AR_6280_80FDID = stringToFourCCSafe(_____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["R技能ID"])
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitStateJapi = japi.GetUnitState
local function _____5F53_524D_5904_4E8EBoss_6218()
    local tsBoss = _____8BFB_53D6_5F53_524DBoss_6218_8FD0_884C_5355_4F4D()
    if tsBoss ~= nil and tsBoss ~= 0 then
        return true
    end
    return YDUserDataGetSafe("string", "Boss战", "状态", "boolean") == true or YDUserDataGetSafe("string", "普通Boss战", "状态", "boolean") == true
end
local function _____8BFB_53D6_6B27_83F2_8389_4E9AR_6218_6597Boss()
    local tsBoss = _____8BFB_53D6_5F53_524DBoss_6218_8FD0_884C_5355_4F4D()
    if tsBoss ~= nil and tsBoss ~= 0 then
        return tsBoss
    end
    local boss = YDUserDataGetSafe("string", "Boss战", "单位", "unit")
    if boss ~= nil and boss ~= 0 then
        return boss
    end
    return YDUserDataGetSafe("string", "普通Boss战", "单位", "unit")
end
local function _____8BBE_7F6E_590D_6D3B_751F_547D_9B54_6CD5(hero, lifePercent, manaPercent)
    local maxLife = GetUnitStateJapi(hero, jass.UNIT_STATE_MAX_LIFE)
    local maxMana = GetUnitStateJapi(hero, jass.UNIT_STATE_MAX_MANA)
    if maxLife > 0 then
        jass.SetUnitState(hero, jass.UNIT_STATE_LIFE, maxLife * lifePercent * 0.01)
    end
    if maxMana > 0 then
        jass.SetUnitState(hero, jass.UNIT_STATE_MANA, maxMana * manaPercent * 0.01)
    end
end
local function _____7ED3_675F_6B27_83F2_8389_4E9AR_79FB_52A8(record)
    if record["回调ID"] > 0 then
        removePeriodicCallback(record["回调ID"])
    end
    record["回调ID"] = 0
    if record["单位"] == nil or record["单位"] == 0 then
        return
    end
    StarOther_PanCameraToTimedForPlayer(
        jass.GetOwningPlayer(record["单位"]),
        GetUnitX(record["单位"]),
        GetUnitY(record["单位"]),
        0.1
    )
end
local function _____6B27_83F2_8389_4E9AR_79FB_52A8Tick(variable)
    local record = variable
    if record == nil or not _____5355_4F4D_5B58_6D3B(record["单位"]) then
        if record ~= nil then
            _____7ED3_675F_6B27_83F2_8389_4E9AR_79FB_52A8(record)
        end
        return
    end
    if record["步数"] >= _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.R["复活移动步数"] then
        _____7ED3_675F_6B27_83F2_8389_4E9AR_79FB_52A8(record)
        return
    end
    local result = _____6CBF_89D2_5EA6_6B65_8FDB_76F4_5230_5730_5F62_963B_6321({
        ["起点X"] = GetUnitX(record["单位"]),
        ["起点Y"] = GetUnitY(record["单位"]),
        ["角度度"] = record["方向"],
        ["单步距离"] = _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.R["复活移动单步距离"],
        ["步数"] = 1,
        ["检测单位"] = record["单位"]
    })
    local x = _____6781_5750_6807X(result["最终X"], record["方向"], 0)
    local y = _____6781_5750_6807Y(result["最终Y"], record["方向"], 0)
    jass.SetUnitX(record["单位"], x)
    jass.SetUnitY(record["单位"], y)
    record["步数"] = record["步数"] + 1
    if record["步数"] >= _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.R["复活移动步数"] or result["是否提前停止"] then
        _____7ED3_675F_6B27_83F2_8389_4E9AR_79FB_52A8(record)
    end
end
local function _____5F00_59CB_6B27_83F2_8389_4E9AR_79FB_52A8(hero)
    local record = {
        ["单位"] = hero,
        ["方向"] = jass.GetRandomReal(0, 360),
        ["步数"] = 0,
        ["回调ID"] = 0
    }
    record["回调ID"] = addPeriodicCallback(_____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.R["复活移动间隔毫秒"], _____6B27_83F2_8389_4E9AR_79FB_52A8Tick, record)
end
local function _____590D_6D3B_6B27_83F2_8389_4E9AR_76EE_6807(caster, target, level, bossBattle, battleBoss)
    if target == nil or target == 0 or not jass.IsUnitType(target, jass.UNIT_TYPE_DEAD) then
        return
    end
    local deadX = GetUnitX(target)
    local deadY = GetUnitY(target)
    _____521B_5EFA_70B9_7279_6548({["模型路径"] = _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.R["复活特效模型"], X = deadX, Y = deadY, ["持续秒"] = _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.R["复活特效持续秒"]})
    if not _____76F4_63A5_590D_6D3B_73A9_5BB6_82F1_96C4(target) then
        return
    end
    local ____bossBattle_10
    if bossBattle then
        ____bossBattle_10 = battleBoss
    else
        ____bossBattle_10 = nil
    end
    local respawnBoss = ____bossBattle_10
    if respawnBoss ~= nil and respawnBoss ~= 0 then
        jass.SetUnitX(
            target,
            GetUnitX(respawnBoss)
        )
        jass.SetUnitY(
            target,
            GetUnitY(respawnBoss)
        )
    elseif not bossBattle then
        jass.SetUnitX(
            target,
            GetUnitX(caster)
        )
        jass.SetUnitY(
            target,
            GetUnitY(caster)
        )
    end
    jass.SetUnitFlyHeight(
        target,
        jass.GetUnitDefaultFlyHeight(target),
        0
    )
    jass.SetUnitTimeScale(target, 1)
    jass.ShowUnit(target, true)
    jass.CameraClearNoiseForPlayer(jass.GetOwningPlayer(target))
    _____8BBE_7F6E_590D_6D3B_751F_547D_9B54_6CD5(target, _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.R["主动生命基础百分比"] + _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.R["主动生命每级百分比"] * level, _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.R["主动魔法基础百分比"] + _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.R["主动魔法每级百分比"] * level)
    _____5F00_59CB_6B27_83F2_8389_4E9AR_79FB_52A8(target)
end
local function _____5904_7406_6B27_83F2_8389_4E9AR(caster, abilityId)
    if abilityId ~= _____6B27_83F2_8389_4E9AR_6280_80FDID or GetUnitTypeId(caster) ~= _____6B27_83F2_8389_4E9A_5355_4F4D_7C7B_578BID then
        return
    end
    local level = GetUnitAbilityLevel(caster, _____6B27_83F2_8389_4E9AR_6280_80FDID)
    _____64AD_653E_6B27_83F2_8389_4E9A_5355_4F4D_97F3_6548(caster, _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.R["全局音效键"])
    local battleBoss = _____8BFB_53D6_6B27_83F2_8389_4E9AR_6218_6597Boss()
    local bossBattle = _____5F53_524D_5904_4E8EBoss_6218()
    do
        local i = 0
        while i < 16 do
            do
                local hero = getRegisteredPlayerHero(jass.Player(i))
                if hero == nil or hero == 0 then
                    goto __continue27
                end
                _____590D_6D3B_6B27_83F2_8389_4E9AR_76EE_6807(
                    caster,
                    hero,
                    level,
                    bossBattle,
                    battleBoss
                )
            end
            ::__continue27::
            i = i + 1
        end
    end
end
registerSpellEffectListener(_____5904_7406_6B27_83F2_8389_4E9AR)
return ____exports
