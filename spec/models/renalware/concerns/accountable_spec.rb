require "rails_helper"

module Renalware
  describe Accountable do
    before do
      @klass = Class.new(ApplicationRecord) do
        self.table_name = "quxes"
        include Accountable

        def self.name
          "Qux"
        end
      end

      @klass.reset_column_information
      create_relation
    end

    let(:created_by_user) { create(:user) }

    describe "#create" do
      context "given the created user is explicity assigned" do
        it "assigns the user who created the record" do
          subject = @klass.create!(created_by: created_by_user, dummy: ":: created it ::")

          expect(subject.created_by).to eq(created_by_user)
          expect(subject.updated_by).to eq(created_by_user)
        end
      end

      context "given the user is implicity assigned" do
        it "assigns the user who created the record" do
          subject = @klass.create!(by: created_by_user, dummy: ":: created it ::")

          expect(subject.created_by).to eq(created_by_user)
          expect(subject.updated_by).to eq(created_by_user)
        end
      end
    end

    describe "#updated_by" do
      let(:updated_by_user) { create(:user) }

      subject! { @klass.create!(created_by: created_by_user, dummy: ":: created it ::") }

      context "given the updated user is explicity assigned" do
        it "assigns the user who updated the record" do
          subject.update(updated_by: updated_by_user, dummy: ":: updated_it ::")

          expect(subject.updated_by).to eq(updated_by_user)
        end
      end

      context "given the updated user is implicity assigned" do
        it "assigns the user who updated the record" do
          subject = @klass.create!(by: created_by_user, dummy: ":: created it ::")
          subject.update(by: updated_by_user, dummy: ":: updated_it ::")

          expect(subject.updated_by).to eq(updated_by_user)
        end
      end
    end

    def create_relation
      ActiveRecord::Schema.define do
        self.verbose = false

        create_table :quxes, force: true do |t|
          t.string :dummy, null: false
          t.integer :created_by_id, null: false
          t.integer :updated_by_id, null: false
        end
      end
    end
  end
end
