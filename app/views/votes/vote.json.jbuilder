json.extract! @votable, :id, :rating
json.class @votable.class.name.downcase
json.voted current_user.voted_this(@votable)
json.vote_up_path votes_path(vote: {votable_id: @votable.id, votable_type: @votable.class.name, elect: true})
json.vote_down_path votes_path(vote: {votable_id: @votable.id, votable_type: @votable.class.name, elect: false})
json.unvote_path vote_path(@vote)
