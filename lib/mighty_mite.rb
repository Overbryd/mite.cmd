require 'rubygems'
require 'yaml'
require 'mite-rb'

module MightyMite
  class Exception < StandardError; end
end

require 'string_ext'
require 'mite_ext'
require 'mighty_mite/client'
require 'mighty_mite/autocomplete'