%hook _LSDefaults

+(bool)isRegionChina {
	return NO; 
}

+(bool)regionChina {
	return NO; 
}

%end

%hook NSLocale

+(bool)CalRegionIsChina {
	return NO; 
}

%end