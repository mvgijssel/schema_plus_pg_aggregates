require 'schema_plus/core'
require_relative 'schema_plus_pg_aggregates/version'
require_relative 'schema_plus_pg_aggregates/aggregate_definition'
require_relative 'schema_plus_pg_aggregates/active_record/connection_adapters/postgresql_adapter'
require_relative 'schema_plus_pg_aggregates/middleware/postgresql/dumper'

SchemaMonkey.register SchemaPlusPgAggregates
