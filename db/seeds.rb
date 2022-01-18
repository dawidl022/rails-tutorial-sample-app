# Create a main sample user.
User.create!(
  name: "Example User",
  email: "example@railstutorial.org",
  password: "foobar",
  password_confirmation: "foobar",
  admin: true,
  activated: true, activated_at: Time.zone.now
)

# Generate a bunch of additional users
1.upto(99).each do |n|
  name = Faker::Name.name
  email = "example-#{n}@railstutorial.org"
  password = "password"
  User.create!(
    name: name, email: email,
    password: password, password_confirmation: password,
    activated: true, activated_at: Time.zone.now
  )
end
