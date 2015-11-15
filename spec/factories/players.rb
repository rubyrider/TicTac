FactoryGirl.define do
  factory :player do
   name 'Adam Gilchrist'
    icon 'x'
  end

  factory :opponent, class: Player do
    name 'Shane Warne'
    icon 'y'
  end
end