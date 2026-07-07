--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____Boss_6B7B_4EA1_97F3_6548_914D_7F6E_8868 = {{["单位ID"] = "N057", ["音效路径"] = "Sound\\Boss\\Thranduil\\SFX\\thranduil_defeat_dissolve_01.mp3", ["裁断距离"] = 2800}, {["单位ID"] = "N00V", ["音效路径"] = "Sound\\Boss\\Mia\\SFX\\mia_defeat_corruption_fades_01_80k.mp3", ["裁断距离"] = 2800}, {["单位ID"] = "N03G", ["音效路径"] = "Sound\\Boss\\Balzaroth\\SFX\\balzaroth_defeat_molten_core_fades_04.mp3", ["裁断距离"] = 2800, ["延迟音效列表"] = {{["音效路径"] = "Sound\\Boss\\Balzaroth\\SFX\\balzaroth_defeat_embers_settle_01.mp3", ["延迟Ms"] = 1900}}}}
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("lib.扩展函数.封装函数.02．音效系统.index")
local Sound3DII_CooPlay = ____require_result_1.Sound3DII_CooPlay
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local function _____67E5_627EBoss_6B7B_4EA1_97F3_6548_914D_7F6E(bossUnit)
    if bossUnit == nil or bossUnit == 0 then
        return nil
    end
    local unitTypeId = GetUnitTypeId(bossUnit)
    do
        local i = 0
        while i < #____Boss_6B7B_4EA1_97F3_6548_914D_7F6E_8868 do
            local config = ____Boss_6B7B_4EA1_97F3_6548_914D_7F6E_8868[i + 1]
            if stringToFourCCSafe(config["单位ID"]) == unitTypeId then
                return config
            end
            i = i + 1
        end
    end
    return nil
end
____exports["尝试播放Boss死亡音效"] = function(bossUnit)
    local config = _____67E5_627EBoss_6B7B_4EA1_97F3_6548_914D_7F6E(bossUnit)
    if config == nil then
        return
    end
    local x = GetUnitX(bossUnit)
    local y = GetUnitY(bossUnit)
    Sound3DII_CooPlay(
        config["音效路径"],
        x,
        y,
        0,
        config["裁断距离"]
    )
    local list = config["延迟音效列表"]
    if list == nil then
        return
    end
    do
        local i = 0
        while i < #list do
            local item = list[i + 1]
            addDelayedCallback(
                item["延迟Ms"],
                function()
                    Sound3DII_CooPlay(
                        item["音效路径"],
                        x,
                        y,
                        0,
                        config["裁断距离"]
                    )
                end
            )
            i = i + 1
        end
    end
end
return ____exports
