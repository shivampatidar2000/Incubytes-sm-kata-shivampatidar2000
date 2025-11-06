class SalaryMetricsController < ApplicationController
  def by_country
    @employee = Employee.where(country: params[:country])
    if @employee.any?
      render json: {
        country: params[:country],
        min_salary: @employee.minimum(:salary).to_f,
        max_salary: @employee.maximum(:salary).to_f,
        avg_salary: @employee.average(:salary).to_f.round(2)
      }
    else
      render json: { message: "No employees found in #{params[:country]}" }, status: :not_found
    end
  end

  def by_job_title
    @employee = Employee.where(job_title: params[:job_title])
    if @employee.any?
      render json: {
        job_title: params[:job_title],
        avg_salary: @employee.average(:salary).to_f.round(2)
      }
    else
      render json: { message: "No employees found with title #{params[:job_title]}" }, status: :not_found
    end
  end
end
