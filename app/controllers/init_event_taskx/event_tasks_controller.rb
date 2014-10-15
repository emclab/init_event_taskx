require_dependency "init_event_taskx/application_controller"

module InitEventTaskx
  class EventTasksController < ApplicationController
    before_filter :require_employee
    before_filter :load_params
        
    def index
      @title = t('Event Tasks')
      @event_tasks = params[:init_event_taskx_event_tasks][:model_ar_r]  #returned by check_access_right
      @event_tasks = @event_tasks.where('TRIM(init_event_taskx_event_tasks.task_category) = ?', @task_category) if @task_category
      @event_tasks = @event_tasks.page(params[:page]).per_page(@max_pagination) 
      @erb_code = find_config_const('event_task_index_view', 'init_event_taskx')
    end
  
    def new
      @title = t('New Event Task')
      @event_task = InitEventTaskx::EventTask.new()
      #@task_category = params[:task_category].strip if params[:task_category].present?
      @erb_code = find_config_const('event_task_new_view', 'init_event_taskx')
    end
  
    def create
      @event_task = InitEventTaskx::EventTask.new(params[:event_task], :as => :role_new)
      @event_task.last_updated_by_id = session[:user_id]
      @event_task.requested_by_id = session[:user_id]
      if @event_task.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @task_category = params[:event_task][:task_category].strip if params[:event_task].present? && params[:event_task][:task_category].present?
        @erb_code = find_config_const('event_task_new_view', 'init_event_taskx')
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update Event Task')
      @event_task = InitEventTaskx::EventTask.find_by_id(params[:id])
      @erb_code = find_config_const('event_task_edit_view', 'init_event_taskx')
    end
  
    def update
      @event_task = InitEventTaskx::EventTask.find_by_id(params[:id])
      @event_task.last_updated_by_id = session[:user_id]
      if @event_task.update_attributes(params[:event_task], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        @erb_code = find_config_const('event_task_edit_view', 'init_event_taskx')
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('Show Event Task')
      @event_task = InitEventTaskx::EventTask.find_by_id(params[:id])
      @erb_code = find_config_const('event_task_show_view', 'init_event_taskx')
    end
    
    protected
    def load_params
      @task_category = params[:task_category].strip if params[:task_category].present?
    end
  end
end
