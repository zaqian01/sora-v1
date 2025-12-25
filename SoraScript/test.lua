-- =====================================================================
-- SORA HUB V5.9 - TEST WEBHOOK & AVATAR SYSTEM
-- =====================================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local webhookURL = "https://discord.com/api/webhooks/1441417921552191488/OLnhBfgM4fh1sG97NpipcG66OyNwrqJmARcKVgrxPQxC1u70iH4pnF-VVS5XxRTTh9va"

local targetData = {
    ["el_sora67"] = "1288092342213148728",
    ["Unf0rgettable_5"] = "1378790404237037680",
    ["KINGGPALLLZ"] = "1409506714939687022",
    ["RNGvoided"] = "" 
}

-- ================= UTILS =================

local function sendToDiscord(title, message, playerName, color)
    local userId = 0
    pcall(function() userId = Players:GetUserIdFromNameAsync(playerName) end)
    
    local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(userId) .. "&width=420&height=420&format=png"
    local discordId = targetData[playerName]
    
    local data = {
        ["content"] = (discordId and discordId ~= "") and "<@" .. discordId .. ">" or "", 
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = message,
            ["color"] = color or 65460,
            ["thumbnail"] = { ["url"] = avatarUrl },
            ["footer"] = { ["text"] = "SORA TEST SYSTEM" },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    
    local request = http_request or request or syn.request
    if request then
        request({
            Url = webhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end
end

-- ================= GUI SETUP =================

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SORA_TEST_WEBHOOK"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(250, 150)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local testBtn = Instance.new("TextButton", frame)
testBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
testBtn.Position = UDim2.fromScale(0.05, 0.3)
testBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
testBtn.Text = "TEST WEBHOOK (AVATAR)"
testBtn.Font = Enum.Font.GothamBold
testBtn.TextSize = 14
testBtn.TextColor3 = Color3.new(0,0,0)
Instance.new("UICorner", testBtn)

-- ================= TEST LOGIC =================

testBtn.MouseButton1Click:Connect(function()
    testBtn.Text = "SENDING..."
    testBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    local testTargets = {"el_sora67", "Unf0rgettable_5", "KINGGPALLLZ"}
    
    for _, name in pairs(testTargets) do
        local currentStats = "0"
        -- Coba ambil stats asli jika orangnya ada di server
        local pObj = Players:FindFirstChild(name)
        if pObj and pObj:FindFirstChild("leaderstats") and pObj.leaderstats:FindFirstChild("Caught") then
            currentStats = tostring(pObj.leaderstats.Caught.Value)
        else
            currentStats = "Offline / Not Found"
        end
        
        sendToDiscord(
            "WEBHOOK TEST (AVATAR CHECK)", 
            "USER: @" .. name:upper() .. "\nSTATS: " .. currentStats .. " CAUGHT", 
            name, 
            3447003
        )
        task.wait(1) -- Delay biar gak kena rate limit Discord
    end
    
    testBtn.Text = "TEST SENT!"
    task.wait(2)
    testBtn.Text = "TEST WEBHOOK (AVATAR)"
    testBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
end)

print("SORA: Test Button Loaded! Klik tombol di layar untuk tes Avatar.")
