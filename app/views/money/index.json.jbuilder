json.array!(@money) do |money|
  json.extract! money, :id
  json.url money_url(money, format: :json)
end
