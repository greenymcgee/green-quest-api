json.company_logos do
  json.array!(
    @company_logos,
    partial: "api/company_logos/company_logo",
    as: :company_logo,
  )
end
