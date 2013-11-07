require "spec_helper"

describe Bitmask do  
  before(:each) do
    3.times {|i| create(:skill, {id: i+10}) } # offset IDs for testing fun
    3.times {|i| create(:condition, {id: i+20}) } # offset IDs for testing fun
  end
  
  describe ".skills_id_map" do    
    it "creates an ID map of all skills, reversed" do
      expect(Bitmask.skills_id_map).to eq [12,11,10]
    end
  end
  describe ".empty_skills_mask" do    
    it { expect(Bitmask.blank_skills_mask).to eq "000" }
  end
  
  describe ".conditions_id_map" do    
    it "creates an ID map of all conditions, reversed" do
      expect(Bitmask.conditions_id_map).to eq [22,21,20]
    end
  end
  describe ".empty_skills_mask" do    
    it { expect(Bitmask.blank_conditions_mask).to eq "000" }
  end
  
  # Instances
  describe "#initialize" do
    it "initialize with an encoded bitmask and returns itself" do
      expect(Bitmask.new("")).to be_a(Bitmask)
    end
    it "sets a skills_mask Bitwise attribute" do
      expect(Bitmask.new("").skills_mask).to be_a Bitwise
    end
    it "sets a skill_conditions attribute" do
      skill_conditions = Bitmask.new("").skill_conditions
      expect(skill_conditions).to be_an Array
      skill_conditions.each do |skill|
        expect(skill).to be_a Bitwise
      end
    end
  end
  
  describe "#skills" do
    subject { Bitmask.new("100".to_i(2).to_s(36)) } # 3rd skill selected
    it { expect(subject.skills).to be_an ActiveRecord::Relation }
    it { expect(subject.skills.first.name).to eq "Some Skill 3" }
  end
  
  describe "#conditions for skill" do
    subject do
      masks = ["100".to_i(2).to_s(36), "001".to_i(2).to_s(36)]  # 3rd skill, 1st condition
      mask = Bitmask.new(masks.join("."))
      mask.conditions(mask.skills.first)
    end
    
    it { expect(subject).to be_an ActiveRecord::Relation }
    it { expect(subject.first.name).to eq "Some Condition 1" }
  end
  
  # private method, tested anyways
  describe "#adjust_mask" do 
    let(:compare) { b=Bitwise.new(); b.bits = "010"; b }
    
    it "extends a mask that is too short so indexes are correct" do
      # note: "2".to_i(36).to_s(2) == "10" which is too short
      expect(Bitmask.new("2").skills_mask.indexes).to eq compare.indexes
    end
    
    # it "trims a mask that is too long so indexes are correct" do
    #   too_long = Bitmask.new()
    #   too_long.skills_mask = "00010"
    #   expect(too_long.indexes).to eq compare.indexes
    # end
  end
  
end

  
