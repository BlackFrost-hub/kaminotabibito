--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["英雄选择配置表"] = {
    ["可选玩家ID列表"] = {
        0,
        1,
        2,
        3,
        4,
        5
    },
    ["双击确认窗口秒数"] = 1,
    ["单击介绍显示秒数"] = 20,
    ["选择系统关闭秒数"] = 180,
    ["选择区域全局名"] = "gg_rct___________________YXXZ",
    ["英雄出生区域全局名"] = "gg_rct______________071",
    ["英雄已选择标记键"] = "是否已选择英雄",
    ["英雄点击次数键"] = "点击次数",
    ["玩家英雄单位组表名"] = "玩家英雄",
    ["玩家英雄单位组键"] = "单位组",
    ["记录已选英雄表名"] = "XZYX",
    ["记录已选英雄键"] = "YX",
    ["记录玩家BB键"] = "BB",
    ["玩家英雄名写入字符串数组偏移"] = 5,
    ["英雄确认公告前缀"] = "|cffffff00『系统消息』：|r",
    ["选择系统关闭提示文本"] = "|cffffff00『系统提示』：|r|cff999999英雄选择系统关闭了|r",
    ["选择确认后直接执行触发名"] = "gg_trg__u",
    ["英雄禁用技能名"] = "选择英雄占位技能",
    ["BB单位名"] = "BB",
    ["英雄单击介绍表"] = {
        ["死神"] = "|cffffff80成长型战士英雄，解放后可以在较长时间内极速奔跑，|r\n|cffff9900力量：20（+2.65）|r\n|cff00ff00敏捷：30（+4.0）|r\n|cff00ccff智力：20（+0.85）|r\n|cffffffcc主要输出伤害：|r|cff993300物理|r\n|cffffffcc主要输出方式：|r|cffcc99ff技能80%+|r|cffff6600普攻20%|r\n|cffffffcc多人Boss战定位：|r|cffff0000输出，控制|r\n|cffff9900随游戏推进强度指数：|r|cffffcc995-6-6-7|r\n|cffff99cc推荐寻找装备属性：|r攻击力，暴击，物伤增幅\n|cffff00ff优点：无|r|cffff0000\n|r|cffff00ff缺点：无|r",
        cloud = "|cffffff80团队控制能力极强的战士型英雄，每次出招会将敌人打入长时间硬直，但比其他力量型英雄耐力（MP）消耗更大|r\n|cffff9900力量：20（+4.0）|r\n|cff00ff00敏捷：20（+2.0）|r\n|cff00ccff智力：20（+1.0）|r\n|cffffffcc主要输出伤害：|r|cff993300物理|r\n|cffffffcc主要输出方式：|r|cffcc99ff技能75%，|r|cffff6800普攻25%|r\n|cffffffcc多人Boss战定位：|r|cffff0000前排＞控制＞输出|r\n|cffff9900随游戏推进强度指数：|r|cffffcc996→6→6→6|r\n|cffff99cc推荐寻找装备属性：|r魔法恢复，力量，暴击\n|cffff00ff优点：|r|cffff0000控制多，暴击特性|r\n|cffff00ff缺点：|r|cffff0000缺蓝，长硬直招式|r",
        ["馒头卡"] = "|cffffff80智力型英雄，兼具远程输出和辅助的少女，在伙伴的帮助下可以处于较为安全的位置，但单独行动时就反而显得捉襟见肘|r\n|cffff9900力量：20（+1.8）|r\n|cff00ff00敏捷：20（+1.5）|r\n|cff00ccff智力：15（+3.7）|r\n|cffffffcc主要输出伤害：|r|cff99ccff魔法|r\n|cffffffcc主要输出方式：|r|cffcc99ff技能65%，|r|cffff6800普攻35%|r\n|cffffffcc多人Boss战定位：|r|cffff0000远程输出或辅助|r\n|cffff9900随游戏推进强度指数：|r|cffffcc994-5-7-8|r\n|cffff99cc推荐寻找装备属性：|r任意\n|cffff00ff优点：|r|cffff0000较为全面，输出位置非常安全|r\n|cffff00ff缺点：|r|cffff0000出招硬直太长，蓝耗较高，非常依靠队友|r",
        ["女仆"] = "|cffffff80能够控制时间的敏捷型技能英雄，控制时间是无视免控的，也可以使用特殊技能一瞬间对敌人造成极高伤害，但时停只有自己能不被影响|r\n|cffff9900力量：20（+1.75）|r\n|cff00ff00敏捷：30（+4.0）|r\n|cff00ccff智力：20（+1.25）|r\n|cffffffcc主要输出伤害：|r|cff993300物理|r\n|cffffffcc主要输出方式：|r|cffcc99ff技能90%↑|r\n|cffffffcc多人Boss战定位：|r|cffff0000远程输出＞辅助|r\n|cffff9900随游戏推进强度指数：|r|cffffcc995-7-6-6|r\n|cffff99cc推荐寻找装备属性：|r攻击力，护甲穿透，物伤增幅\n|cffff00ff优点：时停|r|cffff0000|r\n|cffff00ff缺点：会时停到队友，爆发总体较慢|r",
        ["阿劳伦特"] = "|cffffff80较为全面，能够操作光暗二种属性的力量型战士英雄，能治愈已方的同时伤害敌人，可以吸收光暗之力造成一瞬间的可观伤害，但后续伤害不足|r\n|cffff9900力量：20（+3.0）|r\n|cff00ff00敏捷：30（+2.0）|r\n|cff00ccff智力：20（+2.0）|r\n|cffffffcc主要输出伤害：|r|cffcc99ff光暗魔法|r\n|cffffffcc主要输出方式：|r|cffcc99ff技能85%，|r|cffff6800普攻15%|r\n|cffffffcc多人Boss战定位：|r|cffff0000前排，辅助，输出|r\n|cffff9900随游戏推进强度指数：|r|cffffcc997-7-5-5|r\n|cffff99cc推荐寻找装备属性：|r攻击力或生命属性相关，冷却缩减\n|cffff00ff优点：较为全能\n缺点：后续伤害不可观|r",
        ["无名武士"] = "|cffffff80出招极快变幻莫测的刺客型英雄，一瞬间招架敌人的招式进行反击，但是自身硬度不够，需要找准战场时机和依靠自身反应速度来规避伤害|r\n|cffff9900力量：15（+1.2）|r\n|cff00ff00敏捷：30（+4.5）|r\n|cff00ccff智力：15（+1.3）|r\n|cffffffcc主要输出伤害：|r|cff993300物理|r\n|cffffffcc主要输出方式：|r|cffcc99ff技能70%，|r|cffff6800普攻30%|r\n|cffffffcc多人Boss战定位：|r|cffff0000输出＞骚扰打断|r\n|cffff9900随游戏推进强度指数：|r|cffffcc996→6→6→6|r\n|cffff99cc推荐寻找装备属性：|r攻击，暴击，冷却缩减\n|cffff00ff优点：|r|cffff0000出招收招神速，耐力消耗极低|r\n|cffff00ff缺点：|r|cffff0000作为近战输出，身板和伙伴比相对较弱|r",
        ["亚瑟王"] = "|cffffff80身先士卒进入战场的冲锋型敏捷战士英雄。能消耗自身大量魔力后消灭眼前的敌人，并且拥有一个强力恢复宝具，但是没有宝具时战斗力相对较弱|r\n|cffff9900力量：20（+2.4）|r\n|cff00ff00敏捷：25（+3.8）|r\n|cff00ccff智力：20（+1.3）|r\n|cffffffcc主要输出伤害：|r|cff993300物理|r|cffffffcc，|r|cff99ccff魔法|r\n|cffffffcc主要输出方式：|r|cffcc99ff技能60%|r+|cffff0000普攻40%|r\n|cffffffcc多人Boss战定位：|r|cffff0000半前排，输出|r\n|cffff9900随游戏推进强度指数：|r|cffffcc995-5-7-8|r\n|cffff99cc推荐寻找装备属性：|r攻击力，冷却缩减\n|cffff00ff优点：拥有强力宝具\n缺点：无宝具时较弱|r",
        ["恩赐解脱"] = "|cffffff80出招暴力，狂硬踹飞眼中一切看不爽之事物的力量型英雄。同时享受攻击力和力量加成，但是作为力量英雄控制效果一般|r\n|cffff9900力量：20（+4.3）|r\n|cff00ff00敏捷：20（+1.7）|r\n|cff00ccff智力：20（+1.0）|r\n|cffffffcc主要输出伤害：|r|cff993300物理/|r|cffff6600强化|r\n|cffffffcc主要输出方式：|r|cffcc99ff技能90%↑|r\n|cffffffcc多人Boss战定位：|r|cffff0000前排＞输出＞辅助＞控制|r\n|cffff9900随游戏推进强度指数：|r|cffffcc998-7-6-5\n|cffff99cc推荐寻找装备属性：|r攻击力，力量，冷却缩减\n|cffff00ff优点：|r|cffff0000输出暴力，相对不缺蓝|r\n|cffff00ff缺点：|r|cffff0000控制效果一般|r",
        U2 = "|cffffff80攻防一体的力量型战法师，能够召唤自身本位面的神来协助自己战斗，由于刚降临这个位面被影响，目前暂时无法召唤|r\n|cffff9900力量：20（+4.3）|r\n|cff00ff00敏捷：30（+1.7）|r\n|cff00ccff智力：20（+1.0）|r\n|cffffffcc主要输出伤害：|r|cff993366黑暗魔法|r\n|cffffffcc主要输出方式：|r|cffcc99ff技能90%，|r|cffff6800普攻10%|r\n|cffffffcc多人Boss战定位：|r|cffff0000远程输出＞辅助|r\n|cffff9900随游戏推进强度指数：|r|cffffcc995-6-7-7|r\n|cffff99cc推荐寻找装备属性：|r攻击力，魔法伤害增幅，暗魔法增幅，冷却缩减\n|cffff00ff优点：|r|cffff0000攻防一体，拥有神协助|r\n|cffff00ff缺点：|r|cffff0000适应此位面才可以召唤神（属性需求）|r",
        LV6 = "|cffffff80操作矢量的智力英雄，能够反射敌人的攻击，拥有超高的机动速度，每次升级都能成长，但魔法消耗极高|r\n|cffff9900力量：20（+1）|r\n|cff00ff00敏捷：20（+1.5）|r\n|cff00ccff智力：25（+5.0）|r\n|cffffffcc主要输出伤害：|r|cff99ccff魔法|r\n|cffffffcc主要输出方式：|r|cffcc99ff技能90%↑|r\n|cffffffcc多人Boss战定位：|r|cffff0000机动输出|r\n|cffff9900随游戏推进强度指数：|r|cffffcc993-5-7-9|r\n|cffff99cc推荐寻找装备属性：|r蓝耗减少，魔法恢复，智力\n|cffff00ff优点：|r|cffff0000能够反射敌人攻击|r\n|cffff00ff缺点：|r|cffff0000蓝耗极高|r",
        ["月兔"] = "|cffffff80远程普攻型输出英雄，可以短暂干扰敌人对自己的认知|r\n|cffff9900力量：15（+0.5）|r\n|cff00ff00敏捷：25（+4.5）|r\n|cff00ccff智力：25（+1.5）|r\n|cffffffcc主要输出伤害：|r|cff99ccff魔法/|r|cff993300物理|r\n|cffffffcc主要输出方式：|r|cffff6600普攻75%，|r|cff993366技能25%|r\n|cffffffcc多人Boss战定位：|r|cffff0000远程输出|r\n|cffff9900随游戏推进强度指数：|r|cffffcc994-6-7-8|r\n|cffff99cc推荐寻找装备属性：|r攻击力，暴击，攻速\n|cffff00ff优点：|r|cffff0000干扰敌人|r\n|cffff00ff缺点：|r|cffff0000辅助和控制手段匮乏，身体强度与同伴对比最低之一|r",
        ["永远17岁的少女"] = "|cffffff80操作间隙玩弄敌人的法师型智力英雄，成长略高。|r\n|cffff9900力量：15（+1.50）|r\n|cff00ff00敏捷：25（+1.50）|r\n|cff00ccff智力：25（+4.50）|r\n|cffffffcc主要输出伤害：|r|cff99ccff魔法|r\n|cffffffcc主要输出方式：|r|cffcc99ff技能90%↑|r\n|cffffffcc多人Boss战定位：|r|cffff0000远程输出/控制|r\n|cffff9900随游戏推进强度指数：|r|cffffcc995-6-7-8|r\n|cffff99cc推荐寻找装备属性：|r攻击力，魔法增幅，蓝耗减少，冷却缩减\n|cffff00ff优点：|r|cffff0000作为智力机动性较高|r\n|cffff00ff缺点：|r|cffff0000只能升到17级（注意，因此单人游玩时无法通关）|r",
        ["|cffff0000炎|r|cffff7f7f杀|r姬"] = "|cffffff80横冲直撞的力量型冲锋英雄，恢复能力较高|r\n|cffff9900力量：30（+3.8）|r\n|cff00ff00敏捷：20（+2）|r\n|cff00ccff智力：20（+1.2）|r\n|cffffffcc主要输出伤害：|r|cffff6600火焰魔法|r\n|cffffffcc主要输出方式：|r|cffcc99ff技能90%↑|r\n|cffffffcc多人Boss战定位：|r|cffff0000控场，前排，辅助，输出|r\n|cffff9900随游戏推进强度指数：|r|cffffcc996-6-6-6|r\n|cffff99cc推荐寻找装备属性：|r力量，魔法伤害增幅，火魔法增幅，生命恢复增幅\n|cffff00ff优点：|r|cffff0000生命恢复略高|r\n|cffff00ff缺点：|r|cffff0000释放技能消耗自身生命|r"
    },
    ["必须保留的旧单位事件注册项"] = {
        {["目标单位"] = "英雄", ["旧触发名"] = "gg_trg_DMboss______01______TS___u", ["事件名"] = "EVENT_UNIT_PICKUP_ITEM"},
        {["目标单位"] = "BB", ["旧触发名"] = "gg_trg____________________________ZH", ["事件名"] = "EVENT_UNIT_SPELL_EFFECT"},
        {["目标单位"] = "英雄", ["旧触发名"] = "gg_trg____________________________ZH", ["事件名"] = "EVENT_UNIT_SPELL_EFFECT"},
        {["目标单位"] = "英雄", ["旧触发名"] = "gg_trg_______Boss______JQ00", ["事件名"] = "EVENT_UNIT_SPELL_EFFECT"},
        {["目标单位"] = "英雄", ["旧触发名"] = "gg_trg_______Boss______QD01", ["事件名"] = "EVENT_UNIT_SPELL_EFFECT"},
        {["目标单位"] = "英雄", ["旧触发名"] = "gg_trg_111________________u", ["事件名"] = "EVENT_UNIT_SPELL_EFFECT"},
        {["目标单位"] = "BB", ["旧触发名"] = "gg_trg___________________HC", ["事件名"] = "EVENT_UNIT_PICKUP_ITEM"},
        {["目标单位"] = "英雄", ["旧触发名"] = "gg_trg___________________HC", ["事件名"] = "EVENT_UNIT_PICKUP_ITEM"},
        {["目标单位"] = "英雄", ["旧触发名"] = "gg_trg_Hero____________ZH", ["事件名"] = "EVENT_UNIT_DAMAGED"},
        {["目标单位"] = "英雄", ["旧触发名"] = "gg_trg_________________________SJ", ["事件名"] = "EVENT_UNIT_HERO_SKILL"},
        {["目标单位"] = "英雄", ["旧触发名"] = "gg_trg_________________________RWCF", ["事件名"] = "EVENT_UNIT_USE_ITEM"},
        {["目标单位"] = "英雄", ["旧触发名"] = "gg_trg______________________________________RW__________________u", ["事件名"] = "EVENT_UNIT_PICKUP_ITEM"},
        {["目标单位"] = "英雄", ["旧触发名"] = "gg_trg_________________________SW", ["事件名"] = "EVENT_UNIT_DEATH"},
        {["目标单位"] = "英雄", ["旧触发名"] = "gg_trg_Y________________________YDML", ["事件名"] = "EVENT_UNIT_ISSUED_POINT_ORDER"}
    }
}
____exports.default = ____exports["英雄选择配置表"]
return ____exports
