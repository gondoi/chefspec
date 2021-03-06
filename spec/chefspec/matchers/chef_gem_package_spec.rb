require 'spec_helper'

module ChefSpec
  module Matchers
    describe :install_chef_gem_at_version, :if => defined?(::Chef::Resource::ChefGem) do
      describe "#match" do
        let(:matcher) { install_chef_gem_at_version('foo', '1.2.3') }
        it "should not match when no resources exist" do
          matcher.matches?({:resources => []}).should be false
        end
        it "should not match when there are no chef gem packages" do
          matcher.matches?({:resources => [{:resource_name => 'template', :path => '/tmp/config.conf',
            :source => 'config.conf.erb'}]}).should be false
        end
        it "should not match if is a different chef gem package and an unspecified version" do
          matcher.matches?({:resources => [{:resource_name => 'chef_gem', :package_name => 'bar', :version => nil, :action => :install}]}).should be false
        end
        it "should not match if it is the same chef gem package and version but a different action" do
          matcher.matches?({:resources => [{:resource_name => 'chef_gem', :package_name => 'foo', :version => '1.2.3', :action => :upgrade}]}).should be false
        end
        it "should match if is the same chef gem package, the correct version and the install action" do
          matcher.matches?({:resources => [{:resource_name => 'chef_gem', :package_name => 'foo', :version => '1.2.3', :action => :install}]}).should be true
        end
      end
    end
  end
end
