--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["安兹乌尔恭单位技能配置"] = {
    BossKey = "AinzOoalGown",
    ["单位名称"] = "安兹·乌尔·恭",
    ["正式单位ID"] = "U007",
    ["旧候选单位ID"] = "E005",
    ["模型路径"] = "Boss\\AinzOoalGown\\AinzOoalGown.mdx",
    ["普通攻击"] = {["射程"] = 1200, ["弹道速度"] = 1400, ["弹道模型"] = "Boss\\AinzOoalGown\\Projectile\\AinzMagicMissile.mdx"},
    ["技能壳"] = {["现实断裂"] = "AT08", ["心脏掌握"] = "BT08", ["高阶魔法箭"] = "CT08", ["光辉翠绿体"] = "AN00"},
    ["主动技能提示"] = {{["技能ID"] = "AT08", ["提示"] = "现实断裂", ["扩展提示"] = "预警一条狭长空间切面，短暂延迟后沿固定方向爆发。"}, {["技能ID"] = "BT08", ["提示"] = "心脏掌握", ["扩展提示"] = "点名一名玩家并施加暗红心脏倒计时。"}, {["技能ID"] = "CT08", ["提示"] = "高阶魔法箭", ["扩展提示"] = "向当前目标连续发射高阶亡灵魔法箭。"}, {["技能ID"] = "AN00", ["提示"] = "光辉翠绿体", ["扩展提示"] = "短暂覆盖翠绿色防御层，抵消一次直接物理攻击。"}},
    ["护卫"] = {BossKey = "AlbedoGuardian", ["单位名称"] = "雅儿贝德", ["正式单位ID"] = "U008", ["模型路径"] = "Boss\\AinzOoalGown\\Albedo.mdx"},
    ["阶段阈值"] = {["P2生命比例"] = 0.7, ["P3生命比例"] = 0.35, ["P3预告生命比例"] = 0.4, ["至尊宣言生命比例"] = 0.15},
    ["挑战模式"] = {"至尊的试炼", "守护者介入"},
    ["广播持续时间Ms"] = 4200,
    ["配音裁断距离"] = 4000,
    ["开场台词时间"] = {["战斗开始延迟Ms"] = 4800, ["守护者命令延迟Ms"] = 9000},
    ["台词"] = {
        ["登场"] = {"很好，你们竟能来到这里。那么，就来接受我的试炼吧。"},
        ["战斗开始"] = {"那么，开始吧。尽你们所能挣扎给我看。"},
        ["进入P2"] = {"原来如此，看来值得让我稍微展示一些力量。"},
        ["现实断裂"] = {"现实本身正在拒绝你们。"},
        ["心脏掌握"] = {"心脏掌握。我会留给你恐惧的时间。"},
        ["高阶魔法箭"] = {"无处可逃。接受高阶魔法的洗礼吧。"},
        ["光辉翠绿体"] = {"这种程度的一击，根本触及不了我。"},
        ["时间停止启动"] = {"时间啊，停止吧。"},
        ["时间停止结算"] = {"然后，时间重新开始流动。"},
        ["高阶亡灵召唤"] = {"来吧，我忠实的死亡仆从。"},
        ["天空坠落"] = {"超位魔法，天空坠落。", "超位魔法！天空坠落！"},
        ["一切生命的终点"] = {"一切有生命者所抵达的终点，皆为死亡。", "一切生命的终点！皆为死亡！"},
        ["守护者命令"] = {"雅儿贝德，履行守护者的职责。"},
        ["进入P3"] = {"很出色。但你们无法逃离死亡之理。"},
        ["至尊宣言"] = {"安兹·乌尔·恭绝无败北。"},
        ["挑战结束"] = {"试炼到此为止。雅儿贝德，收起武器。"}
    },
    ["配音资源"] = {
        ["登场"] = {"Sound\\Boss\\AinzOoalGown\\Voice\\01_intro_trial.mp3"},
        ["战斗开始"] = {"Sound\\Boss\\AinzOoalGown\\Voice\\02_battle_start.mp3"},
        ["进入P2"] = {"Sound\\Boss\\AinzOoalGown\\Voice\\03_phase_two_acknowledge.mp3"},
        ["现实断裂"] = {"Sound\\Boss\\AinzOoalGown\\Voice\\04_reality_fracture.mp3"},
        ["心脏掌握"] = {"Sound\\Boss\\AinzOoalGown\\Voice\\05_grasp_heart.mp3"},
        ["高阶魔法箭"] = {"Sound\\Boss\\AinzOoalGown\\Voice\\06_magic_arrow_volley.mp3"},
        ["光辉翠绿体"] = {"Sound\\Boss\\AinzOoalGown\\Voice\\07_green_guard.mp3"},
        ["时间停止启动"] = {"Sound\\Boss\\AinzOoalGown\\Voice\\08_time_stop.mp3"},
        ["时间停止结算"] = {"Sound\\Boss\\AinzOoalGown\\Voice\\09_time_resume.mp3"},
        ["高阶亡灵召唤"] = {"Sound\\Boss\\AinzOoalGown\\Voice\\10_undead_summon.mp3"},
        ["天空坠落"] = {"Sound\\Boss\\AinzOoalGown\\Voice\\11_fallen_down.mp3", "Sound\\Boss\\AinzOoalGown\\Voice\\ainz_fallen_down_super_tier_01.mp3"},
        ["一切生命的终点"] = {"Sound\\Boss\\AinzOoalGown\\Voice\\12_goal_of_all_life.mp3", "Sound\\Boss\\AinzOoalGown\\Voice\\ainz_goal_of_all_life_is_death_01.mp3"},
        ["守护者命令"] = {"Sound\\Boss\\AinzOoalGown\\Voice\\13_guardian_order.mp3"},
        ["进入P3"] = {"Sound\\Boss\\AinzOoalGown\\Voice\\14_final_phase.mp3"},
        ["至尊宣言"] = {"Sound\\Boss\\AinzOoalGown\\Voice\\15_no_defeat.mp3"},
        ["挑战结束"] = {"Sound\\Boss\\AinzOoalGown\\Voice\\16_trial_end.mp3"}
    },
    ["雅儿贝德台词"] = {
        ["至尊拦截"] = {"胆敢对安兹大人出手。就在这里，将你排除。"},
        ["黑翼横扫"] = {"黑翼，展开。安兹大人的敌人，一个不留地抹除。"},
        ["守护者之职责"] = {"一切请交给我，安兹大人。哪怕付出这条性命，我也一定会守护您。"},
        ["至尊共护"] = {"以此身为盾，以漆黑双翼为壁。安兹大人，请尽情施展您的力量。"},
        ["黑翼拘束"] = {"黑翼啊，将其束缚。在安兹大人御前，老实接受裁决吧。"},
        ["生命锚点封锁"] = {"生命之锚已经打下。别妄想逃离安兹大人的审判。"},
        ["守护回归"] = {"非常抱歉，安兹大人。我现在就回到您的身边。"},
        ["护卫反击"] = {"竟敢向安兹大人露出獠牙……认清自己的分寸。用你这条命来偿还。"}
    },
    ["当前状态"] = {
        ["目录结构已建立"] = true,
        ["单位数据已确认"] = true,
        ["技能已实现"] = true,
        ["现实断裂已实现"] = true,
        ["心脏掌握已实现"] = true,
        ["高阶魔法箭已实现"] = true,
        ["光辉翠绿体已实现"] = true,
        ["天空坠落已实现"] = true,
        ["P2阶段调度已实现"] = true,
        ["时间停止已实现"] = true,
        ["高阶亡灵召唤已实现"] = true,
        ["一切生命的终点已实现"] = true,
        ["守护者模式已实现"] = true,
        ["基础运行时已实现"] = true,
        ["战斗启动上下文已注册"] = true
    }
}
return ____exports
