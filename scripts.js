var current_language = "en"
var translations = {}
var data_mappings = {}
var current_category = "cat_1"
var current_section = "sec_1"
var current_item = "item_37"
var content_mapping = []
let listOfTopicsViewed = []
let currentTopic = -1
let CATEGORIES = [
    "PEDIA_HOME_PAGE",
    "PEDIA_CONCEPTS_PAGE",
    "PEDIA_TECHS_PAGE",
    "PEDIA_UNITS_PAGE",
    "PEDIA_PROMOTIONS_PAGE",
    "PEDIA_BUILDINGS_PAGE",
    "PEDIA_WONDERS_PAGE",
    "PEDIA_POLICIES_PAGE",
    "PEDIA_PEOPLE_PAGE",
    "PEDIA_CIVS_PAGE",
    "PEDIA_CITYSTATES_PAGE",
    "PEDIA_TERRAINS_PAGE",
    "PEDIA_RESOURCES_PAGE",
    "PEDIA_IMPROVEMENTS_PAGE",
    "PEDIA_RELIGION_PAGE",
    "PEDIA_CONGRESS_PAGE"
]

var tag_mappings = {
    "NEWLINE": "<br>",
    "TAB": "&nbsp;",
    "ICON_HAPPINESS_1": "<img class='icon align-top' src='./assets/images/icon_images/ICON_HAPPINESS_1.png'>",
    "ICON_HAPPINESS_4": "<img class='icon align-top' src='./assets/images/icon_images/ICON_HAPPINESS_4.png'>",
    "ICON_CULTURE": "<img class='icon align-top' src='./assets/images/icon_images/ICON_CULTURE.png'>",
    "ICON_INTERNATIONAL_TRADE": "<img class='icon align-top' src='./assets/images/icon_images/ICON_INTERNATIONAL_TRADE.png'>",
    "ICON_GOLD": "<img class='icon align-top' src='./assets/images/icon_images/ICON_GOLD.png'>",
    "COLOR_POSITIVE_TEXT": "<span style='color:#7FFF19'>",
    "COLOR_CYAN": "<span style='color:#00E2E2'>",
    "ENDCOLOR": "</span>",
    "ICON_TOURISM": "<img class='icon align-top' src='./assets/images/icon_images/ICON_TOURISM.png'>",
    "ICON_PEACE": "<img class='icon align-top' src='./assets/images/icon_images/ICON_PEACE.png'>",
    "ICON_FOOD": "<img class='icon align-top' src='./assets/images/icon_images/ICON_FOOD.png'>",
    "ICON_PRODUCTION": "<img class='icon align-top' src='./assets/images/icon_images/ICON_PRODUCTION.png'>",
    "ICON_RESEARCH": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RESEARCH.png'>",
    "ICON_RANGE_STRENGTH": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RANGE_STRENGTH.png'>",
    "ICON_CONNECTED": "<img class='icon align-top' src='./assets/images/icon_images/ICON_CONNECTED.png'>",
    "ICON_INFLUENCE": "<img class='icon align-top' src='./assets/images/icon_images/ICON_INFLUENCE.png'>",
    "ICON_RES_WINE": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_WINE.png'>",
    "ICON_RES_INCENSE": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_INCENSE.png'>",
    "ICON_STRENGTH": "<img class='icon align-top' src='./assets/images/icon_images/ICON_STRENGTH.png'>",
    "ICON_GREAT_PEOPLE": "<img class='icon align-top' src='./assets/images/icon_images/ICON_GREAT_PEOPLE.png'>",
    "ICON_SPY": "<img class='icon align-top' src='./assets/images/icon_images/ICON_SPY.png'>",
    "ICON_RELIGION": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RELIGION.png'>",
    "ICON_TROPHY_GOLD": "<img class='icon align-top' src='./assets/images/icon_images/ICON_TROPHY_GOLD.png'>",
    "ICON_TROPHY_SILVER": "<img class='icon align-top' src='./assets/images/icon_images/ICON_TROPHY_SILVER.png'>",
    "ICON_TROPHY_BRONZE": "<img class='icon align-top' src='./assets/images/icon_images/ICON_TROPHY_BRONZE.png'>",
    "ICON_CAPITAL": "<img class='icon align-top' src='./assets/images/icon_images/ICON_CAPITAL.png'>",
    "ICON_GOLDEN_AGE": "<img class='icon align-top' src='./assets/images/icon_images/ICON_GOLDEN_AGE.png'>",
    "ICON_CITIZEN": "<img class='icon align-top' src='./assets/images/icon_images/ICON_CITIZEN.png'>",
    "ICON_MOVES": "<img class='icon align-top' src='./assets/images/icon_images/ICON_MOVES.png'>",
    "ICON_DIPLOMAT": "<img class='icon align-top' src='./assets/images/icon_images/ICON_DIPLOMAT.png'>",
    "ICON_RES_URANIUM": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_URANIUM.png'>",
    "ICON_RES_ALUMINUM": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_ALUMINUM.png'>",
    "ICON_RES_COW": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_COW.png'>",
    "ICON_RES_SHEEP": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_SHEEP.png'>",
    "ICON_RES_HORSE": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_HORSE.png'>",
    "ICON_RES_IRON": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_IRON.png'>",
    "ICON_RES_MARBLE": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_MARBLE.png'>",
    "ICON_RES_FISH": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_FISH.png'>",
    "ICON_RES_PEARLS": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_PEARLS.png'>",
    "ICON_RES_DEER": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_DEER.png'>",
    "ICON_RES_IVORY": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_IVORY.png'>",
    "ICON_RES_FUR": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_FUR.png'>",
    "ICON_RES_TRUFFLES": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_TRUFFLES.png'>",
    "ICON_OCCUPIED": "<img class='icon align-top' src='./assets/images/icon_images/ICON_OCCUPIED.png'>",
    "ICON_RES_STONE": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_STONE.png'>",
    "ICON_RES_OIL": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_OIL.png'>",
    "ICON_RES_GOLD": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_GOLD.png'>",
    "ICON_RES_SILVER": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_SILVER.png'>",
    "ICON_RES_COAL": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_COAL.png'>",
    "ICON_RES_WHEAT": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_WHEAT.png'>",
    "ICON_RES_BANANA": "<img class='icon align-top' src='./assets/images/icon_images/ICON_RES_BANANA.png'>"
}


