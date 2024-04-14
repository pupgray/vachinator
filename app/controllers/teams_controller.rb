class TeamsController < ApplicationController
  before_action :set_team, only: %i[ show edit update destroy ]

  # GET /teams or /teams.json
  def index
    @teams = Current.user.teams
  end

  # GET /teams/1 or /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams or /teams.json
  def create
    @team = Team.new(team_params)

    @team.captain = Current.user

    if @team.save
      redirect_to team_url(@team), notice: "Team was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    return redirect_to team_url(@team), status: :unprocessable_entity, notice: "You are not the captain of this team." if @team.captain != Current.user

    if @team.update(team_params)
      redirect_to team_url(@team), notice: "Team was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    @team.destroy!

    redirect_to teams_url, notice: "Team was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def team_params
    params.require(:team).permit(:name)
  end
end
