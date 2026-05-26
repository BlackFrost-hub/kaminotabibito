import { init as init公共 } from "./00．公共";
import { init as init主线任务 } from "./01．主线任务";

export function init(this: void): void {
  init公共();
  init主线任务();
}
