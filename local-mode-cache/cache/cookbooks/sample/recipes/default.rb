package "apache2" do
	action :install
end

service "apache2" do
	action :start
end

packages = ['mysql-server','mysql-client','php','libapache2-mod-php','php-mcrypt','php-mysql'] 
packages.each do |package|
	apt_package package do
		action :install
	end
end

execute "reset mysqladmin root password" do
	command 'mysqladmin -u root password rootpassword'
end

cookbook_file '/tmp/mysqlcommands' do
	source 'mysqlcommands'
end

execute "creating database" do
	command 'mysql -uroot -prootpassword < /tmp/mysqlcommands && touch /tmp/databasecreated'
        not_if {File.exists?("/tmp/databasecreated")} 
end

cookbook_file '/tmp/latest.zip' do
	source 'latest.zip'
end

package "Installing unzip" do
	package_name 'unzip'
	action :install
end

execute "Unzipping latest to html folder" do
	command 'sudo unzip /tmp/latest.zip -d /var/www/html'
	not_if {File.exists?("/var/www/html/wordpress/index.php")}	
end

cookbook_file '/tmp/wp-config-sample.php' do
	source 'wp-config-sample.php'
end


execute "Copying wp-config-sample.php" do
	command 'cp /tmp/wp-config-sample.php /var/www/html/wordpress/wp-config.php'
end

execute "Setting permission on wordpress folder" do
	command 'sudo chmod -R 775 /var/www/html/wordpress'
end

execute 'Changing ownership of wordpress folder' do
	command 'sudo chown -R www-data:www-data /var/www/html/wordpress'
end

execute "Restarting apache service" do
	command 'sudo service apache2 restart'
end
