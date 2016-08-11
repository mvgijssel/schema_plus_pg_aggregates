require 'spec_helper'

describe 'Schema dump' do
  it 'generates an aggregate statement in the schema' do
    create_aggregate \
      name: 'someagg',
      arguments: ['integer'],
      state_function: 'somefunc',
      state_data_type: 'integer',
      initial_condition: 0

    expect(dump_schema).to include(
      "  create_aggregate \"someagg\", " \
      ":arguments => [\"integer\"], " \
      ":state_function => \"somefunc\", " \
      ":state_data_type => \"integer\", " \
      ":initial_condition => \"0\"\n"
    )
  end

  it 'ignores unset attributes' do
    create_aggregate \
      name: 'someagg',
      arguments: ['integer'],
      state_function: 'somefunc',
      state_data_type: 'integer',
      initial_condition: nil

    expect(dump_schema).to include(
      "  create_aggregate \"someagg\", " \
      ":arguments => [\"integer\"], " \
      ":state_function => \"somefunc\", " \
      ":state_data_type => \"integer\"\n"
    )
  end

  it 'generates multiple arguments' do
    create_aggregate \
      name: 'someagg',
      arguments: ['integer', 'integer'],
      state_function: 'somefunc',
      state_data_type: 'integer',
      initial_condition: 0

    expect(dump_schema).to include(
      "  create_aggregate \"someagg\", " \
      ":arguments => [\"integer\", \"integer\"], " \
      ":state_function => \"somefunc\", " \
      ":state_data_type => \"integer\", " \
      ":initial_condition => \"0\"\n"
    )
  end

  it 'lists aggregates alphabetically' do
    create_aggregate \
      name: 'bggregate',
      arguments: ['integer'],
      state_function: 'bfunc',
      state_data_type: 'integer',
      initial_condition: 0

    create_aggregate \
      name: 'aggregate',
      arguments: ['integer'],
      state_function: 'afunc',
      state_data_type: 'integer',
      initial_condition: 0

    expect(dump_schema).to include(
      "  create_aggregate \"aggregate\", " \
      ":arguments => [\"integer\"], " \
      ":state_function => \"afunc\", " \
      ":state_data_type => \"integer\", " \
      ":initial_condition => \"0\"\n" \
      "  create_aggregate \"bggregate\", " \
      ":arguments => [\"integer\"], " \
      ":state_function => \"bfunc\", " \
      ":state_data_type => \"integer\", " \
      ":initial_condition => \"0\"\n"
    )
  end
end
