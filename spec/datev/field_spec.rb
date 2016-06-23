require 'spec_helper'

describe Datev::Field do
  describe :initialize do
    it "should allow valid params" do
      Datev::Field.new 'foo', :string, :limit => 3
      Datev::Field.new 'foo', :integer, :limit => 3
      Datev::Field.new 'foo', :decimal, :precision => 10, :scale => 2
      Datev::Field.new 'foo', :boolean
      Datev::Field.new 'foo', :date, :format => '%d%m%Y'
    end

    it "should not allow invalid params" do
      expect {
        Datev::Field.new :foo, :xy
      }.to raise_error(ArgumentError, 'Name param has to be a String')

      expect {
        Datev::Field.new 'foo', :xy
      }.to raise_error(ArgumentError, 'Type param not recognized')

      expect {
        Datev::Field.new 'foo', :string, :bar => 42
      }.to raise_error(ArgumentError, 'Options param includes unknown key')

      expect {
        Datev::Field.new 'foo', :string, 42
      }.to raise_error(ArgumentError, 'Options param has to be a Hash')
    end
  end

  context :string do
    let(:field) { Datev::Field.new 'foo', :string, :limit => 3, :required => true }

    describe :validate! do
      it "should accept valid value" do
        expect { field.validate!('Bar') }.to_not raise_error
      end

      it "should fail for invalid values" do
        [ 123, 123.45, true ].each do |value|
          expect { field.validate!(value)       }.to raise_error(ArgumentError, "Value given for field 'foo' is not a String")
        end
        expect { field.validate!('MuchTooLong') }.to raise_error(ArgumentError, "Value 'MuchTooLong' for field 'foo' is too long")
        expect { field.validate!(nil)           }.to raise_error(ArgumentError, "Value for field 'foo' is required")
      end
    end

    describe :output do
      it "should return unchanged value" do
        expect(field.output('foo')).to eq('foo')
      end
    end
  end

  context :integer do
    let(:field) { Datev::Field.new 'foo', :integer, :limit => 3, :required => true }

    describe :validate! do
      it "should accept valid value" do
        expect { field.validate!(42) }.to_not raise_error
      end

      it "should fail for invalid values" do
        [ '123', 100.5, true ].each do |value|
          expect { field.validate!(value) }.to raise_error(ArgumentError, "Value given for field 'foo' is not an Integer")
        end
        expect { field.validate!(1000)    }.to raise_error(ArgumentError, "Value '1000' for field 'foo' is too long")
        expect { field.validate!(nil)     }.to raise_error(ArgumentError, "Value for field 'foo' is required")
      end
    end

    describe :output do
      it "should fill with 0" do
        expect(field.output(1)).to eq('001')
      end
    end
  end

  context :decimal do
    let(:field) { Datev::Field.new 'foo', :decimal, :precision => 4, :scale => 2, :required => true }

    describe :validate! do
      it "should accept valid value" do
        expect { field.validate!(12.23)  }.to_not raise_error
      end

      it "should fail for invalid values" do
        [ '123', true, Date.new(2016,1,1) ].each do |value|
          expect { field.validate!(value) }.to raise_error(ArgumentError, "Value given for field 'foo' is not a Decimal")
        end
        expect { field.validate!(1000.5)  }.to raise_error(ArgumentError, "Value '1000.5' for field 'foo' is too long")
        expect { field.validate!(nil)     }.to raise_error(ArgumentError, "Value for field 'foo' is required")
      end
    end

    describe :output do
      it "should format" do
        expect(field.output(1.2)).to eq('1,20')
      end
    end
  end

  context :date do
    let(:field) { Datev::Field.new 'foo', :date, :format => "%m%Y", :required => true }

    describe :validate! do
      it "should accept valid value" do
        expect { field.validate!(Date.today)  }.to_not raise_error
        expect { field.validate!(Time.now) }.to_not raise_error
      end

      it "should fail for invalid values" do
        [ 1000, '123', 100.5 ].each do |value|
          expect { field.validate!(value) }.to raise_error(ArgumentError, "Value given for field 'foo' is not a Date or Time")
        end
        expect { field.validate!(nil)     }.to raise_error(ArgumentError, "Value for field 'foo' is required")
      end
    end

    describe :output do
      it "should format using option" do
        expect(field.output(Date.new(2016,3,28))).to eq('032016')
      end
    end
  end

  context :boolean do
    let(:field) { Datev::Field.new 'foo', :boolean, :required => true }

    describe :validate! do
      it "should accept valid value" do
        expect { field.validate!(true)  }.to_not raise_error
        expect { field.validate!(false) }.to_not raise_error
      end

      it "should fail for invalid values" do
        [ 1000, '123', 100.5 ].each do |value|
          expect { field.validate!(value) }.to raise_error(ArgumentError, "Value given for field 'foo' is not a Boolean")
        end
        expect { field.validate!(nil)     }.to raise_error(ArgumentError, "Value for field 'foo' is required")
      end
    end

    describe :output do
      it "should return 0 or 1" do
        expect(field.output(true)).to eq(1)
        expect(field.output(false)).to eq(0)
      end
    end
  end
end
