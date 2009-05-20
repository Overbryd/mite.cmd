class Mite::Service < Mite::Base
  
  def time_entries(options = {})
    TimeEntry.find(:all, :params => options.update(:service_id => id))
  end
  
end