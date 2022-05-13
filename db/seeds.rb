

if User.count == 0
  admin_user = User.new(email:'admin@admin.com',password:'12345678', role: 'admin')
  admin_user.save(:validate=>false)
end
