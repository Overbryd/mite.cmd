String.class_eval do
  def quote(q="\"")
    "#{q}#{self}#{q}"
  end
  
  def quote_if_spaced(q="\"")
    self =~ /\s/ ? self.quote : self
  end
  
  def close_unmatched_quotes(q="\"")
    (self.scan(/"/).size % 2) != 0 ? self+q : self
  end
  
  BASH_COLOR = {
    :black => 30,
    :red => 31,
    :green => 32,
    :yellow => 33,
    :blue => 34,
    :magenta => 35,
    :cyan => 36,
    :white => 37,
    :default => 39
  }
  BASH_EFFECT = {
    :none => 0,
    :bright => 1,
    :underline => 4,
    :blink => 5,
    :exchange => 7,
    :hidden => 8
  }
  def colorize(options={})
    return '' if self == ''
    options = {:color => options} if options.is_a?(Symbol)
    options[:color] = :default unless options[:color]
    if options[:color] != :default && options[:color].to_s =~ /^(light|bright)/
      options[:color] = options[:color].to_s.sub(/^(light|bright)/, '').to_sym
      options[:effect] = :bright 
    end
    options[:background] = :default unless options[:background]
    options[:effect] = :none unless options[:effect]
    
    effect_code = "#{BASH_EFFECT[options[:effect]]}"
    background_code = "#{BASH_COLOR[options[:background]]+10}m"
    color_code = "#{BASH_COLOR[options[:color]]}"
    reset_code = "\e[0m"
    "\e[#{effect_code};#{color_code};#{background_code}#{self}#{reset_code}"
  end
end