document.addEventListener("DOMContentLoaded", async function () {
    $("body").hide()
    current_language = (localStorage.getItem("locale") || "en");
    for (const lang of ['en', 'ru']) {
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
    await fetch("./assets/data/content.json")
        .then(response => response.json())
        .then(data => {
            content_mapping = data;
        })
        .catch(error => console.error(`Error loading content.json`, error));
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => bootstrap.Tooltip.getOrCreateInstance(tooltipTriggerEl, {title: get_translation(current_language, tooltipTriggerEl.getAttribute("data-bs-title")), trigger: 'hover'}))

    content_mapping.push(...Object.entries(patchNotes.ru).map(([k, v]) => {return {item_id: `PATCH${k}`, view_id: 'view_4', strings: {title: `TXT_KEY_PATCH_${k}_TITLE`, text: `TXT_KEY_PATCH_${k}_SUMMARY`}}}))
    data_mappings.categories[0].sections.push({label: 'TXT_KEY_PATCH_NOTES', items: [...Object.entries(patchNotes.ru).map(([k, v]) => {return {id: `PATCH${k}`, label: `TXT_KEY_PATCH_${k}_TITLE`}})].sort((a, b) => -a.label.localeCompare(b.label, undefined, {numeric: true}))})
    translations['en'] = {...translations['en'], ...patchTxtTags.en, ...Object.entries(patchNotes.en).reduce((acc, [k, v]) => {return {...acc, [`TXT_KEY_PATCH_${k}_TITLE`]: `Version ${k}`, [`TXT_KEY_PATCH_${k}_SUMMARY`]: '<ul>' + addMarkup(v) + '</ul>'}}, {})}
    translations['ru'] = {...translations['ru'], ...patchTxtTags.ru, ...Object.entries(patchNotes.ru).reduce((acc, [k, v]) => {return {...acc, [`TXT_KEY_PATCH_${k}_TITLE`]: `Версия ${k}`, [`TXT_KEY_PATCH_${k}_SUMMARY`]: '<ul>' + addMarkup(v) + '</ul>'}}, {})}
    if (!search_article(location.hash.substring(1))) {
        current_category = data_mappings["categories"][0]
        current_section = current_category["sections"][0]
        current_item = current_section["items"][0]
        generate_view()
        set_heading()
        generate_accordion_list()
    }
    create_listeners()
    $( "#pedia-search" ).autocomplete({
        source: content_mapping.map((item) => {return {label: get_translation(current_language, item.strings.title), id: item.item_id}}),
        select: (e, ui) => {search_article(get_info_from_item_id(ui.item.id)?.strings.shortcut ?? ui.item.id)}
    });
    $("body").show()
});

