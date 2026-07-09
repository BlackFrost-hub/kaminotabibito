/** @noSelfInFile */

const jass = require("jass.common") as any;

const CreateTrigger = jass.CreateTrigger as () => any;
const TriggerAddAction = jass.TriggerAddAction as (trig: any, action: () => void) => void;
const TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent as (
  trig: any,
  whichPlayer: any,
  chatMessageToDetect: string,
  exactMatchOnly: boolean
) => void;
const Player = jass.Player as (index: number) => any;
const GetTriggerPlayer = jass.GetTriggerPlayer as () => any;
const DisplayTextToPlayer = jass.DisplayTextToPlayer as (player: any, x: number, y: number, message: string) => void;

const { 获取Boss测试玩家基准英雄 } = require("系统.12．测试系统.00．Boss测试系统.02．Boss测试单位") as {
  获取Boss测试玩家基准英雄: (this: void, player: any) => any;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};

const TEST_COMMAND = "testvoice";
const TEST_VOICE_PATH = "Sound\\Boss\\Thranduil\\Voice\\thranduil_opening_law_warning_jude_02_v3_64k.mp3";
const TEST_VOICE_CUTOFF = 4000;

let initialized = false;

function playExternalVoiceForPlayer(this: void): void {
  const player = GetTriggerPlayer();
  const hero = 获取Boss测试玩家基准英雄(player);
  if (hero == null || hero === 0) {
    DisplayTextToPlayer(player, 0, 0, "[testvoice] 未找到大法师/玩家英雄，无法在单位位置播放 3D 外置语音。");
    return;
  }

  DisplayTextToPlayer(player, 0, 0, "[testvoice] 在大法师位置播放 3D 外置语音: " + TEST_VOICE_PATH);
  Sound3DII_UnitPlayReuse(TEST_VOICE_PATH, hero, TEST_VOICE_CUTOFF);
}

function initExternalVoicePackTest(this: void): void {
  if (initialized) return;
  initialized = true;

  const trig = CreateTrigger();
  TriggerAddAction(trig, playExternalVoiceForPlayer);
  for (let i = 0; i <= 15; i++) {
    TriggerRegisterPlayerChatEvent(trig, Player(i), TEST_COMMAND, true);
  }
}

initExternalVoicePackTest();

export {};
