require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  employee = FactoryBot.create(:employee)

  describe "GET /index" do
    it "show all the employee" do
      get :index
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(1)
    end
  end


  describe "GET / show" do
    it "show particuler one employee record" do
      get :show, params: { id: employee.id }
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["data"]["id"]).to eq(employee.id)
      expect(json_response["data"]["full_name"]).to eq(employee.full_name)
    end
  end

   describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          employee: {
            full_name: Faker::Name.name,
            job_title: Faker::Job.title,
            country: Faker::Address.country,
            salary: Faker::Number.between(from: 30_000, to: 150_000)
          }
        }
      end

      it "creates a new employee and returns success message" do
        expect {
          post :create, params: valid_params
        }.to change(Employee, :count).by(1)

        expect(response).to have_http_status(201)
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Employee created successfully")
        expect(json["data"]["full_name"]).to eq(valid_params[:employee][:full_name])
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        { employee: { full_name: "", job_title: "", country: "", salary: nil } }
      end

      it "does not create an employee and returns error messages" do
        expect {
          post :create, params: invalid_params
        }.not_to change(Employee, :count)

        expect(response).to have_http_status(422)
        json = JSON.parse(response.body)
        expect(json["error"]).to include("Full name can't be blank")
      end
    end
  end

   describe "PUT #update" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          id: employee.id,
          employee: {
            full_name: "Updated Name",
            job_title: "Updated Job Title",
            country: "Updated Country",
            salary: 90000
          }
        }
      end

      it "updates the employee and returns success message" do
        put :update, params: valid_params

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Employee updated successfully")
        expect(json["data"]["full_name"]).to eq("Updated Name")

        employee.reload
        expect(employee.full_name).to eq("Updated Name")
        expect(employee.salary).to eq(90000)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          id: employee.id,
          employee: { full_name: "", job_title: "", country: "", salary: nil }
        }
      end

      it "does not update the employee and returns error messages" do
        put :update, params: invalid_params

        expect(response).to have_http_status(422)
        json = JSON.parse(response.body)
        expect(json["error"]).to include("Full name can't be blank")
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the employee" do
      employee = Employee.second

      expect {
        delete :destroy, params: { id: employee.id }
      }.to change(Employee, :count).by(-1)

      expect(response).to have_http_status(200)
    end
  end

  describe "GET #calculate_salary" do
    context "when employee is from India" do
      let!(:employee1) { FactoryBot.create(:employee, country: "India", salary: 100_000) }

      it "calculates 10% deduction for India" do
        get :calculate_salary, params: { id: employee1.id }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["employee_id"]).to eq(employee1.id)
        expect(json["gross_salary"]).to eq(100_000.0)
        expect(json["deductions"]).to eq(10_000.0)
        expect(json["net_salary"]).to eq(90_000.0)
      end
    end

    context "when employee is from United States" do
      let!(:employee2) { FactoryBot.create(:employee, country: "United States", salary: 100_000) }

      it "calculates 12% deduction for the US" do
        get :calculate_salary, params: { id: employee2.id }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["employee_id"]).to eq(employee2.id)
        expect(json["gross_salary"]).to eq(100_000.0)
        expect(json["deductions"]).to eq(12_000.0)
        expect(json["net_salary"]).to eq(88_000.0)
      end
    end

    context "when employee is from other countries" do
      let!(:employee3) { create(:employee, country: "Japan", salary: 100_000) }

      it "returns full salary with no deductions" do
        get :calculate_salary, params: { id: employee3.id }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["employee_id"]).to eq(employee3.id)
        expect(json["gross_salary"]).to eq(100_000.0)
        expect(json["deductions"]).to eq(0.0)
        expect(json["net_salary"]).to eq(100_000.0)
      end
    end
  end
end
