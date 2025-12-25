-- ================= SORA WEBHOOK DEBUGGER =================
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local webhookURL = "https://discord.com/api/webhooks/1441417921552191488/OLnhBfgM4fh1sG97NpipcG66OyNwrqJmARcKVgrxPQxC1u70iH4pnF-VVS5XxRTTh9va"

local targetData = {
    ["el_sora67"] = "1288092342213148728",
    ["Unf0rgettable_5"] = "1378790404237037680",
    ["KINGGPALLLZ"] = "1409506714939687022",
    ["RNGvoided"] = "" 
}

local lastCaughtVal = {}
local afkTime = {}

local function sendToDiscord(title, message, playerName)
    print("SORA DEBUG: Mengirim Webhook untuk " .. tostring(playerName))
    local discordId = targetData[playerName]
    local data = {
        ["content"] = (discordId and discordId ~= "") and "<@" .. discordId .. ">" or "", 
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = message,
            ["color"] = 16776960,
        }}
    }
    local request = http_request or request or syn.request
    if request then
        local success, err = pcall(function()
            request({ Url = webhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data) })
        end)
        if not success then print("SORA DEBUG: Gagal kirim Webhook: " .. tostring(err)) end
    else
        print("SORA DEBUG: Executor tidak mendukung HTTP Request!")
    end
end

print("SORA DEBUG: Script Dimulai. Menunggu 60 detik untuk pengecekan pertama...")

task.spawn(function()
    while task.wait(60) do
        print("SORA DEBUG: Menjalankan pengecekan rutin pada menit ke-" .. os.date("%M"))
        for _, p in pairs(Players:GetPlayers()) do
            if targetData[p.Name] then
                local s = p:FindFirstChild("leaderstats") and p.leaderstats:FindFirstChild("Caught")
                if s then
                    print("SORA DEBUG: Akun " .. p.Name .. " terpantau. Caught: " .. tostring(s.Value))
                    
                    if lastCaughtVal[p.Name] ~= nil and lastCaughtVal[p.Name] == s.Value then
                        afkTime[p.Name] = (afkTime[p.Name] or 0) + 1
                        print("SORA DEBUG: " .. p.Name .. " AFK selama " .. tostring(afkTime[p.Name]) .. " menit.")
                        
                        if afkTime[p.Name] == 1 then
                            sendToDiscord("AFK WARNING", "AKUN @" .. p.Name:upper() .. " TIDAK MANCING 1 MENIT", p.Name)
                        end
                    else
                        afkTime[p.Name] = 0
                        print("SORA DEBUG: " .. p.Name .. " masih aktif mancing.")
                    end
                    lastCaughtVal[p.Name] = s.Value
                else
                    print("SORA DEBUG: leaderstats 'Caught' tidak ditemukan untuk " .. p.Name)
                end
            end
        end
    end
end)
