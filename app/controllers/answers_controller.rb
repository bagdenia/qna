class AnswersController < ApplicationController
  before_action do
    @question = Question.find(params[:question_id])
  end

  before_action :load_answer, only: [:show, :edit, :update, :destroy]

  def index
    @answers = Answer.all
  end

  def show
  end

  def new
    @asnwer = @question.answers.new
  end



  def create
    @answer = @question.answers.create(answer_params)
    if @answer.save
      redirect_to question_answer_path(@question,@answer)
    else
      render :new
    end
  end

  private

  def load_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
