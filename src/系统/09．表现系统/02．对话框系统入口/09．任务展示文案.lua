--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
function ____exports.resolveRewardDisplayText(self, quest)
    if not quest then
        return "无"
    end
    if quest.rewardDisplay and quest.rewardDisplay ~= "" then
        return quest.rewardDisplay
    end
    local ____type = quest.type or ""
    local reward = quest.reward or ""
    if ____type == "给予" and (string.find(reward, ":", nil, true) or 0) - 1 >= 0 then
        return "给予未知奖励"
    end
    return reward ~= "" and reward or "无"
end
return ____exports
