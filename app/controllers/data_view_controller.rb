require 'date'

class DataViewController < ApplicationController
  @@data = nil

  def viz
    @money = money
  end

  private

  def money
    data = get_data
    return data["money"]
  end

  def group_by_month
    data = get_data
    data.group_by { |e| Date.parse(e["date"].month) }
  end

 # {"id"=>202899279,
 # "user_id"=>1116765,
 # "date"=>"2014-05-19",
 # "mode"=>"payment",
 # "category_id"=>101,
 # "genre_id"=>10105,
 # "from_account_id"=>872094,
 # "to_account_id"=>0,
 # "amount"=>1080,
 # "comment"=>"",
 # "active"=>1,
 # "created"=>"2014-05-19 19:51:41",
 # "currency_code"=>"JPY",
 # "name"=>"",
 # "receipt_id"=>0,
 # "place_uid"=>"zm-b387b32e0b728831",
 # "place"=>"やよい軒"},
  def get_data
    return @@data if @@data
    zaimdata_path = "public/zaimdata/#{ZaimauthController::MONEY_DATA}"
    return nil unless File.exist?(zaimdata_path)
    contents = File.open(zaimdata_path).read
    @@data = JSON.parse(contents)
    return @@data
  end

end
