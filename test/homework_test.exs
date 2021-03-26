defmodule HomeworkTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  # Start hound session and destroy when tests are run
  hound_session()

  test "checks form authentication" do
    IO.puts ("Form authentication - correct credentials")
    navigate_to "https://the-internet.herokuapp.com/"

    # username and password
    username = "tomsmith"
    password = "SuperSecretPassword!"

    # click form authentication hyperlink
    form_authentication_hyperlink_xpath = "//*[@id=\"content\"]/ul/li[21]/a"
    form_authentication_hyperlink = find_element(:xpath, form_authentication_hyperlink_xpath)
    click(form_authentication_hyperlink)

    # username input field
    username_element = find_element(:id, "username")
    input_into_field(username_element, username)

    # password input field
    password_element = find_element(:id, "password")
    input_into_field(password_element, password)

    # login button
    login_button_xpath = "//*[@id=\"login\"]/button"
    login_button = find_element(:xpath, login_button_xpath)
    submit_element(login_button)

    # flash message placeholder
    flash_message_element = find_element(:id, "flash")
    actual_message = visible_text(flash_message_element)

    #IO.puts (actual_message)

    # login - success and error message
    login_success_message = "You logged into a secure area!"
    login_error_message = "Your username is invalid!"

    # verify correct login message is displayed
    if actual_message =~ login_success_message do
      IO.puts ("Successful login")
      IO.puts ("Test case passed")
    end

    if actual_message =~ login_error_message do
      IO.puts ("Unsuccessful login")
      IO.puts ("Test case failed")
      take_screenshot()
    end

  end


  test "Takes screenshot on error - form authentication" do
    IO.puts ("Test case: screenshot on failure - incorrect credentials during form authentication ")
    navigate_to "https://the-internet.herokuapp.com/"

    # wrong username
    username = "TestUser1"
    password = "SuperSecretPassword!"

    # click form authentication hyperlink
    form_authentication_hyperlink_xpath = "//*[@id=\"content\"]/ul/li[21]/a"
    form_authentication_hyperlink = find_element(:xpath, form_authentication_hyperlink_xpath)
    click(form_authentication_hyperlink)

    # username input field
    username_element = find_element(:id, "username")
    input_into_field(username_element, username)

    # password input field
    password_element = find_element(:id, "password")
    input_into_field(password_element, password)

    # login button
    login_button_xpath = "//*[@id=\"login\"]/button"
    login_button = find_element(:xpath, login_button_xpath)
    submit_element(login_button)

    # flash message placeholder
    flash_message_element = find_element(:id, "flash")
    actual_message = visible_text(flash_message_element)

    #IO.puts (actual_message)
    
    # login - success and error message
    login_success_message = "You logged into a secure area!"
    login_error_message = "Your username is invalid!"

    # verify correct login message is displayed
    if actual_message =~ login_success_message do
      IO.puts ("Successful login")
      IO.puts ("Test case failed")
    end

    if actual_message =~ login_error_message do
      IO.puts ("Unsuccessful login")
      IO.puts ("Test case passed")
      take_screenshot("Screenshot_LoginError.png")
    end

  end
 

  test "selects and deselects checkbox" do
    IO.puts("test case: select - deselect checkbox")
    navigate_to "https://the-internet.herokuapp.com/"

    # click hyperlink
    checkbox_hyperlink_xpath = "//*[@id=\"content\"]/ul/li[6]/a"
    checkbox_element = find_element(:xpath, checkbox_hyperlink_xpath)
    click(checkbox_element)
    
    # checkbox 1 field
    checkbox1_input_xpath = "//*[@id=\"checkboxes\"]/input[1]"
    checkbox1_input_element = find_element(:xpath, checkbox1_input_xpath)

    # checkbox 2 field
    checkbox2_input_xpath = "//*[@id=\"checkboxes\"]/input[2]"
    checkbox2_input_element = find_element(:xpath, checkbox2_input_xpath)

    # select checkbox 1
    click(checkbox1_input_element) 
    
    # deselect chechbox 2
    click(checkbox2_input_element)
    
  end
  

  test "dropdown" do
    IO.puts("test case: for dropdown")
    navigate_to "https://the-internet.herokuapp.com/"
    
    # click hyperlink 
    dropdown_hyperlink_xpath = "//*[@id=\"content\"]/ul/li[11]/a"
    dropdown_hyperlink = find_element(:xpath, dropdown_hyperlink_xpath)
    click(dropdown_hyperlink)

    #dropdown_element = find_element(:id, "dropdown")
    
    #click(find_element(:css, "##{dropdown_id} option[value='#{option}']"))
    #click(find_element(:css, "#dropdown option[value='1']")) # To select Option 1
    #click(find_element(:css, "#dropdown option[value='2']")) # To select Option 2
    
    # select option 2
    dropdown_option = find_element(:css, "#dropdown option[value='2']")
    click(dropdown_option)
    
    # prints dropdown selection info
    IO.puts "Dropdrop selection is: " <> visible_text(find_element(:css, "#dropdown option[selected='selected']"))
    
  end

  
  test "key presses" do
    IO.puts("test case: key presses")
    navigate_to "https://the-internet.herokuapp.com/"

    # click hyperlink
    key_presses_hyperlink_xpath = "//*[@id=\"content\"]/ul/li[31]/a"
    key_presses_hyperlink = find_element(:xpath, key_presses_hyperlink_xpath)
    click(key_presses_hyperlink)

    # input text field 
    input_field = find_element(:id, "target")
    click(input_field)
    
    # to enter "K" in input field
    input_into_field(input_field, "K")
    IO.puts visible_text(input_field)

    result_field = find_element(:id, "result")

    # verify input and displayed keys are same
    if visible_text(result_field) =~ "K" do
      IO.puts ("test case passed")
    end
    
  end


  test "api tests - GET: List users" do
    IO.puts("test case: api tests for GET request (list users)")
    
    # get request
    response = HTTPoison.get!("https://reqres.in/api/users?page=2")
    
    # status code - OK status
    assert response.status_code == 200

    #IO.puts response.body
    response_jason = Jason.decode!(response.body)

    #IO.inspect response_jason
    jason_data = response_jason["total"]

    # verify value of "total" in response 
    assert jason_data == 12

  end


  test "api tests - GET: single user not found" do
    IO.puts("test case: api tests for GET request (single user not found)")

    # get request
    response = HTTPoison.get!("https://reqres.in/api/users/23")

    #IO.puts response.status_code
    assert response.status_code == 404
    
    # verify empty results in response
    assert response.body == "{}"
  end
  
end