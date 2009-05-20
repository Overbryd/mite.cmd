class Mite::Project < Mite::Base
  
  def time_entries(options = {})
    TimeEntry.find(:all, :params => options.update(:project_id => id))
  end

  def customer
    @customer ||= Customer.find(customer_id) unless customer_id.blank?
  end
  
  def customer=(customer)
    self.customer_id = customer ? customer.id : nil
    @customer = customer
  end
  
end