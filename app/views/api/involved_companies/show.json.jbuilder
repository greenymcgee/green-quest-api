json.involved_company do
  json.partial!(
    "api/involved_companies/involved_company",
    involved_company: @involved_company,
  )
end
