-- ================= SORA HUB V6.2 (CDN FIXED) =================
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local webhookURL = "https://discord.com/api/webhooks/1441417921552191488/OLnhBfgM4fh1sG97NpipcG66OyNwrqJmARcKVgrxPQxC1u70iH4pnF-VVS5XxRTTh9va"

-- Daftar Nama Akun (Target)
local targets = {
    "el_sora67",
    "Unf0rgettable_5",
    "KINGGPALLLZ"
}

-- Fungsi untuk mendapatkan link foto tr.rbxcdn.com secara otomatis
local function getFinalAvatarUrl(playerName)
    local userId = 0
    local successId, errId = pcall(function() 
        userId = Players:GetUserIdFromNameAsync(playerName) 
    end)
    
    if successId and userId ~= 0 then
        -- Memanggil API Thumbnail terbaru
        local apiUrl = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="..userId.."&size=420x420&format=Png&isCircular=false"
        local successApi, response = pcall(function()
            return game:HttpGet(apiUrl)
        end)
        
        if successApi then
            local decoded = HttpService:JSONDecode(response)
            if decoded and decoded.data and decoded.data[1] then
                -- Inilah link tr.rbxcdn.com yang kamu butuhkan
                return decoded.data[1].imageUrl
            end
        end
    end
    return "" -- Kembali kosong jika gagal
end

-- ================= TEST WEBHOOK DENGAN CDN =================

print("SORA HUB: Memulai pengambilan URL foto tim...")

task.spawn(function()
    for _, name in pairs(targets) do
        local cdnUrl = getFinalAvatarUrl(name)
        
        if cdnUrl ~= "" then
            print("Berhasil mengambil URL untuk " .. name .. ": " .. cdnUrl)
            
            -- Kirim ke Discord dengan Link CDN asli
            local data = {
                ["embeds"] = {{
                    ["title"] = "CDN AVATAR CHECK",
                    ["description"] = "AKUN: @" .. name:upper() .. "\nSTATUS: CDN BERHASIL DIAMBIL",
                    ["color"] = 65460,
                    ["thumbnail"] = { ["url"] = cdnUrl }, -- Menggunakan link tr.rbxcdn.com
                    ["footer"] = { ["text"] = "SORA MONITOR V6.2" },
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
        else
            print("Gagal mengambil URL untuk " .. name)
        end
        task.wait(2) -- Delay agar tidak terkena limit
    end
    print("SORA HUB: Selesai mengirim semua foto ke Discord!")
end)
