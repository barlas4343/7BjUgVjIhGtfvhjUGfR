-- Fling Mantığı için gerekli servisleri tanımla
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Fling'i gerçekleştiren ana fonksiyon
local function FlingTouchV2()
    local lp = Players.LocalPlayer
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    
    if not hrp then return end -- Karakter yoksa işlemi durdur

    -- Fling için kullanacağımız fizik nesnesini (BodyVelocity) oluştur.
    local bv = Instance.new("BodyVelocity")
    
    -- EXTREME HIZ AYARLARI
    local FlingSpeed = 100000  -- Yüksek hız değeri
    local MaxForce = Vector3.new(1000000, 1000000, 1000000) -- Maksimum kuvvet (genellikle limitlenir)

    bv.MaxForce = MaxForce
    bv.Velocity = Vector3.new(0, FlingSpeed, 0) -- Başlangıçta karakteri yukarı fırlat
    bv.Parent = hrp
    
    -- Fling etkisini korumak için kısa bir döngü
    -- Bu döngü, ana koddan coroutine durdurulana kadar çalışacak.
    while true do 
        -- Karakteri istenilen hız ve yöne doğru sürekli hareket ettir.
        -- Bu, sadece anlık hız ataması (Velocity) yapmaktan daha zor tespit edilir.
        bv.Velocity = hrp.CFrame.LookVector * FlingSpeed + Vector3.new(0, 50000, 0) 
        
        RunService.Heartbeat:Wait()
    end
    
    -- Bu noktaya asla ulaşılamayacak (coroutine durdurulacak)
    -- ancak yine de temizlik kodunu koymak iyi bir pratik.
    -- bv:Destroy() 
end

-- ANA KODA DÖNDÜRÜLECEK FONKSİYON
return function()
    -- Fling'i başlatmak için bu coroutine'i döndür
    -- Coroutine sonlandığında, BodyVelocity nesnesinin de silinmesi gerekecek.
    return function()
        -- Coroutine'i sarar, böylece durdurulduğunda BodyVelocity temizlenebilir
        local flingThread = coroutine.create(FlingTouchV2)
        
        return function(action)
            -- 'start' veya 'stop' eylemini işler
            if action == "start" then
                coroutine.resume(flingThread)
            elseif action == "stop" then
                -- BodyVelocity nesnesini temizle
                local lp = Players.LocalPlayer
                local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                local bv = hrp and hrp:FindFirstChildOfClass("BodyVelocity")
                if bv then
                    bv:Destroy()
                end
                
                -- Coroutine'i durdur (yield ile)
                if coroutine.status(flingThread) == "running" then
                    coroutine.yield(flingThread)
                end
            end
        end
    end
end