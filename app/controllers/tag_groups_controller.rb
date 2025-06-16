class TagGroupsController < ApplicationController
  before_action :set_tag_group, only: %i[ show edit update destroy ]

  # GET /tag_groups
  def index
    @tag_groups = TagGroup.all
  end

  # GET /tag_groups/1
  def show
  end

  # GET /tag_groups/new
  def new
    @tag_group = TagGroup.new
  end

  # GET /tag_groups/1/edit
  def edit
  end

  # POST /tag_groups
  def create
    @tag_group = TagGroup.new(tag_group_params)

    if @tag_group.save
      redirect_to @tag_group, notice: "Tag group was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tag_groups/1
  def update
    if @tag_group.update(tag_group_params)
      redirect_to @tag_group, notice: "Tag group was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tag_groups/1
  def destroy
    @tag_group.destroy!
    redirect_to tag_groups_path, notice: "Tag group was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag_group
      @tag_group = TagGroup.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def tag_group_params
      params.expect(tag_group: [ :name ])
    end
end
