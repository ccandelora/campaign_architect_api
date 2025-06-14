FactoryBot.define do
  factory :background_job do
    job_id { "MyString" }
    job_type { "MyString" }
    status { "MyString" }
    result { "" }
    campaign { nil }
  end
end
