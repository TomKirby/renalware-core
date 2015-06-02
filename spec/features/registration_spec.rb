require 'rails_helper'

feature 'User registration' do
  scenario 'A user registers giving incomplete information' do
    visit new_user_registration_path

    fill_in 'First name', with: 'John'
    fill_in 'Username', with: 'SmithJ'

    click_on 'Sign up'

    expect(page).to have_css('#error_explanation', text: /Email can't be blank/)
    expect(page).to have_css('#error_explanation', text: /Password can't be blank/)
    expect(page).to have_css('#error_explanation', text: /Last name can't be blank/)
  end

  scenario 'A user registers with an existing username' do
    create(:user, username: 'bevana')

    visit new_user_registration_path

    fill_in 'First name', with: 'Aneurin'
    fill_in 'Last name', with: 'Bevan'
    fill_in 'Username', with: 'BevanA'
    fill_in 'Email', with: 'aneurin.bevan@nhs.net'
    fill_in 'Password', with: 'supersecret'
    fill_in 'Password confirmation', with: 'supersecret'

    click_on 'Sign up'

    expect(page).to have_css('#error_explanation', text: /Username has already been taken/)
  end

  scenario 'A user registers with an existing email address' do
    create(:user, email: 'aneurin.bevan@nhs.net')

    visit new_user_registration_path

    fill_in 'First name', with: 'Aneurin'
    fill_in 'Last name', with: 'Bevan'
    fill_in 'Username', with: 'BevanA'
    fill_in 'Email', with: 'aneurin.bevan@nhs.net'
    fill_in 'Password', with: 'supersecret'
    fill_in 'Password confirmation', with: 'supersecret'

    click_on 'Sign up'

    expect(page).to have_css('#error_explanation', text: /Email has already been taken/)
  end

  scenario 'A user registers giving required information' do
    visit new_user_registration_path

    fill_in 'First name', with: 'Aneurin'
    fill_in 'Last name', with: 'Bevan'
    fill_in 'Username', with: 'BevanA'
    fill_in 'Email', with: 'aneurin.bevan@nhs.net'
    fill_in 'Password', with: 'supersecret'
    fill_in 'Password confirmation', with: 'supersecret'

    click_on 'Sign up'

    expect(current_path).to eq(new_user_session_path)
    # TODO: There should be a message explaining that admin approval is required before login.
  end
end