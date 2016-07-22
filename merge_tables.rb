require 'json'
require_relative 'environment.rb'
require 'pry'

CSV.foreach("data/addresses.csv", headers: true) do |row|
  a = Address.new(row)
  pre = Precinct.new(a.precinct_code) if !Precinct.codes.include?(a.precinct_code)
  pre = Precinct.find_by_code(a.precinct_code) if Precinct.codes.include?(a.precinct_code)
  pre.addresses << a
end

arr1 = []
CSV.foreach("data/precinct_polling_list.csv", headers: true) do |row|
  p = PollingPrecinct.new(row.to_hash)
  pre = Precinct.new(p.precinct) if !Precinct.codes.include?(p.precinct)
  arr1.push(pre) if pre
  pre = Precinct.find_by_code(p.precinct) if Precinct.codes.include?(p.precinct)
  arr = Address.all.select{|a| a.precinct_code == p.precinct}
  arr.each do |address|
    p.addresses << address
    address.polling_precinct = p.address
  end
end

preCounter = 0
pollCounter = 0

while preCounter < Precinct.all.length
  current = Precinct.all[preCounter]
  current.id = "pre" + sprintf('%03d', preCounter + 1)
  preCounter += 1
end

while pollCounter < PollingPrecinct.all.length
  current = PollingPrecinct.all[pollCounter]
  current.id = "poll" + sprintf('%03d', pollCounter + 1)
  pollCounter += 1
end


precinct = File.open("precinct.txt", "w")
precinct.puts("name,number,locality_id,ward,mail_only,ballot_style_image_url,id")
polling_location = File.open("polling_location.txt", "w")
polling_location.puts("address_line,directions,hours,photo_uri,hours_open_id,is_drop_box,is_early_voting,latitude,longitude,latlng_source,id")
ppp = File.open("precinct_polling_location.txt", "w")
ppp.puts("precinct_id,polling_location_id")


PollingPrecinct.all.each do |pp|
  pp.txt_data.each do |item|
    polling_location.write(",") if item.nil?
    polling_location.write(item + ",") if !item.nil? && item != pp.id
    polling_location.puts(item) if item == pp.id
  end
end

Precinct.all.each do |pre|
  pre.txt_data.each do |item|
    precinct.write(",") if item.nil?
    precinct.write(item + ",") if !item.nil? && item != pre.id
    precinct.puts(item) if item == pre.id
  end
end


# Precinct.all.each do |pre|
#   if pre.polling_location_id
#     ppp.write(pre.id_number + ",")
#     ppp.puts(pre.polling_location_id)
#   end
# end

# arr = Precinct.no_poll

binding.pry

x = 1

