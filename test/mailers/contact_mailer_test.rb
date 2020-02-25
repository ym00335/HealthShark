require 'test_helper'

class ContactMailerTest < ActionMailer::TestCase
  test "creation" do
    # Create the email and store it for further assertions
    email = ContactMailer.contact_email('me@example.com',
              'Name', '07555555555', 'Test Title', 
              'Test message content of the email')
 
    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end
 
    # Test the body of the sent email contains what we expect it to
    assert_equal ['me@example.com'], email.cc
    assert_equal ['info@mynotes.com'], email.from
    assert_equal ['info@mynotes.com'], email.to
    
    assert_equal read_fixture('test_mail.txt').join, email.body.to_s.gsub(/\r/,'')
  end
end
