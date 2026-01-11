require 'rails_helper'

RSpec.describe "Nearest Customers API", type: :request do
  let(:headers) do
    { "CONTENT_TYPE" => "multipart/form-data" }
  end

  let(:invalid_format) do
    fixture_file_upload(
      Rails.root.join('spec/fixtures/files/invalid_format.pdf'),
      'application/pdf'
    )
  end

  let(:only_text) do
    fixture_file_upload(
      Rails.root.join('spec/fixtures/files/only_text.txt'),
      'text/plain'
    )
  end

  let(:valid_json) do
    fixture_file_upload(
      Rails.root.join('spec/fixtures/files/valid_json.txt'),
      'text/plain'
    )
  end

  it "returns 400 when file is missing" do
    post "/api/v1/customers/nearest_customers"

    expect(response).to have_http_status(:bad_request)

    body = JSON.parse(response.body)
    expect(body["error"]).to eq("File missing")
  end

  it "returns 422 for invalid file format" do
    post "/api/v1/customers/nearest_customers",
         params: { file: invalid_format },
         headers: headers

    expect(response).to have_http_status(:unprocessable_entity)
  end

  it "returns empty customers for plain text file" do
    post "/api/v1/customers/nearest_customers",
         params: { file: only_text },
         headers: headers

    expect(response).to have_http_status(:ok)

    body = JSON.parse(response.body)
    expect(body["customers"]).to eq([])
  end

  it "returns invalid json line numbers in message" do
    post "/api/v1/customers/nearest_customers",
         params: { file: valid_json },
         headers: headers

    body = JSON.parse(response.body)
    expect(body["message"]).to include("Invalid json at lines")
  end

  it "returns nearest sorted customers using IDs within 100km" do
    post "/api/v1/customers/nearest_customers",
         params: { file: valid_json },
         headers: headers

    expect(response).to have_http_status(:ok)

    body = JSON.parse(response.body)
    customers = body["customers"]

    expect(customers).not_to be_empty
    expect(customers.size).to eq(2)
    expect(customers.first.keys).to match_array(%w[id name])
    expect(customers[0]["name"]).to eq("User Three")
    expect(customers[1]["name"]).to eq("User One")    
  end
end
