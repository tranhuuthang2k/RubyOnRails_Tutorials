# frozen_string_literal: true

# require "json"
# fileJson = File.read("bt_file_ student.txt")
# infoStudents = JSON.parse(fileJson)
# puts "School Name : " + infoStudents["school_center"]
# puts "Class Name : " + infoStudents["class_name"]
# puts "List Student"
# puts "Name\t\t\t" + "Age\t\t" + "Gender"
# infoStudents["students"].each do |student|
#   puts student["name"] + "\t\t" + student["age"] + "\t\t" + student["sex"]
# end
module Device
  def switch_on
    puts 'on'
  end

  def switch_off
    puts 'off'
  end
end

module Volume
  def volume_up
    puts 'in'
  end

  def volume_down
    puts 'out'
  end
end

module Pluggable
  def plug_in
    puts 'in'
  end

  def plug_out
    puts 'out'
  end
end

class CellPhone
  def ring
    puts 'ringing'
  end

  include Device
  include Volume
  include Pluggable
end

# cellphone = CellPhone.new
# puts cellphone.volume_up
# switch_on = CellPhone.new
# puts cellphone.ring

# def check_ip(ip)
#   ips = /^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}(?:\-([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]))?$/
#   if ips.match(ip)
#     puts "true"
#   else
#     puts "false"
#   end
# end

def check_ip?(str)
  !!(str =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/)
end

p check_ip?('192.168.0.1')
p check_ip?('255.255.255.255')
p check_ip?('0.0.0.0')
p check_ip?('255.255.255.zyz')
p check_ip?('2555.255.255.255')
p check_ip?('255.255.255')

def number_after_word?(str)
  !!(str =~ /(?<=\w) (\d+)/)
end

# p number_after_word?("Phuong 32")
# p number_after_word?("Phuong 0")
# p number_after_word?("Phuong 1")
# p number_after_word?("Phuong ãxx")
# p number_after_word?("Phuong ))))")

def check_valid_email?(email)
  !!email.match(/\A[\w.+-]+@\w+\.\w+\z/)
end

# p check_valid_email?("phuong@gmail.com")
# p check_valid_email?("phuong.it@gmail.com")
# p check_valid_email?("phuong.it@gmail.com.vn")
