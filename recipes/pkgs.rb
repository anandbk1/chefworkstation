pkgs = ['firefox', 'midori', 'qupzilla']

pkgs.each do |pkg|
 apt_package pkg do
   action :install
 end
end
