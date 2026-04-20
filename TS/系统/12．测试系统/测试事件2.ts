// 测试事件2 - 2222：4×+1000 + 4 条漂浮字；555：12×+1000 + 12 条（漂浮字均设 duration，走 漂浮文字函数 回收队列排泄）

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };
const { AdjustPlayerStateBJ } = require("lib.扩展函数.封装函数.01．通用工具.index") as { AdjustPlayerStateBJ: (delta: number, whichPlayer: any, whichPlayerState: any) => void };
const { Sound3DII_Mp3PlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
  Sound3DII_Mp3PlayReuse: (path: string, player?: any) => void;
};
const { CreateFloatTextOnUnit } = require("lib.扩展函数.封装函数.03．漂浮文字.index") as {
  CreateFloatTextOnUnit: (unit: any, text: string, options?: any) => any;
};

/** 每条 +1000 各一条漂浮字；duration>0 入队，到期 DestroyTextTag（排泄） */
const GOLD_FLOAT_DURATION_SEC = 1.25;

function spawnGoldFloatPlus1000(): void {
  const u = g.gg_unit_Hamg_0002;
  if (u == null) return;
  CreateFloatTextOnUnit(u, "+1000", {
    size: 12,
    red: GOLD_R,
    green: GOLD_G,
    blue: GOLD_B,
    alpha: 0,
    duration: GOLD_FLOAT_DURATION_SEC
  });
}

const SOUND_GOLD = "Abilities\\Spells\\Items\\ResourceItems\\ReceiveGold.wav";
// 金色 RGB
const GOLD_R = 255;
const GOLD_G = 215;
const GOLD_B = 0;

/** 2222：1s 内 4 次 → 间隔 0.25s */
const GOLD_BURST_TIMES = 4;
const GOLD_BURST_INTERVAL_SEC = 0.25;

/** 555：1s 内 12 次 → 间隔 1/11s（12 次起播时刻 0～1s） */
const GOLD_BURST_555_TIMES = 12;
const GOLD_BURST_555_INTERVAL_SEC = 1 / 11;

function onChat2222(): void {
  const p0 = (jass as any).Player(0);
  let n = 0;
  const step = (): void => {
    if (n >= GOLD_BURST_TIMES) return;
    AdjustPlayerStateBJ(1000, p0, (jass as any).PLAYER_STATE_RESOURCE_GOLD);
    Sound3DII_Mp3PlayReuse(SOUND_GOLD, p0);
    spawnGoldFloatPlus1000();
    n++;
    if (n >= GOLD_BURST_TIMES) return;
    const t = (jass as any).CreateTimer();
    (jass as any).TimerStart(t, GOLD_BURST_INTERVAL_SEC, false, () => {
      (jass as any).DestroyTimer((jass as any).GetExpiredTimer());
      step();
    });
  };
  step();
  (jass as any).DisplayTimedTextToPlayer(
    (jass as any).Player(0),
    0,
    0,
    10,
    "[测试事件2] 1s内4×+1000+4条漂浮字，收金币音复用，间隔" + GOLD_BURST_INTERVAL_SEC + "s"
  );
}

function onChat555(): void {
  const p0 = (jass as any).Player(0);
  let n = 0;
  const step = (): void => {
    if (n >= GOLD_BURST_555_TIMES) return;
    AdjustPlayerStateBJ(1000, p0, (jass as any).PLAYER_STATE_RESOURCE_GOLD);
    Sound3DII_Mp3PlayReuse(SOUND_GOLD, p0);
    spawnGoldFloatPlus1000();
    n++;
    if (n >= GOLD_BURST_555_TIMES) return;
    const t = (jass as any).CreateTimer();
    (jass as any).TimerStart(t, GOLD_BURST_555_INTERVAL_SEC, false, () => {
      (jass as any).DestroyTimer((jass as any).GetExpiredTimer());
      step();
    });
  };
  step();
  if (typeof (jass as any).DisplayTimedTextToPlayer === "function") {
    (jass as any).DisplayTimedTextToPlayer(
      (jass as any).Player(0),
      0,
      0,
      12,
      "[测试事件2] 555：1s内12×+1000+12条漂浮字+12次音，间隔1/11s；首按可能少1声"
    );
  }
}

function init(): void {
  const tr = (jass as any).CreateTrigger();
  if (
    typeof (jass as any).TriggerRegisterPlayerChatEvent === "function" &&
    typeof (jass as any).TriggerAddAction === "function" &&
    typeof (jass as any).Player === "function"
  ) {
    (jass as any).TriggerRegisterPlayerChatEvent(
      tr,
      (jass as any).Player(0),
      "2222",
      true
    );
    (jass as any).TriggerAddAction(tr, onChat2222);
    const tr555 = (jass as any).CreateTrigger();
    (jass as any).TriggerRegisterPlayerChatEvent(
      tr555,
      (jass as any).Player(0),
      "555",
      true
    );
    (jass as any).TriggerAddAction(tr555, onChat555);
  }
}

init();
export {};


