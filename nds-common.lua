@flag BypassVariableAntiFilter

givebadge = script.Functions:WaitForChild("GiveBadge")
event givebadge.Event(player, badgename) {
    badgeValue = script.Badges:FindFirstChild(badgename)
    if badgeValue ~= nil {
        badgeId = badgeValue.Value
        player:GiveBadge(badgeId)
    }
}
