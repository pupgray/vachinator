class InviteLinksController < ApplicationController
  before_action :set_herd, except: %i[new_join create_join]
  before_action :set_invite_link, only: %i[ show edit update destroy new_join create_join ]

  def index
    @invite_links = @herd.invite_links
  end

  def show
    return redirect_to root_path, alert: "You don't have permission to do that." if @invite_link.user != Current.user

    redirect_to join_herd_invite_link_path(@invite_link.code)
  end

  def new_join
    redirect_to root_path, alert: "Link was expired." if @invite_link.nil?
  end

  def create_join
    return redirect_to root_path, alert: "Link was expired." if @invite_link.nil?
    return render :new_join, status: :unprocessable_entity, alert: "You already joined this herd" if @invite_link.herd.has?(Current.user)

    @invite_link.join(Current.user)

    redirect_to @invite_link.herd, notice: "Successfully joined #{@invite_link.herd.name}."
  end

  def new
    @invite_link = InviteLink.new
  end

  def edit
  end

  def create
    @invite_link = InviteLink.new(invite_link_params)

    @invite_link.user = Current.user
    @invite_link.herd = @herd

    if @invite_link.save
      redirect_to herd_invite_link_path(@herd, @invite_link), notice: "Invite link was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @invite_link.update(invite_link_params)
      redirect_to herd_path(@herd), notice: "Invite link was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @invite_link.destroy!
    redirect_to herd_invite_links_path(@herd), notice: "Invite link was successfully destroyed.", status: :see_other
  end

  private

  def set_invite_link
    @invite_link = InviteLink.find(params[:id]) if params[:id]
    @invite_link = InviteLink.find_by_token_for(:invite_code, params[:code]) if params[:code]
  end

  def set_herd
    @herd = Herd.find(params[:herd_id])
  end

  def invite_link_params
    params.require(:invite_link).permit(:expires_at, :spaces_remaining)
  end
end
