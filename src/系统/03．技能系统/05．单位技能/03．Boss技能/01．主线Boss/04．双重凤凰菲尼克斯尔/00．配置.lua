--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["菲尼克斯尔单位技能配置"] = {
    ["单位ID"] = "N00U",
    ["单位名称"] = "双重凤凰·菲尼克斯尔",
    ["第一形态名称"] = "熔岩炽凰·菲尼克斯尔",
    ["第二形态名称"] = "骸骨烈焰凤凰·菲尼克斯尔",
    ["Boss单位ID"] = "N00U",
    ["技能壳"] = {["炽羽散射"] = "A0F8", ["熔岩吐息"] = "A0F7", ["凤凰漩涡"] = "A0F9"},
    ["主动技能提示"] = {{["技能ID"] = "A0F8", ["提示"] = "炽羽散射", ["扩展提示"] = "读条0.7秒，14枚羽毛锁定目标周围80~520码落点，落点半径150；飞行0.75秒后造成当前攻击力×95%+目标最大生命值2%，并生成半径180、持续5秒燃烧区，每秒造成目标最大生命值0.8%。（离开落点和燃烧区。）"}, {["技能ID"] = "A0F7", ["提示"] = "熔岩吐息", ["扩展提示"] = "预警0.45秒后持续2.5秒，正面70°、半径720扇形每0.25秒结算一次；每次为（当前攻击力×45%+目标最大生命值1.2%）×50%，累计命中3次后减速25%持续2秒。（离开正面扇形。）"}, {["技能ID"] = "A0F9", ["提示"] = "凤凰漩涡", ["扩展提示"] = "锁定目标当前位置预警2秒，生成半径420漩涡持续4秒；每0.5秒造成当前攻击力×35%+目标已损失生命值4%，并向中心牵引36码，中心140码内不再牵引。（离开锁定圆圈，别停留在漩涡内。）"}},
    ["机制单位ID"] = {["永恒冰核"] = "N0P0", ["能量导管"] = "N0P1", ["怨火核心"] = "N0P2", ["凤凰之卵"] = "N0P3"},
    ["广播持续时间Ms"] = 4200,
    ["配音裁断距离"] = 4000,
    ["配音生成配置"] = {
        ["显示台词字段"] = "台词",
        ["配音台词字段"] = "配音台词",
        ["声线名称"] = "Elariel X - Epic Queen Ethereal",
        ["声线ID"] = "ksryVoNAGZT8GxWCTiVm",
        ["模型ID"] = "eleven_v3",
        ["语言"] = "en",
        ["整体提示词"] = "An ancient dual-form phoenix queen, first radiant with molten majesty beneath an eternal ice seal, then reborn as a hollow skeletal flame spirit. Ethereal feminine authority, avian resonance, controlled combat pace, and clear fantasy RPG delivery. Keep P1 regal and smoldering; make P2 hollow, vengeful, and deathless. Not human screaming, not a witch narrator, not a dragon growl.",
        ["说明"] = "菲尼克斯尔两种形态共用 Elariel X。第一形态强调高贵神性、熔火与戏谑；第二形态通过分段提示词转为空洞、怨怒、骸骨烈焰与轮回执念。避免人类尖叫、温和旁白和巨龙咆哮感。"
    },
    BuffID = {
        ["凤凰火印"] = "BPH1",
        ["冷焰印记"] = "BPH2",
        ["毒火蚀痕"] = "BPH3",
        ["怨火烙印"] = "BPH4",
        ["导管破封"] = "BPH5",
        ["怨火链接"] = "BPH6",
        ["永恒轮回"] = "BPH7"
    },
    ["模型"] = {
        ["第一形态"] = "Boss\\Phoenixel\\HolyPhoenix.mdx",
        ["第二形态"] = "Boss\\Phoenixel\\UndyingPhoenix.mdx",
        ["永恒冰核"] = "Common\\Effect\\Element\\Ice\\Ice_egg.mdx",
        ["能量导管"] = "Common\\Effect\\Element\\Ice\\FrozenMana.mdx",
        ["怨火核心"] = "Common\\Effect\\Element\\Fire\\Burning Core.mdx",
        ["凤凰之卵"] = "Boss\\Phoenixel\\HolyPhoenix.mdx"
    },
    ["台词"] = {
        ["开场"] = {"两枚火种，一具骨翼。你们要先熄灭哪一边？（先处理4根能量导管，全部摧毁后才会转阶段。）"},
        ["转第二形态"] = {"血肉烧尽，余烬仍会飞翔。（第一形态结束，骸骨弹幕与怨火机制开始，观察新预警。）"},
        ["死亡"] = {"轮回...也会有尽头吗...（凤凰之卵全部摧毁，轮回无法重生。）"},
        ["炽羽散射"] = {"羽火散开，别让它们找到你的影子。（读条0.7秒后出现半径150落点，随后避开燃烧区。）"},
        ["熔岩吐息"] = {"熔岩会记住你逃跑的方向。（0.45秒预警后喷吐正面70°、半径720扇形，立即离开。）"},
        ["凤凰漩涡"] = {"风会把火带回中心。（2秒后固定位置生成半径420漩涡，持续4秒并牵引，离开预警圈。）"},
        ["导管摧毁"] = {"锁链断裂，封印正在反噬你们。（每根已摧毁导管使Boss承伤提高8%、技能强度提高6%。）"},
        ["浴火重生准备"] = {"灰烬只是下一次振翼。（4根导管全部摧毁后进入5秒转场，准备第二形态。）"},
        ["骸骨弹幕"] = {"骨火无眼，但会追逐生命。（读条1秒后连续3波、每波14枚，波间0.8秒，沿预警空隙移动。）"},
        ["怨火链接"] = {"怨火相连，断开它。（链接持续8秒、宽90码；不要穿过连线，也不要把两端拉开超过850码。）"},
        ["凤凰挽歌"] = {"听吧，这是轮回前的哀鸣。（引导6秒，每秒损失当前生命10%；进入半径260安全圆规避本跳。）"},
        ["元素爆发"] = {"你们身上的印记，正在回应我。（3秒后按最高元素层数结算，先查看自己身上的最高层印记。）"},
        ["怨火核心暴露"] = {"核心已裂，来证明你们的锋刃。（核心只暴露8秒，最大生命为Boss最大生命10%，优先集火。）"},
        ["永恒轮回"] = {"摧毁那些卵，否则我将再次归来。（Boss生命≤5%进入15秒轮回，4枚凤凰蛋必须全部摧毁。）"}
    },
    ["配音台词"] = {
        ["开场"] = {"[smoldering amusement] Two embers. One frame of bone. [taunting] Which flame will you try to extinguish first?"},
        ["转第二形态"] = {"[in searing agony] Let the flesh burn away... [reborn in fury] the fire still remembers how to fly."},
        ["死亡"] = {"[shaken, weakening] Can even the cycle... [fading disbelief] truly come to an end...?"},
        ["炽羽散射"] = {"[fierce warning] The burning feathers are loose! [predatory threat] Do not let them catch even your shadow."},
        ["熔岩吐息"] = {"[severe warning] Run if you wish. [smoldering menace] The lava will remember exactly where you fled."},
        ["凤凰漩涡"] = {"[drawing power inward] The wind draws every flame back to its heart."},
        ["导管摧毁"] = {"[raging through pain] Another chain breaks... [vengeful warning] and now the seal turns its fury upon you!"},
        ["浴火重生准备"] = {"[smoldering rebirth] Ash is merely the pause before my wings beat again."},
        ["骸骨弹幕"] = {"[hollow menace] Bonefire has no eyes... [predatory] but it knows how to hunt the living."},
        ["怨火链接"] = {"[cold warning] Vengeful flame binds you. [cruel menace] Sever it... and pay the price."},
        ["凤凰挽歌"] = {"[funereal resonance] Listen. This is the lament sung before the cycle begins anew."},
        ["元素爆发"] = {"[commanding] The marks upon you... [rising power] answer to me."},
        ["怨火核心暴露"] = {"[defiant challenge] My core lies open. Come... prove your blades can reach it."},
        ["永恒轮回"] = {"[deathless warning] Shatter every egg! [rising wrath] Leave even one... and I will rise again!"}
    },
    ["配音资源"] = {
        ["开场"] = {"Sound\\Boss\\Phoenixel\\Voice\\phoenixel_opening_two_embers_elariel_x_01_v3.mp3"},
        ["转第二形态"] = {"Sound\\Boss\\Phoenixel\\Voice\\phoenixel_phase2_flesh_burns_rebirth_elariel_x_01_v3.mp3"},
        ["死亡"] = {"Sound\\Boss\\Phoenixel\\Voice\\phoenixel_death_cycle_ends_elariel_x_01_v3.mp3"},
        ["炽羽散射"] = {"Sound\\Boss\\Phoenixel\\Voice\\phoenixel_burning_feathers_scatter_elariel_x_02_heavy_warning_v3.mp3"},
        ["熔岩吐息"] = {"Sound\\Boss\\Phoenixel\\Voice\\phoenixel_lava_breath_remembers_elariel_x_02_heavy_warning_v3.mp3"},
        ["凤凰漩涡"] = {"Sound\\Boss\\Phoenixel\\Voice\\phoenixel_vortex_flames_return_elariel_x_01_v3.mp3"},
        ["导管摧毁"] = {"Sound\\Boss\\Phoenixel\\Voice\\phoenixel_conduit_chain_breaks_elariel_x_02_heavy_warning_v3.mp3"},
        ["浴火重生准备"] = {"Sound\\Boss\\Phoenixel\\Voice\\phoenixel_rebirth_ash_wings_elariel_x_01_v3.mp3"},
        ["骸骨弹幕"] = {"Sound\\Boss\\Phoenixel\\Voice\\phoenixel_bonefire_barrage_elariel_x_01_v3.mp3"},
        ["怨火链接"] = {"Sound\\Boss\\Phoenixel\\Voice\\phoenixel_vengeful_flame_link_elariel_x_02_heavy_warning_v3.mp3"},
        ["凤凰挽歌"] = {"Sound\\Boss\\Phoenixel\\Voice\\phoenixel_lament_cycle_begins_elariel_x_01_v3.mp3"},
        ["元素爆发"] = {"Sound\\Boss\\Phoenixel\\Voice\\phoenixel_element_marks_answer_elariel_x_01_v3.mp3"},
        ["怨火核心暴露"] = {"Sound\\Boss\\Phoenixel\\Voice\\phoenixel_wrath_core_exposed_elariel_x_01_v3.mp3"},
        ["永恒轮回"] = {"Sound\\Boss\\Phoenixel\\Voice\\phoenixel_eternal_cycle_eggs_rebirth_elariel_x_02_heavy_warning_v3.mp3"}
    }
}
return ____exports
