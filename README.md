# CDMUI

Roblox 控制面板 UI 库。单文件，无依赖，PC / 手机自适应。

```
CDMUI 2.3.4
```

---

## 目录

- [安装](#安装)
- [快速开始](#快速开始)
- [UI.Create 参数](#uicreate-参数)
- [加载任务（预热）](#加载任务预热)
- [Window 方法](#window-方法)
- [状态读写](#状态读写)
- [控件参考](#控件参考)
  - [Toggle 开关](#toggle-开关)
  - [Slider 滑条](#slider-滑条)
  - [Cycle 循环切换](#cycle-循环切换)
  - [Input 文本输入](#input-文本输入)
  - [Expand 展开分组](#expand-展开分组)
  - [Section 分组标题](#section-分组标题)
  - [Label 纯文本](#label-纯文本)
  - [Divider 分隔线](#divider-分隔线)
  - [ClickableRow 可点行](#clickablerow-可点行)
  - [RowButton 行内按钮](#rowbutton-行内按钮)
  - [Dropdown 下拉选择](#dropdown-下拉选择)
  - [MultiSelect 多选](#multiselect-多选)
  - [ColorPicker 取色器](#colorpicker-取色器)
  - [TextBox 文本框](#textbox-文本框)
  - [Progress 进度条](#progress-进度条)
  - [Buttons 按钮组](#buttons-按钮组)
  - [Paragraph 段落](#paragraph-段落)
  - [Space 间隔](#space-间隔)
  - [Custom 自定义行](#custom-自定义行)
  - [Keybind 按键绑定](#keybind-按键绑定)
- [子控件（Expand 内部）](#子控件expand-内部)
- [连接管理](#连接管理)
- [平台适配](#平台适配)
- [主题定制](#主题定制)
- [性能选项](#性能选项)
- [错误处理](#错误处理)
- [通知与对话框](#通知与对话框)
- [卡片](#卡片)
- [依赖系统](#依赖系统)
- [配置存储](#配置存储)
- [Tooltip](#tooltip)
- [搜索](#搜索)
- [常见问题](#常见问题)
- [版本历史](#版本历史)

---

## 安装

```lua
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Cubee332/CDMUI/main/CDMUI.lua"))()
```

单文件，无外部依赖，不污染全局。

也可以直接读本地文件：

```lua
local UI = loadstring(readfile("CDMUI.lua"))()
```

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

多标签页：

```lua
local tab1 = win:Tab("基础")
local tab2 = win:Tab("高级")
local tab3 = win:Tab("关于")

win:SelectTab(1)   -- 切到第一个
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
| `RealLoading` | bool | `false` | 加载动画是否跑真实任务 |
| `Tasks` | table | `nil` | 真实任务列表（配 `RealLoading`）|

示例：

```lua
local win = UI.Create({
    Title = "外挂面板",
    TopbarText = "打开",
    AutoOpen = false,
    AutoUnlockMouse = true,
    TopbarButton = true,
})
```

---

## 加载任务（预热）

默认关闭。开启后，加载动画会真的执行你传进去的任务，进度条按**实际完成数**推进，而不是固定的时间表。

### 用途

把首次开启功能时会「卡一下」的初始化工作提前做掉。

### 基本用法

```lua
local win = UI.Create({
    Title = "控制面板",
    RealLoading = true,          -- 开启真实加载
    Tasks = {
        { Name = "扫描容器", Run = function()
            local found = {}
            for _, name in ipairs({"Characters", "Dummies", "AI"}) do
                local f = workspace:FindFirstChild(name)
                if f then found[#found + 1] = f end
            end
            _G._Containers = found
        end },

        { Name = "预热高亮池", Run = function()
            local pool = {}
            for i = 1, 8 do
                local h = Instance.new("Highlight")
                h.Name = "HL_" .. i
                h.Enabled = false
                h.Parent = game:GetService("Lighting")
                pool[i] = h
            end
            _G._HLPool = pool
        end },

        { Name = "整理内存", Run = function()
            collectgarbage("step")
        end },
    },
})
```

### 行为说明

| 项 | 说明 |
|---|---|
| 执行顺序 | 按 `Tasks` 数组顺序，逐个执行 |
| 进度计算 | `已完成数 / 总数`，每个任务完成立刻推进 |
| 错误处理 | 单个任务报错不会中断，只 `warn` 一条 |
| 超时保护 | 最多等 15 秒，超时强制继续 |
| 最短停留 | 全部完成后至少 0.3 秒，避免一闪而过 |
| 关闭时 | 不传 `RealLoading` 或传 `false` → 走默认装饰动画 |

### 关闭真实加载

```lua
-- 只想要装饰动画
local win = UI.Create({
    Title = "控制面板",
    -- 不传 RealLoading，或传 false
})
```

### 动态切换

```lua
local USE_REAL = true   -- 改这里控制

local win = UI.Create({
    Title = "控制面板",
    RealLoading = USE_REAL,
    Tasks = USE_REAL and buildTasks() or nil,
})
```

### 常见预热任务

| 任务 | 作用 |
|---|---|
| 扫描场景容器 | 缓存 `Workspace.Characters` 等，避免首次透视遍历整棵树 |
| 预热高亮池 | 预建 `Highlight` 实例，首次透视直接复用 |
| 预热音频池 | 预建 `Sound` 实例，避免每次播放都 `Instance.new` |
| 缓存运行环境 | 预读 `CurrentCamera` / `LocalPlayer.Character` |
| 预热雷达点 | 预建雷达小点 Frame |
| 整理内存 | `collectgarbage("step")` 减少运行时卡顿 |

---

## Window 方法

| 方法 | 说明 |
|---|---|
| `win:Tab(name)` | 新建 Tab，返回 Tab 对象 |
| `win:SelectTab(i, instant)` | 切到第 i 个 Tab（`instant=true` 不播动画）|
| `win:SetVisible(bool)` | 显示 / 隐藏面板 |
| `win:Toggle()` | 切换显示状态 |
| `win:Notify(text, sec)` | 弹一条提示（默认 2 秒）|
| `win:Destroy()` | 销毁面板（自动断开所有连接）|

```lua
win:Notify("已启用", 1.5)
win:SetVisible(false)
win:Toggle()
```

---

## 状态读写

`win.State[key]` 是唯一数据源。控件改动会写回这里。

| 方法 | 说明 |
|---|---|
| `win:Get(key)` | 读当前值 |
| `win:Set(key, value)` | 设置值 + 重绘 + **触发回调** |
| `win:SetSilent(key, value)` | 设置值 + 重绘，**不触发回调** |
| `win:SetMany({k1=v1, k2=v2})` | 批量设置 |
| `win:RepaintAll()` | 把 State 全量同步到控件 |

```lua
-- 读
local enabled = win:Get("esp")

-- 写（会触发 Callback）
win:Set("esp", true)

-- 写（不触发 Callback，用于初始化）
win:SetSilent("esp", true)

-- 批量
win:SetMany({ esp = true, aimbot = false })
```

**什么时候用 `SetSilent`**：加载配置时，不想触发一堆副作用回调。

---

## 控件参考

### Toggle 开关

右侧勾选框，最常用的开关。

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `Key` | string | ✅ | 状态键名 |
| `Name` | string | ✅ | 显示名 |
| `Desc` | string | | 副标题 |
| `Default` | bool | | 默认值 |
| `Callback` | function(v) | | 变化时调用 |

```lua
tab:Toggle({
    Key = "esp",
    Name = "透视",
    Desc = "显示敌人轮廓",
    Default = false,
    Callback = function(v) print("透视 =", v) end,
})
```

### Slider 滑条

拖动条，手机端热区自动加宽到 44px。

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `Key` | string | ✅ | 状态键名 |
| `Name` | string | ✅ | 显示名 |
| `Desc` | string | | 副标题 |
| `Min` | number | | 最小值（默认 0）|
| `Max` | number | | 最大值（默认 100）|
| `Default` | number | | 默认值 |
| `Step` | number | | 步进（默认 1）|
| `Callback` | function(v) | | 变化时调用 |

```lua
tab:Slider({
    Key = "fov",
    Name = "视野",
    Desc = "调整相机视野",
    Min = 70,
    Max = 120,
    Default = 90,
    Step = 1,
    Callback = function(v) print("FOV =", v) end,
})
```

### Cycle 循环切换

点一下切到下一个选项。

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `Key` | string | ✅ | 状态键名 |
| `Name` | string | ✅ | 显示名 |
| `Desc` | string | | 副标题 |
| `Options` | table | ✅ | 选项数组 |
| `Default` | any | | 默认值 |
| `Callback` | function(v) | | 变化时调用 |

```lua
tab:Cycle({
    Key = "theme",
    Name = "主题",
    Options = { "暗色", "亮色", "自动" },
    Default = "暗色",
    Callback = function(v) print("主题 =", v) end,
})
```

### Input 文本输入

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `Key` | string | ✅ | 状态键名 |
| `Name` | string | ✅ | 显示名 |
| `Desc` | string | | 副标题 |
| `Default` | string | | 默认值 |
| `Placeholder` | string | | 占位提示 |
| `Callback` | function(text) | | 提交时调用 |

```lua
tab:Input({
    Key = "webhook",
    Name = "Webhook",
    Desc = "粘贴地址",
    Placeholder = "https://...",
    Callback = function(text) print("输入 =", text) end,
})
```

### Expand 展开分组

可展开的容器，展开 / 收起带高度动画。

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `Key` | string | ✅ | 状态键名 |
| `Name` | string | ✅ | 显示名 |
| `Desc` | string | | 副标题 |
| `Default` | bool | | 是否默认展开 |
| `Callback` | function(v) | | 展开/收起时调用 |
| `Children` | table | | 子控件数组 |

```lua
tab:Expand({
    Key = "advanced",
    Name = "高级设置",
    Desc = "展开查看更多",
    Default = false,
    Callback = function(v) print("展开 =", v) end,
    Children = {
        -- 子控件，见下一节
    },
})
```

### Section 分组标题

纯视觉分隔，无交互。

```lua
tab:Section("基础设置")
```

### Label 纯文本

| 参数 | 类型 | 说明 |
|---|---|---|
| `Name` | string | 主文字 |
| `Desc` | string | 副文字 |

```lua
tab:Label({
    Name = "提示",
    Desc = "这是一段说明文字",
})
```

### Divider 分隔线

```lua
tab:Divider()
```

### ClickableRow 可点行

整行可点击，常用于「打开子面板」。

| 参数 | 类型 | 说明 |
|---|---|---|
| `Name` | string | 主文字 |
| `Desc` | string | 副文字 |
| `Callback` | function() | 点击时调用 |

```lua
tab:ClickableRow({
    Name = "打开设置",
    Desc = "点击进入",
    Callback = function() print("点了") end,
})
```

### RowButton 行内按钮

行内右侧带一个按钮。

| 参数 | 类型 | 说明 |
|---|---|---|
| `Name` | string | 主文字 |
| `Desc` | string | 副文字 |
| `ButtonText` | string | 按钮文字 |
| `Callback` | function() | 点击时调用 |

```lua
tab:RowButton({
    Name = "重置",
    Desc = "恢复默认值",
    ButtonText = "执行",
    Callback = function() print("重置了") end,
})
```

### Dropdown 下拉选择

点开弹出一列选项，选中后收起。

| 参数 | 类型 | 说明 |
|---|---|---|
| `Key` | string | 状态键名 |
| `Name` | string | 显示名 |
| `Desc` | string | 副标题 |
| `Options` | table | 选项数组 |
| `Default` | string | 默认选中项 |
| `Multi` | bool | 是否多选 |
| `ButtonWidth` | number | 按钮宽度（默认 150）|
| `Callback` | function(v) | 选中时调用 |

```lua
-- 单选
tab:Dropdown({
    Key = "mode",
    Name = "模式",
    Options = { "普通", "精准", "狂暴" },
    Default = "普通",
    Callback = function(v) print("选了", v) end,
})

-- 多选
tab:Dropdown({
    Key = "features",
    Name = "功能",
    Options = { "透视", "自瞄", "加速" },
    Multi = true,
    Default = { "透视" },
    Callback = function(list)
        for _, v in ipairs(list) do print(v) end
    end,
})
```

### Keybind 按键绑定

点一下进入监听状态，按下任意键即绑定。按 Esc 取消。

| 参数 | 类型 | 说明 |
|---|---|---|
| `Key` | string | 状态键名 |
| `Name` | string | 显示名 |
| `Desc` | string | 副标题 |
| `Default` | string \| Enum.KeyCode | 默认按键 |
| `Callback` | function(keyCode) | 绑定时调用 |

```lua
tab:Keybind({
    Key = "aimKey",
    Name = "自瞄按键",
    Desc = "按住此键启用自瞄",
    Default = Enum.KeyCode.Q,
    Callback = function(kc) print("绑定到", kc) end,
})
```

### MultiSelect 多选

一组小按钮，可同时选中多个。

| 参数 | 类型 | 说明 |
|---|---|---|
| `Key` | string | 状态键名 |
| `Name` | string | 显示名 |
| `Desc` | string | 副标题 |
| `Options` | table | 选项数组 |
| `Default` | table | 默认选中的项 |
| `Callback` | function(list) | 变化时调用 |

```lua
tab:MultiSelect({
    Key = "features",
    Name = "功能",
    Options = { "透视", "自瞄", "加速" },
    Default = { "透视" },
    Callback = function(list)
        for _, v in ipairs(list) do print(v) end
    end,
})
```

### ColorPicker 取色器

| 参数 | 类型 | 说明 |
|---|---|---|
| `Key` | string | 状态键名 |
| `Name` | string | 显示名 |
| `Desc` | string | 副标题 |
| `Default` | Color3 | 默认颜色 |
| `Callback` | function(color) | 变化时调用 |

```lua
tab:ColorPicker({
    Key = "espColor",
    Name = "透视颜色",
    Default = Color3.fromRGB(255, 80, 80),
    Callback = function(c) print(c) end,
})
```

### TextBox 文本框

多行文本输入，适合粘贴长内容。

```lua
tab:TextBox({
    Key = "notes",
    Name = "备注",
    Placeholder = "输入多行文本...",
    Callback = function(text) end,
})
```

### Progress 进度条

只读进度显示。

```lua
local bar = tab:Progress({
    Key = "loadProgress",
    Name = "加载进度",
    Max = 100,
    Value = 0,
})
bar.Set(45)
```

### Buttons 按钮组

一行里放多个按钮。

```lua
tab:Buttons({
    Name = "快捷操作",
    Buttons = {
        { Text = "保存", Callback = function() end },
        { Text = "重置", Callback = function() end },
    },
})
```

### Paragraph 段落

多行文字块，适合放说明。

| 参数 | 类型 | 说明 |
|---|---|---|
| `Name` | string | 标题（可选）|
| `Text` | string | 正文 |
| `Height` | number | 高度（不填自动算）|

```lua
tab:Paragraph({
    Name = "使用说明",
    Text = "第一行\n第二行\n第三行",
})
```

### Space 间隔

纯间距，用于分组留白。

```lua
tab:Space(16)          -- 16px 间隔
tab:Space({ Height = 24 })
```

### Custom 自定义行

用库的标准行样式（标题/描述/圆角/悬浮/箭头），内容区自己画。这是给非标准控件用的入口。

| 参数 | 类型 | 说明 |
|---|---|---|
| `Key` | string | 状态键名 |
| `Name` | string | 显示名 |
| `Desc` | string | 副标题 |
| `Height` | number | 展开后内容区高度 |
| `Arrow` | bool | 是否显示箭头（默认 true）|
| `Builder` | function(inner, ctx) | 绘制内容 |

```lua
local ctrl = tab:Custom({
    Key = "myWidget",
    Name = "自定义控件",
    Desc = "点击箭头展开",
    Height = 200,
    Builder = function(inner, ctx)
        -- inner 是一块空白 Frame，在里面自由绘制
        local label = Instance.new("TextLabel")
        label.Size = UDim2.fromScale(1, 1)
        label.BackgroundTransparency = 1
        label.Text = "自定义内容"
        label.TextColor3 = CD.Theme.text
        label.Parent = inner
    end,
})

ctrl.Expand(true)      -- 展开
ctrl.Set(true)         -- 展开（不播动画）
ctrl.Get()             -- 读状态
ctrl.Inner             -- 内容容器
ctrl.Child             -- 子容器（含背景/竖条）
```

---

## 子控件（Expand 内部）

`Children` 数组里每一项用 `Kind` 区分类型。

### Kind = toggle

```lua
{ Kind = "toggle",
  Key = "sub1",
  Name = "子开关",
  Default = true,
  Callback = function(v) end }
```

### Kind = action

点击式按钮。外观位置和勾选框一样，但**没有开关状态**，点击只触发回调，点完自己不变。

```lua
{ Kind = "action",
  Key  = "resetPos",
  Name = "重置位置",
  IconImage = "rbxassetid://112173305232811",   -- 图片图标（可选）
  IconColor = Color3.fromRGB(220, 225, 235),    -- 图标颜色（可选）
  Icon = "↻",                                   -- 没有图片时的文字图标
  OnClick = function() end }
```

| 参数 | 类型 | 说明 |
|---|---|---|
| `Key` | string | 状态键名 |
| `Name` | string | 显示名 |
| `IconImage` | string | 图片图标 assetid（优先）|
| `IconColor` | Color3 | 图标染色 |
| `Icon` | string | 文字图标（无图片时用）|
| `OnClick` | function() | 点击时调用 |
| `Callback` | function(true) | 兼容写法，等同 OnClick |

说明：

- `IconImage` 优先级高于 `Icon`
- 图标居中显示，无背景框、无边框、悬停不变色
- 点击热区比图标大一圈（PC 30px / 手机 38px）
- 点击时图标短暂变暗作为反馈
- 图标库：[Footagesus/Icons](https://github.com/Footagesus/Icons)
  - 例：lucide 的 `fingerprint` = `rbxassetid://112173305232811`

### Kind = slider

```lua
{ Kind = "slider",
  Key = "speed",
  Name = "速度",
  Min = 1, Max = 100, Default = 50, Step = 1,
  Callback = function(v) end }
```

### Kind = input

```lua
{ Kind = "input",
  Key = "name",
  Name = "名称",
  Default = "",
  Placeholder = "输入...",
  Callback = function(text) end }
```

### Kind = cycle

```lua
{ Kind = "cycle",
  Key = "mode",
  Name = "模式",
  Options = { "A", "B", "C" },
  Default = "A",
  Callback = function(v) end }
```

---

## 连接管理

全库有近百处 `:Connect`，如果不统一管理，重载时会残留大量连接，导致「重载后行为异常」这类怪 bug。

| 方法 | 说明 |
|---|---|
| `UI.AddSignal(owner, conn)` | 登记一条连接（`owner=nil` 表示全局）|
| `UI.DisconnectAll(owner)` | 断开某个 owner 的所有连接 |
| `UI.DisconnectEverything()` | 断开全库所有登记的连接 |
| `UI.GetSignalStats()` | 返回 `{ total, owners }`（调试用）|

`Window:Destroy()` 会自动调用 `DisconnectAll(self)`。

### 用法

```lua
local win = UI.Create({ Title = "面板" })

-- 自己的连接也登记进去，销毁时自动清理
local conn = game:GetService("RunService").Heartbeat:Connect(function()
    -- 每帧逻辑
end)
UI.AddSignal(win, conn)
```

卸载时：

```lua
UI.DisconnectEverything()
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

**注意**：这个变量要在 `loadstring` 之前设置才生效。

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
| HUD 字号 | 17 / 18 | 20 / 22 |

---

## 主题定制

```lua
UI.Theme            -- 当前主题表（可直接改字段）
UI.Layout           -- 布局尺寸表
UI.Size             -- 控件尺寸表
```

### 改主题

```lua
UI.Theme.accent = Color3.fromRGB(120, 200, 255)
UI.Theme.panel  = Color3.fromRGB(18, 18, 22)
```

**注意**：主题要在 `UI.Create` **之前**改才生效。

### 常用字段

| 字段 | 说明 |
|---|---|
| `Theme.panel` | 面板底色 |
| `Theme.row` | 行底色 |
| `Theme.rowChild` | 子行底色 |
| `Theme.accent` | 强调色 |
| `Theme.accentBar` | 左侧竖条色 |
| `Theme.text` | 主文字色 |
| `Theme.textDim` | 次要文字色 |
| `Theme.box` | 勾选框底色 |
| `Theme.boxStroke` | 勾选框描边色 |

---

## 性能选项

```lua
UI.LowSpecMode      -- 低配模式（跳过装饰性描边）
UI.SetLowSpec(bool) -- 开关低配模式
```

低配设备上跳过 `UIStroke` 等装饰性描边，减少渲染开销：

```lua
UI.SetLowSpec(true)
```

---

## 错误处理

所有用户回调都经过 `UI.safeCall` 隔离，单个回调报错不会中断整个 UI。

```lua
UI.GetErrorStats()   -- 返回 { count = 累计错误数, last = 最后一条错误 }
UI.ClearErrors()     -- 清空错误统计
```

错误信息只在控制台提示前 3 次，避免刷屏：

```
[CDMUI] Callback error: ...
```

---

## 通知与对话框

### UI.Notify 通知

右上角堆叠提示，自动消失。

| 参数 | 类型 | 说明 |
|---|---|---|
| `text` | string | 提示内容 |
| `opts.Duration` | number | 显示时长（默认 3 秒）|
| `opts.Type` | string | `info` / `success` / `warn` / `error` |

```lua
UI.Notify("已启用透视", { Duration = 2, Type = "success" })
UI.Notify("找不到目标", { Type = "warn" })
UI.Notify("操作失败", { Type = "error" })
```

### UI.Dialog 对话框

模态对话框，带遮罩和按钮。

| 参数 | 类型 | 说明 |
|---|---|---|
| `Title` | string | 标题 |
| `Text` | string | 正文 |
| `Buttons` | table | 按钮数组 |
| `Callback` | function(i, label) | 点按钮时调用 |

```lua
UI.Dialog({
    Title = "确认",
    Text = "确定要重置所有设置吗？",
    Buttons = { "取消", "确定" },
    Callback = function(i, label)
        if i == 2 then print("确定") end
    end,
})
```

按钮可以带独立回调：

```lua
UI.Dialog({
    Title = "选择操作",
    Text = "请选择",
    Buttons = {
        { Text = "重置", Callback = function() print("重置") end },
        { Text = "关闭" },
    },
})
```

---

## 卡片

### Window:Card 独立卡片

浮在面板上的独立卡片，不属于任何 Tab。

| 参数 | 类型 | 说明 |
|---|---|---|
| `Title` | string | 标题 |
| `Text` | string | 正文 |
| `Width` | number | 宽（默认 280）|
| `Height` | number | 高（默认 140）|
| `Position` | UDim2 | 位置 |
| `Closable` | bool | 是否显示关闭按钮（默认 true）|

```lua
local card = win:Card({
    Title = "提示",
    Text = "这是一张独立卡片",
    Width = 300,
    Height = 160,
})
```

---

## 依赖系统

子控件可以依赖某个开关：开关关掉时自动隐藏。这是 Linoria / Obsidian 的核心特性。

```lua
-- 先建主开关
tab:Toggle({ Key = "aimbot", Name = "自瞄" })

-- 建子控件
local rangeRow = tab:Slider({ Key = "aimRange", Name = "范围", Min = 10, Max = 500 })
local smoothRow = tab:Slider({ Key = "aimSmooth", Name = "平滑", Min = 1, Max = 100 })

-- 绑定依赖：aimbot 关掉时，这两行自动隐藏
win:AddDependency("aimbot", { rangeRow.Frame, smoothRow.Frame })
```

### 特性

- 主开关变化时自动显隐
- `Set` / `SetSilent` 都会触发
- 支持传单个 Frame 或 Frame 数组
- 切页后状态保持

---

## 配置存储

把 State 序列化存文件，下次进游戏自动恢复。

```lua
-- 保存
win:SaveConfig("myconfig")

-- 加载
win:LoadConfig("myconfig")
```

### 说明

- 存储路径：`CDMUI/myconfig.json`
- 只序列化基础类型（bool / number / string / table）
- 跳过 Color3、Enum 等不可序列化的值
- 依赖执行器支持 `writefile` / `readfile` / `isfile` / `makefolder`

### 配合依赖系统

```lua
-- 加载后依赖状态也会同步刷新
win:LoadConfig("myconfig")
```

---

## Tooltip

给任意控件加悬浮提示。

```lua
local btn = tab:RowButton({ Name = "重置", ButtonText = "执行" })
UI.Tooltip(btn.Frame, "点击后恢复所有默认设置", { Width = 220 })
```

| 参数 | 类型 | 说明 |
|---|---|---|
| `target` | Instance | 触发提示的控件 |
| `text` | string | 提示内容 |
| `opts.Width` | number | 提示框宽度（默认 200）|

返回 `{ Show(), Hide() }` 可手动控制。

---

## 搜索

给顶栏加搜索框，实时过滤当前 Tab 的行。

```lua
win:EnableSearch("搜索功能...")
```

搜索框会匹配每行的 `Name` 文字，不匹配的行自动隐藏。

---

## 常见问题

### Q：面板打开后鼠标没解锁？

检查 `AutoUnlockMouse` 是否为 `true`。如果用了自定义鼠标锁定逻辑，可以设 `AutoUnlockMouse = false` 自己管理。

### Q：手机上控件太小点不中？

库已自动适配。如果仍觉得小，可以改 `UI.Size` 里的尺寸表，或强制手机模式：

```lua
_G._CDMUIMobileOverride = true
local UI = loadstring(...)()
```

### Q：重载脚本后面板行为异常？

用 `UI.DisconnectEverything()` 清干净再重载：

```lua
if getgenv().CDMUI then
    pcall(getgenv().CDMUI.DisconnectEverything)
end
if _G._CDMUIWin then
    pcall(function() _G._CDMUIWin:Destroy() end)
end
```

### Q：HUD 行显示了但没数据？

数据每 0.15 秒刷新一次，首次显示可能延迟。如果一直没数据，检查是否被其他 UI 遮挡。

### Q：HUD 四角变形了？

四角用 Slice 贴图，高度变化时会拉伸。库已把高度固定来避免。如果要改高度，记得同时调 `UI.SetHUDStyle({ sliceCenter = ... })` 让切分点适配。

---

## 版本历史

| 版本 | 变更 |
|---|---|
| 2.3.4 | 修复拖动后停住再松手仍有惯性 |
| 2.3.3 | 修复首次加载时行悬停高亮残留 |
| 2.3.2 | 行文字右侧预留空间，不被按钮遮挡 |
| 2.3.1 | 描述文字支持自动换行（最多 3 行）|
| 2.3.0 | 加载动画支持真实任务（RealLoading + Tasks）|
| 2.2.1 | WaitForIntro 分两阶段等待（先等开始再等结束）|
| 2.2.0 | Tab 悬停高亮接入刷新系统；导出入场状态 API |
| 2.1.2 | 导出 UI.PlayClick（自定义控件可复用音效）|
| 2.1.1 | Custom 注册切页恢复器；动画参数对齐 Expand |
| 2.1.0 | 新增依赖系统 / 配置存储 / Tooltip（对齐主流 UI 库）|
| 2.0.0 | 完善预设体系：清理重复定义，新增 Custom/Paragraph/Space/Card，导出 Layout |
| 1.9.7 | 移除 Body2D（游戏专属）；文档更新 |
| 1.9.6 | 移除 HUD（改为独立模块）；新增 Dropdown / Keybind / Notify / Dialog / Search |
| 1.9.5 | HUD 行高修正（总高精确等于框高）|
| 1.9.4 | HUD 间隙 8px、字号加大 |
| 1.9.3 | HUD 行显隐修复（syncRow 无条件设 true）|
| 1.9.2 | HUD 位置可动态跟随外部参照；PC/手机双模式 |
| 1.9.1 | 统一连接管理（AddSignal / DisconnectAll）|
| 1.9.0 | 新增 HUD 浮层与 action 控件；子项悬浮高亮 |
| 1.8.5 | 滑块热区优化、鼠标恢复修复 |
| 1.6.0 | 基础控件齐全 |

---

## 许可

MIT
