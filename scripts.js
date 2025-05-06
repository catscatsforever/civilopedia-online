var current_language = "en"
var translations = {}
var data_mappings = {}
var data_mappings_vanilla = {}
var current_category = "cat_1"
var current_section = "sec_1"
var current_item = "item_37"
var content_mapping = []
var content_mapping_vanilla = []
let listOfTopicsViewed = []
let currentTopic = -1
let patchDiff
let encodeList = {}

var tag_mappings = {
    "NEWLINE": "<br>",
    "TAB": "&nbsp;",
    "COLOR_POSITIVE_TEXT": "<span style='color:#7FFF19'>",
    "COLOR_NEGATIVE_TEXT": "<span style='color:rgb(255,76,76)'>",
    "COLOR_CYAN": "<span style='color:#00E2E2'>",
    "ENDCOLOR": "</span>",
    ICON_ALPHA: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Alpha.png'></span>",
    ICON_BLOCKADED: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Blockaded.png'></span>",
    ICON_BULLET: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Bullet.png'></span>",
    ICON_CAPITAL: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Capital.png'></span>",
    ICON_CITIZEN: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Citizen.png'></span>",
    ICON_CITY_STATE: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.CityState.png'></span>",
    ICON_CONNECTED: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Connected.png'></span>",
    ICON_CULTURE: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Culture.png'></span>",
    ICON_DENOUNCE: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Denounce.png'></span>",
    ICON_FLOWER: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Flower.png'></span>",
    ICON_FOOD: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Food.png'></span>",
    ICON_GOLD: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Gold.png'></span>",
    ICON_GOLDEN_AGE: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.GoldenAge.png'></span>",
    ICON_GREAT_PEOPLE: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.GreatPeople.png'></span>",
    ICON_HAPPINESS_1: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Happiness1.png'></span>",
    ICON_HAPPINESS_2: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Happiness2.png'></span>",
    ICON_HAPPINESS_3: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Happiness3.png'></span>",
    ICON_HAPPINESS_4: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Happiness4.png'></span>",
    ICON_IDEOLOGY_AUTOCRACY: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.IdeologyAutocracy.png'></span>",
    ICON_IDEOLOGY_FREEDOM: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.IdeologyFreedom.png'></span>",
    ICON_IDEOLOGY_ORDER: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.IdeologyOrder.png'></span>",
    ICON_INFLUENCE: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Influence.png'></span>",
    ICON_INQUISITOR: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Inquisitor.png'></span>",
    ICON_INVEST: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Invest.png'></span>",
    ICON_LOCKED: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Locked.png'></span>",
    ICON_MINUS: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Minus.png'></span>",
    ICON_MISSIONARY: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Missionary.png'></span>",
    ICON_MOVES: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Moves.png'></span>",
    ICON_MUSHROOM: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Mushroom.png'></span>",
    ICON_OCCUPIED: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Occupied.png'></span>",
    ICON_OMEGA: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Omega.png'></span>",
    ICON_PEACE: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Peace.png'></span>",
    ICON_PIRATE: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Pirate.png'></span>",
    ICON_PLUS: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Plus.png'></span>",
    ICON_PRODUCTION: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Production.png'></span>",
    ICON_PROPHET: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Prophet.png'></span>",
    ICON_PUPPET: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Puppet.png'></span>",
    ICON_RANGE_STRENGTH: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.RangeStrength.png'></span>",
    ICON_RAZING: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Razing.png'></span>",
    ICON_RELIGION: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Religion.png'></span>",
    ICON_RELIGION_BUDDHISM: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ReligionBuddhism.png'></span>",
    ICON_RELIGION_CHRISTIANITY: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ReligionChristianity.png'></span>",
    ICON_RELIGION_CONFUCIANISM: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ReligionConfucianism.png'></span>",
    ICON_RELIGION_HINDUISM: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ReligionHinduism.png'></span>",
    ICON_RELIGION_ISLAM: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ReligionIslam.png'></span>",
    ICON_RELIGION_JUDAISM: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ReligionJudaism.png'></span>",
    ICON_RELIGION_ORTHODOX: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ReligionOrthodox.png'></span>",
    ICON_RELIGION_PANTHEON: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ReligionPantheon.png'></span>",
    ICON_RELIGION_PROTESTANT: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ReligionProtestant.png'></span>",
    ICON_RELIGION_SHINTO: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ReligionShinto.png'></span>",
    ICON_RELIGION_SIKHISM: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ReligionSikhism.png'></span>",
    ICON_RELIGION_TAOISM: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ReligionTaoism.png'></span>",
    ICON_RELIGION_TENGRIISM: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ReligionTengriism.png'></span>",
    ICON_RELIGION_ZOROASTRIANISM: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ReligionZoroastrianism.png'></span>",
    ICON_RES_ALUMINUM: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResAluminum.png'></span>",
    ICON_RES_BANANA: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResBanana.png'></span>",
    ICON_RES_CITRUS: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResCitrus.png'></span>",
    ICON_RES_COAL: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResCoal.png'></span>",
    ICON_RES_COPPER: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResCopper.png'></span>",
    ICON_RES_COTTON: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResCotton.png'></span>",
    ICON_RES_COW: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResCow.png'></span>",
    ICON_RES_CRAB: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResCrab.png'></span>",
    ICON_RES_DEER: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResDeer.png'></span>",
    ICON_RES_DYE: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResDye.png'></span>",
    ICON_RES_FISH: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResFish.png'></span>",
    ICON_RES_FUR: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResFur.png'></span>",
    ICON_RES_GEMS: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResGems.png'></span>",
    ICON_RES_GOLD: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResGold.png'></span>",
    ICON_RES_HORSE: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResHorse.png'></span>",
    ICON_RES_INCENSE: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResIncense.png'></span>",
    ICON_RES_IRON: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResIron.png'></span>",
    ICON_RES_IVORY: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResIvory.png'></span>",
    ICON_RES_JEWELRY: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResJewelry.png'></span>",
    ICON_RES_MARBLE: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResMarble.png'></span>",
    ICON_RES_OIL: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResOil.png'></span>",
    ICON_RES_PEARLS: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResPearls.png'></span>",
    ICON_RES_PORCELAIN: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResPorcelain.png'></span>",
    ICON_RES_SALT: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResSalt.png'></span>",
    ICON_RES_SHEEP: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResSheep.png'></span>",
    ICON_RES_SILK: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResSilk.png'></span>",
    ICON_RES_SILVER: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResSilver.png'></span>",
    ICON_RES_SPICES: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResSpices.png'></span>",
    ICON_RES_STONE: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResStone.png'></span>",
    ICON_RES_SUGAR: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResSugar.png'></span>",
    ICON_RES_TRUFFLES: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResTruffles.png'></span>",
    ICON_RES_URANIUM: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResUranium.png'></span>",
    ICON_RES_WHALE: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResWhale.png'></span>",
    ICON_RES_WHEAT: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResWheat.png'></span>",
    ICON_RES_WINE: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ResWine.png'></span>",
    ICON_RESEARCH: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Research.png'></span>",
    ICON_RESISTANCE: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Resistance.png'></span>",
    ICON_SPY: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Spy.png'></span>",
    ICON_STAR: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Star.png'></span>",
    ICON_STRENGTH: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Strength.png'></span>",
    ICON_TEAM_1: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Team1.png'></span>",
    ICON_TEAM_10: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Team10.png'></span>",
    ICON_TEAM_11: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Team11.png'></span>",
    ICON_TEAM_2: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Team2.png'></span>",
    ICON_TEAM_3: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Team3.png'></span>",
    ICON_TEAM_4: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Team4.png'></span>",
    ICON_TEAM_5: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Team5.png'></span>",
    ICON_TEAM_6: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Team6.png'></span>",
    ICON_TEAM_7: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Team7.png'></span>",
    ICON_TEAM_8: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Team8.png'></span>",
    ICON_TEAM_9: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Team9.png'></span>",
    ICON_TEAM_USA: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.TeamUsa.png'></span>",
    ICON_TRADE: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Trade.png'></span>",
    ICON_TRADE_WHITE: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.TradeWhite.png'></span>",
    ICON_VIEW_CITY: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.ViewCity.png'></span>",
    ICON_WAR: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.War.png'></span>",
    ICON_WORKER: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Worker.png'></span>",
    ICON_WTF1: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Wtf1.png'></span>",
    ICON_WTF2: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Wtf2.png'></span>",
    ICON_GREAT_ENGINEER: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.GreatEngineer.png'></span>",
    ICON_GREAT_GENERAL: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.GreatGeneral.png'></span>",
    ICON_GREAT_SCIENTIST: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.GreatScientist.png'></span>",
    ICON_GREAT_MERCHANT: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.GreatMerchant.png'></span>",
    ICON_GREAT_ARTIST: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.GreatArtist.png'></span>",
    ICON_GREAT_MUSICIAN: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.GreatMusician.png'></span>",
    ICON_GREAT_WRITER: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.GreatWriter.png'></span>",
    ICON_GREAT_ADMIRAL: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.GreatAdmiral.png'></span>",
    ICON_TOURISM: "<span class='icon-cont'><img class='icon align-top' src='./assets/images/icon_images/Civ5Icon.Tourism.png'></span>",
}

