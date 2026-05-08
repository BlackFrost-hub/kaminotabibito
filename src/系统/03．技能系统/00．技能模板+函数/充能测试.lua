--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．充能.index")
local _____5F00_59CB_5145_80FD = ____index["开始充能"]
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
local debugLogForce = ____require_result_0.debugLogForce
local CreateTrigger = jass.CreateTrigger
local TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent
local TriggerAddAction = jass.TriggerAddAction
local Player = jass.Player
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitEnemy = jass.IsUnitEnemy
local CreateGroup = jass.CreateGroup
local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local DestroyGroup = jass.DestroyGroup
local UnitDamageTarget = jass.UnitDamageTarget
local _____6A21_5757_540D = "充能测试"
local _____6D4B_8BD5_5F00_5173 = true
local _____5145_80FD_6D4B_8BD5_547D_4EE4 = "113"
local _____5145_80FD_4F24_5BB3_534A_5F84 = 300
local _____5145_80FD_4F24_5BB3 = 100
local _____5DF2_6CE8_518C = false
local function _____5BF9_5468_56F4_654C_4EBA_9020_6210_4F24_5BB3(_____4E2D_5FC3_5355_4F4D)
    local _____4E2D_5FC3X = GetUnitX(_____4E2D_5FC3_5355_4F4D)
    local _____4E2D_5FC3Y = GetUnitY(_____4E2D_5FC3_5355_4F4D)
    local _____6240_5C5E_73A9_5BB6 = GetOwningPlayer(_____4E2D_5FC3_5355_4F4D)
    local _____679A_4E3E_7EC4 = CreateGroup()
    GroupEnumUnitsInRange(
        _____679A_4E3E_7EC4,
        _____4E2D_5FC3X,
        _____4E2D_5FC3Y,
        _____5145_80FD_4F24_5BB3_534A_5F84,
        nil
    )
    while true do
        local _____76EE_6807 = FirstOfGroup(_____679A_4E3E_7EC4)
        if _____76EE_6807 == nil or _____76EE_6807 == 0 then
            break
        end
        GroupRemoveUnit(_____679A_4E3E_7EC4, _____76EE_6807)
        if IsUnitEnemy(_____76EE_6807, _____6240_5C5E_73A9_5BB6) then
            UnitDamageTarget(
                _____4E2D_5FC3_5355_4F4D,
                _____76EE_6807,
                _____5145_80FD_4F24_5BB3,
                false,
                false,
                jass.ATTACK_TYPE_NORMAL,
                jass.DAMAGE_TYPE_NORMAL,
                jass.WEAPON_TYPE_WHOKNOWS
            )
        end
    end
    DestroyGroup(_____679A_4E3E_7EC4)
end
local function _____5145_80FD_5B8C_6210_56DE_8C03(_____5355_4F4D, ______5145_80FDID)
    debugLogForce(_____6A21_5757_540D, "充能完成，对周围敌人造成", _____5145_80FD_4F24_5BB3, "伤害")
    _____5BF9_5468_56F4_654C_4EBA_9020_6210_4F24_5BB3(_____5355_4F4D)
end
local function _____6267_884C_5145_80FD_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到 gg_unit_Hamg_0002")
        return
    end
    local _____5145_80FDID = _____5F00_59CB_5145_80FD(_____5927_6CD5_5E08, {["持续时间"] = 3, ["充能完成回调"] = _____5145_80FD_5B8C_6210_56DE_8C03})
    debugLogForce(_____6A21_5757_540D, "开始充能，id=", _____5145_80FDID)
end
local function ____on_804A_5929113_6D4B_8BD5()
    _____6267_884C_5145_80FD_6D4B_8BD5()
end
local function _____6CE8_518C_804A_5929_6D4B_8BD5()
    if not _____6D4B_8BD5_5F00_5173 or _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    local trig113 = CreateTrigger()
    TriggerRegisterPlayerChatEvent(
        trig113,
        Player(0),
        _____5145_80FD_6D4B_8BD5_547D_4EE4,
        true
    )
    TriggerAddAction(trig113, ____on_804A_5929113_6D4B_8BD5)
    debugLogForce(_____6A21_5757_540D, "已注册测试：113=开始3秒充能")
end
_____6CE8_518C_804A_5929_6D4B_8BD5()
return ____exports
