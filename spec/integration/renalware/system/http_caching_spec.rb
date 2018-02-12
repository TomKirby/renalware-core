require "rails_helper"

RSpec.describe "HTTP Caching", type: :request do
  let(:patient) { create(:patient) }

  # Note spec/dummy/app/controllers/applciation_controller
  # must include the cache busting concern for this test to pass
  context "when hitting a page inside the engine" do
    describe "Cache-Control HTTP Header" do
      it "includes 'no-store' so the user cannot navigate back" do
        get patient_clinical_summary_path(patient)

        expect(response.headers["Cache-Control"])
          .to eq("no-cache, no-store, max-age=0, must-revalidate")
      end
    end
  end
end
