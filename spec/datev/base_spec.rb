require 'spec_helper'

class Person < Datev::Base
  field 'name',            :string, :limit => 30, :required => true
  field 'favorite number', :integer, :limit => 10
  field 'weight',          :decimal, :precision => 4, :scale => 1
  field 'birthday',        :date, :format => '%d%m%Y'
  field 'alive',           :boolean
end

describe Datev::Base do
  describe '.field' do
    it "should build definition" do
      expect(Person.fields.count).to eq(5)
    end

    it "should not allow duplicate field names" do
      expect {
        Person.field 'name', :string
      }.to raise_error(ArgumentError, "Field 'name' already exists")
    end
  end

  describe :initialize do
    it "should accept valid attributes" do
      expect {
        Person.new 'name' => 'John'
      }.to_not raise_error
    end

    it "should not accept missing required key" do
      expect {
        Person.new 'alive' => true
      }.to raise_error(ArgumentError, "Value for field 'name' is required but missing")
    end

    it "should not accept wrong type" do
      expect {
        Person.new 'name' => 42
      }.to raise_error(ArgumentError, "Value given for field 'name' is not a String")
    end

    it "should not accept unknown key" do
      expect {
        Person.new 'locale' => 'de'
      }.to raise_error(ArgumentError, "Field 'locale' not found")
    end

    it "should not accept something other than Hash" do
      expect {
        Person.new 42
      }.to raise_error(ArgumentError, "Hash required")
    end
  end

  describe :to_a do
    it "should return array with formatted values" do
      person = Person.new(
        'name'            => 'John',
        'favorite number' => 666,
        'weight'          => 83.6,
        'birthday'        => Date.new(1975,4,30),
        'alive'           => true
      )

      expect(person.to_a).to eq([ 'John', '0000000666', '83,6', '30041975', 1 ])
    end
  end
end
