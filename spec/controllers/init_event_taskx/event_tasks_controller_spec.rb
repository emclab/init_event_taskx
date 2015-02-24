require 'rails_helper'

module InitEventTaskx
  RSpec.describe EventTasksController, type: :controller do
    routes {InitEventTaskx::Engine.routes}
    before(:each) do
      expect(controller).to receive(:require_signin)
      expect(controller).to receive(:require_employee)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      
    end
    
    before(:each) do
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      @task_sta = FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'task_status')  
    end
    
    render_views
    
    describe "GET 'index'" do
      it "returns tasks" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'init_event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "InitEventTaskx::EventTask.where(:cancelled => false).order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:init_event_taskx_event_task, :task_status_id => @task_sta.id, :task_category => 'test')
        task1 = FactoryGirl.create(:init_event_taskx_event_task, :task_status_id => @task_sta.id, :name => 'a new task', :task_category => 'test')
        get 'index', {:use_route => :init_event_taskx}
        expect(assigns(:event_tasks)).to match_array([task, task1])
      end
      
      it "should return the task for the task_category" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'init_event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "InitEventTaskx::EventTask.where(:cancelled => false).order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:init_event_taskx_event_task, :task_status_id => @task_sta.id, :task_category => 'production')
        task1 = FactoryGirl.create(:init_event_taskx_event_task, :task_status_id => @task_sta.id, :name => 'a new task', :task_category => 'test')
        get 'index', {:task_category => 'production'}
        expect(assigns(:event_tasks)).to match_array([task])
      end
    end
  
    describe "GET 'new'" do
      it "returns bring up new page with task_category" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'init_event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new', {:task_category => 'production', :resource_id => 100, :resource_string => 'event_taskx/event_tasks'}
        expect(response).to be_success
        expect(assigns[:task_category]).to eq('production')
      end
      
      it "should bring up new page without task_category" do        
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'init_event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new', {:resource_id => 100, :resource_string => 'event_taskx/event_tasks'}
        expect(response).to be_success
         
      end
    end
  
    describe "GET 'create'" do
      it "should create and redirect after successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'init_event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.attributes_for(:init_event_taskx_event_task, :task_status_id => @task_sta.id )  
        get 'create', {:event_task => task}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render 'new' if data error" do        
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'init_event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.attributes_for(:init_event_taskx_event_task, :task_status_id => @task_sta.id, :name => nil)
        get 'create', {:event_task => task}
        expect(response).to render_template('new')
      end
    end
  
    describe "GET 'edit'" do
      it "returns edit page" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'init_event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:init_event_taskx_event_task, :task_status_id => @task_sta.id, :task_category => 'production')
        get 'edit', {:id => task.id}
        expect(response).to be_success
      end
    end
  
    describe "GET 'update'" do
      it "should return success and redirect" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'init_event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:init_event_taskx_event_task, :task_status_id => @task_sta.id, :task_category => 'production')
        get 'update', {:id => task.id, :event_task => {:name => 'new name'}}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'init_event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:init_event_taskx_event_task, :task_status_id => @task_sta.id, :task_category => 'production')
        get 'update', {:id => task.id, :event_task => {:name => ''}}
        expect(response).to render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'init_event_taskx_event_tasks', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.executioner_id == session[:user_id]")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:init_event_taskx_event_task, :task_status_id => @task_sta.id, :task_category => 'production', :executioner_id => @u.id)
        get 'show', {:id => task.id}
        expect(response).to be_success
      end
    end
  
  end
end
