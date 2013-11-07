require "spec_helper"

describe "Create and edit sessions" do
  it "Create a session" do
    create(:skill)
    3.times { create(:condition) }
    
    visit root_path
    
    click_on "New Session"
    expect(page).to have_content "Select a Skill"
    click_on "Some Skill 1"
    click_on "Some Condition 2"
    find(".menu .sessions").click
      
    within "#sessions" do
      expect(page).to have_content "Some Skill 1"
    end
    
  end
end
