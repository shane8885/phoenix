require 'spec_helper'

describe "Users" do
  describe "public access" do
    it "should redirect access to users search path" do
      get search_user_index_path
      response.status.should be(302)
    end
  end
  
  describe "sign in and out" do
    it "should work given valid credentials" do
      user = FactoryGirl.create(:user, :username => 'joe', :password => 'password')
      visit new_user_session_path
      fill_in 'Username', :with => 'joe'
      fill_in 'Password', :with => 'password'
      click_button 'Sign in'
      page.should have_content("Signed in successfully")
      click_link 'Sign out'
      page.should have_content("Signed out successfully")
    end
  end
  
  describe "sign up" do
    it "should work when given valid data" do
      visit new_user_registration_path
      fill_in 'Username', :with => 'joe'
      fill_in 'Email', :with => 'joe@email.com'
      fill_in 'Password', :with => 'password'
      fill_in 'Password confirmation', :with => 'password'
      click_button 'Sign up'
      page.should have_content('Welcome! You have signed up successfully.')
    end
  end
end
