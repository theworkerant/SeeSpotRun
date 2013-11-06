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