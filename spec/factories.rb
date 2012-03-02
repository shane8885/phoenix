Factory.define :user do |f|
  f.sequence(:username) { |n| "user-#{n}" }
  f.password "password"
  f.password_confirmation { |u| u.password }
  f.sequence(:email) { |n| "user-#{n}@noemail.com" }
end

Factory.define :event do |f|
  f.sequence(:name) { |n| "event-#{n}" }
  f.description "none"
  f.open_for_selections true
  f.open_for_voting true
  f.selections_deadline 1.week.from_now
  f.votes_deadline 2.weeks.from_now
  f.start 3.weeks.from_now
  f.maxmovies 100
  f.association :user
  f.selections_per_attendee 3
  f.votes_per_attendee 3
end

Factory.define :selection do |f|
  f.association :event
  f.movie_id { rand(10000) }
  f.sequence(:movie_name) { |n| "movie-#{n}" }
end
