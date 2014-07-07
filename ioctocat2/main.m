#import <UIKit/UIKit.h>
#import "IOCApplication.h"
#import "iOctocatDelegate.h"

int main(int argc, char *argv[]) {
	@autoreleasepool {
//		int retVal = UIApplicationMain(argc, argv, NSStringFromClass(IOCApplication.class),  nil);//  旧 view 层级
        int retVal = UIApplicationMain(argc, argv, nil,  NSStringFromClass([iOctocatDelegate class]));//新View层级
		return retVal;
	}
}