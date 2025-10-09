local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
	local detection = Instance.new("Decal")
	detection.Name = "juisdfj0i32i0eidsuf0iok"
	detection.Parent = ReplicatedStorage
end

local stopFling = false

-- ⚡ Ultra hızlı, yakından geçen herkesi anında uçuran fling sistemi ⚡
local function fling()
	local lp = Players.LocalPlayer
	local char = lp.Character or lp.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	
	local power = 50000  -- 🔥 Uçurma gücü (artırılabilir)
	local range = 10     -- 🔥 Etki mesafesi (metre)
	
	while not stopFling do
		RunService.Heartbeat:Wait()

		if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
			continue
		end
		
		hrp = lp.Character.HumanoidRootPart
		local myPos = hrp.Position

		-- Etraftaki oyuncuları kontrol et
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local targetHRP = plr.Character.HumanoidRootPart
				local distance = (targetHRP.Position - myPos).Magnitude

				if distance <= range then
					-- 💥 Yakın oyuncuyu anında uçur!
					local flingDir = (targetHRP.Position - myPos).Unit * power
					targetHRP.Velocity = flingDir + Vector3.new(0, power / 2, 0)
				end
			end
		end
	end
end

-- API dışarı aktarımı
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
