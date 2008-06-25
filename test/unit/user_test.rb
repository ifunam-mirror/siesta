require File.dirname(__FILE__) + '/../test_helper'
class UserTest < Test::Unit::TestCase
  fixtures :userstatuses, :users

  # Testing basic constraints
  should_require_attributes :login, :email, :passwd

  should_not_allow_values_for :login, 'al', :message => /too short/
  should_not_allow_values_for :login, 's' * 31, :message => /too long/
  should_not_allow_values_for :login, '@@@', :message => /is invalid/

  should_not_allow_values_for :email, "a@s.c", :message => /too short/
  should_not_allow_values_for :email, 'user@'+'domain' * 16 + '.com', :message => /too long/
  should_not_allow_values_for :email, 'user@d@main.com', :message => /is invalid/
  should_not_allow_values_for :email, 'user.domain.com', :message => /is invalid/

  should_not_allow_values_for :passwd, "abcd", :message => /too short/
  should_not_allow_values_for :passwd, 's' * 201, :message => /too long/

  should_require_unique_attributes :login
  should_require_unique_attributes :email
  

  def setup
    @logins = User.find(:all).collect { |u|  u.login }
  end

  def test_authenticate?
    assert User.authenticate?('admin','maltiempo')
  end

  def test_should_not_authenticate?
    assert !User.authenticate?('admin','badpassword')
  end

  def test_should_authenticate_by_token?
    assert User.authenticate_by_token?('alex.juarez','lcGVrs2FmS')
    assert !User.authenticate_by_token?('admin','badtoken')
  end

  def test_should_change_password
    assert User.change_password('admin','maltiempo', 'new_password')
  end

  def test_should_not_change_password
    assert !User.change_password('admin','badpassword', 'new_password')
  end

  def test_should_encrypt_string
    assert_equal '285915705af70616553eb13a997ee9f5183d3a83b9c9a36c6a928dc64920c664f8c5eb5284643d7edd2edcb6c4948af68f6322d98991cf61f104bced3bf50028', User.encrypt('somepassword', 'RhKfxHddtln1XPWw1bIwVefodA2p9MROequn/oEG')
  end

  def test_should_activate_user
    for login in (@logins)
      @user = User.find_by_login(login)
      @user.activate
      assert @user.is_activated?
    end
  end

  def test_should_lock_user
    for login in (@logins)
      @user = User.find_by_login(login)
      @user.lock
      assert @user.is_locked?
    end
  end

  def test_should_send_user_to_history_file
    for login in (@logins)
      @user = User.find_by_login(login)
      @user.send_to_history_file
      assert @user.is_in_history_file?
    end
  end

  def test_should_get_new_token
    for login in (%w(alejandro admin))
      @user = User.find_by_login(login)
      assert @user.token.empty?
      @user.new_token
      assert !@user.token.empty?
    end
  end

  def test_should_destroy_token
    @user = User.find_by_login('alex.juarez')
    assert !@user.token.empty?
    @user.destroy_token
    assert @user.token.nil?
  end

  def test_new_user_should_be_unactivated
    @user = User.new(:login => 'john', :passwd => 'supersecret', :email => 'john@somedomain.com')
    assert @user.valid?
    @user.save
    assert @user.is_unactivated?
  end

  def test_new_user_should_be_created
    assert_difference 'User.count' do
      user = User.build_valid
      deny user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

   def test_unactivated_users
     user = User.build_valid
     user.save
     assert_equal 1, User.unactivated.count
   end

   def test_activated_users
     assert_equal 3, User.activated.count
   end

   def test_locked_users
     usersc=%w(admin alejandro)
     users.each do |user|
       User.find_by_login(user).lock
     end
     assert_equal users.size, User.locked.count
   end

   def test_users_in_history_file
       users = %w(admin alejandro)
       users.each do |user|
             User.find_by_login(user).send_to_history_file
       end
     assert_equal users.size, User.in_history_file.count
   end

   def test_users_with_user_incharge
     user = User.build_valid
     user.user_incharge = User.find_by_login('admin')
     user.save
     assert_equal 1, User.with_user_incharge.count
   end

end
