if node['platform'] == 'debian' || node['platform'] == 'ubuntu'
 execute "apt-get update" do
   command "touch sample.txt"
 end
end
