Redmine::Plugin.register :worklogs do
  name 'Worklogs'
  author 'Iceskysl, XY'
  description 'This is a worklogs plugin for Redmine'
  version '0.3.0'
  url 'https://github.com/yxiaoa/worklogs'
  author_url 'http://my.eoe.cn/iceskysl'
  
  permission :all_worklogs, :worklogs => :index
  permission :my_worklogs, :worklogs => :my
  permission :new_worklogs, :worklogs => :new
  
  menu :top_menu, :worklogs, { :controller => 'worklogs', :action => 'index' }, :caption => :label_worklog #, :if => User.current.allowed_to?({:controller => "worklogs", :action => "index"},nil,{:global => true})
  
  settings :default => {'empty' => true}, :partial => 'settings/worklogs_settings'
end
