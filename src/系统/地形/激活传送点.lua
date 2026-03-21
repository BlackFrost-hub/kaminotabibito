local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local _____6FC0_6D3B_4F20_9001_70B9_914D_7F6E = require("系统.地形.激活传送点配置")
local _____6FC0_6D3B_4F20_9001_70B9_914D_7F6E = _____6FC0_6D3B_4F20_9001_70B9_914D_7F6E.default
--- 激活传送点系统：
-- - 根据《激活传送点配置》在地图上创建一次性 Region
-- - 单位首次进入时：删除用于检测的 Rect，可选地：
--   - 把配置里指定的单位交给玩家7（绿色，Player(6)）
--   - 为玩家1（红色，Player(0)）在指定 Rect 开视野
--   - 向所有玩家显示提示文字
local jass = require("jass.common")
local g = require("jass.globals")
local regionMap = __TS__New(Map)
local function dbg(self, _msg)
end
local function initActivationPointsInternal(self)
    if type(jass.CreateTrigger) ~= "function" or type(jass.CreateRegion) ~= "function" or type(jass.Rect) ~= "function" then
        return
    end
    local enabledCount = 0
    for key in pairs(_____6FC0_6D3B_4F20_9001_70B9_914D_7F6E) do
        do
            local __continue5
            repeat
                local cfg = _____6FC0_6D3B_4F20_9001_70B9_914D_7F6E[key]
                if not cfg or not cfg.enabled then
                    __continue5 = true
                    break
                end
                enabledCount = enabledCount + 1
                local region = jass.CreateRegion()
                local rect = jass.Rect(cfg.left, cfg.bottom, cfg.right, cfg.top)
                if type(jass.RegionAddRect) == "function" then
                    jass.RegionAddRect(region, rect)
                end
                local trig = jass.CreateTrigger()
                if type(jass.TriggerRegisterEnterRegion) == "function" then
                    jass.TriggerRegisterEnterRegion(trig, region, nil)
                end
                if type(jass.TriggerAddAction) == "function" then
                    local fired = false
                    jass.TriggerAddAction(
                        trig,
                        function()
                            if fired then
                                return
                            end
                            fired = true
                            local ____temp_0
                            if type(jass.GetTriggerUnit) == "function" then
                                ____temp_0 = jass.GetTriggerUnit()
                            else
                                ____temp_0 = nil
                            end
                            local unit = ____temp_0
                            if not unit then
                                return
                            end
                            if rect and type(jass.RemoveRect) == "function" then
                                jass.RemoveRect(rect)
                            end
                            if cfg.UnitID and type(jass.SetUnitOwner) == "function" and type(jass.Player) == "function" then
                                local u = g[cfg.UnitID]
                                local p6 = jass.Player(6)
                                if u and p6 then
                                    jass.SetUnitOwner(u, p6, true)
                                end
                            end
                            if cfg.reveal and type(jass.CreateFogModifierRect) == "function" and type(jass.FogModifierStart) == "function" and type(jass.Player) == "function" then
                                local revealRect = g[cfg.reveal]
                                if revealRect then
                                    local mode = jass.FOG_OF_WAR_VISIBLE
                                    local fog = jass.CreateFogModifierRect(
                                        jass.Player(0),
                                        mode,
                                        revealRect,
                                        true,
                                        false
                                    )
                                    jass.FogModifierStart(fog)
                                end
                            end
                            if cfg.text and type(jass.DisplayTimedTextToPlayer) == "function" and type(jass.Player) == "function" then
                                do
                                    local i = 0
                                    while i < 12 do
                                        jass.DisplayTimedTextToPlayer(
                                            jass.Player(i),
                                            0,
                                            0,
                                            8,
                                            cfg.text
                                        )
                                        i = i + 1
                                    end
                                end
                            end
                            if type(jass.DestroyTrigger) == "function" then
                                jass.DestroyTrigger(trig)
                            end
                            if type(jass.RemoveRegion) == "function" then
                                jass.RemoveRegion(region)
                            end
                        end
                    )
                end
                __continue5 = true
            until true
            if not __continue5 then
                break
            end
        end
    end
end
--- 在地图初始化时调用（建议用 0.00 秒计时器）
____exports["init激活传送点"] = function(self)
    if type(jass.CreateTimer) == "function" and type(jass.TimerStart) == "function" then
        local t = jass.CreateTimer()
        jass.TimerStart(
            t,
            0,
            false,
            function()
                if type(jass.DestroyTimer) == "function" then
                    jass.DestroyTimer(t)
                end
                initActivationPointsInternal(nil)
            end
        )
    else
        initActivationPointsInternal(nil)
    end
end
return ____exports
