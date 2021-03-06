# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Managing system messages that are displayed on the login page", type: :feature do
  it "listing system message via the menu" do
    message = create(
      :system_message,
      title: "Test title",
      body: "Test body",
      display_from: Time.zone.now - 1.day,
      display_until: Time.zone.now + 1.day
    )
    login_as_super_admin

    visit root_path
    within "nav.top-bar" do
      click_on "Super Admin"
      click_on "System Messages"
    end

    within ".system-messages" do
      expect(page).to have_content(message.title)
      expect(page).to have_content(message.body)
      expect(page).to have_content(I18n.l(message.display_from))
      expect(page).to have_content(I18n.l(message.display_until))
      expect(page).to have_content("Yes") # active?
    end
  end

  it "creating a new message", js: true do
    login_as_super_admin
    visit system_messages_path

    within ".page-actions" do
      click_on "Add"
    end

    fill_in "Title", with: "Test title"
    fill_trix_editor with: "Test body"
    fill_in "Display from", with: "2018-01-01 01:01:01"
    fill_in "Display until", with: "2018-02-02 02:02:02"
    select "Warning", from: "Severity"
    click_on "Save"

    expect(page).to have_current_path(system_messages_path)

    within ".system-messages" do
      expect(page).to have_content("Test title")
      expect(page).to have_content("Test body")
      expect(page).to have_content("Edit")
      expect(page).to have_content("Delete")
      expect(page).to have_content("Warning")
    end
  end

  it "editing an existing message", js: true do
    create(:system_message)
    login_as_super_admin
    visit system_messages_path

    within ".system-messages" do
      click_on "Edit"
    end

    fill_in "Title", with: "Edited title"
    fill_trix_editor with: "Edited body"

    click_on "Save"

    expect(page).to have_current_path(system_messages_path)

    within ".system-messages" do
      expect(page).to have_content("Edited title")
      expect(page).to have_content("Edited body")
    end
  end

  it "deleting a message" do
    create(:system_message, title: "Test title")
    login_as_super_admin
    visit system_messages_path

    within ".system-messages" do
      expect(page).to have_content("Test title")
      click_on "Delete"
    end

    within ".system-messages" do
      expect(page).not_to have_content("Test title")
    end
  end

  it "displays an active message on the login screen" do
    message = create(
      :system_message,
      title: "Test title",
      body: "Test body",
      display_from: Time.zone.now - 1.day,
      display_until: Time.zone.now + 1.day
    )

    visit new_user_session_path

    expect(page).to have_content(message.title)
    expect(page).to have_content(message.body)
  end
end
