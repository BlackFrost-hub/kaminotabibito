## 目的

记录从“对战平台官方作者群编辑器”拿到的 `BzAPI.j` 片段（JASS 头文件/声明 + 少量封装函数），以及与平台实测行为的差异，方便以后排查。

## 关键结论（以项目实测为准）

- **`jass.japi` 是 Lua 侧导出表**，不等同于 JASS 头文件里 `library BzAPI` 的内容。
- 该 `.j` 文件用于 **声明/编译/提示**；其中的封装函数（如 `DzTriggerRegisterKeyEventTrg`）可能与平台运行时规则不一致。
- 本项目在平台上实测：键盘事件 `DzTriggerRegisterKeyEventByCode` **需要 `sync=false` 才会触发**（`sync=true` 不触发）。

## 你提供的 BzAPI.j 片段（摘录）

### natives（节选：hardware）

```jass
native DzTriggerRegisterKeyEvent takes trigger trig, integer key, integer status, boolean sync, string func returns nothing
native DzTriggerRegisterKeyEventByCode takes trigger trig, integer key, integer status, boolean sync, code funcHandle returns nothing
native DzGetTriggerKey takes nothing returns integer
native DzGetTriggerKeyPlayer takes nothing returns player
native DzIsKeyDown takes integer iKey returns boolean
```

### JASS 封装（节选：Trg 版本）

```jass
function DzTriggerRegisterKeyEventTrg takes trigger trg, integer status, integer btn returns nothing
    if trg == null then
        return
    endif
    call DzTriggerRegisterKeyEvent(trg, btn, status, true, null)
endfunction
```

### 差异点

- 上面封装把 `sync` 固定成 `true`，但平台实测键盘事件需要 `sync=false` 才派发到回调。

