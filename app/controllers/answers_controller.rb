class AnswersController < ApplicationController
  before_action do
    @question = Question.find(params[:question_id])
  end

  before_action :load_answer, only: [:show, :edit, :update, :destroy]

  def index
    @answers = Answer.all
  end
  private

  def load_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
