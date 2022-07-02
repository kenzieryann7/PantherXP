-- ########################################################################################################
-- PantherXP
-- Author: Rynzaii
-- The MIT License
--
-- ########################################################################################################


-- PXP Initialization


-- ########################################################################################################
-- Load saved settings
--  - Account-wide settings or Default settings
--
-- ########################################################################################################
local function LoadSavedVars()
    PXP.sv = ZO_SavedVars:NewAccountWide(PXP.svName, PXP.svVersion, nil, PXP.default)
end

-- ########################################################################################################
-- Scenes to show XP Text
--
-- ########################################################################################################

-- HUD Scenes
local hudScene = SCENE_MANAGER:GetScene("hud")
local hudUIScene = SCENE_MANAGER:GetScene("hudui")

-- Common Menu Scenes
local inventoryScene = SCENE_MANAGER:GetScene("inventory")
local statsScene = SCENE_MANAGER:GetScene("stats")
local skillsScene = SCENE_MANAGER:GetScene("skills")
local notificationsScene = SCENE_MANAGER:GetScene("notifications")
local groupMenuKeyboardScene = SCENE_MANAGER:GetScene("groupMenuKeyboard")
local friendsListScene = SCENE_MANAGER:GetScene("friendsList")
local ignoreListScene = SCENE_MANAGER:GetScene("ignoreList")

-- Journal Scenes
local questJournalScene = SCENE_MANAGER:GetScene("questJournal")
local antiquityJournalKeyboardScene = SCENE_MANAGER:GetScene("antiquityJournalKeyboard")
local loreLibraryScene = SCENE_MANAGER:GetScene("loreLibrary")
local achievementsScene = SCENE_MANAGER:GetScene("achievements")
local leaderboardsScene = SCENE_MANAGER:GetScene("leaderboards")

-- Collection Scenes
local collectionsBookScene = SCENE_MANAGER:GetScene("collectionsBook")
local dlcBookScene = SCENE_MANAGER:GetScene("dlcBook")
local housingBookScene = SCENE_MANAGER:GetScene("housingBook")
local outfitStylesBookScene = SCENE_MANAGER:GetScene("outfitStylesBook")
local itemSetsBookScene = SCENE_MANAGER:GetScene("itemSetsBook")
local tributePatronBookScene = SCENE_MANAGER:GetScene("tributePatronBook")

-- Mail Scenes
local mailInboxScene = SCENE_MANAGER:GetScene("mailInbox")
local mailSendScene = SCENE_MANAGER:GetScene("mailSend")

-- Help Scenes
local helpTutorialsScene = SCENE_MANAGER:GetScene("helpTutorials")
local helpCustomerSupportScene = SCENE_MANAGER:GetScene("helpCustomerSupport")
local helpEmotesScene = SCENE_MANAGER:GetScene('helpEmotes')

-- Guild Scenes
local guildHomeScene = SCENE_MANAGER:GetScene("guildHome")
local guildRosterScene = SCENE_MANAGER:GetScene("guildRoster")
local guildRanksScene = SCENE_MANAGER:GetScene("guildRanks")
local guildRecruitmentKeyboardScene = SCENE_MANAGER:GetScene("guildRecruitmentKeyboard")
local guildHistoryScene = SCENE_MANAGER:GetScene("guildHistory")


-- ########################################################################################################
-- Add PantherFragment to the following scenes
--
-- ########################################################################################################
local function CreatePantherFragment()

    local PantherFragment = ZO_HUDFadeSceneFragment:New(PantherXP, 400, 200)

    -- HUD
    hudScene:AddFragment(PantherFragment)
    hudUIScene:AddFragment(PantherFragment)

    -- Common Menus
    inventoryScene:AddFragment(PantherFragment)
    statsScene:AddFragment(PantherFragment)
    skillsScene:AddFragment(PantherFragment)
    notificationsScene:AddFragment(PantherFragment)
    groupMenuKeyboardScene:AddFragment(PantherFragment)
    friendsListScene:AddFragment(PantherFragment)
    ignoreListScene:AddFragment(PantherFragment)

    -- Journals
    questJournalScene:AddFragment(PantherFragment)
    antiquityJournalKeyboardScene:AddFragment(PantherFragment)
    loreLibraryScene:AddFragment(PantherFragment)
    achievementsScene:AddFragment(PantherFragment)
    leaderboardsScene:AddFragment(PantherFragment)

    -- Collections
    collectionsBookScene:AddFragment(PantherFragment)
    dlcBookScene:AddFragment(PantherFragment)
    housingBookScene:AddFragment(PantherFragment)
    outfitStylesBookScene:AddFragment(PantherFragment)
    itemSetsBookScene:AddFragment(PantherFragment)
    tributePatronBookScene:AddFragment(PantherFragment)

    -- Mail
    mailInboxScene:AddFragment(PantherFragment)
    mailSendScene:AddFragment(PantherFragment)

    -- Help
    helpTutorialsScene:AddFragment(PantherFragment)
    helpCustomerSupportScene:AddFragment(PantherFragment)
    helpEmotesScene:AddFragment(PantherFragment)

    -- Guild
    guildHomeScene:AddFragment(PantherFragment)
    guildRosterScene:AddFragment(PantherFragment)
    guildRanksScene:AddFragment(PantherFragment)
    guildRecruitmentKeyboardScene:AddFragment(PantherFragment)
    guildHistoryScene:AddFragment(PantherFragment)

end


-- ########################################################################################################
-- Loading only PantherXP
--
-- ########################################################################################################
local function OnAddonOnLoaded(eventCode, addonName)

    -- Only initialize only PantherXP
    if PXP.name ~= addonName then
        return
    end

    -- If PantherXP initalized, unregister event listener
    EVENT_MANAGER:UnregisterForEvent(addonName, eventCode)

    -- Load saved variables
    LoadSavedVars()

    -- Init Settings menu using LibAddonMenu-2.0
    PXP.initSettings()

    -- Create Panther Fragment to be added to predefined fragments as shown above
    CreatePantherFragment()

    -- Create XP Label
    PXP.CreateXPLabel(PXPSV.Default[GetDisplayName()]['$AccountWide'].defaultFontName)

    -- Refresh XP Label when XP Bar updates
    ZO_PreHookHandler(ZO_PlayerProgressBar, 'OnUpdate', PXP.RefreshLabelOnUpdate)

    -- Display XP Bar
    PXP.ShowXPBar()

end 


-- ########################################################################################################
-- Hook initialization
--
-- ########################################################################################################
EVENT_MANAGER:RegisterForEvent(PXP.name, EVENT_ADD_ON_LOADED, OnAddonOnLoaded)
