require './index'
require 'sinatra/activerecord/rake'

# Documentation for sinatra/activerecord migrations at: https://github.com/bmizerany/sinatra-activerecord

desc "Seed data with a dump from the itp server"
task :seed do
  people = File.open('itpdir.csv').readlines
  people.each do |line|
    person = line.split(',')
    if ["Faculty","Student","Adjunct"].include? person[5].chomp
      @user = User.create({
        :nnumber => person[2][1..person[2].length].to_i,
        :netid => person[1].chomp,
        :first => person[3].chomp,
        :last => person[4].chomp,
        :role => person[5].chomp
      })
    end
  end
end

desc "Remove all users"
task :dump_users do
  User.all.each {|u| u.destroy}
end
