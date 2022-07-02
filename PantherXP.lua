-- ########################################################################################################
-- PantherXP
-- Author: Rynzaii
-- The MIT License
--
-- ########################################################################################################


-- PXP namespace
if PXP == nil then PXP = {} end

PXP.tag         = "PXP"
PXP.name        = "PantherXP"
PXP.version     = "1.1.0"
PXP.author      = "Rynzaii"
PXP.github      = "https://github.com/kenzieryann7/PantherXP"
PXP.feedback    = "https://github.com/kenzieryann7/PantherXP/issues"
PXP.donation    = "https://paypal.me/makenzienoggle?country.x=US&locale.x=en_US"

-- Saved options
PXP.sv          = nil
PXP.svVersion   = 2
PXP.svName      = "PXPSV"

-- Default settings
PXP.default = {
    showXPBar               = false,
    showXPLabel             = false,
    XPLabelFormat           = "No formatting",
    XPLabelPlacement        = "Top",
    defaultFontName         = "Default",
    defaultFontSize         = 20
}

-- XP Label format choices
PXP.labelFormats = {
    "No formatting",
    "Format with commas",
    "Abbreviate Long XP values [Champion only]"
}

-- XP Label placement choices
PXP.labelPlacements = {
    "Top",
    "Center",
    "Bottom"
}

-- Local ESO in-game fonts
PXP.fontsList = {
    ["Default"]             = "$(BOLD_FONT)",           -- ZoFontGameBold
    ["ProseAntique"]        = "$(ANTIQUE_FONT)",        -- ZoFontBookPaper
    ["Skyrim Handwritten"]  = "$(HANDWRITTEN_FONT)",    -- ZoFontBookLetter
    ["Trajan Pro"]          = "$(STONE_TABLET_FONT)",   -- ZoFontBookTablet
    ["Univers 57"]          = "$(MEDIUM_FONT)",         -- ZoFontGame
    ["Univers 67"]          = "$(BOLD_FONT)",           -- ZoFontWinH1
}
