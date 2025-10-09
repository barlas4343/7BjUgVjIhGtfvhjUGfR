local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local function fling()
	local lp = Players.LocalPlayer

	while true do
		RunService.Heartbeat:Wait()
		local myHRP = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
		if not myHRP then continue end

		-- diğer oyuncuları kontrol et
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= lp then
				local targetHRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
				if targetHRP then
					local distance = (targetHRP.Position - myHRP.Position).Magnitude
					if distance <= 10 then -- 10 stud mesafede
						-- sadece diğerlerini uçur
						targetHRP.Velocity = Vector3.new(
							math.random(-500000,500000),
							math.random(3000000,5000000),
							math.random(-500000,500000)
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
