Mite.class_eval do
  def self.account_url
    host_format % [protocol, domain_format % account, (port.blank? ? '' : ":#{port}")]
  end
end

Mite::TimeEntry.class_eval do
  # I need the full class path, otherwise there will be LoadErrors
  def service
    @service ||= Mite::Service.find(service_id) unless service_id.blank?
  end
  
  # I need the full class path, otherwise there will be LoadErrors
  def project
    @project ||= Mite::Project.find(project_id) unless project_id.blank?
  end

  def inspect
    output = []
    output << formatted_time.colorize(tracking? ? :lightyellow : :lightred)
    output << formatted_revenue.colorize(:lightgreen) if revenue
    output << "\tdoing #{service.name}" if service
    output << "\tfor #{project.name}" if project
    output << "\n\t\t|_ #{note}" unless note.blank?
    output.join(' ')
  end
  
  def formatted_revenue
    revenue.nil? ? '' : "%.2f $" % (revenue / 100.0)
  end
    
  def formatted_time
    minutes = tracking? ? tracker.minutes : self.minutes
    if minutes > 59
      h = minutes/60
      m = minutes-h*60
      "#{h}:%.2d" % m
    else
      "0:%.2d" % minutes
    end
  end

end

Mite::Tracker.class_eval do
  def time_entry
    @time_entry ||= Mite::TimeEntry.find(id)
  end

  def inspect
    time_entry.inspect
  end
end