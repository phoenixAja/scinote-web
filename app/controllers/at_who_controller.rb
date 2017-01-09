class AtWhoController < ApplicationController
  before_action :load_vars
  before_action :check_users_permissions

  def users
    # Search users
    res = @organization
          .search_users(@query)
          .select(:id, :full_name, :email)
          .limit(Constants::ATWHO_SEARCH_LIMIT)
          .as_json

    # Add avatars, convert to JSON
    res.each do |user_obj|
      user_obj['img_url'] = avatar_path(user_obj['id'], :icon_small)
    end

    respond_to do |format|
      format.json do
        render json: {
          users: res,
          status: :ok
        }
      end
    end
  end

  def menu_items
    res = SmartAnnotation.new(current_user, @query)

    respond_to do |format|
      format.json do
        render json: {
          prj: res.projects,
          exp: res.experiments,
          tsk: res.my_modules,
          sam: res.samples,
          status: :ok
        }
      end
    end
  end

  def samples
    res = SmartAnnotation.new(current_user, @query)
    respond_to do |format|
      format.json do
        render json: {
          res: res.samples,
          status: :ok
        }
      end
    end
  end

  def projects
    res = SmartAnnotation.new(current_user, @query)
    respond_to do |format|
      format.json do
        render json: {
          res: res.projects,
          status: :ok
        }
      end
    end
  end

  def experiments
    res = SmartAnnotation.new(current_user, @query)
    respond_to do |format|
      format.json do
        render json: {
          res: res.experiments,
          status: :ok
        }
      end
    end
  end

  def my_modules
    res = SmartAnnotation.new(current_user, @query)
    respond_to do |format|
      format.json do
        render json: {
          res: res.my_modules,
          status: :ok
        }
      end
    end
  end

  private

  def load_vars
    @organization = Organization.find_by_id(params[:id])
    @query = params[:query]
    render_404 unless @organization
  end

  def check_users_permissions
    render_403 unless can_view_organization_users(@organization)
  end
end
