require "spec_helper"

describe Skill do
  describe "#restrictions" do
    it "inits with a blank mask" do
      skill = create(:skill)
      expect(skill.restrictions).to eq "0"
    end
    
    context "with conditions" do
      subject { create(:skill) }
      before(:each) do
        
        # Make a "real"-ish mask, stagger ids [1,3,5] == "10101"
        5.times do
          condition = create(:condition)
          subject.restricted_conditions << condition if condition.id.odd?
        end 
      end

      it "returns a mask" do
        expect(subject.restrictions).to eq "l"
      end
      it "produces condition correct ids when reversed" do
        conditions = Bitmask.new("1.#{subject.restrictions}").conditions(subject)
        expect(conditions.ids).to eq [1,3,5]
      end
      
    end

  end
end