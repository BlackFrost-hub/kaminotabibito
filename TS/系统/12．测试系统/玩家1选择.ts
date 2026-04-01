/**
 * 测试：红色玩家（Player 0）选择指定单位时触发对话框
 *
 * 文本数据集中在本文件，以后由 Excel 表格 + 宏生成的 TS 表替换。
 * 对话逻辑（isDialogActive 判断 / 入队）由 openNpcDialog 统一处理。
 */

const jass = require("jass.common") as any;
const UI函数 = require("系统.00．核心系统.06．UI函数") as {
  openNpcDialog: (player: any, data: any) => void;
  NpcDialogData: any;
};
const 便捷函数 = require("系统.00．核心系统.11．便捷函数（偶尔用）") as {
  getPlayerFirstHero: (player: any) => any;
};

const { openNpcDialog } = UI函数;
type NpcDialogData = any;

// 手动计算 FourCC("ngme")
// n=110, g=103, m=109, e=101  →  110*16777216 + 103*65536 + 109*256 + 101
const UNIT_ID_NGME = 110 * 16777216 + 103 * 65536 + 109 * 256 + 101; // "ngme"

// ─── 村长对话数据（未来从表格读取，替换此处即可）─────────────────────────────
const VILLAGE_CHIEF_DIALOG: NpcDialogData = {
  lines: [
    {
      title: "村长",
      text: "年轻人，我们村子最近遭到了哥布林的袭击，损失惨重……",
      duration: 4,
    },
    {
      title: "村长",
      text: "听说你武艺高强，能否帮我们解决这个麻烦？",
      duration: 3,
    },
  ],
  quest: {
    title: "村长",
    text: "【讨伐哥布林】\n\n哥布林巢穴就在村子东边的森林里，请消灭首领。\n\n奖励：金币 500 + 经验 1000",
    onAccept: () => {
      jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 5, "|cff00ff00[任务] 已接受：讨伐哥布林|r");
    },
    onReject: () => {
      jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 5, "|cffff4444[任务] 已拒绝：讨伐哥布林|r");
    },
  },
};
// ─────────────────────────────────────────────────────────────────────────────

const trg = jass.CreateTrigger();
const redPlayer = jass.Player(0);
jass.TriggerRegisterPlayerUnitEvent(
  trg,
  redPlayer,
  jass.EVENT_PLAYER_UNIT_SELECTED,
  null
);
jass.TriggerAddAction(trg, () => {
  const u = jass.GetTriggerUnit();
  if (!u) return;
  if (jass.GetUnitTypeId(u) !== UNIT_ID_NGME) return;
  
  const hero = 便捷函数.getPlayerFirstHero(redPlayer);
  if (!hero) return;
  if (!jass.IsUnitInRange(hero, u, 350)) return;

  openNpcDialog(redPlayer, VILLAGE_CHIEF_DIALOG);
});
