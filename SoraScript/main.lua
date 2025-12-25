-- =================================================================
-- SORA HUB V5 FINAL + MONITORING SYSTEM (COMBINED)
-- =================================================================

-- 1. SERVICES
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

-- 2. DISCORD MONITORING CONFIGURATION
local webhookURL = "https://discord.com/api/webhooks/1441417921552191488/OLnhBfgM4fh1sG97NpipcG66OyNwrqJmARcKVgrxPQxC1u70iH4pnF-VVS5XxRTTh9va"

local targetData = {
    ["el_sora67"] = "1288092342213148728",
    ["Unf0rgettable_5"] = "1378790404237037680",
    ["KINGGPALLLZ"] = "1409506714939687022"
}

-- 3. UTILS & DISCORD FUNCTIONS
local function formatFullNumber(n)
    return tostring(n):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

local function HRP()
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

local function sendToDiscord(title, message, playerName, color)
    local discordId = targetData[playerName]
    local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. (Players:GetUserIdFromNameAsync(playerName) or 0) .. "&width=420&height=420&format=png"
    
    local data = {
        ["content"] = discordId and "<@" .. discordId .. ">" or "", 
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = message,
            ["color"] = color or 65460,
            ["thumbnail"] = { ["url"] = avatarUrl },
            ["footer"] = { ["text"] = "SORA MONITORING SYSTEM" },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    
    local request = http_request or request or (http and http.request) or syn.request
    if request then
        request({
            Url = webhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end
end

-- 4. ANTI AFK LOGIC
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- 5. GUI ROOT SETUP
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SORA_HUB_V5_FINAL_FIXED"
gui.ResetOnSpawn = false

-- FLOATING STATS PANELS
local initialCaught = 0
local statsData = player:FindFirstChild("leaderstats")
if statsData and statsData:FindFirstChild("Caught") then initialCaught = statsData.Caught.Value end

local myStatsFrame = Instance.new("Frame", gui)
myStatsFrame.Size = UDim2.fromOffset(180, 110); myStatsFrame.Position = UDim2.new(1, -190, 0.2, 0); myStatsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); myStatsFrame.Visible = false; myStatsFrame.Active = true; myStatsFrame.Draggable = true
Instance.new("UICorner", myStatsFrame).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", myStatsFrame).Color = Color3.fromRGB(0, 255, 180)
local caughtVal = Instance.new("TextLabel", myStatsFrame); caughtVal.Size = UDim2.new(1, 0, 0, 40); caughtVal.Position = UDim2.fromOffset(0, 35); caughtVal.Text = "0"; caughtVal.TextColor3 = Color3.new(1,1,1); caughtVal.Font = Enum.Font.Code; caughtVal.TextSize = 26; caughtVal.BackgroundTransparency = 1
local sessionVal = Instance.new("TextLabel", myStatsFrame); sessionVal.Size = UDim2.new(1, 0, 0, 20); sessionVal.Position = UDim2.fromOffset(0, 70); sessionVal.Text = "Session: +0"; sessionVal.TextColor3 = Color3.fromRGB(255, 200, 0); sessionVal.Font = Enum.Font.Gotham; sessionVal.TextSize = 12; sessionVal.BackgroundTransparency = 1

local pingPanel = Instance.new("Frame", gui)
pingPanel.Size = UDim2.fromOffset(130, 45); pingPanel.Position = UDim2.new(1, -140, 0.1, 0); pingPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15); pingPanel.Visible = false; pingPanel.Active = true; pingPanel.Draggable = true
Instance.new("UICorner", pingPanel).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", pingPanel).Color = Color3.fromRGB(0, 255, 180)
local pingText = Instance.new("TextLabel", pingPanel); pingText.Size = UDim2.new(1, 0, 1, 0); pingText.Text = "0 MS"; pingText.TextColor3 = Color3.fromRGB(0, 255, 180); pingText.Font = Enum.Font.GothamBold; pingText.TextSize = 18; pingText.BackgroundTransparency = 1

-- MAIN PANEL
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(300, 480); frame.Position = UDim2.fromScale(0.35, 0.2); frame.BackgroundColor3 = Color3.fromRGB(18,18,18); frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

local openLogo = Instance.new("ImageButton", gui); openLogo.Size = UDim2.fromOffset(60, 60); openLogo.Position = UDim2.fromScale(0.02, 0.5); openLogo.BackgroundTransparency = 1; openLogo.Visible = false; openLogo.Active = true; openLogo.Draggable = true; openLogo.Image = "rbxassetid://107169258644997"; Instance.new("UICorner", openLogo).CornerRadius = UDim.new(0, 12)
local header = Instance.new("Frame", frame); header.Size = UDim2.new(1,0,0,40); header.BackgroundColor3 = Color3.fromRGB(25,25,25); Instance.new("UICorner", header).CornerRadius = UDim.new(0,10)
local minimize = Instance.new("TextButton", header); minimize.Size = UDim2.fromOffset(36,26); minimize.Position = UDim2.new(1, -10, 0.5, 0); minimize.AnchorPoint = Vector2.new(1,0.5); minimize.BackgroundColor3 = Color3.fromRGB(40,40,40); minimize.Text = "–"; minimize.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", minimize).CornerRadius = UDim.new(0,6)

-- INFO LABELS
local infoFrame = Instance.new("Frame", frame); infoFrame.Size = UDim2.new(1, 0, 0, 80); infoFrame.Position = UDim2.fromOffset(0, 40); infoFrame.BackgroundTransparency = 1
local coordLabel = Instance.new("TextLabel", infoFrame); coordLabel.Size = UDim2.new(1,0,0,25); coordLabel.BackgroundTransparency = 1; coordLabel.TextColor3 = Color3.fromRGB(200,200,200); coordLabel.Font = Enum.Font.Code; coordLabel.TextSize = 11
local pingLabel = Instance.new("TextLabel", infoFrame); pingLabel.Size = UDim2.new(1,0,0,25); pingLabel.Position = UDim2.fromOffset(0, 20); pingLabel.BackgroundTransparency = 1; pingLabel.TextColor3 = Color3.fromRGB(0,255,180); pingLabel.Font = Enum.Font.GothamBold; pingLabel.TextSize = 13
local xmasCountdown = Instance.new("TextLabel", infoFrame); xmasCountdown.Size = UDim2.new(1,0,0,25); xmasCountdown.Position = UDim2.fromOffset(0, 40); xmasCountdown.BackgroundTransparency = 1; xmasCountdown.TextColor3 = Color3.fromRGB(255,200,0); xmasCountdown.Font = Enum.Font.GothamBold; xmasCountdown.TextSize = 13

-- 6. SIDE PANELS (SPOT & PLAYER)
local spotFrame = Instance.new("Frame", frame); spotFrame.Size = UDim2.fromOffset(180, 220); spotFrame.Position = UDim2.new(0, -190, 0, 0); spotFrame.BackgroundColor3 = Color3.fromRGB(25,25,25); spotFrame.Visible = false; Instance.new("UICorner", spotFrame).CornerRadius = UDim.new(0,8)
local spotList = Instance.new("ScrollingFrame", spotFrame); spotList.Position = UDim2.fromOffset(5,35); spotList.Size = UDim2.new(1,-10,1,-45); spotList.BackgroundTransparency = 1; spotList.ScrollBarThickness = 0; Instance.new("UIListLayout", spotList).Padding = UDim.new(0,5)
local SPOTS = { ["Spot 1"] = CFrame.new(606.0, -580.6, 8923.3), ["Spot 2"] = CFrame.new(603.4, -580.6, 8886.0), ["Spot 3"] = CFrame.new(576.8, -580.7, 8845.8), ["Spot 4"] = CFrame.new(774.6, -487.2, 8923.0) }
_G.SelectedEventSpot = SPOTS["Spot 1"]
for name, cf in pairs(SPOTS) do
    local b = Instance.new("TextButton", spotList); b.Size = UDim2.new(1, 0, 0, 30); b.BackgroundColor3 = Color3.fromRGB(45,45,45); b.Text = name; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; b.TextSize = 12; Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
    b.MouseButton1Click:Connect(function() _G.SelectedEventSpot = cf end)
end

local playerListFrame = Instance.new("Frame", frame); playerListFrame.Size = UDim2.fromOffset(200, 300); playerListFrame.Position = UDim2.new(1, 15, 0, 0); playerListFrame.BackgroundColor3 = Color3.fromRGB(25,25,25); playerListFrame.Visible = false; Instance.new("UICorner", playerListFrame).CornerRadius = UDim.new(0,8)
local scroll = Instance.new("ScrollingFrame", playerListFrame); scroll.Position = UDim2.fromOffset(5,35); scroll.Size = UDim2.new(1,-10,1,-45); scroll.BackgroundTransparency = 1; scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; scroll.ScrollBarThickness = 0; Instance.new("UIListLayout", scroll).Padding = UDim.new(0,5)

local function refreshPlayerList()
    for _,c in pairs(scroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local b = Instance.new("TextButton", scroll); b.Size = UDim2.new(1, 0, 0, 30); b.BackgroundColor3 = Color3.fromRGB(45,45,45); b.Text = " " .. plr.DisplayName; b.TextColor3 = Color3.new(1,1,1); b.TextXAlignment = Enum.TextXAlignment.Left; b.Font = Enum.Font.Gotham; b.TextSize = 12; Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
            b.MouseButton1Click:Connect(function() 
                if HRP() and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then 
                    HRP().CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3) 
                end 
            end)
        end
    end
end

-- 7. FEATURES AREA (BUTTONS)
local contentScroll = Instance.new("ScrollingFrame", frame); contentScroll.Position = UDim2.fromOffset(0, 130); contentScroll.Size = UDim2.new(1,0,1,-140); contentScroll.BackgroundTransparency = 1; contentScroll.ScrollBarThickness = 0; Instance.new("UIListLayout", contentScroll).HorizontalAlignment = Enum.HorizontalAlignment.Center; Instance.new("UIListLayout", contentScroll).Padding = UDim.new(0,8)
local function createBtn(text)
    local b = Instance.new("TextButton", contentScroll); b.Size = UDim2.new(0, 270, 0, 36); b.BackgroundColor3 = Color3.fromRGB(35,35,35); b.Text = text; b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    return b
end

local fly, noclip, autoXmas, flySpeed = false, false, false, 100
local flyBtn = createBtn("Fly: OFF")
local noclipBtn = createBtn("Noclip: OFF")
local myStatsBtn = createBtn("My Stats: OFF")
local pingBtn = createBtn("Ping Panel: OFF")
local tpBtn = createBtn("Teleport To Player")
local xmasBtn = createBtn("Auto Christmas: OFF")
local spotBtn = createBtn("Pick Event Spot")
local hideBtn = createBtn("Hide Game UI")

-- HANDLERS
flyBtn.MouseButton1Click:Connect(function() 
    fly = not fly; flyBtn.Text = fly and "Fly: ON" or "Fly: OFF"
    local hrp = HRP()
    if fly and hrp then
        local bv = Instance.new("BodyVelocity", hrp); bv.Name = "SoraFly"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge); bv.Velocity = Vector3.zero
        local bg = Instance.new("BodyGyro", hrp); bg.Name = "SoraGyro"; bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bg.CFrame = hrp.CFrame
        player.Character.Humanoid.PlatformStand = true
    else
        if HRP() then 
            if HRP():FindFirstChild("SoraFly") then HRP().SoraFly:Destroy() end 
            if HRP():FindFirstChild("SoraGyro") then HRP().SoraGyro:Destroy() end 
        end
        if player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.PlatformStand = false end
    end
end)

