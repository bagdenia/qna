require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:user){ create(:user) }
  let(:question){ create(:question, user: user) }
  let(:answer){ create(:answer, user: user, question: question) }
  it 'sends daily digest' do
    expect(AnswerMailer).to receive(:informer).with(answer, user).and_call_original
    NewAnswerJob.perform_now(answer)
  end
end

