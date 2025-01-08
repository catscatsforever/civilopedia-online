var current_language = "en"
var translations = {}
var data_mappings = {}
var current_category = "cat_1"
var current_section = "sec_1"
var current_item = "item_37"
var content_mapping = []
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
    current_language = (sessionStorage.getItem("locale") || "en");
    for (const lang of ['en', 'ru']) {
        await fetch("./assets/data/translations_" + lang + ".json")
            .then(response => response.json())
            .then(data => {
                translations[lang] = data;
            })
            .catch(error => console.error(`Error loading ${language} translation file:`, error));
    }
    await fetch("./assets/data/structure.json")
        .then(response => response.json())
        .then(data => {
            data_mappings = data;
        })
        .catch(error => console.error(`Error loading ${language} structure file:`, error));
    await fetch("./assets/data/content.json")
        .then(response => response.json())
        .then(data => {
            content_mapping = data;
        })
        .catch(error => console.error(`Error loading ${language} content file:`, error));
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => bootstrap.Tooltip.getOrCreateInstance(tooltipTriggerEl, {title: get_translation(current_language, tooltipTriggerEl.getAttribute("data-bs-title")), trigger: 'hover'}))

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
            sessionStorage.setItem("locale", current_language);
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


function generate_view() {
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
    current_section = current_category["sections"].find(item => item.id === $(this).parent().attr("value"));
    current_item = current_section["items"].find(item => item.id === $(this).attr("value"));
    if (CATEGORIES.includes(current_item["id"])) {
        check_home_pages()
    }
    generate_view()
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

function switch_category() {
    switch (current_category["id"]) {
        case "cat_1":
            document.querySelector('#home-tab').click();
            break;
        case "cat_2":
            document.querySelector('#concepts-tab').click();
            break;
        case "cat_3":
            document.querySelector('#tech-tab').click();
            break;
        case "cat_4":
            document.querySelector('#units-tab').click();
            break;
        case "cat_5":
            document.querySelector('#promos-tab').click();
            break;
        case "cat_6":
            document.querySelector('#buildings-tab').click();
            break;
        case "cat_7":
            document.querySelector('#wonders-tab').click();
            break;
        case "cat_8":
            document.querySelector('#social-tab').click();
            break;
        case "cat_9":
            document.querySelector('#great-tab').click();
            break;
        case "cat_10":
            document.querySelector('#civs-tab').click();
            break;
        case "cat_11":
            document.querySelector('#cities-tab').click();
            break;
        case "cat_12":
            document.querySelector('#terrain-tab').click();
            break;
        case "cat_13":
            document.querySelector('#resources-tab').click();
            break;
        case "cat_14":
            document.querySelector('#improvements-tab').click();
            break;
        case "cat_15":
            document.querySelector('#religion-tab').click();
            break;
        case "cat_16":
            document.querySelector('#congress-tab').click();
            break;
    }
}

function check_home_pages() {
    let category_index = CATEGORIES.indexOf(current_item["id"])
    current_category = data_mappings["categories"][category_index]
    current_section = current_category["sections"][0]
    current_item = current_section["items"][0]
    switch_category()
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
    item_info = content_mapping.find(element => element.item_id === item_id);
    return item_info
}

function search_article(item_id) {
    for (let cat of data_mappings.categories) {
        for (let sec of cat.sections) {
            for (let item of sec.items) {
                if (item.id === item_id) {
                    current_category = cat
                    switch_category()
                    current_section = sec
                    current_item = item
                    set_heading()
                    generate_accordion_list()
                    generate_view()
                    return true
                }
            }
        }
    }
    console.log('search failure', item_id)
    return false
}
