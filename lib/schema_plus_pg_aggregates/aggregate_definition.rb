module SchemaPlusPgAggregates
  class AggregateDefinition
    attr_reader :name, :arguments, :state_function, :state_data_type, :initial_condition

    def initialize(name:, arguments:, state_function:, state_data_type:, initial_condition:)
      @name = name
      @arguments = arguments
      @state_function = state_function
      @state_data_type = state_data_type
      @initial_condition = initial_condition
    end
  end
end
