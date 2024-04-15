class InviteLinksController < ApplicationController
  before_action :set_team, except: %i[new_join create_join]
  before_action :set_invite_link, only: %i[ show edit update destroy new_join create_join ]

  def index
    @invite_links = @team.invite_links
  end

  def show
    return redirect_to root_path, alert: "You don't have permission to do that." if @invite_link.user != Current.user

    redirect_to join_team_invite_link_path(@invite_link.code)
  end

  def new_join
    redirect_to root_path, alert: "Link was expired." if @invite_link.nil?
  end

  def create_join
    return redirect_to root_path, alert: "Link was expired." if @invite_link.nil?

    @invite_link.team.members << Current.user

    redirect_to @invite_link.team, notice: "Successfully joined #{@invite_link.team.name}."
  end

  def new
    @invite_link = InviteLink.new
  end

  def edit
  end

  def create
    @invite_link = InviteLink.new(invite_link_params)

    @invite_link.user = Current.user
    @invite_link.team = @team

    if @invite_link.save
      redirect_to team_invite_link_path(@team, @invite_link), notice: "Invite link was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @invite_link.update(invite_link_params)
      redirect_to team_path(@team), notice: "Invite link was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @invite_link.destroy!
    redirect_to team_invite_links_path(@team), notice: "Invite link was successfully destroyed.", status: :see_other
  end

  private

  def set_invite_link
    @invite_link = InviteLink.find(params[:id]) if params[:id]
    @invite_link = InviteLink.find_by_token_for(:invite_code, params[:code]) if params[:code]
  end

  def set_team
    @team = Team.find(params[:team_id])
  end

  def invite_link_params
    params.require(:invite_link).permit(:expires_at, :spaces_remaining)
  end
end
