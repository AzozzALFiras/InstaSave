ARCHS = arm64e arm64
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = InstaSave

InstaSave_FILES = Tweak.xm
InstaSave_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
