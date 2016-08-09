require 'spec_helper'

def create_function
  ActiveRecord::Base.connection.execute <<-SQL
    CREATE FUNCTION somefunc(integer, integer) RETURNS integer
        LANGUAGE sql
        AS $_$
          SELECT $1 + $2
        $_$;
      SQL
end

def dop_function
  ActiveRecord::Base.connection.execute <<-SQL
    DROP FUNCTION somefunc(integer, integer)
  SQL
end

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
