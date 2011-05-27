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

require 'fog'

module Skeme
  module CloudProviders
    class Aws
      @@logger = nil
      @@fog_aws_computes = {}

      # TODO: Allow a preferred region/az if it's known
      def initialize(options={})
        @@logger = options[:logger]
        if options[:aws_access_key_id] && options[:aws_secret_access_key]
          @@logger.info("AWS credentials supplied.  EC2 Tagging Enabled.")
          fog_aws_compute = Fog::Compute.new({:aws_access_key_id => options[:aws_access_key_id], :aws_secret_access_key => options[:aws_secret_access_key], :provider => 'AWS'})
          fog_aws_compute.describe_regions.body['regionInfo'].each do |region|
            @@fog_aws_computes.store(region['regionName'],
              Fog::Compute.new({
                :aws_access_key_id => options[:aws_access_key_id],
                :aws_secret_access_key => options[:aws_secret_access_key],
                :provider => 'AWS',
                :host => region['regionEndpoint']
              })
            )
          end
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
        if @@fog_aws_computes
          tag = params[:ec2_tag] || params[:tag]
          setting = params[:action] == "set"

          taggable_resources = [:ec2_instance_id, :ec2_ebs_volume_id, :ec2_ebs_snapshot_id]
          supplied_id_type = taggable_resources & params.keys
          supplied_id_type.each do |resource_id_key|
            resource_id = params[resource_id_key]
            if setting
              not_found_exceptions = []
              @@fog_aws_computes.each do |key,val|
                begin
                  val.create_tags(resource_id, {tag => nil})
                  @@logger.info("Tagging AWS resource id (#{resource_id}) with (#{tag}) in AWS cloud (#{key})")
                rescue Fog::Service::NotFound => e
                  not_found_exceptions << e
                end
              end
              if not_found_exceptions.count == @@fog_aws_computes.count
                raise not_found_exceptions.first
              end
            else
              @@logger.info("Removing tag (#{tag}) from AWS resource id (#{resource_id})")
              not_found_exceptions = []
              @@fog_aws_computes.each do |key,val|
                begin
                  val.delete_tags(resource_id, {tag => nil})
                rescue Fog::Service::NotFound => e
                  not_found_exceptions << e
                end
              end
              if not_found_exceptions.count == @@fog_aws_computes.count
                raise not_found_exceptions.first
              end
            end

          end
        end
      end
    end
  end
end