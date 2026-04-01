--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
--- 测试：红色玩家（Player 0）选择指定单位时触发对话框
-- 
-- 文本数据集中在本文件，以后由 Excel 表格 + 宏生成的 TS 表替换。
-- 对话逻辑（isDialogActive 判断 / 入队）由 openNpcDialog 统一处理。
jass = require("jass.common")
____UI_51FD_6570 = require("系统.00．核心系统.06．UI函数")
_____4FBF_6377_51FD_6570 = require("系统.00．核心系统.11．便捷函数（偶尔用）")
openNpcDialog = ____UI_51FD_6570.openNpcDialog
UNIT_ID_NGME = 110 * 16777216 + 103 * 65536 + 109 * 256 + 101
VILLAGE_CHIEF_DIALOG = {
    lines = {{title = "村长", text = "年轻人，我们村子最近遭到了哥布林的袭击，损失惨重……", duration = 4}, {title = "村长", text = "听说你武艺高强，能否帮我们解决这个麻烦？", duration = 3}},
    quest = {
        title = "村长",
        text = "【讨伐哥布林】\n\n哥布林巢穴就在村子东边的森林里，请消灭首领。\n\n奖励：金币 500 + 经验 1000",
        onAccept = function()
            jass.DisplayTimedTextToPlayer(
                jass.Player(0),
                0,
                0,
                5,
                "|cff00ff00[任务] 已接受：讨伐哥布林|r"
            )
        end,
        onReject = function()
            jass.DisplayTimedTextToPlayer(
                jass.Player(0),
                0,
                0,
                5,
                "|cffff4444[任务] 已拒绝：讨伐哥布林|r"
            )
        end
    }
}
trg = jass.CreateTrigger()
redPlayer = jass.Player(0)
jass.TriggerRegisterPlayerUnitEvent(trg, redPlayer, jass.EVENT_PLAYER_UNIT_SELECTED, nil)
jass.TriggerAddAction(
    trg,
    function()
        local u = jass.GetTriggerUnit()
        if not u then
            return
        end
        if jass.GetUnitTypeId(u) ~= UNIT_ID_NGME then
            return
        end
        local hero = _____4FBF_6377_51FD_6570:getPlayerFirstHero(redPlayer)
        if not hero then
            return
        end
        if not jass.IsUnitInRange(hero, u, 350) then
            return
        end
        openNpcDialog(nil, redPlayer, VILLAGE_CHIEF_DIALOG)
    end
)
