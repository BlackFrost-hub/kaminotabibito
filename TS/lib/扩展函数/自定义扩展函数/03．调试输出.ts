const _print = (globalThis as any).print as ((...args: any[]) => void) | undefined;

const DEBUG_FLAGS: Record<string, boolean> = {};

export function setDebug(module: string, on: boolean): void {
  DEBUG_FLAGS[module] = on;
}

export function isDebug(module: string): boolean {
  return DEBUG_FLAGS[module] === true;
}

export function debugLog(module: string, ...args: any[]): void {
  if (!isDebug(module)) return;
  if (!_print) return;
  const prefix = "[" + module + "] ";
  _print(prefix, ...args);
}

export function debugLogForce(module: string, ...args: any[]): void {
  if (!_print) return;
  const prefix = "[" + module + "] ";
  _print(prefix, ...args);
}
