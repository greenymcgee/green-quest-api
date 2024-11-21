json.involved_companies do
  json.array!(
    @involved_companies,
    partial: "api/involved_companies/involved_company",
    as: :involved_company,
  )
end
