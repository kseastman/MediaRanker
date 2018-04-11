class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def login
    user = User.find_by(name: params[:user][:name])

    if user
      session[:user_id] = user.id
      flash[:success] = " #Successfully logged in as existing user #{user.name}"
    else
      # use strong params instead on refactor
      user = User.new(name: params[:user][:name])

      if user.save
        session[:user_id] = user.id
        flash[:success] = "Successfully created new user #{user.name} with ID #{user.id}"
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = "Could not log in"
        flash.now[:messages] = user.errors.messages
        render "login_form", status: :bad_request
        return
      end

    end
    redirect_to root_path
  end

  def logout
    session[:user_id] = nil
    # session.delete([:user_id])
    flash[:success] = "Successfully logged out"
    redirect_to root_path
  end

end