const itemKeys = {
    title: "{TXT_KEY_TITLE_BAR}:",
    leaders: "TXT_KEY_PEDIA_LEADERS_LABEL",
    unique_units: "TXT_KEY_PEDIA_UNIQUEUNIT_LABEL",
    unique_buildings: "TXT_KEY_PEDIA_UNIQUEBLDG_LABEL",
    unique_improvements: "TXT_KEY_PEDIA_UNIQUEIMPRV_LABEL",
    policy_branch: "TXT_KEY_PEDIA_POLICYBRANCH_LABEL",
    yields: "TXT_KEY_PEDIA_YIELD_LABEL",
    cost: "TXT_KEY_PEDIA_COST_LABEL",
    maintenance: "TXT_KEY_PEDIA_MAINT_LABEL",
    happiness: "TXT_KEY_PEDIA_HAPPINESS_LABEL",
    culture: "TXT_KEY_PEDIA_CULTURE_LABEL",
    faith: "TXT_KEY_PEDIA_FAITH_LABEL",
    defense: "TXT_KEY_PEDIA_DEFENSE_LABEL",
    food: "TXT_KEY_PEDIA_FOOD_LABEL",
    gold: "TXT_KEY_PEDIA_GOLD_LABEL",
    science: "TXT_KEY_PEDIA_SCIENCE_LABEL",
    production: "TXT_KEY_PEDIA_PRODUCTION_LABEL",
    great_engineer_points: "TXT_KEY_SPECIALIST_ENGINEER_TITLE",
    great_writer_points: "TXT_KEY_SPECIALIST_WRITER_TITLE",
    great_artist_points: "TXT_KEY_SPECIALIST_ARTIST_TITLE",
    great_merchant_points: "TXT_KEY_SPECIALIST_MERCHANT_TITLE",
    great_scientist_points: "TXT_KEY_SPECIALIST_SCIENTIST_TITLE",
    great_musician_points: "TXT_KEY_SPECIALIST_MUSICIAN_TITLE",
    combat_type: "TXT_KEY_PEDIA_COMBATTYPE_LABEL",
    combat: "TXT_KEY_PEDIA_COMBAT_LABEL",
    ranged_combat: "TXT_KEY_PEDIA_RANGEDCOMBAT_LABEL",
    range: "TXT_KEY_PEDIA_RANGE_LABEL",
    movement: "TXT_KEY_PEDIA_MOVEMENT_LABEL",
    abilities: "TXT_KEY_PEDIA_FREEPROMOTIONS_LABEL",
    required_resources: "TXT_KEY_PEDIA_REQ_RESRC_LABEL",
    movement_cost: "TXT_KEY_PEDIA_MOVECOST_LABEL",
    combat_modifier: "TXT_KEY_PEDIA_COMBATMOD_LABEL",
    revealed_by: "TXT_KEY_PEDIA_REVEAL_TECH_LABEL",
    terrains_found_on: "TXT_KEY_PEDIA_TERRAINS_LABEL",
    improved_by: "TXT_KEY_PEDIA_IMPROVEMENTS_LABEL",
    features_on: "TXT_KEY_PEDIA_FEATURES_LABEL",
    improves_resources: "TXT_KEY_PEDIA_IMPROVES_RESRC_LABEL",
    lived: "TXT_KEY_PEDIA_LIVED_LABEL",
    titles: "TXT_KEY_PEDIA_TITLES_LABEL",
    civilization: "TXT_KEY_PEDIA_CIVILIZATIONS_LABEL",
    local_resources_required: "TXT_KEY_PEDIA_LOCAL_RESRC_LABEL",
    prerequisite_techs: "TXT_KEY_PEDIA_PREREQ_TECH_LABEL",
    required_buildings: "TXT_KEY_PEDIA_REQ_BLDG_LABEL",
    specialists: "TXT_KEY_PEDIA_SPEC_LABEL",
    leads_to_techs: "TXT_KEY_PEDIA_LEADS_TO_TECH_LABEL",
    units_unlocked: "TXT_KEY_PEDIA_UNIT_UNLOCK_LABEL",
    buildings_unlocked: "TXT_KEY_PEDIA_BLDG_UNLOCK_LABEL",
    great_works: "TXT_KEY_PEDIA_GREAT_WORKS_LABEL",
    projects_unlocked: "TXT_KEY_PEDIA_PROJ_UNLOCK_LABEL",
    resources_revealed: "TXT_KEY_PEDIA_RESRC_RVL_LABEL",
    worker_actions_allowed: "TXT_KEY_PEDIA_WORKER_ACTION_LABEL",
    becomes_obsolete_with: "TXT_KEY_PEDIA_OBSOLETE_TECH_LABEL",
    upgrade_unit: "TXT_KEY_COMMAND_UPGRADE",
    replaces: "TXT_KEY_PEDIA_REPLACES_LABEL",
    can_be_built_on: "TXT_KEY_PEDIA_FOUNDON_LABEL",
    resources_found_on: "TXT_KEY_PEDIA_RESOURCESFOUND_LABEL",
    tenet_level: "TXT_KEY_PEDIA_TENET_LEVEL",
    prerequisite_era: "TXT_KEY_PEDIA_PREREQ_ERA_LABEL",
    required_policies: "TXT_KEY_PEDIA_PREREQ_POLICY_LABEL",
    required_promotions: "TXT_KEY_PEDIA_REQ_PROMOTIONS_LABEL",
    summary: "TXT_KEY_PEDIA_SUMMARY_LABEL",
    game_info: "TXT_KEY_PEDIA_GAME_INFO_LABEL",
    special_abilities: "TXT_KEY_PEDIA_ABILITIES_LABEL",
    quote: "TXT_KEY_PEDIA_QUOTE_LABEL",
    strategy: "TXT_KEY_PEDIA_STRATEGY_LABEL",
    historical_info: "TXT_KEY_PEDIA_HISTORICAL_LABEL",
}

