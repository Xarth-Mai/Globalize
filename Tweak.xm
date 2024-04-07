#import <substrate.h>
#import <dlfcn.h>
#import <CoreFoundation/CoreFoundation.h>

typedef mach_port_t io_object_t;
typedef io_object_t io_registry_entry_t;
typedef UInt32 IOOptionBits;
typedef char io_name_t[128];

const uint32_t swbh[] = {1,0,0,0}; // only "valid"

// 原始函数指针
static CFTypeRef (*orig_registryEntry)(io_registry_entry_t entry, const io_name_t plane, CFStringRef key, CFAllocatorRef allocator, IOOptionBits options);
static NSString *(*orig_EMFGetDeviceRegionCode)();

// 替换的 registryEntry 函数实现
CFTypeRef replaced_registryEntry(io_registry_entry_t entry, const io_name_t plane, CFStringRef key, CFAllocatorRef allocator, IOOptionBits options) {
    CFTypeRef retval = NULL;
    if (CFEqual(key, CFSTR("region-info"))) {
        retval = CFDataCreate(kCFAllocatorDefault, (const unsigned char *)"TA/A", 5);
    } else if (CFEqual(key, CFSTR("software-behavior"))) {
        retval = CFDataCreate(kCFAllocatorDefault, (const UInt8 *)&swbh, 16);
    } else {
        retval = orig_registryEntry(entry, plane, key, allocator, options);
    }
    return retval;
}


// 替换的 EMFGetDeviceRegionCode 函数实现
NSString *replaced_EMFGetDeviceRegionCode() {
    return @"TA";
}

// Hook初始化函数
__attribute__((constructor)) static void regioninit() {
    // Hook IORegistryEntrySearchCFProperty 函数
    void *IORegistryEntrySearchCFProperty = MSFindSymbol(MSGetImageByName("/System/Library/Frameworks/IOKit.framework/Versions/A/IOKit"), "_IORegistryEntrySearchCFProperty");
    MSHookFunction(IORegistryEntrySearchCFProperty, (void *)replaced_registryEntry, (void **)&orig_registryEntry);
    
    // Hook EMFGetDeviceRegionCode 函数
    void *EMFGetDeviceRegionCode = MSFindSymbol(MSGetImageByName("/System/Library/PrivateFrameworks/EmojiFoundation.framework/EmojiFoundation"), "_EMFGetDeviceRegionCode");
    MSHookFunction(EMFGetDeviceRegionCode, (void *)replaced_EMFGetDeviceRegionCode, (void **)&orig_EMFGetDeviceRegionCode);
}