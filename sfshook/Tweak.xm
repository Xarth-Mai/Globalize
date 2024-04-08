%hook _SFSearchEngineController

+(bool)isChinaDevice {
	return NO; 
}

+(bool)_deviceRegionCodeIsChina {
	return NO; 
}

%end