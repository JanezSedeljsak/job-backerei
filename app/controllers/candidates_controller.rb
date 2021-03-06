require "json"

class CandidatesController < ApplicationController
  before_action :set_candidate, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  # GET /candidates
  # GET /candidates.json
  def index
    @candidates = Candidate.all
  end

  # GET /candidates/1
  # GET /candidates/1.json
  def show
    @user = User.find(params[:id_u])
    @questions = Question.where(job_id: params[:id_j])
    question_ids = Question.where(job_id: params[:id_j]).select(:id).map { |n| n["id"] }
    @answers = Answer.where("user_id = ? AND question_id IN (?)", params[:id_u], question_ids)
  end

  # GET /candidates/new
  def new
    @candidate = Candidate.new
    @questions = Question.where(job_id: params[:id])
  end

  # GET /candidates/1/edit
  def edit
  end
  # POST /candidates
  # POST /candidates.json
  def create
    @candidate = Candidate.new(candidate_params)
    @candidate.user_id = current_user.id

    parsedAnswers = JSON.parse(params["candidate"]["answers"]) 

    parsedAnswers.each do |item|
        @answer = Answer.new(:question_id => item["question_id"].to_i, :body => item["body"], :user_id => current_user.id)
        puts @answer
        puts item
        @answer.save
    end

    respond_to do |format|
      if @candidate.save
        format.html { redirect_to :root, notice: 'Candidate was successfully created.' }
        format.json { render :show, status: :created, location: @candidate }
      else
        format.html { render :new }
        format.json { render json: :root, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /candidates/1
  # PATCH/PUT /candidates/1.json
  def update
    respond_to do |format|
      if @candidate.update(candidate_params)
        format.html { redirect_to @candidate, notice: 'Candidate was successfully updated.' }
        format.json { render :show, status: :ok, location: @candidate }
      else
        format.html { render :edit }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /candidates/1
  # DELETE /candidates/1.json
  def destroy
    @candidate.destroy
    respond_to do |format|
      format.html { redirect_to candidates_url, notice: 'Candidate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_candidate
        if params[:id]
            @candidate = Candidate.find(params[:id])
        end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def candidate_params
      params.require(:candidate).permit(:user_id, :job_id, :expreties)
    end
end