document.addEventListener("DOMContentLoaded", async function () {
    document.querySelector("body").style.visibility = "hidden";
    let userLang = (new Intl.Locale(navigator.language)).language
    current_language = localStorage.getItem("locale") ?? (['en', 'ru'].includes(userLang) ? userLang : 'en');
    document.querySelector(".container-loader").style.visibility = "visible";
    document.querySelector("#loaderLBL").textContent = current_language === 'en' ? 'Loading' : 'Загрузка';
    for (const lang of ['en', 'ru', 'en_vanilla', 'ru_vanilla']) {
        await fetch("./assets/data/translations_" + lang + ".json")
            .then(response => response.json())
            .then(data => {
                translations[lang] = data;
            })
            .catch(error => console.error(`Error loading ${lang} translation file:`, error));
    }
    await fetch("./assets/data/structure.json")
        .then(response => response.json())
        .then(data => {
            data_mappings = data;
        })
        .catch(error => console.error(`Error loading structure.json`, error));
    await fetch("./assets/data/structure_vanilla.json")
        .then(response => response.json())
        .then(data => {
            data_mappings_vanilla = data;
        })
        .catch(error => console.error(`Error loading structure_vanilla.json`, error));
    await fetch("./assets/data/content.json")
        .then(response => response.json())
        .then(data => {
            content_mapping = data;
        })
        .catch(error => console.error(`Error loading content.json`, error));
    await fetch("./assets/data/content_vanilla.json")
        .then(response => response.json())
        .then(data => {
            content_mapping_vanilla = data;
        })
        .catch(error => console.error(`Error loading content_vanilla.json`, error));
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => bootstrap.Tooltip.getOrCreateInstance(tooltipTriggerEl, {title: get_translation(current_language, tooltipTriggerEl.getAttribute("data-bs-title")), trigger: 'hover'}))


    content_mapping.push({item_id: 'PATCH_FULL_CHANGELOG', view_id: 'view_5', strings: {title: 'TXT_KEY_PATCH_FULL_CHANGELOG_TITLE'}, diff: getPatchDiff()})
    content_mapping.push(...Object.entries(patchNotes.ru.versions).map(([k, v]) => {return {item_id: `PATCH${k}`, view_id: 'view_4', strings: {title: `TXT_KEY_PATCH_${k}_TITLE`, text: `TXT_KEY_PATCH_${k}_SUMMARY`}}}))
    data_mappings.categories[0].sections.push(
        /*{
            label: 'TXT_KEY_PATCH_FULL_TITLE',
            items: Object.entries(patchNotes.ru.full).map(([k, v]) => {return {id: `PATCH_${k}`, label: `TXT_KEY_PATCH_${k}_TITLE`}})
        },*/
        {
            label: 'TXT_KEY_PATCH_VERSIONS_TITLE',
            items: Object.entries(patchNotes.ru.versions).map(([k, v]) => {return {id: `PATCH${k}`, label: `TXT_KEY_PATCH_${k}_TITLE`}}).sort((a, b) => -a.label.localeCompare(b.label, undefined, {numeric: true}))
        })
    translations['en'] = {...translations['en'], ...patchTxtTags.en, ...Object.entries(patchNotes.en.versions).reduce((acc, [k, v]) => {return {...acc, [`TXT_KEY_PATCH_${k}_TITLE`]: `Version ${k}`, [`TXT_KEY_PATCH_${k}_SUMMARY`]: '<ul>' + addMarkup(v) + '</ul>'}}, {})}
    translations['ru'] = {...translations['ru'], ...patchTxtTags.ru, ...Object.entries(patchNotes.ru.versions).reduce((acc, [k, v]) => {return {...acc, [`TXT_KEY_PATCH_${k}_TITLE`]: `Версия ${k}`, [`TXT_KEY_PATCH_${k}_SUMMARY`]: '<ul>' + addMarkup(v) + '</ul>'}}, {})}
    if (!search_article(location.hash.substring(1))) {
        currentTopic++
        listOfTopicsViewed.push(get_info_from_item_id('PEDIA_HOME_PAGE'))
        history.replaceState({list: listOfTopicsViewed, index: currentTopic}, '', '#PEDIA_HOME_PAGE');
        search_article('PEDIA_HOME_PAGE', true)
    }
    create_listeners()
    $( "#pedia-search" ).autocomplete({
        source: content_mapping.filter(x => x?.strings.title).map((item) => {return {label: get_translation(current_language, item.strings.title), id: item.item_id}}),
        select: (e, ui) => {search_article(get_info_from_item_id(ui.item.id)?.strings.shortcut ?? ui.item.id)}
    });
    document.querySelector(".container-loader").style.visibility = "hidden";
    document.querySelector("body").style.visibility = "visible";
});

