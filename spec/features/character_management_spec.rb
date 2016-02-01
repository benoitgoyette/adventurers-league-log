require "rails_helper"

RSpec.feature "Characters page", :type => :feature, js: true do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_as(@user, :scope => :user)
  end

  scenario "Default to character page" do
    visit root_path
    expect(current_path).to eq(user_characters_path(@user))
  end

  scenario "Character page should have information" do
    @character       = FactoryGirl.create(:character, user: @user)
    @other_character = FactoryGirl.create(:character, user: @user)
    visit user_characters_path(@user)

    expect(page).to have_text(@character.name)
    expect(page).to have_text(@character.race)
    expect(page).to have_text(@character.class_and_levels)
    expect(page).to have_text(@character.faction.name)

    expect(page).to have_text(@other_character.name)
    expect(page).to have_text(@other_character.race)
    expect(page).to have_text(@other_character.class_and_levels)
    expect(page).to have_text(@other_character.faction.name)
  end

  scenario "Create a character" do
    @faction = FactoryGirl.create :faction
    @character_count = Character.count
    visit user_characters_path(@user)

    click_link "New Character"

    fill_in "Name *",             :with => "Rum"
    fill_in "Race",               :with => "Human (variant)"
    fill_in "Classes and Levels", :with => "Fighter 1"
    select  "Harpers",            :from => "Faction"

    click_button "Save"

    expect(Character.count).to have_text(@character_count + 1)
    expect(page).to have_text("Rum")
    expect(page).to have_text("Human (variant)")
    expect(page).to have_text("Fighter 1")
    expect(page).to have_text("Harpers")
  end

  scenario "Edit an existing character" do
    @character = FactoryGirl.create(:character, user: @user)
    @faction   = FactoryGirl.create :faction, name: 'Zhentarim'
    visit user_characters_path(@user)

    click_link "Edit"

    fill_in "Name *",             :with => "Rum"
    fill_in "Race",               :with => "Human (variant)"
    fill_in "Classes and Levels", :with => "Fighter 1"
    select  "Zhentarim",          :from => "Faction"

    click_button "Save"

    expect(page).to have_text("Rum")
    expect(page).to have_text("Human (variant)")
    expect(page).to have_text("Fighter 1")
    expect(page).to have_text("Zhentarim")
  end

  scenario "Delete an existing character" do
    @character = FactoryGirl.create(:character, user: @user)
    @character_count = Character.count
    visit user_characters_path(@user)

    click_link "Delete"

    expect(Character.count).to have_text(@character_count - 1)
  end
end