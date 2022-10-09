#encoding: utf-8
class WorklogsController < ApplicationController
  model_object Worklog
  unloadable

  # before_filter :authorize, :only => [:index,:my,:new]
  
  before_action :find_model_object, :except => [:index, :new, :create,:my,:preview]
  before_action :init_slider,:only => [:index, :my, :new, :edit, :show]
  
  
  def init_slider
    @last=Worklog.order("created_at asc").first.created_at.to_date if Worklog.count > 0
    @last ||= Date.today
    # @last = Date.new(@start_topic.year,@start_topic.mon,1)
    @start=Date.today
    scope = User.logged.status(1)
    @users =  scope.order("id asc").all - Worklog.no_need_users
  end
  
  def load_worklogs
    worklogs_scope = Worklog.where("status = 0")
    if @user_id && @user_id.to_i > 0
      worklogs_scope = worklogs_scope.where(:user_id => @user_id)
    end
    
    unless @week.blank?
      worklogs_scope = worklogs_scope.where(:week => @week)
    end
    
    unless @typee.blank?
      worklogs_scope = worklogs_scope.where(:typee => @typee)
    end
    
    
    worklogs_scope = worklogs_scope.order("day desc,id desc")
    @limit =  Setting.plugin_worklogs['WORKLOGS_PAGINATION_LIMIT'].to_i || 20
    # @worklogs = worklogs_scope.all#.limit(@limit)
    
    @worklogs_count = worklogs_scope.count
    @worklogs_pages = Paginator.new @worklogs_count, 20, @limit, params['page']
    @offset ||= @worklogs_pages.offset
    #@worklogs = worklogs_scope.all(    :order => "#{Worklog.table_name}.created_at DESC",
    #                                   :offset => @offset,
    #                                   :limit => @limit)
    @worklogs = worklogs_scope.all
  end
  

  def index
    @user_id = params[:user_id]
    @week = params[:week]
    @typee = params[:typee]
    load_worklogs
  end
  
  def preview
    # logger.info(params[:worklog])
    
    if params[:id].present? && worklog = Worklog.visible.find_by_id(params[:id])
      @previewed = worklog
    end
    # @text = (params[:worklog] ? params[:worklog][:do] : nil)
    @worklog = Worklog.new(params[:worklog])
    @worklog.day = Date.today
    @worklog.week = Date.today.strftime("%W").to_i
    @worklog.author = User.current
    render :partial => 'preview'
  end
  

  
  def my
    @user_id = session[:user_id]
    @week = params[:week]
    load_worklogs
    render :action => :index
  end

  def new
    @day = Date.today
    @day_todo = Worklog.where("user_id = ? and day <> ? and typee = ?", session[:user_id],Date.today,0).last
    @week_todo = Worklog.where("user_id = ? and day <> ? and typee = ?", session[:user_id],Date.today,1).last
    @month_todo = Worklog.where("user_id = ? and day <> ? and typee = ?", session[:user_id],Date.today,2).last
    @year_todo = Worklog.where("user_id = ? and day <> ? and typee = ?", session[:user_id],Date.today,3).last
    
    @worklog = Worklog.new()
    @worklog.typee = 1
    10.times do
      @worklog.tasklogs.build
    end
  end

  def edit
    @worklog = Worklog.find(params[:id])
    @day = Date.today
    @day_todo = Worklog.where("user_id = ? and day <> ? and typee = ?", session[:user_id],Date.today,0).last
    @week_todo = Worklog.where("user_id = ? and day <> ? and typee = ?", session[:user_id],Date.today,1).last
    10.times do
      @worklog.tasklogs.build
    end
  end

  def show
    @worklog_reviews = @worklog.worklog_reviews
    @worklog_review = WorklogReview.new()
  end
  

  def review
    @worklog_reviews = WorklogReview.new(params[:worklog_review])
    @worklog_reviews.user = User.current
    @worklog_reviews.worklog = @worklog
    if @worklog_reviews.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to worklog_path(:id=>@worklog.id)
    end
  end

  def update
    @worklog = Worklog.find(params[:id])

    if @worklog.update(worklog_params)
      flash[:notice] = l(:notice_successful_update)
      redirect_to @worklog
    else
      render :action => 'edit',:id => @worklog.id
    end
  end

  def destroy
    @worklog = Worklog.find(params[:id])
    @worklog.destroy

    redirect_to worklogs_path()
  end

  def create
    @worklog = Worklog.new(worklog_params)
    @worklog.day = Date.today
    @worklog.week = Date.today.strftime("%W").to_i
    @worklog.month = Date.today.strftime("%m").to_i
    @worklog.year = Date.today.strftime("%Y").to_i
    @worklog.author = User.current
    if @worklog.save
      redirect_to worklogs_path()
    else
    end
  end

  private
  def worklog_params
    params.require(:worklog).permit(:user_id, :typee, :day, :week, :month, :year, 
      tasklogs_attributes: [:id, :project, :responsible, :task_description, :start, :due, :task_log, :schedule, :bottleneck, :_destroy])
  end
end
