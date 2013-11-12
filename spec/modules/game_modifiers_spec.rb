require "spec_helper"

class DummyClass; include Game; end
describe Game::Modifiers do
  subject { DummyClass.new() }
  
  describe "#new_skill_high_score" do
    let(:user) { build(:user) }
    let(:skill) { create(:skill, {id: 100}) }
    
    it "a new high score is given when an old score existed" do
      subject.skill_high_score user, skill, 5
      expect(subject.new_skill_high_score).to eq false
      subject.skill_high_score user, skill, 6
      expect(subject.new_skill_high_score).to eq true
    end
  end
end
