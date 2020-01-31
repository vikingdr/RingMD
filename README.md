# Install Cocoapods
- sudo gem install cocoapods
- pod install
- Always open Ring.xcworkspace, not the project

# Install HockeyApp and OpenTok
- Make sure to subscribe to the OpenTok blog to be updated about new releases
- The OpenTok currently makes building a PITA because it doesn't support 64 bit systems (build settings must be changed accordingly). This is bound to change soon.

# Install required console line apps
- Install [Homebrew](http://brew.sh)
- brew install mogenerator
- brew install xcproj
- brew install batik

# Set up automatic build number bumping
Call ./Ring/SuportingFiles/Scripts/update-build-number.sh from .git/hooks/pre-commit

The build number needs to be changed before uploading to HockeyApp (try setting it to zero).

# Workarounds
TPKeyboardAvoiding 1.2.4 doesn't deal with third-party keyboards gracefully. To fix, open `UIScrollView+TPKeyboardAvoidingAdditions.m` and scroll to the bottom. There, enter the following code:
> @implementation TPKeyboardAvoidingState
> - (BOOL)keyboardVisible { if (self.keyboardRect.size.height == 0) { return NO; } return _keyboardVisible; }
> @end

This is a hack. See also [this ticket](https://github.com/michaeltyson/TPKeyboardAvoiding/issues/130).

# Connect to the RingMD cloud
- GitHub
- iTunes Connect
- Apple Developer Center
- Dropbox
- Pivotal
- HockeyApp
- Heroku (e.g. to access server logs)
- Slack

Make sure to always sign up with the @ring.md email address (except for GitHub).

# Reading material
- [objc.io](http://objc.io) (they regularly post neat [snippets](http://www.objc.io/snippets/) on functional code too)
- [NSHipster](http://nshipster.com)
