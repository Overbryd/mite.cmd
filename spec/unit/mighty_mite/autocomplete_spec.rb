require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe MightyMite::Autocomplete do
  before(:each) do
    MightyMite::Autocomplete.completion_table = {
      0 => ['argument1', 'argument1a', 'argument1b', 'argument1c'],
      1 => ['Homer', 'Simpsons', 'Holy', 'Holy Moly', 'Holy Grail'],
      2 => ['I love spaces']
    }
    MightyMite::Autocomplete.calling_script =  './test_command'
    ENV['COMP_LINE'] = "./test_command argument1 Holy \"I love spaces\""
    ENV['COMP_POINT'] = '27'
  end
  
  describe 'argument_string' do
    it "should return a string of all arguments without the calling script" do
      MightyMite::Autocomplete.argument_string.should == 'argument1 Holy "I love spaces"'
    end
  end
  
  describe 'partial_argument_string' do
    it "should return a string of all arguments before the cursor position without the calling script" do
      MightyMite::Autocomplete.partial_argument_string.should == 'argument1 Holy'
    end
    
    it "should be able to handle unmatched quotes" do
      ENV['COMP_LINE'] = "./test_command \"arg "
      ENV['COMP_POINT'] = '20'
      MightyMite::Autocomplete.partial_argument_string.should == '"arg "'
    end
  end
  
  describe 'args' do
    it "should return an array of arguments" do
      MightyMite::Autocomplete.args.should == ['argument1', 'Holy', 'I love spaces']
    end
  end
  
  describe 'cursor_position' do
    it "should return the cursor position as integer" do
      MightyMite::Autocomplete.cursor_position.should == 27
    end
  end
  
  describe 'current_word' do
    it "should return the current word at the cursor position" do
      MightyMite::Autocomplete.current_word.should == 'Holy'
    end
    
    it "should be able to handle unmatched quotes" do
      ENV['COMP_LINE'] = "./test_command \"arg "
      ENV['COMP_POINT'] = '20'
      MightyMite::Autocomplete.current_word.should == 'arg '
    end
    
    it "should return nil if the last word has been completed" do
      ENV['COMP_LINE'] = "./test_command arg0 "
      ENV['COMP_POINT'] = '20'
      MightyMite::Autocomplete.current_word.should == nil
    end
  end
  
  describe 'current_argument_index' do
    it "should return the index of the argument at the cursor position" do
      MightyMite::Autocomplete.current_argument_index.should == 1
    end
    
    it "should default to 0 if there are no args yet" do
      ENV['COMP_LINE'] = "./test_command "
      ENV['COMP_POINT'] = '15'
      MightyMite::Autocomplete.current_argument_index.should == 0
    end
    
    it "should return the size of the existing arguments plus 1 if the cursor position is at the end" do
      ENV['COMP_LINE'] = "./test_command arg_index0 arg_index1 "
      ENV['COMP_POINT'] = '37'
      MightyMite::Autocomplete.current_argument_index.should == 2
    end
  end
  
  describe 'suggestions' do
    it "should return the suggested values from the completion table at the current argument index" do
      MightyMite::Autocomplete.suggestions.should == ['Holy', 'Holy Moly', 'Holy Grail']
    end
  end
end