require 'spec_helper'

class Person < Datev::Base
  field 'name',            :string, :limit => 30, :required => true
  field 'favorite number', :integer, :limit => 10
  field 'weight',          :decimal, :precision => 4, :scale => 1
  field 'birthday',        :date, :format => '%d%m%Y'
  field 'alive',           :boolean do
    def output(value, context)
      value ? 'yes' : 'no'
    end
  end
end

describe Datev::Base do
  let(:person) {
    Person.new(
      'name'            => 'John',
      'favorite number' => 666,
      'weight'          => 83.6,
      'birthday'        => Date.new(1975,4,30),
      'alive'           => true
    )
  }

  describe '.field' do
    it "should build definition" do
      expect(Person.fields.count).to eq(5)
    end

    it "should not allow duplicate field names" do
      expect {
        Person.field 'name', :string
      }.to raise_error(ArgumentError, "Field 'name' already exists")
    end

    it "should not allow unknown field type" do
      expect {
        Person.field 'xy', :foo
      }.to raise_error(NameError)
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

  describe :[] do
    it "should return raw value" do
      expect(person['name']).to eq 'John'
      expect(person['favorite number']).to eq 666
      expect(person['weight']).to eq 83.6
      expect(person['birthday']).to eq Date.new(1975,4,30)
      expect(person['alive']).to eq true
    end

    it "should fail for unknown field name" do
      expect {
        person['foobar']
      }.to raise_error(ArgumentError, "Field 'foobar' not found")
    end
  end

  describe :output do
    it "should return array with formatted values" do
      expect(person.output).to eq([ '"John"', '666', '83,6', '30041975', 'yes' ])
    end

    it "should pass context to field's output method" do
      expect(Person.fields[0]).to receive(:output).with('John', 42)
      person.output(42)
    end
  end
end
