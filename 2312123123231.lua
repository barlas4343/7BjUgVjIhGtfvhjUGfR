local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
    local detection = Instance.new("Decal")
    detection.Name = "juisdfj0i32i0eidsuf0iok"
    detection.Parent = ReplicatedStorage
end

local function fling()
    local lp = Players.LocalPlayer
    local movel = 0.1
    local c, hrp, vel

    -- Karakter yeniden doğarsa güncelle
    lp.CharacterAdded:Connect(function(char)
        c = char
        hrp = char:WaitForChild("HumanoidRootPart", 5)
    end)

    -- İlk karakteri tanımla
    if lp.Character then
        c = lp.Character
        hrp = c:FindFirstChild("HumanoidRootPart")
    end

    -- Sonsuz fling döngüsü (asla durmaz)
    while true do
        RunService.Heartbeat:Wait()

        c = lp.Character
        if c then
            hrp = c:FindFirstChild("HumanoidRootPart")
            local hum = c:FindFirstChildOfClass("Humanoid")

            -- Karakter ölse bile bekle, yeniden doğunca devam et
            if hum and hum.Health <= 0 then
                hrp = nil
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
end

-- Kod çalışır çalışmaz fling başlasın
coroutine.wrap(fling)()
