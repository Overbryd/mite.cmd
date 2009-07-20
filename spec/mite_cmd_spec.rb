require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe MiteCmd, 'load_configuration' do
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
      MiteCmd.load_configuration
    end

    it "should set the apikey for Mite" do
      Mite.should_receive(:key=).with '123'
      MiteCmd.load_configuration
    end
  end

  describe 'configuration file does not exist' do
    before(:each) do
      File.stub!(:exist?).and_return false
    end

    it "should raise an error if the configuration file is missing" do
      lambda {
        MiteCmd.load_configuration
      }.should raise_error
    end
  end
end

describe MiteCmd, 'run' do
  it "should create a new instance of the Application class using the given arguments" do
    MiteCmd::Application.should_receive(:new).with(['arg1', 'arg2']).and_return stub('application', :run => nil)
    MiteCmd.run(['arg1', 'arg2'])
  end
  
  it "should call run on the new instance" do
    application = stub('application')
    MiteCmd::Application.stub!(:new).and_return application
    application.should_receive :run
    MiteCmd.run([])
  end
end