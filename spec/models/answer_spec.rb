require 'rails_helper'

RSpec.describe Answer, type: :model do
  it {should validate_presence_of :body}
  it {should validate_presence_of :question_id}
  it {should belong_to(:question)}
  it { should have_many :attachments }
  it { should have_many :votes}
  it { should accept_nested_attributes_for :attachments }
  it {should have_db_index(:question_id)}
  it {should belong_to(:user)}
  it {should have_db_index(:user_id)}

  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let!(:answers) { create_list(:answer, 3, question: question) }

  describe 'set_best' do
    it 'makes answer better'do
      answer.set_best
      expect(answer.best).to eq true
    end

    it 'makes answer first' do
      answer.set_best
      expect(Answer.first).to eq answer
    end

    it 'makes other asnwers not best' do
      answer.set_best
      Answer.where.not(id: answer).each do |answ|
        expect(answ.best).to eq false
      end
    end
  end

  describe 'inform_subscribers' do
    it 'called on answer create' do
      new_answer = build(:answer)
      expect(new_answer).to receive(:inform_subscribers)
      new_answer.save
    end
    it 'call NewAnswerJob' do
      expect(NewAnswerJob).to receive(:perform_later).with(answer)
      answer.inform_subscribers
    end
  end
end
