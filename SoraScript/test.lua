-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

-- ================= GUI ROOT =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SORA_V6_FIXED"
gui.ResetOnSpawn = false

-- MAIN FRAME
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.fromOffset(550, 380)
mainFrame.Position = UDim2.fromScale(0.5, 0.5)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.Draggable = true
mainFrame.Active = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- SIDEBAR (LEFT)
local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, 130, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)

local sideLayout = Instance.new("UIListLayout", sidebar)
sideLayout.Padding = UDim.new(0, 5)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", sidebar).PaddingTop = UDim.new(0, 10)

-- CONTENT AREA
local container = Instance.new("Frame", mainFrame)
container.Size = UDim2.new(1, -140, 1, -60)
container.Position = UDim2.fromOffset(135, 50)
container.BackgroundTransparency = 1

-- HEADER (SORA + PING + COORD)
local headerArea = Instance.new("Frame", mainFrame)
headerArea.Size = UDim2.new(1, -140, 0, 40)
headerArea.Position = UDim2.fromOffset(135, 5)
headerArea.BackgroundTransparency = 1

local headerTitle = Instance.new("TextLabel", headerArea)
headerTitle.Size = UDim2.new(0, 100, 1, 0)
headerTitle.Text = "SORA"
headerTitle.TextColor3 = Color3.fromRGB(0, 255, 180)
headerTitle.Font = Enum.Font.GothamBold
headerTitle.TextSize = 20
headerTitle.BackgroundTransparency = 1
headerTitle.TextXAlignment = Enum.TextXAlignment.Left

local infoLabel = Instance.new("TextLabel", headerArea)
infoLabel.Size = UDim2.new(1, -110, 1, 0)
infoLabel.Position = UDim2.fromOffset(110, 0)
infoLabel.Text = "Ping: 0ms | X: 0 Y: 0 Z: 0"
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.Font = Enum.Font.Code
infoLabel.TextSize = 11
infoLabel.BackgroundTransparency = 1
infoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ================= TAB SYSTEM =================
local tabs = {}
local function createTab(name)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(0, 110, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = name
    btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)

    local page = Instance.new("ScrollingFrame", container)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Visible = false
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 0
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(tabs) do p.Visible = false end
        page.Visible = true
    end)
    tabs[name] = page
    return page
end

local function createToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 380, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.TextColor3 = state and Color3.fromRGB(0, 255, 180) or Color3.new(1, 1, 1)
        callback(state)
    end)
    return btn
end

-- ================= TABS =================
local mainPage = createTab("Main")
local tpPage = createTab("Teleport")
local miscPage = createTab("Misc")
tabs["Main"].Visible = true

-- ================= MAIN TAB =================
local autoXmas = false
local xmasBtn = createToggle(mainPage, "Auto Event", function(v) autoXmas = v end)

local countdownLabel = Instance.new("TextLabel", mainPage)
countdownLabel.Size = UDim2.new(0, 380, 0, 25); countdownLabel.BackgroundTransparency = 1; countdownLabel.TextColor3 = Color3.fromRGB(255, 200, 0); countdownLabel.Font = Enum.Font.GothamBold

local spotContainer = Instance.new("Frame", mainPage)
spotContainer.Size = UDim2.new(0, 380, 0, 150); spotContainer.BackgroundTransparency = 1; spotContainer.Visible = false
Instance.new("UIListLayout", spotContainer).Padding = UDim.new(0, 5)

local SPOTS = { ["Spot 1"] = CFrame.new(606.0, -580.6, 8923.3), ["Spot 2"] = CFrame.new(603.4, -580.6, 8886.0), ["Spot 3"] = CFrame.new(576.8, -580.7, 8845.8), ["Spot 4"] = CFrame.new(774.6, -487.2, 8923.0) }
_G.SelectedEventSpot = SPOTS["Spot 1"]

for name, cf in pairs(SPOTS) do
    local b = Instance.new("TextButton", spotContainer)
    b.Size = UDim2.new(1, 0, 0, 30); b.Text = "Select " .. name; b.BackgroundColor3 = Color3.fromRGB(35, 35, 35); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() _G.SelectedEventSpot = cf end)
end

xmasBtn.MouseButton1Click:Connect(function() spotContainer.Visible = autoXmas end)

-- ================= TELEPORT TAB =================
local tpActive = false
local tpBtn = createToggle(tpPage, "Teleport To Player", function(v) tpActive = v end)

local playerList = Instance.new("ScrollingFrame", tpPage)
playerList.Size = UDim2.new(0, 380, 0, 200); playerList.BackgroundTransparency = 1; playerList.Visible = false; playerList.ScrollBarThickness = 0
Instance.new("UIListLayout", playerList).Padding = UDim.new(0, 5)

