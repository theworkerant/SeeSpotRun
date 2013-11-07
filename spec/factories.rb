FactoryGirl.define do
  factory :skill do
    sequence(:name) {|n| "Some Skill #{n}" }
    category "obedience"
    point_basis 1
    difficulty 1
  end
end

FactoryGirl.define do
  factory :condition do
    sequence(:name) {|n| "Some Condition #{n}" }
    category "control"
    point_basis 1
    difficulty 1
  end
end

FactoryGirl.define do
  factory :user do
    email "test@test.com"
    password "testing123"
    password_confirmation "testing123"
  end
end

FactoryGirl.define do
  factory :session do
    user
    skills "1.1" # 1st skill, 1st condition
    
    before(:create) do |session, evaluator|
      2.times {FactoryGirl.create :skill}
      FactoryGirl.create :condition
    end
  end
end