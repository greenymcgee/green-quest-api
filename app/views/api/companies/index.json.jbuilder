json.companies do
  json.array! @companies, partial: "api/companies/company", as: :company
end
