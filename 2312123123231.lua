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
	local active = true

	local function getHRP(player)
		if player.Character then
			return player.Character:FindFirstChild("HumanoidRootPart")
		end
	end

	-- Karakter yeniden doğarsa HRP al
	lp.CharacterAdded:Connect(function(char)
		char:WaitForChild("HumanoidRootPart")
	end)

	while active do
		RunService.Heartbeat:Wait()

		local myHRP = getHRP(lp)
		if not myHRP then continue end

		-- 10 stud çevresindeki diğer oyuncuları fırlat
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= lp then
				local targetHRP = getHRP(plr)
				if targetHRP then
					local distance = (targetHRP.Position - myHRP.Position).Magnitude
					if distance <= 10 then
						-- aşırı güçlü velocity
						targetHRP.Velocity = Vector3.new(
							(math.random(-500000,500000)),
							(math.random(3000000,5000000)),
							(math.random(-500000,500000))
						)
					end
				end
			end
		end
	end
end

return {
	fling = coroutine.wrap(fling)
}
