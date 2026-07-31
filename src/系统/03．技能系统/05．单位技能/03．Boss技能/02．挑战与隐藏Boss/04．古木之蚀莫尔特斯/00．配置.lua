--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["莫尔特斯单位技能配置"] = {
    ["单位ID"] = "N05W",
    ["单位名称"] = "古木之蚀·莫尔特斯",
    ["Boss单位ID"] = "N05W",
    ["技能壳"] = {
        ["腐朽根须穿刺"] = "AN00",
        ["腐败孢子云"] = "AN01",
        ["扭曲荆棘鞭笞"] = "AT12",
        ["腐败之种"] = "BT08",
        ["古木悲鸣"] = "AN02"
    },
    ["主动技能提示"] = {
        {["技能ID"] = "AN00", ["提示"] = "腐朽根须穿刺", ["扩展提示"] = "预警1.5秒后随机3个512码格子爆发；每格造成莫尔特斯当前攻击力×120%伤害并增加15点腐败值。（离开红色格子预警。）"},
        {["技能ID"] = "AN01", ["提示"] = "腐败孢子云", ["扩展提示"] = "连续生成3团孢子云，每团持续10秒、半径200码；每秒造成目标最大生命值×4%伤害并增加10点腐败值，云团每秒移动200码。（离开孢子云覆盖范围。）"},
        {["技能ID"] = "AT12", ["提示"] = "扭曲荆棘鞭笞", ["扩展提示"] = "连续3波扫击，每波预警1秒；每条矩形路径宽512、长1536码，命中造成莫尔特斯当前攻击力×100%伤害并增加8点腐败值，附加12秒荆棘寄生；寄生每3秒造成莫尔特斯施加时攻击力×20%伤害。（离开红色矩形路径。）"},
        {["技能ID"] = "BT08", ["提示"] = "腐败之种", ["扩展提示"] = "施法1秒后投掷种子，飞行1.2秒；落地后倒计时3秒成长为固定幼树，幼树持续18秒，半径360码内每1秒造成莫尔特斯当前攻击力×35%伤害并增加8点腐败值。（离开落点预警并远离幼树。）"},
        {["技能ID"] = "AN02", ["提示"] = "古木悲鸣", ["扩展提示"] = "读条4.034秒后从中心向四向发射弹幕；命中造成目标最大生命值×40%伤害并增加25点腐败值，命中后腐败值达到60点会恐惧3秒。（躲在蘑菇背向Boss的白色扇形安全区内。）"}
    },
    ["广播提示"] = {
        ["腐朽根须穿刺"] = "莫尔特斯施放腐朽根须穿刺：1.5秒后随机3个格子爆发，造成Boss攻击力120%伤害并增加15点腐败值。（离开红色格子预警。）",
        ["腐败孢子云"] = "莫尔特斯释放3团腐败孢子云，每团持续10秒；每秒造成目标最大生命4%伤害并增加10点腐败值。（离开孢子云覆盖范围。）",
        ["扭曲荆棘鞭笞"] = "莫尔特斯开始连续3波荆棘鞭笞，命中造成Boss攻击力100%伤害并增加8点腐败值，还会附加12秒荆棘寄生。（离开红色矩形路径。）",
        ["腐败之种"] = "莫尔特斯投掷腐败之种，落地3秒后成长为幼树并持续制造范围伤害和腐败值。（远离种子落点与幼树范围。）",
        ["古木悲鸣"] = "莫尔特斯即将释放四向古木悲鸣，命中造成目标最大生命40%伤害并增加25点腐败值。（躲到蘑菇背后的白色扇形安全区。）"
    },
    ["广播持续时间Ms"] = 4200,
    ["配音裁断距离"] = 4000,
    ["配音生成配置"] = {
        ["显示台词字段"] = "台词",
        ["配音台词字段"] = "配音台词",
        ["声线名称"] = "Elderbark - Rooted and Deep",
        ["声线ID"] = "2HmIg4yvRgcH2ZDgiwGz",
        ["模型ID"] = "eleven_v3",
        ["语言"] = "en",
        ["整体提示词"] = "An immense ancient guardian tree corrupted through its deepest roots. The voice is old, resonant, woody, and intelligent, carrying the pain of a forest that has rotted for centuries. In combat, grief hardens into territorial wrath, curses, and heavy commands. At defeat, the corruption recedes and the original weary guardian briefly returns with relief and remorse. Clear dark-fantasy combat diction; not a human narrator, not a mindless monster, and not a random creature vocal.",
        ["说明"] = "莫尔特斯使用 Elderbark 保留古树守护者的树龄、根系与沉重本体感。战斗阶段通过更低稳定度和腐化、痛苦、古木愤怒类分段标签表现黑暗侵蚀；死亡恢复守护者本色，转为痛苦解除与短暂清醒。Creature Vocal SFX 仍是独立拟声池，不替代可辨识 Voice 台词。"
    },
    ["台词"] = {
        ["开场"] = {"你们竟敢踏入我的根域……那就与这片受伤的森林一同腐烂吧。"},
        ["根系觉醒"] = {"大地还记得它承受的每一道伤痕。根系，苏醒吧！"},
        ["低血量"] = {"不……腐败仍在大地深处流淌。我还能汲取更多。"},
        ["死亡"] = {"终于……根须不再疼痛了……森林，请原谅我……"},
        ["腐朽根须穿刺"] = {"你们脚下，饥饿的根须正在寻找猎物。"},
        ["腐败孢子云"] = {"尽情呼吸吧……这是森林腐烂后的气息。"},
        ["扭曲荆棘鞭笞"] = {"荆棘，撕开这些闯入者！"},
        ["腐败之种"] = {"埋入大地吧……然后，替我生长。"},
        ["古木悲鸣"] = {"听见了吗？这是整片森林的痛苦！"}
    },
    ["配音台词"] = {
        ["开场"] = {"[ancient wrath] You dare enter the reach of my roots... [grave curse] Then rot with the wounded forest."},
        ["根系觉醒"] = {"[rising ancient fury] The earth remembers every wound it has endured. [commanding roar] Roots... awaken!"},
        ["低血量"] = {"[strained hunger] No... the rot still runs deep beneath the earth. [desperate menace] I can draw upon more."},
        ["死亡"] = {"[dying relief] At last... the roots no longer ache. [fading remorse] Forest... forgive me..."},
        ["腐朽根须穿刺"] = {"[low warning] Beneath your feet... the hungry roots are searching for prey."},
        ["腐败孢子云"] = {"[poisonous whisper] Breathe deeply... this is the scent of a forest left to rot."},
        ["扭曲荆棘鞭笞"] = {"[furious command] Thorns... tear the intruders apart!"},
        ["腐败之种"] = {"[dark nurturing] Sink into the soil... [corrupted command] and grow for me."},
        ["古木悲鸣"] = {"[ancient grief rising to wrath] Do you hear it? [soul-rending lament] The agony of an entire forest!"}
    },
    ["配音资源"] = {
        ["开场"] = {"Sound\\Boss\\Moltes\\Voice\\moltes_opening_roots_domain_elderbark_01_v3.mp3"},
        ["根系觉醒"] = {"Sound\\Boss\\Moltes\\Voice\\moltes_root_awaken_earth_remembers_elderbark_01_v3.mp3"},
        ["低血量"] = {"Sound\\Boss\\Moltes\\Voice\\moltes_low_health_draw_more_rot_elderbark_01_v3.mp3"},
        ["死亡"] = {"Sound\\Boss\\Moltes\\Voice\\moltes_defeat_roots_no_longer_ache_elderbark_01_v3.mp3"},
        ["腐朽根须穿刺"] = {"Sound\\Boss\\Moltes\\Voice\\moltes_rotten_roots_hungry_beneath_elderbark_01_v3.mp3"},
        ["腐败孢子云"] = {"Sound\\Boss\\Moltes\\Voice\\moltes_spore_cloud_breathe_rot_elderbark_01_v3.mp3"},
        ["扭曲荆棘鞭笞"] = {"Sound\\Boss\\Moltes\\Voice\\moltes_thorn_lash_intruders_elderbark_01_v3.mp3"},
        ["腐败之种"] = {"Sound\\Boss\\Moltes\\Voice\\moltes_corruption_seed_grow_for_me_elderbark_01_v3.mp3"},
        ["古木悲鸣"] = {"Sound\\Boss\\Moltes\\Voice\\moltes_ancient_lament_forest_agony_elderbark_01_v3.mp3"}
    }
}
return ____exports
