-- ╔═══════════════════════════════════╗
--   EXO HUB | FLY + NOCLIP
--   discord.gg/6QzV9pTWs
-- ╚═══════════════════════════════════╝

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local lp               = Players.LocalPlayer

-- ══════════════════════════════════════
--  STATE
-- ══════════════════════════════════════
local flyActive    = false
local noclipActive = false
local flySpeed     = 50
local flyConn      = nil
local noclipConn   = nil
local bodyGyro     = nil
local bodyVel      = nil

-- ══════════════════════════════════════
--  HELPERS
-- ══════════════════════════════════════
local function getChar() return lp.Character end
local function getHRP()  local c=getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum()  local c=getChar(); return c and c:FindFirstChildOfClass("Humanoid") end

-- ══════════════════════════════════════
--  FLY
-- ══════════════════════════════════════
local function startFly()
    local hrp = getHRP()
    local hum = getHum()
    if not hrp or not hum then return end
    hum.PlatformStand = true

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bodyGyro.P = 9e4
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp

    bodyVel = Instance.new("BodyVelocity")
    bodyVel.Velocity = Vector3.zero
    bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)
    bodyVel.P = 9e4
    bodyVel.Parent = hrp

    local cam = workspace.CurrentCamera
    flyConn = RunService.RenderStepped:Connect(function()
        if not flyActive then return end
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space)     then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end
        bodyVel.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
        bodyGyro.CFrame  = cam.CFrame
    end)
end

local function stopFly()
    flyActive = false
    if flyConn  then flyConn:Disconnect();  flyConn  = nil end
    if bodyGyro then bodyGyro:Destroy();    bodyGyro = nil end
    if bodyVel  then bodyVel:Destroy();     bodyVel  = nil end
    local hum = getHum()
    if hum then hum.PlatformStand = false end
end

-- ══════════════════════════════════════
--  NOCLIP
-- ══════════════════════════════════════
local function startNoclip()
    noclipConn = RunService.Stepped:Connect(function()
        if not noclipActive then return end
        local char = getChar()
        if not char then return end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end)
end

local function stopNoclip()
    noclipActive = false
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    local char = getChar()
    if char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = true
            end
        end
    end
end

-- respawn
lp.CharacterAdded:Connect(function()
    task.wait(1)
    if flyActive    then startFly() end
    if noclipActive then startNoclip() end
end)

-- ══════════════════════════════════════
--  GUI — CUSTOM WINDUI-STYLE DARK BLUE
-- ══════════════════════════════════════
if lp.PlayerGui:FindFirstChild("ExoFlyGui") then lp.PlayerGui.ExoFlyGui:Destroy() end

local SG = Instance.new("ScreenGui")
SG.Name = "ExoFlyGui"
SG.ResetOnSpawn = false
SG.DisplayOrder = 999
SG.IgnoreGuiInset = true
SG.Parent = lp.PlayerGui

-- COLOURS (matching EXO HUB logo)
local C = {
    bg       = Color3.fromRGB(8,  10, 20),
    bg2      = Color3.fromRGB(11, 14, 26),
    bg3      = Color3.fromRGB(14, 18, 34),
    sidebar  = Color3.fromRGB(6,  8,  18),
    accent   = Color3.fromRGB(0,  140, 255),
    accent2  = Color3.fromRGB(0,  200, 255),
    border   = Color3.fromRGB(0,  50,  120),
    border2  = Color3.fromRGB(0,  80,  180),
    text     = Color3.fromRGB(200,220, 255),
    subtext  = Color3.fromRGB(80, 110, 170),
    dim      = Color3.fromRGB(30, 40,  80),
}

local W_W, W_H = 480, 340
local MINI_H   = 46
local minimised = false
local activeTab = "fly"

-- WINDOW
local W = Instance.new("Frame")
W.Size = UDim2.new(0, W_W, 0, W_H)
W.Position = UDim2.new(0.5, -(W_W/2), 0.5, -(W_H/2))
W.BackgroundColor3 = C.bg
W.BorderSizePixel = 0
W.ClipsDescendants = true
W.Active = true
W.Draggable = true
W.Parent = SG
Instance.new("UICorner", W).CornerRadius = UDim.new(0, 12)

local wStroke = Instance.new("UIStroke")
wStroke.Color = C.border2
wStroke.Thickness = 1.2
wStroke.Parent = W

