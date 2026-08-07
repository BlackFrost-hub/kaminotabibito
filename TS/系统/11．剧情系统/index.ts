import { init as init公共 } from "./00．公共";
import { init as init主线任务 } from "./01．主线任务";
import { init as init支线任务 } from "./02．支线任务";
import { init as init世界线变动 } from "./03．世界线变动";

export function init(this: void): void {
  init公共();
  init主线任务();
  init支线任务();
  init世界线变动();
}
