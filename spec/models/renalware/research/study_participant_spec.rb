# frozen_string_literal: true

require "rails_helper"

module Renalware
  RSpec.describe Research::StudyParticipant, type: :model do
    it_behaves_like "an Accountable model"
    it_behaves_like "a Paranoid model"
    it { is_expected.to validate_presence_of :participant_id }

    describe "uniqueness" do
      subject{
        Research::StudyParticipant.new(
          participant_id: patient.id,
          study_id: study.id,
          joined_on: "2018-01-01"
        )
      }
      let(:study) { create(:research_study) }
      let(:patient) { create(:patient) }

      it { is_expected.to validate_uniqueness_of(:external_id) }
    end

    describe ".external_application_participant_url" do
      subject do
        build_stubbed(:research_study_participant, study: study, external_id: "123")
          .external_application_participant_url
      end

      context "when the study has no application_link" do
        let(:study) { build_stubbed(:research_study, application_url: nil) }

        it { is_expected.to be_nil }
      end

      context "when the study has an application_link" do
        let(:study) { build_stubbed(:research_study, application_url: "http://test/{external_id}") }

        it { is_expected.to eq("http://test/123") }
      end
    end
  end
end
