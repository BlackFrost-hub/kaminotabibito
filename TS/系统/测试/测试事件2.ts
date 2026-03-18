// 测试事件2 - 玩家输入 222：给玩家0加 1000 金币 + 仅玩家0 播放收金币音效（用 封装函数 + 音效函数）

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };
const { AdjustPlayerStateBJ } = require("系统.00_核心.封装函数") as { AdjustPlayerStateBJ: (delta: number, whichPlayer: any, whichPlayerState: any) => void };
const { Sound3DII_Mp3Play } = require("系统.00_核心.音效函数") as { Sound3DII_Mp3Play: (path: string, player?: any) => any };
const { CreateFloatTextOnUnit } = require("系统.00_核心.漂浮文字函数") as { CreateFloatTextOnUnit: (unit: any, text: string, options?: any) => any };

const SOUND_GOLD = "Abilities\\Spells\\Items\\ResourceItems\\ReceiveGold.wav";
// 金色 RGB
const GOLD_R = 255;
const GOLD_G = 215;
const GOLD_B = 0;

function onChat222(): void {
  AdjustPlayerStateBJ(
    1000,
    (jass as any).Player(0),
    (jass as any).PLAYER_STATE_RESOURCE_GOLD
  );
  // 1 秒内每 0.1 秒播放一次，共 10 次（测试引擎能否承受高频同音效）
  if (
    typeof (jass as any).CreateTimer === "function" &&
    typeof (jass as any).TimerStart === "function" &&
    typeof (jass as any).DestroyTimer === "function"
  ) {
    const t = (jass as any).CreateTimer();
    let n = 0;
    (jass as any).TimerStart(t, 0.1, true, () => {
      n++;
      Sound3DII_Mp3Play(SOUND_GOLD, (jass as any).Player(0));
      if (n >= 10) {
        (jass as any).DestroyTimer(t);
      }
    });
  } else {
    Sound3DII_Mp3Play(SOUND_GOLD, (jass as any).Player(0));
  }
  if (g.gg_unit_Hamg_0002 != null) {
    CreateFloatTextOnUnit(g.gg_unit_Hamg_0002, "+2000", {
      size: 12,
      red: GOLD_R,
      green: GOLD_G,
      blue: GOLD_B,
      alpha: 0
    });
  }
  if (typeof (jass as any).DisplayTimedTextToPlayer === "function") {
    (jass as any).DisplayTimedTextToPlayer(
      (jass as any).Player(0),
      0,
      0,
      10,
      "[测试事件2] 已给玩家0增加 1000 金币"
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
      "222",
      true
    );
    (jass as any).TriggerAddAction(tr, onChat222);
  }
}

init();
export {};
