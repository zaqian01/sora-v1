-- ================= SORA RECORDER V2 (AUTO-SAVE) =================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local placeId = game.PlaceId
local fileName = "SORA_MAP_" .. placeId .. ".json"

local recordedPoints = {}

-- FUNGSI SAVE KE FILE
local function saveToFile()
    local data = {}
    for _, cf in ipairs(recordedPoints) do
        -- CFrame harus dipecah jadi table biar bisa masuk JSON
        table.insert(data, {cf:GetComponents()})
    end
    writefile(fileName, HttpService:JSONEncode(data))
end

-- FUNGSI LOAD DARI FILE
local function loadFromFile()
    if isfile(fileName) then
        local content = readfile(fileName)
        local data = HttpService:JSONDecode(content)
        recordedPoints = {}
        for _, components in ipairs(data) do
            table.insert(recordedPoints, CFrame.new(unpack(components)))
        end
        return true
    end
    return false
end

-- ================= UI & LOGIC =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SoraRecorderV2"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260, 280)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "SORA MAP RECORDER V2"
title.TextColor3 = Color3.fromRGB(0, 255, 180)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Font = Enum.Font.GothamBold
Instance.new("UICorner", title)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 0.88, 0)
status.Text = "Checking for save data..."
status.TextColor3 = Color3.new(0.8, 0.8, 0.8)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextSize = 10

-- BUTTON CREATOR UTILS
local function createBtn(text, pos, color)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0, 220, 0, 35); b.Position = pos; b.AnchorPoint = Vector2.new(0.5, 0); b.Text = text; b.BackgroundColor3 = color; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    return b
end

local recBtn = createBtn("RECORD POINT (0)", UDim2.new(0.5, 0, 0.18, 0), Color3.fromRGB(45, 45, 90))
local rushBtn = createBtn("START AUTO RUSH", UDim2.new(0.5, 0, 0.35, 0), Color3.fromRGB(45, 90, 45))
local saveBtn = createBtn("SAVE TO FILE", UDim2.new(0.5, 0, 0.52, 0), Color3.fromRGB(120, 80, 20))
local clearBtn = createBtn("CLEAR DATA", UDim2.new(0.5, 0, 0.69, 0), Color3.fromRGB(100, 30, 30))

-- HANDLERS
recBtn.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        table.insert(recordedPoints, hrp.CFrame)
        recBtn.Text = "RECORD POINT (" .. #recordedPoints .. ")"
        status.Text = "Point recorded!"
    end
end)

local rushing = false
rushBtn.MouseButton1Click:Connect(function()
    if #recordedPoints == 0 then status.Text = "No points recorded!"; return end
    rushing = not rushing
    rushBtn.Text = rushing and "STOP RUSH" or "START AUTO RUSH"
    
    if rushing then
        task.spawn(function()
            for i, cf in ipairs(recordedPoints) do
                if not rushing then break end
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = cf
                    status.Text = "Teleporting to Point " .. i
                    task.wait(1.5)
                end
            end
            rushing = false
            rushBtn.Text = "START AUTO RUSH"
            status.Text = "Rush Finished!"
        end)
    end
end)

saveBtn.MouseButton1Click:Connect(function()
    saveToFile()
    status.Text = "Saved to: " .. fileName
end)

clearBtn.MouseButton1Click:Connect(function()
    recordedPoints = {}
    recBtn.Text = "RECORD POINT (0)"
    if isfile(fileName) then delfile(fileName) end
    status.Text = "Data and File Deleted!"
end)

-- AUTO LOAD ON STARTUP
task.spawn(function()
    if loadFromFile() then
        recBtn.Text = "RECORD POINT (" .. #recordedPoints .. ")"
        status.Text = "Loaded data for Map: " .. placeId
    else
        status.Text = "No previous data for this map."
    end
end)
