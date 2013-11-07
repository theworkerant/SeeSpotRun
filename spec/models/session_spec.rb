require "spec_helper"

describe Session do
  let(:user) { create :user }
  let(:point_tally) { Proc.new {REDIS.hget "user:#{user.id}:tallies", "points"} }
  
  describe "#process" do
    
    subject { create :session, {user: user} }
    it "increase points tally" do
      expect(point_tally.call.to_i).to eq 0
      subject
      expect(point_tally.call.to_i).to be > 0
    end
    
    it "awards more points for 2 skills than 1, with same conditions" do
      subject
      score = point_tally.call.to_i
      create :session, {user: user, skills: "3.1.1"}
      final_score = point_tally.call.to_i
      expect(final_score-score).to be > score
    end
    
    context "reversal" do
      it "decreases point tally" do
        subject
        expect(point_tally.call.to_i).to be > 0
        subject.process(reverse:true)
        expect(point_tally.call.to_i).to eq 0
      end
    end
    
  end
  
  describe "#reprocess" do    
    subject { create :session, {user: user, skills: "1.1"} }
    
    before(:each) do
      3.times {create(:session, {user: user}) } # each creates as skill and condition as well
    end
    
    it "updates score when skills have changed" do
      score = point_tally.call.to_i
      subject.update_attribute :skills, "2.1.1"
      expect(point_tally.call.to_i).to be > score
    end
    
    context "session is past the change memory" do
      pending
    end
  end
  
end