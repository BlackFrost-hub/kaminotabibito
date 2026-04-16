local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local Set = ____lualib.Set
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
--- 玩家单位管理器 — 功能：移速 > 阈值时挂龙卷提示特效
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local ____require_result_1 = require("lib.扩展函数.BJ函数.07．杂项")
local ForGroupBJ = ____require_result_1.ForGroupBJ
local ____require_result_2 = require("lib.扩展函数.KK扩展API.index")
local DzUnbindEffect = ____require_result_2.DzUnbindEffect
local C = require("系统.00．核心系统.00．玩家系统.00．常量")
--- unitHandleId -> effectHandle
local tornadoEffMap = __TS__New(Map)
local function getUnitHandleId(self, u)
    return type(jass.GetHandleId) == "function" and (jass.GetHandleId(u) or 0) or 0
end
local function createTornadoEffect(self, u)
    if type(jass.AddSpecialEffectTarget) ~= "function" then
        return nil
    end
    return jass.AddSpecialEffectTarget(C.TORNADO_EFFECT_MODEL, u, C.TORNADO_ATTACH_POINT)
end
local function destroyTornadoEffect(self, eff)
    if not eff then
        return
    end
    if type(DzUnbindEffect) == "function" then
        DzUnbindEffect(nil, eff)
    end
    if type(jass.DestroyEffect) == "function" then
        jass.DestroyEffect(eff)
    end
end
--- 一轮同步：读 YD 玩家英雄组，按移速增删龙卷特效；清理已不在组内但 Map 仍存的条目。
function ____exports.syncTornadoSpeedEffectsByHeroGroup(self)
    local heroGroup = YDUserDataGet(
        nil,
        C.YD_TABLE_TYPE_PLAYER_HERO,
        C.YD_TABLE_KEY_PLAYER_HERO,
        C.YD_ATTR_HERO_GROUP,
        C.YD_VALUE_TYPE_GROUP
    )
    if not heroGroup then
        return
    end
    if type(jass.GetUnitMoveSpeed) ~= "function" or type(jass.GetEnumUnit) ~= "function" then
        return
    end
    local seen = __TS__New(Set)
    ForGroupBJ(
        nil,
        heroGroup,
        function()
            local u = jass.GetEnumUnit()
            if u == nil or u == 0 then
                return
            end
            local uid = getUnitHandleId(nil, u)
            if not uid then
                return
            end
            seen:add(uid)
            local sp = jass.GetUnitMoveSpeed(u)
            local shouldHave = sp > C.MOVE_SPEED_THRESHOLD
            if shouldHave then
                if not tornadoEffMap:has(uid) then
                    local eff = createTornadoEffect(nil, u)
                    if eff then
                        tornadoEffMap:set(uid, eff)
                    end
                end
            else
                local eff = tornadoEffMap:get(uid)
                if eff then
                    destroyTornadoEffect(nil, eff)
                    tornadoEffMap:delete(uid)
                end
            end
        end
    )
    for ____, ____value in __TS__Iterator(tornadoEffMap) do
        local uid = ____value[1]
        local eff = ____value[2]
        if not seen:has(uid) then
            destroyTornadoEffect(nil, eff)
            tornadoEffMap:delete(uid)
        end
    end
end
return ____exports
