class SearchAccountsController < ApplicationController
  before_filter :restricted_area, :only=>[:pending_request,:authenticate_requests]
  before_filter :account_inactive_and_exists, :only=>[:claim,:request_sent]
  before_filter :visitor_only,:only=>[:claim,:search,:index,:request_sent]
  def claim
    @claim=Claim.new
  end

  def search
    if params[:search]!=""
      @lawyers = []
      @lawyers = User.inactive_lawyers_search(params[:search], params[:page])
      @pagination=0
    else
      @lawyers=User.inactive_lawyers(params[:page])
    end
    render :action=>"index"
  end

  def index
    @lawyers=User.inactive_lawyers(params[:page])
  end

  def request_sent
    @claim=Claim.new(params[:claim])
    @claim.user_id=@lawyer.id
    if @claim.save
      flash[:notice]="We got you request we will contact you soon."
      redirect_to search_accounts_path
    else
      render :action => "claim"
    end
  end

  def authenticate_requests
    if params[:commit]=='Approve'
      Claim.where(["id in (?)",params[:select]]).collect {
        |x|
        password=random_string
        x.user.email = x.email
        x.user.activation_code=Digest::MD5.hexdigest(Time.now.to_i.to_s)
        x.user.password=password
        x.user.password_confirmation=password
        x.user.save(false)
        x.user.send_claim_account_activation_mail(password)
        x.delete
      }
      flash[:notice]="The selected invitation(s) has been approved."
    else
      Claim.where(["id in (?)",params[:select]]).collect {|x| x.destroy}
      flash[:notice]="The selected invitation(s) has been declined."
    end
    redirect_to  pending_request_search_accounts_path
  end

  def pending_request
    @claims = Claim.paginate(:page => params[:page],:order => 'created_at DESC')
  end

  private

  def account_inactive_and_exists
    @lawyer = User.where(['id = ? and active = ? and activation_code IS NULL', params[:id], 0]).first
    unless @lawyer
      flash[:error]="You are not authorized for this action."
      redirect_to search_accounts_path
    end
  end

end

