class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question
  before_action :load_answer, only: [:show, :edit, :update, :destroy]


  def show
  end

  def new
    @answer = @question.answers.new
  end



  def create
    @answer = @question.answers.create(answer_params)
    if @answer.save
      redirect_to question_answer_path(@question,@answer), notice: 'Your answer successfully created'
    else
      render :new
    end
  end

  private

  def load_answer
    @answer = @question.answers.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
