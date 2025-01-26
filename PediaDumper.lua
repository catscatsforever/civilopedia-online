-- Civ 5 Civilopedia json dumper
-- usage: run Civ 5; run Civ 5 SDK -> Firaxis Live Tuner -> Lua Console -> Main State -> dofile('C:/Projects/Github/civilopedia-online/PediaDumper.lua')

---------------------------------------
-- helper functions
---------------------------------------
local json = {}

local function kind_of(obj)
  if type(obj) ~= 'table' then return type(obj) end
  local i = 1
  for _ in pairs(obj) do
	if obj[i] ~= nil then i = i + 1 else return 'table' end
  end
  if i == 1 then return 'table' else return 'array' end
end

local function escape_str(s)
  local in_char  = {'\\', '"', '/', '\b', '\f', '\n', '\r', '\t'}
  local out_char = {'\\', '"', '/',  'b',  'f',  'n',  'r',  't'}
  for i, c in ipairs(in_char) do
	s = s:gsub(c, '\\' .. out_char[i])
  end
  return s
end

function json.stringify(obj, as_key)
  local s = {}  -- We'll build the string as an array of strings to be concatenated.
  local kind = kind_of(obj)  -- This is 'array' if it's an array or type(obj) otherwise.
  if kind == 'array' then
	if as_key then error('Can\'t encode array as key.') end
	s[#s + 1] = '['
	for i, val in ipairs(obj) do
	  if i > 1 then s[#s + 1] = ', ' end
	  s[#s + 1] = json.stringify(val)
	end
	s[#s + 1] = ']'
  elseif kind == 'table' then
	if as_key then error('Can\'t encode table as key.') end
	s[#s + 1] = '{'
	for k, v in pairs(obj) do
	  if #s > 1 then s[#s + 1] = ', ' end
	  s[#s + 1] = json.stringify(k, true)
	  s[#s + 1] = ':'
	  s[#s + 1] = json.stringify(v)
	end
	s[#s + 1] = '}'
  elseif kind == 'string' then
	return '"' .. escape_str(obj) .. '"'
  elseif kind == 'number' then
	if as_key then return '"' .. tostring(obj) .. '"' end
	return tostring(obj)
  elseif kind == 'boolean' then
	return tostring(obj)
  elseif kind == 'nil' then
	return 'null'
  else
	error('Unjsonifiable type: ' .. kind .. '.')
  end
  return table.concat(s)
end

json.null = {}  -- This is a one-off table to represent the null value.

function Vector2( i, j )	   return { x = i, y = j }; end
function Vector3( i, j, k )	return { x = i, y = j, z = k }; end
function Vector4( i, j, k, l ) return { x = i, y = j, z = k, w = l }; end

function IconLookup( offset, iconSize, atlas )
	if (offset < 0) then
		return nil, nil;
	end	
	if(g_IconAtlases == nil) then
		PopulateIconAtlases();
	end
	local atlas = g_IconAtlases and g_IconAtlases[atlas];
	if(atlas ~= nil) then
		local entry = atlas[iconSize];
		if(entry ~= nil) then
		
			local filename = entry[1];
			local numRows = entry[3];
			local numCols = entry[2];
			
			if (filename == nil or offset > (numRows * numCols) - 1) then
				return;
			end
			
			return Vector2( (offset % numCols) * iconSize, math.floor(offset / numCols) * iconSize ), filename;			
		end
	end	
end


---------------------------------------
-- CIVILOPEDIA EXPORT
---------------------------------------

print('Civilopedia export START')
local PATH = debug.getinfo(1).source:match("@?(.*/)")  -- this script's absolute path
print('PATH:', PATH)
--local PATH = string.format("%s\\Documents\\My Games\\Sid Meier's Civilization 5\\cache", os.getenv('USERPROFILE'))
local atlasList = {}
local content = {}
local translations_en = {}
local translations_ru = {}
local agindex = 1

local cat = {
	home = 1,
	concepts = 2,
	techs = 3,
	units = 4,
	promotions = 5,
	buildings = 6,
	wonders = 7,
	policies = 8,
	people = 9,
	civs = 10,
	citystates = 11,
	terrains = 12,
	resources = 13,
	improvements = 14,
	religion = 15,
	congress = 16
}

-- hopefully categories will not change; (other) sections and items are populated from the database.
local structure = {
	categories = { {
			sections = {
				{ label = 'TXT_KEY_PEDIA_CATEGORY_1_LABEL' }
			}
		}, {
			sections = {
				{ label = 'TXT_KEY_PEDIA_GAME_CONCEPT_PAGE_LABEL' }
				-- expands from Concepts.CivilopediaHeaderType
			}
		}, {
			sections = {
				{ label = 'TXT_KEY_PEDIA_TECH_PAGE_LABEL' }
				-- expands from Eras
			}
		}, {
			sections = {
				{ label = 'TXT_KEY_PEDIA_UNITS_PAGE_LABEL' },
				{ label = 'TXT_KEY_PEDIA_RELIGIOUS', items = {} }
				-- expands from Eras
			}
		}, {
			sections = {
				{ label = 'TXT_KEY_PEDIA_PROMOTIONS_PAGE_LABEL' }
			}
		}, {
			sections = {
				{ label = 'TXT_KEY_PEDIA_BUILDINGS_PAGE_LABEL' },
				{ label = 'TXT_KEY_PEDIA_RELIGIOUS', items = {} }
				-- expands from Eras
			}
		}, {
			sections = {
				{ label = 'TXT_KEY_PEDIA_WONDERS_PAGE_LABEL' },
				{ label = 'TXT_KEY_WONDER_SECTION_1', items = {} },
				{ label = 'TXT_KEY_WONDER_SECTION_2', items = {} },
				{ label = 'TXT_KEY_WONDER_SECTION_3', items = {} }
			}
		}, {
			sections = {
				{ label = 'TXT_KEY_PEDIA_POLICIES_PAGE_LABEL' }
				-- expands from PolicyBranchTypes
			}
		}, {
			sections = {
				{ label = 'TXT_KEY_PEDIA_PEOPLE_PAGE_LABEL' },
				{ label = 'TXT_KEY_PEOPLE_SECTION_1', items = {} },
				{ label = 'TXT_KEY_PEOPLE_SECTION_2', items = {} }
			}
		}, {
			sections = {
				{ label = 'TXT_KEY_PEDIA_CIVILIZATIONS_PAGE_LABEL' },
				{ label = 'TXT_KEY_CIVILIZATION_SECTION_1', items = {} },
				{ label = 'TXT_KEY_CIVILIZATION_SECTION_2', items = {} }
			}
		}, {
			sections = {
				{ label = 'TXT_KEY_PEDIA_CITY_STATES_PAGE_LABEL' }
				-- expands from MinorCivTraits
			}
		}, {
			sections = {
				{ label = 'TXT_KEY_PEDIA_TERRAIN_PAGE_LABEL' },
				{ label = 'TXT_KEY_PEDIA_TERRAIN_LABEL', items = {} },
				{ label = 'TXT_KEY_PEDIA_TERRAIN_FEATURES_LABEL', items = {} }
			}
		}, {
			sections = {
				{ label = 'TXT_KEY_PEDIA_RESOURCES_PAGE_LABEL' },
				{ label = 'TXT_KEY_RESOURCES_SECTION_0', items = {} },
				{ label = 'TXT_KEY_RESOURCES_SECTION_1', items = {} },
				{ label = 'TXT_KEY_RESOURCES_SECTION_2', items = {} }
			}
		}, {
			sections = {
				{ label = 'TXT_KEY_PEDIA_IMPROVEMENTS_PAGE_LABEL', items = {} }
			}
		}, {
			sections = {
				{ label = 'TXT_KEY_PEDIA_BELIEFS_PAGE_LABEL' },
				{ label = 'TXT_KEY_PEDIA_BELIEFS_CATEGORY_1', items = {} },
				{ label = 'TXT_KEY_PEDIA_BELIEFS_CATEGORY_2', items = {} },
				{ label = 'TXT_KEY_PEDIA_BELIEFS_CATEGORY_3', items = {} },
				{ label = 'TXT_KEY_PEDIA_BELIEFS_CATEGORY_4', items = {} },
				{ label = 'TXT_KEY_PEDIA_BELIEFS_CATEGORY_5', items = {} },
				{ label = 'TXT_KEY_PEDIA_BELIEFS_CATEGORY_6', items = {} }
			}
		}, {
			sections = {
				{ label = 'TXT_KEY_PEDIA_WORLD_CONGRESS_PAGE_LABEL' },
				{ label = 'TXT_KEY_PEDIA_WORLD_CONGRESS_CATEGORY_1', items = {} },
				{ label = 'TXT_KEY_PEDIA_WORLD_CONGRESS_CATEGORY_2', items = {} }
			}
		}
	}
}
for icat, k in next, cat do
	structure.categories[k].label = 'TXT_KEY_PEDIA_CATEGORY_' .. tostring(k) .. '_LABEL'
	structure.categories[k].sections[1].items = {{
		label = structure.categories[k].sections[1].label,
		id = 'PEDIA_' .. Locale.ToUpper(icat) .. '_PAGE'
	}}
end

-- These projects were more of an implementation detail and not explicit projects
-- that the user can build.  So to avoid confusion, we shall ignore them from the pedia.
local projectsToIgnore = {
	PROJECT_SS_COCKPIT = true,
	PROJECT_SS_STASIS_CHAMBER = true,
	PROJECT_SS_ENGINE = true,
	PROJECT_SS_BOOSTER = true
};

------------------------------
-- Home Page
------------------------------
content = { {
		item_id = "PEDIA_HOME_PAGE",
		strings = {
			image = "assets/images/TERRAIN_ATLAS/i_20.png",
			title = "TXT_KEY_PEDIA_HOME_PAGE_LABEL",
			quote = "TXT_KEY_PEDIA_HOME_PAGE_BLURB_TEXT",
			section_title = "TXT_KEY_PEDIA_HOME_PAGE_HELP_LABEL",
			section_text = "TXT_KEY_PEDIA_HOME_PAGE_HELP_TEXT"
	   }
	}, {
		item_id = "PEDIA_CONCEPTS_PAGE",
		strings = {
			image = "assets/images/TECH_ATLAS_1/i_47.png",
			title = "TXT_KEY_PEDIA_GAME_CONCEPT_PAGE_LABEL",
			quote = "TXT_KEY_PEDIA_QUOTE_BLOCK_GCONCEPTS",
			section_title = "TXT_KEY_PEDIA_GAME_CONCEPT_PAGE_LABEL",
			section_text = "TXT_KEY_PEDIA_GAME_CONCEPT_HELP_TEXT"
		}
	}, {
		item_id = "PEDIA_TECHS_PAGE",
		rand_image = true,
		strings = {
			title = "TXT_KEY_PEDIA_TECH_PAGE_LABEL",
			quote = "TXT_KEY_PEDIA_QUOTE_BLOCK_TECHS",
			section_title = "TXT_KEY_PEDIA_TECH_PAGE_LABEL",
			section_text = "TXT_KEY_PEDIA_TECHNOLOGIES_HELP_TEXT"
		}
	}, {
		item_id = "PEDIA_UNITS_PAGE",
		rand_image = true,
		strings = {
			title = "TXT_KEY_PEDIA_UNITS_PAGE_LABEL",
			quote = "TXT_KEY_PEDIA_QUOTE_BLOCK_UNITS",
			section_title = "TXT_KEY_PEDIA_UNITS_PAGE_LABEL",
			section_text = "TXT_KEY_PEDIA_UNITS_HELP_TEXT"
		}
	}, {
		item_id = "PEDIA_PROMOTIONS_PAGE",
		rand_image = true,
		strings = {
			title = "TXT_KEY_PEDIA_PROMOTIONS_PAGE_LABEL",
			quote = "TXT_KEY_PEDIA_QUOTE_BLOCK_PROMOTIONS",
			section_title = "TXT_KEY_PEDIA_PROMOTIONS_PAGE_LABEL",
			section_text = "TXT_KEY_PEDIA_PROMOTIONS_HELP_TEXT"
		}
	}, {
		item_id = "PEDIA_BUILDINGS_PAGE",
		rand_image = true,
		strings = {
			title = "TXT_KEY_PEDIA_BUILDINGS_PAGE_LABEL",
			quote = "TXT_KEY_PEDIA_QUOTE_BLOCK_BUILDINGS",
			section_title = "TXT_KEY_PEDIA_BUILDINGS_PAGE_LABEL",
			section_text = "TXT_KEY_PEDIA_BUILDINGS_HELP_TEXT"
		}
	}, {
		item_id = "PEDIA_WONDERS_PAGE",
		rand_image = true,
		strings = {
			title = "TXT_KEY_PEDIA_WONDERS_PAGE_LABEL",
			quote = "TXT_KEY_PEDIA_QUOTE_BLOCK_WONDERS",
			section_title = "TXT_KEY_PEDIA_WONDERS_PAGE_LABEL",
			section_text = "TXT_KEY_PEDIA_WONDERS_HELP_TEXT"
		}
	}, {
		item_id = "PEDIA_POLICIES_PAGE",
		rand_image = true,
		strings = {
			title = "TXT_KEY_PEDIA_POLICIES_PAGE_LABEL",
			quote = "TXT_KEY_PEDIA_QUOTE_BLOCK_POLICIES",
			section_title = "TXT_KEY_PEDIA_POLICIES_PAGE_LABEL",
			section_text = "TXT_KEY_PEDIA_SOCIAL_POL_HELP_TEXT"
		}
	}, {
		item_id = "PEDIA_PEOPLE_PAGE",
		strings = {
			image = "assets/images/UNIT_ATLAS_2/i_47.png",
			title = "TXT_KEY_PEDIA_PEOPLE_PAGE_LABEL",
			quote = "TXT_KEY_PEDIA_QUOTE_BLOCK_PEOPLE",
			section_title = "TXT_KEY_PEDIA_PEOPLE_PAGE_LABEL",
			section_text = "TXT_KEY_PEDIA_SPEC_HELP_TEXT"
		}
	}, {
		item_id = "PEDIA_CIVS_PAGE",
		rand_image = true,
		strings = {
			title = "TXT_KEY_PEDIA_CIVILIZATIONS_PAGE_LABEL",
			quote = "TXT_KEY_PEDIA_QUOTE_BLOCK_CIVS",
			section_title = "TXT_KEY_PEDIA_CIVILIZATIONS_PAGE_LABEL",
			section_text = "TXT_KEY_PEDIA_CIVS_HELP_TEXT"
		}
	}, {
		item_id = "PEDIA_CITYSTATES_PAGE",
		strings = {
			image = "assets/images/UNIT_ATLAS_2/i_44.png",
			title = "TXT_KEY_PEDIA_CITY_STATES_PAGE_LABEL",
			quote = "TXT_KEY_PEDIA_QUOTE_BLOCK_CITYSTATES",
			section_title = "TXT_KEY_PEDIA_CITY_STATES_PAGE_LABEL",
			section_text = "TXT_KEY_PEDIA_CSTATES_HELP_TEXT"
		}
	}, {
		item_id = "PEDIA_TERRAINS_PAGE",
		rand_image = true,
		strings = {
			title = "TXT_KEY_PEDIA_TERRAIN_PAGE_LABEL",
			quote = "TXT_KEY_PEDIA_QUOTE_BLOCK_TERRAIN",
			section_title = "TXT_KEY_PEDIA_TERRAIN_LABEL",
			section_text = "TXT_KEY_TERRAIN_HEADING1_BODY",
			section_title_2 = "TXT_KEY_PEDIA_TERRAIN_FEATURES_LABEL",
			section_text_2 = "TXT_KEY_TERRAIN_FEATURES_HEADING2_BODY"
		}
	}, {
		item_id = "PEDIA_RESOURCES_PAGE",
		rand_image = true,
		strings = {
			title = "TXT_KEY_PEDIA_RESOURCES_PAGE_LABEL",
			quote = "TXT_KEY_PEDIA_QUOTE_BLOCK_RESOURCES",
			section_title = "TXT_KEY_PEDIA_RESOURCES_PAGE_LABEL",
			section_text = "TXT_KEY_PEDIA_RESOURCES_HELP_TEXT"
		}
	}, {
		item_id = "PEDIA_IMPROVEMENTS_PAGE",
		rand_image = true,
		strings = {
			title = "TXT_KEY_PEDIA_IMPROVEMENTS_PAGE_LABEL",
			quote = "TXT_KEY_PEDIA_QUOTE_BLOCK_IMPROVEMENTS",
			section_title = "TXT_KEY_PEDIA_IMPROVEMENTS_PAGE_LABEL",
			section_text = "TXT_KEY_PEDIA_IMPROVEMENT_HELP_TEXT"
		}
	}, {
		item_id = "PEDIA_RELIGION_PAGE",
		strings = {
			image = "assets/images/religion256.png",
			title = "TXT_KEY_PEDIA_BELIEFS_PAGE_LABEL",
			quote = "TXT_KEY_PEDIA_BELIEFS_HOMEPAGE_BLURB",
			section_title = "TXT_KEY_PEDIA_BELIEFS_PAGE_LABEL",
			section_text = "TXT_KEY_PEDIA_BELIEFS_HOMEPAGE_TEXT1"
		}
	}, {
		item_id = "PEDIA_CONGRESS_PAGE",
		strings = {
			image = "assets/images/worldcongressportrait.png",
			title = "TXT_KEY_PEDIA_WORLD_CONGRESS_PAGE_LABEL",
			quote = "TXT_KEY_WONDER_UNITEDNATIONS_QUOTE",
			section_title = "TXT_KEY_PEDIA_CATEGORY_16_LABEL",
			section_text = "TXT_KEY_PEDIA_WORLD_CONGRESS_HOMEPAGE_TEXT1"
		}
	}
}
structure.categories[cat.home].sections[1].items = {}
for k in next, content do
	content[k].view_id = 'view_3'
	structure.categories[cat.home].sections[1].items[#structure.categories[cat.home].sections[1].items + 1] = {
		id = k == 1 and content[k].item_id or content[k].item_id .. '_SH',
		label = 'TXT_KEY_PEDIA_CATEGORY_' .. tostring(k) .. '_LABEL'
	}
end
for k, i in next, cat do
	content[#content + 1] = {
		item_id = content[i].item_id .. '_SH',
		view_id = 'view_3',
		strings = {
			shortcut = content[i].item_id
		}
	}
end
------------------------------
-- Concepts
------------------------------
local conceptSections = {
	HEADER_CITIES = 1,
	HEADER_COMBAT = 2,
	HEADER_TERRAIN = 3,
	HEADER_RESOURCES = 4,
	HEADER_IMPROVEMENTS = 5,
	HEADER_CITYGROWTH = 6,
	HEADER_TECHNOLOGY = 7,
	HEADER_CULTURE = 8,
	HEADER_DIPLOMACY = 9,
	HEADER_HAPPINESS = 10,
	HEADER_FOW = 11,
	HEADER_POLICIES = 12,
	HEADER_GOLD = 13,
	HEADER_ADVISORS = 14,
	HEADER_PEOPLE = 15,
	HEADER_CITYSTATE = 16,
	HEADER_MOVEMENT = 17,
	HEADER_AIRCOMBAT = 18,
	HEADER_RUBARB = 19,
	HEADER_UNITS = 20,
	HEADER_VICTORY = 21,
	HEADER_ESPIONAGE = 22,
	HEADER_RELIGION = 23,
	HEADER_TRADE = 24,
	HEADER_WORLDCONGRESS = 25,
}
local offset = #structure.categories[cat.concepts].sections
for sec, k in next, conceptSections do
	structure.categories[cat.concepts].sections[offset + k] = {
		label = 'TXT_KEY_GAME_CONCEPT_SECTION_' .. tostring(k),
		items = {}
	}
end
for thisConcept in GameInfo.Concepts() do
	local sectionID = conceptSections[thisConcept.CivilopediaHeaderType];
	if (sectionID ~= nil) then
		structure.categories[cat.concepts].sections[offset + sectionID].items[#structure.categories[cat.concepts].sections[offset + sectionID].items + 1] = {
			id = thisConcept.Type,
			label = thisConcept.Description
		}
		local entry = { strings = {} };
		entry.item_id = thisConcept.Type
		entry.view_id = 'view_1'
		entry.strings.title = thisConcept.Description
		entry.strings.summary = thisConcept.Summary
		content[#content + 1] = entry;
	end
end
------------------------------
-- Technologies
------------------------------
function tagFormat(text, args)
	local t = {}
	local temp = string.gsub(text, '({[@]?[0-9]+[^}]*})', function(s)
		local match = args[tonumber(s:sub(2,2)) or tonumber(s:sub(3,3))]
		if s:sub(-4,-4) == '[' and tonumber(s:sub(-3,-3)) and s:sub(-2,-2) == ']' then
			return match:sub(1,-2) .. '[' .. s:sub(-3,-3) .. ']}'
		else
			return match
		end
	end)
	return temp
end
local k = 1
local offset = #structure.categories[cat.techs].sections
-- for each era
for era in GameInfo.Eras() do
	local eraID = era.ID;
	local sectionID = k
	k = k + 1
	structure.categories[cat.techs].sections[#structure.categories[cat.techs].sections + 1] = {
		label = era.Description,
		items = {}
	}
	-- for each tech in this era
	for tech in GameInfo.Technologies("Era = '" .. era.Type .. "'") do
		structure.categories[cat.techs].sections[offset + sectionID].items[#structure.categories[cat.techs].sections[offset + sectionID].items + 1] = {
			id = tech.Type,
			label = tech.Description
		}
		local entry = { strings = {} };
		entry.item_id = tech.Type
		entry.view_id = 'view_1'
		local condition = "TechType = '" .. tech.Type .. "'";
		local prereqCondition = "PrereqTech = '" .. tech.Type .. "'";
		local otherPrereqCondition = "TechPrereq = '" .. tech.Type .. "'";
		local revealCondition = "TechReveal = '" .. tech.Type .. "'";
		local tech_prereqs = {}
		for q in GameInfo.Technology_PrereqTechs( condition ) do
			tech_prereqs[#tech_prereqs + 1] = q.PrereqTech
		end
		local tech_unlocks = {}
		for q in GameInfo.Technology_PrereqTechs( prereqCondition ) do
			tech_unlocks[#tech_unlocks + 1] = q.TechType
		end
		local unit_unlocks = {}
		for q in GameInfo.Units( prereqCondition ) do
			if q.ShowInPedia then
				unit_unlocks[#unit_unlocks + 1] = q.Type
			end
		end
		local building_unlocks = {}
		for q in GameInfo.Buildings( prereqCondition ) do
			building_unlocks[#building_unlocks + 1] = q.Type
		end
		local build_unlocks = {}
		for q in GameInfo.Builds( prereqCondition ) do
			build_unlocks[#build_unlocks + 1] = q.Type
		end
		local resource_reveals = {}
		for q in GameInfo.Resources( revealCondition ) do
			resource_reveals[#resource_reveals + 1] = q.Type
		end
		local project_unlocks = {}
		for q in GameInfo.Projects( otherPrereqCondition ) do
			local bIgnore = projectsToIgnore[q.Type];
			if (bIgnore ~= true) then
				project_unlocks[#project_unlocks + 1] = q.Type
			end
		end
		local tblAbilities = {}
		for row in GameInfo.Route_TechMovementChanges( condition ) do
			for row2 in DB.Query([[select language_en_us.text as texten, language_ru_ru.text as textru from localization.language_en_us
				left join language_ru_ru using(tag) where tag = "TXT_KEY_CIVILOPEDIA_SPECIALABILITIES_MOVEMENT"]]) do
				local tag = 'TXT_KEY_PEDIA_AUTOGENERATED' .. tostring(agindex)
				agindex = agindex + 1
				local t = { '{'..GameInfo.Routes[row.RouteType].Description..'}' }
				translations_en[tag] = tagFormat(row2.texten, t)
				translations_ru[tag] = tagFormat(row2.textru, t)
				tblAbilities[#tblAbilities + 1] = '{' .. tag .. '}'
			end
		end
		for row in GameInfo.Improvement_TechYieldChanges( condition ) do
			for row2 in DB.Query([[select language_en_us.text as texten, language_ru_ru.text as textru from localization.language_en_us
				left join language_ru_ru using(tag) where tag = "TXT_KEY_CIVILOPEDIA_SPECIALABILITIES_YIELDCHANGES"]]) do
				local tag = 'TXT_KEY_PEDIA_AUTOGENERATED' .. tostring(agindex)
				agindex = agindex + 1
				local t = { '{'..GameInfo.Improvements[row.ImprovementType].Description..'}', '{'..GameInfo.Yields[row.YieldType].Description..'}', row.Yield }
				translations_en[tag] = tagFormat(row2.texten, t)
				translations_ru[tag] = tagFormat(row2.textru, t)
				tblAbilities[#tblAbilities + 1] = '{' .. tag .. '}'
			end
		end
		for row in GameInfo.Improvement_TechNoFreshWaterYieldChanges( condition ) do
			for row2 in DB.Query([[select language_en_us.text as texten, language_ru_ru.text as textru from localization.language_en_us
				left join language_ru_ru using(tag) where tag = "TXT_KEY_CIVILOPEDIA_SPECIALABILITIES_NOFRESHWATERYIELDCHANGES"]]) do
				local tag = 'TXT_KEY_PEDIA_AUTOGENERATED' .. tostring(agindex)
				agindex = agindex + 1
				local t = { '{'..GameInfo.Improvements[row.ImprovementType].Description..'}', '{'..GameInfo.Yields[row.YieldType].Description..'}', row.Yield }
				translations_en[tag] = tagFormat(row2.texten, t)
				translations_ru[tag] = tagFormat(row2.textru, t)
				tblAbilities[#tblAbilities + 1] = '{' .. tag .. '}'
			end
		end
		for row in GameInfo.Improvement_TechFreshWaterYieldChanges( condition ) do
			for row2 in DB.Query([[select language_en_us.text as texten, language_ru_ru.text as textru from localization.language_en_us
				left join language_ru_ru using(tag) where tag = "TXT_KEY_CIVILOPEDIA_SPECIALABILITIES_FRESHWATERYIELDCHANGES"]]) do
				local tag = 'TXT_KEY_PEDIA_AUTOGENERATED' .. tostring(agindex)
				agindex = agindex + 1
				local t = { '{'..GameInfo.Improvements[row.ImprovementType].Description..'}', '{'..GameInfo.Yields[row.YieldType].Description..'}', row.Yield }
				translations_en[tag] = tagFormat(row2.texten, t)
				translations_ru[tag] = tagFormat(row2.textru, t)
				tblAbilities[#tblAbilities + 1] = '{' .. tag .. '}'
			end
		end
		if tech.EmbarkedMoveChange > 0 then
			tblAbilities[#tblAbilities + 1] = "{TXT_KEY_ABLTY_FAST_EMBARK_STRING}"
		end
		if tech.AllowsEmbarking then
			tblAbilities[#tblAbilities + 1] = "{TXT_KEY_ALLOWS_EMBARKING}"
		end
		if tech.AllowsDefensiveEmbarking then
			tblAbilities[#tblAbilities + 1] = "{TXT_KEY_ABLTY_DEFENSIVE_EMBARK_STRING}"
		end
		if tech.EmbarkedAllWaterPassage then
			tblAbilities[#tblAbilities + 1] = "{TXT_KEY_ABLTY_OCEAN_EMBARK_STRING}"
		end
		if tech.OpenBordersTradingAllowed then
			tblAbilities[#tblAbilities + 1] = "{TXT_KEY_ABLTY_OPEN_BORDER_STRING}"
		end
		if tech.DefensivePactTradingAllowed then
			tblAbilities[#tblAbilities + 1] = "{TXT_KEY_ABLTY_D_PACT_STRING}"
		end
		if tech.ResearchAgreementTradingAllowed then
			tblAbilities[#tblAbilities + 1] = "{TXT_KEY_ABLTY_R_PACT_STRING}"
		end
		if tech.TradeAgreementTradingAllowed then
			tblAbilities[#tblAbilities + 1] = "{TXT_KEY_ABLTY_T_PACT_STRING}"
		end
		if tech.BridgeBuilding then
			tblAbilities[#tblAbilities + 1] = "{TXT_KEY_ABLTY_BRIDGE_STRING}"
		end
		entry.strings.image = string.format('assets/images/%s/i_%d.png', tech.IconAtlas, tech.PortraitIndex)
		atlasList[tech.IconAtlas] = true
		entry.strings.title = tech.Description or nil;
		entry.strings.game_info = tech.Help or nil;
		entry.strings.historical_info = tech.Civilopedia or nil;
		entry.strings.quote = tech.Quote or nil;
		entry.strings.cost = string.format('%s [ICON_RESEARCH]', tech.Cost);
		entry.strings.era = tech.Era or nil;
		entry.strings.prerequisite_techs = next(tech_prereqs) and tech_prereqs or nil
		entry.strings.leads_to_techs = next(tech_unlocks) and tech_unlocks or nil
		entry.strings.buildings_unlocked = next(building_unlocks) and building_unlocks or nil
		entry.strings.units_unlocked = next(unit_unlocks) and unit_unlocks or nil
		entry.strings.worker_actions_allowed = next(build_unlocks) and build_unlocks or nil
		entry.strings.resources_revealed = next(resource_reveals) and resource_reveals or nil
		entry.strings.special_abilities = next(tblAbilities) and table.concat(tblAbilities, '[NEWLINE]') or nil
		entry.strings.projects_unlocked = next(project_unlocks) and project_unlocks or nil
		content[#content + 1] = entry;
	end
end
------------------------------
-- Units
------------------------------
function processUnit( unit )
	local entry = { strings = {} };
	entry.item_id = unit.Type
	entry.view_id = 'view_1'
	local condition = "UnitType = '" .. unit.Type .. "'";
	local costString = "";
	local cost = unit.Cost;
	local faithCost = unit.FaithCost;
	if (cost == 1 and faithCost > 0) then
		costString = tostring(faithCost) .. " [ICON_PEACE]";
	elseif (cost > 0 and faithCost > 0) then
		costString = tostring(cost) .. " [ICON_PRODUCTION] {TXT_KEY_PEDIA_A_OR_B} " .. tostring(faithCost) .. " [ICON_PEACE]"
	else
		if (cost > 0) then
			costString = tostring(cost) .. " [ICON_PRODUCTION]";
		elseif (faithCost > 0) then
			costString = tostring(faithCost) .. " [ICON_PEACE]";
		else
			costString = "TXT_KEY_FREE"
		end
	end
	entry.strings.cost = costString
	local abilities = {}
	for row in GameInfo.Unit_FreePromotions( condition ) do
		local promotion = GameInfo.UnitPromotions[row.PromotionType];
		if promotion then
			abilities[#abilities + 1] = promotion.Type
		end	
	end
	local required_resources = {}
	for row in GameInfo.Unit_ResourceQuantityRequirements( condition ) do
		local requiredResource = GameInfo.Resources[row.ResourceType];
		if requiredResource then
			required_resources[#required_resources + 1] = requiredResource.Type
		end		
	end
	local tech_prereq = {}
	if unit.PrereqTech then
		local prereq = GameInfo.Technologies[unit.PrereqTech];
		if prereq then
			tech_prereq[#tech_prereq + 1] = prereq.Type
		end
	end
	local tech_obsolete = {}
	if unit.ObsoleteTech then
		local obs = GameInfo.Technologies[unit.ObsoleteTech];
		if obs then
			tech_obsolete[#tech_obsolete + 1] = obs.Type
		end
	end
	local upgrades = {}
	for row in GameInfo.Unit_ClassUpgrades{UnitType = unit.Type} do	
		local unitClass = GameInfo.UnitClasses[row.UnitClassType];
		local upgradeUnit = GameInfo.Units[unitClass.DefaultUnit];
		if (upgradeUnit) then
			upgrades[#upgrades + 1] = upgradeUnit.Type
		end		
	end
	local replacesUnitClass = {};
	local specificCivs = {};
	local classOverrideCondition = string.format("UnitType='%s' and CivilizationType <> 'CIVILIZATION_BARBARIAN' and CivilizationType <> 'CIVILIZATION_MINOR'", unit.Type);
	for row in GameInfo.Civilization_UnitClassOverrides(classOverrideCondition) do
		specificCivs[#specificCivs + 1] = row.CivilizationType;
		replacesUnitClass[#replacesUnitClass + 1] = GameInfo.UnitClasses[row.UnitClassType].DefaultUnit;
	end
	entry.strings.image = string.format('assets/images/%s/i_%d.png', unit.IconAtlas, unit.PortraitIndex)
	atlasList[unit.IconAtlas] = true
	entry.strings.title = unit.Description or nil
	entry.strings.strategy = unit.Strategy or nil
	entry.strings.historical_info = unit.Civilopedia or nil
	entry.strings.game_info = unit.Help or nil
	entry.strings.movement = unit.Moves > 0 and tostring(unit.Moves) .. ' [ICON_MOVES]' or nil
	entry.strings.abilities = next(abilities) and abilities or nil
	entry.strings.combat_type = unit.CombatClass and GameInfo.UnitCombatInfos[unit.CombatClass].Description or nil
	entry.strings.combat = unit.Combat > 0 and tostring(unit.Combat) .. ' [ICON_STRENGTH]' or nil
	entry.strings.ranged_combat = unit.RangedCombat > 0 and tostring(unit.RangedCombat) .. ' [ICON_RANGE_STRENGTH]' or nil
	entry.strings.range = unit.Range or nil
	entry.strings.prerequisite_techs = next(tech_prereq) and tech_prereq or nil
	entry.strings.becomes_obsolete_with = next(tech_obsolete) and tech_obsolete or nil
	entry.strings.upgrade_unit = next(upgrades) and upgrades or nil
	entry.strings.civilization = next(specificCivs) and specificCivs or nil
	entry.strings.replaces = next(replacesUnitClass) and replacesUnitClass or nil
	entry.strings.required_resources = next(required_resources) and required_resources or nil
	content[#content + 1] = entry;
end
local k = 1
local offset = #structure.categories[cat.units].sections
-- for each era
for era in GameInfo.Eras() do
	local eraID = era.ID;
	local sectionID = k
	k = k + 1
	structure.categories[cat.units].sections[#structure.categories[cat.units].sections + 1] = {
		label = era.Description,
		items = {}
	}
	-- for each tech in this era
	for tech in GameInfo.Technologies("Era = '" .. era.Type .. "'") do
		-- for each unit that requires this tech
		for unit in GameInfo.Units("PrereqTech = '" .. tech.Type .. "'") do
			if unit.ShowInPedia then
				if unit.FaithCost > 0 and unit.Cost == -1 and not unit.RequiresFaithPurchaseEnabled then  -- religious section
					structure.categories[cat.units].sections[2].items[#structure.categories[cat.units].sections[2].items + 1] = {
						id = unit.Type,
						label = unit.Description
					}
				else
					structure.categories[cat.units].sections[offset + sectionID].items[#structure.categories[cat.units].sections[offset + sectionID].items + 1] = {
						id = unit.Type,
						label = unit.Description
					}
				end
				processUnit(unit)
			end
		end
	end
	
	-- put in all of the units that do not have tech requirements in the Ancient Era for lack of a better place
	if eraID == 0 then
		for unit in GameInfo.Units() do
			if unit.PrereqTech == nil and unit.Special == nil then
				if unit.ShowInPedia then
					if unit.FaithCost > 0 and unit.Cost == -1 and not unit.RequiresFaithPurchaseEnabled then  -- religious section
						structure.categories[cat.units].sections[2].items[#structure.categories[cat.units].sections[2].items + 1] = {
							id = unit.Type,
							label = unit.Description
						}
					else
						structure.categories[cat.units].sections[offset + 1].items[#structure.categories[cat.units].sections[offset + 1].items + 1] = {
							id = unit.Type,
							label = unit.Description
						}
					end
					processUnit(unit)
				end
			end
		end
	end
end
------------------------------
-- Promotions
------------------------------
local promotionAddons = {
	PEDIA_HEAL = '_h',
	PEDIA_AIR = '_a',
	PEDIA_ATTRIBUTES = '_at',
	PEDIA_MELEE = '_m',
	PEDIA_NAVAL = '_n',
	PEDIA_RANGED = '_r',
	PEDIA_SCOUTING = '_s',
	PEDIA_SHARED = '_sh'
}
local promotionSections = {
	PEDIA_MELEE = 1,
	PEDIA_RANGED = 2,
	PEDIA_NAVAL = 3,
	PEDIA_HEAL = 4,
	PEDIA_SCOUTING = 5,
	PEDIA_AIR = 6,
	PEDIA_SHARED = 7,
	PEDIA_ATTRIBUTES = 8
}
local offset = #structure.categories[cat.promotions].sections
-- populate sections
for k, v in next, promotionSections do
	structure.categories[cat.promotions].sections[offset + v] = {
		label = 'TXT_KEY_PROMOTIONS_SECTION_' .. tostring(v),
		items = {}
	}
end
-- for each promotion
for thisPromotion in GameInfo.UnitPromotions() do
	local sectionID = promotionSections[thisPromotion.PediaType];
	if (sectionID ~= nil) then
		structure.categories[cat.promotions].sections[offset + sectionID].items[#structure.categories[cat.promotions].sections[offset + sectionID].items + 1] = {
			id = thisPromotion.Type,
			label = thisPromotion.Description
		}
	end
	local entry = { strings = {} };
	entry.item_id = thisPromotion.Type
	entry.view_id = 'view_1'
	local prereqs = {}
	if thisPromotion.PromotionPrereqOr1 then
		local thisReq = GameInfo.UnitPromotions[thisPromotion.PromotionPrereqOr1];
		if thisReq then
			prereqs[#prereqs + 1] = thisReq.Type
		end
	end
	if thisPromotion.PromotionPrereqOr2 then
		local thisReq = GameInfo.UnitPromotions[thisPromotion.PromotionPrereqOr2];
		if thisReq then
			prereqs[#prereqs + 1] = thisReq.Type
		end
	end
	if thisPromotion.PromotionPrereqOr3 then
		local thisReq = GameInfo.UnitPromotions[thisPromotion.PromotionPrereqOr3];
		if thisReq then
			prereqs[#prereqs + 1] = thisReq.Type
		end
	end
	if thisPromotion.PromotionPrereqOr4 then
		local thisReq = GameInfo.UnitPromotions[thisPromotion.PromotionPrereqOr4];
		if thisReq then
			prereqs[#prereqs + 1] = thisReq.Type
		end
	end
	if thisPromotion.PromotionPrereqOr5 then
		local thisReq = GameInfo.UnitPromotions[thisPromotion.PromotionPrereqOr5];
		if thisReq then
			prereqs[#prereqs + 1] = thisReq.Type
		end
	end
	if thisPromotion.PromotionPrereqOr6 then
		local thisReq = GameInfo.UnitPromotions[thisPromotion.PromotionPrereqOr6];
		if thisReq then
			prereqs[#prereqs + 1] = thisReq.Type
		end
	end
	if thisPromotion.PromotionPrereqOr7 then
		local thisReq = GameInfo.UnitPromotions[thisPromotion.PromotionPrereqOr7];
		if thisReq then
			prereqs[#prereqs + 1] = thisReq.Type
		end
	end
	if thisPromotion.PromotionPrereqOr8 then
		local thisReq = GameInfo.UnitPromotions[thisPromotion.PromotionPrereqOr8];
		if thisReq then
			prereqs[#prereqs + 1] = thisReq.Type
		end
	end
	if thisPromotion.PromotionPrereqOr9 then
		local thisReq = GameInfo.UnitPromotions[thisPromotion.PromotionPrereqOr9];
		if thisReq then
			prereqs[#prereqs + 1] = thisReq.Type
		end
	end
	entry.strings.image = string.format('assets/images/%s/i_%d.png', thisPromotion.IconAtlas, thisPromotion.PortraitIndex)
	atlasList[thisPromotion.IconAtlas] = true
	entry.strings.title = thisPromotion.Description or nil
	entry.strings.game_info = thisPromotion.Help or nil
	entry.strings.required_promotions = next(prereqs) and prereqs or nil
	content[#content + 1] = entry;
end
------------------------------
-- Buildings
------------------------------
local GPlookup = {
	SPECIALIST_WRITER = 'great_writer_points',
	SPECIALIST_ARTIST = 'great_artist_points',
	SPECIALIST_MUSICIAN = 'great_musician_points',
	SPECIALIST_SCIENTIST = 'great_scientist_points',
	SPECIALIST_MERCHANT = 'great_merchant_points',
	SPECIALIST_ENGINEER = 'great_engineer_points',
}
function processBuildingOrWonder( building, bProject )
	local entry = { strings = {} };
	entry.item_id = building.Type
	entry.view_id = 'view_1'
	local condition = "BuildingType = '" .. building.Type .. "'";
	local costString = "";
	local cost = building.Cost;
	local faithCost = bProject and 0 or building.FaithCost;
	local costPerPlayer = 0;
	for tLeagueProject in GameInfo.LeagueProjects() do
		if (tLeagueProject ~= nil) then
			for iTier = 1, 3, 1 do
				if (tLeagueProject["RewardTier" .. iTier] ~= nil) then
					local tReward = GameInfo.LeagueProjectRewards[tLeagueProject["RewardTier" .. iTier]];
					if (tReward ~= nil and tReward.Building ~= nil) then
						if (GameInfo.Buildings[tReward.Building] ~= nil and GameInfo.Buildings[tReward.Building].ID == buildingID) then
							costPerPlayer = tLeagueProject.CostPerPlayer;
						end
					end
				end
			end
		end
	end
	if (costPerPlayer > 0) then
		costString = tostring(costPerPlayer) .. ' TXT_KEY_PER_CIV';
	elseif (cost == 1 and faithCost > 0) then
		costString = tostring(faithCost) .. " [ICON_PEACE]";
	elseif (cost > 0 and faithCost > 0) then
		costString = tostring(cost) .. " [ICON_PRODUCTION] {TXT_KEY_PEDIA_A_OR_B} " .. tostring(faithCost) .. " [ICON_PEACE]"
	else
		if (cost > 0) then
			costString = tostring(cost) .. " [ICON_PRODUCTION]";
		elseif (faithCost > 0) then
			costString = tostring(faithCost) .. " [ICON_PEACE]";
		else
			costString = "TXT_KEY_FREE";
		end
	end
	entry.strings.cost = costString
	local GetBuildingYieldChange = function(buildingID, yieldType)
		local yieldModifier = 0;
		local buildingType = GameInfo.Buildings[buildingID].Type;
		for row in GameInfo.Building_YieldChanges{BuildingType = buildingType, YieldType = yieldType} do
			yieldModifier = yieldModifier + row.Yield;
		end
		return yieldModifier;
	end
	local GetBuildingYieldModifier = function(buildingID, yieldType)
		local yieldModifier = 0;
		local buildingType = GameInfo.Buildings[buildingID].Type;
		for row in GameInfo.Building_YieldModifiers{BuildingType = buildingType, YieldType = yieldType} do
			yieldModifier = yieldModifier + row.Yield;
		end
		return yieldModifier;
	end
	local tblFood = {}
	local iFood = GetBuildingYieldChange(building.ID, "YIELD_FOOD");
	if (iFood > 0) then
		tblFood[#tblFood + 1] = "+" .. tostring(iFood).." [ICON_FOOD]"
	end
	local iFood = GetBuildingYieldModifier(building.ID, "YIELD_FOOD");
	if (iFood > 0) then
		tblFood[#tblFood + 1] = "+" .. tostring(iFood).."% [ICON_FOOD]"
	end
	if (#tblFood > 0) then
		entry.strings.food = table.concat(tblFood, ', ')
	end
	local tblGold = {}
	local iGold = GetBuildingYieldChange(building.ID, "YIELD_GOLD");
	if (iGold > 0) then
		tblGold[#tblGold + 1] = "+" .. tostring(iGold).." [ICON_GOLD]"
	end
	local iGold = GetBuildingYieldModifier(building.ID, "YIELD_GOLD");
	if (iGold > 0) then
		tblGold[#tblGold + 1] = "+" .. tostring(iGold).."% [ICON_GOLD]"
	end
	if (#tblGold > 0) then
		entry.strings.gold = table.concat(tblGold, ', ')
	end
	local tblScience = {}
	local iScience = GetBuildingYieldChange(building.ID, "YIELD_SCIENCE");
	if (iScience > 0) then
		tblScience[#tblScience + 1] = "+" .. tostring(iScience).." [ICON_RESEARCH]"
	end
	local iScience = GetBuildingYieldModifier(building.ID, "YIELD_SCIENCE");
	if (iScience > 0) then
		tblScience[#tblScience + 1] = "+" .. tostring(iScience).."% [ICON_RESEARCH]"
	end
	if (#tblScience > 0) then
		entry.strings.science = table.concat(tblScience, ', ')
	end
	local tblProduction = {}
	local iProduction = GetBuildingYieldChange(building.ID, "YIELD_PRODUCTION");
	if (iProduction > 0) then
		tblProduction[#tblProduction + 1] = "+" .. tostring(iProduction).." [ICON_PRODUCTION]"
	end
	local iProduction = GetBuildingYieldModifier(building.ID, "YIELD_PRODUCTION");
	if (iProduction > 0) then
		tblProduction[#tblProduction + 1] = "+" .. tostring(iProduction).."% [ICON_PRODUCTION]"
	end
	if (#tblProduction > 0) then
		entry.strings.production = table.concat(tblProduction, ', ')
	end
	local tblCulture = {}
	local iCulture = GetBuildingYieldChange(building.ID, "YIELD_CULTURE");
	if (iCulture > 0) then
		tblCulture[#tblCulture + 1] = "+" .. tostring(iCulture).." [ICON_CULTURE]"
	end
	local iCulture = GetBuildingYieldModifier(building.ID, "YIELD_CULTURE");
	if (iCulture > 0) then
		tblCulture[#tblCulture + 1] = "+" .. tostring(iCulture).."% [ICON_CULTURE]"
	end
	if (#tblCulture > 0) then
		entry.strings.culture = table.concat(tblCulture, ', ')
	end
	local tblFaith = {}
	local iFaith = GetBuildingYieldChange(building.ID, "YIELD_FAITH");
	if (iFaith > 0) then
		tblFaith[#tblFaith + 1] = "+" .. tostring(iFaith).." [ICON_PEACE]"
	end
	local iFaith = GetBuildingYieldModifier(building.ID, "YIELD_FAITH");
	if (iFaith > 0) then
		tblFaith[#tblFaith + 1] = "+" .. tostring(iFaith).."% [ICON_PEACE]"
	end
	if (#tblFaith > 0) then
		entry.strings.faith = table.concat(tblFaith, ', ')
	end
	local iGPType = bProject and nil or building.SpecialistType;
	if iGPType ~= nil then
		local iNumPoints = building.GreatPeopleRateChange;
		if (iNumPoints > 0) then
			if GPlookup[GameInfo.Specialists[iGPType].Type] then
				entry.strings[GPlookup[GameInfo.Specialists[iGPType].Type]] = tostring(iNumPoints).." [ICON_GREAT_PEOPLE]"
			end
		end
	end
	local specialists = {}
	-- TODO missing SpecialistType key for BARN and MANHATTAN_PROJECT
	if (not bProject and building.SpecialistCount > 0 and building.SpecialistType) then
		local thisSpec = GameInfo.Specialists[building.SpecialistType];
		if (thisSpec) then
			for _ = 1, building.SpecialistCount do
				specialists[#specialists + 1] = thisSpec.Type
			end
		end
	end	
	local building_prereq = {}
	for row in GameInfo.Building_ClassesNeededInCity( condition ) do
		local buildingClass = GameInfo.BuildingClasses[row.BuildingClassType];
		if (buildingClass) then
			local thisBuildingInfo = GameInfo.Buildings[buildingClass.DefaultBuilding];
			if (thisBuildingInfo) then
				building_prereq[#building_prereq + 1] = thisBuildingInfo.Type
			end
		end
	end
	local required_local_resources = {}
	for row in GameInfo.Building_LocalResourceAnds( condition ) do
		local requiredResource = GameInfo.Resources[row.ResourceType];
		if requiredResource then
			required_local_resources[#required_local_resources + 1] = requiredResource.Type
		end		
	end
	local required_resources = {}
	for row in GameInfo.Building_ResourceQuantityRequirements( condition ) do
		local requiredResource = GameInfo.Resources[row.ResourceType];
		if requiredResource then
			required_resources[#required_resources + 1] = requiredResource.Type
		end		
	end
	local tech_prereq = {}
	if not bProject and building.PrereqTech then
		local prereq = GameInfo.Technologies[building.PrereqTech];
		if prereq then
			tech_prereq[#tech_prereq + 1] = prereq.Type
		end
	end
	local defaultBuilding = {}
	local thisCiv = {}
	for row in GameInfo.Civilization_BuildingClassOverrides( condition ) do
		if row.CivilizationType ~= "CIVILIZATION_BARBARIAN" and row.CivilizationType ~= "CIVILIZATION_MINOR" then
			local otherCondition = "Type = '" .. row.BuildingClassType .. "'";
			for classrow in GameInfo.BuildingClasses( otherCondition ) do
				defaultBuilding[#defaultBuilding + 1] = GameInfo.Buildings[classrow.DefaultBuilding].Type;
			end
			if defaultBuilding then
				thisCiv[#thisCiv + 1] = GameInfo.Civilizations[row.CivilizationType].Type;
				break;
			end
		end
	end
	great_works = {}
	if (not bProject and building.GreatWorkCount > 0) then
		for i = 1, building.GreatWorkCount, 1 do
			local greatWorkSlot = GameInfo.GreatWorkSlots[building.GreatWorkSlotType];
			if greatWorkSlot then
				great_works[#great_works + 1] = greatWorkSlot.Type
			end		
		end
	end
	entry.strings.image = string.format('assets/images/%s/i_%d.png', building.IconAtlas, building.PortraitIndex)
	atlasList[building.IconAtlas] = true
	entry.strings.title = building.Description or nil
	entry.strings.game_info = building.Help or nil
	entry.strings.historical_info = building.Civilopedia or nil
	entry.strings.quote = not bProject and building.Quote or nil
	entry.strings.prerequisite_techs = next(tech_prereq) and tech_prereq or nil
	entry.strings.strategy = building.Strategy or nil
	if not bProject and building.Happiness + building.UnmoddedHappiness > 0 then
		entry.strings.happiness = string.format('%d [ICON_HAPPINESS_1]', building.Happiness + building.UnmoddedHappiness)
	end
	entry.strings.great_works = next(great_works) and great_works or nil
	entry.strings.maintenance = not bProject and building.GoldMaintenance > 0 and tostring(building.GoldMaintenance) .. ' [ICON_GOLD]' or nil
	if not bProject then
		tblDef = {}
		if building.Defense ~= 0 then
			tblDef[#tblDef + 1] = string.format('%s [ICON_STRENGTH]', tostring(building.Defense / 100))
		end
		if building.ExtraCityHitPoints ~= 0 then
			tblDef[#tblDef + 1] = string.format('%+d {TXT_KEY_HP}', building.ExtraCityHitPoints)
		end
		entry.strings.defense = next(tblDef) and table.concat(tblDef, ', ') or nil
	end
	entry.strings.civilization = next(thisCiv) and thisCiv or nil
	entry.strings.replaces = next(defaultBuilding) and defaultBuilding or nil
	entry.strings.specialists = next(specialists) and specialists or nil
	entry.strings.required_buildings = next(building_prereq) and building_prereq or nil
	entry.strings.local_resources_required = next(required_local_resources) and required_local_resources or nil
	entry.strings.required_resources = next(required_resources) and required_resources or nil
	content[#content + 1] = entry;
end
local k = 1
local offset = #structure.categories[cat.buildings].sections
-- for each era
for era in GameInfo.Eras() do
	local eraID = era.ID;
	local sectionID = k
	k = k + 1
	structure.categories[cat.buildings].sections[#structure.categories[cat.buildings].sections + 1] = {
		label = era.Description,
		items = {}
	}
	-- for each tech in this era
	for tech in GameInfo.Technologies("Era = '" .. era.Type .. "'") do
		-- for each building that requires this tech
		for building in GameInfo.Buildings("PrereqTech = '" .. tech.Type .. "'") do
			-- exclude wonders etc.				
			local thisBuildingClass = GameInfo.BuildingClasses[building.BuildingClass];
			if thisBuildingClass.MaxGlobalInstances < 0 and (thisBuildingClass.MaxPlayerInstances ~= 1 or building.SpecialistCount > 0) and thisBuildingClass.MaxTeamInstances < 0 then
				if building.FaithCost > 0 and building.Cost == -1 then  -- religious section
					structure.categories[cat.buildings].sections[2].items[#structure.categories[cat.buildings].sections[2].items + 1] = {
						id = building.Type,
						label = building.Description
					}
				else
					structure.categories[cat.buildings].sections[offset + sectionID].items[#structure.categories[cat.buildings].sections[offset + sectionID].items + 1] = {
						id = building.Type,
						label = building.Description
					}
				end
				processBuildingOrWonder(building)
			end
		end
	end
	
	-- put in all of the buildings that do not have tech requirements in the Ancient Era for lack of a better place
	if eraID == 0 then
		for building in GameInfo.Buildings() do
			if building.PrereqTech == nil then
				-- exclude wonders etc.				
				local thisBuildingClass = GameInfo.BuildingClasses[building.BuildingClass];
				if thisBuildingClass.MaxGlobalInstances < 0 and (thisBuildingClass.MaxPlayerInstances ~= 1 or building.SpecialistCount > 0) and thisBuildingClass.MaxTeamInstances < 0 then
					if building.FaithCost > 0 and building.Cost == -1 then  -- religious section
						structure.categories[cat.buildings].sections[2].items[#structure.categories[cat.buildings].sections[2].items + 1] = {
							id = building.Type,
							label = building.Description
						}
					else
						structure.categories[cat.buildings].sections[offset + 1].items[#structure.categories[cat.buildings].sections[offset + 1].items + 1] = {
							id = building.Type,
							label = building.Description
						}
					end
					processBuildingOrWonder(building)
				end
			end
		end
	end
end
------------------------------
-- Wonders
------------------------------
for building in GameInfo.Buildings() do	
	-- exclude wonders etc.				
	local thisBuildingClass = GameInfo.BuildingClasses[building.BuildingClass];
	if thisBuildingClass.MaxGlobalInstances > 0  then
		structure.categories[cat.wonders].sections[2].items[#structure.categories[cat.wonders].sections[2].items + 1] = {
			id = building.Type,
			label = building.Description
		}
		processBuildingOrWonder(building)
	end
end
for building in GameInfo.Buildings() do	
	local thisBuildingClass = GameInfo.BuildingClasses[building.BuildingClass];
	if thisBuildingClass.MaxPlayerInstances == 1 and building.SpecialistCount == 0  then
		structure.categories[cat.wonders].sections[3].items[#structure.categories[cat.wonders].sections[3].items + 1] = {
			id = building.Type,
			label = building.Description
		}
		processBuildingOrWonder(building)
	end
end
for building in GameInfo.Projects() do
	local bIgnore = projectsToIgnore[building.Type];	
	if (bIgnore ~= true) then
		structure.categories[cat.wonders].sections[4].items[#structure.categories[cat.wonders].sections[4].items + 1] = {
			id = building.Type,
			label = building.Description
		}
		processBuildingOrWonder(building, true)
	end
end
------------------------------
-- Policies
------------------------------
function processPolicy( policy )
	local entry = { strings = {} };
	entry.item_id = policy.Type
	entry.view_id = 'view_1'
	if policy.PolicyBranchType then
		local branch = GameInfo.PolicyBranchTypes[policy.PolicyBranchType];
		if branch then
			entry.strings.policy_branch = branch.Description
			if branch.EraPrereq then
				local era = GameInfo.Eras[branch.EraPrereq];
				if era then
					entry.strings.prerequisite_era = era.Description
				end
			end
		end
	end
	local required_policies = {}
	local condition = "PolicyType = '" .. policy.Type .. "'";
	for row in GameInfo.Policy_PrereqPolicies( condition ) do
		local requiredPolicy = GameInfo.Policies[row.PrereqPolicy];
		if requiredPolicy then
			required_policies[#required_policies + 1] = requiredPolicy.Type
		end
	end
	local tenetLevelLabels = {
		"TXT_KEY_POLICYSCREEN_L1_TENET",
		"TXT_KEY_POLICYSCREEN_L2_TENET",
		"TXT_KEY_POLICYSCREEN_L3_TENET",
	}
	local tenetLevel = tonumber(policy.Level);
	if (tenetLevel ~= nil and tenetLevel > 0) then
		entry.strings.tenet_level = tenetLevelLabels[tenetLevel]
	end
	entry.strings.image = string.format('assets/images/%s/i_%d.png', policy.IconAtlas, policy.PortraitIndex)
	atlasList[policy.IconAtlas] = true
	entry.strings.title = policy.Description or nil
	entry.strings.game_info = policy.Help or nil
	entry.strings.historical_info = policy.Civilopedia or nil
	entry.strings.required_policies = next(required_policies) and required_policies or nil
	content[#content + 1] = entry;
end
local k = 1
local offset = #structure.categories[cat.policies].sections
-- for each policy branch
for branch in GameInfo.PolicyBranchTypes() do
	local branchID = branch.ID;
	local sectionID = k
	k = k + 1
	structure.categories[cat.policies].sections[#structure.categories[cat.policies].sections + 1] = {
		label = branch.Description,
		items = {}
	}
	-- for each policy in this branch
	for policy in GameInfo.Policies("PolicyBranchType = '" .. branch.Type .. "'") do
		structure.categories[cat.policies].sections[offset + sectionID].items[#structure.categories[cat.policies].sections[offset + sectionID].items + 1] = {
			id = policy.Type,
			label = policy.Description
		}
		processPolicy(policy)
	end
	-- put in free policies that belong to this branch in here
	if (branch.FreePolicy ~= nil) then
		local freePolicy = GameInfo.Policies[branch.FreePolicy];
		if freePolicy then
			structure.categories[cat.policies].sections[offset + sectionID].items[#structure.categories[cat.policies].sections[offset + sectionID].items + 1] = {
				id = freePolicy.Type,
				label = freePolicy.Description
			}
			processPolicy(freePolicy)
		end
	end
end
------------------------------
-- Specialists And GP
------------------------------
for person in GameInfo.Specialists() do
	structure.categories[cat.people].sections[2].items[#structure.categories[cat.people].sections[2].items + 1] = {
		id = person.Type,
		label = person.Description
	}
	local entry = { strings = {} };
	entry.item_id = person.Type
	entry.view_id = 'view_1'
	entry.strings.image = string.format('assets/images/%s/i_%d.png', person.IconAtlas, person.PortraitIndex)
	atlasList[person.IconAtlas] = true
	entry.strings.title = person.Description or nil
	entry.strings.summary = person.Strategy or nil
	content[#content + 1] = entry;
end
for unit in GameInfo.Units() do
	if unit.PrereqTech == nil and unit.Special ~= nil then
		structure.categories[cat.people].sections[3].items[#structure.categories[cat.people].sections[3].items + 1] = {
			id = unit.Type,
			label = unit.Description
		}
		local entry = { strings = {} };
		entry.item_id = unit.Type
		entry.view_id = 'view_1'
		entry.strings.image = string.format('assets/images/%s/i_%d.png', unit.IconAtlas, unit.PortraitIndex)
		atlasList[unit.IconAtlas] = true
		entry.strings.title = unit.Description or nil
		entry.strings.historical_info = unit.Civilopedia or nil
		entry.strings.strategy = unit.Strategy or nil
		content[#content + 1] = entry;
	end
end
------------------------------
-- Civilizations And Leaders
------------------------------
function TagExists( tag )
	return Locale.HasTextKey(tag);
end
for row in GameInfo.Civilizations() do
	if row.Type ~= "CIVILIZATION_MINOR" and row.Type ~= "CIVILIZATION_BARBARIAN" then
		structure.categories[cat.civs].sections[2].items[#structure.categories[cat.civs].sections[2].items + 1] = {
			id = row.Type,
			label = row.ShortDescription
		}
		local entry = { strings = {} };
		entry.item_id = row.Type
		entry.view_id = 'view_1'
		local condition = "CivilizationType = '" .. row.Type .. "'";
		local leaders = {}
		for leader in GameInfo.Civilization_Leaders("CivilizationType = '" .. row.Type .. "'") do
			leaders[#leaders + 1] = leader.LeaderheadType
		end
		local unique_units = {}
		for thisOverride in GameInfo.Civilization_UnitClassOverrides( condition ) do
			if thisOverride.UnitType ~= nil then
				local thisUnitInfo = GameInfo.Units[thisOverride.UnitType];
				if thisUnitInfo then
					unique_units[#unique_units + 1] = thisUnitInfo.Type
				end
			end
		end
		local unique_buildings = {}
		for thisOverride in GameInfo.Civilization_BuildingClassOverrides( condition ) do
			if thisOverride.BuildingType ~= nil then
				local thisBuildingInfo = GameInfo.Buildings[thisOverride.BuildingType];
				if thisBuildingInfo then
					unique_buildings[#unique_buildings + 1] = thisBuildingInfo.Type
				end
			end
		end
		local unique_improvements = {}
		for thisImprovement in GameInfo.Improvements( condition ) do
			unique_improvements[#unique_improvements + 1] = thisImprovement.Type
		end
		local headings = {}
		local texts = {}
		local tagString = row.CivilopediaTag;
		if tagString then
			local headerString = tagString .. "_HEADING_";
			local bodyString = tagString .. "_TEXT_";
			local notFound = false;
			local i = 1;
			repeat
				local headerTag = headerString .. tostring( i );
				local bodyTag = bodyString .. tostring( i );
				if TagExists( headerTag ) and TagExists( bodyTag ) then
					headings[#headings + 1] = headerTag
					texts[#texts + 1] = bodyTag
				else
					notFound = true;		
				end
				i = i + 1;
			until notFound;

			local factoidHeaderString = tagString .. "_FACTOID_HEADING";
			local factoidBodyString = tagString .. "_FACTOID_TEXT";
			if TagExists( factoidHeaderString ) and TagExists( factoidBodyString ) then
				headings[#headings + 1] = factoidHeaderString
				texts[#texts + 1] = factoidBodyString
			end
		end
		entry.strings.image = string.format('assets/images/%s/i_%d.png', row.IconAtlas, row.PortraitIndex)
		atlasList[row.IconAtlas] = true
		entry.strings.title = row.ShortDescription or nil
		entry.strings.heading = next(headings) and headings or nil
		entry.strings.texts = next(texts) and texts or nil
		entry.strings.leaders = next(leaders) and leaders or nil
		entry.strings.unique_units = next(unique_units) and unique_units or nil
		entry.strings.unique_buildings = next(unique_buildings) and unique_buildings or nil
		entry.strings.unique_improvements = next(unique_improvements) and unique_improvements or nil
		content[#content + 1] = entry;
	end
end
for row in GameInfo.Civilizations() do	
	if row.Type ~= "CIVILIZATION_MINOR" and row.Type ~= "CIVILIZATION_BARBARIAN" then
		for civleader in GameInfo.Civilization_Leaders("CivilizationType = '" .. row.Type .. "'") do
			local leader = GameInfo.Leaders[civleader.LeaderheadType]
			if leader then
				structure.categories[cat.civs].sections[3].items[#structure.categories[cat.civs].sections[3].items + 1] = {
					id = leader.Type,
					label = leader.Description
				}
				local entry = { strings = {} };
				entry.item_id = leader.Type
				entry.view_id = 'view_1'
				local civilizations = {}
				for row in GameInfo.Civilization_Leaders("LeaderheadType = '" .. leader.Type .. "'") do
					civilizations[#civilizations + 1] = row.CivilizationType
				end
				local headings = {}
				local texts = {}
				local tagString = leader.CivilopediaTag;
				if tagString then
					local name = tagString.."_NAME"
					entry.strings.subtitle = tagString .. "_SUBTITLE"
					entry.strings.lived = tagString.."_LIVED"
					local titlesString = tagString .. "_TITLES_"
					local notFound = false;
					local i = 1;
					local titles = "";
					local numTitles = 0;
					repeat
						local titlesTag = titlesString .. tostring( i );
						if TagExists( titlesTag ) then
							if numTitles > 0 then
								titles = titles .. "[NEWLINE][NEWLINE]"
							end
							numTitles = numTitles + 1;
							titles = titles .. '{' .. titlesTag .. '}'
						else
							notFound = true;		
						end
						i = i + 1;
					until notFound;
					if numTitles > 0 then
						entry.strings.titles = titles
					end
					local headerString = tagString .. "_HEADING_";
					local bodyString = tagString .. "_TEXT_";
					local notFound = false;
					local i = 1;
					repeat
						local headerTag = headerString .. tostring( i );
						local bodyTag = bodyString .. tostring( i );
						if TagExists( headerTag ) and TagExists( bodyTag ) then
							headings[#headings + 1] = headerTag
							texts[#texts + 1] = bodyTag
						else
							notFound = true;		
						end
						i = i + 1;
					until notFound;
					
					notFound = false;
					i = 1;
					repeat
						local bodyString = tagString .. "_FACT_";
						local bodyTag = bodyString .. tostring( i );
						if TagExists( bodyTag ) then
							headings[#headings + 1] = 'TXT_KEY_PEDIA_FACTOID'
							texts[#texts + 1] = bodyTag
						else
							notFound = true;		
						end
						i = i + 1;
					until notFound;
				end
				local traitTbl = {}
				local condition = "LeaderType = '" .. leader.Type .. "'";
				for leaderTrait in GameInfo.Leader_Traits(condition) do
					local trait = leaderTrait.TraitType;
					local traitString = '{' .. GameInfo.Traits[trait].ShortDescription .."}[NEWLINE][NEWLINE]{".. GameInfo.Traits[trait].Description .. '}';
					traitTbl[#traitTbl + 1] = traitString
				end
				entry.strings.image = string.format('assets/images/%s/i_%d.png', leader.IconAtlas, leader.PortraitIndex)
				atlasList[leader.IconAtlas] = true
				entry.strings.title = leader.Description or nil
				entry.strings.civilization = next(civilizations) and civilizations or nil
				entry.strings.heading = next(headings) and headings or nil
				entry.strings.texts = next(texts) and texts or nil
				entry.strings.game_info = next(traitTbl) and table.concat(traitTbl, '[NEWLINE][NEWLINE]') or nil
				content[#content + 1] = entry;
			end
		end
	end
end
------------------------------
-- City-States
------------------------------
local k = 1
local offset = #structure.categories[cat.citystates].sections
for trait in GameInfo.MinorCivTraits() do
	local traitID = trait.ID;
	local sectionID = k
	structure.categories[cat.citystates].sections[#structure.categories[cat.citystates].sections + 1] = {
		label = 'TXT_KEY_' .. trait.Type,
		items = {}
	}
	k = k + 1
	for cityState in GameInfo.MinorCivilizations("MinorCivTrait = '" .. trait.Type .. "'") do
		structure.categories[cat.citystates].sections[offset + sectionID].items[#structure.categories[cat.citystates].sections[offset + sectionID].items + 1] = {
			id = cityState.Type,
			label = cityState.Description
		}
		local entry = { strings = {} };
		entry.item_id = cityState.Type
		entry.view_id = 'view_1'
		entry.strings.title = cityState.Description or nil
		entry.strings.summary = cityState.Civilopedia or nil
		content[#content + 1] = entry;
	end
end
------------------------------
-- Terrain and Features
------------------------------
for thisTerrain in GameInfo.Terrains() do
	structure.categories[cat.terrains].sections[2].items[#structure.categories[cat.terrains].sections[2].items + 1] = {
		id = thisTerrain.Type,
		label = thisTerrain.Description
	}
	local entry = { strings = {} };
	entry.item_id = thisTerrain.Type
	entry.view_id = 'view_1'
	local condition = "TerrainType = '" .. thisTerrain.Type .. "'";
	local numYields = 0;
	local yieldString = "";
	for thisTerrain in GameInfo.Terrain_Yields( condition ) do
		numYields = numYields + 1;
		yieldString = yieldString..tostring(thisTerrain.Yield).." ";
		yieldString = yieldString..GameInfo.Yields[thisTerrain.YieldType].IconString.." ";
	end
	if thisTerrain.Type == "TERRAIN_HILL" then
		numYields = 1;
		yieldString = "2 [ICON_PRODUCTION]"
	end
	if numYields == 0 then
		entry.strings.yields = "TXT_KEY_PEDIA_NO_YIELD"
	else
		entry.strings.yields = yieldString
	end
	local moveCost = thisTerrain.Movement;
	-- special case hackery for hills
	if thisTerrain.Type == "TERRAIN_HILL" then
		moveCost = moveCost + GameDefines.HILLS_EXTRA_MOVEMENT;
	end
	if thisTerrain.Type == "TERRAIN_MOUNTAIN" then
		entry.strings.movement_cost = "TXT_KEY_PEDIA_IMPASSABLE"
	else
		entry.strings.movement_cost = tostring( moveCost ).." [ICON_MOVES]"
	end
	local combatModifier = 0;
	local combatModString = "";
	if thisTerrain.Type == "TERRAIN_HILL" or thisTerrain.Type == "TERRAIN_MOUNTAIN" then
		combatModifier = GameDefines.HILLS_EXTRA_DEFENSE;
	elseif thisTerrain.Water then
		combatModifier = 0;
	else
		combatModifier = GameDefines.FLAT_LAND_EXTRA_DEFENSE;
	end
	if combatModifier > 0 then
		combatModString = "+";
	end
	combatModString = combatModString..tostring(combatModifier).."%";
	entry.strings.combat_modifier = combatModString
	local features = {}
	for row in GameInfo.Feature_TerrainBooleans( condition ) do
		local thisFeature = GameInfo.Features[row.FeatureType];
		if thisFeature then
			features[#features + 1] = thisFeature.Type
		end
	end
	local resources = {}
	for row in GameInfo.Resource_TerrainBooleans( condition ) do
		local thisResource = GameInfo.Resources[row.ResourceType];
		if thisResource then
			resources[#resources + 1] = thisResource.Type
		end
	end
	-- special case hackery for hills
	if thisTerrain.Type == "TERRAIN_HILL" then
		for thisResource in GameInfo.Resources() do
			if thisResource and thisResource.Hills then
				resources[#resources + 1] = thisResource.Type
			end
		end
	end
	entry.strings.image = string.format('assets/images/%s/i_%d.png', thisTerrain.IconAtlas, thisTerrain.PortraitIndex)
	atlasList[thisTerrain.IconAtlas] = true
	entry.strings.title = thisTerrain.Description or nil
	entry.strings.game_info = thisTerrain.Civilopedia or nil
	entry.strings.resources_found_on = next(resources) and resources or nil
	entry.strings.features_on = next(features) and features or nil
	content[#content + 1] = entry;
end
for thisFeature in GameInfo.Features() do
	structure.categories[cat.terrains].sections[3].items[#structure.categories[cat.terrains].sections[3].items + 1] = {
		id = thisFeature.Type,
		label = thisFeature.Description
	}
	local entry = { strings = {} };
	entry.item_id = thisFeature.Type
	entry.view_id = 'view_1'
	local condition = "FeatureType = '" .. thisFeature.Type .. "'";
	local numYields = 0;
	local yieldString = "";
	for row in GameInfo.Feature_YieldChanges( condition ) do
		numYields = numYields + 1;
		yieldString = yieldString..tostring(row.Yield).." ";
		yieldString = yieldString..GameInfo.Yields[row.YieldType].IconString.." ";
	end				
	-- add happiness since it is a quasi-yield
	if thisFeature.InBorderHappiness and thisFeature.InBorderHappiness ~= 0 then
		numYields = numYields + 1;
		yieldString = yieldString.." ";
		yieldString = yieldString..tostring(thisFeature.InBorderHappiness).."[ICON_HAPPINESS_1] ";
	end
	if numYields == 0 then
		entry.strings.yields = "TXT_KEY_PEDIA_NO_YIELD"
	else
		entry.strings.yields = yieldString
	end
	local moveCost = thisFeature.Movement;
	if thisFeature.Impassable then
		entry.strings.movement_cost = "TXT_KEY_PEDIA_IMPASSABLE"
	else
		entry.strings.movement_cost = tostring( moveCost ).."[ICON_MOVES]"
	end
	local combatModifier = thisFeature.Defense;
	local combatModString = "";
	if combatModifier > 0 then
		combatModString = "+";
	end
	combatModString = combatModString..tostring(combatModifier).."%";
	entry.strings.combat_modifier = combatModString
	local terrains = {}
	for row in GameInfo.Feature_TerrainBooleans( condition ) do
		local thisTerrain = GameInfo.Features[row.TerrainType];
		if thisTerrain then
			terrains[#terrains + 1] = thisTerrain.Type
		end
	end
	local resources = {}
	for row in GameInfo.Resource_FeatureBooleans( condition ) do
		local thisResource = GameInfo.Resources[row.ResourceType];
		if thisResource then
			resources[#resources + 1] = thisResource.Type
		end
	end
	entry.strings.image = string.format('assets/images/%s/i_%d.png', thisFeature.IconAtlas, thisFeature.PortraitIndex)
	atlasList[thisFeature.IconAtlas] = true
	entry.strings.title = thisFeature.Description or nil
	entry.strings.historical_info = thisFeature.Civilopedia or nil
	entry.strings.game_info = thisFeature.Help or nil
	entry.strings.terrains_found_on = next(terrains) and terrains or nil
	entry.strings.resources_found_on = next(resources) and resources or nil
	content[#content + 1] = entry;
end
-- now for the fake features (river and lake)
for thisFeature in GameInfo.FakeFeatures() do
	structure.categories[cat.terrains].sections[3].items[#structure.categories[cat.terrains].sections[3].items + 1] = {
		id = thisFeature.Type,
		label = thisFeature.Description
	}
	local entry = { strings = {} };
	entry.item_id = thisFeature.Type
	entry.view_id = 'view_1'
	local condition = "FeatureType = '" .. thisFeature.Type .. "'";
	local numYields = 0;
	local yieldString = "";
	for row in GameInfo.Feature_YieldChanges( condition ) do
		numYields = numYields + 1;
		yieldString = yieldString..tostring(row.Yield).." ";
		yieldString = yieldString..GameInfo.Yields[row.YieldType].IconString.." ";
	end
	if numYields == 0 then
		entry.strings.yields = "TXT_KEY_PEDIA_NO_YIELD"
	else
		entry.strings.yields = yieldString
	end
	local moveCost = thisFeature.Movement;
	if thisFeature.Impassable then
		entry.strings.movement_cost = "TXT_KEY_PEDIA_IMPASSABLE"
	else
		entry.strings.movement_cost = '{'..tostring( moveCost ).."}[ICON_MOVES]"
	end
	local combatModifier = thisFeature.Defense;
	local combatModString = "";
	if combatModifier > 0 then
		combatModString = "+";
	end
	combatModString = combatModString..tostring(combatModifier).."%";
	entry.strings.combat_modifier = combatModString
	local terrains = {}
	for row in GameInfo.Feature_TerrainBooleans( condition ) do
		local thisTerrain = GameInfo.Features[row.TerrainType];
		if thisTerrain then
			terrains[#terrains + 1] = thisTerrain.Type
		end
	end
	local resources = {}
	for row in GameInfo.Resource_FeatureBooleans( condition ) do
		local thisResource = GameInfo.Resources[row.ResourceType];
		if thisResource then
			resources[#resources + 1] = thisResource.Type
		end
	end
	entry.strings.image = string.format('assets/images/%s/i_%d.png', thisFeature.IconAtlas, thisFeature.PortraitIndex)
	atlasList[thisFeature.IconAtlas] = true
	entry.strings.title = thisFeature.Description or nil
	entry.strings.game_info = thisFeature.Civilopedia or nil
	entry.strings.terrains_found_on = next(terrains) and terrains or nil
	entry.strings.resources_found_on = next(resources) and resources or nil
	content[#content + 1] = entry;
end
------------------------------
-- Resources
------------------------------
-- for each type of resource
local k = 1
for resourceType = 0, 2, 1 do
	local sectionID = k + 1
	k = k + 1
	-- for each type of resource
	for thisResource in GameInfo.Resources( "ResourceUsage = '" .. resourceType .. "'" ) do
		structure.categories[cat.resources].sections[sectionID].items[#structure.categories[cat.resources].sections[sectionID].items + 1] = {
			id = thisResource.Type,
			label = thisResource.Description
		}
		local entry = { strings = {} };
		entry.item_id = thisResource.Type
		entry.view_id = 'view_1'
		local condition = "ResourceType = '" .. thisResource.Type .. "'";
		local tech_prereq = {}
		if thisResource.TechReveal then
			local prereq = GameInfo.Technologies[thisResource.TechReveal];
			if prereq then
				tech_prereq[#tech_prereq + 1] = prereq.Type
			end
		end
		local numYields = 0;
		local yieldString = "";
		for row in GameInfo.Resource_YieldChanges( condition ) do
			numYields = numYields + 1;
			if row.Yield > 0 then
				yieldString = yieldString.."+";
			end
			yieldString = yieldString..tostring(row.Yield)..GameInfo.Yields[row.YieldType].IconString.." ";
		end
		if numYields == 0 then
			entry.strings.yields = "TXT_KEY_PEDIA_NO_YIELD"
		else
			entry.strings.yields = yieldString
		end
		local terrains = {}
		for row in GameInfo.Resource_FeatureBooleans( condition ) do
			local thisFeature = GameInfo.Features[row.FeatureType];
			if thisFeature then
				terrains[#terrains + 1] = thisFeature.Type
			end
		end
		local bAlreadyShowingHills = false;
		for row in GameInfo.Resource_TerrainBooleans( condition ) do
			local thisTerrain = GameInfo.Terrains[row.TerrainType];
			if thisTerrain then
				if(row.TerrainType == "TERRAIN_HILL") then
					bAlreadyShowingHills = true;
				end
				terrains[#terrains + 1] = thisTerrain.Type
			end
		end
		-- hackery for hills
		if thisResource and thisResource.Hills and not bAlreadyShowingHills then
			local thisTerrain = GameInfo.Terrains["TERRAIN_HILL"];
			terrains[#terrains + 1] = thisTerrain.Type
		end
		local improvements = {}
		for row in GameInfo.Improvement_ResourceTypes( condition ) do
			local thisImprovement = GameInfo.Improvements[row.ImprovementType];
			if thisImprovement then
				improvements[#improvements + 1] = thisImprovement.Type
			end
		end
		entry.strings.image = string.format('assets/images/%s/i_%d.png', thisResource.IconAtlas, thisResource.PortraitIndex)
		atlasList[thisResource.IconAtlas] = true
		entry.strings.title = thisResource.Description or nil
		entry.strings.game_info = thisResource.Help or nil
		entry.strings.historical_info = thisResource.Civilopedia or nil
		entry.strings.revealed_by = next(tech_prereq) and tech_prereq or nil
		entry.strings.improved_by = next(improvements) and improvements or nil
		entry.strings.terrains_found_on = next(terrains) and terrains or nil
		content[#content + 1] = entry;
	end
end
------------------------------
-- Improvements
------------------------------
-- for each improvement
for thisImprovement in GameInfo.Improvements() do	
	if not thisImprovement.GraphicalOnly then
		structure.categories[cat.improvements].sections[1].items[#structure.categories[cat.improvements].sections[1].items + 1] = {
			id = thisImprovement.Type,
			label = thisImprovement.Description
		}
		local entry = { strings = {} };
		entry.item_id = thisImprovement.Type
		entry.view_id = 'view_1'
	 	local condition = "ImprovementType = '" .. thisImprovement.Type .. "'";
	 	local tech_prereq = {}
	 	local prereq;
	 	for row in GameInfo.Builds( condition ) do
	 		if row.PrereqTech then
	 			prereq = GameInfo.Technologies[row.PrereqTech];
	 		end
	 	end
	 	if prereq then
	 		tech_prereq[#tech_prereq + 1] = prereq.Type
	 	end
	 	local numYields = 0;
	 	local yieldString = "";
	 	for row in GameInfo.Improvement_Yields( condition ) do
	 		numYields = numYields + 1;
	 		if row.Yield > 0 then
	 			yieldString = yieldString.."+";
	 		end
	 		yieldString = yieldString..tostring(row.Yield)..GameInfo.Yields[row.YieldType].IconString.." ";
	 	end
	 	if numYields == 0 then
	 		entry.strings.yields = "TXT_KEY_PEDIA_NO_YIELD"
	 	else
	 		entry.strings.yields = yieldString
	 	end
	 	-- add in mountain adjacency yield
	 	numYields = 0;
	 	yieldString = "";
	 	for row in GameInfo.Improvement_AdjacentMountainYieldChanges( condition ) do
	 		numYields = numYields + 1;
	 		if row.Yield > 0 then
	 			yieldString = yieldString.."+";
	 		end
	 		yieldString = yieldString..tostring(row.Yield)..GameInfo.Yields[row.YieldType].IconString.." ";
	 	end
	 	if numYields ~= 0 then
	 		entry.strings.nearby_mountain_bonus = yieldString
	 	end
	 	local civilizations = {}
	 	if thisImprovement.CivilizationType then
	 		local thisCiv = GameInfo.Civilizations[thisImprovement.CivilizationType];
	 		if thisCiv then
	 			civilizations[#civilizations + 1] = thisCiv.Type
	 		end
	 	end
	 	local terrains = {}
	 	for row in GameInfo.Improvement_ValidFeatures( condition ) do
	 		local thisFeature = GameInfo.Features[row.FeatureType];
	 		if thisFeature then
	 			terrains[#terrains + 1] = thisFeature.Type
	 		end
	 	end
	 	for row in GameInfo.Improvement_ValidTerrains( condition ) do
	 		local thisTerrain = GameInfo.Terrains[row.TerrainType];
	 		if thisTerrain then
	 			terrains[#terrains + 1] = thisTerrain.Type
	 		end
	 	end
	 	local resources = {}
	 	for row in GameInfo.Improvement_ResourceTypes( condition ) do
	 		local requiredResource = GameInfo.Resources[row.ResourceType];
	 		if requiredResource then
	 			resources[#resources + 1] = requiredResource.Type
	 		end		
	 	end
		entry.strings.image = string.format('assets/images/%s/i_%d.png', thisImprovement.IconAtlas, thisImprovement.PortraitIndex)
		atlasList[thisImprovement.IconAtlas] = true
		entry.strings.title = thisImprovement.Description or nil
		entry.strings.game_info = thisImprovement.Civilopedia or nil
		entry.strings.can_be_built_on = next(terrains) and terrains or nil
		entry.strings.improves_resources = next(resources) and resources or nil
		entry.strings.prerequisite_techs = next(tech_prereq) and tech_prereq or nil
		entry.strings.civilization = next(civilizations) and civilizations or nil
		content[#content + 1] = entry;
	end
end
--add railroads and roads
for thisImprovement in GameInfo.Routes() do
	structure.categories[cat.improvements].sections[1].items[#structure.categories[cat.improvements].sections[1].items + 1] = {
		id = thisImprovement.Type,
		label = thisImprovement.Description
	}
	local entry = { strings = {} };
	entry.item_id = thisImprovement.Type
	entry.view_id = 'view_1'
	local condition = "RouteType = '" .. thisImprovement.Type .. "'";
	local tech_prereq = {}
	local prereq;
	for row in GameInfo.Builds( condition ) do
		if row.PrereqTech then
			prereq = GameInfo.Technologies[row.PrereqTech];
		end
	end
	if prereq then
		tech_prereq[#tech_prereq + 1] = prereq.Type
	end
	entry.strings.image = string.format('assets/images/%s/i_%d.png', thisImprovement.IconAtlas, thisImprovement.PortraitIndex)
	atlasList[thisImprovement.IconAtlas] = true
	entry.strings.title = thisImprovement.Description or nil
	entry.strings.game_info = thisImprovement.Civilopedia or nil
	entry.strings.prerequisite_techs = next(tech_prereq) and tech_prereq or nil
	content[#content + 1] = entry;
end
------------------------------
-- Religion and Beliefs
------------------------------
for religion in GameInfo.Religions("Type <> 'RELIGION_PANTHEON'") do
	structure.categories[cat.religion].sections[2].items[#structure.categories[cat.religion].sections[2].items + 1] = {
		id = religion.Type,
		label = religion.Description
	}
	local entry = { strings = {} };
	entry.item_id = religion.Type
	entry.view_id = 'view_1'
	entry.strings.title = religion.Description or nil
	entry.strings.summary = religion.Civilopedia or nil
	content[#content + 1] = entry;
end
-- for each type of resource
local sectionConditions = {
	"Pantheon = 1",
	"Founder = 1",
	"Follower = 1",
	"Enhancer = 1",
	"Reformation = 1"
};
for i,condition in ipairs(sectionConditions) do
	for belief in GameInfo.Beliefs(condition) do
		structure.categories[cat.religion].sections[i + 2].items[#structure.categories[cat.religion].sections[i + 2].items + 1] = {
			id = belief.Type,
			label = belief.ShortDescription
		}
		local entry = { strings = {} };
		entry.item_id = belief.Type
		entry.view_id = 'view_1'
		entry.strings.title = belief.ShortDescription or nil
		entry.strings.summary = belief.Description or nil
		content[#content + 1] = entry;
	end
end
------------------------------
-- World Congress
------------------------------
for resolution in GameInfo.Resolutions() do
	structure.categories[cat.congress].sections[2].items[#structure.categories[cat.congress].sections[2].items + 1] = {
		id = resolution.Type,
		label = resolution.Description
	}
	local entry = { strings = {} };
	entry.item_id = resolution.Type
	entry.view_id = 'view_1'
	entry.strings.image = 'assets/images/worldcongressportrait.png'
	entry.strings.title = resolution.Description or nil
	entry.strings.summary = resolution.Help or nil
	content[#content + 1] = entry;
end
for leagueProject in GameInfo.LeagueProjects() do
	structure.categories[cat.congress].sections[3].items[#structure.categories[cat.congress].sections[3].items + 1] = {
		id = leagueProject.Type,
		label = leagueProject.Description
	}
	local entry = { strings = {} };
	entry.item_id = leagueProject.Type
	entry.view_id = 'view_1'
	local s = "";
	local TrophyIcons = {
		"[ICON_TROPHY_BRONZE]",
		"[ICON_TROPHY_SILVER]",
		"[ICON_TROPHY_GOLD]",
	};
	for i = 3, 1, -1 do
		local reward = leagueProject["RewardTier" .. i];
		if (reward ~= nil) then
			local tReward = GameInfo.LeagueProjectRewards[reward];
			if (tReward ~= nil) then
				if (tReward.Description ~= nil and tReward.Help ~= nil) then
					s = s .. string.format('%s {%s}: {%s}', TrophyIcons[i], tReward.Description, tReward.Help);
				end
			end
		end
		if (i > 1) then
			s = s .. "[NEWLINE][NEWLINE]";
		end
	end
	entry.strings.image = string.format('assets/images/%s/i_%d.png', leagueProject.IconAtlas, leagueProject.PortraitIndex)
	atlasList[leagueProject.IconAtlas] = true
	entry.strings.title = leagueProject.Description or nil
	entry.strings.summary = s or nil
	content[#content + 1] = entry;
end

------------------------------
-- extras
------------------------------
for row in GameInfo.Builds() do
	local entry = { strings = {} };
	entry.item_id = row.Type
	entry.view_id = 'view_1'
	entry.strings.image = string.format('assets/images/%s/i_%d.png', row.IconAtlas, row.IconIndex)
	atlasList[row.IconAtlas] = true
	entry.strings.title = row.Description or nil
	if row.RouteType then
		entry.strings.shortcut = GameInfo.Routes[row.RouteType].Type
	elseif row.ImprovementType then
		entry.strings.shortcut = GameInfo.Improvements[row.ImprovementType].Type
	else -- we are a choppy thing
		entry.strings.shortcut = 'CONCEPT_WORKERS_CLEARINGLAND'
	end
	content[#content + 1] = entry;
end
for row in GameInfo.GreatWorkSlots() do
	local entry = { strings = {} };
	entry.item_id = row.Type
	entry.view_id = 'view_1'
	entry.strings.image = 'assets/images/' .. Locale.ToLower(row.EmptyIcon:sub(0, -5)):gsub(' ','_') .. '.png'
	entry.strings.title = row.EmptyToolTipText or nil
	entry.strings.shortcut = 'CONCEPT_CULTURE_GREAT_WORKS'
	content[#content + 1] = entry;
end


------------------------------
------------------------------

local catid = 1
local secid = 1
for i, cat in next, structure.categories do
	structure.categories[i].id = 'cat_' .. tostring(catid)
	for j, sec in next, structure.categories[i].sections do
		structure.categories[i].sections[j].id = 'sec_' .. tostring(secid)
		secid = secid + 1
	end
	catid = catid + 1
end



file = io.open(PATH .. 'assets\\data\\content.json', 'w')
file:write(json.stringify(content))
file:close()
file = io.open(PATH .. 'assets\\data\\structure.json', 'w')
file:write(json.stringify(structure))
file:close()
for row in DB.Query('SELECT * FROM Localization.Language_en_US') do
	translations_en[row.Tag] = row.Text
end
file = io.open(PATH .. 'assets\\data\\translations_en.json', 'w')
file:write(json.stringify(translations_en))
file:close()
for row in DB.Query('SELECT * FROM Localization.Language_RU_RU') do
	translations_ru[row.Tag] = row.Text
end
file = io.open(PATH .. 'assets\\data\\translations_ru.json', 'w')
file:write(json.stringify(translations_ru))
file:close()
-- print sorted list of icon atlases
local keys = {}
for key in pairs(atlasList) do
	keys[#keys + 1] = key
end
table.sort(keys)
file = io.open(PATH .. 'atlas_list.txt', 'w')
for i, key in ipairs(keys) do
	file:write(key, '\n')
end
file:close()
print('Civilopedia export END')
