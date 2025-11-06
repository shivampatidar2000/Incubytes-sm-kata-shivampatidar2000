require 'rails_helper'

RSpec.describe SalaryMetricsController, type: :controller do
  describe "GET #by_country" do
    context "when employees exist for the given country" do
      let!(:emp1) { FactoryBot.create(:employee, country: "India", salary: 50_000) }
      let!(:emp2) { FactoryBot.create(:employee, country: "India", salary: 70_000) }
      let!(:emp3) { FactoryBot.create(:employee, country: "India", salary: 90_000) }

      it "returns min, max, and avg salary for that country" do
        get :by_country, params: { country: "India" }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["country"]).to eq("India")
        expect(json["min_salary"]).to eq(50_000)
        expect(json["max_salary"]).to eq(90_000)
        expect(json["avg_salary"]).to eq(70_000.0)
      end
    end

    context "when no employees exist for the given country" do
      it "returns a not found message" do
        get :by_country, params: { country: "Japan" }

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("No employees found in Japan")
      end
    end
  end

  describe "GET #by_job_title" do
    context "when employees exist for the given job title" do
      let!(:emp1) { FactoryBot.create(:employee, job_title: "Developer", salary: 60_000) }
      let!(:emp2) { FactoryBot.create(:employee, job_title: "Developer", salary: 80_000) }

      it "returns avg salary for that job title" do
        get :by_job_title, params: { job_title: "Developer" }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["job_title"]).to eq("Developer")
        expect(json["avg_salary"]).to eq(70_000.0)
      end
    end

    context "when no employees exist for the given job title" do
      it "returns a not found message" do
        get :by_job_title, params: { job_title: "Designer" }

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("No employees found with title Designer")
      end
    end
  end
end
