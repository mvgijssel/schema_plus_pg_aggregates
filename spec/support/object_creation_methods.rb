module SchemaPlusPgAggregates::ObjectCreationMethods
  def create_aggregate(name = 'someagg', arguments: ['integer'])
    create_function("#{name}func", arguments: arguments + ['integer'])
    ActiveRecord::Base.connection.create_aggregate name,
      state_function: "#{name}func",
      state_data_type: 'integer',
      arguments: arguments
  end

  # TODO: need to have some sort of After rspec hook which cleans out all created aggregates
  # after each spec
  def drop_aggregate(name = 'someagg', arguments: ['integer'])
    ActiveRecord::Base.connection.drop_aggregate name, arguments: arguments
    drop_function("#{name}func", arguments: arguments + ['integer'])
  end

  def create_function(name = 'someaggfunc', arguments: ['integer', 'integer'])
    function_arguments = arguments.each_with_index.map do |argument, index|
      "$#{index + 1}"
    end
    ActiveRecord::Base.connection.execute <<-SQL
      CREATE FUNCTION #{name}(#{arguments.join(', ')}) RETURNS integer
        LANGUAGE sql
        AS $_$
          SELECT #{function_arguments.join(' + ')}
        $_$;
    SQL
  end

  def drop_function(name = 'somefunc', arguments: ['integer', 'integer'])
    ActiveRecord::Base.connection.execute <<-SQL
      DROP FUNCTION #{name}(#{arguments.join(', ')})
    SQL
  end

  def drop_aggregates
    results = ActiveRecord::Base.connection.query(<<-SQL, 'SCHEMA')
      SELECT
        'DROP AGGREGATE ' || n.nspname || '.' || proname || '(' ||
        CASE WHEN pronargs > 0 THEN oidvectortypes(proargtypes)
             ELSE '*'
        END
        || ')' || ' CASCADE;'
      FROM
        pg_proc p
      INNER JOIN pg_namespace n ON n.oid = p.pronamespace
      WHERE p.proisagg = true
        AND n.nspname = ANY (current_schemas(false))
    SQL

    results.each do |result|
      # TODO for some reason every result is an array with a single item?
      ActiveRecord::Base.connection.execute result[0]
    end
  end

  RSpec.configure do |config|
    config.after :each do |example|
      drop_aggregates
    end
  end
end
