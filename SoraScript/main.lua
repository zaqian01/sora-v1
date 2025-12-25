-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- ================= DISCORD CONFIG =================
local webhookURL = "https://discord.com/api/webhooks/1441417921552191488/OLnhBfgM4fh1sG97NpipcG66OyNwrqJmARcKVgrxPQxC1u70iH4pnF-VVS5XxRTTh9va"
local targetData = {
    ["el_sora67"] = "1288092342213148728",
    ["Unf0rgettable_5"] = "1378790404237037680",
    ["KINGGPALLLZ"] = "1409506714939687022",
    ["RNGvoided"] = "" 
}
local isClosing = false

-- ================= UTILS =================
local function formatFullNumber(n)
    return tostring(n):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

local function HRP()
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

local function sendToDiscord(title, message, playerName, color)
    if isClosing then return end
    local discordId = targetData[playerName]
    local avatarUrl = ""
    pcall(function()
        if playerName then
            local userId = Players:GetUserIdFromNameAsync(playerName)
            avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"
        end
    end)
    
    local data = {
        ["content"] = (discordId and discordId ~= "") and "<@" .. discordId .. ">" or "", 
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = message,
            ["color"] = color or 65460,
            ["thumbnail"] = (avatarUrl ~= "") and { ["url"] = avatarUrl } or nil,
            ["footer"] = { ["text"] = "SORA MONITORING SYSTEM" },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    local req = http_request or request or syn.request
    if req then req({ Url = webhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data) }) end
end

-- ================= ANTI AFK =================
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ================= GUI SYSTEM =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SORA_HUB_V5_REPAIRED"
gui.ResetOnSpawn = false

-- MY STATS PANEL
local initialCaught = 0
local statsData = player:WaitForChild("leaderstats", 10):WaitForChild("Caught", 10)
if statsData then initialCaught = statsData.Value end

local myStatsFrame = Instance.new("Frame", gui)
myStatsFrame.Size = UDim2.fromOffset(180, 110); myStatsFrame.Position = UDim2.new(1, -190, 0.2, 0); myStatsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); myStatsFrame.Visible = false; myStatsFrame.Active = true; myStatsFrame.Draggable = true
Instance.new("UICorner", myStatsFrame); Instance.new("UIStroke", myStatsFrame).Color = Color3.fromRGB(0, 255, 180)
local caughtVal = Instance.new("TextLabel", myStatsFrame); caughtVal.Size = UDim2.new(1, 0, 0, 40); caughtVal.Position = UDim2.fromOffset(0, 35); caughtVal.Text = "0"; caughtVal.TextColor3 = Color3.new(1,1,1); caughtVal.Font = Enum.Font.Code; caughtVal.TextSize = 26; caughtVal.BackgroundTransparency = 1
local sessionVal = Instance.new("TextLabel", myStatsFrame); sessionVal.Size = UDim2.new(1, 0, 0, 20); sessionVal.Position = UDim2.fromOffset(0, 70); sessionVal.Text = "Session: +0"; sessionVal.TextColor3 = Color3.fromRGB(255, 200, 0); sessionVal.Font = Enum.Font.Gotham; sessionVal.TextSize = 12; sessionVal.BackgroundTransparency = 1

-- PING PANEL
local pingPanel = Instance.new("Frame", gui)
pingPanel.Size = UDim2.fromOffset(130, 45); pingPanel.Position = UDim2.new(1, -140, 0.1, 0); pingPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15); pingPanel.Visible = false; pingPanel.Active = true; pingPanel.Draggable = true
Instance.new("UICorner", pingPanel); Instance.new("UIStroke", pingPanel).Color = Color3.fromRGB(0, 255, 180)
local pingText = Instance.new("TextLabel", pingPanel); pingText.Size = UDim2.new(1, 0, 1, 0); pingText.Text = "0 MS"; pingText.TextColor3 = Color3.fromRGB(0, 255, 180); pingText.Font = Enum.Font.GothamBold; pingText.TextSize = 18; pingText.BackgroundTransparency = 1

-- MAIN PANEL
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(300, 480); frame.Position = UDim2.fromScale(0.35, 0.2); frame.BackgroundColor3 = Color3.fromRGB(18,18,18); frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame)

local header = Instance.new("Frame", frame); header.Size = UDim2.new(1,0,0,40); header.BackgroundColor3 = Color3.fromRGB(25,25,25); Instance.new("UICorner", header)
local title = Instance.new("TextLabel", header); title.Size = UDim2.new(1,-50,1,0); title.Position = UDim2.fromOffset(12,0); title.BackgroundTransparency = 1; title.Text = "SORA HUB V5.6"; title.TextColor3 = Color3.fromRGB(0,255,180); title.Font = Enum.Font.GothamBold; title.TextSize = 18; title.TextXAlignment = Enum.TextXAlignment.Left

local minimize = Instance.new("TextButton", header); minimize.Size = UDim2.fromOffset(36,26); minimize.Position = UDim2.new(1, -10, 0.5, 0); minimize.AnchorPoint = Vector2.new(1,0.5); minimize.BackgroundColor3 = Color3.fromRGB(40,40,40); minimize.Text = "–"; minimize.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", minimize)

