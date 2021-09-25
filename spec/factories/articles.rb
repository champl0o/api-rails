FactoryBot.define do
  factory :article do
    title { "Sample article" }
    content { "Sample content" }
    sequence(:slug) { |n| "article-#{n}-#{title}"}
  end
end