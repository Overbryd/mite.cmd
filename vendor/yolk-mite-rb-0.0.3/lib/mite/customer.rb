class Mite::Customer < Mite::Base
  def time_entries(options = {})
    TimeEntry.find(:all, :params => options.update(:customer_id => id))
  end

  def projects(options = {})
    Project.find(:all, :params => options.update(:customer_id => id))
  end
end