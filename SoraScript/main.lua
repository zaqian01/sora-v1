-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

-- ================= ANTI AFK =================
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ================= GUI ROOT =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SORA_FINAL"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10 -- Memastikan GUI ini paling depan di layar

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(300, 420)
frame.Position = UDim2.fromScale(0.05, 0.2)
frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = false -- Diubah ke false agar panel teleport tidak terpotong

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

-- ================= HEADER =================
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1,0,0,40)
header.BackgroundColor3 = Color3.fromRGB(25,25,25)
header.ZIndex = 2 -- Agar header selalu di atas
Instance.new("UICorner", header).CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-50,1,0)
title.Position = UDim2.fromOffset(12,0)
title.BackgroundTransparency = 1
title.Text = "SORA HUB"
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(0,255,180)
title.ZIndex = 3

local minimize = Instance.new("TextButton", header)
minimize.Size = UDim2.fromOffset(36,26)
minimize.Position = UDim2.new(1, -10, 0.5, 0)
minimize.AnchorPoint = Vector2.new(1,0.5)
minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
minimize.Text = "–"
minimize.TextColor3 = Color3.new(1,1,1)
minimize.ZIndex = 3
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0,6)

-- ================= INFO DISPLAY (Sesuai Foto) =================
local infoFrame = Instance.new("Frame", frame)
infoFrame.Size = UDim2.new(1, 0, 0, 60)
infoFrame.Position = UDim2.fromOffset(0, 40)
infoFrame.BackgroundTransparency = 1
infoFrame.ZIndex = 2

local coordLabel = Instance.new("TextLabel", infoFrame)
coordLabel.Size = UDim2.new(1,0,0,30)
coordLabel.BackgroundTransparency = 1
coordLabel.TextColor3 = Color3.fromRGB(220,220,220)
coordLabel.Font = Enum.Font.Code
coordLabel.TextSize = 14
coordLabel.Text = "POS: X:0.0 Y:0.0 Z:0.0"

local pingLabel = Instance.new("TextLabel", infoFrame)
pingLabel.Size = UDim2.new(1,0,0,25)
pingLabel.Position = UDim2.fromOffset(0, 25)
pingLabel.BackgroundTransparency = 1
pingLabel.TextColor3 = Color3.fromRGB(0,255,180)
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextSize = 16
pingLabel.Text = "PING: -- ms"

-- ================= CONTENT (DITURUNKAN DI BAWAH INFO) =================
local contentFrame = Instance.new("Frame", frame)
contentFrame.Position = UDim2.fromOffset(0, 100)
contentFrame.Size = UDim2.new(1,0,1,-100)
contentFrame.BackgroundTransparency = 1
contentFrame.ZIndex = 1

local listLayout = Instance.new("UIListLayout", contentFrame)
listLayout.Padding = UDim.new(0,8)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ================= PLAYER LIST PANEL (FIXED Z-INDEX) =================
local playerListFrame = Instance.new("Frame", frame)
playerListFrame.Size = UDim2.fromOffset(260, 260)
playerListFrame.Position = UDim2.fromScale(0.5, 0.5)
playerListFrame.AnchorPoint = Vector2.new(0.5, 0.5)
playerListFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
playerListFrame.BorderSizePixel = 1
playerListFrame.BorderColor3 = Color3.fromRGB(0,255,180)
playerListFrame.Visible = false
playerListFrame.ZIndex = 100 -- SANGAT TINGGI agar berada paling depan

Instance.new("UICorner", playerListFrame).CornerRadius = UDim.new(0,10)

local plTitle = Instance.new("TextLabel", playerListFrame)
plTitle.Size = UDim2.new(1,0,0,40)
plTitle.Text = "Teleport To Player"
plTitle.TextColor3 = Color3.fromRGB(0,255,180)
plTitle.Font = Enum.Font.GothamBold
plTitle.TextSize = 14
plTitle.BackgroundTransparency = 1
plTitle.ZIndex = 101