function get_translation(language, key, gcase = 0, encodeTags) {
    if (key in translations[language]) {
        return parse_tags(language, translations[language][key].split('|')[gcase], encodeTags)
    }
    else {
        return parse_tags(language, key, encodeTags)
    }
}

function addMarkup(text) {
    return text
        .trim()
        .replaceAll(/^\s*$/gm, '<br>')
        .replaceAll(/^( *)[-|*] (.+)$/gm, (m, c1, c2) => `${'<ul>'.repeat(c1.length / 2)}<li>\n${c2}</li>${'</ul>'.repeat(c1.length / 2)}`)  // bullet list item -/* with indent
        .replaceAll(/^( *)(#{1,3}) (.+)$/gm, (m, c1, c2, c3) => `<h${c2.length + 2}>\n${c3}</h${c2.length + 2}>`)  // headers # ## ###
        .replaceAll(/^( *)-# (.+)$/gm, (m, c1, c2) => `<sub>\n${c2}</sub>`)  // subtext -#
        .replaceAll(/~~([^~]+)~~/gm, (m, c1) => `<span class="strike">${c1}</span>`)  // strike ~~text~~
        .replaceAll(/__([^_]+)__/gm, (m, c1) => `<u>${c1}</u>`)  // underline __text__
        .replaceAll(/\*\*([^\*]+)\*\*/gm, (m, c1) => `<b>${c1}</b>`)  // bold **text**
        .replaceAll(/_([^_]+)_/gm, (m, c1) => `<i>${c1}</i>`).replaceAll(/\*([^\*]+)\*/gm, (m, c1) => `<i>${c1}</i>`)  // italics *text*/_text_
}

function getPatchDiff() {
    if (patchDiff)
        return patchDiff
    patchDiff = {...data_mappings.categories.reduce((acc, cat)=>{return{...acc,...{[cat.id]: {id:cat.id,label:cat.label,show:false,added:{},removed:{},updated:{}}}}},{}),cat_other:{id:'cat_other',label:'TXT_KEY_MODDING_CATEGORY_57',show:false,added:{},removed:{},updated:{}}}
    for (let o of content_mapping)  {
        let _cat = 'cat_other'
        for (let cat of data_mappings.categories) {
            for (let sec of cat.sections) {
                for (let item of sec.items) {
                    if (item.id === o.item_id) {
                        _cat = cat.id
                    }
                }
            }
        }
        if (_cat === 'cat_1' || o?.strings.shortcut)
            continue
        let v = content_mapping_vanilla.find(el => el.item_id === o.item_id);
        if (v) {
            let f = false
            let d = {strings:{}}
            Object.entries(o.strings).forEach(([k,e]) => {
                if (v.strings[k] !== undefined) {
                    let t1 = get_translation(current_language + '_vanilla', v.strings[k])?.replace(/\s\s+/g, ' ')
                    let t2 = get_translation(current_language, e)?.replace(/\s\s+/g, ' ')
                    if (t1 !== t2) {
                        f = true
                        d.strings[k] = typeof(e) === 'object' ? {label: itemKeys[k] ?? '', old: v.strings[k].filter(x => !e.includes(x)), new: e.filter(x => !v.strings[k].includes(x))} : {label: itemKeys[k] ?? '', old: v.strings[k], new: e}
                    }
                } else {
                    if (e) {
                        f = true
                        d.strings[k] = {label: itemKeys[k] ?? '', old: typeof(e) === 'object' ? [] : 0, new: e}
                    }
                }
            })
            Object.entries(v.strings).forEach(([k,e]) => {
                if (o.strings[k] === undefined) {
                    if (e) {
                        f = true
                        d.strings[k] = {label: itemKeys[k] ?? '', old: e, new: typeof(e) === 'object' ? [] : 0}
                    }
                }
            })
            if (f) {
                d.o1 = v
                d.o2 = o
                patchDiff[_cat].updated[o.item_id] = d
                patchDiff[_cat].show = true
            }
        }
        else {
            patchDiff[_cat].added[o.item_id] = o
            patchDiff[_cat].show = true
        }
    }
    for (let o of content_mapping_vanilla) {
        let _cat = 'cat_other'
        for (let cat of data_mappings_vanilla.categories) {
            for (let sec of cat.sections) {
                for (let item of sec.items) {
                    if (item.id === o.item_id) {
                        _cat = cat.id
                    }
                }
            }
        }
        if (_cat === 'cat_1' || o?.strings.shortcut)
            continue
        if (!content_mapping.find(el => el.item_id === o.item_id)) {
            patchDiff[_cat].removed[o.item_id] = o
            patchDiff[_cat].show = true
        }
    }
    return patchDiff
}

function parse_tags(language, text, encodeTags) {
    if (!text) return;
    text = text.toString()
    var matches = text.match(/{([^}]*)}/g);
    for (let match in matches) {
        let gcase = 0
        let s  = matches[match].replaceAll(/\[([0-9])\]}$/g, (m) => {gcase = parseInt(m[1]) - 1; return '}'})
        //console.log(matches[match], s, gcase)
        text = text.replace(matches[match], s.startsWith('{TXT_KEY_') ? get_translation(language, s.replaceAll(/[{}]/g, ""), gcase, encodeTags) : '')
    }
    return text.replace(/\[([^\]]+)\]/g, (_, a) => {
        if (tag_mappings[a]) {
            if (encodeTags) {
                let i = 12345 + Object.keys(tag_mappings).indexOf(a)
                encodeList[String.fromCodePoint(i)] = a
                return String.fromCodePoint(i)
            }
            return `${tag_mappings[a]}`
        }
        return ''
    })
}

