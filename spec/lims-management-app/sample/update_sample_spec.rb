require 'lims-management-app/sample/update_sample'
require 'lims-management-app/sample/sample_shared'
require 'lims-management-app/spec_helper'
require 'integrations/spec_helper'

module Lims::ManagementApp
  describe Sample::UpdateSample do
    shared_examples_for "updating a sample" do
      include_context "create object"
      it_behaves_like "an action"

      it "updates a sample object" do
        Lims::Core::Persistence::Session.any_instance.should_receive(:save)
        result = subject.call
        sample = result[:sample]
        sample.should be_a(Sample)
        updated_parameters.each do |k,v|
          v = DateTime.parse(v) if k.to_s =~ /date/
          if [:dna, :rna, :cellular_material].include?(k)
            v.each do |k2,v2|
              sample.send(k).send(k2).to_s.should == v2.to_s
            end
          else
            sample.send(k).to_s.should == v.to_s
          end
        end
      end
    end

    include_context "sample factory"
    include_context "for application", "sample update"
    let!(:store) { Lims::Core::Persistence::Store.new }
    let(:new_gender) { "Female" }
    let(:new_sample_type) { "DNA Pathogen" }
    let(:new_dna) { {:sample_purified => false} }
    let(:parameters) { 
      {
        :store => store, 
        :user => user, 
        :application => application,
        :sample => new_common_sample
      }
    }
    let(:updated_parameters) { update_parameters(full_sample_parameters) }

    context "invalid action" do
      it "requires a sample or a sanger sample id" do
        described_class.new(parameters - [:sample]).valid?.should == false
      end
    end


    context "valid action given a sample" do
      subject {
        described_class.new(:store => store, :user => user, :application => application) do |a,s|
          a.sample = new_sample_with_dna_rna_cellular
          updated_parameters.each do |k,v|
            a.send("#{k}=", v)
          end
        end
      }

      it "is valid" do
        described_class.new(parameters).valid?.should == true
      end

      it_behaves_like "updating a sample"
    end
  end
end
