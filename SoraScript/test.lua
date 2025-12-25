-- ================= SORA TEAM MONITOR (FIXED AVATAR) =================
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local webhookURL = "https://discord.com/api/webhooks/1441417921552191488/OLnhBfgM4fh1sG97NpipcG66OyNwrqJmARcKVgrxPQxC1u70iH4pnF-VVS5XxRTTh9va"

local targetData = {
    ["el_sora67"] = "1288092342213148728",
    ["Unf0rgettable_5"] = "1378790404237037680",
    ["KINGGPALLLZ"] = "1409506714939687022",
    ["RNGvoided"] = "" 
}

local isClosing = false

-- Fungsi Ambil UserID yang lebih aman
local function getUserId(name)
    local ok, id = pcall(function() return Players:GetUserIdFromNameAsync(name) end)
    return ok and id or 0
end

local function sendToDiscord(title, message, playerName, color)
    if isClosing then return end
    
    local discordId = targetData[playerName]
    local avatarUrl = ""
    
    -- Memastikan Avatar URL terbuat dengan benar menggunakan ID Angka
    if playerName then
        local userId = getUserId(playerName)
        if userId ~= 0 then
            avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"
        end
    end
    
    local data = {
        ["content"] = (discordId and discordId ~= "") and "<@" .. discordId .. ">" or "", 
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = message,
            ["color"] = color or 65460,
            -- Menggunakan Thumbnail agar muncul di samping teks (mirip Seraphin)
            ["thumbnail"] = (avatarUrl ~= "") and { ["url"] = avatarUrl } or nil,
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

-- 1. HOST SIGNAL
sendToDiscord("HOST ACTIVATE", "PENGELOLAAN WEBHOOK TELAH TERSAMBUNG. HOST: @" .. Players.LocalPlayer.Name:upper(), Players.LocalPlayer.Name, 65460)

game:BindToClose(function()
    isClosing = true 
    local data = {
        ["embeds"] = {{
            ["title"] = "HOST DISCONNECT",
            ["description"] = "SISTEM PENGELOLAAN WEBHOOK TERPUTUS. HOST @" .. Players.LocalPlayer.Name:upper() .. " TELAH KELUAR.",
            ["color"] = 16724814,
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    local request = http_request or request or (http and http.request) or syn.request
    if request then
        request({ Url = webhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data) })
    end
end)

-- 2. MONITOR JOIN & LEAVE
Players.PlayerAdded:Connect(function(plr)
    if targetData[plr.Name] then
        sendToDiscord("PLAYER JOINED", "AKUN @" .. plr.Name:upper() .. " TELAH JOIN KE SERVER", plr.Name, 65460)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if isClosing or plr == Players.LocalPlayer then return end
    if targetData[plr.Name] then
        sendToDiscord("PLAYER LEFT", "AKUN @" .. plr.Name:upper() .. " KELUAR DARI SERVER", plr.Name, 16724814)
    end
end)

-- 3. MONITOR AFK BERTINGKAT
local afkTimer = {}
local lastCaught = {}

task.spawn(function()
    while task.wait(60) do
        if isClosing then break end
        for _, p in pairs(Players:GetPlayers()) do
            if targetData[p.Name] then
                local s = p:FindFirstChild("leaderstats")
                if s and s:FindFirstChild("Caught") then
                    local current = s.Caught.Value
                    if lastCaught[p.UserId] and lastCaught[p.UserId] == current then
                        afkTimer[p.UserId] = (afkTimer[p.UserId] or 0) + 1
                        local t = afkTimer[p.UserId]
                        if t == 1 then
                            sendToDiscord("AFK WARNING", "AKUN @" .. p.Name:upper() .. " TIDAK MENARIK PANCINGAN SELAMA 1 MENIT", p.Name, 16776960)
                        elseif t == 10 then
                            sendToDiscord("AFK WARNING", "AKUN @" .. p.Name:upper() .. " TIDAK MENARIK PANCINGAN SELAMA 10 MENIT", p.Name, 16753920)
                        elseif t == 60 then
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
