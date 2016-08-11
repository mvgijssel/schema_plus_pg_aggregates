module SchemaPlusPgAggregates
  module Middleware
    module Dumper
      # So it's after all the table definitions and foreign_keys
      module Tables
        module Postgresql
          def after(env)
            env.connection.aggregates.sort_by(&:name).each do |aggregate|
              params = [aggregate.name.inspect]
              params << ":arguments => #{aggregate.arguments}" unless aggregate.arguments.nil?
              params << ":state_function => #{aggregate.state_function.inspect}"
              params << ":state_data_type => #{aggregate.state_data_type.inspect}"
              params << ":initial_condition => #{aggregate.initial_condition.inspect}" unless aggregate.initial_condition.nil?
              env.dump.final << "create_aggregate #{params.join(', ')}\n"
            end
          end
        end
      end
    end
  end
end