-- top accent bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 2)
topBar.BackgroundColor3 = C.accent
topBar.BorderSizePixel = 0
topBar.ZIndex = 10
topBar.Parent = W
local topBarGrad = Instance.new("UIGradient")
topBarGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(0,0,0)),
    ColorSequenceKeypoint.new(0.25, C.accent),
    ColorSequenceKeypoint.new(0.75, C.accent2),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(0,0,0)),
})
topBarGrad.Parent = topBar
task.spawn(function()
    local t = 0
    while SG.Parent do
        t += 0.025
        topBarGrad.Offset = Vector2.new(math.sin(t)*0.7, 0)
        task.wait(0.025)
    end
end)

-- SIDEBAR
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 46, 1, 0)
sidebar.BackgroundColor3 = C.sidebar
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 3
sidebar.Parent = W
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 12)
local sbFix = Instance.new("Frame")
sbFix.Size = UDim2.new(1, 0, 1, 0)
sbFix.Position = UDim2.new(1, -12, 0, 0)
sbFix.BackgroundColor3 = C.sidebar
sbFix.BorderSizePixel = 0
sbFix.ZIndex = 2
sbFix.Parent = sidebar

-- sidebar right border line
local sbLine = Instance.new("Frame")
sbLine.Size = UDim2.new(0, 1, 1, 0)
sbLine.Position = UDim2.new(1, 0, 0, 0)
sbLine.BackgroundColor3 = C.border
sbLine.BorderSizePixel = 0
sbLine.ZIndex = 4
sbLine.Parent = sidebar

-- logo icon on sidebar
local logoIcon = Instance.new("TextLabel")
logoIcon.Size = UDim2.new(1, 0, 0, 46)
logoIcon.Position = UDim2.new(0, 0, 0, 2)
logoIcon.BackgroundTransparency = 1
logoIcon.Text = "✦"
logoIcon.TextSize = 20
logoIcon.Font = Enum.Font.GothamBold
logoIcon.TextColor3 = C.accent
logoIcon.ZIndex = 5
logoIcon.Parent = sidebar

-- CONTENT AREA
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -46, 1, 0)
contentArea.Position = UDim2.new(0, 46, 0, 0)
contentArea.BackgroundTransparency = 1
contentArea.ZIndex = 3
contentArea.Parent = W

-- HEADER
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 46)
headerFrame.BackgroundTransparency = 1
headerFrame.ZIndex = 4
headerFrame.Parent = contentArea

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, -80, 0, 18)
titleLbl.Position = UDim2.new(0, 14, 0, 8)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "EXO HUB"
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 15
titleLbl.TextColor3 = C.text
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 5
titleLbl.Parent = headerFrame
local tGrad = Instance.new("UIGradient")
tGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.accent2),
    ColorSequenceKeypoint.new(0.5, C.text),
    ColorSequenceKeypoint.new(1, C.accent),
})
tGrad.Parent = titleLbl

local discordLbl = Instance.new("TextLabel")
discordLbl.Size = UDim2.new(1, -80, 0, 13)
discordLbl.Position = UDim2.new(0, 14, 0, 27)
discordLbl.BackgroundTransparency = 1
discordLbl.Text = "discord.gg/6QzV9pTWs"
discordLbl.Font = Enum.Font.GothamMedium
discordLbl.TextSize = 9
discordLbl.TextColor3 = C.subtext
discordLbl.TextXAlignment = Enum.TextXAlignment.Left
discordLbl.ZIndex = 5
discordLbl.Parent = headerFrame

-- header buttons
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 22, 0, 22)
minBtn.Position = UDim2.new(1, -50, 0.5, -11)
minBtn.BackgroundColor3 = C.bg3
minBtn.Text = "─"
minBtn.TextColor3 = C.subtext
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 10
minBtn.BorderSizePixel = 0
minBtn.ZIndex = 6
minBtn.Parent = headerFrame
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
local minStroke = Instance.new("UIStroke")
minStroke.Color = C.border
minStroke.Thickness = 1
minStroke.Parent = minBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -24, 0.5, -11)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 60)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 10
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 6
closeBtn.Parent = headerFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- header divider
local hDiv = Instance.new("Frame")
hDiv.Size = UDim2.new(1, -16, 0, 1)
hDiv.Position = UDim2.new(0, 8, 0, 45)
hDiv.BackgroundColor3 = C.border
hDiv.BorderSizePixel = 0
hDiv.ZIndex = 4
hDiv.Parent = contentArea

