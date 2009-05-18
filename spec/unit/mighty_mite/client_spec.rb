require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

def fake_configuration
  File.stub!(:exist?).and_return true
  File.stub!(:read).and_return :yaml_data
  YAML.stub!(:load).and_return({:account => 'demo', :apikey => '123'})
end

describe MightyMite::Client do
  before(:each) do
    fake_configuration
  end

  describe 'new' do
    describe 'configuration file exists' do

      it "should set the account name for Mite" do
        Mite.should_receive(:account=).with 'demo'
        MightyMite::Client.new
      end

      it "should set the apikey for Mite" do
        Mite.should_receive(:key=).with '123'
        MightyMite::Client.new
      end
    end

    describe 'configuration file does not exist' do
      before(:each) do
        File.stub!(:exist?).and_return false
      end

      it "should raise an error if the configuration file is missing" do
        lambda {
          MightyMite::Client.new
        }.should raise_error
      end
    end
  end
    
  describe 'current_time_entry' do
    it "should return the current tracker" do
      Mite::Tracker.stub!(:current).and_return stub('current', :time_entry => :time_entry)
      Mite::Tracker.current.should_receive(:time_entry).and_return :time_entry
      MightyMite::Client.new.current_time_entry.should == :time_entry
    end
    
    it "should return nil if there is no current tracker" do
      Mite::Tracker.stub!(:current).and_return nil
      MightyMite::Client.new.current_time_entry.should == nil
    end
  end

  describe 'projects' do
    it "should return all projects for this user" do
      Mite::Project.should_receive(:all).and_return :projects
      MightyMite::Client.new.projects.should == :projects
    end
    
    it "should cache all projects" do
      Mite::Project.stub!(:all).and_return :projects
      client = MightyMite::Client.new
      client.projects
      Mite::Project.should_not_receive(:all)
      client.projects
    end
  end
  
  describe 'create_project' do
    it "should create a new project for this user" do
      project = stub('project', :save => nil)
      Mite::Project.should_receive(:new).with(:name => 'test', :customer_id => 12).and_return project
      project.should_receive(:save)
      MightyMite::Client.new.create_project(:name => 'test', :customer_id => 12).should == project
    end
  end
  
  describe 'services' do
    it "should return all services for this user" do
      Mite::Service.should_receive(:all).and_return :services
      MightyMite::Client.new.services.should == :services
    end

    it "should cache all services" do
      Mite::Service.stub!(:all).and_return :services
      client = MightyMite::Client.new
      client.services
      Mite::Service.should_not_receive(:all)
      client.services
    end
  end
  
  describe 'create_service' do
    it "should create a new service for this user" do
      service = stub('service', :save => nil)
      Mite::Service.should_receive(:new).with(:name => 'test').and_return service
      service.should_receive(:save)
      MightyMite::Client.new.create_service(:name => 'test').should == service
    end
  end
  
  describe 'customers' do
    it "should return all customers for this user" do
        Mite::Customer.should_receive(:all).and_return :customers
        MightyMite::Client.new.customers.should == :customers
      end

      it "should cache all customers" do
        Mite::Customer.stub!(:all).and_return :customers
        client = MightyMite::Client.new
        client.customers
        Mite::Customer.should_not_receive(:all)
        client.customers
      end
  end
  
  describe 'create_customer' do
    it "should create a new customer for this user" do
      customer = stub('customer', :save => nil)
      Mite::Customer.should_receive(:new).with(:name => 'test').and_return customer
      customer.should_receive(:save)
      MightyMite::Client.new.create_customer(:name => 'test').should == customer
    end
  end
  
  describe 'time_entries' do
    it "should return all time_entries for this user" do
      Mite::TimeEntry.should_receive(:all).and_return :time_entries
      MightyMite::Client.new.time_entries.should == :time_entries
    end

    it "should cache all time_entries" do
      Mite::TimeEntry.stub!(:all).and_return :time_entries
      client = MightyMite::Client.new
      client.time_entries
      Mite::TimeEntry.should_not_receive(:all)
      client.time_entries
    end
    
    describe 'specific params' do
      it "should pass the params" do
        Mite::TimeEntry.should_receive(:all).with(:params => {:id => 12})
        MightyMite::Client.new.time_entries(:id => 12)
      end
      
      it "should cache per param" do
        Mite::TimeEntry.stub!(:all).and_return :time_entries
        client = MightyMite::Client.new
        client.time_entries
        Mite::TimeEntry.should_receive(:all).with(:params => {:project_id => 123})
        client.time_entries(:project_id => 123)
        Mite::TimeEntry.should_not_receive(:all)
        client.time_entries(:project_id => 123)
      end
    end
    
    describe 'force_reload' do
      it "should reload the cache" do
        Mite::TimeEntry.stub!(:all).and_return :time_entries
        client = MightyMite::Client.new
        client.time_entries.should == :time_entries
        Mite::TimeEntry.stub!(:all).and_return :more_time_entries
        client.time_entries(:force_reload => true).should == :more_time_entries
      end
    end
  end
  
  describe 'create_time_entry' do
    it "should create a new time_entry for this user" do
      time_entry = stub('time_entry', :save => nil)
      Mite::TimeEntry.should_receive(:new).with(:name => 'test', :project_id => 12, :service_id => 13).and_return time_entry
      time_entry.should_receive(:save)
      MightyMite::Client.new.create_time_entry(:name => 'test', :project_id => 12, :service_id => 13).should == time_entry
    end
  end
end