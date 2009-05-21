require File.dirname(__FILE__) + '/../../spec_helper'

describe MightyMite::Application, 'new' do
  it "should load the configuration for MightyMite" do
    MightyMite.should_receive(:load_configuration)
    MightyMite::Application.new []
  end
  
  it "should not load the configuration if the first argument is 'configure'" do
    MightyMite.should_not_receive(:load_configuration)
    MightyMite::Application.new ['configure']
  end
  
  it "should set arguments" do
    MightyMite.stub!(:load_configuration)
    MightyMite::Application.new(['1', '2', '3']).instance_variable_get('@arguments').should == ['1', '2', '3']
  end
end

describe MightyMite::Application, 'run' do
  before(:each) do
    MightyMite.stub!(:load_configuration)
  end
  
  describe 'no argument' do
    before(:each) do
      @application = MightyMite::Application.new []
      @application.stub!(:say)
      @application.stub!(:flirt).and_return 'Your beautiful eyes touch my heart.'
    end
        
    it "should tell the inspection of the current tracker if there is one" do    
      tracker = stub('tracker', :inspect => 'I am the inspection of this tracker')
      Mite::Tracker.stub!(:current).and_return tracker
      @application.should_receive(:tell).with 'I am the inspection of this tracker'
      @application.run
    end
    
    it "should tell something romantic if there is no current tracker" do
      Mite::Tracker.stub!(:current).and_return nil
      @application.should_receive(:tell).with 'Your beautiful eyes touch my heart.'
      @application.run
    end
  end
  
  describe 'the open argument' do
    it "should try to open the account url or at least echo it" do
      Mite.stub!(:account_url).and_return 'http://demo.mite.yo.lk'
      application = MightyMite::Application.new ['open']
      application.should_receive(:exec).with "open 'http://demo.mite.yo.lk' || echo 'http://demo.mite.yo.lk'"
      application.run
    end
  end
  
  describe 'the help argument' do
    it "should try to open the github repository of mighty mite or at least echo it" do
      application = MightyMite::Application.new ['help']
      application.should_receive(:exec).with "open 'http://github.com/Overbryd/mighty-mite' || echo 'http://github.com/Overbryd/mighty-mite'"
      application.run
    end
  end
  
  describe 'the configure argument' do
    before(:each) do
      @application = MightyMite::Application.new ['configure', 'demo', '123']
      @application.stub!(:tell)
    end
    
    it "should generate a yaml formatted file in ~/.mite.yml with the account and the apikey" do
      File.stub!(:expand_path).and_return '/tmp/.mite.yml'
      File.should_receive(:open).with('/tmp/.mite.yml', 'w').and_yield :file_handle
      YAML.should_receive(:dump).with({:account => 'demo', :apikey => '123'}, :file_handle)
      @application.run
    end
    
    it "should tell something nice if the bash completion setup fails" do
      @application.stub!(:try_to_setup_bash_completion).and_return false
      @application.should_receive(:tell).with "Could't set up bash completion. I'm terribly frustrated. Maybe 'mite help' helps out."
      
      File.stub!(:open) # prevents the yml file to be written
      @application.run
    end
    
    describe 'and setup bash completion' do
      it "should append the bash completion call for mite to ~/.bash_completion if it exists and return true" do
        File.stub!(:expand_path).and_return '/tmp/.bash_completion'
        File.should_receive(:exist?).with('/tmp/.bash_completion').and_return true
        file_handle = stub('file_handle')
        File.should_receive(:open).with('/tmp/.bash_completion', 'a').and_yield file_handle
        file_handle.should_receive(:puts).with("\n\ncomplete -C \"mite auto-complete\" mite")
        
        File.stub!(:read).and_return ''
        @application.send(:try_to_setup_bash_completion).should == true
      end
      
      it "should try '~/.bash_completion', '~/.bash_profile', '~/.bash_login', '~/.bashrc'" do
        files = ['~/.bash_completion', '~/.bash_profile', '~/.bash_login', '~/.bashrc']
        files_regexp = files.map {|f| Regexp.escape(f)}.join('|')
        File.should_receive(:expand_path).with(
          Regexp.new(files_regexp)
        ).exactly(files.size).times
        
        File.stub!(:exist?).and_return false
        @application.send :try_to_setup_bash_completion
      end
      
      it "should not open a file handle if the file does not exist" do
        File.stub!(:exist?).and_return false
        File.should_not_receive(:open)
        @application.send :try_to_setup_bash_completion
      end
      
      it "should not append the bash completion call twice" do
        File.stub!(:read).and_return "\n\ncomplete -C \"mite auto-complete\" mite"
        File.should_not_receive(:open)
        @application.send :try_to_setup_bash_completion
      end
      
      it "should return false if the bash completion could not be set up" do
        File.stub!(:exist?).and_return false
        @application.send(:try_to_setup_bash_completion).should == false
      end
    end
    
    it "should raise an error if one of the last two arguments is missing" do
      application = MightyMite::Application.new ['configure', 'faildemo']
      lambda {
        application.run
      }.should raise_error(MightyMite::Exception)
    end
  end
  
  describe 'the auto-complete argument' do
    before(:each) do
      @application = MightyMite::Application.new ['auto-complete']
      @application.stub!(:tell)
      
      @autocomplete = stub('autocomplete', :completion_table => {}, :completion_table= => nil, :suggestions => [])
      MightyMite::Autocomplete.stub!(:new).and_return @autocomplete
    end
    
    it "should create a new instance of MightyMite::Autocomplete setting the calling_script" do
      MightyMite.stub!(:calling_script).and_return '/usr/local/bin/mite'
      MightyMite::Autocomplete.should_receive(:new).with '/usr/local/bin/mite'
      @application.run
    end

    it "should unmarshal the cached completion table from ~/.mite.cache if it exists" do
      File.stub!(:exist?).and_return true
      File.should_receive(:read).and_return :marshal_data
      Marshal.should_receive(:load).and_return :cached_completion_table
      @autocomplete.should_receive(:completion_table=).with :cached_completion_table
      @autocomplete.stub!(:suggestions).and_return []
      @application.run
    end
    
    it "should tell each suggestion from MightyMite::Autocomplete" do
      File.stub!(:exist?).and_return true
      File.stub!(:read)
      Marshal.stub!(:load)
      @autocomplete.stub!(:suggestions).and_return ['Heinz', 'Peter']
      @application.should_receive(:tell).with(/Heinz|Peter/).exactly(2).times
      @application.run
    end

    shared_examples_for 'an uncached completion table' do
      before(:each) do
        File.stub!(:exist?).and_return false
        
        Mite::Project.stub!(:all).and_return [stub('project', :name => 'Demo Project')]
        Mite::Service.stub!(:all).and_return [stub('service', :name => 'late night programming')]
        Mite::TimeEntry.stub!(:all).and_return [stub('time entry', :note => 'shit 02:13 is really late')]
        
        @completion_table = {
          0 => ['Demo Project'],
          1 => ['late night programming'],
          2 => ['"0:05"', '"0:05+"', '"0:15"', '"0:15+"', '"0:30"', '"0:30+"', '"1:00"', '"1:00+"'],
          3 => ['shit 02:13 is really late']
        }
      end

      it "should create a new completion table" do
        File.stub!(:open)
        @application.send(:rebuild_completion_table).should == @completion_table
      end

      it "should save the new completion table to ~/.mite.cache" do
        File.stub!(:expand_path).and_return '/tmp/.mite.cache'
        File.should_receive(:open).with('/tmp/.mite.cache', 'w').and_yield :file_handle
        Marshal.should_receive(:dump).with(@completion_table, :file_handle)
        @application.run
      end
    end
    
    describe 'and the completion table is not cached' do
      it_should_behave_like 'an uncached completion table'
    end
    
  end

  describe 'the rebuild-cache argument' do
    before(:each) do
      @application = MightyMite::Application.new ['rebuild-cache']
      @application.stub!(:tell)
    end
    
    it "should delete the file at ~/.mite.cache if it exists" do
      File.stub!(:exist?).and_return true
      File.stub!(:expand_path).and_return '/tmp/.mite.cache'
      File.should_receive(:delete).with '/tmp/.mite.cache'
      @application.run
    end
    
    it "should not call delete on File if ~/.mite.cache does not exist" do
      File.stub!(:exist?).and_return false
      File.should_not_receive(:delete)
      @application.run
    end
    
    it "should tell something nice if the cache has been rebuild" do
      @application.should_receive(:tell).with 'The rebuilding of the cache has been done, Master. Your wish is my command.'
      @application.run
    end
    
    it_should_behave_like 'an uncached completion table'
  end
  
  describe 'the simple report argument' do
    shared_examples_for 'a simple report' do
      before(:each) do
        @application = MightyMite::Application.new [@argument]
        @application.stub!(:tell)

        @time_entry = stub('time_entry', :inspect => 'I am a time entry.', :revenue => 1200)
        @time_entry_with_nil_revenue = stub('time_entry_without_revenue', :inspect => 'I am a time entry.', :revenue => nil)
        @time_entry_with_nil_revenue.stub!(:revenue).and_return nil
        Mite::TimeEntry.stub!(:all).and_return [@time_entry, @time_entry, @time_entry_with_nil_revenue]
      end

      it "should tell an inspection of each time entry" do
        Mite::TimeEntry.should_receive(:all).with(:params => hash_including(:at => @argument))
        @time_entry.should_receive(:inspect).exactly(2).times
        @time_entry_with_nil_revenue.should_receive(:inspect).at_least(:once)
        @application.should_receive(:tell).with('I am a time entry.').exactly(3).times
        @application.run
      end
      
      it "should only output the time entries of the current user" do
        Mite::TimeEntry.should_receive(:all).with(:params => hash_including(:user_id => 'current'))
        @application.run
      end
      
      it "should tell #{@argument}'s revenue, nicely formatted and colorized in lightgreen" do
        @application.should_receive(:tell).with("\e[1;32;49m2400.00 $\e[0m").at_least(:once)
        @application.run
      end
    end
    
    ['today', 'yesterday', 'this_week', 'last_week', 'this_month', 'last_month'].each do |argument|
      describe argument do
        before(:each) { @argument = argument }
        it_should_behave_like 'a simple report'
      end
    end
  end
  
  describe 'the stop argument' do
    before(:each) do
      @application = MightyMite::Application.new ['stop']
      @application.stub!(:tell)
      
      time_entry = stub('time_entry', :inspect => 'hey there.')
      @current_tracker = stub('tracker', :time_entry => time_entry)
      @current_tracker.stub!(:stop).and_return @current_tracker
      Mite::Tracker.stub!(:current).and_return @current_tracker
    end
    
    it "should call stop on the current tracker" do
      @current_tracker.should_receive :stop
      @application.run
    end
    
    it "should do nothing if there is no current tracker" do
      Mite::Tracker.stub!(:current).and_return nil
      @application.run
    end
    
    it "should tell the inspection of the tracker's time entry if it has been stopped" do
      @application.should_receive(:tell).with 'hey there.'
      @application.run
    end
  end

  describe 'the start argument' do
    before(:each) do
      @application = MightyMite::Application.new ['start']
      @application.stub!(:tell)
      
      @time_entry = stub('time_entry', :start_tracker => nil, :inspect => 'I was started.')
      Mite::TimeEntry.stub!(:first).and_return @time_entry
    end
  
    it "should call start_tracker on the last time entry of today" do
      # last time entry by time = first by list order
      Mite::TimeEntry.should_receive(:first).with(:params => {:at => 'today'})
      @time_entry.should_receive(:start_tracker)
      @application.run
    end
    
    it "should tell an inspection of the last time entry if it has been started" do
      @application.should_receive(:tell).with 'I was started.'
      @application.run
    end
    
    it "should tell something nice if there is no time entry to start" do
      Mite::TimeEntry.stub!(:first).and_return nil
      @application.should_receive(:tell).with "Oh my dear! I tried hard, but I could'nt find any time entry for today."
      @application.run
    end
  end

