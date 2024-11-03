class UserSerializer
  include JSONAPI::Serializer
  # TODO: add roles
  attributes :id, :email, :first_name, :last_name
end
