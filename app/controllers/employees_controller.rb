class EmployeesController < ApplicationController
  before_action :set_employee, only: [ :show, :update, :destroy, :calculate_salary ]
  def index
    @employees =  Employee.all
    render json: { data: @employees }, status: 200
  end

  def show
    if @employee.present?
      render json: { data: @employee }, status: 200
    else
      render json: { error: "Record not found" }, status: 422
    end
  end
  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      render json: {  message: "Employee created successfully", data: @employee }, status: 201
    else
      render json: { error: @employee.errors.full_messages }, status: 422
    end
  end

  def update
    if @employee.update(employee_params)
      render json: {  message: "Employee updated successfully", data: @employee }, status: 200
    else
      render json: { error: @employee.errors.full_messages }, status: 422
    end
  end
  def destroy
    if @employee.destroy
      render json: { data: "Employee delete successfully " }, status: 200
    else
      render json: { err0r: "Employee not deleted" }, status: 422
    end
  end

  def calculate_salary
    gross = @employee.salary.to_f
    net =
    case @employee.country.downcase
    when "india"
      then gross * 0.9
    when "united states"
      then gross * 0.88
    else gross
    end
    render json: {
      employee_id: @employee.id,
      gross_salary: gross,
      deductions: (gross - net).round(2),
      net_salary: net.round(2)
    }
  end

  private

  def employee_params
    params.require(:employee).permit(:full_name, :job_title, :country, :salary)
  end

  def set_employee
    @employee = Employee.find(params[:id])
  end
end
