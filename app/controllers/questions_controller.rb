class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: :show
  after_action :publish_question, only: :create
  respond_to :js

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with(@question)
    gon.question_id = params[:id]
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
  end

  def update
    if current_user.id == @question.user_id
      @question.update(question_params)
      respond_with(@question)
    end
  end

  def destroy
    if current_user.id == @question.user_id
      respond_with(@question.destroy)
    end
  end


  private

  def build_answer
    @answer = @question.answers.build
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast "questions",
      ApplicationController.render(
        partial: 'questions/question_channel',
        locals: {question: @question}
      )
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
