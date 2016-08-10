module SchemaPlusPgAggregates::ObjectCreationMethods
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
end
