require 'spec_helper'

describe Sqlighter do
  
  before(:each) do
    Sqlighter.new("tmp/test").destroy
  end

  it 'has a version number' do
    expect(Sqlighter::VERSION).not_to be nil
  end

  it 'can create a new table' do
    sl = Sqlighter.new("tmp/test")
    sl.schema({
      test_table: { 
      }
    })
    expect(sl.schema.keys).to eq [ :test_table ]

    sl = Sqlighter.new("tmp/test")
    expect(sl.schema.keys).to eq [ :test_table ]

    destoyed = sl.destroy
    expect(destoyed).to eq true
  end

  it 'detects a new table' do
    sl = Sqlighter.new("tmp/test")
    sl.schema({
      test_table: { 
      }
    })
    expect(sl.schema.keys).to eq [ :test_table ]

    sl = Sqlighter.new("tmp/test")
    sl.schema({
      test_table: {},
      test_table2: {}
    })
    expect(sl.schema.keys).to eq [ :test_table, :test_table2 ]

    sl = Sqlighter.new("tmp/test")
    expect(sl.schema.keys).to eq [ :test_table, :test_table2 ]

    destoyed = sl.destroy
    expect(destoyed).to eq true
  end

  it 'detects a missing table' do
    sl = Sqlighter.new("tmp/test")
    sl.schema({
      test_table: {},
      test_table2: {}
    })
    expect(sl.schema.keys).to eq [ :test_table, :test_table2 ]

    sl = Sqlighter.new("tmp/test")
    sl.schema({
      test_table: {}
    })
    expect(sl.schema.keys).to eq [ :test_table ]

    destoyed = sl.destroy
    expect(destoyed).to eq true
  end

  it 'adds a new field' do
    sl = Sqlighter.new("tmp/test")
    sl.schema({
      test_table: {
        col1: [ "VARCHAR(100)" ],
        col2: [ "VARCHAR(101)" ]
      }
    })
    expect(sl.schema.keys).to eq [ :test_table ]
    expect(sl.schema[:test_table][:col1]).to eq [ "VARCHAR(100)" ]
    expect(sl.schema[:test_table][:col2]).to eq [ "VARCHAR(101)" ]

    sl = Sqlighter.new("tmp/test")
    expect(sl.schema.keys).to eq [ :test_table ]
    expect(sl.schema[:test_table][:col1]).to eq [ "VARCHAR(100)" ]
    expect(sl.schema[:test_table][:col2]).to eq [ "VARCHAR(101)" ]

    destoyed = sl.destroy
    expect(destoyed).to eq true
  end

end