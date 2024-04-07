#import <substrate.h>
#import <dlfcn.h>
#import <CoreFoundation/CoreFoundation.h>


static NSString *(*orig_EMFGetDeviceRegionCode)();

NSString *replaced_EMFGetDeviceRegionCode() {
    return @"TA";
}


__attribute__((constructor)) static void emojiinit() {
    void *EMFGetDeviceRegionCode = MSFindSymbol(MSGetImageByName("/System/Library/PrivateFrameworks/EmojiFoundation.framework/EmojiFoundation"), "_EMFGetDeviceRegionCode");
    MSHookFunction(EMFGetDeviceRegionCode, (void *)replaced_EMFGetDeviceRegionCode, (void **)&orig_EMFGetDeviceRegionCode);
}