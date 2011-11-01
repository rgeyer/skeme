#  Copyright 2011 Ryan J. Geyer
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

require 'cloud_providers/aws'
require 'managers/rightscale'
require 'models/tag'

module Skeme
  class Skeme
    # Cloud providers & management tools
    attr_accessor :tag_destinations

    # Just useful internal bits
    attr_accessor :logger

    def initialize(options={})
      @tag_destinations = {}

      if options[:logger]
        @logger = options[:logger]
      else
        @logger = Logger.new(STDOUT)
      end

      options[:logger] = @logger

      tag_destinations["aws"]         = CloudProviders::Aws.new(options)
      tag_destinations["rightscale"]  = Managers::RightScale.new(options)
    end

    def set_tag(params={})
      destinations = params[:destinations] || tag_destinations.keys

      tag_destinations.select{|key| destinations.include? key }.each do |destination|
        destination.set_tag(params)
      end
    end

    def unset_tag(params={})
      destinations = params[:destinations] || tag_destinations.keys

      tag_destinations.select{|key| destinations.include? key }.each do |destination|
        destination.unset_tag(params)
      end
    end

    def get_tags(params={})

    end
  end
end