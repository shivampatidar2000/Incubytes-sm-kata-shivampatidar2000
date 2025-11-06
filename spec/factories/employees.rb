FactoryBot.define do
  factory :employee do
    full_name { Faker::Name.name }
    job_title { Faker::Job.title }
    country { Faker::Address.country }
    salary { Faker::Number.between(from: 30_000, to: 150_000) }
  end
end
