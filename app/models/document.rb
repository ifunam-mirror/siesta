class Document < ActiveRecord::Base
  validates_numericality_of :id, :allow_nil => true, :greater_than => 0, :only_integer => true
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :user_documents
end
