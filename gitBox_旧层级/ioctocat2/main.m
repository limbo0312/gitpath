#import <UIKit/UIKit.h>
#import "IOCApplication.h"
#import "iOctocatDelegate.h"

int main(int argc, char *argv[]) {
	@autoreleasepool {
		int retVal = UIApplicationMain(argc, argv, NSStringFromClass(IOCApplication.class),  nil);
//        int retVal = UIApplicationMain(argc, argv, nil,  NSStringFromClass([iOctocatDelegate class]));
		return retVal;
	}
}