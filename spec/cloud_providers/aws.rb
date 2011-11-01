require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'cloud_providers', 'aws.rb')

describe "AWS Tests" do

  def instance_ids
    @instance_ids = ['i-4379a920', 'i-6979a90a']
  end

  def aws
    @aws ||= Skeme::CloudProviders::Aws.new({
      :aws_access_key_id => $creds_yo[:aws_access_key_id],
      :aws_secret_access_key => $creds_yo[:aws_secret_access_key],
      :rs_email => $creds_yo[:rs_email],
      :rs_pass => $creds_yo[:rs_pass],
      :rs_acct_num => $creds_yo[:rs_acct_num],
      :logger => Logger.new(STDOUT)
    })
  end

  before(:all) do
    #aws.unset_tags({:ec2_instance_id => instance_ids})
  end

  it "Can set one tag on one resource of one type" do
    # Probably need to do some better error checking rather than just not receiving an error.
    lambda { aws.set_tag("foo","bar","baz", :ec2_instance_id => instance_ids[0]) }.should_not raise_error
    aws.get_tags(:ec2_instance_id => instance_ids[0]).count.should == 1
  end

  it "Can unset one tag on one resource of one type" do
    aws.get_tags(:ec2_instance_id => instance_ids[0]).count.should == 1
    lambda { aws.unset_tag("foo","bar","baz", :ec2_instance_id => instance_ids[0]) }.should_not raise_error
    aws.get_tags(:ec2_instance_id => instance_ids[0]).count.should == 0
  end

  it "Can set one tag on many resources of the same type" do
    lambda { aws.set_tag("foo","bar","baz", :ec2_instance_id => instance_ids) }.should_not raise_error
    instance_ids.each do |instance_id|
      aws.get_tags(:ec2_instance_id => instance_id).count.should == 1
    end
    lambda { aws.unset_tag("foo","bar","baz", :ec2_instance_id => instance_ids) }.should_not raise_error
  end

  #it "Can get all tags for instance" do
  #  aws.get_tags(:ec2_instance_id => instance_id).count.should == 0
  #
  #  aws.set_tag("foo", "bar", "baz", :ec2_instance_id => instance_id)
  #  aws.get_tags(:ec2_instance_id => instance_id).count.should == 1
  #  aws.unset_tag(
  #    :tag => "foo:bar=baz",
  #    :ec2_instance_id => instance_id
  #  )
  #  aws.get_tags(:ec2_instance_id => instance_id).count.should == 0
  #end

  it "ArgumentError thrown when no valid resource type is supplied" do
    lambda { aws.get_tags(:foobar => 12345) }.should raise_error(ArgumentError)
  end

end