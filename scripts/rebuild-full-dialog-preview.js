const fs = require("fs");

const base = "C:/Users/Administrator/Desktop/syzl";
const tsPath =
  `${base}/TS/系统/08．任务系统/00．配置表/06．JLC精灵村001阶段配置表.ts`;
const jFiles = [`${base}/JASS/1.J`, `${base}/JASS/2.j`, `${base}/JASS/3.j`];
const wtsPath = `${base}/JASS/111.wts`;

function read(p) {
  return fs.readFileSync(p, "utf8");
}

const wts = read(wtsPath);
const wtsMap = new Map();
for (const m of wts.matchAll(/STRING\s+(\d+)\s*\{([\s\S]*?)\}/g)) {
  wtsMap.set(`TRIGSTR_${m[1]}`, m[2].trim().replace(/\r?\n/g, "\\n"));
}

const blocks = [];

for (const file of jFiles) {
  const src = read(file).split(/\r?\n/);
  const triggerName =
    (src.find((l) => l.includes("// Trigger:")) || "")
      .replace("// Trigger:", "")
      .trim() || file;

  let inActions = false;
  const stack = [];

  for (const line of src) {
    if (/^function\s+.*Actions\s+takes nothing returns nothing/.test(line)) {
      inActions = true;
      continue;
    }
    if (inActions && /^endfunction/.test(line)) {
      inActions = false;
      break;
    }
    if (!inActions) continue;

    const ifm = line.match(/^\s*if\s+\(\((.*)\)\s+then/);
    if (ifm) {
      stack.push({
        condition: ifm[1].replace(/\s+/g, " ").trim(),
        fromStage: "*",
        pairs: [],
      });
      const sEq = ifm[1].match(/剧情进度","整数", integer\)\s*==\s*(\d+)/);
      const sLt = ifm[1].match(/剧情进度","整数", integer\)\s*<\s*(\d+)/);
      if (sEq) stack[stack.length - 1].fromStage = sEq[1];
      else if (sLt) stack[stack.length - 1].fromStage = sLt[1];
      continue;
    }

    if (/^\s*endif/.test(line)) {
      const b = stack.pop();
      if (b && b.pairs.length > 0) {
        blocks.push({ triggerName, fromStage: b.fromStage, condition: b.condition, pairs: b.pairs });
      }
      continue;
    }

    if (stack.length === 0) continue;
    const cur = stack[stack.length - 1];
    const tm = line.match(/TransmissionFromUnitWithNameBJ\([^"]*"TRIGSTR_(\d+)"\s*,\s*null\s*,\s*"TRIGSTR_(\d+)"/);
    if (tm) {
      cur.pairs.push([`TRIGSTR_${tm[1]}`, `TRIGSTR_${tm[2]}`]);
      continue;
    }
    const sm = line.match(/TransmissionFromUnitWithNameBJ\([^"]*"TRIGSTR_(\d+)"\s*,/);
    if (sm) {
      cur.pairs.push([null, `TRIGSTR_${sm[1]}`]);
    }
  }
}

const ts = read(tsPath).split(/\r?\n/);
const out = [];
let i = 0;
while (i < ts.length) {
  const line = ts[i];
  out.push(line);
  if (!/^\s*condition:\s*"/.test(line)) {
    i++;
    continue;
  }

  const cond = (line.match(/^\s*condition:\s*"(.*)",\s*$/) || [])[1];
  let triggerName = "";
  let fromStage = "*";
  for (let j = i - 1; j >= 0 && j > i - 12; j--) {
    const t = ts[j].match(/triggerName:\s*"([^"]+)"/);
    if (t) triggerName = t[1];
    const s = ts[j].match(/fromStage:\s*"([^"]+)"/);
    if (s) fromStage = s[1];
  }

  const blk = blocks.find(
    (b) => b.triggerName === triggerName && b.fromStage === fromStage && b.condition === cond
  );

  if (blk) {
    // skip old dialogPreview block if present
    let k = i + 1;
    while (k < ts.length && !/^\s*enabled:\s*true,/.test(ts[k])) {
      if (/^\s*dialogPreview:/.test(ts[k])) {
        while (k < ts.length && !/^\s*`,\s*$/.test(ts[k]) && !/,\s*$/.test(ts[k])) k++;
      }
      k++;
    }

    const items = [];
    for (const [sid, tid] of blk.pairs) {
      const sp = sid ? (wtsMap.get(sid) || sid) : "系统";
      const tx = tid ? (wtsMap.get(tid) || tid) : "";
      if (tx) items.push(`${sp}：${tx}`);
    }

    out.push("    dialogPreview: `");
    items.forEach((it, idx) => out.push(`    ${idx + 1}. ${it}`));
    out.push("    `,");

    i = k - 1;
  }
  i++;
}

fs.writeFileSync(tsPath, out.join("\n"), "utf8");
console.log("rebuilt full dialogPreview");
