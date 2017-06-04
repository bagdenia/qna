class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :load_question, only: [:create, :new]
  before_action :load_answer, only: [:show, :edit, :update, :destroy, :set_best]


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
    @question = @answer.question
  end



  def create
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
  end

  def destroy
    @question = @answer.question
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

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :best)
  end

end
