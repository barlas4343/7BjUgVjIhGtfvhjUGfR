-- Fling Mantığı için gerekli servisleri tanımla
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Fling durumunu tutan değişkeni buraya tanımlamıyoruz, 
-- çünkü kontrol ana koddan gelecek.

-- Fling işlevini kontrol eden ana fonksiyon
local function FlingTouch(fling_state_ref)
    local lp = Players.LocalPlayer
    local c, hrp, vel, movel = nil, nil, nil, 0.1
    
    -- "fling_state_ref" referansı true olduğu sürece döngü çalışır
    -- Not: Lua'da değişken referansı için buraya bir üst tabloya erişim 
    -- veya global değişken kullanımı gerekebilir. En basit yol, 
    -- fling döngüsünün kontrolünü ana koda bırakmaktır.
    
    -- Bu döngü, ana koddan coroutine içinde çağrılacak ve sadece
    -- Fling aktifken çalışacaktır.
    while true do -- Sonsuz döngü. Coroutine durdurulana kadar çalışacak.
        RunService.Heartbeat:Wait()
        
        c = lp.Character
        hrp = c and c:FindFirstChild("HumanoidRootPart")
        
        if hrp then
            -- Fling mekaniği
            vel = hrp.Velocity
            hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
            
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
            
            RunService.Stepped:Wait()
            hrp.Velocity = vel + Vector3.new(0, movel, 0)
            movel = -movel 
        end
    end
end

-- ANA KODA DÖNDÜRÜLECEK FONKSİYON
-- Bu fonksiyon, main script'in fling'i başlatmasını/durdurmasını sağlar.
return function()
    -- Fling'i başlatmak için bu coroutine'i döndür
    return coroutine.wrap(FlingTouch)
end