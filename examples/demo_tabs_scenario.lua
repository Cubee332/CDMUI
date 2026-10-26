-- ============================================================================
-- demo_tabs_scenario.lua — 停在「其他」页，检查 Slider / Keybind / MultiSelect
-- ============================================================================

local win = loadstring(game:HttpGet("https://mock.local/demo.lua"))()
pump(0.8)

local tabBtn = findByName("Tab_其他")
check("其他 Tab 存在", tabBtn ~= nil)
if tabBtn then
    tapUI(tabBtn)
    pump(0.9)
end

Snapshot("其他页")
check("滑动条渲染", findByText("音量") ~= nil)
check("按键绑定渲染", findByText("紧急关闭键") ~= nil)
check("多选渲染", findByText("通知类型") ~= nil)

__HARNESS.summary()
