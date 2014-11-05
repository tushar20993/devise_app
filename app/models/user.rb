class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise  :omniauthable, :omniauth_providers => [:facebook, :twitter, :instagram, :linkedin, :google_oauth2]
         
  
  attr_accessible :avatar, :name, :email, :password, :password_confirmation, :provider
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  
  def feed
    Micropost.from_users_followed_by(self)
  end
 
 def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    self.relationships.create!(followed_id: other_user.id)
  end
  
  def unfollow!(other_user)
    self.relationships.find_by(followed_id: other_user.id).destroy
  end
  ######################################################################
  
  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
  	  user = User.where(:provider => auth.provider, :uid => auth.uid).first
  	  if user
  	  	  return user
  	  else
  	  	  registered_user = User.where(:email => auth.uid + "@twitter.com").first
  	  	  if registered_user
  	  	  	  return registered_user
  	  	  else
  	  	  	  
  	  	  	  user = User.create(name:auth.extra.raw_info.name,
  	  	  	  	  provider:auth.provider,
  	  	  	  	  uid:auth.uid,
  	  	  	  	  email:auth.uid+"@twitter.com",
  	  	  	  	  password:Devise.friendly_token[0,20],
  	  	  	  	  )
  	    	  end
  	   	  
  	    end
    end
    
    
    ###########################################################
    
    def self.connect_to_linkedin(auth, signed_in_resource=nil)
    	    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    	    if user
    	    	    return user
    	    else
    	    	    registered_user = User.where(:email => auth.info.email).first
    	    	    if registered_user
    	    	    	    return registered_user
    	    	    else
    	    	    	    	
    	    	    	    user = User.create(name:auth.info.first_name,
    	    	    	    	    provider:auth.provider,
    	    	    	    	    uid:auth.uid,
    	    	    	    	    email:auth.info.email,
    	    	    	    	    password:Devise.friendly_token[0,20],
    	    	    	    	    )
    	             end
    	   	    	    
    	  end
   end
   
   ###########################################################
   
   
   
   def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
   	   user = User.where(:provider => auth.provider, :uid => auth.uid).first
   	   if user
   	   	   return user
   	   else
   	   	   registered_user = User.where(:email => auth.info.email).first
   	   	   if registered_user
   	   	   	   return registered_user
   	   	   else
   	   	   	   user = User.create(name:auth.extra.raw_info.name,
   	   	   	   	   provider:auth.provider,
   	   	   	   	   uid:auth.uid,
   	   	   	   	   email:auth.info.email,
   	   	   	   	   password:Devise.friendly_token[0,20],
   	   	   	   	   )
   	   	    end 
   	    end
    end
   
   ###################################################################
   
   
   def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
   	   data = access_token.info
   	   user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
   	   if user
   	   	   return user
   	   else
   	   	   registered_user = User.where(:email => access_token.info.email).first
   	   	   if registered_user
   	   	   	   return registered_user
   	   	   else
   	   	   	   user = User.create(name: data["name"],
   	   	   	   	   provider:access_token.provider,
   	   	   	   	   email: data["email"],
   	   	   	   	   uid: access_token.uid ,
   	   	   	   	   password: Devise.friendly_token[0,20],
   	   	   	   	   )
   	   	    end
   	    end
	end
#####################################################################   
   
  
end
