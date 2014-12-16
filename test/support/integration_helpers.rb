class ActionDispatch::IntegrationTest
  protected
    def sign_in(email, password="test")
      post_via_redirect user_session_path, 'user[email]' => email, 'user[password]' => password, reset_password_token: 'reset_token'
    end
end