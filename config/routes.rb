# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'worklogs', :to => 'worklogs#index'
get 'worklogs/my', :to => 'worklogs#my'
get 'worklogs/report', :to => 'worklogs#report'
put 'worklogs', :to => 'worklogs#update'
match '/worklogs/preview', :controller => 'worklogs', :action => 'preview', :as => 'preview_worklogs', :via => [:get, :post, :put]

get 'worklogs/review', :to => 'worklogs#review',:as => 'review_worklog'
post 'worklogs/review', :to => 'worklogs#review',:as => 'review_worklogs'


resources :worklogs do
  resources :tasklogs
end
