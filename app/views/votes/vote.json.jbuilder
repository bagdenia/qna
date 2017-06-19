json.extract! @votable, :id, :rating
json.class @votable.class.name.downcase
json.voted @votable.voted_by(current_user)
json.vote_up_path polymorphic_path([@votable, :votes ], vote: { elect: 1})
json.vote_down_path polymorphic_path([@votable, :votes ], vote: { elect: -1})
json.unvote_path vote_path(@vote)
