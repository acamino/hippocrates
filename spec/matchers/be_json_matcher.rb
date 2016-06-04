RSpec::Matchers.define :be_json do |_|
  match do |actual|
    actual.content_type.include? 'application/json'
  end
end
