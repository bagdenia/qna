class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :load_question, only: [:create, :new]
  before_action :load_answer, only: [:show, :edit, :update, :destroy, :set_best]
  after_action :publish_answer, only: :create


  def show
  end

  def edit
  end

  def new
     @answer = @question.answers.new
  end

  def update
    if current_user.id == @answer.user_id
      @answer = Answer.find(params[:id])
      @answer.update(answer_params)
    end
  end



  def create
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
  end

  def destroy
    if current_user.id == @answer.user_id
      @answer.destroy
    end
  end

  def set_best
    @question = @answer.question
    if current_user.id == @question.user_id
      @answer.set_best
    end

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
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

end
