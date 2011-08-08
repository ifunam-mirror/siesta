class Managers::StudentsController < Managers::ApplicationController
  respond_to :html, :js, :only => [:index, :show]
  respond_to :jpg, :only => [:card_front, :card_back]
  respond_to :js, :only => [:authorize]
  def index
     respond_with(@users = User.fullname_asc.paginated_search(params))
  end

  def show
    @student = StudentProfile.find(params[:id])
    @student.person.build_card_image
    respond_with(@student)
  end

  def card_front
    @card = Card.new(params[:id])
    respond_to do |format|
      format.jpg do
        send_data @card.front, :filename => "front_studentid.jpg", :type => 'image/jpeg', :disposition => 'attachment'  
      end
    end
  end

  def card_back
    @card = Card.new(params[:id])
    respond_to do |format|
      format.jpg do
        send_data @card.back, :filename => "back_studentid.jpg", :type => 'image/jpeg', :disposition => 'attachment'  
      end
    end
  end
  
  def authorize
    @user_request = UserRequest.find(params[:id])
    @user_request.update_attribute(:is_official,true)
    respond_with(@user_request)
  end
end
