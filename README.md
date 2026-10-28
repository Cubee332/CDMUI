# CDMUI

Roblox 控制面板 UI 库。单文件，无依赖，支持 PC 和移动端。

提供 19 种控件，覆盖开关、滑条、下拉、展开分组、人体图选择等常见需求。内置入场/退出动画、点击音效、鼠标锁定管理，以及重载时的自动清理。

五行代码可以起一个能用的面板。

```lua
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Cubee332/CDMUI/main/CDMUI.lua"))()

local win = UI.Create({ Title = "面板" })
local tab = win:Tab("基础")

tab:Toggle({ Key = "k", Name = "开关", Callback = function(v) print(v) end })
```

---

## 目录

- [安装](#安装)
- [创建窗口](#创建窗口)
- [Window 方法](#window-方法)
- [控件参考](#控件参考)
  - [Toggle 开关](#toggle-开关)
  - [Slider 滑条](#slider-滑条)
  - [Cycle 循环切换](#cycle-循环切换)
  - [Input 数字输入](#input-数字输入)
  - [Keybind 按键绑定](#keybind-按键绑定)
  - [MultiSelect 多选](#multiselect-多选)
  - [Expand 可展开分组](#expand-可展开分组)
  - [Body2D 人体部位选择](#body2d-人体部位选择)
  - [Dropdown 下拉](#dropdown-下拉)
  - [ColorPicker 颜色](#colorpicker-颜色)
  - [TextBox 文本框](#textbox-文本框)
  - [Progress 进度条](#progress-进度条)
  - [Section / Label / Divider](#sectionlabeldivider)
  - [Buttons 按钮行](#buttons-按钮行)
  - [ClickableRow / RowButton](#clickablerowrowbutton)
- [控件对象](#控件对象)
- [主题自定义](#主题自定义)
- [动画与错误处理](#动画与错误处理)
- [热重载](#热重载)
- [注意事项](#注意事项)
- [参数速查表](#参数速查表)
- [常见问题](#常见问题)
- [调试](#调试)
- [销毁与清理](#销毁与清理)
- [移动端适配](#移动端适配)
- [版本历史](#版本历史)
- [许可](#许可)

---

## 安装

提供三种加载方式。

**远程加载**：

```lua
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Cubee332/CDMUI/main/CDMUI.lua"))()
```

**本地文件**，将 `CDMUI.lua` 放入执行器 workspace：

```lua
local UI = loadstring(readfile("CDMUI.lua"))()
```

**锁定版本**，指定 commit 可避免上游更新带来的行为变化：

```lua
local URL = "https://raw.githubusercontent.com/Cubee332/CDMUI/77fb1434/CDMUI.lua"
local UI = loadstring(game:HttpGet(URL))()
```

注意：`loadstring` 返回的是函数，需要加 `()` 调用才能得到 UI 表。

---

## 创建窗口

```lua
local win = UI.Create({
    Title = "我的面板",        -- 顶部大标题
    TopbarText = "打开面板",   -- 左上角按钮文字
    AutoOpen = true,           -- 创建后直接显示
    TopbarButton = true,       -- 要不要生成顶栏按钮
})
```

能传的参数就这几个：

| 参数 | 默认值 | 说明 |
|---|---|---|
| `Title` | `"控制面板"` | 顶部标题 |
| `TopbarText` | 同 Title | 顶栏按钮文字 |
| `AutoOpen` | `true` | 创建后自动显示 |
| `AutoUnlockMouse` | `true` | 打开时解锁鼠标 |
| `TopbarButton` | `true` | 是否生成顶栏按钮 |
| `GuiName` | `"ControlPanelUI"` | ScreenGui 名字，调试用 |
| `DisplayOrder` | `101` | 显示层级 |

---

## Window 方法

```lua
win:Tab("基础")              -- 新建分页
win:SelectTab(2)             -- 切到第二页
win:SelectTab(2, true)       -- 切页但不播动画
win:SetVisible(false)        -- 隐藏面板
win:Toggle()                 -- 开关面板
win:Notify("搞定了", 3)      -- 弹个提示，3 秒
win:Destroy()                -- 销毁
```

状态读写：

```lua
win:Get("key")               -- 读
win:Set("key", value)        -- 写 + 重绘 + 触发回调
win:SetSilent("key", value)  -- 写 + 重绘，不触发回调
win:SetMany({ a = 1, b = 2 })-- 批量写
win:RepaintAll()             -- 把 State 全量刷到界面
```

`win.State` 是唯一数据源，控件显示始终从它渲染，避免逻辑状态与界面不一致。

`Set` 会触发回调，`SetSilent` 不会。做功能互斥时用 `SetSilent`，可避免相互触发的死循环。

---

## 控件参考

所有控件都挂在 `tab` 上。通用的三个字段是 `Key`、`Name`、`Desc`，下面就不重复写了。

### Toggle 开关

```lua
tab:Toggle({
    Key = "esp",
    Name = "透视",
    Desc = "显示所有敌人",
    Default = false,
    Callback = function(v)
        print("透视 =", v)
    end,
})
```

### Slider 滑条

```lua
tab:Slider({
    Key = "speed",
    Name = "速度倍率",
    Min = 1, Max = 10, Default = 2,
    Callback = function(v) print("倍率 =", v) end,
})
```

### Cycle 循环切换

```lua
tab:Cycle({
    Key = "mode",
    Name = "锁定模式",
    Options = { "最近", "最高", "360°" },
    DefaultIndex = 1,
    Callback = function(idx, text)
        print("选了", idx, text)
    end,
})
```

回调第一个参数是索引数字，第二个才是文字。写成 `function(text)` 会拿到数字。

默认值必须用 `DefaultIndex`，写 `Default` 无效，界面会始终显示第一项。

### Input 数字输入

```lua
tab:Input({
    Key = "fov",
    Name = "FOV 半径",
    Default = "200",
    Min = 10, Max = 1000,
    Callback = function(v) print("FOV =", v) end,
})
```

回调收到的是**字符串**，需要数字时自行 `tonumber`。

### Keybind 按键绑定

```lua
tab:Keybind({
    Key = "hotkey",
    Name = "快捷键",
    Default = Enum.KeyCode.F,
    Callback = function(code) print("按了", code.Name) end,
})
```

### MultiSelect 多选

```lua
tab:MultiSelect({
    Key = "targets",
    Name = "目标类型",
    Options = { "普通怪", "精英怪", "BOSS" },
    Default = { "普通怪" },
    Callback = function(list)
        for _, v in ipairs(list) do print(v) end
    end,
})
```

### Expand 可展开分组

一个主开关带多个子选项：

```lua
tab:Expand({
    Key = "magic",
    Name = "魔法子弹",
    Desc = "子弹自动追踪",
    Default = false,
    Callback = function(v) print("魔法子弹 =", v) end,

    -- 可选：右边放个切换按钮
    Cycle = {
        Key = "magic_mode",
        Options = { "准星", "360°" },
        DefaultIndex = 1,
        Callback = function(idx) print("模式 =", idx) end,
    },

    Children = {
        { Kind = "toggle", Key = "mb_box", Name = "显示头框", Default = true,
          Callback = function(v) print("头框 =", v) end },

        { Kind = "number", Key = "mb_dist", Name = "最大距离",
          Min = 10, Max = 500, Default = 200,
          Callback = function(v) print("距离 =", v) end },

        { Kind = "cycle", Key = "mb_part", Name = "锁定部位",
          Options = { "头", "身体" }, DefaultIndex = 1,
          Callback = function(idx) print("部位 =", idx) end },

        { Kind = "slider", Key = "mb_alpha", Name = "透明度",
          Min = 0, Max = 100, Default = 50,
          Callback = function(v) print("透明 =", v) end },
    },
})
```

子项的 `Kind` 必须写，支持 `toggle`、`number`、`cycle`、`slider` 四种。漏写或写错不会报错，但子项不会显示。

### Body2D 人体部位选择

```lua
tab:Body2D({
    Key = "aim_part",
    Name = "锁定部位",
    Desc = "点小人选身体部位",
    Default = 1,
    Callback = function(idx) print("选了部位", idx) end,

    Parts = {
        { Key = 1, Name = "头部" },
        { Key = 2, Name = "躯干" },
        { Key = 3, Name = "左臂" },
        { Key = 4, Name = "右臂" },
        { Key = 5, Name = "左腿" },
        { Key = 6, Name = "右腿" },
    },
})
```

默认收起，点击标题行展开。比例按 R6：头 60×60、躯干 90×90、四肢 45×90。

### Dropdown 下拉

```lua
tab:Dropdown({
    Key = "profile",
    Name = "配置",
    Options = { "默认", "激进", "保守" },
    Default = "默认",
    Callback = function(v) print("配置 =", v) end,
})
```

### ColorPicker 颜色

```lua
tab:ColorPicker({
    Key = "color",
    Name = "颜色",
    Default = Color3.fromRGB(255, 100, 100),
    Callback = function(c) print("颜色", c) end,
})
```

### TextBox 文本框

```lua
tab:TextBox({
    Key = "name",
    Name = "名字",
    Default = "",
    Callback = function(text) print("输入了", text) end,
})
```

### Progress 进度条

```lua
local p = tab:Progress({ Name = "加载进度", Value = 0, Max = 100 })
p.Set(50)   -- 更新到 50%
```

### Section、Label、Divider

三个纯展示的：

```lua
tab:Section({ Name = "战斗" })       -- 分组标题
tab:Label({ Name = "提示", Desc = "说明文字" })
tab:Divider()                        -- 一条横线
```

### Buttons 按钮行

```lua
tab:Buttons({
    Buttons = {
        { Name = "保存", Callback = function() print("保存") end },
        { Name = "重置", Callback = function() print("重置") end },
    },
})
```

### ClickableRow、RowButton

整行可点，适合做"打开某某"的入口：

```lua
tab:ClickableRow({
    Name = "打开设置",
    Desc = "进入详细配置",
    Arrow = true,
    Callback = function() print("点了") end,
})

tab:RowButton({
    Name = "立即执行",
    Callback = function() print("执行") end,
})
```

---

## 控件对象

每个控件都会登记到 `tab.Rows[Key]`，可以后面再操作：

```lua
tab.Rows.esp.Set(true)          -- 设置值，会触发回调
tab.Rows.esp.SetSilent(true)    -- 只改界面，不触发
local v = tab.Rows.esp.Get()    -- 读值
```

功能互斥示例，A 打开时关闭 B：

```lua
tab:Toggle({
    Key = "a", Name = "功能A",
    Callback = function(v)
        if v and win.State.b then
            tab.Rows.b.SetSilent(false)   -- 界面关掉
            win.State.b = false            -- 逻辑也关掉
        end
    end,
})
```

---

## 主题自定义

在 `UI.Create` 之前改这些：

```lua
UI.Theme.panel   = Color3.fromRGB(15, 15, 18)
UI.Theme.accent  = Color3.fromRGB(0, 170, 255)
UI.Layout.panelH = 600
UI.Size.radius   = 6
```

常用的几个字段：

`UI.Theme` 里是颜色，`panel`（面板底）、`row`（行底）、`rowHover`（悬停）、`text`（主文字）、`textDim`（次要文字）、`accent`（强调色）、`ctrl`（控件底）、`ctrlStroke`（控件描边）。

`UI.Layout` 是尺寸，`panelW`、`panelH`、`rowH`、`tabHeight`、`childH`。

`UI.Size` 是圆角，`radius`、`radiusRow`、`checkbox`。

---

## 动画与错误处理

动画接口：

```lua
UI.Anim.to(inst, props, dur, style, dir, delay)   -- 补间
UI.Anim.cancel(inst)                               -- 取消该实例所有动画
UI.Anim.snap(inst, props)                          -- 直接设到终态
```

`Anim.to` 会自动取消同一实例同一属性上未完成的旧动画，避免动画冲突。

错误隔离：

```lua
UI.safeCall(fn, ...)     -- 安全调用，出错不中断 UI
UI.GetErrorStats()       -- 看错误统计
UI.ClearErrors()         -- 清空
```

所有控件回调都经过 `safeCall`，单个功能出错不会影响面板其余部分。

---

## 热重载

重复 `loadstring` 是安全的，会自动完成以下步骤：

播放退出动画（面板与顶栏按钮淡出）→ 等待动画结束 → 创建新面板 → 断开所有连接并还原鼠标 hook。

手动清理：

```lua
if _G._CDMUILastCleanup then _G._CDMUILastCleanup() end
```

---

## 注意事项

以下均为实际遇到过的问题，接入新脚本时请对照检查。

**Cycle 的回调第一个参数是索引，不是文字。**

```lua
-- 对的
Callback = function(idx, text) end

-- 错的，text 拿到的是数字
Callback = function(text) end
```

**Expand 子项必须写 Kind。** 支持 `toggle`、`cycle`、`number`、`slider` 四种。漏写的话子项不报错也不显示，很难查。

```lua
-- 对的
{ Kind = "toggle", Key = "c1", Name = "开关", Callback = fn }

-- 错的，会静默消失
{ Key = "c1", Name = "开关", Callback = fn }
```

**Cycle 子项的默认值要用 DefaultIndex。** 写 `Default` 是无效的，界面永远显示第一项。

```lua
-- 对的
{ Kind = "cycle", Options = {"A","B"}, DefaultIndex = 2 }

-- 错的
{ Kind = "cycle", Options = {"A","B"}, Default = 2 }
```

**Body2D 默认收起。** 点标题行或者箭头才展开。`Callback` 收到的是选中的 Key（数字）。

**自己做按钮的话用 bindTap。** 直接连 `MouseButton1Click` 是没音效的。

```lua
bindTap(btn, function() ... end)              -- 有音效
btn.MouseButton1Click:Connect(function() end) -- 没音效
```

**外部同步界面用 SetSilent。** 用 `Set` 会触发回调，容易递归。

```lua
win:SetSilent("key", value)   -- 只改界面
win:Set("key", value)         -- 改界面 + 触发回调
```

**反复重载没问题。** `cleanup` 会断开连接、播动画、延迟销毁，还会把临时钩子还原。

**鼠标 hook 是全局单例。** 用引用计数管理，最后一个窗口销毁时才真正卸载 `__newindex`。

**别动这几个内部状态。**

```lua
_G._CDMUILastCleanup
_G._CDMUILiveWindows
_G._CDMUIRunGen
```

要清理就调 `win:Destroy()`。

**同一个 Tab 里 Key 不能重复。** 重复会打警告，然后后者覆盖前者。不同 Tab 之间可以同名。

---

## 参数速查表

所有控件都吃 `Key`、`Name`、`Desc` 这三个通用字段，下面只列专属的。

| 控件 | 专属参数 | 回调 |
|---|---|---|
| Toggle | `Default` | `(bool)` |
| Slider | `Min`, `Max`, `Default` | `(number)` |
| Cycle | `Options`, `DefaultIndex` | `(idx, text)` |
| Input | `Default`, `Min`, `Max` | `(string)` |
| Keybind | `Default` | `(keyCode)` |
| MultiSelect | `Options`, `Default` | `(table)` |
| Expand | `Default`, `Children`, `Cycle` | `(bool)` |
| Body2D | `Default`, `Parts` | `(idx)` |
| Dropdown | `Options`, `Default` | `(string)` |
| ColorPicker | `Default` | `(Color3)` |
| TextBox | `Default` | `(string)` |
| Progress | `Value`, `Max` | — |
| Section | 只有 `Name` | — |
| Label | `Name`, `Desc` | — |
| Divider | 无 | — |
| Buttons | `Buttons` | 各自 `()` |
| ClickableRow | `Arrow` | `()` |
| RowButton | 只有 `Name` | `()` |

Expand 子项的参数：

| Kind | 专属参数 | 回调 |
|---|---|---|
| toggle | `Default` | `(bool)` |
| number | `Min`, `Max`, `Default` | `(number)` |
| cycle | `Options`, `DefaultIndex` | `(idx)` |
| slider | `Min`, `Max`, `Default` | `(number)` |

---

## 常见问题

**控件加进去了但看不见？**

大概率是 Key 写错了，或者 Expand 子项漏了 `Kind`。先检查 `tab.Rows` 里有没有这个 key：

```lua
for k, v in pairs(tab.Rows) do print(k) end
```

**回调不触发？**

`win:Set()` 默认会触发回调，`win:SetSilent()` 不会。如果你用的是 `SetSilent` 那当然不触发。用户点 UI 的时候一定触发。

**改了 Key 之后状态丢了？**

Key 是状态的唯一标识，改了就相当于新控件。发布之后最好别改。

**面板挡住了游戏画面？**

改 `DisplayOrder` 调层级，或者用 `win:SetVisible(false)` 关掉。

**多个脚本都想用这个库，会冲突吗？**

会。`_G._CDMUILiveWindows` 是全局的，重复加载会互相干扰。建议一个脚本只建一个面板。

---

## 调试

**面板没出来**

```lua
print(getgenv().ExaminationWin)   -- 或者你自己的窗口变量
print(#win.Tabs)                  -- 分页数
```

如果是 nil，说明 `UI.Create` 没执行成功，往前找报错。

**控件状态不对**

```lua
print(win.State["your_key"])           -- 逻辑层的值
print(tab.Rows["your_key"].Get())      -- 界面显示的值
```

两个不一致就说明同步出了问题。正常情况下 `State` 是权威，界面应该跟着它走。

**报错被吞了**

所有回调都包了 `pcall`，报错不会中断 UI，但也可能被忽略。可以看错误统计：

```lua
local stats = UI.GetErrorStats()
print(stats.count, stats.last)
```

**检查内部有没有崩**

```lua
-- 看所有分页的控件数量
for i, tb in ipairs(win.Tabs) do
    local n = 0
    for _ in pairs(tb.Rows or {}) do n = n + 1 end
    print(i, tb.Name, n)
end
```

---

## 销毁与清理

```lua
win:Destroy()                        -- 销毁当前窗口
```

或者清掉所有残留：

```lua
if _G._CDMUILastCleanup then _G._CDMUILastCleanup() end
```

`Destroy` 会断开所有连接、销毁所有实例、释放鼠标 hook。重载前不用手动调，新的一次加载会自动处理旧的。

---

## 移动端适配

自动检测（`TouchEnabled` 且没有 `KeyboardEnabled`），尺寸会放大一圈：

行高从 76 变成 88，Tab 高从 54 变成 62，字号加 2，滚动条从 3px 到 5px。退出动画也长一点（0.28s 对 0.24s），拖动阈值小一点（12px 对 18px），手指滑动更容易触发。

---

## 版本历史

当前 1.6.0。这一版做了几件事：

`Anim` 加了动画冲突管理，同一属性上的新动画会自动取消旧的。`UI.safeCall` 做了错误隔离，回调抛错不再中断 UI。`State` 统一成唯一数据源，`Set` / `SetSilent` / `SetMany` / `RepaintAll` 都基于它。加了 `registerControl` 做注册校验，key 冲突会警告。抽出 `makeFoldable` 折叠基类，Expand 和 Body2D 共用一套逻辑。`SelectTab` 的两个分支合并了，之前改一处忘另一处出过好几次问题。

修的 bug 也不少：折叠收不起来（`apply` 写 State 覆盖了用户选择）、切页后折叠状态错乱（动画分支没调 `setPage`）、点击触发两次切换（`RowHit` 盖住了箭头区域）、顶栏按钮消失和变白（误删了函数和常量）、Tab 滚动条消失（动画隐藏后没恢复）。

更早的版本：

1.5.0 给 `bindTap` 内置了音效，所有控件自动有点击声；Body2D 修正成 R6 比例并支持折叠。

1.4.x 做了退出动画和入场动画，还处理了鼠标状态记录与还原。

1.3.x 把 Tab 栏改成横向滚动，支持拖动。

---

## 许可

MIT
