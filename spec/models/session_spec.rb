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
    
    it "updates score when skills have changed" do
      score = point_tally.call.to_i
      subject.update_attributes skills: "2.1.1"
      expect(point_tally.call.to_i).to be > score
    end
    
    it "reprocess unchanged sessions between selected session" do      
      other_session = create(:session, {user: user})
      subject
      Timecop.travel(1.minute.from_now) { subject.update_attributes skills: "2.1.1" }
      other_session.reload
      expect(other_session.updated_at.to_i).to be > other_session.created_at.to_i
    end
    
    it "still works when there aren't any other sessions to reprocess" do
      subject
      3.times {create(:session, {user: user, created_at: 1.year.ago}) }
      subject.update_attributes skills: "2.1.1"
    end
    
    context "on destroy" do
      it "reverses scores and does not reprocess that session" do
        3.times {create(:session, {user: user}) }
        score = point_tally.call.to_i
        Session.first.destroy
        expect(point_tally.call.to_i).to be < score
        expect(point_tally.call.to_i).to be > 0
      end
    end
    
    context "session being changed is past the expiry" do
      it "adds to ActiveRecord errors" do
        Timecop.freeze(1.year.ago) do
          subject
          subject.update_attributes skills: "2.1.1"
        end
        
        expect(subject.errors[:processing_expiry]).not_to be_empty
      end
    end
    context "session being changed is past the processing max" do
      it "adds to ActiveRecord errors" do
        subject
        stub_const("Session::PROCESSING_MAX", 3)
        3.times { create :session, {user: user} }
        subject.update_attributes skills: "2.1.1"
        
        expect(subject.errors[:processing_max]).not_to be_empty
      end
    end

  end
  
end