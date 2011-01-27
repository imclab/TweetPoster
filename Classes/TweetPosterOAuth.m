#import "TweetPosterOAuth.h"

// Twitter App 登録情報
static NSString* kConsumerKey = @"xxxxxxxxxxxxxxxxxxxx";
static NSString* kConsumerSecret = @"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";

// Keys for defaults system.
static NSString* kAccessKeyStore = @"TwitterAccessKey";
static NSString* kAccessSecretStore = @"TwitterAccessSecret";

// Shared instance.
static TweetPosterOAuth *s_sharedInstance;

@implementation TweetPosterOAuth;

@synthesize consumer = _consumer;
@synthesize requestToken = _requestToken;
@synthesize accessToken = _accessToken;

#pragma mark Property Accessors

- (void)setAccessToken:(OAToken *)token {
    [_accessToken release];
    _accessToken = token;
    // アクセストークンの保存（あるいは破棄）。
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (token) {
        [defaults setObject:token.key forKey:kAccessKeyStore];
        [defaults setObject:token.secret forKey:kAccessSecretStore];
    } else {
        [defaults removeObjectForKey:kAccessKeyStore];
        [defaults removeObjectForKey:kAccessSecretStore];
    }
}

#pragma mark Constructor / Destructor

- (id)init {
    if ((self = [super init])) {
        // 保存されたアクセストークンの取り出し。
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *accessKey = [defaults stringForKey:kAccessKeyStore];
        NSString *accessSecret = [defaults stringForKey:kAccessSecretStore];
        if (accessKey && accessSecret) {
            self.accessToken = [[[OAToken alloc] initWithKey:accessKey secret:accessSecret] autorelease];
        }
        // コンシューマーの初期化。
        self.consumer = [[[OAConsumer alloc] initWithKey:kConsumerKey secret:kConsumerSecret] autorelease];
    }
    return self;
}

- (void)dealloc {
    [consumer_ release];
    [requestToken_ release];
    [accessToken_ release];
    [super dealloc];
}

#pragma mark Shared Instance Methods

+ (TweetPosterOAuth *)sharedInstance {
    if (s_sharedInstance == nil) s_sharedInstance = [[TweetPosterOAuth alloc] init];
    return s_sharedInstance;
}

+ (void)disposeSharedInstance {
    [s_sharedInstance release];
    s_sharedInstance = nil;
}

@end
