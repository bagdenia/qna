require 'rails_helper'

RSpec.describe Vote, type: :model do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:vote) { create(:vote, votable: question,
                       votable_type: question.class) }
  it {should belong_to(:user)}
  it {should belong_to(:votable)}

  it {should validate_presence_of :votable}
  it { should validate_uniqueness_of(:user_id).scoped_to(:votable_id,
                                                           :votable_type)}
end
