class Mite::TimeEntryGroup < Mite::Base
  self.collection_name = "time_entries"
  
  attr_accessor :time_entries_params
  
  class << self
    def find_every(options={})
      return TimeEntry.all(options) if !options[:params] || !options[:params][:group_by]
      
      returning super(options) do |records|
        records.each do |record| 
          if record.attributes["time_entries_params"]
            record.time_entries_params = record.attributes.delete("time_entries_params").attributes.stringify_keys
          end
        end
      end
    end
  end
  
  def time_entries(options={})
    return [] unless time_entries_params.is_a?(Hash)
    
    empty_result = false
    
    options[:params] ||= {}
    options[:params].stringify_keys!
    options[:params].merge!(time_entries_params) do |key, v1, v2|
      empty_result = (v1 != v2)
      v2
    end
    
    return [] if empty_result
    
    TimeEntry.all(options)
  end
end