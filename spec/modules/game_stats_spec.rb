require "spec_helper"

class DummyClass; include GameStats; end
describe GameStats do
  subject { DummyClass.new() }
  
  describe "#point_tally" do
    before(:each) do
      stub_const "DummyClass::LIST_STORAGE", 3
    end
    let(:user) { build(:user) }
    let(:skill) { create(:skill, {id: 100}) }
    let(:list_key) { "user:#{user.id}:points:#{skill.id}" } 
    let(:point_tally) { Proc.new {REDIS.hget "user:#{user.id}:tallies", "points"} }
    
    it "increments point tally" do
      subject.point_tally user, skill, 20
      expect(point_tally.call).to eq "20"
      
      subject.point_tally user, skill, 22
      expect(point_tally.call).to eq "42"
    end
    
    it "pushes skill point rating" do
      subject.point_tally user, skill, 11
      subject.point_tally user, skill, 15
      expect(REDIS.lrange(list_key, 0, 10)).to eq ["15","11"]
    end
    
    it "limits list size" do
      4.times do |i|
        REDIS.lpush list_key, i+1
      end
      
      expect(REDIS.lindex(list_key, 3)).to eq "1"
      expect(REDIS.llen(list_key)).to eq 4
      
      subject.point_tally user, skill, 6
      expect(REDIS.lindex(list_key, 0)).to eq "6"
    end
    
    context "reversal" do
      it "pops an item from the points list" do
        subject.point_tally user, skill, 11
        subject.point_tally user, skill, 12
        subject.point_tally user, skill, 0, reverse:true
        expect(REDIS.lrange(list_key, 0, 10)).to eq ["11"]
      end
      it "decrements total points tally" do
        subject.point_tally user, skill, 42
        expect(point_tally.call).to eq "42"
      
        subject.point_tally user, skill, 42, reverse: true
        expect(point_tally.call).to eq "0"
      end
    end
  end
  
  describe "#skill_tallies" do
    let(:user) { build(:user) }
    let(:skill) { create(:skill, {id: 100}) }
    let(:skill_tally) { Proc.new {REDIS.hget "user:#{user.id}:tallies", "skill:#{skill.id}"} } 
    let(:category_tally) { Proc.new {REDIS.hget "user:#{user.id}:tallies", "category:#{skill.category}"} }
    
    it "increments skill tally" do
      subject.skill_tally user, skill
      expect(skill_tally.call).to eq "1"
      
      subject.skill_tally user, skill
      expect(skill_tally.call).to eq "2"
    end
    it "increments skill category tally" do
      subject.skill_tally user, skill
      expect(category_tally.call).to eq "1"
      
      subject.skill_tally user, skill
      expect(category_tally.call).to eq "2"
    end
    
    context "reversal" do
      it "decrements skill tally" do
        subject.skill_tally user, skill
        expect(skill_tally.call).to eq "1"
      
        subject.skill_tally user, skill, reverse: true
        expect(skill_tally.call).to eq "0"
      end
    end
  end
  
  describe "#condition_tallies" do
    let(:user) { build(:user) }
    let(:skill) { create(:skill, {id: 100}) }
    let(:condition) { create(:condition, {id: 200}) }
    let(:skill_tally) { Proc.new {REDIS.hget "user:#{user.id}:tallies", "skill:#{skill.id}:condition:#{condition.id}"} } 
    let(:general_tally) { Proc.new {REDIS.hget "user:#{user.id}:tallies", "condition:#{condition.id}"} }
    
    it "increments skill tally" do
      subject.condition_tally user, skill, condition
      expect(skill_tally.call).to eq "1"
      
      subject.condition_tally user, skill, condition
      expect(skill_tally.call).to eq "2"
    end
    it "increments condition tally" do
      subject.condition_tally user, skill, condition
      expect(general_tally.call).to eq "1"
      
      subject.condition_tally user, skill, condition
      expect(general_tally.call).to eq "2"
    end
    
    context "reversal" do
      it "decrements condition tally" do
        subject.condition_tally user, skill, condition
        expect(skill_tally.call).to eq "1"
      
        subject.condition_tally user, skill, condition, reverse: true
        expect(skill_tally.call).to eq "0"
      end
    end
  end
  
  describe "#skill_performance" do
    before(:each) do
      stub_const "DummyClass::LIST_STORAGE", 1
    end
    let(:user) { build(:user) }
    let(:skill) { create(:skill, {id: 100}) }
    let(:list_key) { "user:#{user.id}:performance:#{skill.id}" } 
    
    it "pushes performance rating" do
      subject.skill_performance user, skill, 123  
      subject.skill_performance user, skill, 456  
      expect(REDIS.lrange(list_key, 0, 10)).to eq ["456","123"]
    end
    
    it "limits list size" do
      11.times do |i|
        REDIS.lpush list_key, i+1
      end
      
      expect(REDIS.lindex(list_key, 10)).to eq "1"
      expect(REDIS.llen(list_key)).to eq 11
      
      subject.skill_performance user, skill, 20
      expect(REDIS.lindex(list_key, 0)).to eq "20"
    end
    
    context "reversal" do
      it "pops an item from the performance list" do
        subject.skill_performance user, skill, 5
        subject.skill_performance user, skill, 6
        subject.skill_performance user, skill, 0, reverse:true
        expect(REDIS.lrange(list_key, 0, 10)).to eq ["5"]
      end
    end
  end
  
  describe "#difficulty_performance" do
    before(:each) do
      stub_const "DummyClass::LIST_STORAGE", 3
    end
    let(:user) { build(:user) }
    let(:skill) { create(:skill, {id: 100}) }
    let(:list_key) { "user:#{user.id}:difficulty:#{skill.id}" } 
    
    it "pushes performance rating" do
      subject.difficulty_performance user, skill, 3
      subject.difficulty_performance user, skill, 5
      expect(REDIS.lrange(list_key, 0, 10)).to eq ["5","3"]
    end
    
    it "limits list size" do
      4.times do |i|
        REDIS.lpush list_key, i+1
      end
      
      expect(REDIS.lindex(list_key, 3)).to eq "1"
      expect(REDIS.llen(list_key)).to eq 4
      
      subject.difficulty_performance user, skill, 6
      expect(REDIS.lindex(list_key, 0)).to eq "6"
    end
    
    context "reversal" do
      it "pops an item from the difficulty list" do
        subject.difficulty_performance user, skill, 3
        subject.difficulty_performance user, skill, 4
        subject.difficulty_performance user, skill, 0, reverse:true
        expect(REDIS.lrange(list_key, 0, 10)).to eq ["3"]
      end
    end
  end
  
  
end