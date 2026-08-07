import { init as init被驱逐的水怪 } from "./01．被驱逐的水怪";
import { init as init污染之猫米亚 } from "./02．污染之猫米亚";
import { init as init瑟兰迪尔 } from "./03．瑟兰迪尔";
import { init as init莫特斯 } from "./04．莫特斯";
import { init as init莫尔特斯 } from "./04．莫尔特斯";

export * from "./01．支线NPC配置表";

export function init(this: void): void {
  init被驱逐的水怪();
  init污染之猫米亚();
  init瑟兰迪尔();
  init莫特斯();
  init莫尔特斯();
}
