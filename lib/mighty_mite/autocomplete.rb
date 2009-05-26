require 'shellwords'

module MiteCmd
  class Autocomplete
    include Shellwords
    
    attr_accessor :completion_table
    attr_reader :calling_script
    
    def initialize(calling_script)
      @calling_script = calling_script
    end
    
    def bash_line
      ENV['COMP_LINE'].to_s
    end
  
    def argument_string
      bash_line.sub(/^(.*)#{File.basename calling_script}\s*/, '').close_unmatched_quotes
    end
  
    def partial_argument_string
      bash_line[0..cursor_position+1].sub(/^(.*)#{File.basename calling_script}\s*/, '').close_unmatched_quotes
    end
  
    def current_word
      return nil if argument_string =~ /\s$/ && bash_line.length == cursor_position
      shellwords(partial_argument_string).last
    end
  
    def current_argument_index
      return args.size if argument_string =~ /\s$/ && bash_line.length == cursor_position
      args.index(current_word) || 0
    end
  
    def cursor_position
      ENV['COMP_POINT'].to_i
    end
  
    def args
      shellwords(argument_string)
    end
  
    def suggestions
      completion_table[current_argument_index] ? completion_table[current_argument_index].select {|s| s =~ /^#{current_word}/} : []
    end
  end
end