closeBtn.MouseButton1Click:Connect(function()
    stopFly(); stopNoclip()
    SG:Destroy()
end)

minBtn.MouseButton1Click:Connect(function()
    minimised = not minimised
    minBtn.Text = minimised and "+" or "─"
    TweenService:Create(W, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, W_W, 0, minimised and MINI_H or W_H)
    }):Play()
end)

-- TAB BAR
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -16, 0, 30)
tabBar.Position = UDim2.new(0, 8, 0, 52)
tabBar.BackgroundColor3 = C.bg3
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 4
tabBar.Parent = contentArea
Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", tabBar).Color = C.border

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabBar

-- TAB PAGES
local pages = {}
local tabBtns = {}

local function makePage()
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -16, 1, -92)
    f.Position = UDim2.new(0, 8, 0, 90)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    f.Visible = false
    f.ZIndex = 4
    f.Parent = contentArea
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = f
    return f
end

local function switchTab(key)
    activeTab = key
    for k, btn in pairs(tabBtns) do
        local on = k == key
        TweenService:Create(btn, TweenInfo.new(0.18), {
            BackgroundColor3 = on and C.accent or Color3.fromRGB(0,0,0),
            BackgroundTransparency = on and 0 or 1,
            TextColor3 = on and Color3.fromRGB(0,0,0) or C.subtext,
        }):Play()
    end
    for k, page in pairs(pages) do
        page.Visible = k == key
    end
end

local TABS = {
    {key="fly",      label="✈️  Fly"},
    {key="noclip",   label="👻  NoClip"},
    {key="settings", label="⚙️  Settings"},
}

for i, tab in ipairs(TABS) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#TABS, 0, 1, 0)
    btn.BackgroundColor3 = i==1 and C.accent or Color3.fromRGB(0,0,0)
    btn.BackgroundTransparency = i==1 and 0 or 1
    btn.Text = tab.label
    btn.TextColor3 = i==1 and Color3.fromRGB(0,0,0) or C.subtext
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.BorderSizePixel = 0
    btn.ZIndex = 5
    btn.LayoutOrder = i
    btn.Parent = tabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
    tabBtns[tab.key] = btn
    pages[tab.key] = makePage()
    btn.MouseButton1Click:Connect(function() switchTab(tab.key) end)
end
pages["fly"].Visible = true

