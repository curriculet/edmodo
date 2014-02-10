module EdmodoHelpers

  def set_testing_configuration
    Edmodo.reset!
    Edmodo.api_key  = edmodo_api_key
    Edmodo.endpoint = 'https://appsapi.edmodobox.com'
    Edmodo.testing  = true
  end

  def testing_launch_key
    "wxw0PE"
  end

  def testing_user_token
    'a1b9fe377'
  end

  def testing_user_token_2
    'a4cd03ede'
  end

  def testing_group_id
    '582139'
  end

  def testing_group_id_2
    '583203'
  end
end