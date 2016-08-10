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

    def ==(other)
      eq other
    end

    def eq(other)
      return false unless other.class == self.class
      return false unless name == other.name
      return false unless arguments == other.arguments
      return false unless state_function == other.state_function
      return false unless state_data_type == other.state_data_type
      return false unless initial_condition == other.initial_condition
      return true
    end
  end
end
