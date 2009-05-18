module MightyMite
  class Client
    CONFIG_FILE = File.expand_path("~/.mite.yml")
  
    def initialize
      if File.exist?(CONFIG_FILE)
        configuration = YAML.load(File.read(CONFIG_FILE))
        Mite.account = configuration[:account]
        Mite.key = configuration[:apikey]
      else
        raise MightyMite::Exception.new("Configuration file is missing.")
      end
    end
  
    def current_time_entry
      Mite::Tracker.current.nil? ? nil : Mite::Tracker.current.time_entry
    end
  
    def projects(params={})
      @projects ||= {}
      force_reload = !!params.delete(:force_reload)
      cache_key = params.blank? ? :blank : params
      if force_reload
        @projects[cache_key] = Mite::Project.all(:params => params)
      else
        @projects[cache_key] ||= Mite::Project.all(:params => params)
      end
    end
  
    def create_project(attributes={})
      project = Mite::Project.new(attributes)
      project.save
      project
    end
  
    def services(params={})
      @services ||= {}
      force_reload = !!params.delete(:force_reload)
      cache_key = params.blank? ? :blank : params
      if force_reload
        @services[cache_key] = Mite::Service.all(:params => params)
      else
        @services[cache_key] ||= Mite::Service.all(:params => params)
      end
    end
  
    def create_service(attributes={})
      service = Mite::Service.new(attributes)
      service.save
      service
    end
  
    def customers(params={})
      @customers ||= {}
      force_reload = !!params.delete(:force_reload)
      cache_key = params.blank? ? :blank : params
      if force_reload
        @customers[cache_key] = Mite::Customer.all(:params => params)
      else
        @customers[cache_key] ||= Mite::Customer.all(:params => params)
      end
    end
  
    def create_customer(attributes={})
      customer = Mite::Customer.new(attributes)
      customer.save
      customer
    end
  
    def time_entries(params={})
      @time_entries ||= {}
      force_reload = !!params.delete(:force_reload)
      cache_key = params.blank? ? :blank : params
      if force_reload
        @time_entries[cache_key] = Mite::TimeEntry.all(:params => params)
      else
        @time_entries[cache_key] ||= Mite::TimeEntry.all(:params => params)
      end
    end
  
    def create_time_entry(attributes={})
      time_entry = Mite::TimeEntry.new(attributes)
      time_entry.save
      time_entry
    end
  
  end
end