local scroll = Instance.new("ScrollingFrame", playerListFrame)
scroll.Position = UDim2.fromOffset(10,40)
scroll.Size = UDim2.new(1,-20,1,-50)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarThickness = 3
scroll.ZIndex = 101

local scrollList = Instance.new("UIListLayout", scroll)
scrollList.Padding = UDim.new(0,5)

-- ================= UTILS =================
local function HRP()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function createBtn(text)
    local b = Instance.new("TextButton", contentFrame)
    b.Size = UDim2.fromOffset(280, 36)
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    b.ZIndex = 2
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    return b
end

-- ================= LOGIC REFRESH LIST (FIXED TEXT & COLOR) =================
local function refreshPlayerList()
    for _,c in pairs(scroll:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local b = Instance.new("TextButton", scroll)
            b.Size = UDim2.new(1, 0, 0, 35)
            b.BackgroundColor3 = Color3.fromRGB(40,40,40)
            b.Text = "  " .. plr.DisplayName -- Tambah spasi dikit agar tidak mepet
            b.TextColor3 = Color3.fromRGB(255,255,255)
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.Font = Enum.Font.GothamBold
            b.TextSize = 13
            b.ZIndex = 105 -- Paling depan dalam scroll
            Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)

            b.MouseButton1Click:Connect(function()
                local hrp = HRP()
                local th = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp and th then hrp.CFrame = th.CFrame * CFrame.new(0,0,3) end
                playerListFrame.Visible = false
            end)
        end
    end
end

-- ================= BUTTON ACTIONS =================

-- Fly Logic
local fly, speed, bv, bg = false, 60, nil, nil
local flyBtn = createBtn("Fly: OFF")
flyBtn.MouseButton1Click:Connect(function()
    fly = not fly
    flyBtn.Text = fly and "Fly: ON" or "Fly: OFF"
    local hrp = HRP()
    if not hrp then return end
    if fly then
        bv = Instance.new("BodyVelocity", hrp); bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bg = Instance.new("BodyGyro", hrp); bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
        if player.Character:FindFirstChildOfClass("Humanoid") then player.Character:FindFirstChildOfClass("Humanoid").PlatformStand = true end
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        if player.Character:FindFirstChildOfClass("Humanoid") then player.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false end
    end
end)

-- Noclip Logic
local noclip = false
local noclipBtn = createBtn("Noclip: OFF")
noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = noclip and "Noclip: ON" or "Noclip: OFF"
end)

-- Teleport Logic
createBtn("Teleport To Player").MouseButton1Click:Connect(function()
    playerListFrame.Visible = not playerListFrame.Visible
    if playerListFrame.Visible then refreshPlayerList() end
end)

-- Minimize Logic
local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    frame:TweenSize(minimized and UDim2.fromOffset(300,40) or UDim2.fromOffset(300,420), "Out", "Quad", 0.2, true)
    contentFrame.Visible = not minimized
    infoFrame.Visible = not minimized
    playerListFrame.Visible = false -- Tutup panel jika di-minimize
    minimize.Text = minimized and "+" or "–"
end)

-- Hide UI
createBtn("Hide Game UI").MouseButton1Click:Connect(function()
    for _,ui in pairs(player.PlayerGui:GetChildren()) do
        if ui ~= gui and ui:IsA("ScreenGui") then ui.Enabled = not ui.Enabled end
    end
end)

-- ================= MAIN LOOP =================
RunService.RenderStepped:Connect(function()
    local hrp = HRP()
    if hrp then
        coordLabel.Text = string.format("POS: X:%.1f Y:%.1f Z:%.1f", hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
    end
    local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    pingLabel.Text = string.format("PING: %d ms", ping)
    pingLabel.TextColor3 = ping < 100 and Color3.fromRGB(0,255,180) or Color3.fromRGB(255,100,100)

    if fly and bv and bg then
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
        bv.Velocity = dir.Magnitude > 0 and dir.Unit * speed or Vector3.zero
        bg.CFrame = cam.CFrame
    end
end)

RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _,v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
