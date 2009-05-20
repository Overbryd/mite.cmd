class Mite::User < Mite::Base
  
  def time_entries(options = {})
    TimeEntry.find(:all, :params => options.update(:user_id => id))
  end
  
  def save
    raise Error, "Cannot modify users over mite.api"
  end
  
  def create
    raise Error, "Cannot create users over mite.api"
  end
  
  def destroy
    raise Error, "Cannot destroy users over mite.api"
  end

end
