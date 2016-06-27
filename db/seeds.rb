# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
File.open("./db/airports.dat", "r") do |file|
	file.each_line do |line|
		line_content = line.shellsplit[0].split(",")
		airport_data = {
			:name => line_content[1],
			:city => line_content[2],
			:country => line_content[3],
			:iata => line_content[4],
			:icao => line_content[5],
			:latitude => line_content[6],
			:longitude => line_content[7],
			:tz_db => line_content[11]
		}
		Airport.create(airport_data)
	end
end

File.open("./db/airlines.dat", "r") do |file|
	file.each_line do |line|
		line_content = line.shellsplit[0].split(',')
		offset = rand(Airport.count)
		airline_data = {
			:name => line_content[1],
			:iata => line_content[3],
			:icao => line_content[4],
			:airport => Airport.offset(offset).first
		}
		Airline.create(airline_data)
	end
end

File.open("./db/routes.dat", "r") do |file|
	file.each_line do |line|
		line_content = line.shellsplit[0].split(",")
		offset = rand(Airport.count)
		depart_airport = Airport.find_by(:id => line_content[3])
		arrival_airport = Airport.find_by(:id => line_content[5])
		next if depart_airport.nil? || arrival_airport.nil?
		flight_data = {
			:departure_date => Faker::Date.backward(30),
			:arrival_date => Faker::Date.forward(30),
			:airport => Airport.offset(offset).first,
			:airline => Airline.find_by(:id => line_content[1]),
			:flight_number => Faker::Number.number(6),
			:departure_location => depart_airport.name,
			:arrival_location => arrival_airport.name,
			:price => Faker::Commerce.price
		}
		Flight.create(flight_data)
	end
end
