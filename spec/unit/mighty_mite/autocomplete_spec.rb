require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe MiteCmd::Autocomplete, 'new' do
  it "should set calling_script" do
    autocomplete = MiteCmd::Autocomplete.new('/usr/local/bin/mite')
    autocomplete.instance_variable_get('@calling_script').should == '/usr/local/bin/mite'
  end
end

describe MiteCmd::Autocomplete do
  before(:each) do
    @autocomplete = MiteCmd::Autocomplete.new '/usr/local/bin/test_command'
    @autocomplete.completion_table = {
      0 => ['argument1', 'argument1a', 'argument1b', 'argument1c'],
      1 => ['Homer', 'Simpsons', 'Holy', 'Holy Moly', 'Holy Grail'],
      2 => ['I love spaces']
    }
    ENV['COMP_LINE'] = "./test_command argument1 Holy \"I love spaces\""
    ENV['COMP_POINT'] = '27'
  end
  
  describe 'argument_string' do
    it "should return a string of all arguments without the calling script" do
      @autocomplete.argument_string.should == 'argument1 Holy "I love spaces"'
    end
  end
  
  describe 'partial_argument_string' do
    it "should return the arguments part of the bash line" do
      @autocomplete.partial_argument_string.should == 'argument1 Holy'
    end
    
    it "should be able to handle unmatched quotes" do
      ENV['COMP_LINE'] = "./test_command \"arg "
      ENV['COMP_POINT'] = '20'
      @autocomplete.partial_argument_string.should == '"arg "'
    end
  end
  
  describe 'args' do
    it "should return an array of arguments" do
      @autocomplete.args.should == ['argument1', 'Holy', 'I love spaces']
    end
  end
  
  describe 'cursor_position' do
    it "should return the cursor position as integer" do
      @autocomplete.cursor_position.should == 27
    end
  end
  
  describe 'current_word' do
    it "should return the current word at the cursor position" do
      @autocomplete.current_word.should == 'Holy'
    end
    
    it "should be able to handle unmatched quotes" do
      ENV['COMP_LINE'] = "./test_command \"arg "
      ENV['COMP_POINT'] = '20'
      @autocomplete.current_word.should == 'arg '
    end
    
    it "should return nil if the last word has been completed" do
      ENV['COMP_LINE'] = "./test_command arg0 "
      ENV['COMP_POINT'] = '20'
      @autocomplete.current_word.should == nil
    end
  end
  
  describe 'current_argument_index' do
    it "should return the index of the argument at the cursor position" do
      @autocomplete.current_argument_index.should == 1
    end
    
    it "should default to 0 if there are no args yet" do
      ENV['COMP_LINE'] = "./test_command "
      ENV['COMP_POINT'] = '15'
      @autocomplete.current_argument_index.should == 0
    end
    
    it "should return the size of the existing arguments plus 1 if the cursor position is at the end" do
      ENV['COMP_LINE'] = "./test_command arg_index0 arg_index1 "
      ENV['COMP_POINT'] = '37'
      @autocomplete.current_argument_index.should == 2
    end
  end
  
  describe 'suggestions' do
    it "should return the suggested values from the completion table at the current argument index" do
      @autocomplete.suggestions.should == ['Holy', 'Holy Moly', 'Holy Grail']
    end
    
    it "should return an empty array if the current argument index is out of range" do
      @autocomplete.stub!(:current_argument_index).and_return 50
      @autocomplete.suggestions.should == []
    end
    
  end
  
end