function create_listeners() {
    const buttons = document.querySelectorAll('.language-button');
    buttons.forEach(function (button) {
        button.addEventListener('click', function () {
            current_language = this.value
            localStorage.setItem("locale", current_language);
            $('[data-bs-toggle="tooltip"]').tooltip('dispose')
            search_article(current_item.id)
            $( "#pedia-search" ).autocomplete('option', {
                source: content_mapping.map((item) => {return {label: get_translation(current_language, item.strings.title), id: item.item_id}}),
                select: (e, ui) => {search_article(get_info_from_item_id(ui.item.id)?.strings.shortcut ?? ui.item.id)}
            });
        });
    });
}

Object.entries({
    get_item_image: (id) => get_info_from_item_id(id)["strings"]["image"],
    get_item_image_v: (id) => content_mapping_vanilla.find(element => element.item_id === id)["strings"]["image"],
    get_item_label: (s) => itemKeys[s] ?? '',
    get_item_name: (id) => get_info_from_item_id(id)["strings"]["title"],
    get_item_name_v: (id) => content_mapping_vanilla.find(element => element.item_id === id)["strings"]["title"],
    get_diff: (s1, s2) => getDiff(s1, s2),
    eq: (a,b) => a == b,
    is_object: (o) => typeof(o) === 'object',
    parse_tags: (s) => parse_tags(current_language, s),
    parse_tags_v: (s) => parse_tags(current_language, s),
    parse_tags_p: (s) => parse_tags(current_language + '_vanilla', s),
    translate: (s) => get_translation(current_language, s),
    translate_v: (s) => get_translation(current_language + '_vanilla', s),
}).forEach(([k,v]) => { Handlebars.registerHelper(k, v) })

