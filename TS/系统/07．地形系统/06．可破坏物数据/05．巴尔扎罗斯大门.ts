/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { ModifyGateBJ, GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  ModifyGateBJ: (this: void, gateOperation: number, d: any) => void;
  GetPlayersAll: (this: void) => any;
};
const { TransmissionFromUnitWithNameBJ } = require("lib.扩展函数.BJ函数.05A．电影函数") as {
  TransmissionFromUnitWithNameBJ: (
    this: void,
    toForce: any,
    whichUnit: any,
    unitName: string,
    soundHandle: any,
    message: string,
    timeType: number,
    timeVal: number,
    wait: boolean,
  ) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, 回调: (this: void, 死亡单位: any, 击杀单位: any) => void) => void;
};

const GetUnitTypeId = jass.GetUnitTypeId as (this: void, 单位: any) => number;

const 巴尔扎罗斯大门全局名 = "gg_dest_B00M_13602";
const 恶魔看守者单位ID = stringToFourCCSafe("n03S");
const 传音说话者 = "(远处的声音)";
const 传音文本 = "不错，你们几个小鬼的实力得到了我的认可，进来吧！";
const bj_GATEOPERATION_OPEN = jglobals.bj_GATEOPERATION_OPEN as number;
const bj_TIMETYPE_SET = jglobals.bj_TIMETYPE_SET as number;

let 大门已开启 = false;

function 处理恶魔看守者死亡(this: void, 死亡单位: any, _击杀单位: any): void {
  if (大门已开启) return;
  if (死亡单位 == null || 死亡单位 === 0) return;
  if (GetUnitTypeId(死亡单位) !== 恶魔看守者单位ID) return;
  大门已开启 = true;

  const 大门 = jglobals[巴尔扎罗斯大门全局名];
  if (大门 != null && 大门 !== 0) {
    ModifyGateBJ(bj_GATEOPERATION_OPEN, 大门);
  }

  TransmissionFromUnitWithNameBJ(
    GetPlayersAll(),
    null,
    传音说话者,
    null,
    传音文本,
    bj_TIMETYPE_SET,
    10.0,
    false,
  );
}

registerDeathListener(处理恶魔看守者死亡);

export {};
