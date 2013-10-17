FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user-#{n}" }
    password "password"
    password_confirmation { |u| u.password }
    sequence(:email) { |n| "user-#{n}@noemail.com" }
  end
end

FactoryGirl.define do
  factory :event do
    sequence(:name) { |n| "event-#{n}" }
    description "none"
    open_for_selections true
    open_for_voting true
    selections_deadline 1.week.from_now
    votes_deadline 2.weeks.from_now
    start 3.weeks.from_now
    maxmovies 100
    association :user
    selections_per_attendee 3
    votes_per_attendee 3
  end
end

FactoryGirl.define do
  factory :selection do
    association :event
    movie_id { rand(10000) }
    sequence(:movie_name) { |n| "movie-#{n}" }
  end
end
