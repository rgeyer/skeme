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

module Skeme
  class Tag
    attr_accessor :namespace
    attr_accessor :predicate
    attr_accessor :value
    attr_accessor :resource_ids
    attr_accessor :destinations

    def initialize(aws_hash={})
      @namespace     = ""
      @predicate     = ""
      @value         = ""
      @resource_ids  = {}
      @destinations  = []

      if aws_hash.instance_of? ::Hash
        case(aws_hash.keys)
          when ["resourceId","value","key","resourceType"] # It's an AWS response hash
            case(aws_hash["resourceType"])
              when "instance"
                @resource_ids[:ec2_instance_id] = aws_hash["resourceId"]
              when "volume"
                @resource_ids[:ec2_ebs_volume_id] = aws_hash["resourceId"]
              when "snapshot"
                @resource_ids[:ec2_ebs_snapshot_id] = aws_hash["resourceId"]
            end
            split_key = aws_hash["key"].split(':')

            @namespace = split_key[0]
            @predicate = split_key[1]
            @value     = aws_hash["value"]
        end
      end
    end

    def machine_tag
      "#{namespace}:#{predicate}=#{value}"
    end
  end
end