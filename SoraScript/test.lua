-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local placeId = game.PlaceId
local fileName = "SORA_MAP_" .. placeId .. ".json"

-- DATA STORAGE
local recordedPoints = {}
_G.SelectedEventSpot = CFrame.new(606.0, -580.6, 8923.3)

-- ================= ANTI AFK =================
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ================= GUI ROOT =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SORA_V6"
gui.ResetOnSpawn = false

-- FLOATING LOGO
local openLogo = Instance.new("ImageButton", gui)
openLogo.Size = UDim2.fromOffset(60, 60)
openLogo.Position = UDim2.fromScale(0.02, 0.5)
openLogo.BackgroundTransparency = 1
openLogo.Visible = false
openLogo.Draggable = true
openLogo.Image = "rbxassetid://107169258644997"
Instance.new("UICorner", openLogo).CornerRadius = UDim.new(0, 12)

-- MAIN FRAME
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.fromOffset(550, 350)
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

local sidePadding = Instance.new("UIPadding", sidebar)
sidePadding.PaddingTop = UDim.new(0, 10)

-- CONTENT AREA (RIGHT)
local container = Instance.new("Frame", mainFrame)
container.Size = UDim2.new(1, -140, 1, -40)
container.Position = UDim2.fromOffset(135, 35)
container.BackgroundTransparency = 1

-- TITLE & MINIMIZE
local headerTitle = Instance.new("TextLabel", mainFrame)
headerTitle.Size = UDim2.new(0, 100, 0, 30)
headerTitle.Position = UDim2.fromOffset(140, 5)
headerTitle.Text = "SORA HUB | PREMIUM"
headerTitle.TextColor3 = Color3.fromRGB(0, 255, 180)
headerTitle.Font = Enum.Font.GothamBold
headerTitle.BackgroundTransparency = 1
headerTitle.TextXAlignment = Enum.TextXAlignment.Left

local minBtn = Instance.new("TextButton", mainFrame)
minBtn.Size = UDim2.fromOffset(30, 25)
minBtn.Position = UDim2.new(1, -35, 0, 5)
minBtn.Text = "–"
minBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
minBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", minBtn)

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
    page.ScrollBarThickness = 2
    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.Padding = UDim.new(0, 8)
    pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(tabs) do p.Visible = false end
        page.Visible = true
    end)

    tabs[name] = page
    return page
end

-- ================= UI UTILS =================
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
end

