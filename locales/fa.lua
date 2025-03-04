-- As I Said in README.md  - 
-- There will be a translation file for other languages,
-- but for now, the language in use is Persian inside the Client/main.lua.
local Translations = {
    error = {
        already_driving_bus = 'Shoma dar hale ranandegi otobus hastid',
        not_in_bus = 'Shoma dar yek otobus nistid',
        one_bus_active = 'Shoma faghat mitavanid yek otobus faal dashte bashid',
        drop_off_passengers = 'Mosaferan ra piade konid ghabl az anke kar ra motevaghef konid',
        exploit = 'Talash baraye sooe estefade'
    },
    success = {
        dropped_off = 'Shakhs piade shod',
    },
    info = {
        bus = 'Otobus mamooli',
        goto_busstop = 'Be mahale otobus beravid',
        busstop_text = '[E] Mahale otobus',
        bus_plate = 'OTOBUS',
        bus_depot = 'Tavaghofgah otobus',
        bus_stop_work = '[E] Kar ra motevaghef kon',
        bus_job_vehicles = '[E] Vasayel naghlie kar'
    },
    menu = {
        bus_header = 'Otobus ha',
        bus_close = '⬅ Bastan menu'
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})