prettyHtml = function(diffs) {
    var html = [];
    var pattern_amp = /&/g;
    var pattern_lt = /</g;
    var pattern_gt = />/g;
    var pattern_para = /\n/g;
    for (var x = 0; x < diffs.length; x++) {
        var op = diffs[x][0];    // Operation (insert, delete, equal)
        var data = diffs[x][1];  // Text of change.
        var text = data.replace(pattern_amp, '&amp;').replace(pattern_lt, '&lt;').replace(pattern_gt, '&gt;').replace(pattern_para, '&para;<br>');
        switch (op) {
            case DIFF_INSERT:
                html[x] = '<ins>' + text + '</ins>';
                break;
            case DIFF_DELETE:
                html[x] = '<del>' + text + '</del>';
                break;
            case DIFF_EQUAL:
                html[x] = '<span>' + text + '</span>';
                break;
        }
    }
    return html.join('').replaceAll('</ins><del>', '</ins> <del>').replaceAll('</del><ins>', '</del> <ins>');
};

function getDiff(s1, s2) {
    s1 = s1 ? get_translation(current_language + '_vanilla', s1, undefined, true) : ''
    s2 = s2 ? get_translation(current_language, s2, undefined, true) : ''
    let dmp = new diff_match_patch();
    let diff = dmp.diff_main(s1, s2);
    dmp.diff_cleanupSemantic(diff);
    let score = (2 * dmp.diff_levenshtein(diff)) / (s1.replaceAll(/<[^>]+>/g, '').length + s2.replaceAll(/<[^>]+>/g, '').length)
    let re = new RegExp(`[${Object.keys(encodeList).join('')}]`, 'g')
    if (score > 0.8 || !isNaN(parseInt(s1)))
        return '<del>' + s1.replaceAll(re, (c) => get_translation(current_language, `[${encodeList[c]}]`)).replaceAll('<br>', ' ') + '</del> <ins>' + s2.replaceAll(re, (c) => parse_tags(current_language, `[${encodeList[c]}]`)).replaceAll('<br>', ' ') + '</ins>'
    else {
        return prettyHtml(diff).replaceAll(re, (c) => get_translation(current_language, `[${encodeList[c]}]`)).replaceAll('<br>', ' ').replaceAll('&amp;', '&').replaceAll('&lt;', '<').replaceAll('&gt;', '>')
    }
}

