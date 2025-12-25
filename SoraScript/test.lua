-- =====================================================================
-- SORA HUB V6.5 - FINAL SYSTEM (CDN AVATAR & MULTI-TIER AFK)
-- =====================================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local webhookURL = "https://discord.com/api/webhooks/1441417921552191488/OLnhBfgM4fh1sG97NpipcG66OyNwrqJmARcKVgrxPQxC1u70iH4pnF-VVS5XxRTTh9va"

-- CONFIGURATION (Nama & ID Discord)
local targetData = {
    ["el_sora67"] = "1288092342213148728",
    ["Unf0rgettable_5"] = "1378790404237037680",
    ["KINGGPALLLZ"] = "1409506714939687022",
    ["RNGvoided"] = "" 
}

local lastCaughtVal = {}
local afkTime = {}

-- ================= UTILS (CDN FETCH) =================

local function getFinalAvatar(playerName)
    local userId = 0
    pcall(function() userId = Players:GetUserIdFromNameAsync(playerName) end)
    if userId == 0 then return "" end
    
    local apiUrl = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="..userId.."&size=420x420&format=Png&isCircular=false"
    local success, response = pcall(function() return game:HttpGet(apiUrl) end)
    
    if success then
        local decoded = HttpService:JSONDecode(response)
        if decoded and decoded.data and decoded.data[1] then
            return decoded.data[1].imageUrl
        end
    end
    return ""
end

local function sendToDiscord(title, message, playerName, color)
    local cdnUrl = getFinalAvatar(playerName)
    local discordId = targetData[playerName]
    
    local data = {
        ["content"] = (discordId and discordId ~= "") and "<@" .. discordId .. ">" or "", 
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = message,
            ["color"] = color or 65460,
            ["thumbnail"] = (cdnUrl ~= "") and { ["url"] = cdnUrl } or nil,
            ["footer"] = { ["text"] = "SORA MONITORING SYSTEM V6.5" },
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

-- ================= CORE LOGIC =================

-- 1. HOST START
print("SORA HUB V6.5: Sistem Monitoring Aktif!")
sendToDiscord("HOST ACTIVATE", "PENGELOLAAN WEBHOOK TELAH TERSAMBUNG. HOST: @" .. Players.LocalPlayer.Name:upper(), Players.LocalPlayer.Name, 65460)

-- 2. JOIN & LEAVE
Players.PlayerAdded:Connect(function(plr)
    if targetData[plr.Name] then
        sendToDiscord("PLAYER JOINED", "AKUN @" .. plr.Name:upper() .. " TELAH JOIN KE SERVER", plr.Name, 65460)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if targetData[plr.Name] and plr ~= Players.LocalPlayer then
        sendToDiscord("PLAYER LEFT", "AKUN @" .. plr.Name:upper() .. " KELUAR DARI SERVER", plr.Name, 16724814)
    end
end)

-- 3. AFK MONITORING (1m, 10m, 30m, 1h)
task.spawn(function()
    while task.wait(60) do
        for _, p in pairs(Players:GetPlayers()) do
            if targetData[p.Name] then
                local s = p:FindFirstChild("leaderstats") and p.leaderstats:FindFirstChild("Caught")
                if s then
                    if lastCaughtVal[p.Name] ~= nil and lastCaughtVal[p.Name] == s.Value then
                        afkTime[p.Name] = (afkTime[p.Name] or 0) + 1
                        local t = afkTime[p.Name]
                        
                        if t == 1 then
                            sendToDiscord("AFK WARNING", "AKUN @" .. p.Name:upper() .. " TIDAK MENARIK PANCINGAN SELAMA 1 MENIT", p.Name, 16776960)
                        elseif t == 10 then
                            sendToDiscord("AFK WARNING", "AKUN @" .. p.Name:upper() .. " TIDAK MENARIK PANCINGAN SELAMA 10 MENIT", p.Name, 16753920)
                        elseif t == 30 then
                            sendToDiscord("AFK WARNING (URGENT)", "AKUN @" .. p.Name:upper() .. " TIDAK MENARIK PANCINGAN SELAMA 30 MENIT", p.Name, 16737792)
                        elseif t == 60 then
                            sendToDiscord("AFK WARNING (CRITICAL)", "AKUN @" .. p.Name:upper() .. " TIDAK MENARIK PANCINGAN SELAMA 1 JAM", p.Name, 16711680)
                        end
                    else
                        afkTime[p.Name] = 0
                    end
                    lastCaughtVal[p.Name] = s.Value
                end
            end
        end
    end
end)
