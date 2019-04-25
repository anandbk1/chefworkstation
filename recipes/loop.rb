packages = ['firefox', 'midori', 'qupzilla']

packages.each do |package|
 apt_package package do
   action :install
 end
end
