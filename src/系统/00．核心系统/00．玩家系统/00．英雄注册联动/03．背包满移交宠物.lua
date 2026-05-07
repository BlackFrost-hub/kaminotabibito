local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local isValidHandle, ensureSmartOrderId, onPetItemHandoff, jass, YDUserDataGet, String2OrderIdBJ, SoHeroHatm, GS_news, PET_ATTR, SMART_ORDER, MSG_BOTH_FULL, MSG_MOVED_TO_PET, smartOrderId
function isValidHandle(self, handle)
    return handle ~= nil and handle ~= 0
end
function ensureSmartOrderId(self)
    if smartOrderId ~= 0 then
        return smartOrderId
    end
    smartOrderId = String2OrderIdBJ(nil, SMART_ORDER)
    return smartOrderId
end
function onPetItemHandoff(self)
    local targetItem = jass:GetOrderTargetItem()
    if not isValidHandle(nil, targetItem) then
        return
    end
    local issuedOrderId = jass:GetIssuedOrderId() or 0
    if issuedOrderId ~= ensureSmartOrderId(nil) then
        return
    end
    local hero = jass:GetTriggerUnit()
    if not isValidHandle(nil, hero) or SoHeroHatm(nil, hero) < 6 then
        return
    end
    local owner = jass:GetOwningPlayer(hero)
    if not isValidHandle(nil, owner) then
        return
    end
    local pet = YDUserDataGet(
        nil,
        "player",
        owner,
        PET_ATTR,
        "unit"
    )
    if not isValidHandle(nil, pet) then
        return
    end
    if SoHeroHatm(nil, pet) >= 6 then
        GS_news(nil, owner, MSG_BOTH_FULL)
        return
    end
    jass:UnitAddItem(pet, targetItem)
    GS_news(nil, owner, MSG_MOVED_TO_PET)
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
PET_ATTR = "BB"
SMART_ORDER = "smart"
MSG_BOTH_FULL = "|cffffff00『系统提示』：|r英雄和|cffffcc99『宠物』|r的物品栏都已满，无法拾取！"
MSG_MOVED_TO_PET = "|cffffff00『系统提示』：|r由于物品栏已满，已经移交到|cffffcc99『宠物』|r"
local petItemHandoffTrigger = nil
smartOrderId = 0
local registeredHeroIds = __TS__New(Set)
local function getHandleId(self, handle)
    if not isValidHandle(nil, handle) then
        return 0
    end
    return jass:GetHandleId(handle) or 0
end
local function ensurePetItemHandoffTrigger(self)
    if petItemHandoffTrigger ~= nil then
        return petItemHandoffTrigger
    end
    petItemHandoffTrigger = jass:CreateTrigger()
    jass:TriggerAddAction(petItemHandoffTrigger, onPetItemHandoff)
    return petItemHandoffTrigger
end
--- 由英雄注册桥接调用。
-- 给指定英雄挂上“smart 目标物品命令”监听，避免重复注册。
function ____exports.registerPetItemHandoffHero(self, whichHero)
    if not isValidHandle(nil, whichHero) then
        return
    end
    local trigger = ensurePetItemHandoffTrigger(nil)
    if trigger == nil then
        return
    end
    local heroId = getHandleId(nil, whichHero)
    if heroId == 0 or registeredHeroIds:has(heroId) then
        return
    end
    unitSpecificEventCenter.registerUnitEventTrigger(trigger, whichHero, jass.EVENT_UNIT_ISSUED_TARGET_ORDER)
    registeredHeroIds:add(heroId)
end
--- 初始化时只确保触发器存在，真正的英雄注册由桥接模块负责。
function ____exports.initPetItemHandoff(self)
    ensurePetItemHandoffTrigger(nil)
end
return ____exports
