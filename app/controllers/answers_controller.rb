class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :load_question, only: [:create, :new]
  before_action :load_answer, only: [:show, :edit, :update, :destroy, :set_best]
  after_action :publish_answer, only: :create
  respond_to :js
  authorize_resource



  def update
    @answer.update(answer_params)
    respond_with @answer
  end



  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_user.id)))
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def set_best
    respond_with(@answer.set_best)
  end






  private

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast "questions/#{params[:question_id]}",
      ApplicationController.render(
        partial: 'answers/answer_channel',
        locals: {answer: @answer}
      )
  end

  def load_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

end
