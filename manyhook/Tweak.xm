%hook NTKPrideFace

+ (BOOL)isRestrictedForDevice:(id)arg1 {
    return NO;
}

%end

%hook WSWebSheetView

- (BOOL)isChinaRegion {
    return NO;
}

%end

%hook UIDevice

- (BOOL)sf_isChinaRegionCellularDevice {
    return NO;
}

%end

%hook GEOReview

- (BOOL)_isChinaSuppressed {
    return NO;
}

%end