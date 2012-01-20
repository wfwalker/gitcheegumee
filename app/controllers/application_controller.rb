# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
	helper :all # include all helpers, all the time

	protect_from_forgery # See ActionController::RequestForgeryProtection for details
	layout "standard"

	def index
	end

	def inactivity_timeout
		if (ENV['inactivity_timeout'] != nil)
		  ENV['inactivity_timeout'].to_i
		else
		  1200
		end
	end         
  
	def has_valid_credentials
		if session[:player_id] == nil
			return false
		else
			sessionPlayer = Player.find_by_id(session[:player_id])
			return ((session[:email] == sessionPlayer.email) and (params[:id].to_s == session[:player_id].to_s))
		end
	end

	def has_valid_admin_credentials
		if session[:player_id] == nil
			return false
		else
			sessionPlayer = Player.find_by_id(session[:player_id])
			return (session[:email] == sessionPlayer.email and sessionPlayer.admin)
		end
	end

	def verify_and_update_activity_timer
		if (has_valid_credentials) then
		  # username is valid, login_time is valid, do the real checking
		  inactivity = Time.now.to_i - session[:login_time]
		  logger.error("VC: Checking timeout " + inactivity.to_s + " versus " + inactivity_timeout.to_s)

		  if (inactivity > inactivity_timeout) then
		    # timeout! clobber the session
		    flash[:error] = 'Editing session timed out; please login again to continue editing'
		    clear_session()
 		    redirect_to :controller => 'application', :action => 'index'
		  else
		    # active session, update the timer
		    logger.error("VC: Actively logged in, setting activity timer")
		    session[:login_time] = Time.now.to_i
			sessionPlayer = Player.find_by_id(session[:player_id])
			sessionPlayer.touch
		  end
		else
		  logger.error("VC: Not logged in, no timeout check")
		end
	end
	
	def verify_credentials
		if (has_valid_credentials) then
		  logger.error("VC: Logged in")
		else
		  # username is nil, just clobber login_time
		  logger.error("VC: Not logged in, redirecting to login")
		  clear_session()
		  redirect_to :controller => 'application', :action => 'index'
		end
	end

	def verify_admin_credentials
		if (has_valid_admin_credentials) then
		  logger.error("VC: Logged in or not administrator")
		else
		  # username is nil, just clobber login_time
		  logger.error("VC: Not logged in or not administrator, redirecting to login")
		  clear_session()
		  redirect_to :controller => 'application', :action => 'index'
		end
	end

	def clear_session
		session[:email] = nil    
		session[:player_id] = nil
		session[:admin] = nil
		session[:login_time] = nil 
	end

	def populate_session(aPlayer)
		session[:email] = @player.email
		session[:player_id] = @player.id 
		session[:admin] = @player.admin
		session[:login_time] = Time.now.to_i     
	end

	def logout
		logger.error("VC: logging out")
		flash[:error] = 'logging out'
		clear_session()
		redirect_to :controller => 'application', :action => 'index'
	end

	def verify_browserid
		if (session[:email] != nil)
			logger.error("ALREADY LOGGED IN")
			flash[:error] = 'already logged in'
			redirect_to :controller => 'application', :action => 'index'
		elsif (params[:assertion])                     
		  # now post to https://browserid.org/verify with two POST args, assertion and audience
		  
		  url = URI.parse('https://browserid.org/verify')                       
		  http = Net::HTTP.new(url.host, url.port)

		  http.use_ssl = true
		  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		        
		  req = Net::HTTP::Post.new(url.path)

		  if request.port != 80
		  	audience = "%s:%d" % [request.host, request.port]
		  else
		  	audience = request.host
		  end
		  logger.error("\n\naudience " + audience + "\n\n")
		  req.set_form_data({'assertion' => params[:assertion], 'audience' => audience})

		  res = http.start {|http| http.request(req) } 
		                                                            
		  # results should be JSON like result {"status":"okay","email":"walker@shout.net","audience":"localhost","valid-until":1313649622973,"issuer":"browserid.org:443"}
		  
		  parsedResults = ActiveSupport::JSON.decode(res.body())  

		  logger.error("results from verifier:\n" + parsedResults.to_s)
		  
		  if parsedResults["status"] == "okay"
		  	# we got a valid assertion; either we have an account for this guy or we send him to create a new one
		  	if (@player = Player.find_by_email(parsedResults["email"]))
			    logger.error("VC: Logging in as " + @player.email)
			    flash[:notice] = 'Welcome back, ' + @player.email
			    populate_session(@player)
			    redirect_to url_for(:controller => 'players', :action => 'play', :id => @player) 
			else
				flash[:error] = 'Welcome, please register'
				@player = Player.new(:location_id => 1)
				@player.email = parsedResults["email"]
			    populate_session(@player)
			    redirect_to url_for(:controller => 'players', :action => 'register', :email => parsedResults["email"], :location_id => 1)
			end
		  else
		    logger.error("VC: invalid assertion")
		    flash[:error] = 'Invalid assertion'
			clear_session()
			redirect_to :controller => 'application', :action => 'index'
		  end
		else
			logger.error("VC: Missing assertion")
			flash[:error] = 'Missing assertion; please try again'
			clear_session()
			redirect_to :controller => 'application', :action => 'index'
		end
	end
end
