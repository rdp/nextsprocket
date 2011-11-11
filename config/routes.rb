ActionController::Routing::Routes.draw do |map|
  map.root :controller => :tasks

  map.resources :tasks, :member => {:created => :get, :create_comment => :post, :working_on => :post, :not_working_on => :post}, :collection => {:new => :any} do |task|
    task.resources :submissions, :controller => :task_submissions, :member => {:reject => :post,
                                                                               :accept => :post,
                                                                               :create_comment => :post}
    task.resources :rewards, :controller => :task_rewards
  end
  
  map.resources :payments, :member=>{:completed_paypal => :get, :canceled_paypal =>:get}
  map.resources :preapproval_payments, :member=>{:completed_paypal => :get, :canceled_paypal =>:get}
  map.resources :feedbacks
  map.resources :projects

  map.resource :my_profile, :controller => :my_profile
  map.resources :profiles
  map.resources :users
  map.resource :user_session
  map.resource :account, :controller => :users, :action => :edit

  map.about '/about', :controller => :home, :action => :about
  map.contact_us '/contact_us', :controller => :home, :action => :contact_us
  map.terms_of_use '/terms_of_use', :controller => :home, :action => :terms_of_use
  map.privacy_policy '/privacy_policy', :controller => :home, :action => :privacy_policy
  map.how_it_works '/how_it_works', :controller => :home, :action => :how_it_works

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