end

describe MightyMite::Application, 'dynamic time entry creation' do
  before(:each) do
    MightyMite.stub!(:load_configuration)
    
    @time_entry = stub('time_entry', :start_tracker => nil, :inspect => '')
    Mite::TimeEntry.stub!(:create).and_return @time_entry
    Mite::Project.stub! :first
    Mite::Project.stub! :create
    Mite::Service.stub! :first
    Mite::Service.stub! :create
  end
  
  def new_application(args=[])
    application = MightyMite::Application.new args
    application.stub!(:tell)
    application
  end
  
  it "should tell an inspection of the time entry" do
    @time_entry.stub!(:inspect).and_return 'My name is entry, time entry.'
    application = new_application(['Project', 'Service', 'Note'])
    application.should_receive(:tell).with 'My name is entry, time entry.'
    application.run
  end
  
  describe 'the + argument' do
    it "should create and start a new time entry" do
      time_entry = stub('time_entry')
      Mite::TimeEntry.should_receive(:create).and_return time_entry
      time_entry.should_receive :start_tracker
      new_application(['+']).run
    end
  end
  
  describe 'with a time given' do
    it "should parse minutes as integer out of h:mm(+)?" do
      new_application.send(:parse_minutes, '1:18').should == 78
      new_application.send(:parse_minutes, '72:00').should == 4320
      new_application.send(:parse_minutes, '0:01+').should == 1
    end
    
    it "should parse minutes as integer out of h(:)?(+)?" do
      new_application.send(:parse_minutes, '3').should == 180
      new_application.send(:parse_minutes, '2:').should == 120
      new_application.send(:parse_minutes, '1.5').should == 90
      new_application.send(:parse_minutes, '2.5+').should == 150
      new_application.send(:parse_minutes, '5:').should == 300
      new_application.send(:parse_minutes, '1:+').should == 60
      new_application.send(:parse_minutes, '0.5:').should == 30
    end
    
    it "should parse minutes as nil out of +" do
      new_application.send(:parse_minutes, '+').should == nil
    end
    
    it "should add the parsed minutes to the attributes" do
      Mite::TimeEntry.should_receive(:create).with hash_including(:minutes => 78)
      new_application(['ARG1', 'ARG2', '1:18', 'ARG4']).run
    end
    
    it "should start the tracker for the time entry if the attributes is suffixed with '+'" do
      @time_entry.should_receive(:start_tracker)
      new_application(['ARG1', 'ARG2', '1:18+', 'ARG4']).run
    end
  end
  
  describe 'with a project name given' do
    before(:each) do
      @project = stub('project', :id => 1)
      Mite::Project.stub!(:first).and_return @project
    end
    
    it "should try if the first argument is an existing project" do
      Mite::Project.should_receive(:first).with(:params => {:name => 'Project No1'})
      new_application(['Project No1']).run
    end
    
    it "should add the project id to the attributes if a project was found" do
      Mite::TimeEntry.should_receive(:create).with hash_including(:project_id => 1)
      new_application(['Project No1']).run
    end
    
    it "should create a new project unless a project was found" do
      Mite::Project.stub!(:first).and_return nil
      @project.stub!(:id).and_return 1234
      Mite::Project.stub!(:create).and_return @project
      Mite::TimeEntry.should_receive(:create).with hash_including(:project_id => 1234)
      new_application(['I do not exist']).run
    end
    
    it "should not create a new project if the first argument is a time argument" do
      Mite::Project.stub!(:first).and_return nil
      Mite::Project.should_not_receive(:create)
      new_application(['1:11+']).run
    end
  end
  
  describe "with a service name given" do
    before(:each) do
      @service = stub('service', :id => 2)
      Mite::Service.stub!(:first).and_return @service
    end
    
    it "should try if the second argument is an existing service" do
      Mite::Service.should_receive(:first).with(:params => {:name => 'Carwashing'})
      new_application(['1', 'Carwashing']).run
    end
    
    it "should add the service id to the attributes if a service was found" do
      Mite::TimeEntry.should_receive(:create).with hash_including(:service_id => 2)
      new_application(['1', 'Read a book']).run
    end
    
    it "should not add the service id to the attributes unless a service was found" do
      Mite::Service.stub!(:first).and_return nil
      Mite::TimeEntry.should_not_receive(:create).with hash_including(:service_id => 2)
      new_application(['1', 'Write a book']).run
    end
    
    it "should create a new service unless a service was found" do
      Mite::Service.stub!(:first).and_return nil
      @service.stub!(:id).and_return 15
      Mite::Service.stub!(:create).and_return @service
      Mite::TimeEntry.should_receive(:create).with hash_including(:service_id => 15)
      new_application(['1', 'I do not exist yet']).run
    end
    
    it "should not create a new service if the second argument is a time argument" do
      Mite::Service.stub!(:first).and_return nil
      Mite::Service.should_not_receive(:create)
      new_application(['1', '0:18']).run
    end
    
    it "should do nothing on services if there is no second argument" do
      application = new_application(['1'])
      application.should_not_receive :find_or_create_service
      application.run
    end
  end
  
  describe "with a note given" do
    it "should parse the note out of the arguments" do
      new_application.send(:parse_note, ['0:12', 'gnarr gnarr'], '0:12').should == 'gnarr gnarr'
      new_application.send(:parse_note, ['1', '1:30+', 'bla bla'], '1:30+').should == 'bla bla'
      new_application.send(:parse_note, ['Project', 'Service', 'NOTE!'], nil).should == 'NOTE!'
    end
    
    it "should add the note to the attributes if the fourth argument is given" do
      Mite::TimeEntry.should_receive(:create).with hash_including(:note => 'Reminder')
      new_application(['ARG1', 'ARG2', '3+', 'Reminder']).run
    end
    
    it "should add the note to the attributes if it is third argument and no time is given" do
      Mite::TimeEntry.should_receive(:create).with hash_including(:note => 'bla bla')
      new_application(['ARG1', 'ARG2', 'bla bla']).run
    end
    
    it "should add the note to the attributes if a time argument is followed by a note" do
      Mite::TimeEntry.should_receive(:create).with hash_including(:note => 'gnarr gnarr')
      new_application(['1:02', 'gnarr gnarr']).run
      Mite::TimeEntry.should_receive(:create).with hash_including(:note => 'glubb glubb')
      new_application(['ARG1', '3:04', 'glubb glubb']).run
    end
  end
end

describe MightyMite::Application, 'flirt' do
  before(:each) do
    MightyMite.stub!(:load_configuration)
  end
  
  it "should return a random flirt as string" do
    MightyMite::Application.new.flirt.should be_kind_of(String)
  end
end