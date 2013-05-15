require 'lims-core/persistence/sequel/persistor'
require 'lims-management-app/sample/taxonomy/taxonomy_persistor'

module Lims::ManagementApp
  class Sample
    class Taxonomy
      class TaxonomySequelPersistor < TaxonomyPersistor
        include Lims::Core::Persistence::Sequel::Persistor

        def self.table_name
          :taxonomies
        end

        # @param [Integer] taxon_id
        # @param [String] name
        # @param [String] type
        # @return [Integer,Nil]
        # Case insensitive lookup for the taxonomy id
        # based on taxon_id, name and type.
        def id_by_taxon_id_and_name(taxon_id, name, type)
          self.dataset.select(primary_key).where({
            :taxon_id => taxon_id
          }).where {
            {lower(:name) => lower(name)}
          }.where {
            {lower(:type) => lower(type)}
          }.first[primary_key]
        end
      end
    end
  end
end
