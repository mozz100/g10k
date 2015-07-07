class RunnersController < ApplicationController
  before_action :set_runner, only: [:show, :edit, :update, :destroy, :checkpoint]
  skip_before_filter :verify_authenticity_token, :only => [:start_race, :reset, :checkpoint]

  # GET /runners
  # GET /runners.json
  def index
    @runners = Runner.all.order('expected_duration DESC')
  end

  # GET /runners/1
  # GET /runners/1.json
  def show
  end

  # GET /runners/new
  def new
    @runner = Runner.new
  end

  # GET /runners/1/edit
  def edit
  end

  # POST /runners
  # POST /runners.json
  def create
    @runner = Runner.new(runner_params)
    @runner.race = Race.first

    respond_to do |format|
      if @runner.save
        format.html { redirect_to @runner, notice: 'Runner was successfully created.' }
        format.json { render :show, status: :created, location: @runner }
      else
        format.html { render :new }
        format.json { render json: @runner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /runners/1
  # PATCH/PUT /runners/1.json
  def update
    respond_to do |format|
      if @runner.update(runner_params)
        format.html { redirect_to @runner, notice: 'Runner was successfully updated.' }
        format.json { render :show, status: :ok, location: @runner }
      else
        format.html { render :edit }
        format.json { render json: @runner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /runners/1
  # DELETE /runners/1.json
  def destroy
    @runner.destroy
    respond_to do |format|
      format.html { redirect_to runners_url, notice: 'Runner was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def reset
    Race.reset
    output_race_data
  end

  def start_race
    @race = Race.first
    start_time = Time.at(params[:start_time].to_i).to_datetime
    @race.start!(actual_time: start_time)
    output_race_data
  end

  def checkpoint
    # Delete any existing checkpoint with the same parameters
    CheckPoint.where(runner_id: @runner.id, percent: params[:percent].to_f).delete_all

    check_time = Time.at(params[:check_time].to_i).to_datetime
    @checkpoint = CheckPoint.create(runner: @runner, check_time: check_time, percent: params[:percent].to_f)
    output_race_data
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_runner
      @runner = Runner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def runner_params
      params.require(:runner).permit(:name, :email, :expected_duration, :race_number, :thumbnail_url)
    end
end