local function createActionBtn(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 380, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

-- ================= TABS CREATION =================
local mainPage = createTab("Main")
local mountainPage = createTab("Mountain")
local tpPage = createTab("Teleport")
local miscPage = createTab("Misc")
tabs["Main"].Visible = true

-- ================= MAIN TAB (FISHING/EVENT) =================
local SPOTS = {
    ["Spot 1"] = CFrame.new(606.0, -580.6, 8923.3),
    ["Spot 2"] = CFrame.new(603.4, -580.6, 8886.0),
    ["Spot 3"] = CFrame.new(576.8, -580.7, 8845.8),
    ["Spot 4"] = CFrame.new(774.6, -487.2, 8923.0)
}

local spotLabel = Instance.new("TextLabel", mainPage)
spotLabel.Size = UDim2.new(0, 380, 0, 20); spotLabel.Text = "Current Event Spot: Spot 1"; spotLabel.BackgroundTransparency = 1; spotLabel.TextColor3 = Color3.new(0.6,0.6,0.6); spotLabel.Font = Enum.Font.Gotham

for name, cf in pairs(SPOTS) do
    createActionBtn(mainPage, "Select " .. name, function()
        _G.SelectedEventSpot = cf
        spotLabel.Text = "Current Event Spot: " .. name
    end)
end

local autoXmas = false
createToggle(mainPage, "Auto Event Teleport", function(v) autoXmas = v end)

-- ================= MOUNTAIN TAB (RECORDER) =================
createActionBtn(mountainPage, "Record Current Point", function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        table.insert(recordedPoints, player.Character.HumanoidRootPart.CFrame)
    end
end)

local rushState = false
createToggle(mountainPage, "Auto Rush Recorded Points", function(v) 
    rushState = v 
    if rushState then
        task.spawn(function()
            for i, cf in ipairs(recordedPoints) do
                if not rushState then break end
                player.Character.HumanoidRootPart.CFrame = cf
                task.wait(1.5)
            end
        end)
    end
end)

createActionBtn(mountainPage, "Save Map Data", function()
    local data = {}
    for _, cf in ipairs(recordedPoints) do table.insert(data, {cf:GetComponents()}) end
    writefile(fileName, HttpService:JSONEncode(data))
end)

createActionBtn(mountainPage, "Clear Data", function() 
    recordedPoints = {} 
    if isfile(fileName) then delfile(fileName) end 
end)

-- ================= TELEPORT TAB =================
local tpScroll = Instance.new("ScrollingFrame", tpPage)
tpScroll.Size = UDim2.new(1, 0, 1, 0); tpScroll.BackgroundTransparency = 1; tpScroll.ScrollBarThickness = 0
local tpList = Instance.new("UIListLayout", tpScroll); tpList.Padding = UDim.new(0, 5); tpList.HorizontalAlignment = Enum.HorizontalAlignment.Center

createActionBtn(tpPage, "Refresh Player List", function()
    for _, child in pairs(tpScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local b = Instance.new("TextButton", tpScroll)
            b.Size = UDim2.new(0, 350, 0, 30); b.Text = p.DisplayName; b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function()
                player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end)
        end
    end
end)

-- ================= MISC TAB =================
local fly, flySpeed = false, 100
createToggle(miscPage, "Fly Mode", function(v) 
    fly = v 
    local hrp = player.Character.HumanoidRootPart
    if fly then
        local bv = Instance.new("BodyVelocity", hrp); bv.Name = "SoraFly"; bv.MaxForce = Vector3.new(1e6,1e6,1e6)
        local bg = Instance.new("BodyGyro", hrp); bg.Name = "SoraGyro"; bg.MaxTorque = Vector3.new(1e6,1e6,1e6)
    else
        if hrp:FindFirstChild("SoraFly") then hrp.SoraFly:Destroy() end
        if hrp:FindFirstChild("SoraGyro") then hrp.SoraGyro:Destroy() end
    end
end)

createActionBtn(miscPage, "Hide Game UI", function()
    for _, v in pairs(player.PlayerGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name ~= gui.Name then v.Enabled = not v.Enabled end
    end
end)

-- ================= SYSTEM LOOPS =================
minBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false; openLogo.Visible = true end)
openLogo.MouseButton1Click:Connect(function() mainFrame.Visible = true; openLogo.Visible = false end)

local EVENT_HOURS = {0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22}
local teleported = false

RunService.Stepped:Connect(function()
    if autoXmas then
        local t = os.date("!*t", workspace:GetServerTimeNow())
        local hrp = player.Character.HumanoidRootPart
        local isEvent = false
        for _, h in pairs(EVENT_HOURS) do if t.hour == h then isEvent = true break end end

        if isEvent and t.min == 0 and t.sec >= 30 and not teleported then
            _G.LastPos = hrp.CFrame
            hrp.CFrame = _G.SelectedEventSpot
            teleported = true
        elseif t.min == 29 and t.sec >= 30 and teleported then
            hrp.CFrame = _G.LastPos or hrp.CFrame
            teleported = false
        end
    end
    
    if fly and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        hrp:FindFirstChild("SoraFly").Velocity = dir * flySpeed
        hrp:FindFirstChild("SoraGyro").CFrame = cam.CFrame
    end
end)

-- AUTO LOAD MOUNTAIN DATA
if isfile(fileName) then
    local data = HttpService:JSONDecode(readfile(fileName))
    for _, comp in ipairs(data) do table.insert(recordedPoints, CFrame.new(unpack(comp))) end
end
