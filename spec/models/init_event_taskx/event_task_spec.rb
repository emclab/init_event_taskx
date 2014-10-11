require 'spec_helper'

module InitEventTaskx
  describe EventTask do
    it "should be OK" do
      c = FactoryGirl.build(:init_event_taskx_event_task)
      c.should be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:init_event_taskx_event_task, :name => nil)
      c.should_not be_valid
    end
    
    it "should reject nil task category" do
      c = FactoryGirl.build(:init_event_taskx_event_task, :task_category => nil)
      c.should_not be_valid
    end
  end
end
