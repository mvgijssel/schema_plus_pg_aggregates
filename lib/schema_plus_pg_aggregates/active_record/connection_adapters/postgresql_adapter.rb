module SchemaPlusPgAggregates
  module ActiveRecord
    module ConnectionAdapters
      module PostgresqlAdapter
        def aggregates
          result = exec_query(<<-SQL, 'SCHEMA')
            SELECT
              p.proname AS name,
              (SELECT string_agg(format_type(t, null), ',') FROM unnest(p.proargtypes::oid[]) t) AS arguments,
              a.aggtransfn::varchar AS state_function,
              format_type(a.aggtranstype, null) AS state_data_type,
              a.agginitval AS initial_condition
            FROM
              pg_proc p
            INNER JOIN pg_aggregate a ON p.oid = a.aggfnoid
            WHERE p.proisagg = true
              AND p.pronamespace IN (SELECT oid FROM pg_namespace WHERE nspname = ANY (current_schemas(false)) )
          SQL

          result.to_hash.map do |row|
            row['arguments'] = row['arguments'].split(',')
            AggregateDefinition.new row.symbolize_keys
          end
        end

        def create_aggregate(name, state_function:, state_data_type:, initial_condition: nil, arguments: [])
          settings = [
            "SFUNC = #{state_function}",
            "STYPE = #{state_data_type}"
          ]
          settings << "INITCOND = #{initial_condition.inspect}" unless initial_condition.nil?
          execute <<-SQL
            CREATE AGGREGATE #{name}(#{arguments.empty? ? "*" : arguments.join(', ')})(
              #{settings.join(",\n")}
            )
          SQL
        end

        def drop_aggregate(name, arguments: [])
          execute <<-SQL
            DROP AGGREGATE #{name}(#{arguments.empty? ? "*" : arguments.join(', ')})
          SQL
        end
      end
    end
  end
end
