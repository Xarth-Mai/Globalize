ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
THEOS_PACKAGE_SCHEME=rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Globalize
Globalize_FILES = Tweak.xm
include $(THEOS_MAKE_PATH)/tweak.mk

Globalize_EXTRA_FRAMEWORKS = CydiaSubstrate

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += wapihook
SUBPROJECTS += pridewatchfacehook
include $(THEOS_MAKE_PATH)/aggregate.mk
