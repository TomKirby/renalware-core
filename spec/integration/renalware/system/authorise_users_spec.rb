require "rails_helper"
require "action_view/record_identifier"

module Renalware
  feature "Authorising, approving and reactivating users" do
    include ActionView::RecordIdentifier

    background do
      @clinician_role = Role.find_or_create_by(name: "clinician")

      @approved = create(:user, :approved)
      @unapproved = create(:user)
      @expired = create(:user, :approved, :expired)

      login_as_super_admin

      visit admin_users_path
    end

    scenario "An admin approves a newly registered user" do
      click_on "Unapproved"

      click_link "Edit"
      expect(current_path).to eq(edit_admin_user_path(@unapproved))

      check "Clinician"
      click_on "Approve"

      expect(current_path).to eq(admin_users_path)
      expect(page).to have_content("You have successfully updated this user.")
      expect(@unapproved.reload).to be_approved
      expect(@unapproved.roles).to match_array([@clinician_role])
    end

    scenario "An admin approves a user without assigning a role" do
      click_on "Unapproved"

      click_link "Edit"
      expect(current_path).to eq(edit_admin_user_path(@unapproved))

      click_on "Approve"

      expect(current_path).to eq(admin_user_path(@unapproved))
      expect(@unapproved.reload).not_to be_approved
      expect(page).to have_content("You have failed to update this user.")
      expect(page).to have_content(/approved users must have a role/)
    end

    scenario "An admin removes all roles from a user" do
      first("tbody tr##{dom_id(@approved)}").click_link("Edit")
      expect(current_path).to eq(edit_admin_user_path(@approved))

      uncheck "Clinician"
      click_on "Update"

      expect(current_path).to eq(admin_user_path(@approved))
      expect(page).to have_content("You have failed to update this user.")
      expect(page).to have_content(/approved users must have a role/)
    end

    scenario "An admin authorises an existing user with additional roles" do
      within("tbody") do
        find("a[href='#{edit_admin_user_path(@approved)}']").click
      end
      expect(current_path).to eq(edit_admin_user_path(@approved))

      check "Clinician"
      click_on "Update"

      expect(current_path).to eq(admin_users_path)
      expect(page).to have_content("You have successfully updated this")
      expect(@approved.reload).to be_approved
      expect(@approved.roles).to include(@clinician_role)
    end

    scenario "An admin reactivates an inactive user" do
      click_link "Inactive"

      first("tbody tr").click_link("Edit")
      expect(current_path).to eq(edit_admin_user_path(@expired))

      check "Reactivate account"
      click_on "Update"

      expect(current_path).to eq(admin_users_path)
      expect(page).to have_content("You have successfully updated this")
      expect(@expired.reload.expired_at).to be_nil

      click_link "Inactive"

      expect(page).not_to have_content(@expired.username)
    end

    scenario "An admin cannot assign super_admin role to anyone" do
      within("tbody") do
        find("a[href='#{edit_admin_user_path(@approved)}']").click
      end

      # 'Hidden' super_admin role appears as a disabled checkbox
      expect(find("input[type='checkbox'][disabled='disabled']")).not_to be_nil
    end

    scenario "An admin cannot remove the super_admin role" do
      superadmin = create(:user, :approved, :super_admin)
      visit admin_users_path
      within("tbody") do
        find("a[href='#{edit_admin_user_path(superadmin)}']").click
      end
      expect(current_path).to eq(edit_admin_user_path(superadmin))

      # may be already unchecked, but just to be sure this person has no roles
      # other than the hidden superadmin role
      uncheck "Clinician"
      click_on "Update"

      # They are as super-admin so submit should succeed and the super-admin
      # role be preserved because that can only be changed on the command line.
      expect(current_path).to eq(admin_users_path)
      superadmin.reload
      expect(superadmin.role_names).to include("super_admin")
      expect(superadmin.roles).not_to include(@clinician_role)
    end
  end
end