local openLogo = Instance.new("ImageButton", gui); openLogo.Size = UDim2.fromOffset(60, 60); openLogo.Position = UDim2.fromScale(0.02, 0.5); openLogo.BackgroundTransparency = 1; openLogo.Visible = false; openLogo.Image = "rbxassetid://107169258644997"; Instance.new("UICorner", openLogo)

-- BUTTONS AREA
local contentScroll = Instance.new("ScrollingFrame", frame); contentScroll.Position = UDim2.fromOffset(0, 50); contentScroll.Size = UDim2.new(1,0,1,-60); contentScroll.BackgroundTransparency = 1; contentScroll.ScrollBarThickness = 0
Instance.new("UIListLayout", contentScroll).HorizontalAlignment = Enum.HorizontalAlignment.Center; contentScroll.UIListLayout.Padding = UDim.new(0,8)

local function createBtn(text)
    local b = Instance.new("TextButton", contentScroll); b.Size = UDim2.new(0, 270, 0, 36); b.BackgroundColor3 = Color3.fromRGB(35,35,35); b.Text = text; b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    return b
end

local flyBtn = createBtn("Fly: OFF")
local noclipBtn = createBtn("Noclip: OFF")
local myStatsBtn = createBtn("My Stats: OFF")
local pingBtn = createBtn("Ping Panel: OFF")
local tpBtn = createBtn("Teleport To Player")
local xmasBtn = createBtn("Auto Christmas: OFF")
local hideBtn = createBtn("Hide Game UI")

-- HANDLERS
local fly, noclip, autoXmas, flySpeed = false, false, false, 100
flyBtn.MouseButton1Click:Connect(function()
    fly = not fly; flyBtn.Text = fly and "Fly: ON" or "Fly: OFF"
    local hrp = HRP()
    if fly and hrp then
        local bv = Instance.new("BodyVelocity", hrp); bv.Name = "SoraFly"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        local bg = Instance.new("BodyGyro", hrp); bg.Name = "SoraGyro"; bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        player.Character.Humanoid.PlatformStand = true
    else
        if HRP() then if HRP():FindFirstChild("SoraFly") then HRP().SoraFly:Destroy() end if HRP():FindFirstChild("SoraGyro") then HRP().SoraGyro:Destroy() end end
        if player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.PlatformStand = false end
    end
end)

noclipBtn.MouseButton1Click:Connect(function() noclip = not noclip; noclipBtn.Text = noclip and "Noclip: ON" or "Noclip: OFF" end)
myStatsBtn.MouseButton1Click:Connect(function() myStatsFrame.Visible = not myStatsFrame.Visible; myStatsBtn.Text = myStatsFrame.Visible and "My Stats: ON" or "My Stats: OFF" end)
pingBtn.MouseButton1Click:Connect(function() pingPanel.Visible = not pingPanel.Visible; pingBtn.Text = pingPanel.Visible and "Ping Panel: ON" or "Ping Panel: OFF" end)
tpBtn.MouseButton1Click:Connect(function() -- Tambahkan logic teleport sederhana ke player random sebagai contoh
    local plrs = Players:GetPlayers()
    local target = plrs[math.random(2, #plrs)]
    if target and target.Character then HRP().CFrame = target.Character.HumanoidRootPart.CFrame end
end)
xmasBtn.MouseButton1Click:Connect(function() autoXmas = not autoXmas; xmasBtn.Text = autoXmas and "Auto Christmas: ON" or "Auto Christmas: OFF" end)
minimize.MouseButton1Click:Connect(function() frame.Visible = false; openLogo.Visible = true end)
openLogo.MouseButton1Click:Connect(function() openLogo.Visible = false; frame.Visible = true end)

-- ================= LOGIC LOOPS =================
sendToDiscord("HOST ACTIVATE", "PENGELOLAAN WEBHOOK TELAH TERSAMBUNG. HOST: @" .. player.Name:upper(), player.Name, 65460)

RunService.RenderStepped:Connect(function()
    local hrp = HRP()
    -- PING & STATS UPDATE
    local pVal = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    if pingPanel.Visible then pingText.Text = pVal .. " MS" end
    if myStatsFrame.Visible and statsData then 
        caughtVal.Text = formatFullNumber(statsData.Value)
        sessionVal.Text = "Session: +" .. formatFullNumber(statsData.Value - initialCaught)
    end

    -- FLY LOGIC
    if fly and hrp and hrp:FindFirstChild("SoraFly") then
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
        hrp.SoraFly.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
        hrp.SoraGyro.CFrame = cam.CFrame
    end
    
    -- NOCLIP
    if noclip and player.Character then
        for _,v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- AFK MONITOR DISCORD
local lastCaughtVal = {}
local afkTime = {}
task.spawn(function()
    while task.wait(60) do
        for _, p in pairs(Players:GetPlayers()) do
            if targetData[p.Name] then
                local s = p:FindFirstChild("leaderstats") and p.leaderstats:FindFirstChild("Caught")
                if s then
                    if lastCaughtVal[p.Name] == s.Value then
                        afkTime[p.Name] = (afkTime[p.Name] or 0) + 1
                        if afkTime[p.Name] == 1 then sendToDiscord("AFK WARNING", "AKUN @"..p.Name:upper().." TIDAK MANCING 1 MENIT", p.Name, 16776960) end
                    else
                        afkTime[p.Name] = 0
                    end
                    lastCaughtVal[p.Name] = s.Value
                end
            end
        end
    end
end)
