local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Tek seferlik kontrol objesi
if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
	local detection = Instance.new("Decal")
	detection.Name = "juisdfj0i32i0eidsuf0iok"
	detection.Parent = ReplicatedStorage
end

local stopFling = false

local function fling()
	local lp = Players.LocalPlayer
	local c, hrp

	-- Karakter yüklendiğinde güncelle
	lp.CharacterAdded:Connect(function(char)
		c = char
		hrp = char:WaitForChild("HumanoidRootPart", 5)
	end)

	if lp.Character then
		c = lp.Character
		hrp = c:FindFirstChild("HumanoidRootPart")
	end

	-- Hızlandırılmış fling döngüsü
	while not stopFling do
		task.wait() -- minimum gecikme

		if not c or not hrp or not hrp.Parent then
			c = lp.Character
			if c then
				hrp = c:FindFirstChild("HumanoidRootPart")
			end
		end

		if hrp then
			local basePos = hrp.Position

			-- Yakındaki tüm oyunculara etki
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					local targetHRP = plr.Character.HumanoidRootPart
					local distance = (targetHRP.Position - basePos).Magnitude

					if distance < 15 then -- çok yakınsa anında uçur
						local dir = (targetHRP.Position - basePos).Unit
						targetHRP.Velocity = dir * 10000 + Vector3.new(0, 8000, 0)
						targetHRP.RotVelocity = Vector3.new(math.random(-5000,5000), math.random(-5000,5000), math.random(-5000,5000))
					elseif distance < 30 then -- orta mesafe: çekim etkisi
						targetHRP.Velocity = targetHRP.Velocity + (basePos - targetHRP.Position).Unit * 5000
					end
				end
			end

			-- kendi sabitleme (sen uçma)
			hrp.Velocity = Vector3.new(0, 0, 0)
			hrp.RotVelocity = Vector3.new(0, 0, 0)
		end
	end
end

-- dış API (fonksiyon adları değişmedi)
return {
	fling = function()
		stopFling = false
		return coroutine.create(fling)
	end,
	stop = function()
		stopFling = true
	end,
	enableGui = function() end,
	disableGui = function() end
}