noclipBtn.MouseButton1Click:Connect(function() noclip = not noclip; noclipBtn.Text = noclip and "Noclip: ON" or "Noclip: OFF" end)
myStatsBtn.MouseButton1Click:Connect(function() myStatsFrame.Visible = not myStatsFrame.Visible; myStatsBtn.Text = myStatsFrame.Visible and "My Stats: ON" or "My Stats: OFF" end)
pingBtn.MouseButton1Click:Connect(function() pingPanel.Visible = not pingPanel.Visible; pingBtn.Text = pingPanel.Visible and "Ping Panel: ON" or "Ping Panel: OFF" end)
tpBtn.MouseButton1Click:Connect(function() playerListFrame.Visible = not playerListFrame.Visible; if playerListFrame.Visible then refreshPlayerList() end end)
spotBtn.MouseButton1Click:Connect(function() spotFrame.Visible = not spotFrame.Visible end)
xmasBtn.MouseButton1Click:Connect(function() autoXmas = not autoXmas; xmasBtn.Text = autoXmas and "Auto Christmas: ON" or "Auto Christmas: OFF" end)

local uiHidden = false
hideBtn.MouseButton1Click:Connect(function()
    uiHidden = not uiHidden; hideBtn.Text = uiHidden and "Show Game UI" or "Hide Game UI"
    for _, v in pairs(player.PlayerGui:GetChildren()) do if v:IsA("ScreenGui") and v.Name ~= gui.Name then v.Enabled = not uiHidden end end
end)

