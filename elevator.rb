require 'json'
require 'net/http'
BUFFER_SIZE = 80 # locations per request
lines = IO.readlines("hexagons.txt")
OFFSET = 0
HOW_MANY = 100 #765 paczek maks
results = []

File.open("elevations-#{OFFSET}-#{OFFSET+HOW_MANY-1}.txt", 'w') do |f|
  index = OFFSET
  lines[OFFSET*BUFFER_SIZE,HOW_MANY*BUFFER_SIZE].each_slice(BUFFER_SIZE) do |b|
    l = b.collect{|line| line.chomp}.join("|")
    response = Net::HTTP.get_response("maps.googleapis.com","/maps/api/elevation/json?sensor=false&locations=#{l}")
    r = JSON.parse(response.body)
    f.puts r["results"].collect{|r| "#{r["location"]["lat"]},#{r["location"]["lng"]}:#{r["elevation"].round}"}.join("\n");
    puts "#{index} : #{r["status"]}"
    index = index + 1    
  end
end


#puts results["status"].inspect
