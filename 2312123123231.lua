-- Fling Mantığı için gerekli servisleri tanımla
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Fling işlevini kontrol eden ana fonksiyon
local function FlingTouch()
    local lp = Players.LocalPlayer
    local c, hrp, vel, movel = nil, nil, nil, 0.1
    
    while true do 
        RunService.Heartbeat:Wait()
        
        c = lp.Character
        hrp = c and c:FindFirstChild("HumanoidRootPart")
        
        if hrp then
            -- ÇOK EXTREME VE YÜKSEK DEĞERLERİ KULLANIN
            local multiplier = 100000 -- YATAY ÇARPIMI 100 BİN'E ÇIKAR
            local verticalForce = 100000 -- DİKEY KUVVETİ 100 BİN'E ÇIKAR
            
            vel = hrp.Velocity
            
            -- ADIM 1: Yüksek hızda çarpma (Fling)
            hrp.Velocity = vel * multiplier + Vector3.new(0, verticalForce, 0)
            
            RunService.RenderStepped:Wait()
            
            -- ADIM 2: Hızı eski haline getir (Anti-teleport'u atlatmak için)
            hrp.Velocity = vel
            
            RunService.Stepped:Wait()
            
            -- ADIM 3: Küçük titreşim efekti (Stabilite için)
            hrp.Velocity = vel + Vector3.new(0, movel, 0)
            movel = -movel 
        end
    end
end

-- ANA KODA DÖNDÜRÜLECEK FONKSİYON
return function()
    return coroutine.wrap(FlingTouch)
end