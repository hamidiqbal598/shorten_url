

if User.count == 0
  admin_user = User.new(email:'admin@admin.com',password:'12345678', role: 'admin')
  admin_user.save(:validate=>false)
end
users = User.create([
                      { email: 'hamidiqbal598@gmail.com' , password:'12345678', role: 'user'},
                      { email: 'shoaibkhosa488@gmail.com' , password:'56123456', role: 'user' },
                      { email: 'kh.hamidkhan@gmail.com' , password:'123456', role: 'user' }
                    ])
user = User.first()
urls = Url.create([
                      { original_url: 'https://www.youtube.com/' , last_access_at: DateTime.now()},
                      { original_url: 'https://stackoverflow.com/' , last_access_at: DateTime.now()},
                      { original_url: 'https://imagecolorpicker.com/en' , last_access_at: DateTime.now()},
                      { original_url: 'https://api.rubyonrails.org/' , last_access_at: DateTime.now()},
                      { original_url: 'https://www.tutorialspoint.com/swift/' , last_access_at: DateTime.now()},
                      { original_url: 'http://facebook.com', last_access_at: DateTime.now()},
                      { original_url: 'https://www.google.com.pk/', last_access_at: DateTime.now()},
                      { original_url: 'https://www.starbucks.com/' , last_access_at: DateTime.now(), user_id: user.id, is_public: false},
                      { original_url: 'https://www.starbucks.com/' , last_access_at: DateTime.now(), user_id: user.id, is_public: false},
                      { original_url: 'https://github.com/' , last_access_at: DateTime.now(), user_id: User.last.id, is_public: false},
                      { original_url: 'https://www.radio-uk.co.uk/bbc-world-service' , last_access_at: DateTime.now(), user_id: User.last.id, is_public: false}
                    ])