function generate_view(ignoreTopicList) {
    $("#content-area").empty()
    var item_data = content_mapping.find(item => item.item_id === current_item.id);
    if (item_data.rand_image) {
        let items = [].concat(...current_category.sections.map(s => s.items.map(i => get_info_from_item_id(i.id).strings.image))).filter(it => it)
        item_data.strings.image = items[Math.floor(Math.random() * items.length)]
    }
    var template = Handlebars.compile($("#" + item_data["view_id"]).html())
    $("#content-area").append(template(item_data))
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => bootstrap.Tooltip.getOrCreateInstance(tooltipTriggerEl, {title: get_translation(current_language, tooltipTriggerEl.getAttribute("data-bs-title")), trigger: 'hover'}))

    if (!ignoreTopicList) {
        currentTopic++
        listOfTopicsViewed = listOfTopicsViewed.slice(0, currentTopic)
        listOfTopicsViewed.push(current_item)
        history.pushState({list: listOfTopicsViewed, index: currentTopic}, "", `#${current_item.id}`)
    }
    document.title = get_translation(current_language, item_data.strings.title) + ' • ' + get_translation(current_language, 'TXT_KEY_CIVILOPEDIA')
}

$(document).on("click", ".category-tab", function () {
    current_category = data_mappings["categories"].find(item => item.id === this.value);
    current_section = current_category["sections"][0]
    current_item = current_section["items"][0]
    set_heading()
    generate_accordion_list()
    generate_view()
});

