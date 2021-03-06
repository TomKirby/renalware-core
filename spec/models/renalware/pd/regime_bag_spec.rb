# frozen_string_literal: true

require "rails_helper"
require "./spec/support/login_macros"

module Renalware
  RSpec.describe PD::RegimeBag, type: :model do
    it { is_expected.to belong_to(:regime).touch(true) }
    it { is_expected.to validate_presence_of :bag_type }
    it { is_expected.to validate_presence_of :volume }
    it { is_expected.to enumerize(:role).in(:ordinary, :additional_manual_exchange, :last_fill) }

    it do
      is_expected
        .to validate_numericality_of(:volume)
        .is_greater_than_or_equal_to(100)
        .is_less_than_or_equal_to(10000)
        .allow_nil
    end

    before do
      @patient = build_stubbed(:patient)
      @pd_regime_bag_1 = PD::RegimeBag.new
      @pd_regime_bag_2 = build(:pd_regime_bag,
                               sunday: true,
                               monday: false,
                               tuesday: true,
                               wednesday: false,
                               thursday: false,
                               friday: true,
                               saturday: false
                              )
    end

    describe "days" do
      it "returns days of the week which have been checked as true or false" do
        expect(@pd_regime_bag_2.days).to eq([true, false, true, false, false, true, false])
      end
    end

    describe "Date::DAYNAME_SYMBOLS" do
      it "converts rails date daynames module to become lowercase and to symbol" do
        days = [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]
        expect(Date::DAYNAME_SYMBOLS).to eq(days)
      end
    end
  end
end
