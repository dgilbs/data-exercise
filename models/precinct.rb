require 'pry'

class Precinct

  attr_accessor :code, :id

  @@all = []


  def initialize(code)
    @code = code
    @addresses = []
    @@all << self
  end

  def self.all 
    @@all
  end


  def self.codes
    arr = self.all.map{|a| a.code}
    arr.uniq
  end

  def id_number
    arr = self.id.split("")
    arr[3..arr.length-1].join
  end

  def addresses
    @addresses
  end

  def polling_location_id
    self.addresses.first.polling_location_id if self.addresses.length > 0
  end

  def polling_location_address
    self.addresses.first.polling_location_address if self.addresses.length > 0
  end

  def self.find_by_code(code)
    self.all.find{|a| a.code == code}
  end

  def self.no_poll
    self.all.select{|a| a.polling_location_id.nil?}
  end

  def ballot_style_id
  end

  def electoral_district_ids
  end

  def external_identifier_type
  end

  def external_identifier_other_type
  end

  def external_identifier_value
  end

  def mail_only
  end

  def locality_id
  end

  def name
    self.code
  end

  def number
  end

  def polling_location_ids
  end

  def precinct_split
  end

  def ballot_style_image_url
  end

  def ward
  end


  def txt_data
     [self.name, self.number, self.locality_id, self.mail_only, 
      self.ballot_style_image_url, self.id]
  end

end