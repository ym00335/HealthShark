require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'valid user' do
    user = User.new(name: 'Name', email: 'email@email.com', password: 'password', is_female: true, date_of_birth: DateTime.new(1999, 5, 8))
    assert user.valid?
  end

  test 'valid user without gender' do
    user = User.new(name: 'Name', email: 'email@email.com', password: 'password', date_of_birth: DateTime.new(1999, 5, 8))
    assert user.valid?
  end

  test 'valid user without date of birth' do
    user = User.new(name: 'Name', email: 'email@email.com', password: 'password', is_female: true)
    assert user.valid?
  end

  test 'invalid user without name' do
    user = User.new(email: 'email@email.com', password: 'password', is_female: true)
    refute user.valid?
    assert_not_nil user.errors[:name]
  end

  test 'invalid user without email' do
    user = User.new(name: 'Name', password: 'password', is_female: true)
    refute user.valid?
    assert_not_nil user.errors[:email]
  end

  test 'invalid user without password' do
    user = User.new(name: 'Name', email: 'email@email.com', is_female: true)
    refute user.valid?
    assert_not_nil user.errors[:password]
  end

  test 'invalid user with invalid email' do
    user = User.new(name: 'Name', email: 'em$ail@email.com', password: 'password', is_female: true)
    refute user.valid?
    assert_not_nil user.errors[:email]
  end
end
