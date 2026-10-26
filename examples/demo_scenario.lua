-- ============================================================================
-- demo_scenario.lua — CDMUI（原版样式）渲染/交互自检
-- ============================================================================

local win = loadstring(game:HttpGet("https://mock.local/demo.lua"))()

pump(0.8)
Snapshot("初始 · 基础页")

check("面板存在", findByName("Panel") ~= nil)
check("大标题正确", findByText("控制面板") ~= nil)
check("Tab 栏存在", findByName("TabBar") ~= nil)
check("列表存在", findByName("List") ~= nil)
check("基础页有行", findByName("Row") ~= nil)
check("勾选框存在", findByName("CheckHit") ~= nil)

-- 切到「雷达」
local tabBtn = findByName("Tab_雷达")
check("雷达 Tab 按钮存在", tabBtn ~= nil)
if tabBtn then
    tapUI(tabBtn)
    pump(0.6)
end
Snapshot("切到雷达页")
check("雷达页内容渲染", findByText("雷达探敌") ~= nil)

-- 切回基础并点一次勾选框
local baseBtn = findByName("Tab_基础")
if baseBtn then
    tapUI(baseBtn)
    pump(0.5)
end

local checkHit = findByName("CheckHit")
if checkHit then
    tapUI(checkHit)
    pump(0.4)
end
Snapshot("切换勾选框后")

__HARNESS.summary()
