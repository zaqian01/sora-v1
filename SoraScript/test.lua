-- ================= SORA PATH RECORDER (TESTING) =================
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SoraRecorder"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(250, 250)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35); title.Text = "SORA RECORDER"; title.TextColor3 = Color3.fromRGB(0, 255, 180); title.BackgroundColor3 = Color3.fromRGB(30, 30, 30); title.Font = Enum.Font.GothamBold; Instance.new("UICorner", title)

-- DATA STORAGE
local recordedPoints = {}

local function HRP()
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

-- BUTTON CREATOR
local function createBtn(text, pos, color)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0, 200, 0, 35); b.Position = pos; b.AnchorPoint = Vector2.new(0.5, 0.5); b.Text = text; b.BackgroundColor3 = color; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    return b
end

local recBtn = createBtn("RECORD POINT (0)", UDim2.new(0.5, 0, 0.3, 0), Color3.fromRGB(40, 40, 80))
local rushBtn = createBtn("START AUTO RUSH", UDim2.new(0.5, 0, 0.5, 0), Color3.fromRGB(40, 80, 40))
local clearBtn = createBtn("CLEAR DATA", UDim2.new(0.5, 0, 0.7, 0), Color3.fromRGB(80, 40, 40))
local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, 0, 0, 20); status.Position = UDim2.new(0, 0, 0.85, 0); status.Text = "Status: Idle"; status.TextColor3 = Color3.new(1,1,1); status.BackgroundTransparency = 1; status.Font = Enum.Font.Gotham; status.TextSize = 10

-- RECORD LOGIC
recBtn.MouseButton1Click:Connect(function()
    local hrp = HRP()
    if hrp then
        table.insert(recordedPoints, hrp.CFrame)
        recBtn.Text = "RECORD POINT (" .. #recordedPoints .. ")"
        status.Text = "Point " .. #recordedPoints .. " Saved!"
        task.wait(0.2)
        status.Text = "Status: Waiting for next point..."
    end
end)

-- AUTO RUSH LOGIC
local rushing = false
rushBtn.MouseButton1Click:Connect(function()
    if #recordedPoints == 0 then status.Text = "Error: No data recorded!"; return end
    
    rushing = not rushing
    rushBtn.Text = rushing and "STOP RUSH" or "START AUTO RUSH"
    
    if rushing then
        task.spawn(function()
            for i, cf in ipairs(recordedPoints) do
                if not rushing then break end
                local hrp = HRP()
                if hrp then
                    hrp.CFrame = cf
                    status.Text = "TP to Point: " .. i
                    task.wait(1.5) -- Delay antar TP
                end
            end
            rushing = false
            rushBtn.Text = "START AUTO RUSH"
            status.Text = "Status: Finish!"
        end)
    end
end)

clearBtn.MouseButton1Click:Connect(function()
    recordedPoints = {}
    recBtn.Text = "RECORD POINT (0)"
    status.Text = "Data Cleared!"
end)
