class Api::SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :update]

  def create
    @survey = current_user.surveys.new(survey_params)
    if @survey.save
      render json: @survey, status: :created
    else
      render json: @survey.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @survey, status: :ok
  end

  def update
    if @survey.update(survey_params)
      render json: @survey
    else
      render json: @survey.errors, status: :unprocessable_entity
    end
  end

  private

  def set_survey
    @survey = current_user.surveys.find(params[:id])
  end

  def survey_params
    params.require(:survey).permit(:name, :description, components: [:id, :type, :content, :x_coordinate, :y_coordinate])
  end
end
