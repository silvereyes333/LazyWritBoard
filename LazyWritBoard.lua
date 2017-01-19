local addonName = "LazyWritBoard"
local function HandleEventQuestOffered(eventCode)
    -- Stop listen for quest offering
    EVENT_MANAGER:UnregisterForEvent(addonName, EVENT_QUEST_OFFERED)
    -- Accept the writ quest
    AcceptOfferedQuest()
end
local function HandleChatterBegin(eventCode, optionCount)
    -- Ignore interactions with no options
    if optionCount == 0 then return end
    -- Get details of first option
    local optionString, optionType = GetChatterOption(1)
    -- If it is a writ quest option...
    if optionType == CHATTER_START_NEW_QUEST_BESTOWAL 
       and string.find(optionString, "Writ") ~= nil 
    then
        -- Listen for the quest offering
        EVENT_MANAGER:RegisterForEvent(addonName, EVENT_QUEST_OFFERED, HandleEventQuestOffered)
        -- Select the first writ
        SelectChatterOption(1)
    end
end
local function OnAddonLoaded(event, name)
    if name ~= addonName then return end
    EVENT_MANAGER:RegisterForEvent(addonName, EVENT_CHATTER_BEGIN, HandleChatterBegin)
end
EVENT_MANAGER:RegisterForEvent(addonName, EVENT_ADD_ON_LOADED, OnAddonLoaded)
