require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

s.every '30s' do
  client = ZendeskAPI.Client.MyClient.instance
  puts client
  puts
  puts "FANTISMO!"
end
