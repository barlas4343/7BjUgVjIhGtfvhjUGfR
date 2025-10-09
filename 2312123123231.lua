local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Fling Gücü Ayarı: Önceki 10000 yerine 500000 (Beş yüz bin)
local EXTREME_FLING_POWER = 500000 
local DITHER_FORCE = 0.1 -- Titreşim kuvveti

-- Fling işlevini kontrol eden ana fonksiyon
local function FlingTouch()
    local lp = Players.LocalPlayer
    local c, hrp, vel, movel = nil, nil, nil, DITHER_FORCE
    
    -- Karakterin yüklenmesini bekle
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.CharacterAdded:Wait()
    end
    
    -- Bu coroutine, ana kod tarafından durdurulana kadar çalışacak.
    while true do 
        RunService.Heartbeat:Wait()
        
        c = lp.Character
        hrp = c and c:FindFirstChild("HumanoidRootPart")
        
        -- Eğer karakterimiz ölmüşse veya HRP yoksa döngüden çık
        if not hrp or (c and c:FindFirstChild("Humanoid") and c.Humanoid.Health <= 0) then
            break 
        end
        
        -- Fling Mantığı
        vel = hrp.Velocity
        
        -- ADIM 1: AŞIRI YÜKSEK HIZ UYGULA
        hrp.Velocity = vel * EXTREME_FLING_POWER + Vector3.new(0, EXTREME_FLING_POWER, 0)
        
        RunService.RenderStepped:Wait()
        
        -- ADIM 2: HIZI SIFIRLA (Anti-cheat/teleport korumasını atlatmak için)
        hrp.Velocity = vel
        
        RunService.Stepped:Wait()
        
        -- ADIM 3: TİTREŞİM EFEKTİ UYGULA
        hrp.Velocity = vel + Vector3.new(0, movel, 0)
        movel = -movel
    end
end

-- ANA KODA DÖNDÜRÜLECEK FONKSİYON
return function()
    -- Bu, 'start' ve 'stop' eylemlerini kontrol eden ana kapatıcı fonksiyon
    local flingThread = coroutine.create(FlingTouch)
    
    return function(action)
        if action == "start" then
            -- Yeni bir coroutine oluştur ve başlat
            if coroutine.status(flingThread) == "dead" or coroutine.status(flingThread) == "suspended" then
                flingThread = coroutine.create(FlingTouch)
            end
            coroutine.resume(flingThread)
            
        elseif action == "stop" then
            -- Fling'i durdurmak için coroutine'i duraklat
            if coroutine.status(flingThread) == "running" then
                coroutine.yield(flingThread)
            end
        end
    end
end