require 'spec_helper'

describe 'ActiveRecord::Migration', postgresql: :only do
  before(:all) { ActiveRecord::Migration.verbose = false }
  let(:migration) { ActiveRecord::Migration }

  describe 'aggregates' do
    it 'returns all aggregates' do
      create_aggregate name: 'someagg1'
      create_aggregate name: 'someagg2'
      expect(migration.aggregates.count).to eq 2
    end
  end

  describe 'create_aggregate' do
    it 'creates the aggregate' do
      create_function 'somefunc'
      expect do
        migration.create_aggregate 'someagg',
          arguments: ['integer'],
          state_function: 'somefunc',
          state_data_type: 'integer',
          initial_condition: 0
      end.to change { migration.aggregates.count }.from(0).to(1)
    end

    it 'has the right attributes' do
      create_function 'somefunc'
      migration.create_aggregate 'someagg1',
        arguments: ['integer'],
        state_function: 'somefunc',
        state_data_type: 'integer',
        initial_condition: 0

      expect(migration.aggregates).to eq [
        SchemaPlusPgAggregates::AggregateDefinition.new(
          name: 'someagg1',
          arguments: ['integer'],
          state_function: 'somefunc',
          state_data_type: 'integer',
          initial_condition: '0',
        )
      ]
    end

    it 'creates an aggregate when no arguments are given' do
      create_aggregate name: "someagg", arguments: []
      expect(migration.aggregates.map(&:arguments)).to eq [[]]
    end
  end

  describe 'drop_aggregate' do
    it 'removes the aggregate' do
      create_aggregate name: 'someagg', arguments: ['integer']
      expect { migration.drop_aggregate 'someagg', arguments: ['integer'] }
        .to change { migration.aggregates.count }.from(1).to(0)
    end
  end
end
