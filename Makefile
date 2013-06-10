include theos/makefiles/common.mk

TOOL_NAME = UDIDGenerator
UDIDGenerator_CFLAGS = -I./ios-reversed-headers/
UDIDGenerator_FILES = main.m
UDIDGenerator_LIBRARIES = MobileGestalt

include $(THEOS_MAKE_PATH)/tool.mk
