class UsersController < ApplicationController
   skip_before_filter :require_login, :only => [:new, :create, :show] 
   caches_action :new

   respond_to :html
  
   def new
     @user = User.new
	 respond_with(@user)
   end

   def create
	@user = User.new(params[:user])
	flash[:notice] = "User account has been created" if @user.save
	respond_with(@user) do |format|
	  format.html { render 'show' }
	end
   end
end