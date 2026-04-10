--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5355_4F4D_76F8_5173 = require("lib.扩展函数.自定义扩展函数.00．单位相关")
local createUnitWithOptions = ____00_FF0E_5355_4F4D_76F8_5173.createUnitWithOptions
local jass = require("jass.common")
____exports.MAIN_STORY_NPCS = {}
local function createNeutralPassive(self, unitId, x, y, facingDeg)
    local facingRad = facingDeg * math.pi / 180
    return createUnitWithOptions(
        nil,
        15,
        unitId,
        x,
        y,
        facingRad
    )
end
--- 对应 JASS: Trig_____________NPC4_0SActions
-- 创建主线剧情涉及的 NPC 并写入运行时映射表。
function ____exports.createMainStoryNPCs(self)
    ____exports.MAIN_STORY_NPCS["自然守护者"] = createNeutralPassive(
        nil,
        "etrp",
        -29053.5,
        -28338,
        200
    )
    ____exports.MAIN_STORY_NPCS["八云紫"] = createNeutralPassive(
        nil,
        "E00O",
        26486.9,
        -28470.7,
        270
    )
    ____exports.MAIN_STORY_NPCS["精灵村长老"] = createNeutralPassive(
        nil,
        "edot",
        28773.9,
        -28943.7,
        0
    )
    ____exports.MAIN_STORY_NPCS["沙漠营地领主"] = createNeutralPassive(
        nil,
        "n01L",
        -18080.6,
        -24550.7,
        290
    )
    ____exports.MAIN_STORY_NPCS["熔岩小镇镇长"] = createNeutralPassive(
        nil,
        "ndrp",
        8668.3,
        -20334,
        270
    )
    ____exports.MAIN_STORY_NPCS["恶魔城领主"] = createNeutralPassive(
        nil,
        "n03V",
        14861.74,
        -15980.4,
        270
    )
    ____exports.MAIN_STORY_NPCS["沙漠年长者"] = createNeutralPassive(
        nil,
        "n05I",
        -3945.7,
        -24963.1,
        235
    )
    ____exports.MAIN_STORY_NPCS["沙漠年轻佣兵"] = createNeutralPassive(
        nil,
        "h008",
        -4550.4,
        -23952.4,
        80
    )
    ____exports.MAIN_STORY_NPCS["沙漠情报商人"] = createNeutralPassive(
        nil,
        "n02G",
        -7139.3,
        -26096.7,
        270
    )
    ____exports.MAIN_STORY_NPCS["蛇人族藏品管家"] = createNeutralPassive(
        nil,
        "h01J",
        -20448.3,
        2966.3,
        180
    )
    ____exports.MAIN_STORY_NPCS["阿尔文"] = createNeutralPassive(
        nil,
        "n04O",
        -21062.4,
        -14229.1,
        200
    )
    ____exports.MAIN_STORY_NPCS["jl禁军门卫"] = createNeutralPassive(
        nil,
        "h01M",
        15632.6,
        -25873,
        0
    )
    ____exports.MAIN_STORY_NPCS["jl禁军门卫2"] = createNeutralPassive(
        nil,
        "h01M",
        16207.5,
        -24926,
        180
    )
    ____exports.MAIN_STORY_NPCS["克林姆德王"] = createNeutralPassive(
        nil,
        "h01N",
        19063.9,
        -24612.7,
        180
    )
    _G.__MAIN_STORY_NPCS__ = ____exports.MAIN_STORY_NPCS
    return ____exports.MAIN_STORY_NPCS
end
--- 等价于 JASS 的 TriggerRegisterTimerEventSingle(..., 1.00)
function ____exports.initMainStoryNPCsWithDelay(self, delaySec)
    if delaySec == nil then
        delaySec = 1
    end
    if type(jass.CreateTimer) ~= "function" or type(jass.TimerStart) ~= "function" then
        ____exports.createMainStoryNPCs(nil)
        return
    end
    local timer = jass.CreateTimer()
    jass.TimerStart(
        timer,
        delaySec,
        false,
        function()
            ____exports.createMainStoryNPCs(nil)
            if type(jass.DestroyTimer) == "function" then
                jass.DestroyTimer(timer)
            end
        end
    )
end
____exports.default = {createMainStoryNPCs = ____exports.createMainStoryNPCs, initMainStoryNPCsWithDelay = ____exports.initMainStoryNPCsWithDelay}
return ____exports
