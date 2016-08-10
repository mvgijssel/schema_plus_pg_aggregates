require 'spec_helper'

describe 'pg_aggregates', postgresql: :only do
  before(:all) { ActiveRecord::Migration.verbose = false }
  let(:migration) { ActiveRecord::Migration }

  describe 'aggregates' do
    it 'returns all aggregates' do
      begin
        create_function
        migration.create_aggregate 'someagg',
          state_function: 'somefunc',
          state_data_type: 'integer',
          arguments: ['integer']
      ensure
        migration.drop_aggregate 'someagg', arguments: ['integer']
        dop_function
      end
    end
  end
end
