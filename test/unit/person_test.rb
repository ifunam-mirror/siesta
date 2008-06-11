# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < ActiveSupport::TestCase
  fixtures :countries, :states, :cities, :users, :people
  should_require_attributes :firstname, :lastname1, :birthdate, :country_id
  # should_require_unique_attributes :name, :scope => [:country_id]
  should_only_allow_numeric_values_for :id
  should_not_allow_values_for :id, -1,  :message => /must be greater than 0/
  should_not_allow_values_for :id, 0,  :message => /must be greater than 0/
  should_allow_values_for :gender, true, false
  should_only_allow_numeric_values_for :user_id, :country_id, :state_id, :city_id
  should_belong_to :country
  should_belong_to :state
  should_belong_to :city

  def test_fullname
    assert_equal 'Argáez García Juancho', Person.find(:first).fullname
  end

  def test_placeofbirth
    assert_equal 'Aguascalientes, Aguascalientes, México', Person.find(:first).placeofbirth
  end

  def test_invalid_birthdate
    @record = Person.find(:first)
    @record.birthdate = Date.today
    assert !@record.valid?
  end
end
