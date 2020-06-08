# frozen_string_literal: true

require 'date'

require 'graphql/client'
require 'graphql/client/http'

require 'active_support/hash_with_indifferent_access'
require 'active_support/inflector'

require 'mirah/version'
require 'mirah/errors'
require 'mirah/serializers'
require 'mirah/base_object'
require 'mirah/collection'
require 'mirah/push_result'
require 'mirah/graphql'

Dir[File.dirname(__FILE__) + '/mirah/data/**/*.rb'].sort.each do |file|
  require file
end

require 'mirah/graphql/fragments'
require 'mirah/graphql/queries'
require 'mirah/graphql/mutations'

require 'mirah/filters'

Dir[File.dirname(__FILE__) + '/mirah/filters/**/*.rb'].sort.each do |file|
  require file
end

require 'mirah/inputs'
require 'mirah/base_input_object'

Dir[File.dirname(__FILE__) + '/mirah/inputs/**/*.rb'].sort.each do |file|
  require file
end

require 'mirah/client'

# Mirah ruby interoperability
module Mirah
end
