require "application_system_test_case"

class UserTaggedsTest < ApplicationSystemTestCase
  setup do
    @auth_admin_user_tagged = auth_admin_user_taggeds(:one)
  end

  test "visiting the index" do
    visit auth_admin_user_taggeds_url
    assert_selector "h1", text: "User Taggeds"
  end

  test "creating a User tagged" do
    visit auth_admin_user_taggeds_url
    click_on "New User Tagged"

    fill_in "Tagged", with: @auth_admin_user_tagged.tagged_id
    fill_in "Tagged type", with: @auth_admin_user_tagged.tagged_type
    click_on "Create User tagged"

    assert_text "User tagged was successfully created"
    click_on "Back"
  end

  test "updating a User tagged" do
    visit auth_admin_user_taggeds_url
    click_on "Edit", match: :first

    fill_in "Tagged", with: @auth_admin_user_tagged.tagged_id
    fill_in "Tagged type", with: @auth_admin_user_tagged.tagged_type
    click_on "Update User tagged"

    assert_text "User tagged was successfully updated"
    click_on "Back"
  end

  test "destroying a User tagged" do
    visit auth_admin_user_taggeds_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User tagged was successfully destroyed"
  end
end
