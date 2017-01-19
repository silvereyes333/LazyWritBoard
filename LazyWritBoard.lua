local addonName = "LazyWritBoard"
local function HandleQuestCompleteDialog(eventCode, journalIndex)
    -- Stop listening for quest complete dialog
    EVENT_MANAGER:UnregisterForEvent(addonName, EVENT_QUEST_COMPLETE_DIALOG)
    -- Complete the writ quest
    CompleteQuest()
end
local function HandleEventQuestOffered(eventCode)
    -- Stop listening for quest offering
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
        
    -- If it is a writ quest completion option
    elseif optionType == CHATTER_START_ADVANCE_COMPLETABLE_QUEST_CONDITIONS
       and string.find(optionString, "Place the goods") ~= nil  
    then
        -- Listen for the quest complete dialog
        EVENT_MANAGER:RegisterForEvent(addonName, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleteDialog)
        -- Select the first option to complete the quest
        SelectChatterOption(1)
    
    -- If the goods were already placed, then complete the quest
    elseif optionType == CHATTER_START_COMPLETE_QUEST
       and (string.find(optionString, "Place the goods") ~= nil 
            or string.find(optionString, "Sign the Manifest") ~= nil)
    then
        -- Listen for the quest complete dialog
        EVENT_MANAGER:RegisterForEvent(addonName, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleteDialog)
        -- Select the first option to place goods and/or sign the manifest
        SelectChatterOption(1)
    end
end
local function OnAddonLoaded(event, name)
    if name ~= addonName then return end
    EVENT_MANAGER:RegisterForEvent(addonName, EVENT_CHATTER_BEGIN, HandleChatterBegin)

end
EVENT_MANAGER:RegisterForEvent(addonName, EVENT_ADD_ON_LOADED, OnAddonLoaded)
