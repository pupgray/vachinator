class HerdsController < ApplicationController
  before_action :set_herd, only: %i[ show edit update destroy ]

  # GET /herds or /herds.json
  def index
    @herds = Current.user.herds
  end

  # GET /herds/1 or /herds/1.json
  def show
  end

  # GET /herds/new
  def new
    @herd = Herd.new
  end

  # GET /herds/1/edit
  def edit
  end

  # POST /herds or /herds.json
  def create
    @herd = Herd.new(herd_params)
    @herd.captain = Current.user

    if @herd.save
      redirect_to herd_url(@herd), notice: "Herd was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /herds/1 or /herds/1.json
  def update
    return redirect_to herd_url(@herd), status: :unprocessable_entity, notice: "You are not the captain of this herd." if @herd.captain != Current.user

    if @herd.update(herd_params)
      redirect_to herd_url(@herd), notice: "Herd was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /herds/1 or /herds/1.json
  def destroy
    @herd.destroy!

    redirect_to herds_url, notice: "Herd was successfully destroyed."
  end

  private

  def set_herd
    @herd = Herd.find(params[:id])
  end

  def herd_params
    params.require(:herd).permit(:name)
  end
end
