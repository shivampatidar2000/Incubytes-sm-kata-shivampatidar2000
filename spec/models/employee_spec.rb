require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'validations' do
    subject { build(:employee) }

    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:job_title) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:salary) }

    context 'with valid attributes' do
      it 'is valid with valid factory data' do
        employee = build(:employee)
        expect(employee).to be_valid
      end
    end

    context 'with missing attributes' do
      it 'is invalid without a full_name' do
        employee = build(:employee, full_name: nil)
        expect(employee).not_to be_valid
        expect(employee.errors[:full_name]).to include("can't be blank")
      end

      it 'is invalid without a job_title' do
        employee = build(:employee, job_title: nil)
        expect(employee).not_to be_valid
        expect(employee.errors[:job_title]).to include("can't be blank")
      end

      it 'is invalid without a country' do
        employee = build(:employee, country: nil)
        expect(employee).not_to be_valid
        expect(employee.errors[:country]).to include("can't be blank")
      end

      it 'is invalid without a salary' do
        employee = build(:employee, salary: nil)
        expect(employee).not_to be_valid
        expect(employee.errors[:salary]).to include("can't be blank")
      end
    end
  end
end
