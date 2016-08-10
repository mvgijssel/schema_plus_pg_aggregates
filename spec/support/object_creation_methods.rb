module SchemaPlusPgAggregates::ObjectCreationMethods
  def create_aggregate
    create_function
    ActiveRecord::Base.connection.create_aggregate 'someagg',
      state_function: 'somefunc',
      state_data_type: 'integer',
      arguments: ['integer']
  end

  def drop_aggregate
    ActiveRecord::Base.connection.drop_aggregate 'someagg', arguments: ['integer']
    drop_function
  end

  def create_function
    ActiveRecord::Base.connection.execute <<-SQL
      CREATE FUNCTION somefunc(integer, integer) RETURNS integer
          LANGUAGE sql
          AS $_$
            SELECT $1 + $2
          $_$;
        SQL
  end

  def drop_function
    ActiveRecord::Base.connection.execute <<-SQL
      DROP FUNCTION somefunc(integer, integer)
    SQL
  end
end
