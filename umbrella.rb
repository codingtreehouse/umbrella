require "open-uri"
require "json"

puts "Where are you located?"

user_location = gets.chomp

puts "Checking the weather at #{user_location}..."

google_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{ENV.fetch("GMAPS_KEY")}"

g_loc = URI.open(google_url).read

g_parse = JSON.parse(g_loc)

g_array = g_parse.fetch("results").at(0)

g_geo = g_array.fetch("geometry").fetch("location")

lat = g_geo.fetch("lat").to_s
long = g_geo.fetch("lng").to_s

puts "Your coordinates are #{lat},#{long}"

## Weather here ##

weather_url = URI.open("https://api.pirateweather.net/forecast/#{ENV.fetch("PIRATE_WEATHER_KEY")}/#{lat},#{long}").read
weather_parse = JSON.parse(weather_url)

current = weather_parse.fetch("currently")
temp = current.fetch("temperature")
weather_status = current.fetch("summary").downcase

hourly = weather_parse.fetch("hourly")
hour_summary = hourly.fetch("data")[0]["precipProbability"]

puts ""
puts "It is currently #{temp}° F."

puts "Next hour: #{hourly.fetch("data")[0]["summary"]}"

if hour_summary > 0.1
  12.times do |hour|
    hour_up = hour+1
    hour_weather = hourly.fetch("data")[hour_up]
    puts "In #{hour_up} hours, there is a #{(hour_weather["precipProbability"]*100).round(1)}% chance of precipitation."
  end
  puts "You might want to take an umbrella!"
else 
  puts ""
  puts "You probably don't need an umbrella today!"
end
