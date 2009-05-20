class Mite::Tracker < Mite::Base
  
  self.collection_name = "tracker"
  
  def self.current
    tracking_time_entry = connection.get(collection_path, headers)["tracking_time_entry"]
    tracking_time_entry ? instantiate_record(tracking_time_entry) : nil
  end
  
  def self.start(time_entry_or_id)
    id = time_entry_or_id.is_a?(Mite::TimeEntry) ? time_entry_or_id.id : time_entry_or_id
    self.new(:id => id).start
  end
  
  def self.stop
    tracker = current 
    tracker ? tracker.stop : false
  end
  
  def start
    response = connection.put(element_path(prefix_options), encode, self.class.headers)
    load(self.class.format.decode(response.body)["tracking_time_entry"])
    response.is_a?(Net::HTTPSuccess) ? self : false
  end
  
  def stop
    connection.delete(element_path, self.class.headers).is_a?(Net::HTTPSuccess) ? self : false
  end
  
  def time_entry
    Mite::TimeEntry.find(id)
  end
  
end