-- SECTION LABEL BUILDER
local function makeSection(page, labelTxt, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelTxt:upper()
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 9
    lbl.TextColor3 = C.subtext
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LetterSpacing = 3
    lbl.ZIndex = 5
    lbl.LayoutOrder = order
    lbl.Parent = page
end

-- TOGGLE BUILDER
local function makeToggle(page, cfg)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 50)
    row.BackgroundColor3 = C.bg2
    row.BorderSizePixel = 0
    row.ZIndex = 5
    row.LayoutOrder = cfg.order
    row.Parent = page
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
    local rowStroke = Instance.new("UIStroke")
    rowStroke.Color = C.border
    rowStroke.Thickness = 1
    rowStroke.Parent = row

    local iBg = Instance.new("Frame")
    iBg.Size = UDim2.new(0, 32, 0, 32)
    iBg.Position = UDim2.new(0, 10, 0.5, -16)
    iBg.BackgroundColor3 = cfg.color
    iBg.BackgroundTransparency = 0.8
    iBg.BorderSizePixel = 0
    iBg.ZIndex = 6
    iBg.Parent = row
    Instance.new("UICorner", iBg).CornerRadius = UDim.new(0, 8)

    local iLbl = Instance.new("TextLabel")
    iLbl.Size = UDim2.new(1,0,1,0)
    iLbl.BackgroundTransparency = 1
    iLbl.Text = cfg.icon
    iLbl.TextSize = 15
    iLbl.Font = Enum.Font.GothamBold
    iLbl.ZIndex = 7
    iLbl.Parent = iBg

    local nLbl = Instance.new("TextLabel")
    nLbl.Size = UDim2.new(1,-98,0,16)
    nLbl.Position = UDim2.new(0,50,0,9)
    nLbl.BackgroundTransparency = 1
    nLbl.Text = cfg.name
    nLbl.Font = Enum.Font.GothamBold
    nLbl.TextSize = 12
    nLbl.TextColor3 = C.text
    nLbl.TextXAlignment = Enum.TextXAlignment.Left
    nLbl.ZIndex = 6
    nLbl.Parent = row

    local dLbl = Instance.new("TextLabel")
    dLbl.Size = UDim2.new(1,-98,0,12)
    dLbl.Position = UDim2.new(0,50,0,26)
    dLbl.BackgroundTransparency = 1
    dLbl.Text = cfg.desc
    dLbl.Font = Enum.Font.GothamMedium
    dLbl.TextSize = 9
    dLbl.TextColor3 = C.dim
    dLbl.TextXAlignment = Enum.TextXAlignment.Left
    dLbl.ZIndex = 6
    dLbl.Parent = row

    local pill = Instance.new("Frame")
    pill.Size = UDim2.new(0, 38, 0, 20)
    pill.AnchorPoint = Vector2.new(1, 0.5)
    pill.Position = UDim2.new(1, -10, 0.5, 0)
    pill.BackgroundColor3 = C.bg3
    pill.BorderSizePixel = 0
    pill.ZIndex = 6
    pill.Parent = row
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
    local pillStroke = Instance.new("UIStroke")
    pillStroke.Color = C.border
    pillStroke.Thickness = 1
    pillStroke.Parent = pill

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 13, 0, 13)
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Position = UDim2.new(0.28, 0, 0.5, 0)
    dot.BackgroundColor3 = C.subtext
    dot.BorderSizePixel = 0
    dot.ZIndex = 7
    dot.Parent = pill
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1,0,1,0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.ZIndex = 8
    clickBtn.Parent = row

    local on = false
    local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quart)
    clickBtn.MouseButton1Click:Connect(function()
        on = not on
        TweenService:Create(pill,       ti, {BackgroundColor3 = on and cfg.color or C.bg3}):Play()
        TweenService:Create(pillStroke, ti, {Color = on and cfg.color or C.border, Transparency = on and 0.5 or 0}):Play()
        TweenService:Create(dot,        ti, {Position = on and UDim2.new(0.72,0,0.5,0) or UDim2.new(0.28,0,0.5,0), BackgroundColor3 = on and Color3.fromRGB(255,255,255) or C.subtext}):Play()
        TweenService:Create(iBg,        ti, {BackgroundTransparency = on and 0.5 or 0.8}):Play()
        TweenService:Create(rowStroke,  ti, {Color = on and cfg.color or C.border, Transparency = on and 0.4 or 0}):Play()
        if on then cfg.onEnable() else cfg.onDisable() end
    end)
end

-- SLIDER BUILDER
local function makeSlider(page, cfg)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 56)
    row.BackgroundColor3 = C.bg2
    row.BorderSizePixel = 0
    row.ZIndex = 5
    row.LayoutOrder = cfg.order
    row.Parent = page
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", row).Color = C.border

    local nLbl = Instance.new("TextLabel")
    nLbl.Size = UDim2.new(1,-60,0,16)
    nLbl.Position = UDim2.new(0,12,0,10)
    nLbl.BackgroundTransparency = 1
    nLbl.Text = cfg.name
    nLbl.Font = Enum.Font.GothamBold
    nLbl.TextSize = 12
    nLbl.TextColor3 = C.text
    nLbl.TextXAlignment = Enum.TextXAlignment.Left
    nLbl.ZIndex = 6
    nLbl.Parent = row

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0,50,0,16)
    valLbl.Position = UDim2.new(1,-58,0,10)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(cfg.default)
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 11
    valLbl.TextColor3 = C.accent
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.ZIndex = 6
    valLbl.Parent = row

    local trackBg = Instance.new("Frame")
    trackBg.Size = UDim2.new(1,-24,0,4)
    trackBg.Position = UDim2.new(0,12,0,38)
    trackBg.BackgroundColor3 = C.bg3
    trackBg.BorderSizePixel = 0
    trackBg.ZIndex = 6
    trackBg.Parent = row
    Instance.new("UICorner", trackBg).CornerRadius = UDim.new(1,0)

    local pct = (cfg.default-cfg.min)/(cfg.max-cfg.min)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(pct,0,1,0)
    fill.BackgroundColor3 = C.accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 7
    fill.Parent = trackBg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)
    local fillGrad = Instance.new("UIGradient")
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.accent),
        ColorSequenceKeypoint.new(1, C.accent2),
    })
    fillGrad.Parent = fill

    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0,12,0,12)
    thumb.AnchorPoint = Vector2.new(0.5,0.5)
    thumb.Position = UDim2.new(pct,0,0.5,0)
    thumb.BackgroundColor3 = Color3.fromRGB(240,240,255)
    thumb.BorderSizePixel = 0
    thumb.ZIndex = 8
    thumb.Parent = trackBg
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1,0)

    local dragging = false
    thumb.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end
        local rel = math.clamp((i.Position.X-trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X,0,1)
        local val = math.floor(cfg.min+rel*(cfg.max-cfg.min))
        fill.Size = UDim2.new(rel,0,1,0)
        thumb.Position = UDim2.new(rel,0,0.5,0)
        valLbl.Text = tostring(val)
        cfg.onChange(val)
    end)