$(document).on("click", ".list-group-item", function () {
    let item = get_info_from_item_id($(this).attr("value"));
    search_article(item?.strings.shortcut ?? item.item_id);
})

$(document).on("click", ".info-box-content .small-image", function () {
    let value = $(this).attr("value")
    console.log(value)
    if (value) {
        value = get_info_from_item_id(value)?.strings.shortcut ?? value
        if (search_article(value)) {
            $(this).tooltip('dispose')
        }
    }
})

$(document).on("click", '#backbutton', () => {
    if (currentTopic > 0) {
        currentTopic--
        history.back()
    }
})

$(document).on("click", '#forwardbutton', () => {
    if (currentTopic < listOfTopicsViewed.length - 1) {
        currentTopic++
        history.forward()
    }
})

window.addEventListener("popstate", (e) => {
    $('[data-bs-toggle="tooltip"]').tooltip('dispose')
    currentTopic = e.state.index
    if (!search_article(location.hash.substring(1), true)) {
        search_article('PEDIA_HOME_PAGE', true)
    }
});

function switch_category() {
    $('button.active.category-tab').toggleClass('active');
    $(`button.category-tab[value="${current_category.id}"]`).toggleClass('active');
    set_heading()
}

function set_heading() {
    $("#current_heading").text(get_translation(current_language, current_category["label"]));
    $("#civilopedia-title").text(get_translation(current_language, "TXT_KEY_CIVILOPEDIA"));
    $("#language-dropdown-desktop").text(get_translation(current_language, "TXT_KEY_OPSCREEN_SELECT_LANG"));
    $("#pedia-search").attr('placeholder', get_translation(current_language, "TXT_KEY_SEARCH"));
}

function generate_accordion_list() {
    $("#accordionExample").empty()
    var accordion_section = ""
    current_category["sections"].forEach((section, index) => {
        if (!['cat_1', 'cat_2'].includes(current_category.id))
            section["items"].sort((a, b) => (index === 0 && section["items"].indexOf(a) === 0) ? -1 : get_translation(current_language,a.label).localeCompare(get_translation(current_language,b.label), undefined, {numeric: true}))

        if (index == 0) {
            accordion_section = `<div class="accordion-item"><div id="collapseNone" class="accordion-collapse collapse show"><ul value=${section.id} class="list-group list-group-flush">`
            section["items"].forEach((item) => {
                accordion_section += `<li value=${item.id} class="list-group-item${current_item.id === item.id ? ' active' : ''}">${get_translation(current_language, item.label)}</li>`
            });
            accordion_section += `</ul></div></div>`
        }
        else {
            accordion_section = `<div class="accordion-item"><div class="accordion-header" id="heading${section.id}"><button class="accordion-button p-1 shadow-none" type="button" data-bs-toggle="collapse"
                data-bs-target="#collapse${section.id}" aria-expanded="true" aria-controls="collapse${section.id}">
                ${get_translation(current_language, section.label)}</button></div>
            <div id="collapse${section.id}" class="accordion-collapse collapse show" aria-labelledby="heading${section.id}">
              <ul value=${section.id} class="list-group list-group-flush">`
            section["items"].forEach((item) => {
                accordion_section += `<li value=${item.id} class="list-group-item${current_item.id === item.id ? ' active' : ''}">${get_translation(current_language, item.label)}</li>`
            });

            accordion_section += `</ul></div></div>`
        }
        $("#accordionExample").append(accordion_section)
    });
}


function get_info_from_item_id(item_id) {
    let item_info = content_mapping.find(element => element.item_id === item_id);
    return item_info
}

function search_article(item_id, ignoreTopicList) {
    for (let cat of data_mappings.categories) {
        for (let sec of cat.sections) {
            for (let item of sec.items) {
                if (item.id === item_id) {
                    let bSamePage = current_item.id === item.id
                    current_category = cat
                    switch_category()
                    current_section = sec
                    current_item = item
                    generate_accordion_list()
                    generate_view(ignoreTopicList || bSamePage)
                    return true
                }
            }
        }
    }
    console.log('search failure', item_id)
    return false
}
