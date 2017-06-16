require 'rails_helper'

RSpec.describe Vote, type: :model do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:vote) { create(:vote, user: other_user, votable_id: question.id,
                       votable_type: question.class.name) }
  it {should belong_to(:user)}
  it {should belong_to(:votable)}

  it {should validate_presence_of :votable}
  it {should validate_uniqueness_of(:user_id).scoped_to(:votable_id,
                                                            :votable_type)}

  describe 'update_votable_rating' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: other_user) }
    let!(:vote) { create(:vote, user: user, votable_type: "Question",
                         votable: question, elect: false) }
    it 'Changes votable rating' do
      question.reload
      expect(question.rating).to eq -1
    end
  end
end
