# encoding: utf-8

require_relative "../spec_helper"
require "rango/environments"

describe "Rango environments" do
  it "should defaults to development" do
    Rango.environment.should eql("development")
  end

  describe ".development?" do
    it "should be true if Rango.environment is 'development'" do
      Rango.environment = "development"
      Rango.should be_development
    end

    it "should be true if Rango.environment is included in Rango.development_environments" do
      Rango.environment = "foobar"
      Rango.should_not be_development
      Rango.development_environments.push("foobar")
      Rango.should be_development
    end
  end

  describe ".production?" do
    %w{production stage}.each do |environment|
      it "should be true if Rango.environment is '#{environment}'" do
        Rango.environment = environment
        Rango.should be_production
      end
    end

    it "should be true if Rango.environment is included in Rango.production_environments" do
      Rango.environment = "foobar"
      Rango.should_not be_production
      Rango.production_environments.push("foobar")
      Rango.should be_production
    end
  end

  describe ".testing?" do
    %w{test spec cucumber}.each do |environment|
      it "should be true if Rango.environment is '#{environment}'" do
        Rango.environment = environment
        Rango.should be_testing
      end
    end

    it "should be true if Rango.environment is included in Rango.testing_environments" do
      Rango.environment = "foobar"
      Rango.should_not be_testing
      Rango.testing_environments.push("foobar")
      Rango.should be_testing
    end
  end

  describe ".environment?" do
    it "should returns true if current environment is the same as the only argument" do
      Rango.environment = "development"
      Rango.environment?("development").should be_true
    end

    it "should returns false if current environment is different than the only argument" do
      Rango.environment = "production"
      Rango.environment?("development").should be_false
    end
  end
end