end

-- ══════════════════════════════════════
--  FLY PAGE
-- ══════════════════════════════════════
makeSection(pages["fly"], "Fly Controls", 1)

makeToggle(pages["fly"], {
    name="Fly", desc="WASD  •  Space up  •  Shift down",
    icon="✈️", color=C.accent, order=2,
    onEnable = function() flyActive=true; startFly() end,
    onDisable = stopFly,
})

makeSlider(pages["fly"], {
    name="Fly Speed", min=10, max=200, default=50, order=3,
    onChange = function(v) flySpeed=v end,
})

-- ══════════════════════════════════════
--  NOCLIP PAGE
-- ══════════════════════════════════════
makeSection(pages["noclip"], "NoClip Controls", 1)

makeToggle(pages["noclip"], {
    name="NoClip", desc="Walk through any wall or object",
    icon="👻", color=Color3.fromRGB(140,80,255), order=2,
    onEnable = function() noclipActive=true; startNoclip() end,
    onDisable = stopNoclip,
})

makeToggle(pages["noclip"], {
    name="Fly + NoClip", desc="Both active at once — go anywhere",
    icon="🔓", color=C.accent2, order=3,
    onEnable = function()
        flyActive=true; noclipActive=true
        startFly(); startNoclip()
    end,
    onDisable = function()
        stopFly(); stopNoclip()
    end,
})

-- ══════════════════════════════════════
--  SETTINGS PAGE
-- ══════════════════════════════════════
makeSection(pages["settings"], "EXO HUB", 1)

local credRow = Instance.new("Frame")
credRow.Size = UDim2.new(1,0,0,50)
credRow.BackgroundColor3 = C.bg2
credRow.BorderSizePixel = 0
credRow.ZIndex = 5
credRow.LayoutOrder = 2
credRow.Parent = pages["settings"]
Instance.new("UICorner", credRow).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke", credRow).Color = C.border

local credTitle = Instance.new("TextLabel")
credTitle.Size = UDim2.new(1,-20,0,16)
credTitle.Position = UDim2.new(0,12,0,9)
credTitle.BackgroundTransparency = 1
credTitle.Text = "EXO HUB — Fly + NoClip"
credTitle.Font = Enum.Font.GothamBold
credTitle.TextSize = 12
credTitle.TextColor3 = C.text
credTitle.TextXAlignment = Enum.TextXAlignment.Left
credTitle.ZIndex = 6
credTitle.Parent = credRow

local credSub = Instance.new("TextLabel")
credSub.Size = UDim2.new(1,-20,0,12)
credSub.Position = UDim2.new(0,12,0,27)
credSub.BackgroundTransparency = 1
credSub.Text = "Free forever  •  discord.gg/6QzV9pTWs"
credSub.Font = Enum.Font.GothamMedium
credSub.TextSize = 9
credSub.TextColor3 = C.subtext
credSub.TextXAlignment = Enum.TextXAlignment.Left
credSub.ZIndex = 6
credSub.Parent = credRow

-- ══════════════════════════════════════
--  PULSE
-- ══════════════════════════════════════
local t = 0
RunService.Heartbeat:Connect(function(dt)
    if not SG.Parent then return end
    t += dt
    local pulse = (math.sin(t*2)+1)/2
    local anyOn = flyActive or noclipActive
    wStroke.Color = anyOn
        and Color3.fromRGB(math.floor(pulse*20), math.floor(80+pulse*60), math.floor(180+pulse*75))
        or  C.border2
    wStroke.Thickness = anyOn and 1.2+pulse*0.5 or 1.2
end)

-- ══════════════════════════════════════
--  OPEN ANIMATION
-- ══════════════════════════════════════
W.Position = UDim2.new(-0.5, 0, 0.5, -(W_H/2))
TweenService:Create(W, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -(W_W/2), 0.5, -(W_H/2))
}):Play()

print("[EXO HUB] Fly + NoClip loaded | discord.gg/6QzV9pTWs")
