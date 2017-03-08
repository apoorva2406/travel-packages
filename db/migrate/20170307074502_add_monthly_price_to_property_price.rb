class AddMonthlyPriceToPropertyPrice < ActiveRecord::Migration
  def change
    add_column :property_prices, :monthly_price, :float
    add_column :property_prices, :hourly_price, :float
    add_column :property_prices, :basic_unit, :string
  end
end
