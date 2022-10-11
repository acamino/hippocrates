module ControllerHelpers
  def sign_in_user_mock(options = {})
    user = mock_model(User, **options)
    authenticate_user_mock user
  end

  def authenticate_user_mock(user)
    request.env['warden'] = double(Warden, authenticate: user, authenticate!: user)
  end
end
