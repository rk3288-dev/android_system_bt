LOCAL_PATH := $(call my-dir)

# Setup bdroid local make variables for handling configuration
ifneq ($(BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR),)
  bdroid_C_INCLUDES := $(BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR)
  bdroid_CFLAGS += -DHAS_BDROID_BUILDCFG
else
  bdroid_C_INCLUDES :=
  bdroid_CFLAGS += -DHAS_NO_BDROID_BUILDCFG
endif

ifneq ($(BOARD_BLUETOOTH_BDROID_HCILP_INCLUDED),)
  bdroid_CFLAGS += -DHCILP_INCLUDED=$(BOARD_BLUETOOTH_BDROID_HCILP_INCLUDED)
endif

ifneq ($(TARGET_BUILD_VARIANT),user)
bdroid_CFLAGS += -DBLUEDROID_DEBUG
endif

bdroid_CFLAGS += \
  -Wall \
  -Wno-unused-parameter \
  -Wunused-but-set-variable \
  -UNDEBUG \
  -DLOG_NDEBUG=1

# RealTek Bluetooth private configuration table
#ifeq ($(BOARD_HAVE_BLUETOOTH_RTK),true)
bdroid_C_INCLUDES += $(LOCAL_PATH)/bta/hh
bdroid_C_INCLUDES += $(LOCAL_PATH)/bta/dm
bdroid_CFLAGS += -DBLUETOOTH_RTK
bdroid_CFLAGS += -DBLUETOOTH_RTK_API
#endif

#ifeq ($(BOARD_HAVE_BLUETOOTH_RTK_COEX),true)
bdroid_CFLAGS += -DBLUETOOTH_RTK_COEX
#endif

bdroid_CFLAGS += -DROCKCHIP_BLUETOOTH

include $(call all-subdir-makefiles)

# Cleanup our locals
bdroid_C_INCLUDES :=
bdroid_CFLAGS :=
