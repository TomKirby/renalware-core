# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe "Closed Session" do
      describe Session::Closed, type: :model do
        it { is_expected.to validate_presence_of(:signed_off_by) }
        it { is_expected.to validate_presence_of(:end_time) }
        it { is_expected.to validate_presence_of(:signed_off_at) }
        it { is_expected.to validate_presence_of(:dialysate) }

        it { is_expected.to belong_to(:profile) }
        it { is_expected.to belong_to(:dry_weight) }

        it "defines a policy class" do
          expect(Session::Closed.policy_class).to eq(ClosedSessionPolicy)
        end

        describe "immutable?" do
          it "returns true is the appropriate window has elapsed" do
            session = described_class.new(signed_off_at: Time.zone.now - 10.days)
            allow(session).to receive(:persisted?).and_return(true)

            expect(session.immutable?).to eq(true)
          end

          it "returns false if the appropriate window has not yet elapsed" do
            session = described_class.new(signed_off_at: Time.zone.now - 1.minute)
            allow(session).to receive(:persisted?).and_return(true)

            expect(session.immutable?).to eq(false)
          end

          it "returns true if not yet persisted" do
            session = described_class.new(signed_off_at: Time.zone.now - 1.minute)
            allow(session).to receive(:persisted?).and_return(false)

            expect(session.immutable?).to eq(true)
          end
        end
      end

      describe Session::Closed::SessionDocument do
        subject(:document) { Session::Closed::SessionDocument.new }

        [:hdf_pre, :hdf_post].each do |hd_type|
          it "validates presence of #hdf if hd_type is hdf" do
            document.info.hd_type = hd_type
            document.valid?
            expect(document.hdf.errors).to include(:subs_fluid_pct,
                                                   :subs_goal,
                                                   :subs_rate,
                                                   :subs_volume)
          end
        end

        it "does not validate presence of hdf if hd_type is HD" do
          document.info.hd_type = :hd
          document.valid?
          expect(document.hdf.errors).not_to include(:subs_fluid_pct)
        end
      end

      describe Session::Closed::SessionDocument::Info do
        it { is_expected.to validate_presence_of(:hd_type) }
        it { is_expected.to validate_presence_of(:access_confirmed) }
      end

      describe Session::Closed::SessionDocument::Dialysis do
        it { is_expected.to validate_presence_of(:arterial_pressure) }
        it { is_expected.to validate_presence_of(:venous_pressure) }
        it { is_expected.to validate_presence_of(:fluid_removed) }
        it { is_expected.to validate_presence_of(:blood_flow) }
        it { is_expected.to validate_presence_of(:flow_rate) }
        it { is_expected.not_to validate_presence_of(:machine_urr) }
        it { is_expected.not_to validate_presence_of(:machine_ktv) }
        it { is_expected.to validate_presence_of(:litres_processed) }
      end

      describe Session::Closed::SessionDocument::Observations do
        subject(:observations) {
          Session::Closed::SessionDocument::Observations.new(blood_pressure: BloodPressure.new)
        }

        describe "validation" do
          it { is_expected.to validate_presence_of(:pulse) }

          it { is_expected.not_to validate_presence_of(:bm_stix) }
          it { is_expected.to validate_presence_of(:weight_measured) }
          it { is_expected.to validate_presence_of(:temperature_measured) }

          it "validates presence of blood_pressure" do
            expect(observations).not_to be_valid
            expect(observations.blood_pressure.errors).to include(:systolic, :diastolic)
          end

          describe "#weight" do
            it "validate weight when weight_measured is true" do
              observations.weight_measured = :yes
              expect(observations).to validate_presence_of(:weight)
            end

            it "does not validate weight when weight_measured is false" do
              observations.weight_measured = :no
              expect(observations).not_to validate_presence_of(:weight)
            end
          end

          describe "#temperature" do
            it "validate temperature when temperature_measured is true" do
              observations.temperature_measured = :yes
              expect(observations).to validate_presence_of(:temperature)
            end

            it "does not validate temperature when weight_measured is false" do
              observations.temperature_measured = :no
              expect(observations).not_to validate_presence_of(:temperature)
            end
          end
        end
      end
    end
  end
end
