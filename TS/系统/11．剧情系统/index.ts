/** @noSelfInFile */

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const _xpcall = (globalThis as any).xpcall as
  | undefined
  | ((callback: (this: void) => void, handler: (this: void, error: any) => string) => boolean);
const _luaDebug = (globalThis as any).debug as {
  traceback?: (this: void, message: string, level?: number) => string;
} | undefined;
const _raiseError = (globalThis as any).error as (this: void, message: string) => void;

const STORY_INIT_LOG_MODULE = "剧情系统/分段加载";

interface 剧情子系统 {
  init?: (this: void) => void;
}

let 当前剧情子系统名称 = "";
let 当前剧情子系统路径 = "";

function 剧情初始化异常处理(this: void, error: any): string {
  const errorText = tostring(error);
  const traceback = _luaDebug != null && typeof _luaDebug.traceback === "function"
    ? _luaDebug.traceback(errorText, 2)
    : errorText;
  debugLogForce(STORY_INIT_LOG_MODULE, "捕获异常，完整调用栈如下\n" + traceback);
  return traceback;
}

function 执行当前剧情子系统(this: void): void {
  debugLogForce(STORY_INIT_LOG_MODULE, "准备加载", 当前剧情子系统名称, "path=", 当前剧情子系统路径);
  const 子系统 = require(当前剧情子系统路径) as 剧情子系统;
  debugLogForce(STORY_INIT_LOG_MODULE, "模块加载完成", 当前剧情子系统名称);
  if (typeof 子系统.init === "function") {
    debugLogForce(STORY_INIT_LOG_MODULE, "准备初始化", 当前剧情子系统名称);
    子系统.init();
    debugLogForce(STORY_INIT_LOG_MODULE, "初始化完成", 当前剧情子系统名称);
  }
}

function 加载并初始化剧情子系统(this: void, 名称: string, 模块路径: string): void {
  当前剧情子系统名称 = 名称;
  当前剧情子系统路径 = 模块路径;
  if (typeof _xpcall === "function") {
    const ok = _xpcall(执行当前剧情子系统, 剧情初始化异常处理);
    if (!ok) {
      _raiseError("剧情子系统加载或初始化失败：" + 名称);
    }
  } else {
    执行当前剧情子系统();
  }
}

export function init(this: void): void {
  加载并初始化剧情子系统("公共", "系统.11．剧情系统.00．公共.index");
  加载并初始化剧情子系统("主线任务", "系统.11．剧情系统.01．主线任务.index");
  加载并初始化剧情子系统("支线任务", "系统.11．剧情系统.02．支线任务.index");
  加载并初始化剧情子系统("世界线变动", "系统.11．剧情系统.03．世界线变动.index");
}
