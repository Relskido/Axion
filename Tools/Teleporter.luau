local Funcs = {}

local TPService = game:GetService("TeleportService")
_G.LastServerId = _G.LastServerId or nil

function Funcs.Teleport(PlaceID, Min, Max)
    local IDs = {}

    local function GetTokens()
        local HttpService = game:GetService("HttpService")
        local IP = HttpService:JSONDecode(
            game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100")
        )

        for _, v in pairs(IP.data) do
            if v.playing > Min and v.playing < Max then
                table.insert(IDs, v.id)
            end
        end
    end

    GetTokens()

    for i = #IDs, 1, -1 do
        if IDs[i] == game.JobId or IDs[i] == _G.LastServerId then
            table.remove(IDs, i)
        end
    end

    if #IDs > 0 then
        local target = IDs[math.random(1, #IDs)]
        _G.LastServerId = target
        TPService:TeleportToPlaceInstance(PlaceID, target, game.Players.LocalPlayer)
    end
end

return Funcs