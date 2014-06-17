#import "IOCApplication.h"
#import "iOctocatDelegate.h"


@implementation IOCApplication

- (BOOL)openURL:(NSURL *)url {
	return [(iOctocatDelegate *)self.delegate openURL:url] ? YES : [super openURL:url];
}

- (void)forceOpenURL:(NSURL *)url {
    [super openURL:url];
}

@end