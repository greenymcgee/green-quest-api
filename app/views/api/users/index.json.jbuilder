json.users @users do |user|
  json.admin user.admin?
  json.email user.email
  json.first_name user.first_name || ""
  json.id user.id
  json.last_name user.last_name || ""
  json.username user.username
end
