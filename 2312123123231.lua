local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Fling Gücü Ayarı: Ekstrem güç
local EXTREME_FLING_POWER = 500000 
local DITHER_FORCE = 0.1 

local function FlingTouch()
    local lp = Players.LocalPlayer
    local c, hrp, vel, movel = nil, nil, nil, DITHER_FORCE
    
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.CharacterAdded:Wait()
    end
    
    while true do 
        RunService.Heartbeat:Wait()
        
        c = lp.Character
        hrp = c and c:FindFirstChild("HumanoidRootPart")
        
        -- HATA GİDERME: Ölme/Respawn Kontrolü (Işınlanma sorununu çözer)
        if not hrp or (c and c:FindFirstChild("Humanoid") and c.Humanoid.Health <= 0) then
            break 
        end
        
        -- Orijinal Fling Mantığı (Güçlendirilmiş)
        if hrp then
            vel = hrp.Velocity
            hrp.Velocity = vel * EXTREME_FLING_POWER + Vector3.new(0, EXTREME_FLING_POWER, 0)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
            RunService.Stepped:Wait()
            hrp.Velocity = vel + Vector3.new(0, movel, 0)
            movel = -movel
        end
    end
end

-- ANA KODA DÖNDÜRÜLECEK FONKSİYON
return function()
    -- Her seferinde yeni bir coroutine nesnesi döndürür, bu toggle için idealdir.
    return coroutine.wrap(FlingTouch)
end