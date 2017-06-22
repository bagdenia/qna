class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  after_action :publish_question, only: :create

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    @questions = Question.all
    if current_user.id == @question.user_id
      @question = Question.find(params[:id])
      @question.update(question_params)
    end
  end

  def destroy
    if current_user.id == @question.user_id
      @question.destroy
      redirect_to questions_path, notice: 'Question successfully deleted'
    else
      redirect_to questions_path, notice: 'You cant delete this question'
    end
  end


  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast 'questions',
      ApplicationController.render(
        partial: 'questions/question_ac',
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
