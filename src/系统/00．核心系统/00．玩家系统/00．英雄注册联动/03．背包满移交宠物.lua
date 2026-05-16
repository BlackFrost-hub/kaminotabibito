local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local _____662F_5426_6709_6548, _____786E_4FDD_667A_80FD_547D_4EE4ID, _____5BA0_7269_79FB_4EA4_5904_7406_5668, jass, YDUserDataGet, String2OrderIdBJ, SoHeroHatm, GS_news, _____5BA0_7269_5C5E_6027, _____667A_80FD_547D_4EE4, _____6D88_606F__4E24_8005_6EE1, _____6D88_606F__79FB_4EA4_5BA0_7269, _____667A_80FD_547D_4EE4ID
function _____662F_5426_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
function _____786E_4FDD_667A_80FD_547D_4EE4ID()
    if _____667A_80FD_547D_4EE4ID ~= 0 then
        return _____667A_80FD_547D_4EE4ID
    end
    _____667A_80FD_547D_4EE4ID = String2OrderIdBJ(nil, _____667A_80FD_547D_4EE4)
    return _____667A_80FD_547D_4EE4ID
end
function _____5BA0_7269_79FB_4EA4_5904_7406_5668()
    local _____76EE_6807_7269_54C1 = jass.GetOrderTargetItem()
    if not _____662F_5426_6709_6548(_____76EE_6807_7269_54C1) then
        return
    end
    local _____4E0B_8FBE_547D_4EE4ID = jass.GetIssuedOrderId() or 0
    if _____4E0B_8FBE_547D_4EE4ID ~= _____786E_4FDD_667A_80FD_547D_4EE4ID() then
        return
    end
    local _____82F1_96C4 = jass.GetTriggerUnit()
    if not _____662F_5426_6709_6548(_____82F1_96C4) or SoHeroHatm(nil, _____82F1_96C4) < 6 then
        return
    end
    local _____4E3B_4EBA = jass.GetOwningPlayer(_____82F1_96C4)
    if not _____662F_5426_6709_6548(_____4E3B_4EBA) then
        return
    end
    local _____5BA0_7269 = YDUserDataGet(
        nil,
        "player",
        _____4E3B_4EBA,
        _____5BA0_7269_5C5E_6027,
        "unit"
    )
    if not _____662F_5426_6709_6548(_____5BA0_7269) then
        return
    end
    if SoHeroHatm(nil, _____5BA0_7269) >= 6 then
        GS_news(nil, _____4E3B_4EBA, _____6D88_606F__4E24_8005_6EE1)
        return
    end
    jass.UnitAddItem(_____5BA0_7269, _____76EE_6807_7269_54C1)
    GS_news(nil, _____4E3B_4EBA, _____6D88_606F__79FB_4EA4_5BA0_7269)
end
jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
YDUserDataGet = ____require_result_0.YDUserDataGet
local ____require_result_1 = require("lib.扩展函数.BJ函数.07．杂项")
String2OrderIdBJ = ____require_result_1.String2OrderIdBJ
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.GS扩展库.index")
SoHeroHatm = ____require_result_2.SoHeroHatm
GS_news = ____require_result_2.GS_news
local unitSpecificEventCenter = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
_____5BA0_7269_5C5E_6027 = "BB"
_____667A_80FD_547D_4EE4 = "smart"
_____6D88_606F__4E24_8005_6EE1 = "|cffffff00『系统提示』：|r英雄和|cffffcc99『宠物』|r的物品栏都已满，无法拾取！"
_____6D88_606F__79FB_4EA4_5BA0_7269 = "|cffffff00『系统提示』：|r由于物品栏已满，已经移交到|cffffcc99『宠物』|r"
local _____5BA0_7269_79FB_4EA4_89E6_53D1_5668 = nil
_____667A_80FD_547D_4EE4ID = 0
local _____5DF2_6CE8_518C_82F1_96C4ID_8868 = __TS__New(Set)
local function _____53D6_53E5_67C4ID(handle)
    if not _____662F_5426_6709_6548(handle) then
        return 0
    end
    return jass.GetHandleId(handle) or 0
end
local function _____786E_4FDD_5BA0_7269_79FB_4EA4_89E6_53D1_5668()
    if _____5BA0_7269_79FB_4EA4_89E6_53D1_5668 ~= nil then
        return _____5BA0_7269_79FB_4EA4_89E6_53D1_5668
    end
    _____5BA0_7269_79FB_4EA4_89E6_53D1_5668 = jass.CreateTrigger()
    jass.TriggerAddAction(_____5BA0_7269_79FB_4EA4_89E6_53D1_5668, _____5BA0_7269_79FB_4EA4_5904_7406_5668)
    return _____5BA0_7269_79FB_4EA4_89E6_53D1_5668
end
____exports["注册宠物移交英雄"] = function(whichHero)
    if not _____662F_5426_6709_6548(whichHero) then
        return
    end
    local trigger = _____786E_4FDD_5BA0_7269_79FB_4EA4_89E6_53D1_5668()
    if trigger == nil then
        return
    end
    local heroId = _____53D6_53E5_67C4ID(whichHero)
    if heroId == 0 or _____5DF2_6CE8_518C_82F1_96C4ID_8868:has(heroId) then
        return
    end
    unitSpecificEventCenter.registerUnitEventTrigger(trigger, whichHero, jass.EVENT_UNIT_ISSUED_TARGET_ORDER)
    _____5DF2_6CE8_518C_82F1_96C4ID_8868:add(heroId)
end
____exports["初始化宠物移交"] = function()
    _____786E_4FDD_5BA0_7269_79FB_4EA4_89E6_53D1_5668()
end
return ____exports
