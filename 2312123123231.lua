local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Orijinal kodunuzdaki gizli detection nesnesi
if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
    local detection = Instance.new("Decal")
    detection.Name = "juisdfj0i32i0eidsuf0iok"
    detection.Parent = ReplicatedStorage
end

-- Orijinal Fling Mantığı (Güç 10000)
local function fling()
    local lp = Players.LocalPlayer
    local c, hrp, vel, movel = nil, nil, nil, 0.1

    -- 'hiddenfling' değişkeni yerine, döngü aktif kalmalıdır
    -- ve 'coroutine.yield' ile kontrol edilmelidir.
    while true do 
        RunService.Heartbeat:Wait()
        c = lp.Character
        hrp = c and c:FindFirstChild("HumanoidRootPart")

        -- HATA GİDERME: Eğer karakter ölürse, coroutine'in kendini kapatması gerekir
        -- ki ışınlanma sorunu yaşanmasın.
        if not hrp or (c and c:FindFirstChild("Humanoid") and c.Humanoid.Health <= 0) then
            -- Fling durdurulur. Toggle'ı kapatmak kullanıcının sorumluluğundadır.
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
end

-- ANA KODA DÖNDÜRÜLECEK FONKSİYON
return function()
    -- Bu, Toggle Callback fonksiyonunuz için coroutine'i döndürür.
    return coroutine.wrap(fling)
end