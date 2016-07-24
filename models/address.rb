require 'pry'
require 'json'


class Address
  attr_accessor :street, :apt, :city, :state, :zip, :country, :precinct_id
  attr_accessor :polling_precinct

  @@all = []

  def initialize(hash)
    @street = hash["Street"]
    @apt = hash["Apt"]
    @city = hash["City"]
    @state = hash["State"]
    @zip = hash["Zip"].split
    @country = hash["Country"]
    @precinct_id = hash["Precinct ID"]
    @@all << self
  end

  def self.all 
    @@all 
  end

  def street_address
    arr = [self.street, self.apt, self.city, self.state, self.zip].compact
    arr.join(" ")
  end

  def find_by_zip(zip)
    arr = self.all.select{|a| a.zip == zip}
    arr[0] if arr.length == 1
  end

  def state_code
    codes = {ct: "CON",
      ga: "GEO",
      ma: "MAS", 
      fl: "FLO",
      nj: "NEWJ",
      ca: "CAL",
      mn: "MIN",
      il: "ILL",
      az:"ARI",
      va: "VIR",
      me: "MAI",
      wi: "WIS",
      ny: "NEWY",
      pa: "PEN"
    }
    codes[self.state.downcase.to_sym]
  end

  def polling_location_id
    poll = PollingPrecinct.all.find {|a| a.precinct == self.precinct_code}
    if poll 
      return poll.id_number
    else
      nil
    end
  end

  def polling_location_address
    poll = PollingPrecinct.all.find {|a| a.precinct == self.precinct_code}
    if poll 
      return poll.address
    else
      nil
    end
  end

  def precinct_code
    num = self.precinct_id.split("-")[1]
    self.state_code + "-" + num
  end


  def self.precincts
    arr = self.all.map{|a| a.precinct}
    arr.uniq
  end
end