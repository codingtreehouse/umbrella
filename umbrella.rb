require "open-uri"
require "json"




p "Where are you located?"

user_location = "Chicago" #gets.chomp

p user_location

google_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{ENV.fetch("PIRATE_WEATHER_KEY")}"

g_loc = URI.open(google_url).read

g_parse = JSON.parse(g_loc)

g_array = g_parse.fetch("results").at(0)

g_geo = g_array.fetch("geometry").fetch("location")

lat = g_geo.fetch("lat").to_s
long = g_geo.fetch("lng").to_s

## Weather here ##

weather_url = URI.open("https://api.pirateweather.net/forecast/#{ENV.fetch("GMAPS_KEY")}/#{lat},#{long}").read
weather_parse = JSON.parse(weather_url)

current = weather_parse.fetch("currently")

temp = current.fetch("temperature")

p temp

hourly = weather_parse.fetch("hourly")

p hourly.keys
