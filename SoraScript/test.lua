-- =====================================================================
-- SORA HUB V6.0 - STABLE AVATAR INTEGRATION
-- =====================================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local webhookURL = "https://discord.com/api/webhooks/1441417921552191488/OLnhBfgM4fh1sG97NpipcG66OyNwrqJmARcKVgrxPQxC1u70iH4pnF-VVS5XxRTTh9va"

-- Nama Roblox harus sesuai profil
local targetData = {
    ["el_sora67"] = "1288092342213148728",
    ["Unf0rgettable_5"] = "1378790404237037680",
    ["KINGGPALLLZ"] = "1409506714939687022",
    ["RNGvoided"] = "" 
}

-- ================= AVATAR ENGINE =================

local function getAvatar(userId)
    -- Mencoba mengambil 2 jenis format gambar agar pasti muncul salah satu
    local url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(userId) .. "&width=420&height=420&format=png"
    
    -- Verifikasi UserID (Backup plan)
    if userId == 0 or userId == nil then
        return "https://www.roblox.com/headshot-thumbnail/image?userId=1&width=420&height=420&format=png" -- Default noob avatar
    end
    
    return url
end

local function sendToDiscord(title, message, playerName, color)
    local userId = 0
    -- Mencoba mendapatkan ID dari nama secara aman
    pcall(function() userId = Players:GetUserIdFromNameAsync(playerName) end)
    
    local avatarUrl = getAvatar(userId)
    local discordId = targetData[playerName]
    
    local data = {
        ["content"] = (discordId and discordId ~= "") and "<@" .. discordId .. ">" or "", 
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = message,
            ["color"] = color or 65460,
            -- Thumbnail (Kecil di samping) & Image (Besar di bawah)
            ["thumbnail"] = { ["url"] = avatarUrl },
            ["footer"] = { ["text"] = "SORA HUB | AVATAR FIXED" },
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
gui.Name = "SORA_AVATAR_FIX"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(250, 100)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local testBtn = Instance.new("TextButton", frame)
testBtn.Size = UDim2.new(0.9, 0, 0.6, 0)
testBtn.Position = UDim2.fromScale(0.05, 0.2)
testBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
testBtn.Text = "FORCE TEST AVATAR"
testBtn.Font = Enum.Font.GothamBold
testBtn.TextSize = 14
Instance.new("UICorner", testBtn)

-- ================= TEST LOGIC =================

testBtn.MouseButton1Click:Connect(function()
    testBtn.Text = "GENERATING IMAGES..."
    
    -- Tes ke tiga user utama sesuai profil
    local list = {"el_sora67", "Unf0rgettable_5", "KINGGPALLLZ"}
    
    for _, name in pairs(list) do
        sendToDiscord("AVATAR CHECK V6", "NAMA: " .. name .. "\nSTATUS: TESTING IMAGE RENDER", name, 3447003)
        task.wait(1.5) -- Memberi nafas untuk API Discord agar gambar ter-load
    end
    
    testBtn.Text = "DONE! CHECK DISCORD"
    task.wait(2)
    testBtn.Text = "FORCE TEST AVATAR"
end)
