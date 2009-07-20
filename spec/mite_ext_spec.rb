require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Mite, 'account_url' do
  it "should return the url for this account" do
    Mite.account = 'demo'
    Mite.account_url.should == 'http://demo.mite.yo.lk'
  end
end

describe Mite::TimeEntry, 'formatted_time' do
  it "should output minutes formatted in h:mm" do
    time_entry = Mite::TimeEntry.new
    time_entry.stub!(:minutes).and_return 12
    time_entry.formatted_time.should == '0:12'
    time_entry.stub!(:minutes).and_return 2
    time_entry.formatted_time.should == '0:02'
    time_entry.stub!(:minutes).and_return 61
    time_entry.formatted_time.should == '1:01'
  end
  
  it "should use the minutes from the tracker if there is a tracker running for this time entry" do
    time_entry = Mite::TimeEntry.new
    time_entry.stub!(:tracking?).and_return true
    time_entry.stub!(:tracker).and_return stub('tracking', :minutes => 123)
    time_entry.formatted_time.should == '2:03'
  end
end

describe Mite::TimeEntry, 'formatted_revenue' do
  it "should output the revenue in a readable money format" do
    time_entry = Mite::TimeEntry.new
    time_entry.stub!(:revenue).and_return 1050
    time_entry.formatted_revenue.should == '10.50 $'
  end
  
  it "should output an empty string if revenue is nil" do
    time_entry = Mite::TimeEntry.new
    time_entry.revenue = nil
    time_entry.formatted_revenue.should == ''
  end
end

describe Mite::TimeEntry, 'inspect' do
  before(:each) do
    @time_entry = Mite::TimeEntry.new
  end
  
  describe 'with time' do
    before(:each) do
      @time_entry.stub!(:minutes).and_return 15
      @time_entry.stub!(:revenue).and_return nil
      @time_entry.stub!(:service).and_return nil
      @time_entry.stub!(:project).and_return nil
      @time_entry.stub!(:note).and_return nil
    end
    
    it "should output the current formatted_minutes colorized in lightred" do
      @time_entry.inspect.should == "\e[1;31;49m0:15\e[0m"
    end
    
    describe 'and revenue' do
      it "should append the current formatted_revenue colorized in lightgreen" do
        @time_entry.stub!(:revenue).and_return 1500
        @time_entry.inspect.should be_include("\e[1;32;49m15.00 $\e[0m")
      end
    end
    
    describe 'and service' do
      it "should append the service name" do
        @time_entry.stub!(:service).and_return stub('service', :name => 'programming')
        @time_entry.inspect.should be_include("doing programming")
      end
    end
    
    describe 'and project' do
      it "should append the project name" do
        @time_entry.stub!(:project).and_return stub('project', :name => 'mite command line client')
        @time_entry.inspect.should be_include("for mite command line client")
      end
    end
    
    describe 'and a note' do
      it "should append the note" do
        @time_entry.stub!(:note).and_return 'would be more fun in pair programming'
        @time_entry.inspect.should be_include("would be more fun in pair programming")
      end
    end
    
  end
end

describe Mite::Tracker, 'inspect' do
  it "should call inspect on its time entry" do
    time_entry = stub('time_entry')
    Mite::TimeEntry.stub!(:find).and_return time_entry
    time_entry.should_receive(:inspect)
    Mite::Tracker.new.inspect
  end
end