local function updatePlayers()
    for _, c in pairs(playerList:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local b = Instance.new("TextButton", playerList)
            b.Size = UDim2.new(1, 0, 0, 30); b.Text = p.DisplayName; b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function() if p.Character then player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3) end end)
        end
    end
end

tpBtn.MouseButton1Click:Connect(function() playerList.Visible = tpActive; if tpActive then updatePlayers() end end)

-- ================= MISC TAB =================
local fly, noclip, flySpeed = false, false, 100
createToggle(miscPage, "Fly", function(v) 
    fly = v 
    local hrp = player.Character.HumanoidRootPart
    if fly then
        local bv = Instance.new("BodyVelocity", hrp); bv.Name = "SoraFly"; bv.MaxForce = Vector3.new(1e6,1e6,1e6)
        local bg = Instance.new("BodyGyro", hrp); bg.Name = "SoraGyro"; bg.MaxTorque = Vector3.new(1e6,1e6,1e6)
        player.Character.Humanoid.PlatformStand = true
    else
        if hrp:FindFirstChild("SoraFly") then hrp.SoraFly:Destroy() end
        if hrp:FindFirstChild("SoraGyro") then hrp.SoraGyro:Destroy() end
        player.Character.Humanoid.PlatformStand = false
    end
end)

-- FLY SPEED SLIDER
local sliderFrame = Instance.new("Frame", miscPage); sliderFrame.Size = UDim2.new(0, 380, 0, 45); sliderFrame.BackgroundTransparency = 1
local sliderLabel = Instance.new("TextLabel", sliderFrame); sliderLabel.Size = UDim2.new(1,0,0,20); sliderLabel.Text = "Fly Speed: 100"; sliderLabel.TextColor3 = Color3.new(1,1,1); sliderLabel.BackgroundTransparency = 1; sliderLabel.Font = Enum.Font.Gotham
local sliderBar = Instance.new("TextButton", sliderFrame); sliderBar.Size = UDim2.new(0, 360, 0, 6); sliderBar.Position = UDim2.fromOffset(10, 25); sliderBar.BackgroundColor3 = Color3.fromRGB(50,50,50); sliderBar.Text = ""
local sliderFill = Instance.new("Frame", sliderBar); sliderFill.Size = UDim2.fromScale(0.2, 1); sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 180); sliderFill.BorderSizePixel = 0

sliderBar.MouseButton1Down:Connect(function()
    local moveCon
    moveCon = UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local rel = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            flySpeed = math.floor(100 + (rel * 400))
            sliderFill.Size = UDim2.fromScale(rel, 1)
            sliderLabel.Text = "Fly Speed: " .. flySpeed
        end
    end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then moveCon:Disconnect() end end)
end)

createToggle(miscPage, "Noclip", function(v) noclip = v end)

local uiH = false
createActionBtn = function(p, t, c) -- Helper action btn
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(0, 380, 0, 35); b.BackgroundColor3 = Color3.fromRGB(25,25,25); b.Text = t; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(c)
    return b
end

createActionBtn(miscPage, "Hide Game UI", function()
    uiH = not uiH
    for _, v in pairs(player.PlayerGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name ~= gui.Name then v.Enabled = not uiH end
    end
end)

-- ================= LOOPS =================
local EVENT_HOURS = {0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22}
local teleported = false

RunService.RenderStepped:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local pos = hrp.Position
        infoLabel.Text = string.format("Ping: %dms | X:%.0f Y:%.0f Z:%.0f", Stats.Network.ServerStatsItem["Data Ping"]:GetValue(), pos.X, pos.Y, pos.Z)
    end
    
    local t = os.date("!*t", workspace:GetServerTimeNow())
    local nextH = 24
    for _, h in pairs(EVENT_HOURS) do if h > t.hour then nextH = h; break end end
    local diff = os.time({year=t.year, month=t.month, day=t.day, hour=nextH, min=0, sec=0}) - workspace:GetServerTimeNow()
    countdownLabel.Text = string.format("Next Event: %02d:%02d:%02d", math.floor(diff/3600), math.floor((diff%3600)/60), math.floor(diff%60))

    if fly and hrp and hrp:FindFirstChild("SoraFly") then
        local cam = workspace.CurrentCamera; local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
        hrp.SoraFly.Velocity = dir * flySpeed
        hrp.SoraGyro.CFrame = cam.CFrame
    end
end)

RunService.Stepped:Connect(function()
    if noclip and player.Character then for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if autoXmas and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local t = os.date("!*t", workspace:GetServerTimeNow())
        local isE = false; for _, h in pairs(EVENT_HOURS) do if t.hour == h then isE = true break end end
        if isE and t.min == 0 and t.sec >= 30 and not teleported then
            _G.LPos = hrp.CFrame; hrp.CFrame = _G.SelectedEventSpot; teleported = true
        elseif t.min == 29 and t.sec >= 30 and teleported then
            hrp.CFrame = _G.LPos or hrp.CFrame; teleported = false
        end
    end
end)
