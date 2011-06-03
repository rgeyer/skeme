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

require 'rest_connection'
require 'yaml'

module Skeme
  module Managers
    class RightScale
      attr_accessor :logger, :gotime

      def initialize(options={})
        @logger = options[:logger]
        if options[:rs_email] && options[:rs_pass] && options[:rs_acct_num]
          pass = options[:rs_pass].gsub('"', '\\"')

          @logger.info("RightScale credentials supplied. RightScale Tagging Enabled.")
          ::RightScale::Api::BaseExtend.class_eval <<-EOF
          @@connection ||= RestConnection::Connection.new
            @@connection.settings = {
              :user => "#{options[:rs_email]}",
              :pass => "#{pass}",
              :api_url => "https://my.rightscale.com/api/acct/#{options[:rs_acct_num]}",
              :common_headers => {
                "X_API_VERSION" => "1.0"
              }
            }
          EOF
          ::RightScale::Api::Base.class_eval <<-EOF
          @@connection ||= RestConnection::Connection.new
            @@connection.settings = {
              :user => "#{options[:rs_email]}",
              :pass => "#{pass}",
              :api_url => "https://my.rightscale.com/api/acct/#{options[:rs_acct_num]}",
              :common_headers => {
                "X_API_VERSION" => "1.0"
              }
            }
          EOF

          @gotime = true
        end
      end

      def set_tag(params={})
        tag(params.merge({:action => "set"}))
      end

      def unset_tag(params={})
        tag(params.merge({:action => "unset"}))
      end

      private

      def server_from_unique_id(ec2_instance_id, rs_tag_target)
        # Prefer the target tag if we have it, because it's much more efficient
        if rs_tag_target
          instance = Tag.search('ec2_instance', rs_tag_target).first
          server = Server.find(:first) { |s| instance["href"].start_with? s.href }
        else
          server = Server.find(:first) do |s|
            # This makes an additional API call to get "settings". This process can get expensive in a very big hurry
            # When RS API 1.5 is released, hopefully we'll have a better way to search for EC2 instances
            s.settings['aws-id'] == ec2_instance_id
          end
        end
        server
      end

      def tag(params={})
        if @gotime
          tag = params[:rs_tag] || params[:tag]
          setting = params[:action] == "set"

          params.keys.each do |resource_id_key|
            resource_href = nil
            case resource_id_key
              # TODO: Should check for nil on each of these, since what I'm looking for may not be found

              # This creates a condition where the instance is tagged twice if both ec2_instance_id and rs_tag_target are both provided.
              # It's still less calls than iterating all of the servers for the aws-id though.
              when :ec2_instance_id, :rs_tag_target
                resource_href = server_from_unique_id(params[:ec2_instance_id], params[:rs_tag_target]).current_instance_href
              when :ec2_ebs_volume_id
                resource_href = Ec2EbsVolume.find(:first) { |vol| vol.aws_id == params[:ec2_ebs_volume_id] }.href
              when :ec2_ebs_snapshot_id
                resource_href = Ec2EbsSnapshot.find(:first) { |snap| snap.aws_id == params[:ec2_ebs_snapshot_id] }.href
            end

            if resource_href
              if setting
                Tag.set(resource_href, [tag])
              else
                Tag.unset(resource_href, [tag])
              end
            end
          end
        end
      end


    end
  end
end