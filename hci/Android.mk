LOCAL_PATH := $(call my-dir)

# HCI static library for target
# ========================================================
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    src/btsnoop.c \
    src/btsnoop_mem.c \
    src/btsnoop_net.c \
    src/buffer_allocator.c \
    src/hci_audio.c \
    src/hci_hal.c \
    src/hci_hal_h4.c \
    src/hci_hal_mct.c \
    src/hci_inject.c \
    src/hci_layer.c \
    src/hci_packet_factory.c \
    src/hci_packet_parser.c \
    src/low_power_manager.c \
    src/packet_fragmenter.c \
    src/vendor.c \
    ../EventLogTags.logtags

ifeq ($(strip $(BOARD_CONNECTIVITY_MODULE)), mt5931_6622)
LOCAL_CFLAGS += -DMTK_MT6622
endif

ifeq ($(strip $(BOARD_CONNECTIVITY_MODULE)), mt6622)
LOCAL_CFLAGS += -DMTK_MT6622
endif

ifeq ($(strip $(BOARD_CONNECTIVITY_MODULE)), esp8089_bk3515)
LOCAL_CFLAGS += -DBT_BK3515A
endif

ifeq ($(strip $(BOARD_CONNECTIVITY_MODULE)), rda587x)
    LOCAL_CFLAGS += -DRDA587X_BLUETOOTH
endif

ifeq ($(BLUETOOTH_HCI_USE_MCT),true)
LOCAL_CFLAGS += -DHCI_USE_MCT
endif

#ifeq ($(BOARD_HAVE_BLUETOOTH_RTK),true)
LOCAL_CFLAGS += -DBLUETOOTH_RTK
LOCAL_SRC_FILES += \
    src/bt_list.c \
    src/bt_skbuff.c
#endif

#ifeq ($(BOARD_HAVE_BLUETOOTH_RTK_COEX),true)
LOCAL_SRC_FILES += \
    src/rtk_parse.c
#endif

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/include \
    $(LOCAL_PATH)/.. \
    $(LOCAL_PATH)/../include \
    $(LOCAL_PATH)/../btcore/include \
    $(LOCAL_PATH)/../stack/include \
    $(LOCAL_PATH)/../utils/include \
    $(LOCAL_PATH)/../bta/include \
    $(bluetooth_C_INCLUDES)

LOCAL_MODULE := libbt-hci

ifeq ($(TARGET_BUILD_VARIANT), eng)
    LOCAL_CFLAGS += -DBTSNOOP_DEFAULT=TRUE
endif

ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
LOCAL_CFLAGS += -DENABLE_DBG_FLAGS
endif

LOCAL_CFLAGS += $(bluetooth_CFLAGS)
LOCAL_CONLYFLAGS += $(bluetooth_CONLYFLAGS)
LOCAL_CPPFLAGS += $(bluetooth_CPPFLAGS)

include $(BUILD_STATIC_LIBRARY)

# HCI unit tests for target
# ========================================================
ifeq (,$(strip $(SANITIZE_TARGET)))
include $(CLEAR_VARS)

LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/include \
    $(LOCAL_PATH)/.. \
    $(LOCAL_PATH)/../include \
    $(LOCAL_PATH)/../btcore/include \
    $(LOCAL_PATH)/../osi/test \
    $(LOCAL_PATH)/../stack/include \
    $(LOCAL_PATH)/../utils/include \
    $(bluetooth_C_INCLUDES)

LOCAL_SRC_FILES := \
    ../osi/test/AllocationTestHarness.cpp \
    ../osi/test/AlarmTestHarness.cpp \
    ./test/hci_hal_h4_test.cpp \
    ./test/hci_hal_mct_test.cpp \
    ./test/hci_layer_test.cpp \
    ./test/low_power_manager_test.cpp \
    ./test/packet_fragmenter_test.cpp

LOCAL_MODULE := net_test_hci
LOCAL_MODULE_TAGS := tests
LOCAL_SHARED_LIBRARIES := liblog libdl libprotobuf-cpp-full
LOCAL_STATIC_LIBRARIES := libbt-hci libosi libcutils libbtcore libbt-protos

LOCAL_CFLAGS += $(bluetooth_CFLAGS)
LOCAL_CONLYFLAGS += $(bluetooth_CONLYFLAGS)
LOCAL_CPPFLAGS += $(bluetooth_CPPFLAGS)

include $(BUILD_NATIVE_TEST)
endif # SANITIZE_TARGET
