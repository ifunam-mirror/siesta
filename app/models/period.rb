class Period < ActiveRecord::Base
  validates_numericality_of :id, :allow_nil => true, :only_integer => true, :greater_than => 0
  validates_presence_of :name, :startdate, :enddate
  validates_inclusion_of :is_active, :in=> [true, false]
  validates_uniqueness_of :name

  default_scope :order => 'startdate DESC, enddate DESC'
  def validate!
   if startdate && enddate
      errors.add("startdate", "must be after checkout") if time_at_midnight(startdate) >= time_at_midnight(enddate)
    end
  end

  def self.most_recent
    Period.activated || Period.last_started
  end

  def self.last_started
    self.where(['enddate >= ?', Date.today]).order("startdate ASC").limit(1).first
  end

  def self.activated
    self.where(:is_active=>true).first
  end

  def self.previous
    self.where(['startdate < ?', Period.most_recent.startdate]).order('startdate DESC').limit(1).first
  end
  
  private
  def time_at_midnight(date)
    date.to_date
  end
end
