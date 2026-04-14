const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };
const { DzUnbindEffect, DzSetEffectScale } = require("lib.扩展函数.KK扩展API.index") as {
  DzUnbindEffect: (whichEffect: any) => boolean;
  DzSetEffectScale: (whichEffect: any, scale: number) => boolean;
};
const { createUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  createUnitEffect: (unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
};
const { withTimer } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  withTimer: (delay: number, callback: () => void) => void;
};

let testEffect: any = null;

function testDzUnbindEffect(): void {
  const testUnit = g.gg_unit_Hamg_0002;

  if (!testUnit) {
    jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 5, "|cffff0000[DzUnbindEffect测试]|r 找不到单位 gg_unit_Hamg_0002");
    return;
  }

  const modelPath = "resource\\models\\qipao.mdx";
  testEffect = createUnitEffect(testUnit, "overhead", modelPath);

  if (!testEffect) {
    jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 5, "|cffff0000[DzUnbindEffect测试]|r 特效创建失败");
    return;
  }

  jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 5, "|cff00ff00[DzUnbindEffect测试]|r 特效已绑定到单位，3秒后解除绑定并删除");

  withTimer(3, () => {
    const unbindResult = DzUnbindEffect(testEffect);
    jass.DisplayTimedTextToPlayer(
      jass.Player(0),
      0,
      0,
      5,
      `|cff00ff00[DzUnbindEffect测试]|r DzUnbindEffect 返回: ${unbindResult}`
    );

    const scaleResult = DzSetEffectScale(testEffect, 0);
    jass.DisplayTimedTextToPlayer(
      jass.Player(0),
      0,
      0,
      5,
      `|cff00ff00[DzUnbindEffect测试]|r DzSetEffectScale(0) 返回: ${scaleResult}`
    );

    if (typeof jass.DestroyEffect === "function") {
      jass.DestroyEffect(testEffect);
      jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 5, "|cff00ff00[DzUnbindEffect测试]|r 特效已删除");
    }
  });
}

function init(): void {
  testDzUnbindEffect();
}

init();

export {};
