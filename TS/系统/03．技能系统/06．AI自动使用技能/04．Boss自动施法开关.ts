/** @noSelfInFile */

let Boss自动施法开启 = true;

export function 设置Boss自动施法开启(this: void, 开启: boolean): void {
  Boss自动施法开启 = 开启;
}

export function Boss自动施法是否开启(this: void): boolean {
  return Boss自动施法开启;
}
