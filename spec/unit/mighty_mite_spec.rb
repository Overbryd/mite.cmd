require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MightyMite, 'load_configuration' do
  def fake_configuration
    File.stub!(:exist?).and_return true
    File.stub!(:read).and_return :yaml_data
    YAML.stub!(:load).and_return({:account => 'demo', :apikey => '123'})
  end
  
  describe 'configuration file exists' do
    before(:each) do
      fake_configuration
    end
    
    it "should set the account name for Mite" do
      Mite.should_receive(:account=).with 'demo'
      MightyMite.load_configuration
    end

    it "should set the apikey for Mite" do
      Mite.should_receive(:key=).with '123'
      MightyMite.load_configuration
    end
  end

  describe 'configuration file does not exist' do
    before(:each) do
      File.stub!(:exist?).and_return false
    end

    it "should raise an error if the configuration file is missing" do
      lambda {
        MightyMite.load_configuration
      }.should raise_error
    end
  end
end

describe MightyMite, 'run' do
  it "should create a new instance of the Application class using the given arguments" do
    MightyMite::Application.should_receive(:new).with(['arg1', 'arg2']).and_return stub('application', :run => nil)
    MightyMite.run(['arg1', 'arg2'])
  end
  
  it "should call run on the new instance" do
    application = stub('application')
    MightyMite::Application.stub!(:new).and_return application
    application.should_receive :run
    MightyMite.run([])
  end
end