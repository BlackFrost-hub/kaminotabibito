--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local globals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_1.getRegisteredPlayerHero
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_2.debugLogForce
local ____require_result_3 = require("系统.09．表现系统.01．UI工具.07．物品栏冷却显示")
local _____663E_793A_7269_54C1_680F_7269_54C1_51B7_5374 = ____require_result_3["显示物品栏物品冷却"]
local GetLocalPlayer = jass.GetLocalPlayer
local GetPlayerId = jass.GetPlayerId
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local UnitItemInSlot = jass.UnitItemInSlot
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____6A21_5757_540D = "物品栏被动冷却UI测试"
local _____6D4B_8BD5_547D_4EE4 = "wpuicd"
local _____6D4B_8BD5_69FD_4F4D = 0
local _____6D4B_8BD5_51B7_5374_6BEB_79D2 = 6000
local _____5DF2_521D_59CB_5316 = false
local function _____53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
local function _____5F53_524D_6BEB_79D2()
    return os:clock() * 1000
end
local function _____662F_672C_5730_73A9_5BB6(player)
    if not _____53E5_67C4_6709_6548(player) then
        return false
    end
    return GetPlayerId(GetLocalPlayer()) == GetPlayerId(player)
end
local function _____5355_4F4D_6709_6548(unit)
    return _____53E5_67C4_6709_6548(unit) and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____83B7_53D6_73A9_5BB6_6D4B_8BD5_82F1_96C4(player)
    local registeredHero = getRegisteredPlayerHero(player)
    if _____5355_4F4D_6709_6548(registeredHero) then
        return registeredHero
    end
    local presetHero = globals.gg_unit_Hamg_0002
    if _____5355_4F4D_6709_6548(presetHero) and GetPlayerId(GetOwningPlayer(presetHero)) == GetPlayerId(player) then
        return presetHero
    end
    return nil
end
local function ____on_6D4B_8BD5_547D_4EE4(player, _command)
    local hero = _____83B7_53D6_73A9_5BB6_6D4B_8BD5_82F1_96C4(player)
    if not _____5355_4F4D_6709_6548(hero) then
        debugLogForce(_____6A21_5757_540D, "未找到玩家英雄")
        return
    end
    local item = UnitItemInSlot(hero, _____6D4B_8BD5_69FD_4F4D)
    if not _____53E5_67C4_6709_6548(item) then
        debugLogForce(_____6A21_5757_540D, "英雄第1格没有物品")
        return
    end
    if _____662F_672C_5730_73A9_5BB6(player) then
        _____663E_793A_7269_54C1_680F_7269_54C1_51B7_5374(hero, item, _____6D4B_8BD5_51B7_5374_6BEB_79D2)
    end
    debugLogForce(
        _____6A21_5757_540D,
        "已触发第1格物品UI冷却测试",
        "英雄ID",
        GetHandleId(hero),
        "秒",
        _____6D4B_8BD5_51B7_5374_6BEB_79D2 / 1000
    )
end
local function _____521D_59CB_5316_7269_54C1_680F_88AB_52A8_51B7_5374UI_6D4B_8BD5()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_6D4B_8BD5_547D_4EE4)
end
_____521D_59CB_5316_7269_54C1_680F_88AB_52A8_51B7_5374UI_6D4B_8BD5()
return ____exports
