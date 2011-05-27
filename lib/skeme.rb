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

require 'cloud_providers/aws.rb'
require 'managers/rightscale.rb'

module Skeme
  class Skeme
    # Cloud providers
    attr_accessor :cloud_providers

    # Management tools
    attr_accessor :managers

    # Just useful internal bits
    attr_accessor :logger

    def initialize(options={})
      @cloud_providers  = []
      @managers         = []

      if options[:logger]
        @logger = options[:logger]
      else
        @logger = Logger.new(STDOUT)
      end

      options[:logger] = @logger

      cloud_providers << CloudProviders::Aws.new(options)

      managers << Managers::RightScale.new(options)
    end

    def set_tag(params={})
      cloud_providers.each do |provider|
        provider.set_tag(params)
      end

      managers.each do |manager|
        manager.set_tag(params)
      end
    end

    def unset_tag(params={})
      cloud_providers.each do |provider|
        provider.unset_tag(params)
      end

      managers.each do |manager|
        manager.unset_tag(params)
      end
    end
  end
end