FactoryBot.define do
  factory :swipe_file do
    title { "MyString" }
    content { "MyText" }
    tags { "MyText" }
    brand { "MyString" }
    user { nil }
  end
end
