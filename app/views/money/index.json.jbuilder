json.array!(@money) do |money|
  json.date money.date
  json.category_name money.category_name
  json.genre_name money.genre_name
  json.place money.place
  json.comment money.comment
  json.amount money.amount
  json.from_account_name money.from_account_name
end
