require "spec_helper"
feature "view the homepage" do
  scenario "see it's glory" do
    visit root_path
    expect(page).to have_content "See Spot Run"
  end
end