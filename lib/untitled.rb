require 'rubygems'
require 'sequel'

DW = Sequel.connect('mysql://iilwy_admin:iilwy94IILWY49@10.0.0.226/iilwy_production')
DW.test_connection
DB = Sequel.connect('mysql://iilwy_admin:iilwy94IILWY49@10.0.0.228/iilwy_production')
DB.test_connection

users = DW[:facebook_users___fbu].join(:users___u,:u__id => :fbu__user_id).filter(:u__facebook_uid => nil).exclude(:fbu__facebook_id => nil).select(:user_id,:facebook_id).all

users.each do |user|
  DB[:users].filter(:id => user[:user_id], :facebook_uid => nil).update(:facebook_uid => user[:facebook_id].to_i)
end