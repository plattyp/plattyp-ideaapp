require 'spec_helper'

describe "EmailValidator" do
  let(:validator) { EmailValidator.new({attributes: [:email]}) }
  let(:model) { double('model') }

  before :each do
    model.stub("errors").and_return([])
    model.errors.stub('[]').and_return({})  
    model.errors[].stub('<<')
  end

  context "given an invalid email address" do
    let(:invalid_email) { 'test test tes' }
    it "is rejected as invalid" do
      model.errors[].should_receive('<<')
      validator.validate_each(model, "email", invalid_email)
    end  
  end

  context "given a simple valid address" do
    let(:valid_simple_email) { 'test@test.tes' }
    it "is accepted as valid" do
      model.errors[].should_not_receive('<<')    
      validator.validate_each(model, "email", valid_simple_email)
    end
  end

  context "given a valid tagged address" do
    let(:valid_tagged_email) { 'test+thingo@test.tes' }
    it "is accepted as valid" do
      model.errors[].should_not_receive('<<')    
      validator.validate_each(model, "email", valid_tagged_email)
    end
  end
end