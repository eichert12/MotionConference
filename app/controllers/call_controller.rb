class CallController < UIViewController
  def viewDidLoad
    super
    readUsers
    drawUI
    setupShowKit

    @connection_observer = App.notification_center.observe SHKConnectionStatusChangedNotification do |notification|
      connectionStateChanged(notification)
    end
  end

  def viewDidDisappear
    App.notification_center.unobserve @connection_observer
  end

  def readUsers
    path = NSBundle.mainBundle.pathForResource("users", ofType:"json")
    json = BW::JSON.parse(NSData.dataWithContentsOfFile(path))
    users = json["users"]
    @user1 = users[0]["username"]
    @user1_pw = users[0]["password"]
    @user2 = users[1]["username"]
    @user2_pw = users[1]["password"]
  end

  def drawUI
    @mainVideoUIView = UIView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    self.view.addSubview(@mainVideoUIView)

    @previewVideoUIView = UIView.alloc.initWithFrame [[self.view.frame.size.width - 90, 10], [80, 120]]
    @previewVideoUIView.layer.borderColor = UIColor.lightGrayColor
    @previewVideoUIView.layer.borderWidth = 1.0;
    @previewVideoUIView.backgroundColor = UIColor.whiteColor
    self.view.addSubview(@previewVideoUIView)   

    @toggleUserButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @toggleUserButton.frame = [[10,self.view.frame.size.height - 60], [50, 50]]
    @toggleUserButton.setTitle("User 1", forState:UIControlStateNormal)
    @toggleUserButton.sizeToFit
    @toggleUserButton.addTarget(self, action: :toggleUser, forControlEvents: UIControlEventTouchUpInside)
    self.view.addSubview(@toggleUserButton)  

    @loginButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @loginButton.frame = [[@toggleUserButton.frame.size.width + 20, self.view.frame.size.height - 60], [50, 50]]
    @loginButton.setTitle("Login", forState:UIControlStateNormal)
    @loginButton.sizeToFit
    @loginButton.addTarget(self, action: :login, forControlEvents: UIControlEventTouchUpInside)
    self.view.addSubview(@loginButton)

    @makeCallButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @makeCallButton.frame = [[self.view.frame.size.width - 100, self.view.frame.size.height - 60], [50, 50]]
    @makeCallButton.setTitle("Make Call", forState:UIControlStateNormal)
    @makeCallButton.setTitle("Calling", forState:UIControlStateDisabled)
    @makeCallButton.sizeToFit
    @makeCallButton.addTarget(self, action: :makeCall, forControlEvents: UIControlEventTouchUpInside)
    
    self.view.addSubview(@makeCallButton)
  end

  def setupShowKit
    ShowKit.setState @mainVideoUIView, forKey:SHKMainDisplayViewKey
    ShowKit.setState @previewVideoUIView, forKey:SHKPreviewDisplayViewKey
    ShowKit.setState SHKVideoLocalPreviewEnabled, forKey:SHKVideoLocalPreviewModeKey
  end

  def connectionStateChanged(notification)
    case notification.object.Value
    when SHKConnectionStatusCallTerminated
      @makeCallButton.setTitle("Make Call", forState: UIControlStateNormal)
    when SHKConnectionStatusLoggedIn
      @loginButton.setTitle("Logout", forState: UIControlStateNormal)
    when SHKConnectionStatusLoginFailed
      App.alert("Login Failed")
      ShowKit.hangupCall
    when SHKConnectionStatusCallIncoming
      alert = BW::UIAlertView.default(title: "Call Incoming", message:"Would you like to accept the call?", buttons: ["Accept", "Reject"], cancel_button_index: 1) do |alert|
        if alert.clicked_button.cancel?
          ShowKit.rejectCall
        else 
          ShowKit.acceptCall
        end
      end
      alert.show
    when SHKConnectionStatusNotConnected
      @loginButton.setTitle("Login", forState: UIControlStateNormal)
    when SHKConnectionStatusInCall
      @makeCallButton.setTitle("Hang Up", forState: UIControlStateNormal)
    when SHKConnectionStatusCallFailed
      App.alert("Call Failed")
    when SHKConnectionStatusCallTerminating
    when SHKConnectionStatusCallOutgoing
      @makeCallButton.setTitle("Calling...", forState:UIControlStateNormal)
    else
      puts "UNEXPECTED STATUS: #{notification.object.Value.inspect}"
    end
  end

  def toggleUser
    newTitle = @toggleUserButton.titleLabel.text == "User 1" ? "User 2" : "User 1"
    @toggleUserButton.setTitle(newTitle, forState:UIControlStateNormal)
  end

  def login
    if @loginButton.titleLabel.text == "Login"
      if @toggleUserButton.titleLabel.text == "User 1"
        ShowKit.login @user1, password: @user1_pw
      else
        ShowKit.login @user2, password: @user2_pw
      end
    else
      ShowKit.logout
      @loginButton.setTitle("Login", forState:UIControlStateNormal)
    end
  end

  def makeCall
    if @makeCallButton.titleLabel.text == "Make Call"
      if @toggleUserButton.titleLabel.text == "User 1"
        ShowKit.initiateCallWithUser @user2
      else
        ShowKit.initiateCallWithUser @user1
      end
      @makeCallButton.setTitle("Calling...", forState: UIControlStateNormal)
    else
      ShowKit.hangupCall
      @makeCallButton.setTitle("Make Call", forState: UIControlStateNormal)
    end
  end
end