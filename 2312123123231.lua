local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Fling Gücü Ayarı
local EXTREME_THRUST_FORCE = 750000 -- BodyThrust için ekstrem kuvvet

-- En yakın oyuncuyu bulan yardımcı fonksiyon
local function GetClosestPlayer(localPlayer)
    local closestPlayer = nil
    local shortestDistance = math.huge
    local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not hrp then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = player.Character.HumanoidRootPart
            local distance = (hrp.Position - targetHRP.Position).Magnitude
            
            -- Görüş alanında ve makul bir mesafede (200 stud) olanı hedef al
            if distance < shortestDistance and distance < 200 then 
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end

-- Fling'i gerçekleştiren ana fonksiyon
local function FlingTouchV4()
    local lp = Players.LocalPlayer
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local Thrust = nil

    if not hrp then return end
    
    local targetPlayer = GetClosestPlayer(lp)
    if not targetPlayer or not targetPlayer.Character then return end
    
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end

    -- 1. Fling için BodyThrust oluştur
    Thrust = Instance.new("BodyThrust")
    Thrust.Name = "AutoFlingThrust"
    
    Thrust.Force = Vector3.new(EXTREME_THRUST_FORCE, 0, EXTREME_THRUST_FORCE) 
    Thrust.Location = targetHRP.Position -- İtme hedefini ayarla
    Thrust.Parent = hrp
    
    -- 2. CFrame Senkronizasyon Döngüsü
    while true do 
        -- HATA GİDERME: Karakter/Hedef/Sağlık Kontrolü
        if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") or lp.Character.Humanoid.Health <= 0 or not targetHRP.Parent or not targetHRP.Parent:FindFirstChild("HumanoidRootPart") then
            break -- Eğer hedef veya biz ölürsek döngüyü durdur
        end

        -- Kendi pozisyonumuzu hedefe sabitle (Ana Fling mekaniği)
        lp.Character.HumanoidRootPart.CFrame = targetHRP.CFrame
        
        RunService.Heartbeat:Wait()
    end
    
    -- Temizlik: Coroutine durduğunda BodyThrust'ı sil
    if Thrust and Thrust.Parent then
        Thrust:Destroy()
    end
end

-- ANA KODA DÖNDÜRÜLECEK FONKSİYON
return function()
    -- Bu, 'start' ve 'stop' eylemlerini kontrol eden ana kapatıcı fonksiyon
    local flingThread = coroutine.create(FlingTouchV4)
    
    return function(action)
        local hrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if action == "start" then
            -- Yeni bir coroutine oluştur ve başlat
            if coroutine.status(flingThread) == "dead" or coroutine.status(flingThread) == "suspended" then
                flingThread = coroutine.create(FlingTouchV4)
            end
            coroutine.resume(flingThread)
            
        elseif action == "stop" then
            -- Temizlik: BodyThrust nesnesini sil
            if hrp then
                local thrust = hrp:FindFirstChild("AutoFlingThrust")
                if thrust then
                    thrust:Destroy()
                end
            end
            
            -- Coroutine'i durdur
            if coroutine.status(flingThread) == "running" then
                coroutine.yield(flingThread)
            end
        end
    end
end