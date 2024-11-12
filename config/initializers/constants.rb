USER_ROLES = { admin: "Admin", basic: "Basic" }.freeze
PASSWORD_COMPLEXITY_REGEX =
  /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/.freeze
PASSWORD_COMPLEXITY_ERROR_MESSAGE =
  "Password must include: 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character".freeze
