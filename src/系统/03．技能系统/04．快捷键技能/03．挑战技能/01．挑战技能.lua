--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_6311_6218_6280_80FD_914D_7F6E = require("系统.03．技能系统.04．快捷键技能.03．挑战技能.00．挑战技能配置")
local _____6311_6218_6280_80FD_914D_7F6E_8868 = ____00_FF0E_6311_6218_6280_80FD_914D_7F6E["挑战技能配置表"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_1["是玩家英雄组单位"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接")
local _____542F_52A8_5267_60C5Boss_6218 = ____require_result_3["启动剧情Boss战"]
local ____require_result_4 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_4["广播单位提示"]
local _____64AD_653E_5E7F_64AD_5BF9_767D_5E8F_5217 = ____require_result_4["播放广播对白序列"]
local ____require_result_5 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
local _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8 = ____require_result_5["记录Boss自动技能启动"]
local _____662F_5426_5DF2_767B_8BB0Boss_81EA_52A8_6280_80FD = ____require_result_5["是否已登记Boss自动技能"]
local ____require_result_6 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_6["应用Boss战启动属性配置"]
local ____require_result_7 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.03．Boss战运行驱动")
local _____542F_52A8Boss_6218_8FD0_884C = ____require_result_7["启动Boss战运行"]
local ____require_result_8 = require("系统.11．剧情系统.02．支线任务.01．被驱逐的水怪.00．入口配置")
local _____8BFB_53D6_5361_745F_62C9_5355_4F4D = ____require_result_8["读取卡瑟拉单位"]
local _____662F_5426_5361_745F_62C9_5165_53E3_5BF9_767D_5DF2_5B8C_6210 = ____require_result_8["是否卡瑟拉入口对白已完成"]
local ____require_result_9 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_9.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_9.YDUserDataSetSafe
local YDUserDataClearSafe = ____require_result_9.YDUserDataClearSafe
local ____require_result_10 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWEAngleBetweenUnitsSafe = ____require_result_10.YDWEAngleBetweenUnitsSafe
local ____require_result_11 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_11["创建单位并登记排泄安全"]
local ____require_result_12 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_12.registerDeathListener
local ____require_result_13 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_13.debugLogForce
local _____6311_6218_6280_80FD_6A21_5757_540D = "挑战技能"
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local Player = jass.Player
local RemoveUnit = jass.RemoveUnit
local TriggerRegisterUnitEvent = jass.TriggerRegisterUnitEvent
local _____5DF2_521D_59CB_5316_6311_6218_6280_80FD = false
local _____5361_745F_62C9Boss_6218_5DF2_542F_52A8 = false
local _____55DC_8840_517D_4EBA_6311_6218_5DF2_5B8C_6210 = false
local _____5F53_524D_55DC_8840_517D_4EBABoss = nil
local _____5F53_524D_55DC_8840_517D_4EBA_6311_6218_82F1_96C4 = nil
local _____55DC_8840_517D_4EBA_4EFB_52A1ID = 10019
local _____55DC_8840_517D_4EBABoss_5355_4F4D_7C7B_578BID = stringToFourCCSafe("O008")
local _____517D_4EBA_63A2_9669_5BB6_5355_4F4D_7C7B_578BID = stringToFourCCSafe("ogru")
local _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID = 15
local ____Boss002_89E6_53D1_540D = "gg_trg_______Boss002"
local ____BossTS_89E6_53D1_540D = "gg_trg_______Boss____________TS"
local function _____8BFB_53D6_6311_6218_6280_80FD_914D_7F6E_5217_8868(_____6280_80FDID)
    local _____7ED3_679C = {}
    for ____, _____914D_7F6E in ipairs(_____6311_6218_6280_80FD_914D_7F6E_8868) do
        if stringToFourCCSafe(_____914D_7F6E["技能ID"]) == _____6280_80FDID then
            _____7ED3_679C[#_____7ED3_679C + 1] = _____914D_7F6E
        end
    end
    return _____7ED3_679C
end
local function _____8BFB_53D6_55DC_8840_517D_4EBA_4F2A_88C5_5355_4F4D()
    return YDUserDataGetSafe("string", "支线敌人", "嗜血兽人", "unit")
end
local function _____6CE8_518C_55DC_8840_517D_4EBA_65E7_89E6_53D1_5668_5355_4F4D_4E8B_4EF6(boss)
    local _____65E7_89E6_53D1Boss002 = jglobals[____Boss002_89E6_53D1_540D]
    local _____65E7_89E6_53D1BossTS = jglobals[____BossTS_89E6_53D1_540D]
    if _____65E7_89E6_53D1Boss002 ~= nil and _____65E7_89E6_53D1Boss002 ~= 0 then
        TriggerRegisterUnitEvent(_____65E7_89E6_53D1Boss002, boss, jass.EVENT_UNIT_SPELL_EFFECT)
    end
    if _____65E7_89E6_53D1BossTS ~= nil and _____65E7_89E6_53D1BossTS ~= 0 then
        TriggerRegisterUnitEvent(_____65E7_89E6_53D1BossTS, boss, jass.EVENT_UNIT_SPELL_CAST)
    end
end
local function _____8BFB_53D6_55DC_8840_517D_4EBA_53D1_73B0_5BF9_767D_5355_4F4D(_____8BF4_8BDD_8005_952E)
    local ____temp_14
    if _____8BF4_8BDD_8005_952E == "Boss" then
        ____temp_14 = _____5F53_524D_55DC_8840_517D_4EBABoss
    else
        ____temp_14 = _____5F53_524D_55DC_8840_517D_4EBA_6311_6218_82F1_96C4
    end
    return ____temp_14
end
local function _____5F00_59CB_55DC_8840_517D_4EBA_6218_6597()
    local ____Boss_5355_4F4D = _____5F53_524D_55DC_8840_517D_4EBABoss
    if ____Boss_5355_4F4D == nil or ____Boss_5355_4F4D == 0 then
        return
    end
    if not _____662F_5426_5DF2_767B_8BB0Boss_81EA_52A8_6280_80FD(____Boss_5355_4F4D) then
        _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8(____Boss_5355_4F4D, "Boss战.绑定单位")
    end
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(____Boss_5355_4F4D)
    _____542F_52A8Boss_6218_8FD0_884C(____Boss_5355_4F4D)
end
local function ____on_55DC_8840_517D_4EBABoss_6B7B_4EA1(_____6B7B_4EA1_5355_4F4D, ______51FB_6740_8005)
    if _____5F53_524D_55DC_8840_517D_4EBABoss == nil or _____6B7B_4EA1_5355_4F4D ~= _____5F53_524D_55DC_8840_517D_4EBABoss then
        return
    end
    _____5F53_524D_55DC_8840_517D_4EBABoss = nil
    YDUserDataClearSafe("string", "支线敌人", "嗜血兽人", "unit")
end
local function _____64AD_653E_55DC_8840_517D_4EBA_53D1_73B0_5BF9_767D(_____82F1_96C4, boss)
    _____5F53_524D_55DC_8840_517D_4EBA_6311_6218_82F1_96C4 = _____82F1_96C4
    _____5F53_524D_55DC_8840_517D_4EBABoss = boss
    _____64AD_653E_5E7F_64AD_5BF9_767D_5E8F_5217({["对白列表"] = {{["说话者键"] = "玩家", ["文本"] = "原来如此，看来造成这一切的生灵，就是你这家伙。", ["停留毫秒"] = 2000}, {["说话者键"] = "Boss", ["文本"] = "哦？被发现了吗，那又怎么样，成为我的鲜血吧！", ["停留毫秒"] = 2000}}, ["读取说话单位"] = _____8BFB_53D6_55DC_8840_517D_4EBA_53D1_73B0_5BF9_767D_5355_4F4D, ["播放单句"] = _____5E7F_64AD_5355_4F4D_63D0_793A, ["播放完成"] = _____5F00_59CB_55DC_8840_517D_4EBA_6218_6597})
end
local function _____6267_884C_55DC_8840_517D_4EBA_6311_6218_53D8_5F62(_____65BD_6CD5_5355_4F4D, _____76EE_6807_5355_4F4D)
    if _____55DC_8840_517D_4EBA_6311_6218_5DF2_5B8C_6210 then
        return false
    end
    if GetUnitTypeId(_____76EE_6807_5355_4F4D) ~= _____517D_4EBA_63A2_9669_5BB6_5355_4F4D_7C7B_578BID then
        debugLogForce(
            _____6311_6218_6280_80FD_6A21_5757_540D,
            "嗜血兽人挑战被拒",
            "目标类型不匹配",
            GetUnitTypeId(_____76EE_6807_5355_4F4D),
            "需要=",
            _____517D_4EBA_63A2_9669_5BB6_5355_4F4D_7C7B_578BID
        )
        return false
    end
    local _____4F2A_88C5_5355_4F4D = _____8BFB_53D6_55DC_8840_517D_4EBA_4F2A_88C5_5355_4F4D()
    if _____4F2A_88C5_5355_4F4D ~= _____76EE_6807_5355_4F4D then
        debugLogForce(
            _____6311_6218_6280_80FD_6A21_5757_540D,
            "嗜血兽人挑战被拒",
            "目标非YD伪装单位",
            "YD=",
            _____4F2A_88C5_5355_4F4D,
            "目标=",
            _____76EE_6807_5355_4F4D
        )
        return false
    end
    local _____73A9_5BB6ID = GetPlayerId(GetOwningPlayer(_____65BD_6CD5_5355_4F4D))
    local _____5DF2_63A5_53D6_6807_8BB0 = YDUserDataGetSafe("string", "失踪的精灵村民", "任务状态", "boolean")
    if _____5DF2_63A5_53D6_6807_8BB0 ~= true then
        debugLogForce(_____6311_6218_6280_80FD_6A21_5757_540D, "嗜血兽人挑战被拒", "任务状态标记未激活", _____73A9_5BB6ID)
        return false
    end
    local X = GetUnitX(_____76EE_6807_5355_4F4D)
    local Y = GetUnitY(_____76EE_6807_5355_4F4D)
    local _____671D_5411_73A9_5BB6 = YDWEAngleBetweenUnitsSafe(_____76EE_6807_5355_4F4D, _____65BD_6CD5_5355_4F4D)
    local ____Boss_5355_4F4D = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(_____4E2D_7ACB_88AB_52A8_73A9_5BB6ID),
        _____55DC_8840_517D_4EBABoss_5355_4F4D_7C7B_578BID,
        X,
        Y,
        _____671D_5411_73A9_5BB6
    )
    if ____Boss_5355_4F4D == nil or ____Boss_5355_4F4D == 0 then
        debugLogForce(_____6311_6218_6280_80FD_6A21_5757_540D, "嗜血兽人Boss创建失败")
        return false
    end
    _____55DC_8840_517D_4EBA_6311_6218_5DF2_5B8C_6210 = true
    RemoveUnit(_____76EE_6807_5355_4F4D)
    _____6CE8_518C_55DC_8840_517D_4EBA_65E7_89E6_53D1_5668_5355_4F4D_4E8B_4EF6(____Boss_5355_4F4D)
    debugLogForce(
        _____6311_6218_6280_80FD_6A21_5757_540D,
        "嗜血兽人挑战变形完成",
        "BossHid=",
        jass.GetHandleId(____Boss_5355_4F4D)
    )
    _____64AD_653E_55DC_8840_517D_4EBA_53D1_73B0_5BF9_767D(_____65BD_6CD5_5355_4F4D, ____Boss_5355_4F4D)
    return true
end
local function ____on_6311_6218_6280_80FD_751F_6548(_____65BD_6CD5_5355_4F4D, _____6280_80FDID)
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____65BD_6CD5_5355_4F4D) then
        return
    end
    local _____914D_7F6E_5217_8868 = _____8BFB_53D6_6311_6218_6280_80FD_914D_7F6E_5217_8868(_____6280_80FDID)
    if #_____914D_7F6E_5217_8868 == 0 then
        return
    end
    local _____76EE_6807_5355_4F4D = GetSpellTargetUnit()
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return
    end
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            do
                local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
                if _____914D_7F6E["任务ID"] == _____55DC_8840_517D_4EBA_4EFB_52A1ID then
                    _____6267_884C_55DC_8840_517D_4EBA_6311_6218_53D8_5F62(_____65BD_6CD5_5355_4F4D, _____76EE_6807_5355_4F4D)
                    goto __continue28
                end
                if _____5361_745F_62C9Boss_6218_5DF2_542F_52A8 then
                    goto __continue28
                end
                local _____5361_745F_62C9 = _____8BFB_53D6_5361_745F_62C9_5355_4F4D()
                if _____5361_745F_62C9 == nil or _____5361_745F_62C9 == 0 then
                    goto __continue28
                end
                if not _____662F_5426_5361_745F_62C9_5165_53E3_5BF9_767D_5DF2_5B8C_6210() then
                    goto __continue28
                end
                if _____76EE_6807_5355_4F4D ~= _____5361_745F_62C9 then
                    goto __continue28
                end
                if GetUnitTypeId(_____76EE_6807_5355_4F4D) ~= stringToFourCCSafe(_____914D_7F6E["目标单位ID"]) then
                    goto __continue28
                end
                if _____542F_52A8_5267_60C5Boss_6218(_____5361_745F_62C9, {["触发单位"] = _____65BD_6CD5_5355_4F4D}) then
                    _____5361_745F_62C9Boss_6218_5DF2_542F_52A8 = true
                end
            end
            ::__continue28::
            i = i + 1
        end
    end
end
____exports["init挑战技能"] = function()
    if _____5DF2_521D_59CB_5316_6311_6218_6280_80FD then
        return
    end
    _____5DF2_521D_59CB_5316_6311_6218_6280_80FD = true
    registerSpellEffectListener(____on_6311_6218_6280_80FD_751F_6548)
    registerDeathListener(____on_55DC_8840_517D_4EBABoss_6B7B_4EA1)
end
return ____exports
