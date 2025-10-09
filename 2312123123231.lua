local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Orijinal kodunuzdaki gizli detection nesnesi
if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
    local detection = Instance.new("Decal")
    detection.Name = "juisdfj0i32i0eidsuf0iok"
    detection.Parent = ReplicatedStorage
end

-- Fling fonksiyonu
local function fling()
    local lp = Players.LocalPlayer
    local c, hrp, vel, movel = nil, nil, nil, 0.1
    local active = true -- Toggle kontrolü için boolean

    -- Kapatma sinyali için bağlantı
    local connection
    connection = game:GetService("Players").LocalPlayer:GetPropertyChangedSignal("Character"):Connect(function()
        if not lp.Character or (lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health <= 0) then
            active = false -- Karakter öldüğünde veya kaybolduğunda fling'i durdur
        end
    end)

    while active do 
        RunService.Heartbeat:Wait()
        c = lp.Character
        hrp = c and c:FindFirstChild("HumanoidRootPart")

        -- HATA GİDERME: Eğer karakter ölürse veya HumanoidRootPart yoksa, coroutine durdurulur
        if not hrp or (c and c:FindFirstChild("Humanoid") and c.Humanoid.Health <= 0) then
            connection:Disconnect()
            return 
        end

        if hrp then
            vel = hrp.Velocity
            hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
            RunService.Stepped:Wait()
            hrp.Velocity = vel + Vector3.new(0, movel, 0)
            movel = -movel
        end
    end
    connection:Disconnect()
end

-- ANA KODA DÖNDÜRÜLECEK FONKSİYON
return coroutine.wrap(fling)