require File.dirname(__FILE__) + '/../test_helper'

class InstitutionTest < ActiveSupport::TestCase
  fixtures :countries, :institutions
  should_require_attributes :name, :country_id
  should_require_unique_attributes :name, :scoped_to => :country_id

  should_only_allow_numeric_values_for :id
  should_not_allow_values_for :id, -1,  :message => /must be greater than 0/
  should_not_allow_values_for :id, 0,  :message => /must be greater than 0/
  should_allow_nil_value_for :id
  should_not_allow_float_number_for :id

  should_only_allow_numeric_values_for :country_id
  should_not_allow_values_for :country_id, -1,  :message => /must be greater than 0/
  should_not_allow_values_for :country_id, 0,  :message => /must be greater than 0/
  should_not_allow_nil_value_for :country_id
  should_not_allow_float_number_for :country_id

  should_have_many :schools
  should_belong_to :parent
end
