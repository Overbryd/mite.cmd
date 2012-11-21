require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe String, 'quote' do
  it "should wrap a string in quotes" do
    'Gimme quotes'.quote.should == '"Gimme quotes"'
  end
end

describe String, 'quote_if_spaced' do
  it "should wrap a string in quotes if it contains spaces" do
    'I want quotes'.quote_if_spaced.should == '"I want quotes"'
  end
  
  it "should leave the string unmodified if it doesn't contain spaces" do
    'I_hate_spaces_and_quotes'.quote_if_spaced.should == 'I_hate_spaces_and_quotes'
  end
end

describe String, 'close_unmatched_quotes' do
  it "should close unmatched quotes" do
    '"arg '.close_unmatched_quotes.should == '"arg "'
  end
  
  it "should leave an healthy string intact" do
    'I am happy.'.close_unmatched_quotes.should == 'I am happy.'
  end
end

describe String, 'colorize' do
  describe 'defaults' do
    it "should use default background" do
      '1995'.colorize.should == "\e[0;39;49m1995\e[0m"
    end

    it "should use default foreground" do
      '1995'.colorize.should == "\e[0;39;49m1995\e[0m"
    end

    it "should default to no effect" do
      '1995'.colorize.should == "\e[0;39;49m1995\e[0m"
    end
  end
  
  describe 'empty string' do
    it "should return the empty string" do
      ''.colorize.should == ''
    end
  end
  
  [:black, :red, :green, :yellow, :blue, :magenta, :cyan, :white, :default].each do |color|
    it "should set #{color} as foreground color" do
      'The seventies'.colorize(:color => color).should == "\e[0;#{String::BASH_COLOR[color]};49mThe seventies\e[0m"
    end
    
    it "should set #{color} as background color" do
      'The eighties'.colorize(:background => color).should == "\e[0;39;#{String::BASH_COLOR[color]+10}mThe eighties\e[0m"
    end
    
    it "should set the effect code to bright with light#{color} as foreground" do
      'The nineties'.colorize(:color => "light#{color}".to_sym).should == "\e[1;#{String::BASH_COLOR[color]};49mThe nineties\e[0m"
    end
    
    it "should take a foreground color like #{color} as shorthand argument" do
      'The year 2000'.colorize(color.to_sym).should == "\e[0;#{String::BASH_COLOR[color]};49mThe year 2000\e[0m"
    end
  end
end