minimize.MouseButton1Click:Connect(function() frame.Visible = false; openLogo.Visible = true end)
openLogo.MouseButton1Click:Connect(function() openLogo.Visible = false; frame.Visible = true end)

-- 8. MONITORING PLAYER EVENTS (JOIN/LEAVE)
Players.PlayerAdded:Connect(function(plr)
    if targetData[plr.Name] then
        sendToDiscord("PLAYER JOINED", "AKUN @" .. plr.Name:upper() .. " TELAH JOIN KE SERVER", plr.Name, 65460)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if targetData[plr.Name] and plr.Name ~= Players.LocalPlayer.Name then
        sendToDiscord("PLAYER LEFT", "AKUN @" .. plr.Name:upper() .. " KELUAR DARI SERVER", plr.Name, 16724814)
    end
end)

-- 9. MAIN LOOPS
local EVENT_HOURS = {0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22}
local teleported, lastPos = false, nil
local afkTimer = {}
local lastCaught = {}

-- Loop Monitoring AFK (1m, 10m, 1h)
task.spawn(function()
    while task.wait(60) do
        for _, p in pairs(Players:GetPlayers()) do
            if targetData[p.Name] then
                local s = p:FindFirstChild("leaderstats")
                if s and s:FindFirstChild("Caught") then
                    local current = s.Caught.Value
                    if lastCaught[p.UserId] and lastCaught[p.UserId] == current then
                        afkTimer[p.UserId] = (afkTimer[p.UserId] or 0) + 1
                        local timeAfk = afkTimer[p.UserId]
                        if timeAfk == 1 then
                            sendToDiscord("AFK WARNING", "AKUN @" .. p.Name:upper() .. " TIDAK MENARIK PANCINGAN SELAMA 1 MENIT", p.Name, 16776960)
                        elseif timeAfk == 10 then
                            sendToDiscord("AFK WARNING", "AKUN @" .. p.Name:upper() .. " TIDAK MENARIK PANCINGAN SELAMA 10 MENIT", p.Name, 16753920)
                        elseif timeAfk == 60 then
                            sendToDiscord("AFK WARNING", "AKUN @" .. p.Name:upper() .. " TIDAK MENARIK PANCINGAN SELAMA 1 JAM", p.Name, 16711680)
                        end
                    else
                        afkTimer[p.UserId] = 0
                    end
                    lastCaught[p.UserId] = current
                end
            end
        end
    end
end)

