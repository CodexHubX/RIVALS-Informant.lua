task.spawn(function()
    local ViewReward = require(game:GetService("ReplicatedFirst").Client.UiComponents.ViewReward)
    local TowerController = require(game:GetService('ReplicatedFirst').Client.Controllers.TowerController)
    hookfunction(ViewReward, function()
    end)
    local oldP;
    oldP = hookfunction(TowerController.CheckPlacement, function(...)
        if _G.PlaceAnywhere then 
            return true;
        end;
        return oldP(...)
    end)
    warn("Pass")
end)
