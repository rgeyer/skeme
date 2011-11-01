require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'models', 'tag.rb')

describe "Tag model" do

  def new_tag
    tag = Skeme::Tag.new
    tag.namespace = "foo"
    tag.predicate = "bar"
    tag.value = "baz"
    tag.resource_ids = {:ec2_instance_id => "abc123"}
    tag
  end

  it "Can instantiate a tag object" do
    lambda { new_tag }.should_not raise_error
  end

  it "Can print a tag as a machine tag" do
    new_tag.machine_tag.should == "foo:bar=baz"
  end

  it "Can injest aws tags for an instance" do
    api_tag_response = {"resourceId" => "i-4379a920", "value" => "baz", "key" => "foo:bar", "resourceType" => "instance"}
    tag = Skeme::Tag.new(api_tag_response)
    tag.namespace.should  == "foo"
    tag.predicate.should  == "bar"
    tag.value.should      == "baz"
    tag.resource_ids.should == {:ec2_instance_id => "i-4379a920"}
  end

end