function get_translation(language, key, gcase = 0) {
    if (key in translations[language]) {
        return parse_tags(translations[language][key].split('|')[gcase])
    }
    else {
        return parse_tags(key)
    }

}

function addMarkup(text) {
    return text
        .replaceAll(/^( *)[-|*] (.+)$/gm, (m, c1, c2) => `${'<ul>'.repeat(c1.length / 2)}<li>\n${c2}</li>${'</ul>'.repeat(c1.length / 2)}`)  // bullet list item -/* with indent
        .replaceAll(/^( *)(#{1,3}) (.+)$/gm, (m, c1, c2, c3) => `<h${c2.length}>\n${c3}</h${c2.length}>`)  // headers # ## ###
        .replaceAll(/^( *)-# (.+)$/gm, (m, c1, c2) => `<sub>\n${c2}</sub>`)  // subtext -#
}

function parse_tags(text) {
    if (!text) return;
    text = text.toString()
    var matches = text.match(/{([^}]*)}/g);
    for (let match in matches) {
        let gcase = 0
        let s  = matches[match].replaceAll(/\[([0-9])\]}$/g, (m) => {gcase = parseInt(m[1]) - 1; return '}'})
        //console.log(matches[match], s, gcase)
        text = text.replace(matches[match], s.startsWith('{TXT_KEY_') ? get_translation(current_language, s.replace("{", "").replace("}", ""), gcase) : '')
    }
    return text.replace(/\[([^\]]+)\]/g, (_, a) => tag_mappings[a] ? `${tag_mappings[a]}` : ``)
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

Handlebars.registerHelper('translate', function (aString) {
    return get_translation(current_language, aString)
})

Handlebars.registerHelper('get_item_name', function (item_id) {
    item_name = get_info_from_item_id(item_id)["strings"]["title"]
    return item_name
})
Handlebars.registerHelper('get_item_image', function (item_id) {
    return get_info_from_item_id(item_id)["strings"]["image"]
})

Handlebars.registerHelper('parse_tags', function (aString) {
    return parse_tags(aString)
})


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

    history.pushState({}, "", `#${current_item.id}`)
    if (!ignoreTopicList && current_item.id !== listOfTopicsViewed[listOfTopicsViewed.length - 1]?.id) {
        currentTopic++
        listOfTopicsViewed = listOfTopicsViewed.slice(0, currentTopic)
        listOfTopicsViewed.push(current_item)
    }
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
        search_article(value)
        $(this).tooltip('dispose')
    }
})

$(document).on("click", '#backbutton', () => {
    if (currentTopic > 0) {
        currentTopic--
        search_article(listOfTopicsViewed[currentTopic].id, true)
    }
})

$(document).on("click", '#forwardbutton', () => {
    if (currentTopic < listOfTopicsViewed.length - 1) {
        currentTopic++
        search_article(listOfTopicsViewed[currentTopic].id, true)
    }
})

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
                accordion_section += `<li value=${item.id} class="list-group-item">${get_translation(current_language, item.label)}</li>`
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
                accordion_section += `<li value=${item.id} class="list-group-item">${get_translation(current_language, item.label)}</li>`
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
                    current_category = cat
                    switch_category()
                    current_section = sec
                    current_item = item
                    generate_accordion_list()
                    generate_view(ignoreTopicList)
                    return true
                }
            }
        }
    }
    console.log('search failure', item_id)
    return false
}
