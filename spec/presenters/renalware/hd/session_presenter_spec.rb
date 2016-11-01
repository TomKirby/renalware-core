require "rails_helper"

module Renalware
  module HD
    describe SessionPresenter do
      let(:session) { double("Session", document: Renalware::HD::SessionDocument.new) }
      subject(:presenter) { SessionPresenter.new(session) }

      it { is_expected.to respond_to(:hospital_unit_unit_code) }

      describe "#summarised_access_used" do
        it "delegates to SessionAccessPresenter" do
          expect_any_instance_of(SessionAccessPresenter).to receive(:to_html)
          presenter.summarised_access_used
        end
      end

      describe "#access_used" do
        it "delegates to SessionAccessPresenter" do
          expect_any_instance_of(SessionAccessPresenter).to receive(:to_s)
          presenter.access_used
        end
      end

      describe "#change_in" do
        context "Float values" do
          it "returns the difference between before and after measurements rounded to 1 DP" do
            session.document.observations_before.weight = 101.1
            session.document.observations_after.weight = 100.0
            expect(presenter.change_in(:weight)).to eq(-1.1)
          end
        end
        context "Integer values" do
          it "returns the difference between before and after measurements" do
            session.document.observations_before.pulse = 70
            session.document.observations_after.pulse = 80
            expect(presenter.change_in(:pulse)).to eq 10
          end
        end
        context "Invalid values" do
          it "returns nil if before or after measurement missing" do
            session.document.observations_before.pulse = 70
            session.document.observations_after.pulse = nil
            expect(presenter.change_in(:pulse)).to be_nil
          end
        end
      end

      describe "#before_measurement_for" do
        it "returns the pre-dialysis measurement" do
          session.document.observations_before.weight = 101.1
          expect(presenter.before_measurement_for(:weight)).to eq 101.1
        end
      end
      describe "#after_measurement_for" do
        it "returns the post-dialysis measurement" do
          session.document.observations_after.weight = 101.1
          expect(presenter.after_measurement_for(:weight)).to eq 101.1
        end
      end
    end
  end
end