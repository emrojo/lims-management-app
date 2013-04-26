require 'lims-core/resource'
require 'lims-management-app/sample/dna/dna'
require 'lims-management-app/sample/rna/rna'
require 'lims-management-app/sample/cellular_material/cellular_material'
require 'lims-management-app/sample/validation_shared'
require 'securerandom'

module Lims::ManagementApp
  class Sample
    include Lims::Core::Resource
    include ValidationShared

    # required attributes
    attribute :sanger_sample_id, String, :required => true, :initializable => true
    attribute :gender, String, :required => true, :initializable => true
    attribute :sample_type, String, :required => true, :initializable => true

    # The attributes below are all strings, not required with a private writer
    %w(hmdmc_number supplier_sample_name common_name ebi_accession_number sample_source
    mother father sibling gc_content public_name cohort storage_conditions).each do |name|
      attribute :"#{name}", String, :required => false, :initializable => true
    end

    attribute :taxon_id, Numeric, :required => false, :initializable => true
    attribute :volume, Integer, :required => false, :initializable => true
    attribute :date_of_sample_collection, DateTime, :required => false, :initializable => true
    attribute :is_sample_a_control, Boolean, :required => false, :initializable => true
    attribute :is_re_submitted_sample, Boolean, :required => false, :initializable => true
    attribute :dna, Dna, :required => false, :initializable => true
    attribute :rna, Rna, :required => false, :initializable => true
    attribute :cellular_material, CellularMaterial, :required => false, :initializable => true

    def generate_sanger_sample_id
      @sanger_sample_id = SangerSampleID.generate
      self
    end

    private

    module SangerSampleID
      # @param [String,Integer] unique identifier
      # @return [String]
      # Generate a new sanger sample id using the
      # unique identifier in parameter.
      # @example S2-521-ID
      def self.generate
        "S2-#{unique_identifier.to_s}-ID"
      end

      def self.unique_identifier
        SecureRandom.hex(10)
      end
    end
  end
end
