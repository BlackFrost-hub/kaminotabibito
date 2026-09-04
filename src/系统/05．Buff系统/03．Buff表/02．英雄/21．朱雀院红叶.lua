--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 朱雀院红叶 - 英雄 Buff 表（B1 登记）
-- 图标：尚未完成专用 BLP 迁移，icon 使用已迁入的技能图标占位，不得写 PNG 路径（执行规则 5）。
-- 刀势/水镜/秘传的层数与窗口由红叶私有状态容器精确管理；Buff 只负责玩家识别与状态查询。
____exports["朱雀院红叶BuffID"] = {["破绽"] = "E013", ["刀势"] = "E014", ["水镜招架"] = "E015", ["秘传三式"] = "E016"}
____exports["朱雀院红叶Buff表"] = {[____exports["朱雀院红叶BuffID"]["破绽"]] = {
    buffID = ____exports["朱雀院红叶BuffID"]["破绽"],
    buffName = "破绽",
    icon = "ReplaceableTextures\\CommandButtons\\HeroBuff\\Momiji\\BTNMomijiPoDan.blp",
    effect = "Common\\Effect\\Form\\Marker\\MomijiWeakPointBlade3D.mdx",
    effectMode = "attach",
    effectAttachPoint = "origin",
    effectScale = 1,
    type = "Debuff:physical:skill",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 60,
    canPurge = true,
    tooltip = "破绽 4 秒：普攻命中触发破绽斩（额外物理伤害），触发后破绽消失。"
}, [____exports["朱雀院红叶BuffID"]["刀势"]] = {
    buffID = ____exports["朱雀院红叶BuffID"]["刀势"],
    buffName = "刀势",
    icon = "ReplaceableTextures\\CommandButtons\\HeroBuff\\Momiji\\BTNMomijiDaoShi.blp",
    effect = "",
    effectMode = "attach",
    effectAttachPoint = "origin",
    effectScale = 1,
    type = "Buff:physical:skill",
    interval = 0,
    maxStack = 3,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 70,
    canPurge = false,
    tooltip = "最多 3 层，可强化 Q/W/E/R。"
}, [____exports["朱雀院红叶BuffID"]["水镜招架"]] = {
    buffID = ____exports["朱雀院红叶BuffID"]["水镜招架"],
    buffName = "水镜招架",
    icon = "ReplaceableTextures\\CommandButtons\\HeroBuff\\Momiji\\BTNMomijiShuiJing.blp",
    effect = "",
    effectMode = "attach",
    effectAttachPoint = "origin",
    effectScale = 1,
    type = "Buff:physical:control",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = false,
    dispelLevel = 3,
    priority = 75,
    canPurge = false,
    tooltip = "水镜招架中：正面 90 度、0.6 秒窗口；成功招架立即反击（攻击力100%）。"
}, [____exports["朱雀院红叶BuffID"]["秘传三式"]] = {
    buffID = ____exports["朱雀院红叶BuffID"]["秘传三式"],
    buffName = "秘传三式",
    icon = "ReplaceableTextures\\CommandButtons\\HeroBuff\\Momiji\\BTNMomijiMiChuan.blp",
    effect = "",
    effectMode = "attach",
    effectAttachPoint = "origin",
    effectScale = 1,
    type = "Buff:physical:skill",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 80,
    canPurge = false,
    tooltip = "秘传三式 8 秒：最多 3 次强化，强化 Q/W/E/R；用完或超时结束。"
}}
return ____exports
