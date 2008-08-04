require 'net/ssh'
class Admin::SessionsController < SessionsController
  
  def login
     respond_to do |format|
       @user = User.find_by_login(params[:user][:login])
       if authenticate?(params[:user][:login],params[:user][:passwd]) and !@user.nil? and @user.is_admin
         session[:user_id] = @user.id
         flash[:notice] = "Bienvenido(a), ha iniciado una sesión en el SIESTA!"
         format.html { redirect_to(admin_user_requests_url) }
       else
         flash[:notice] = "El login o el password es incorrecto!"
         format.html { render :action => "index" }
       end
     end
  end
  
  private
  
  def authenticate?(user,passwd)
    begin
      return true if Net::SSH.start("fenix.fisica.unam.mx", user, :password => passwd) 
    rescue StandardError => bang
      return false
    end
  end
end
