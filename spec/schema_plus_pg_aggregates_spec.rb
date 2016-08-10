require 'spec_helper'

describe 'pg_aggregates', postgresql: :only do
  before(:all) { ActiveRecord::Migration.verbose = false }
  let(:migration) { ActiveRecord::Migration }

  describe 'aggregates' do
    it 'returns all aggregates' do
      begin
        create_aggregate('someagg1')
        create_aggregate('someagg2')

        expect(migration.aggregates.count).to eq 2
      ensure
        drop_aggregate('someagg1')
        drop_aggregate('someagg2')
      end
    end
  end

  describe 'create_aggregate' do
    it 'creates the aggregate' do
      begin
        expect { create_aggregate }.to change { migration.aggregates.count }.from(0).to(1)
      ensure
        drop_aggregate
      end
    end

    it 'creates an aggregate when no arguments are given' do
      begin
        create_aggregate "someagg", arguments: []
        expect(migration.aggregates.count).to eq 1
        expect(migration.aggregates[0].arguments).to eq []
      ensure
        drop_aggregate "someagg", arguments: []
      end
    end
  end

  describe 'drop_aggregate' do
    it 'removes the aggregate' do
      create_aggregate 'someagg', arguments: ['integer']
      expect { migration.drop_aggregate('someagg', arguments: ['integer']) }
        .to change { migration.aggregates.count }.from(1).to(0)
    end
  end
end
