Factory.sequence :name do |n|
  "somebody name#{n}"
end

Factory.sequence :email do |n|
"email#{n}@email.com"
end

Factory.define :profile do |p|
  p.association :user, :factory => :user  
  #p.sequence(:user_id){ |n| n }
 p.name { Factory.next(:name)}
end

Factory.define :task do |t|
 t.association :profile, :factory => :profile
 t.title { Factory.next(:name)}
 t.description "desc"
 t.category  "Bug Fix"
 t.associated_project_name "MongoDB"
 t.computer_language  "Ruby"
 t.solution_license "MIT License"
 t.solution_format "Link"
 t.initial_reward_amount  "100"
 t.deadline_date  Date.parse("12/1/12")
end

Factory.define :task_submission do |t|
  t.association :profile, :factory => :profile
  t.association :task, :factory => :task
  t.solution_format Constants::SOLUTION_FORMATS.first
  t.link "http://github.com"
end

Factory.define :task_reward do |t|
  t.association :profile, :factory => :profile
  t.association :task, :factory => :task
  t.amount 100
end

Factory.define :payment do |p|
  p.association :sender, :factory => :profile
  p.association :recipient, :factory => :profile
  p.association :task_submission, :factory => :task_submission
end

Factory.define :preapproval_payment do |p|
  p.association :sender, :factory => :profile
  p.association :task, :factory => :task
  p.amount 100
end

Factory.define :user do  |u|
  u.name { Factory.next(:name) }
  u.email { Factory.next(:email) }
  u.password "password"
  u.password_confirmation{|s| s.password}
end