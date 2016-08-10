require 'spec_helper'

describe 'pg_aggregates', postgresql: :only do
  before(:all) { ActiveRecord::Migration.verbose = false }
  let(:migration) { ActiveRecord::Migration }

  describe 'aggregates' do
    it 'returns all aggregates' do
      begin
        create_aggregate
      ensure
        drop_aggregate
      end
    end
  end

  describe 'create_aggregate' do
  end

  describe 'drop_aggregate' do
  end
end
