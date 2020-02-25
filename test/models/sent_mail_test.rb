require 'test_helper'

class MailTest < ActiveSupport::TestCase
  # Regex validating a correct Phone number (constant)
  PHONE_NUMBER_REGEX = %r{\A([+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*)?\Z}.freeze

  # Regex validating a correct Email address (constant)
  EMAIL_REGEX = %r{\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\Z}.freeze

  test 'valid sent_mail' do
    sent_mail = SentMail.new(name: 'Test Name', email: 'email@email.com', message: 'Test message', telephone: '07555555555', user: User.first)
    assert sent_mail.valid?
  end

  test 'valid sent_mail without telephone' do
    sent_mail = SentMail.new(name: 'Test Name', email: 'email@email.com', message: 'Test message', user: User.first)
    assert sent_mail.valid?
  end

  test 'invalid sent_mail with incorrect telephone' do
    sent_mail = SentMail.new(name: 'Test Name', email: 'email@email.com', message: 'Test message', telephone: 'a07555555555', user: User.first)
    refute sent_mail.valid?
    assert_not_nil sent_mail.errors[:telephone]
  end

  test 'invalid sent_mail without title' do
    sent_mail = SentMail.new(name: 'Test Name', email: 'email@email.com', user: User.first)
    refute sent_mail.valid?, 'sent_mail is not valid without a title'
    assert_not_nil sent_mail.errors[:name]
  end

  test 'invalid sent_mail without message' do
    sent_mail = SentMail.new(name: 'Test Name', email: 'email@email.com', telephone: 'a07555555555', user: User.first)
    refute sent_mail.valid?, 'sent_mail is not valid without description'
    assert_not_nil sent_mail.errors[:description]
  end

  test 'invalid sent_mail with no email' do
    sent_mail = SentMail.new(name: 'Test Name', message: 'Test message', telephone: '07555555555', user: User.first)
    refute sent_mail.valid?
    assert_not_nil sent_mail.errors[:email]
  end

  test 'invalid sent_mail with incorrect email' do
    sent_mail = SentMail.new(name: 'Test Name', email: '$email@email.com', message: 'Test message', telephone: '07555555555', user: User.first)
    refute sent_mail.valid?
    assert_not_nil sent_mail.errors[:email]
  end

  test 'invalid sent_mail without user' do
    sent_mail = SentMail.new(name: 'Test Name', email: 'email@email.com', message: 'Test message', telephone: 'a07555555555')
    refute sent_mail.valid?, 'sent_mail is not valid without description'
    assert_not_nil sent_mail.errors[:user]
  end
end
