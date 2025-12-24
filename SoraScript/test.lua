-- ================= SORA MOUNTAIN TESTING (GITHUB VERSION) =================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- GUI ROOT
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SoraTestingV1"

-- MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(250, 220)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- HEADER
local header = Instance.new("TextLabel", frame)
header.Size = UDim2.new(1, 0, 0, 35)
header.Text = "SORA MOUNTAIN RUSH"
header.TextColor3 = Color3.fromRGB(0, 255, 180)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
header.Font = Enum.Font.GothamBold
header.TextSize = 14
Instance.new("UICorner", header)

-- LOGIC VARIABLES
local isRunning = false
local currentDelay = 1.5

-- UTILS
local function HRP()
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

-- SMART DETECTOR (Mencari Checkpoint secara berurutan)
local function getOrderedCheckpoints()
    local points = {}
    
    -- Scan semua objek yang berpotensi jadi checkpoint
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("SpawnLocation") then
            local n = v.Name:lower()
            if n:find("checkpoint") or n:find("stage") or n:find("spawn") or n:match("^%d+$") then
                table.insert(points, v)
            end
        end
    end
    
    -- Sort berdasarkan angka di nama (Stage 1, Stage 2...)
    table.sort(points, function(a, b)
        local numA = tonumber(a.Name:match("%d+")) or 0
        local numB = tonumber(b.Name:match("%d+")) or 0
        return numA < numB
    end)
    
    return points
end

-- RUNNER
local function startRush()
    local list = getOrderedCheckpoints()
    if #list == 0 then warn("SORA: Ga ketemu checkpoint apapun!") return end
    
    print("SORA: Menemukan " .. #list .. " checkpoint. Memulai...")
    
    for i, part in ipairs(list) do
        if not isRunning then break end
        
        local hrp = HRP()
        if hrp then
            -- Teleport mulus sedikit di atas part
            hrp.CFrame = part.CFrame * CFrame.new(0, 4, 0)
            print("SORA: Teleport ke -> " .. part.Name)
            task.wait(currentDelay)
        end
    end
    
    isRunning = false
    print("SORA: Rush Selesai!")
end

-- UI BUTTONS
local function createBtn(text, pos, color)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0, 200, 0, 40)
    b.Position = pos
    b.AnchorPoint = Vector2.new(0.5, 0.5)
    b.Text = text
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    return b
end

local startBtn = createBtn("START RUSH", UDim2.new(0.5, 0, 0.4, 0), Color3.fromRGB(40, 60, 40))
local stopBtn = createBtn("STOP", UDim2.new(0.5, 0, 0.65, 0), Color3.fromRGB(80, 30, 30))
local delayLabel = Instance.new("TextLabel", frame)
delayLabel.Size = UDim2.new(1, 0, 0, 20)
delayLabel.Position = UDim2.new(0, 0, 0.85, 0)
delayLabel.Text = "Delay: " .. currentDelay .. "s (Safe Mode)"
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 11

-- HANDLERS
startBtn.MouseButton1Click:Connect(function()
    if not isRunning then
        isRunning = true
        startBtn.Text = "RUSHING..."
        task.spawn(startRush)
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    isRunning = false
    startBtn.Text = "START RUSH"
end)
