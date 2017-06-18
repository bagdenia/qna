json.extract! @votable, :id, :rating
json.class @votable.class.name.downcase
json.voted @votable.voted_by(current_user)
json.vote_up_path votes_path(vote: {votable_id: @votable.id, votable_type: @votable.class.name, elect: 1})
json.vote_down_path votes_path(vote: {votable_id: @votable.id, votable_type: @votable.class.name, elect: -1})
json.unvote_path vote_path(@vote)
