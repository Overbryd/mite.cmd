module MightyMite
  class Application
    TIME_FORMAT = /^(\d+(\.\d+)?:?\+?)|(\d+:\d+\+?)|\+$/
    FLIRTS = [
      'I like your hairstyle.', 'What a nice console you have.', 'My favorite color is red on black, monospaced.',
      "What a lovely operation system this #{`uname`} is.", 'What about dinner tonight?', 'Your keystrokes are tingling.'
    ]
    
    def initialize(arguments=[])
      @arguments = arguments
      MightyMite.load_configuration unless ['configure', 'help'].include?(arguments.first)
    end
    
    def run
      if @arguments.first == 'open'
        open_or_echo Mite.account_url
        
      elsif @arguments.first == 'help'
        open_or_echo 'http://github.com/Overbryd/mighty-mite'
        
      elsif @arguments.first == 'configure'
        raise MightyMite::Exception.new('mite configure needs two arguments, the account name and the apikey') if @arguments.size < 3 # lol boobs, err... an ice cone!
        write_configuration({:account => @arguments[1], :apikey => @arguments[2]})
        tell("Couldn't set up bash completion. I'm terribly frustrated. Maybe 'mite help' helps out.") unless try_to_setup_bash_completion
        
      elsif @arguments.first == 'auto-complete'
        autocomplete = MightyMite::Autocomplete.new(MightyMite.calling_script)
        autocomplete.completion_table = if File.exist?(cache_file)
          Marshal.load File.read(cache_file)
        else
          rebuild_completion_table
        end
        autocomplete.suggestions.map(&:quote_if_spaced).each { |s| tell s }
        
      elsif @arguments.first == 'rebuild-cache'
        File.delete(cache_file) if File.exist? cache_file
        rebuild_completion_table
        tell 'The rebuilding of the cache has been done, Master. Your wish is my command.'
        
      elsif ['today', 'yesterday', 'this_week', 'last_week', 'this_month', 'last_month'].include? @arguments.first
        total_revenue = Mite::TimeEntry.all(:params => {:at => @arguments.first, :user_id => 'current'}).each do |time_entry|
          tell time_entry.inspect
        end.map(&:revenue).compact.sum
        tell ("%.2f $" % (total_revenue/100)).colorize(:lightgreen)
        
      elsif ['stop', 'pause', 'lunch'].include? @arguments.first
        if current_tracker = (Mite::Tracker.current ? Mite::Tracker.current.stop : nil)
          tell current_tracker.time_entry.inspect
        end
        
      elsif @arguments.first == 'start'
        if time_entry = Mite::TimeEntry.first(:params => {:at => 'today'})
          time_entry.start_tracker
          tell time_entry.inspect
        else
          tell "Oh my dear! I tried hard, but I could'nt find any time entry for today."
        end
      
      elsif (1..4).include?(@arguments.size)
        attributes = {}
        if time_string = @arguments.select { |a| a =~ TIME_FORMAT }.first
          attributes[:minutes] = parse_minutes(time_string) unless time_string == '+'
          start_tracker = (time_string =~ /\+$/)
        end
        if project = find_or_create_project(@arguments.first)
          attributes[:project_id] = project.id
        end
        if @arguments[1] && service = find_or_create_service(@arguments[1])
          attributes[:service_id] = service.id
        end
        if note = parse_note(@arguments, time_string)
          attributes[:note] = note
        end
        time_entry = Mite::TimeEntry.create attributes
        time_entry.start_tracker if start_tracker
        tell time_entry.inspect
        
      elsif @arguments.size == 0
        tell Mite::Tracker.current ? Mite::Tracker.current.inspect : flirt
      end
    end
    
    def say(what)
      puts what
    end
    alias_method :tell, :say
    
    def flirt
      FLIRTS[rand(FLIRTS.size)]
    end
    
    private
    
    def find_or_create_project(name)
      project = Mite::Project.first(:params => {:name => name})
      return nil if name =~ TIME_FORMAT
      project ? project : Mite::Project.create(:name => name)
    end
    
    def find_or_create_service(name)
      service = Mite::Service.first(:params => {:name => name})
      return nil if name =~ TIME_FORMAT
      service ? service : Mite::Service.create(:name => name)
    end

    def parse_note(args, time_string)
      if args[3]
        args[3]
      elsif time_string.nil? && args[2]
        args[2]
      elsif time_string && args[args.index(time_string)+1]
        args[args.index(time_string)+1]
      else
        nil
      end
    end

    def parse_minutes(string)
      string = string.sub(/\+$/, '')
      if string =~ /^\d+:\d+$/
        string.split(':').first.to_i*60 + string.split(':').last.to_i
      elsif string =~ /^\d+(\.\d+)?:?$/
        (string.to_f*60).to_i
      end
    end
    
    def rebuild_completion_table
      completion_table = {
        0 => Mite::Project.all.map(&:name),
        1 => Mite::Service.all.map(&:name),
        2 => ['0:05', '0:05+', '0:15', '0:15+', '0:30', '0:30+', '1:00', '1:00+'].map(&:quote),
        3 => Mite::TimeEntry.all.map(&:note).compact
      }
      File.open(cache_file, 'w') { |f| Marshal.dump(completion_table, f) }
      completion_table
    end
    
    def cache_file
      File.expand_path('~/.mite.cache')
    end
    
    def open_or_echo(open_argument)
      exec "open '#{open_argument}' || echo '#{open_argument}'"
    end
    
    def write_configuration(config)
      File.open(File.expand_path('~/.mite.yml'), 'w') do |f|
        YAML.dump(config, f)
      end
    end
    
    def try_to_setup_bash_completion
      bash_code = "\n\n#{MightyMite::BASH_COMPLETION}"
      
      ['~/.bash_completion', '~/.bash_profile', '~/.bash_login', '~/.bashrc'].each do |file|
        bash_config_file = File.expand_path file
        next unless File.exist?(bash_config_file)
        unless File.read(bash_config_file) =~ /#{bash_code}/
          File.open(bash_config_file, 'a') do |f|
            f.puts bash_code
          end
          return true
        end
      end
      return false
    end
    
  end
end