require 'rails_helper'

module InitEventTaskx
  RSpec.describe EventTask, type: :model do
    it "should be OK" do
      c = FactoryGirl.build(:init_event_taskx_event_task)
      expect(c).to be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:init_event_taskx_event_task, :name => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil task category" do
      c = FactoryGirl.build(:init_event_taskx_event_task, :task_category => nil)
      expect(c).not_to be_valid
    end
  end
end
