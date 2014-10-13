require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :bind, '0.0.0.0'
set :database, "sqlite3:pizzashop.db"

class Product < ActiveRecord::Base
end

class Shipment < ActiveRecord::Base
  validates :scope, presence: true
  validates :name, presence: true
  validates :phone, presence: true
  validates :address, presence: true
end

get '/' do
	@products = Product.all
	erb :index
end

get '/about' do
	erb :about
end

get '/contacts' do
  erb "Under construction"
end

post '/cart' do
  @orders_input = params[:orderstring]
  @items = parse_orders_input @orders_input

  # выводим сообщение о том, что корзина пуста
  if @items.length == 0
    return erb :cart_is_empty
  end

  @items.each do |item|
    # id, cnt
    item[0] = Product.find(item[0])
  end

	erb :cart
end

get '/admin' do
   @shipms = Shipment.all
  erb :orders_list
end

post '/place_order' do
  @shipment = Shipment.new params[:order]

  if @shipment.save
    erb :order_placed
  else
    @error = @shipment.errors.full_messages.first
    erb "Error"
  end
end

def parse_orders_input orders_input
  s1 = orders_input.split(/,/)

  arr = []

  s1.each do |x|
    s2 = x.split(/\=/)

    s3 = s2[0].split(/_/)

    id = s3[1]
    cnt = s2[1]

    arr2 = [id, cnt]

    arr.push arr2
  end

  return arr
end
