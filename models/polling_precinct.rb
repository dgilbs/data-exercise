require 'pry'
require 'json'



class PollingPrecinct

  attr_accessor :data, :street, :city, :state, :zip, :country, :precinct, :id

  @@all = []

  def initialize(hash)
    if hash.values.compact.length == 5
      @data= hash.values
      @street = hash["Street"]
      @city = hash["City"]
      @state = hash["State/ZIP"].split(" ")[0]
      @zip = hash["State/ZIP"].split(" ")[1]
      @country = hash["Country"]
      @precinct = hash["Precinct"]
    else 
      @data = hash.values
      @state = self.set_state
      @zip = self.set_zip(@state)
      @street = self.set_street
      @precinct = @data.compact.last
      @country = self.set_country
      @city = self.set_city
    end
    @addresses = []
    @@all<<self
  end

  def self.all 
    @@all
  end


  def set_state
    arr = self.data.join(" ").split(" ")
    @state = arr.find{|str| str.length == 2 && str.upcase == str && str.to_i == 0}
  end

  def set_zip(state)
    state_index = self.data_elements.index(state)
    self.data_elements[state_index + 1]
  end

  def set_street
    arr = ["Avenue", "Ave"]
    item = self.data_elements.find{|a| arr.include?(a)}
    self.data_elements.slice(0, self.data_elements.index(item) + 1).join(" ")
  end

  def set_city
    arr = ["Avenue", "Ave"]
    item = self.data_elements.find{|a| arr.include?(a)}
    item_index = self.data_elements.index(item)
    state_index = self.data_elements.index(self.state)
    city_arr = self.data_elements.slice(item_index + 1, state_index-item_index-1)
    city_arr.join(" ")
  end

  def set_country
    self.data_elements.find{|a| a.length == 3 && a.upcase == a && a.to_i == 0}
  end

  def data_elements
    self.data.join(" ").split(" ")
  end

  def set_precinct
    self.data.compact.last
  end

  def self.cities
    self.all.map{|a| a.city}
  end

  def self.all_cities
    self.cities.uniq
  end

  def self.city_count
    hash = {}
    self.all_cities.each do |city|
      hash[city] = self.all.select{|a| a.city == city}.count
    end
    hash
  end

  def addresses
    @addresses
  end

  def address
    arr = [self.street, self.city, self.state, self.zip]
    arr.join(" ")
  end

  def id_number
    arr = self.id.split("")
    arr[4..arr.length-1].join
  end

  def directions
  end

  def hours
  end

  def photo_uri
  end

  def hours_open_id
  end

  def is_drop_box
  end

  def is_early_voting
  end

  def latitude
  end

  def longitude
  end

  def latlng_source
  end

  def txt_data
    [self.address, self.directions, self.hours, self.photo_uri, self.id]
  end




end