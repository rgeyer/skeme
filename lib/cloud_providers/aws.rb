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

require 'right_aws'

module Skeme
  module CloudProviders
    class Aws
      attr_accessor :logger, :ec2

      def initialize(options={})
        @logger = options[:logger]
        if options[:aws_access_key_id] && options[:aws_secret_access_key]
          @logger.info("AWS credentials supplied.  EC2 Tagging Enabled.")
          @ec2 = Rightscale::Ec2.new(options[:aws_access_key_id], options[:aws_secret_access_key], {:logger => options[:logger]})
        end
      end

      def set_tag(params={})
        tag(params.merge({:action => "set"}))
      end

      def unset_tag(params={})
        tag(params.merge({:action => "unset"}))
      end

      private

      def tag(params={})
        if @ec2
          tag = params[:ec2_tag] || params[:tag]
          setting = params[:action] == "set"

          taggable_resources = [:ec2_instance_id, :ec2_ebs_volume_id, :ec2_ebs_snapshot_id]
          supplied_id_type = taggable_resources & params.keys
          supplied_id_type.each do |resource_id_key|
            resource_id = params[resource_id_key]
            if setting
              @logger.info("Tagging AWS resource id (#{resource_id}) with (#{tag})")
              @ec2.create_tags(resource_id, [tag])
            else
              @logger.info("Removing tag (#{tag}) from AWS resource id (#{resource_id})")
              @ec2.delete_tags(resource_id, [tag])
            end

          end
        end
      end
    end
  end
end