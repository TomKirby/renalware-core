# frozen_string_literal: true

module World
  module PD::CAPDRegime
    module Domain
      def record_capd_regime_for(patient:, user:)
        Renalware::PD::CAPDRegime.for_patient(patient).create!(start_date: Time.zone.now,
                                                               treatment: "Treatment") do |regime|
          regime.bags << Renalware::PD::RegimeBag.new(
            volume: 1000,
            bag_type: Renalware::PD::BagType.first
          )
        end
      end

      def regime_is_immutable(regime)
        expect(regime).to_not be_current
      end
    end

    module Web
      include Domain

      # rubocop:disable Metrics/MethodLength
      def record_capd_regime_for(patient:, user:)
        login_as user
        dashboard_path = patient_pd_dashboard_path(patient)
        visit dashboard_path

        within ".page-actions" do
          click_on "Add"
          click_on "CAPD Regime"
        end

        fill_in "* Start date", with: "02/04/2015"
        fill_in "End date", with: "02/05/2015"

        select "1 week", from: "Delivery interval"
        select "Baxter", from: "System"
        select("CAPD 4 exchanges per day", from: "Treatment")

        check "On additional HD"

        find("a.add-bag").click && wait_for_ajax

        select("Dianeal PD2 1.36% (Yellow)", from: "Bag type")
        select("2500", from: "* Volume (ml)")
        uncheck "Tue"
        uncheck "Sat"

        within ".patient-content" do
          click_on "Save"
        end

        expect(page).to have_current_path(dashboard_path)

        # return the regime
        patient.pd_regimes.order(created_at: :desc).first
      end

      def regime_is_immutable(regime)
        visit patient_pd_dashboard_path(regime.patient)
        within "tr[data-regime-id='#{regime.id}']" do
          expect(all(".update-pd-regime").length).to eq(0)
        end
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
