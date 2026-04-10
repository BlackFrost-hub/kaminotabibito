export * from "./00．KK扩展API";
import * as kkApi from "./00．KK扩展API";
function expose(name, fn) {
    if (typeof fn !== "function")
        return;
    const g = globalThis;
    if (typeof g[name] === "function")
        return;
    g[name] = fn;
}
export function registerBridge() {
    expose("DzDoodadCreate", kkApi.DzDoodadCreate);
    expose("DzDoodadGetTypeId", kkApi.DzDoodadGetTypeId);
    expose("DzDoodadSetModel", kkApi.DzDoodadSetModel);
    expose("DzDoodadSetTeamColor", kkApi.DzDoodadSetTeamColor);
    expose("DzDoodadSetColor", kkApi.DzDoodadSetColor);
    expose("DzDoodadGetX", kkApi.DzDoodadGetX);
    expose("DzDoodadGetY", kkApi.DzDoodadGetY);
    expose("DzDoodadGetZ", kkApi.DzDoodadGetZ);
    expose("DzDoodadSetPosition", kkApi.DzDoodadSetPosition);
    expose("DzDoodadSetOrientMatrixRotate", kkApi.DzDoodadSetOrientMatrixRotate);
    expose("DzDoodadSetOrientMatrixScale", kkApi.DzDoodadSetOrientMatrixScale);
    expose("DzDoodadSetOrientMatrixResize", kkApi.DzDoodadSetOrientMatrixResize);
    expose("DzDoodadSetVisible", kkApi.DzDoodadSetVisible);
    expose("DzDoodadSetAnimation", kkApi.DzDoodadSetAnimation);
    expose("DzDoodadSetTimeScale", kkApi.DzDoodadSetTimeScale);
    expose("DzDoodadGetTimeScale", kkApi.DzDoodadGetTimeScale);
    expose("DzDoodadGetCurrentAnimationIndex", kkApi.DzDoodadGetCurrentAnimationIndex);
    expose("DzDoodadGetAnimationCount", kkApi.DzDoodadGetAnimationCount);
    expose("DzDoodadGetAnimationName", kkApi.DzDoodadGetAnimationName);
    expose("DzDoodadGetAnimationTime", kkApi.DzDoodadGetAnimationTime);
}