-- Render Loops (UI & Fly)
RunService.RenderStepped:Connect(function()
    local hrp = HRP()
    if hrp then 
        coordLabel.Text = string.format("POS: X:%.1f Y:%.1f Z:%.1f", hrp.Position.X, hrp.Position.Y, hrp.Position.Z) 
        local pVal = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        pingLabel.Text = "PING: " .. pVal .. " ms"
        if pingPanel.Visible then pingText.Text = pVal .. " MS" end
        if myStatsFrame.Visible and statsData then 
            caughtVal.Text = formatFullNumber(statsData.Caught.Value) 
            sessionVal.Text = "Session: +" .. formatFullNumber(statsData.Caught.Value - initialCaught)
        end
    end

    if fly and hrp and hrp:FindFirstChild("SoraFly") and hrp:FindFirstChild("SoraGyro") then
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0, 1, 0) end
        hrp.SoraFly.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
        hrp.SoraGyro.CFrame = cam.CFrame
    end

    local t = os.date("!*t", workspace:GetServerTimeNow())
    local nextH = 24
    for _,h in pairs(EVENT_HOURS) do if h > t.hour then nextH = h; break end end
    local diff = os.time({year=t.year, month=t.month, day=t.day, hour=nextH, min=0, sec=0}) - workspace:GetServerTimeNow()
    xmasCountdown.Text = string.format("Next Event: %02d:%02d:%02d", math.floor(diff/3600), math.floor((diff%3600)/60), math.floor(diff%60))
end)

-- Physics Loop (Noclip & Auto Christmas)
RunService.Stepped:Connect(function()
    if noclip and player.Character then for _,v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    
    if autoXmas and HRP() then
        local t = os.date("!*t", workspace:GetServerTimeNow())
        local isE = false; for _,h in pairs(EVENT_HOURS) do if t.hour == h then isE = true break end end
        if isE and t.min == 0 and t.sec >= 30 and not teleported then
            lastPos = HRP().CFrame; HRP().CFrame = _G.SelectedEventSpot; teleported = true
        elseif t.min == 29 and t.sec >= 30 and teleported then
            HRP().CFrame = lastPos or HRP().CFrame; teleported = false
        end
        if not isE then teleported = false end
    end
end)
