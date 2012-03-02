require 'spec_helper'

describe "Events" do
  before :all do
    @event = Factory(:event)
  end
  
  after :all do
    User.all.each { |u| u.destroy }
    Event.all.each { |e| e.destroy }
  end
    
  context "(not authenticated)" do
    it "should redirect access to search path" do
      get search_events_path
      response.status.should be(302)
    end
    
    it "should redirect access to new event path" do
      get new_event_path
      response.status.should be(302)
    end
  end
  
  context "(authenticated)" do
    before :each do
      visit new_user_session_path
      fill_in 'Username', :with => @event.user.username
      fill_in 'Password', :with => 'password'
      click_button 'Sign in'
      page.should have_content 'Signed in successfully'
      visit search_user_index_path
      click_button 'Invite'
      page.should have_content 'Invitation was successfully created'
      @attendee = Factory(:user)
      # create invite for attendee
      # post_and_redirec
    end
    
    it "allows event creation given good parameters" do
      visit new_event_path
      fill_in 'Name', :with => 'event-test'
      click_button 'Create Event'
      page.should have_content('Event was successfully created.')
    end
    
    context "empty" do
      it "should let me see all the event pages" do
        visit selections_event_path(@event)
        page.should have_content('No selections have been made official')
        visit calendar_event_path(@event)
        page.should have_content('Create New Schedule')
        visit attendees_event_path(@event)
        page.should have_content('No confirmed attendees')
        visit schedule_event_path(@event)
        page.should have_content('No schedule has been created')
        visit voting_event_path(@event)
        page.should have_content('No votes have been registered')
        visit comments_event_path(@event)
        page.should have_content('Comments')
      end
    end
    
    it "creates an invite and adds a movie to the selections list" do
      visit movies_search_path
      fill_in 'Find movie', :with => 'rocky'
      click_button 'Search'
      click_link 'show'
      click_button 'Select'
      page.should have_content('Selection was successfully created')
      visit selection_path(@event.selections.first)
      click_button 'Add Vote'
      page.should have_content('Successfully registered vote')
      visit selections_event_path(@event)
      click_link 'Promote'
      page.should have_content('Successfully promoted selection')
    end
    
    it "should restrict users to their quota of selections" do
      attendance = Attendance.find_by_event_id_and_attending_id(@event.id,@event.user_id)
      attendance.selections_remaining = 0
      attendance.save
      visit movies_search_path
      fill_in 'Find movie', :with => 'jurasic park'
      click_button 'Search'
      click_link 'show'
      click_button 'Select'
      #save_and_open_page
      page.should have_content('You have no selections remaining')
    end
    
    it "should create a schedule" do
      Factory(:selection, :event_id => @event.id, :user_id => @event.user_id)
      Factory(:selection, :event_id => @event.id, :user_id => @event.user_id)
      Factory(:selection, :event_id => @event.id, :user_id => @event.user_id)
    end
    
    it "should remove everything when deleted"
    
    it "should restrict users to their quota of votes" do
      attendance = Attendance.find_by_event_id_and_attending_id(@event.id,@event.user_id)
      attendance.votes_remaining = 0
      attendance.save
      visit movies_search_path
      fill_in 'Find movie', :with => 'star wars'
      click_button 'Search'
      click_link 'show'
      click_button 'Select'
      page.should have_content('Selection was successfully created')
      visit selections_event_path(@event)
      click_button 'Vote'
      #save_and_open_page
      page.should have_content('Sorry, you used all your votes')
    end
      
    it "should not allow duplicate selections" do
      visit movies_search_path
      fill_in 'Find movie', :with => 'star wars'
      click_button 'Search'
      click_link 'show'
      click_button 'Select'
      #save_and_open_page
      page.should have_content('Selection was successfully created')
      visit movies_search_path
      fill_in 'Find movie', :with => 'star wars'
      click_button 'Search'
      click_link 'show'
      click_button 'Select'
      #save_and_open_page
      page.should have_content('It may already exist')
    end
    
    it "should not allow duplicate invitations" do
      visit search_user_index_path
      click_button 'Invite'
      page.should have_content 'Sorry, could not create invitation'
    end
    
    it "should not allow access to other events" do
      e = Factory(:event)
      visit event_path(e)
      page.should have_content 'Not authorized to perform that action'
    end
  end
end
