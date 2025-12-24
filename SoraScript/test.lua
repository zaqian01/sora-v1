-- ================= SORA TESTING (MOUNTAIN MODULE) =================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- GUI ROOT
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SoraTesting"

-- MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(250, 200)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- HEADER
local header = Instance.new("TextLabel", frame)
header.Size = UDim2.new(1, 0, 0, 35)
header.Text = "SORA TESTING V1"
header.TextColor3 = Color3.fromRGB(0, 255, 180)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
header.Font = Enum.Font.GothamBold
header.TextSize = 14
Instance.new("UICorner", header)

-- UTILS
local function HRP()
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

local function getCheckpoints()
    local points = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("SpawnLocation") then
            local name = v.Name:lower()
            -- Deteksi keyword umum di map obby/gunung
            if name:find("checkpoint") or name:find("stage") or name:find("spawnpoint") or name:find("flag") then
                table.insert(points, v)
            end
        end
    end
    
    -- Sorting berdasarkan angka di nama
    table.sort(points, function(a, b)
        local numA = tonumber(a.Name:match("%d+")) or 0
        local numB = tonumber(b.Name:match("%d+")) or 0
        return numA < numB
    end)
    return points
end

-- LOGIC RUNNER
local isRunning = false

local function runAutoSummit(delayTime)
    local points = getCheckpoints()
    if #points == 0 then print("SORA: Ga ada checkpoint ketemu!") return end
    
    for i, cp in ipairs(points) do
        if not isRunning then break end
        local hrp = HRP()
        if hrp then
            -- Teleport 3 unit di atas checkpoint biar ga nyangkut
            hrp.CFrame = cp.CFrame * CFrame.new(0, 3, 0)
            print("SORA: TP ke " .. cp.Name)
            task.wait(delayTime)
        end
    end
    isRunning = false
    print("SORA: Selesai!")
end

-- BUTTONS
local startBtn = Instance.new("TextButton", frame)
startBtn.Size = UDim2.new(0, 200, 0, 40)
startBtn.Position = UDim2.new(0.5, 0, 0.4, 0)
startBtn.AnchorPoint = Vector2.new(0.5, 0.5)
startBtn.Text = "Start Auto Summit"
startBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", startBtn)

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Size = UDim2.new(0, 200, 0, 40)
stopBtn.Position = UDim2.new(0.5, 0, 0.7, 0)
stopBtn.AnchorPoint = Vector2.new(0.5, 0.5)
stopBtn.Text = "Stop"
stopBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", stopBtn)

-- HANDLERS
startBtn.MouseButton1Click:Connect(function()
    if not isRunning then
        isRunning = true
        startBtn.Text = "Running..."
        task.spawn(function()
            runAutoSummit(1.5) -- Ganti 1.5 ini buat atur delay detik
            startBtn.Text = "Start Auto Summit"
        end)
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    isRunning = false
    startBtn.Text = "Start Auto Summit"
end)

print("SORA TESTING: Loaded. Selamat mencoba di map gunung!")
