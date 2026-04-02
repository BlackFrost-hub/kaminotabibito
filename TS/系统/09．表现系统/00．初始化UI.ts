const japi = require("jass.japi") as any;

/**
 * 初始化原生UI
 * 隐藏顶部菜单按钮图标
 */
export function initNativeUI(): void {
  let ydul_A = 0;
  const JN = new Array<any>();

  while (ydul_A <= 0) {
    JN[ydul_A] = japi.DzCreateFrameByTagName("BACKDROP", "name", japi.DzGetGameUI(), "template", 0);
    japi.DzFrameSetSize(JN[ydul_A], 1.00 / 2400.00, 1.00 / 1800.00);
    japi.DzFrameSetPoint(JN[ydul_A], 0, japi.DzGetGameUI(), 0, 205.50 / 2400.00, -19.30 / 1800.00);

    JN[ydul_A + 4] = japi.DzFrameGetUpperButtonBarButton(ydul_A);
    japi.DzFrameClearAllPoints(JN[ydul_A + 4]);
    japi.DzFrameSetSize(JN[ydul_A + 4], 1.00 / 2400.00, 1.00 / 1800.00);
    japi.DzFrameSetPoint(JN[ydul_A + 4], 4, JN[ydul_A], 4, 0.00, 0.00);
    japi.DzFrameShow(JN[ydul_A + 4], true);

    ydul_A = ydul_A + 1;
  }

  japi.DzFrameSetTexture(JN[0], "UI\\toumingtietu.tga", 0);
}
