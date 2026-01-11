class Api::V1::CustomersController < ApplicationController
  def nearest_customers
    file = params[:file]

    return render json: { error: "File missing" }, status: :bad_request unless file
    return render json: { error: "Invalid file format" }, status: :unprocessable_entity unless File.extname(file.original_filename) == ".txt"

    result = ::Customers::NearestCustomersService.new(file).call

    message =
      result.invalid_lines.any? ?
        "Invalid json at lines #{ result.invalid_lines.join(', ') }" :
        "nearest customers"

    render json: { message: message, customers: result.customers }, status: :ok
  end
end
