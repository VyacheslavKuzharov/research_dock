# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

I18n.locale = :ru

#------ Generate Regions ------#
regions = %w(Ростовская\ область Краснодарский\ край)
regions.each { |region| Region.create(name: region)}


#------ Generate Cities ------#

rostov_region = Region.find_by_name I18n.t('regions.rostov_region')
krasnodar_region = Region.find_by_name I18n.t('regions.krasnodar_region')

cities = [
    { name: 'Таганрог', region_id: rostov_region.id},
    { name: 'Ростов', region_id: rostov_region.id},
    { name: 'Краснодар', region_id: krasnodar_region.id}
]

cities.each { |city| City.create(city) }

#------ Generate Sites ------#

sites = [
    { name: 'mytaganrog.com', url: 'http://mytaganrog.com/' },
    { name: 'rostovlife.ru', url: 'http://rostovlife.ru/' }
]

sites.each { |site| Site.create site }