# CDMUI

Roblox 控制面板 UI 库 · 单文件 · 无依赖 · PC / 手机自适应

```
CDMUI 1.9.4
```

---

## 目录

- [安装](#安装)
- [快速开始](#快速开始)
- [UI.Create 参数](#uicreate-参数)
- [Window 方法](#window-方法)
- [控件清单](#控件清单)
- [屏幕 HUD 浮层](#屏幕-hud-浮层)
- [连接管理](#连接管理)
- [平台适配](#平台适配)
- [主题定制](#主题定制)
- [版本历史](#版本历史)

---

## 安装

```lua
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Cubee332/CDMUI/main/CDMUI.lua"))()
```

单文件，无外部依赖，不污染全局。

---

## 快速开始

```lua
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Cubee332/CDMUI/main/CDMUI.lua"))()

local win = UI.Create({ Title = "我的面板" })
local tab = win:Tab("基础")

tab:Toggle({
    Key = "enabled",
    Name = "启用功能",
    Desc = "点一下试试",
    Default = false,
    Callback = function(v) print("开关 =", v) end,
})
```

---

## UI.Create 参数

| 参数 | 类型 | 默认 | 说明 |
|---|---|---|---|
| `Title` | string | `"控制面板"` | 面板标题 |
| `TopbarText` | string | `"菜单"` | 顶栏按钮文字 |
| `AutoOpen` | bool | `true` | 创建后是否自动显示 |
| `AutoUnlockMouse` | bool | `true` | 面板打开时是否解锁鼠标 |
| `TopbarButton` | bool | `true` | 是否生成左上角顶栏按钮 |

---

## Window 方法

```lua
win:Tab(name)                  -- 新建 Tab，返回 Tab 对象
win:SelectTab(i, instant)      -- 切到第 i 个 Tab（instant=true 不播动画）
win:SetVisible(bool)           -- 显示 / 隐藏面板
win:Toggle()                   -- 切换显示状态
win:Notify(text, sec)          -- 弹一条提示
win:Destroy()                  -- 销毁面板（自动断开所有连接）
```

### 状态读写

```lua
win:Get(key)                   -- 读当前值
win:Set(key, value)            -- 设置值 + 重绘 + 触发回调
win:SetSilent(key, value)      -- 设置值 + 重绘，不触发回调
win:SetMany({ k1 = v1, k2 = v2 })  -- 批量设置
win:RepaintAll()               -- 把 State 全量同步到控件
```

---

## 控件清单

### tab:Toggle

最简单的开关，右侧勾选框。

```lua
tab:Toggle({
    Key = "esp",
    Name = "透视",
    Desc = "显示敌人轮廓",
    Default = false,
    Callback = function(v) print(v) end,
})
```

### tab:Section

分组标题，纯视觉分隔。

```lua
tab:Section("基础设置")
```

### tab:Label

只显示文字，不可交互。

```lua
tab:Label({ Name = "提示", Desc = "这是一段说明" })
```

### tab:Divider

水平分隔线，无参数。

```lua
tab:Divider()
```

### tab:Expand

可展开的分组，展开 / 收起带高度动画。

```lua
tab:Expand({
    Key = "advanced",
    Name = "高级设置",
    Desc = "展开查看更多",
    Default = false,
    Callback = function(v) end,
    Children = {
        -- 子控件
    },
})
```

### 子控件

#### Kind = "toggle"

```lua
{ Kind = "toggle", Key = "sub1", Name = "子开关", Default = true,
  Callback = function(v) end }
```

#### Kind = "action"

点击式按钮：外观位置和勾选框一样，但没有开关状态，点击只触发回调。

```lua
{ Kind = "action",
  Key  = "resetPos",
  Name = "重置位置",
  IconImage = "rbxassetid://112173305232811",   -- 图片图标（可选）
  IconColor = Color3.fromRGB(220, 225, 235),    -- 图标颜色（可选）
  Icon = "↻",                                   -- 没有图片时的文字图标
  OnClick = function() end }
```

说明：

- `IconImage` 优先级高于 `Icon`
- 图标居中显示，无背景框、无边框、悬停不变色
- 点击热区比图标大一圈（PC 30px / 手机 38px）
- 图标来源：[Footagesus/Icons](https://github.com/Footagesus/Icons)
  - 例：lucide 的 `fingerprint` = `rbxassetid://112173305232811`

#### Kind = "slider"

```lua
{ Kind = "slider", Key = "speed", Name = "速度",
  Min = 1, Max = 100, Default = 50, Step = 1,
  Callback = function(v) end }
```

#### Kind = "input"

```lua
{ Kind = "input", Key = "name", Name = "名称",
  Default = "", Placeholder = "输入...",
  Callback = function(text) end }
```

#### Kind = "cycle"

```lua
{ Kind = "cycle", Key = "mode", Name = "模式",
  Options = { "A", "B", "C" }, Default = "A",
  Callback = function(v) end }
```

### tab:Slider

拖动条，手机端热区加宽到 44px。

```lua
tab:Slider({
    Key = "fov",
    Name = "视野",
    Min = 70, Max = 120, Default = 90,
    Callback = function(v) end,
})
```

### tab:Input

```lua
tab:Input({
    Key = "webhook",
    Name = "Webhook",
    Placeholder = "https://...",
    Callback = function(text) end,
})
```

### tab:Cycle

```lua
tab:Cycle({
    Key = "theme",
    Name = "主题",
    Options = { "暗色", "亮色" },
    Default = "暗色",
    Callback = function(v) end,
})
```

### tab:ClickableRow

整行可点的列表项，常用于「打开子面板」。

```lua
tab:ClickableRow({
    Name = "打开设置",
    Desc = "点击进入",
    Callback = function() end,
})
```

### tab:RowButton

行内右侧带按钮。

```lua
tab:RowButton({
    Name = "重置",
    Desc = "恢复默认",
    ButtonText = "执行",
    Callback = function() end,
})
```

### tab:Body2D

给一块空白 2D 画布，自行绘制。

```lua
tab:Body2D({
    Name = "预览",
    Callback = function(frame)
        -- 在 frame 里自由绘制
    end,
})
```

---

## 屏幕 HUD 浮层

屏幕角落的状态浮层，样式仿游戏自带夜视仪状态框（四角括号 + 白色描边字），和夜视仪同宽同层。

```lua
UI.SetHUDAll(fps, ping, players)          -- 一次设置三项显隐（推荐）
UI.SetHUD("fps"|"ping"|"players", bool)   -- 单项设置
UI.SetHUDLocked(bool)                     -- true=锁定不可交互，false=可拖动
UI.ResetHUDPosition()                     -- 重置位置（带弹性动画）
UI.DestroyHUD()                           -- 彻底销毁
UI.GetHUDState()                          -- 读内部状态（调试用）
```

### 特性

- FPS 用真实帧采样；延迟读 `Stats` 的 Data Ping
- 位置自动跟随夜视仪框，间隙 8px
- 开关时播左滑 + 展开动画（Back 缓动）
- 四角用游戏原图 Slice，和夜视仪完全一致
- 锁定状态下整块不接收输入，不挡后面的 UI

### 注意

首次调用要确保 UI 已建完，否则行显隐不生效。建议连续调用 2-3 次或延迟 0.3 秒后再调一次：

```lua
task.spawn(function()
    for _ = 1, 3 do
        pcall(UI.SetHUDAll, true, true, true)
        task.wait(0.3)
    end
end)
```

---

## 连接管理

全库有近百处 `:Connect`，如果不统一管理，重载时会残留大量连接，导致「重载后行为异常」这类怪 bug。

```lua
UI.AddSignal(owner, conn)      -- 登记一条连接（owner=nil 表示全局）
UI.DisconnectAll(owner)        -- 断开某个 owner 的所有连接
UI.DisconnectEverything()      -- 断开全库所有登记的连接
UI.GetSignalStats()            -- 返回 { total, owners }（调试用）
```

`Window:Destroy()` 会自动调用 `DisconnectAll(self)`。

### 用法

```lua
local win = UI.Create({ Title = "面板" })

-- 自己的连接也登记进去，销毁时自动清理
local conn = game:GetService("RunService").Heartbeat:Connect(function() end)
UI.AddSignal(win, conn)
```

---

## 平台适配

```lua
UI.IsMobile    -- 当前是否按手机布局渲染
```

### 强制切换（调试用）

```lua
_G._CDMUIMobileOverride = true    -- 强制手机
_G._CDMUIMobileOverride = false   -- 强制 PC
_G._CDMUIMobileOverride = nil     -- 恢复自动判定
```

### 自动判定规则

1. 有触摸 + 没键盘 → 手机
2. 有触摸 + 有键盘 + 屏幕很小 → 手机
3. 否则 → PC

### 手机端自动放大

| 项 | PC | 手机 |
|---|---|---|
| 控件高度 | 28 | 36 |
| 勾选框热区 | +2px | +8px |
| 滑块热区 | 24px | 44px |
| HUD 宽度 | 195 | 210 |
| HUD 字号 | 17 / 18 | 20 / 22 |

---

## 主题定制

```lua
UI.Theme            -- 当前主题表（可直接改字段）
UI.Layout           -- 布局尺寸表
UI.Size             -- 控件尺寸表
UI.LowSpecMode      -- 低配模式（跳过装饰性描边）
UI.SetLowSpec(bool) -- 开关低配模式
```

### 改主题

```lua
UI.Theme.accent = Color3.fromRGB(120, 200, 255)
UI.Theme.panel  = Color3.fromRGB(18, 18, 22)
```

### 低配模式

低配设备上跳过装饰性描边，减少渲染开销：

```lua
UI.SetLowSpec(true)
```

---

## 版本历史

| 版本 | 变更 |
|---|---|
| 1.9.4 | HUD 间隙 8px、字号加大；文档重写 |
| 1.9.3 | HUD 行显隐修复（syncRow 无条件设 true） |
| 1.9.2 | HUD 位置动态跟随夜视仪；PC/手机双模式 |
| 1.9.1 | 统一连接管理（AddSignal / DisconnectAll） |
| 1.9.0 | 新增 HUD 浮层与 action 控件；子项悬浮高亮 |
| 1.8.5 | 滑块热区优化、鼠标恢复修复 |
| 1.6.0 | 基础控件齐全 |

---

## 许可

MIT
