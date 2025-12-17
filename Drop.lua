getgenv().DropItems = {}
task.spawn(function()
    local ViewReward = require(game:GetService("ReplicatedFirst").Client.UiComponents.ViewReward)
    local TowerController = require(game:GetService('ReplicatedFirst').Client.Controllers.TowerController)
    hookfunction(ViewReward, function(v1)
        table.insert(getgenv().DropItems, v1)
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
