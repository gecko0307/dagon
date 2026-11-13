/*
 * Copyright (c) 2017-2022, The Khronos Group Inc.
 *
 * SPDX-License-Identifier: Apache-2.0 OR MIT
 */

/**
 * OpenXR extensions type definitions.
 * Based on the reworked OpenXR-D project
 * https://github.com/infinityplusb/OpenXR-D
 */
module bindbc.openxr.ext;

import bindbc.openxr.types;

/*
 * XR_KHR_composition_layer_cube
 */
enum XR_KHR_composition_layer_cube = 1;
enum XR_KHR_composition_layer_cube_SPEC_VERSION = 8;
enum XR_KHR_COMPOSITION_LAYER_CUBE_EXTENSION_NAME = "XR_KHR_composition_layer_cube";

struct XrCompositionLayerCubeKHR
{
    XrStructureType type;
    const(void)* next;
    XrCompositionLayerFlags layerFlags;
    XrSpace space;
    XrEyeVisibility eyeVisibility;
    XrSwapchain swapchain;
    uint imageArrayIndex;
    XrQuaternionf orientation;
}

/*
 * XR_KHR_composition_layer_depth
 */
enum XR_KHR_composition_layer_depth = 1;
enum XR_KHR_composition_layer_depth_SPEC_VERSION = 5;
enum XR_KHR_COMPOSITION_LAYER_DEPTH_EXTENSION_NAME = "XR_KHR_composition_layer_depth";
// XrCompositionLayerDepthInfoKHR extends XrCompositionLayerProjectionView
struct XrCompositionLayerDepthInfoKHR
{
    XrStructureType type;
    const(void)* next;
    XrSwapchainSubImage subImage;
    float minDepth;
    float maxDepth;
    float nearZ;
    float farZ;
}

/*
 * XR_KHR_composition_layer_cylinder
 */
enum XR_KHR_composition_layer_cylinder = 1;
enum XR_KHR_composition_layer_cylinder_SPEC_VERSION = 4;
enum XR_KHR_COMPOSITION_LAYER_CYLINDER_EXTENSION_NAME = "XR_KHR_composition_layer_cylinder";

struct XrCompositionLayerCylinderKHR
{
    XrStructureType type;
    const(void)* next;
    XrCompositionLayerFlags layerFlags;
    XrSpace space;
    XrEyeVisibility eyeVisibility;
    XrSwapchainSubImage subImage;
    XrPosef pose;
    float radius;
    float centralAngle;
    float aspectRatio;
}

/*
 * XR_KHR_composition_layer_equirect
 */
enum XR_KHR_composition_layer_equirect = 1;
enum XR_KHR_composition_layer_equirect_SPEC_VERSION = 3;
enum XR_KHR_COMPOSITION_LAYER_EQUIRECT_EXTENSION_NAME = "XR_KHR_composition_layer_equirect";

struct XrCompositionLayerEquirectKHR
{
    XrStructureType type;
    const(void)* next;
    XrCompositionLayerFlags layerFlags;
    XrSpace space;
    XrEyeVisibility eyeVisibility;
    XrSwapchainSubImage subImage;
    XrPosef pose;
    float radius;
    XrVector2f scale;
    XrVector2f bias;
}

/*
 * XR_KHR_visibility_mask
 */
enum XR_KHR_visibility_mask = 1;
enum XR_KHR_visibility_mask_SPEC_VERSION = 2;
enum XR_KHR_VISIBILITY_MASK_EXTENSION_NAME = "XR_KHR_visibility_mask";

alias XrVisibilityMaskTypeKHR = uint;
enum: XrVisibilityMaskTypeKHR
{
    XR_VISIBILITY_MASK_TYPE_HIDDEN_TRIANGLE_MESH_KHR = 1,
    XR_VISIBILITY_MASK_TYPE_VISIBLE_TRIANGLE_MESH_KHR = 2,
    XR_VISIBILITY_MASK_TYPE_LINE_LOOP_KHR = 3,
    XR_VISIBILITY_MASK_TYPE_MAX_ENUM_KHR = 0x7FFFFFFF
}

struct XrVisibilityMaskKHR
{
    XrStructureType type;
    void* next;
    uint vertexCapacityInput;
    uint vertexCountOutput;
    XrVector2f* vertices;
    uint indexCapacityInput;
    uint indexCountOutput;
    uint* indices;
}

struct XrEventDataVisibilityMaskChangedKHR
{
    XrStructureType type;
    const(void)* next;
    XrSession session;
    XrViewConfigurationType viewConfigurationType;
    uint viewIndex;
}

extern(C)
{
    alias PFN_xrGetVisibilityMaskKHR = XrResult function(XrSession session, XrViewConfigurationType viewConfigurationType, uint viewIndex, XrVisibilityMaskTypeKHR visibilityMaskType, XrVisibilityMaskKHR* visibilityMask);
}

/*
 * XR_KHR_composition_layer_color_scale_bias
 */
enum XR_KHR_composition_layer_color_scale_bias = 1;
enum XR_KHR_composition_layer_color_scale_bias_SPEC_VERSION = 5;
enum XR_KHR_COMPOSITION_LAYER_COLOR_SCALE_BIAS_EXTENSION_NAME = "XR_KHR_composition_layer_color_scale_bias";

// XrCompositionLayerColorScaleBiasKHR extends XrCompositionLayerBaseHeader
struct XrCompositionLayerColorScaleBiasKHR
{
    XrStructureType type;
    const(void)* next;
    XrColor4f colorScale;
    XrColor4f colorBias;
}

/*
 * XR_KHR_loader_init
 */
enum XR_KHR_loader_init = 1;
enum XR_KHR_loader_init_SPEC_VERSION = 1;
enum XR_KHR_LOADER_INIT_EXTENSION_NAME = "XR_KHR_loader_init";

struct XrLoaderInitInfoBaseHeaderKHR
{
    XrStructureType type;
    const(void)* next;
}

extern(C)
{
    alias PFN_xrInitializeLoaderKHR = XrResult function(const(XrLoaderInitInfoBaseHeaderKHR)* loaderInitInfo);
}

/*
 * XR_KHR_composition_layer_equirect2
 */
enum XR_KHR_composition_layer_equirect2 = 1;
enum XR_KHR_composition_layer_equirect2_SPEC_VERSION = 1;
enum XR_KHR_COMPOSITION_LAYER_EQUIRECT2_EXTENSION_NAME = "XR_KHR_composition_layer_equirect2";

struct XrCompositionLayerEquirect2KHR
{
    XrStructureType type;
    const(void)* next;
    XrCompositionLayerFlags layerFlags;
    XrSpace space;
    XrEyeVisibility eyeVisibility;
    XrSwapchainSubImage subImage;
    XrPosef pose;
    float radius;
    float centralHorizontalAngle;
    float upperVerticalAngle;
    float lowerVerticalAngle;
}

/*
 * XR_KHR_binding_modification
 */
enum XR_KHR_binding_modification = 1;
enum XR_KHR_binding_modification_SPEC_VERSION = 1;
enum XR_KHR_BINDING_MODIFICATION_EXTENSION_NAME = "XR_KHR_binding_modification";

struct XrBindingModificationBaseHeaderKHR
{
    XrStructureType type;
    const(void)* next;
}

// XrBindingModificationsKHR extends XrInteractionProfileSuggestedBinding
struct XrBindingModificationsKHR
{
    XrStructureType type;
    const(void)* next;
    uint bindingModificationCount;
    const(XrBindingModificationBaseHeaderKHR*)* bindingModifications;
}

/*
 * XR_KHR_swapchain_usage_input_attachment_bit
 */
enum XR_KHR_swapchain_usage_input_attachment_bit = 1;
enum XR_KHR_swapchain_usage_input_attachment_bit_SPEC_VERSION = 3;
enum XR_KHR_SWAPCHAIN_USAGE_INPUT_ATTACHMENT_BIT_EXTENSION_NAME = "XR_KHR_swapchain_usage_input_attachment_bit";

/*
 * XR_EXT_performance_settings
 */
enum XR_EXT_performance_settings = 1;
enum XR_EXT_performance_settings_SPEC_VERSION = 3;
enum XR_EXT_PERFORMANCE_SETTINGS_EXTENSION_NAME = "XR_EXT_performance_settings";

alias XrPerfSettingsDomainEXT = uint;
enum: XrPerfSettingsDomainEXT
{
    XR_PERF_SETTINGS_DOMAIN_CPU_EXT = 1,
    XR_PERF_SETTINGS_DOMAIN_GPU_EXT = 2,
    XR_PERF_SETTINGS_DOMAIN_MAX_ENUM_EXT = 0x7FFFFFFF
}

alias XrPerfSettingsSubDomainEXT = uint;
enum: XrPerfSettingsSubDomainEXT
{
    XR_PERF_SETTINGS_SUB_DOMAIN_COMPOSITING_EXT = 1,
    XR_PERF_SETTINGS_SUB_DOMAIN_RENDERING_EXT = 2,
    XR_PERF_SETTINGS_SUB_DOMAIN_THERMAL_EXT = 3,
    XR_PERF_SETTINGS_SUB_DOMAIN_MAX_ENUM_EXT = 0x7FFFFFFF
}

alias XrPerfSettingsLevelEXT = uint;
enum: XrPerfSettingsLevelEXT
{
    XR_PERF_SETTINGS_LEVEL_POWER_SAVINGS_EXT = 0,
    XR_PERF_SETTINGS_LEVEL_SUSTAINED_LOW_EXT = 25,
    XR_PERF_SETTINGS_LEVEL_SUSTAINED_HIGH_EXT = 50,
    XR_PERF_SETTINGS_LEVEL_BOOST_EXT = 75,
    XR_PERF_SETTINGS_LEVEL_MAX_ENUM_EXT = 0x7FFFFFFF
}

alias XrPerfSettingsNotificationLevelEXT = uint;
enum: XrPerfSettingsNotificationLevelEXT
{
    XR_PERF_SETTINGS_NOTIF_LEVEL_NORMAL_EXT = 0,
    XR_PERF_SETTINGS_NOTIF_LEVEL_WARNING_EXT = 25,
    XR_PERF_SETTINGS_NOTIF_LEVEL_IMPAIRED_EXT = 75,
    XR_PERF_SETTINGS_NOTIFICATION_LEVEL_MAX_ENUM_EXT = 0x7FFFFFFF
}

struct XrEventDataPerfSettingsEXT
{
    XrStructureType type;
    const(void)* next;
    XrPerfSettingsDomainEXT domain;
    XrPerfSettingsSubDomainEXT subDomain;
    XrPerfSettingsNotificationLevelEXT fromLevel;
    XrPerfSettingsNotificationLevelEXT toLevel;
}

extern(C)
{
    alias PFN_xrPerfSettingsSetPerformanceLevelEXT = XrResult function (XrSession session, XrPerfSettingsDomainEXT domain, XrPerfSettingsLevelEXT level);
}

enum XR_EXT_thermal_query = 1;
enum XR_EXT_thermal_query_SPEC_VERSION = 2;
enum XR_EXT_THERMAL_QUERY_EXTENSION_NAME = "XR_EXT_thermal_query";

extern(C)
{
    alias PFN_xrThermalGetTemperatureTrendEXT = XrResult function(XrSession session, XrPerfSettingsDomainEXT domain, XrPerfSettingsNotificationLevelEXT* notificationLevel, float* tempHeadroom, float* tempSlope);
}

/*
 * XR_EXT_debug_utils
 */
enum XR_EXT_debug_utils = 1;
struct XrDebugUtilsMessengerEXT_T;
alias XrDebugUtilsMessengerEXT = XrDebugUtilsMessengerEXT_T*;
enum XR_EXT_debug_utils_SPEC_VERSION = 4;
enum XR_EXT_DEBUG_UTILS_EXTENSION_NAME = "XR_EXT_debug_utils";

alias XrDebugUtilsMessageSeverityFlagsEXT = XrFlags64;
enum: XrDebugUtilsMessageSeverityFlagsEXT
{
    XR_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT = 0x00000001,
    XR_DEBUG_UTILS_MESSAGE_SEVERITY_INFO_BIT_EXT    = 0x00000010,
    XR_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT = 0x00000100,
    XR_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT   = 0x00001000
}

alias XrDebugUtilsMessageTypeFlagsEXT = XrFlags64;
enum: XrDebugUtilsMessageTypeFlagsEXT
{
    XR_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT     = 0x00000001,
    XR_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT  = 0x00000002,
    XR_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT = 0x00000004,
    XR_DEBUG_UTILS_MESSAGE_TYPE_CONFORMANCE_BIT_EXT = 0x00000008
}

struct XrDebugUtilsObjectNameInfoEXT
{
    XrStructureType type;
    const(void)* next;
    XrObjectType objectType;
    ulong objectHandle;
    const(char)* objectName;
}

struct XrDebugUtilsLabelEXT
{
    XrStructureType type;
    const(void)* next;
    const(char)* labelName;
}

struct XrDebugUtilsMessengerCallbackDataEXT
{
    XrStructureType type;
    const(void)* next;
    const(char)* messageId;
    const(char)* functionName;
    const(char)* message;
    uint objectCount;
    XrDebugUtilsObjectNameInfoEXT* objects;
    uint sessionLabelCount;
    XrDebugUtilsLabelEXT* sessionLabels;
}

extern(C)
{
    alias PFN_xrDebugUtilsMessengerCallbackEXT = uint function(XrDebugUtilsMessageSeverityFlagsEXT messageSeverity, XrDebugUtilsMessageTypeFlagsEXT messageTypes, const(XrDebugUtilsMessengerCallbackDataEXT)* callbackData, void* userData);
}

// XrDebugUtilsMessengerCreateInfoEXT extends XrInstanceCreateInfo
struct XrDebugUtilsMessengerCreateInfoEXT
{
    XrStructureType type;
    const(void)* next;
    XrDebugUtilsMessageSeverityFlagsEXT messageSeverities;
    XrDebugUtilsMessageTypeFlagsEXT messageTypes;
    PFN_xrDebugUtilsMessengerCallbackEXT userCallback;
    void* userData;
}

extern(C)
{
    alias PFN_xrSetDebugUtilsObjectNameEXT = XrResult function(XrInstance instance, const(XrDebugUtilsObjectNameInfoEXT)* nameInfo);
    alias PFN_xrCreateDebugUtilsMessengerEXT = XrResult function(XrInstance instance, const(XrDebugUtilsMessengerCreateInfoEXT)* createInfo, XrDebugUtilsMessengerEXT* messenger);
    alias PFN_xrDestroyDebugUtilsMessengerEXT = XrResult function(XrDebugUtilsMessengerEXT messenger);
    alias PFN_xrSubmitDebugUtilsMessageEXT = XrResult function(XrInstance instance, XrDebugUtilsMessageSeverityFlagsEXT messageSeverity, XrDebugUtilsMessageTypeFlagsEXT messageTypes, const(XrDebugUtilsMessengerCallbackDataEXT)* callbackData);
    alias PFN_xrSessionBeginDebugUtilsLabelRegionEXT = XrResult function(XrSession session, const(XrDebugUtilsLabelEXT)* labelInfo);
    alias PFN_xrSessionEndDebugUtilsLabelRegionEXT = XrResult function(XrSession session);
    alias PFN_xrSessionInsertDebugUtilsLabelEXT = XrResult function(XrSession session, const(XrDebugUtilsLabelEXT)* labelInfo);
}

/*
 * XR_EXT_eye_gaze_interaction
 */
enum XR_EXT_eye_gaze_interaction = 1;
enum XR_EXT_eye_gaze_interaction_SPEC_VERSION = 1;
enum XR_EXT_EYE_GAZE_INTERACTION_EXTENSION_NAME = "XR_EXT_eye_gaze_interaction";
// XrSystemEyeGazeInteractionPropertiesEXT extends XrSystemProperties
struct XrSystemEyeGazeInteractionPropertiesEXT
{
    XrStructureType type;
    void* next;
    XrBool32 supportsEyeGazeInteraction;
}

// XrEyeGazeSampleTimeEXT extends XrSpaceLocation
struct XrEyeGazeSampleTimeEXT
{
    XrStructureType type;
    void* next;
    XrTime time;
}

/*
 * XR_EXTX_overlay
 */
enum XR_EXTX_overlay = 1;
enum XR_EXTX_overlay_SPEC_VERSION = 5;
enum XR_EXTX_OVERLAY_EXTENSION_NAME = "XR_EXTX_overlay";
alias XrOverlaySessionCreateFlagsEXTX = XrFlags64;

// Flag bits for XrOverlaySessionCreateFlagsEXTX

alias XrOverlayMainSessionFlagsEXTX = XrFlags64;

enum: XrOverlayMainSessionFlagsEXTX
{
    XR_OVERLAY_MAIN_SESSION_ENABLED_COMPOSITION_LAYER_INFO_DEPTH_BIT_EXTX = 0x00000001
}

// XrSessionCreateInfoOverlayEXTX extends XrSessionCreateInfo
struct XrSessionCreateInfoOverlayEXTX
{
    XrStructureType type;
    const(void)* next;
    XrOverlaySessionCreateFlagsEXTX createFlags;
    uint sessionLayersPlacement;
}

struct XrEventDataMainSessionVisibilityChangedEXTX
{
    XrStructureType type;
    const(void)* next;
    XrBool32 visible;
    XrOverlayMainSessionFlagsEXTX flags;
}

/*
 * XR_VARJO_quad_views
 */
enum XR_VARJO_quad_views = 1;
enum XR_VARJO_quad_views_SPEC_VERSION = 1;
enum XR_VARJO_QUAD_VIEWS_EXTENSION_NAME = "XR_VARJO_quad_views";

/*
 * XR_MSFT_unbounded_reference_space
 */
enum XR_MSFT_unbounded_reference_space = 1;
enum XR_MSFT_unbounded_reference_space_SPEC_VERSION = 1;
enum XR_MSFT_UNBOUNDED_REFERENCE_SPACE_EXTENSION_NAME = "XR_MSFT_unbounded_reference_space";

/*
 * XR_MSFT_spatial_anchor
 */
enum XR_MSFT_spatial_anchor = 1;
struct XrSpatialAnchorMSFT_T;
alias XrSpatialAnchorMSFT = XrSpatialAnchorMSFT_T*;
enum XR_MSFT_spatial_anchor_SPEC_VERSION = 2;
enum XR_MSFT_SPATIAL_ANCHOR_EXTENSION_NAME = "XR_MSFT_spatial_anchor";

struct XrSpatialAnchorCreateInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    XrSpace space;
    XrPosef pose;
    XrTime time;
}

struct XrSpatialAnchorSpaceCreateInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    XrSpatialAnchorMSFT anchor;
    XrPosef poseInAnchorSpace;
}

extern(C)
{
    alias PFN_xrCreateSpatialAnchorMSFT = XrResult function(XrSession session, const(XrSpatialAnchorCreateInfoMSFT)* createInfo, XrSpatialAnchorMSFT* anchor);
    alias PFN_xrCreateSpatialAnchorSpaceMSFT = XrResult function(XrSession session, const(XrSpatialAnchorSpaceCreateInfoMSFT)* createInfo, XrSpace* space);
    alias PFN_xrDestroySpatialAnchorMSFT = XrResult function(XrSpatialAnchorMSFT anchor);
}

/*
 * XR_FB_composition_layer_image_layout
 */
enum XR_FB_composition_layer_image_layout = 1;
enum XR_FB_composition_layer_image_layout_SPEC_VERSION = 1;
enum XR_FB_COMPOSITION_LAYER_IMAGE_LAYOUT_EXTENSION_NAME = "XR_FB_composition_layer_image_layout";

alias XrCompositionLayerImageLayoutFlagsFB = XrFlags64;
enum: XrCompositionLayerImageLayoutFlagsFB
{
    XR_COMPOSITION_LAYER_IMAGE_LAYOUT_VERTICAL_FLIP_BIT_FB = 0x00000001
}

// XrCompositionLayerImageLayoutFB extends XrCompositionLayerBaseHeader
struct XrCompositionLayerImageLayoutFB
{
    XrStructureType type;
    void* next;
    XrCompositionLayerImageLayoutFlagsFB flags;
}

/*
 * XR_FB_composition_layer_alpha_blend
 */
enum XR_FB_composition_layer_alpha_blend = 1;
enum XR_FB_composition_layer_alpha_blend_SPEC_VERSION = 2;
enum XR_FB_COMPOSITION_LAYER_ALPHA_BLEND_EXTENSION_NAME = "XR_FB_composition_layer_alpha_blend";

enum XrBlendFactorFB
{
    XR_BLEND_FACTOR_ZERO_FB = 0,
    XR_BLEND_FACTOR_ONE_FB = 1,
    XR_BLEND_FACTOR_SRC_ALPHA_FB = 2,
    XR_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA_FB = 3,
    XR_BLEND_FACTOR_DST_ALPHA_FB = 4,
    XR_BLEND_FACTOR_ONE_MINUS_DST_ALPHA_FB = 5,
    XR_BLEND_FACTOR_MAX_ENUM_FB = 0x7FFFFFFF
}

// XrCompositionLayerAlphaBlendFB extends XrCompositionLayerBaseHeader
struct XrCompositionLayerAlphaBlendFB
{
    XrStructureType type;
    void* next;
    XrBlendFactorFB srcFactorColor;
    XrBlendFactorFB dstFactorColor;
    XrBlendFactorFB srcFactorAlpha;
    XrBlendFactorFB dstFactorAlpha;
}

/*
 * XR_MND_headless
 */
enum XR_MND_headless = 1;
enum XR_MND_headless_SPEC_VERSION = 2;
enum XR_MND_HEADLESS_EXTENSION_NAME = "XR_MND_headless";

/*
 * XR_OCULUS_android_session_state_enable
 */
enum XR_OCULUS_android_session_state_enable = 1;
enum XR_OCULUS_android_session_state_enable_SPEC_VERSION = 1;
enum XR_OCULUS_ANDROID_SESSION_STATE_ENABLE_EXTENSION_NAME = "XR_OCULUS_android_session_state_enable";

/*
 * XR_EXT_view_configuration_depth_range
 */
enum XR_EXT_view_configuration_depth_range = 1;
enum XR_EXT_view_configuration_depth_range_SPEC_VERSION = 1;
enum XR_EXT_VIEW_CONFIGURATION_DEPTH_RANGE_EXTENSION_NAME = "XR_EXT_view_configuration_depth_range";

// XrViewConfigurationDepthRangeEXT extends XrViewConfigurationView
struct XrViewConfigurationDepthRangeEXT
{
    XrStructureType type;
    void* next;
    float recommendedNearZ;
    float minNearZ;
    float recommendedFarZ;
    float maxFarZ;
}

/*
 * XR_EXT_conformance_automation
 */
enum XR_EXT_conformance_automation = 1;
enum XR_EXT_conformance_automation_SPEC_VERSION = 3;
enum XR_EXT_CONFORMANCE_AUTOMATION_EXTENSION_NAME = "XR_EXT_conformance_automation";

extern(C)
{
    alias PFN_xrSetInputDeviceActiveEXT = XrResult function(XrSession session, XrPath interactionProfile, XrPath topLevelPath, XrBool32 isActive);
    alias PFN_xrSetInputDeviceStateBoolEXT = XrResult function(XrSession session, XrPath topLevelPath, XrPath inputSourcePath, XrBool32 state);
    alias PFN_xrSetInputDeviceStateFloatEXT = XrResult function(XrSession session, XrPath topLevelPath, XrPath inputSourcePath, float state);
    alias PFN_xrSetInputDeviceStateVector2fEXT = XrResult function(XrSession session, XrPath topLevelPath, XrPath inputSourcePath, XrVector2f state);
    alias PFN_xrSetInputDeviceLocationEXT = XrResult function(XrSession session, XrPath topLevelPath, XrPath inputSourcePath, XrSpace space, XrPosef pose);
}

/*
 * XR_MSFT_spatial_graph_bridge
 */
enum XR_MSFT_spatial_graph_bridge = 1;
enum XR_MSFT_spatial_graph_bridge_SPEC_VERSION = 1;
enum XR_MSFT_SPATIAL_GRAPH_BRIDGE_EXTENSION_NAME = "XR_MSFT_spatial_graph_bridge";

enum XrSpatialGraphNodeTypeMSFT
{
    XR_SPATIAL_GRAPH_NODE_TYPE_STATIC_MSFT = 1,
    XR_SPATIAL_GRAPH_NODE_TYPE_DYNAMIC_MSFT = 2,
    XR_SPATIAL_GRAPH_NODE_TYPE_MAX_ENUM_MSFT = 0x7FFFFFFF
}

struct XrSpatialGraphNodeSpaceCreateInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    XrSpatialGraphNodeTypeMSFT nodeType;
    ubyte[16] nodeId;
    XrPosef pose;
}

extern(C)
{
    alias PFN_xrCreateSpatialGraphNodeSpaceMSFT = XrResult function(XrSession session, const(XrSpatialGraphNodeSpaceCreateInfoMSFT)* createInfo, XrSpace* space);
}

/*
 * XR_MSFT_hand_interaction
 */
enum XR_MSFT_hand_interaction = 1;
enum XR_MSFT_hand_interaction_SPEC_VERSION = 1;
enum XR_MSFT_HAND_INTERACTION_EXTENSION_NAME = "XR_MSFT_hand_interaction";

enum XR_EXT_hand_tracking = 1;

enum XR_HAND_JOINT_COUNT_EXT = 26;

/*
 * XR_EXT_hand_tracking
 */
struct XrHandTrackerEXT_T;
alias XrHandTrackerEXT = XrHandTrackerEXT_T*;
enum XR_EXT_hand_tracking_SPEC_VERSION = 4;
enum XR_EXT_HAND_TRACKING_EXTENSION_NAME = "XR_EXT_hand_tracking";

alias XrHandEXT = uint;
enum: XrHandEXT
{
    XR_HAND_LEFT_EXT = 1,
    XR_HAND_RIGHT_EXT = 2,
    XR_HAND_MAX_ENUM_EXT = 0x7FFFFFFF
}

alias XrHandJointEXT = uint;
enum: XrHandJointEXT
{
    XR_HAND_JOINT_PALM_EXT = 0,
    XR_HAND_JOINT_WRIST_EXT = 1,
    XR_HAND_JOINT_THUMB_METACARPAL_EXT = 2,
    XR_HAND_JOINT_THUMB_PROXIMAL_EXT = 3,
    XR_HAND_JOINT_THUMB_DISTAL_EXT = 4,
    XR_HAND_JOINT_THUMB_TIP_EXT = 5,
    XR_HAND_JOINT_INDEX_METACARPAL_EXT = 6,
    XR_HAND_JOINT_INDEX_PROXIMAL_EXT = 7,
    XR_HAND_JOINT_INDEX_INTERMEDIATE_EXT = 8,
    XR_HAND_JOINT_INDEX_DISTAL_EXT = 9,
    XR_HAND_JOINT_INDEX_TIP_EXT = 10,
    XR_HAND_JOINT_MIDDLE_METACARPAL_EXT = 11,
    XR_HAND_JOINT_MIDDLE_PROXIMAL_EXT = 12,
    XR_HAND_JOINT_MIDDLE_INTERMEDIATE_EXT = 13,
    XR_HAND_JOINT_MIDDLE_DISTAL_EXT = 14,
    XR_HAND_JOINT_MIDDLE_TIP_EXT = 15,
    XR_HAND_JOINT_RING_METACARPAL_EXT = 16,
    XR_HAND_JOINT_RING_PROXIMAL_EXT = 17,
    XR_HAND_JOINT_RING_INTERMEDIATE_EXT = 18,
    XR_HAND_JOINT_RING_DISTAL_EXT = 19,
    XR_HAND_JOINT_RING_TIP_EXT = 20,
    XR_HAND_JOINT_LITTLE_METACARPAL_EXT = 21,
    XR_HAND_JOINT_LITTLE_PROXIMAL_EXT = 22,
    XR_HAND_JOINT_LITTLE_INTERMEDIATE_EXT = 23,
    XR_HAND_JOINT_LITTLE_DISTAL_EXT = 24,
    XR_HAND_JOINT_LITTLE_TIP_EXT = 25,
    XR_HAND_JOINT_MAX_ENUM_EXT = 0x7FFFFFFF
}

alias XrHandJointSetEXT = uint;
enum: XrHandJointSetEXT
{
    XR_HAND_JOINT_SET_DEFAULT_EXT = 0,
    XR_HAND_JOINT_SET_MAX_ENUM_EXT = 0x7FFFFFFF
}

// XrSystemHandTrackingPropertiesEXT extends XrSystemProperties
struct XrSystemHandTrackingPropertiesEXT
{
    XrStructureType type;
    void* next;
    XrBool32 supportsHandTracking;
}

struct XrHandTrackerCreateInfoEXT
{
    XrStructureType type;
    const(void)* next;
    XrHandEXT hand;
    XrHandJointSetEXT handJointSet;
}

struct XrHandJointsLocateInfoEXT
{
    XrStructureType type;
    const(void)* next;
    XrSpace baseSpace;
    XrTime time;
}

struct XrHandJointLocationEXT
{
    XrSpaceLocationFlags locationFlags;
    XrPosef pose;
    float radius;
}

struct XrHandJointVelocityEXT
{
    XrSpaceVelocityFlags velocityFlags;
    XrVector3f linearVelocity;
    XrVector3f angularVelocity;
}

struct XrHandJointLocationsEXT
{
    XrStructureType type;
    void* next;
    XrBool32 isActive;
    uint jointCount;
    XrHandJointLocationEXT* jointLocations;
}

// XrHandJointVelocitiesEXT extends XrHandJointLocationsEXT
struct XrHandJointVelocitiesEXT
{
    XrStructureType type;
    void* next;
    uint jointCount;
    XrHandJointVelocityEXT* jointVelocities;
}

extern(C)
{
    alias PFN_xrCreateHandTrackerEXT = XrResult function(XrSession session, const(XrHandTrackerCreateInfoEXT)* createInfo, XrHandTrackerEXT* handTracker);
    alias PFN_xrDestroyHandTrackerEXT = XrResult function(XrHandTrackerEXT handTracker);
    alias PFN_xrLocateHandJointsEXT = XrResult function(XrHandTrackerEXT handTracker, const(XrHandJointsLocateInfoEXT)* locateInfo, XrHandJointLocationsEXT* locations);
}

/*
 * XR_MSFT_hand_tracking_mesh
 */
enum XR_MSFT_hand_tracking_mesh = 1;
enum XR_MSFT_hand_tracking_mesh_SPEC_VERSION = 4;
enum XR_MSFT_HAND_TRACKING_MESH_EXTENSION_NAME = "XR_MSFT_hand_tracking_mesh";

alias XrHandPoseTypeMSFT = uint;
enum: XrHandPoseTypeMSFT
{
    XR_HAND_POSE_TYPE_TRACKED_MSFT = 0,
    XR_HAND_POSE_TYPE_REFERENCE_OPEN_PALM_MSFT = 1,
    XR_HAND_POSE_TYPE_MAX_ENUM_MSFT = 0x7FFFFFFF
}

// XrSystemHandTrackingMeshPropertiesMSFT extends XrSystemProperties
struct XrSystemHandTrackingMeshPropertiesMSFT
{
    XrStructureType type;
    void* next;
    XrBool32 supportsHandTrackingMesh;
    uint maxHandMeshIndexCount;
    uint maxHandMeshVertexCount;
}

struct XrHandMeshSpaceCreateInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    XrHandPoseTypeMSFT handPoseType;
    XrPosef poseInHandMeshSpace;
}

struct XrHandMeshUpdateInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    XrTime time;
    XrHandPoseTypeMSFT handPoseType;
}

struct XrHandMeshIndexBufferMSFT
{
    uint indexBufferKey;
    uint indexCapacityInput;
    uint indexCountOutput;
    uint* indices;
}

struct XrHandMeshVertexMSFT
{
    XrVector3f position;
    XrVector3f normal;
}

struct XrHandMeshVertexBufferMSFT
{
    XrTime vertexUpdateTime;
    uint vertexCapacityInput;
    uint vertexCountOutput;
    XrHandMeshVertexMSFT* vertices;
}

struct XrHandMeshMSFT
{
    XrStructureType type;
    void* next;
    XrBool32 isActive;
    XrBool32 indexBufferChanged;
    XrBool32 vertexBufferChanged;
    XrHandMeshIndexBufferMSFT indexBuffer;
    XrHandMeshVertexBufferMSFT vertexBuffer;
}

// XrHandPoseTypeInfoMSFT extends XrHandTrackerCreateInfoEXT
struct XrHandPoseTypeInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    XrHandPoseTypeMSFT handPoseType;
}

extern(C)
{
    alias PFN_xrCreateHandMeshSpaceMSFT = XrResult function(XrHandTrackerEXT handTracker, const(XrHandMeshSpaceCreateInfoMSFT)* createInfo, XrSpace* space);
    alias PFN_xrUpdateHandMeshMSFT = XrResult function(XrHandTrackerEXT handTracker, const(XrHandMeshUpdateInfoMSFT)* updateInfo, XrHandMeshMSFT* handMesh);
}

/*
 * XR_MSFT_secondary_view_configuration
 */
enum XR_MSFT_secondary_view_configuration = 1;
enum XR_MSFT_secondary_view_configuration_SPEC_VERSION = 1;
enum XR_MSFT_SECONDARY_VIEW_CONFIGURATION_EXTENSION_NAME = "XR_MSFT_secondary_view_configuration";
// XrSecondaryViewConfigurationSessionBeginInfoMSFT extends XrSessionBeginInfo
struct XrSecondaryViewConfigurationSessionBeginInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    uint viewConfigurationCount;
    const(XrViewConfigurationType)* enabledViewConfigurationTypes;
}

struct XrSecondaryViewConfigurationStateMSFT
{
    XrStructureType type;
    void* next;
    XrViewConfigurationType viewConfigurationType;
    XrBool32 active;
}

// XrSecondaryViewConfigurationFrameStateMSFT extends XrFrameState
struct XrSecondaryViewConfigurationFrameStateMSFT
{
    XrStructureType type;
    void* next;
    uint viewConfigurationCount;
    XrSecondaryViewConfigurationStateMSFT* viewConfigurationStates;
}

struct XrSecondaryViewConfigurationLayerInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    XrViewConfigurationType viewConfigurationType;
    XrEnvironmentBlendMode environmentBlendMode;
    uint layerCount;
    const(XrCompositionLayerBaseHeader*)* layers;
}

// XrSecondaryViewConfigurationFrameEndInfoMSFT extends XrFrameEndInfo
struct XrSecondaryViewConfigurationFrameEndInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    uint viewConfigurationCount;
    const(XrSecondaryViewConfigurationLayerInfoMSFT)* viewConfigurationLayersInfo;
}

// XrSecondaryViewConfigurationSwapchainCreateInfoMSFT extends XrSwapchainCreateInfo
struct XrSecondaryViewConfigurationSwapchainCreateInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    XrViewConfigurationType viewConfigurationType;
}

/*
 * XR_MSFT_first_person_observer
 */
enum XR_MSFT_first_person_observer = 1;
enum XR_MSFT_first_person_observer_SPEC_VERSION = 1;
enum XR_MSFT_FIRST_PERSON_OBSERVER_EXTENSION_NAME = "XR_MSFT_first_person_observer";

/*
 * XR_MSFT_controller_model
 */
enum XR_MSFT_controller_model = 1;

enum XR_NULL_CONTROLLER_MODEL_KEY_MSFT = 0;

alias XrControllerModelKeyMSFT = ulong;
enum XR_MSFT_controller_model_SPEC_VERSION = 2;
enum XR_MSFT_CONTROLLER_MODEL_EXTENSION_NAME = "XR_MSFT_controller_model";
enum XR_MAX_CONTROLLER_MODEL_NODE_NAME_SIZE_MSFT = 64;

struct XrControllerModelKeyStateMSFT
{
    XrStructureType type;
    void* next;
    XrControllerModelKeyMSFT modelKey;
}

struct XrControllerModelNodePropertiesMSFT
{
    XrStructureType type;
    void* next;
    char[XR_MAX_CONTROLLER_MODEL_NODE_NAME_SIZE_MSFT] parentNodeName;
    char[XR_MAX_CONTROLLER_MODEL_NODE_NAME_SIZE_MSFT] nodeName;
}

struct XrControllerModelPropertiesMSFT
{
    XrStructureType type;
    void* next;
    uint nodeCapacityInput;
    uint nodeCountOutput;
    XrControllerModelNodePropertiesMSFT* nodeProperties;
}

struct XrControllerModelNodeStateMSFT
{
    XrStructureType type;
    void* next;
    XrPosef nodePose;
}

struct XrControllerModelStateMSFT
{
    XrStructureType type;
    void* next;
    uint nodeCapacityInput;
    uint nodeCountOutput;
    XrControllerModelNodeStateMSFT* nodeStates;
}

extern(C)
{
    alias PFN_xrGetControllerModelKeyMSFT = XrResult function(XrSession session, XrPath topLevelUserPath, XrControllerModelKeyStateMSFT* controllerModelKeyState);
    alias PFN_xrLoadControllerModelMSFT = XrResult function(XrSession session, XrControllerModelKeyMSFT modelKey, uint bufferCapacityInput, uint* bufferCountOutput, ubyte* buffer);
    alias PFN_xrGetControllerModelPropertiesMSFT = XrResult function(XrSession session, XrControllerModelKeyMSFT modelKey, XrControllerModelPropertiesMSFT* properties);
    alias PFN_xrGetControllerModelStateMSFT = XrResult function(XrSession session, XrControllerModelKeyMSFT modelKey, XrControllerModelStateMSFT* state);
}

/*
 * XR_EXT_win32_appcontainer_compatible
 */
enum XR_EXT_win32_appcontainer_compatible = 1;
enum XR_EXT_win32_appcontainer_compatible_SPEC_VERSION = 1;
enum XR_EXT_WIN32_APPCONTAINER_COMPATIBLE_EXTENSION_NAME = "XR_EXT_win32_appcontainer_compatible";

/*
 * XR_EPIC_view_configuration_fov
 */
enum XR_EPIC_view_configuration_fov = 1;
enum XR_EPIC_view_configuration_fov_SPEC_VERSION = 2;
enum XR_EPIC_VIEW_CONFIGURATION_FOV_EXTENSION_NAME = "XR_EPIC_view_configuration_fov";

// XrViewConfigurationViewFovEPIC extends XrViewConfigurationView
struct XrViewConfigurationViewFovEPIC
{
    XrStructureType type;
    const(void)* next;
    XrFovf recommendedFov;
    XrFovf maxMutableFov;
}

/*
 * XR_MSFT_composition_layer_reprojection
 */
enum XR_MSFT_composition_layer_reprojection = 1;
enum XR_MSFT_composition_layer_reprojection_SPEC_VERSION = 1;
enum XR_MSFT_COMPOSITION_LAYER_REPROJECTION_EXTENSION_NAME = "XR_MSFT_composition_layer_reprojection";

enum XrReprojectionModeMSFT
{
    XR_REPROJECTION_MODE_DEPTH_MSFT = 1,
    XR_REPROJECTION_MODE_PLANAR_FROM_DEPTH_MSFT = 2,
    XR_REPROJECTION_MODE_PLANAR_MANUAL_MSFT = 3,
    XR_REPROJECTION_MODE_ORIENTATION_ONLY_MSFT = 4,
    XR_REPROJECTION_MODE_MAX_ENUM_MSFT = 0x7FFFFFFF
}

// XrCompositionLayerReprojectionInfoMSFT extends XrCompositionLayerProjection
struct XrCompositionLayerReprojectionInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    XrReprojectionModeMSFT reprojectionMode;
}

// XrCompositionLayerReprojectionPlaneOverrideMSFT extends XrCompositionLayerProjection
struct XrCompositionLayerReprojectionPlaneOverrideMSFT
{
    XrStructureType type;
    const(void)* next;
    XrVector3f position;
    XrVector3f normal;
    XrVector3f velocity;
}

extern(C)
{
    alias PFN_xrEnumerateReprojectionModesMSFT = XrResult function(XrInstance instance, XrSystemId systemId, XrViewConfigurationType viewConfigurationType, uint modeCapacityInput, uint* modeCountOutput, XrReprojectionModeMSFT* modes);
}

/*
 * XR_HUAWEI_controller_interaction
 */
enum XR_HUAWEI_controller_interaction = 1;
enum XR_HUAWEI_controller_interaction_SPEC_VERSION = 1;
enum XR_HUAWEI_CONTROLLER_INTERACTION_EXTENSION_NAME = "XR_HUAWEI_controller_interaction";

/*
 * XR_FB_swapchain_update_state
 */
enum XR_FB_swapchain_update_state = 1;
enum XR_FB_swapchain_update_state_SPEC_VERSION = 3;
enum XR_FB_SWAPCHAIN_UPDATE_STATE_EXTENSION_NAME = "XR_FB_swapchain_update_state";

struct XrSwapchainStateBaseHeaderFB
{
    XrStructureType type;
    void* next;
}

extern(C)
{
    alias PFN_xrUpdateSwapchainFB = XrResult function(XrSwapchain swapchain, const(XrSwapchainStateBaseHeaderFB)* state);
    alias PFN_xrGetSwapchainStateFB = XrResult function(XrSwapchain swapchain, XrSwapchainStateBaseHeaderFB* state);
}

/*
 * XR_FB_composition_layer_secure_content
 */
enum XR_FB_composition_layer_secure_content = 1;
enum XR_FB_composition_layer_secure_content_SPEC_VERSION = 1;
enum XR_FB_COMPOSITION_LAYER_SECURE_CONTENT_EXTENSION_NAME = "XR_FB_composition_layer_secure_content";

alias XrCompositionLayerSecureContentFlagsFB = XrFlags64;
enum: XrCompositionLayerSecureContentFlagsFB
{
    XR_COMPOSITION_LAYER_SECURE_CONTENT_EXCLUDE_LAYER_BIT_FB = 0x00000001,
    XR_COMPOSITION_LAYER_SECURE_CONTENT_REPLACE_LAYER_BIT_FB = 0x00000002
}

// XrCompositionLayerSecureContentFB extends XrCompositionLayerBaseHeader
struct XrCompositionLayerSecureContentFB
{
    XrStructureType type;
    const(void)* next;
    XrCompositionLayerSecureContentFlagsFB flags;
}

/*
 * XR_VALVE_analog_threshold
 */
enum XR_VALVE_analog_threshold = 1;
enum XR_VALVE_analog_threshold_SPEC_VERSION = 2;
enum XR_VALVE_ANALOG_THRESHOLD_EXTENSION_NAME = "XR_VALVE_analog_threshold";

struct XrInteractionProfileAnalogThresholdVALVE
{
    XrStructureType type;
    const(void)* next;
    XrAction action;
    XrPath binding;
    float onThreshold;
    float offThreshold;
    const(XrHapticBaseHeader)* onHaptic;
    const(XrHapticBaseHeader)* offHaptic;
}

/*
 * XR_EXT_hand_joints_motion_range
 */
enum XR_EXT_hand_joints_motion_range = 1;
enum XR_EXT_hand_joints_motion_range_SPEC_VERSION = 1;
enum XR_EXT_HAND_JOINTS_MOTION_RANGE_EXTENSION_NAME = "XR_EXT_hand_joints_motion_range";

enum XrHandJointsMotionRangeEXT
{
    XR_HAND_JOINTS_MOTION_RANGE_UNOBSTRUCTED_EXT = 1,
    XR_HAND_JOINTS_MOTION_RANGE_CONFORMING_TO_CONTROLLER_EXT = 2,
    XR_HAND_JOINTS_MOTION_RANGE_MAX_ENUM_EXT = 0x7FFFFFFF
}

// XrHandJointsMotionRangeInfoEXT extends XrHandJointsLocateInfoEXT
struct XrHandJointsMotionRangeInfoEXT
{
    XrStructureType type;
    const(void)* next;
    XrHandJointsMotionRangeEXT handJointsMotionRange;
}

/*
 * XR_EXT_samsung_odyssey_controller
 */
enum XR_EXT_samsung_odyssey_controller = 1;
enum XR_EXT_samsung_odyssey_controller_SPEC_VERSION = 1;
enum XR_EXT_SAMSUNG_ODYSSEY_CONTROLLER_EXTENSION_NAME = "XR_EXT_samsung_odyssey_controller";

/*
 * XR_EXT_hp_mixed_reality_controller
 */
enum XR_EXT_hp_mixed_reality_controller = 1;
enum XR_EXT_hp_mixed_reality_controller_SPEC_VERSION = 1;
enum XR_EXT_HP_MIXED_REALITY_CONTROLLER_EXTENSION_NAME = "XR_EXT_hp_mixed_reality_controller";

/*
 * XR_MND_swapchain_usage_input_attachment_bit
 */
enum XR_MND_swapchain_usage_input_attachment_bit = 1;
enum XR_MND_swapchain_usage_input_attachment_bit_SPEC_VERSION = 2;
enum XR_MND_SWAPCHAIN_USAGE_INPUT_ATTACHMENT_BIT_EXTENSION_NAME = "XR_MND_swapchain_usage_input_attachment_bit";

/*
 * XR_MSFT_scene_understanding
 */
enum XR_MSFT_scene_understanding = 1;

struct XrSceneObserverMSFT_T;
alias XrSceneObserverMSFT = XrSceneObserverMSFT_T*;

struct XrSceneMSFT_T;
alias XrSceneMSFT = XrSceneMSFT_T*;

enum XR_MSFT_scene_understanding_SPEC_VERSION = 1;
enum XR_MSFT_SCENE_UNDERSTANDING_EXTENSION_NAME = "XR_MSFT_scene_understanding";

alias XrSceneComputeFeatureMSFT = uint;
enum: XrSceneComputeFeatureMSFT
{
    XR_SCENE_COMPUTE_FEATURE_PLANE_MSFT = 1,
    XR_SCENE_COMPUTE_FEATURE_PLANE_MESH_MSFT = 2,
    XR_SCENE_COMPUTE_FEATURE_VISUAL_MESH_MSFT = 3,
    XR_SCENE_COMPUTE_FEATURE_COLLIDER_MESH_MSFT = 4,
    XR_SCENE_COMPUTE_FEATURE_SERIALIZE_SCENE_MSFT = 1000098000,
    XR_SCENE_COMPUTE_FEATURE_MAX_ENUM_MSFT = 0x7FFFFFFF
}

alias XrSceneComputeConsistencyMSFT = uint;
enum: XrSceneComputeConsistencyMSFT
{
    XR_SCENE_COMPUTE_CONSISTENCY_SNAPSHOT_COMPLETE_MSFT = 1,
    XR_SCENE_COMPUTE_CONSISTENCY_SNAPSHOT_INCOMPLETE_FAST_MSFT = 2,
    XR_SCENE_COMPUTE_CONSISTENCY_OCCLUSION_OPTIMIZED_MSFT = 3,
    XR_SCENE_COMPUTE_CONSISTENCY_MAX_ENUM_MSFT = 0x7FFFFFFF
}

alias XrMeshComputeLodMSFT = uint;
enum: XrMeshComputeLodMSFT
{
    XR_MESH_COMPUTE_LOD_COARSE_MSFT = 1,
    XR_MESH_COMPUTE_LOD_MEDIUM_MSFT = 2,
    XR_MESH_COMPUTE_LOD_FINE_MSFT = 3,
    XR_MESH_COMPUTE_LOD_UNLIMITED_MSFT = 4,
    XR_MESH_COMPUTE_LOD_MAX_ENUM_MSFT = 0x7FFFFFFF
}

alias XrSceneComponentTypeMSFT = uint;
enum: XrSceneComponentTypeMSFT
{
    XR_SCENE_COMPONENT_TYPE_INVALID_MSFT = -1,
    XR_SCENE_COMPONENT_TYPE_OBJECT_MSFT = 1,
    XR_SCENE_COMPONENT_TYPE_PLANE_MSFT = 2,
    XR_SCENE_COMPONENT_TYPE_VISUAL_MESH_MSFT = 3,
    XR_SCENE_COMPONENT_TYPE_COLLIDER_MESH_MSFT = 4,
    XR_SCENE_COMPONENT_TYPE_SERIALIZED_SCENE_FRAGMENT_MSFT = 1000098000,
    XR_SCENE_COMPONENT_TYPE_MAX_ENUM_MSFT = 0x7FFFFFFF
}

alias XrSceneObjectTypeMSFT = uint;
enum: XrSceneObjectTypeMSFT
{
    XR_SCENE_OBJECT_TYPE_UNCATEGORIZED_MSFT = -1,
    XR_SCENE_OBJECT_TYPE_BACKGROUND_MSFT = 1,
    XR_SCENE_OBJECT_TYPE_WALL_MSFT = 2,
    XR_SCENE_OBJECT_TYPE_FLOOR_MSFT = 3,
    XR_SCENE_OBJECT_TYPE_CEILING_MSFT = 4,
    XR_SCENE_OBJECT_TYPE_PLATFORM_MSFT = 5,
    XR_SCENE_OBJECT_TYPE_INFERRED_MSFT = 6,
    XR_SCENE_OBJECT_TYPE_MAX_ENUM_MSFT = 0x7FFFFFFF
}

alias XrScenePlaneAlignmentTypeMSFT = uint;
enum: XrScenePlaneAlignmentTypeMSFT
{
    XR_SCENE_PLANE_ALIGNMENT_TYPE_NON_ORTHOGONAL_MSFT = 0,
    XR_SCENE_PLANE_ALIGNMENT_TYPE_HORIZONTAL_MSFT = 1,
    XR_SCENE_PLANE_ALIGNMENT_TYPE_VERTICAL_MSFT = 2,
    XR_SCENE_PLANE_ALIGNMENT_TYPE_MAX_ENUM_MSFT = 0x7FFFFFFF
}

alias XrSceneComputeStateMSFT = uint;
enum: XrSceneComputeStateMSFT
{
    XR_SCENE_COMPUTE_STATE_NONE_MSFT = 0,
    XR_SCENE_COMPUTE_STATE_UPDATING_MSFT = 1,
    XR_SCENE_COMPUTE_STATE_COMPLETED_MSFT = 2,
    XR_SCENE_COMPUTE_STATE_COMPLETED_WITH_ERROR_MSFT = 3,
    XR_SCENE_COMPUTE_STATE_MAX_ENUM_MSFT = 0x7FFFFFFF
}

struct XrUuidMSFT
{
    ubyte[16] bytes;
}

struct XrSceneObserverCreateInfoMSFT
{
    XrStructureType type;
    const(void)* next;
}

struct XrSceneCreateInfoMSFT
{
    XrStructureType type;
    const(void)* next;
}

struct XrSceneSphereBoundMSFT
{
    XrVector3f center;
    float radius;
}

struct XrSceneOrientedBoxBoundMSFT
{
    XrPosef pose;
    XrVector3f extents;
}

struct XrSceneFrustumBoundMSFT
{
    XrPosef pose;
    XrFovf fov;
    float farDistance;
}

struct XrSceneBoundsMSFT
{
    XrSpace space;
    XrTime time;
    uint sphereCount;
    const(XrSceneSphereBoundMSFT)* spheres;
    uint boxCount;
    const(XrSceneOrientedBoxBoundMSFT)* boxes;
    uint frustumCount;
    const(XrSceneFrustumBoundMSFT)* frustums;
}

struct XrNewSceneComputeInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    uint requestedFeatureCount;
    const(XrSceneComputeFeatureMSFT)* requestedFeatures;
    XrSceneComputeConsistencyMSFT consistency;
    XrSceneBoundsMSFT bounds;
}

// XrVisualMeshComputeLodInfoMSFT extends XrNewSceneComputeInfoMSFT
struct XrVisualMeshComputeLodInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    XrMeshComputeLodMSFT lod;
}

struct XrSceneComponentMSFT
{
    XrSceneComponentTypeMSFT componentType;
    XrUuidMSFT id;
    XrUuidMSFT parentId;
    XrTime updateTime;
}

struct XrSceneComponentsMSFT
{
    XrStructureType type;
    void* next;
    uint componentCapacityInput;
    uint componentCountOutput;
    XrSceneComponentMSFT* components;
}

struct XrSceneComponentsGetInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    XrSceneComponentTypeMSFT componentType;
}

struct XrSceneComponentLocationMSFT
{
    XrSpaceLocationFlags flags;
    XrPosef pose;
}

struct XrSceneComponentLocationsMSFT
{
    XrStructureType type;
    void* next;
    uint locationCount;
    XrSceneComponentLocationMSFT* locations;
}

struct XrSceneComponentsLocateInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    XrSpace baseSpace;
    XrTime time;
    uint componentIdCount;
    const(XrUuidMSFT)* componentIds;
}

struct XrSceneObjectMSFT
{
    XrSceneObjectTypeMSFT objectType;
}

// XrSceneObjectsMSFT extends XrSceneComponentsMSFT
struct XrSceneObjectsMSFT
{
    XrStructureType type;
    void* next;
    uint sceneObjectCount;
    XrSceneObjectMSFT* sceneObjects;
}

// XrSceneComponentParentFilterInfoMSFT extends XrSceneComponentsGetInfoMSFT
struct XrSceneComponentParentFilterInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    XrUuidMSFT parentId;
}

// XrSceneObjectTypesFilterInfoMSFT extends XrSceneComponentsGetInfoMSFT
struct XrSceneObjectTypesFilterInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    uint objectTypeCount;
    const(XrSceneObjectTypeMSFT)* objectTypes;
}

struct XrScenePlaneMSFT
{
    XrScenePlaneAlignmentTypeMSFT alignment;
    XrExtent2Df size;
    ulong meshBufferId;
    XrBool32 supportsIndicesUint16;
}

// XrScenePlanesMSFT extends XrSceneComponentsMSFT
struct XrScenePlanesMSFT
{
    XrStructureType type;
    void* next;
    uint scenePlaneCount;
    XrScenePlaneMSFT* scenePlanes;
}

// XrScenePlaneAlignmentFilterInfoMSFT extends XrSceneComponentsGetInfoMSFT
struct XrScenePlaneAlignmentFilterInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    uint alignmentCount;
    const(XrScenePlaneAlignmentTypeMSFT)* alignments;
}

struct XrSceneMeshMSFT
{
    ulong meshBufferId;
    XrBool32 supportsIndicesUint16;
}

// XrSceneMeshesMSFT extends XrSceneComponentsMSFT
struct XrSceneMeshesMSFT
{
    XrStructureType type;
    void* next;
    uint sceneMeshCount;
    XrSceneMeshMSFT* sceneMeshes;
}

struct XrSceneMeshBuffersGetInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    ulong meshBufferId;
}

struct XrSceneMeshBuffersMSFT
{
    XrStructureType type;
    void* next;
}

struct XrSceneMeshVertexBufferMSFT
{
    XrStructureType type;
    void* next;
    uint vertexCapacityInput;
    uint vertexCountOutput;
    XrVector3f* vertices;
}

struct XrSceneMeshIndicesUint32MSFT
{
    XrStructureType type;
    void* next;
    uint indexCapacityInput;
    uint indexCountOutput;
    uint* indices;
}

struct XrSceneMeshIndicesUint16MSFT
{
    XrStructureType type;
    void* next;
    uint indexCapacityInput;
    uint indexCountOutput;
    ushort* indices;
}

extern(C)
{
    alias PFN_xrEnumerateSceneComputeFeaturesMSFT = XrResult function(XrInstance instance, XrSystemId systemId, uint featureCapacityInput, uint* featureCountOutput, XrSceneComputeFeatureMSFT* features);
    alias PFN_xrCreateSceneObserverMSFT = XrResult function(XrSession session, const(XrSceneObserverCreateInfoMSFT)* createInfo, XrSceneObserverMSFT* sceneObserver);
    alias PFN_xrDestroySceneObserverMSFT = XrResult function(XrSceneObserverMSFT sceneObserver);
    alias PFN_xrCreateSceneMSFT = XrResult function(XrSceneObserverMSFT sceneObserver, const(XrSceneCreateInfoMSFT)* createInfo, XrSceneMSFT* scene);
    alias PFN_xrDestroySceneMSFT = XrResult function(XrSceneMSFT scene);
    alias PFN_xrComputeNewSceneMSFT = XrResult function(XrSceneObserverMSFT sceneObserver, const(XrNewSceneComputeInfoMSFT)* computeInfo);
    alias PFN_xrGetSceneComputeStateMSFT = XrResult function(XrSceneObserverMSFT sceneObserver, XrSceneComputeStateMSFT* state);
    alias PFN_xrGetSceneComponentsMSFT = XrResult function(XrSceneMSFT scene, const(XrSceneComponentsGetInfoMSFT)* getInfo, XrSceneComponentsMSFT* components);
    alias PFN_xrLocateSceneComponentsMSFT = XrResult function(XrSceneMSFT scene, const(XrSceneComponentsLocateInfoMSFT)* locateInfo, XrSceneComponentLocationsMSFT* locations);
    alias PFN_xrGetSceneMeshBuffersMSFT = XrResult function(XrSceneMSFT scene, const(XrSceneMeshBuffersGetInfoMSFT)* getInfo, XrSceneMeshBuffersMSFT* buffers);
}

/*
 * XR_MSFT_scene_understanding_serialization
 */
enum XR_MSFT_scene_understanding_serialization = 1;
enum XR_MSFT_scene_understanding_serialization_SPEC_VERSION = 1;
enum XR_MSFT_SCENE_UNDERSTANDING_SERIALIZATION_EXTENSION_NAME = "XR_MSFT_scene_understanding_serialization";

struct XrSerializedSceneFragmentDataGetInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    XrUuidMSFT sceneFragmentId;
}

struct XrDeserializeSceneFragmentMSFT
{
    uint bufferSize;
    const(ubyte)* buffer;
}

struct XrSceneDeserializeInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    uint fragmentCount;
    const(XrDeserializeSceneFragmentMSFT)* fragments;
}

extern(C)
{
    alias PFN_xrDeserializeSceneMSFT = XrResult function(XrSceneObserverMSFT sceneObserver, const(XrSceneDeserializeInfoMSFT)* deserializeInfo);
    alias PFN_xrGetSerializedSceneFragmentDataMSFT = XrResult function(XrSceneMSFT scene, const(XrSerializedSceneFragmentDataGetInfoMSFT)* getInfo, uint countInput, uint* readOutput, ubyte* buffer);
}

/*
 * XR_FB_display_refresh_rate
 */
enum XR_FB_display_refresh_rate = 1;
enum XR_FB_display_refresh_rate_SPEC_VERSION = 1;
enum XR_FB_DISPLAY_REFRESH_RATE_EXTENSION_NAME = "XR_FB_display_refresh_rate";

struct XrEventDataDisplayRefreshRateChangedFB
{
    XrStructureType type;
    const(void)* next;
    float fromDisplayRefreshRate;
    float toDisplayRefreshRate;
}

extern(C)
{
    alias PFN_xrEnumerateDisplayRefreshRatesFB = XrResult function(XrSession session, uint displayRefreshRateCapacityInput, uint* displayRefreshRateCountOutput, float* displayRefreshRates);  
    alias PFN_xrGetDisplayRefreshRateFB = XrResult function(XrSession session, float* displayRefreshRate);
    alias PFN_xrRequestDisplayRefreshRateFB = XrResult function(XrSession session, float displayRefreshRate);
}

/*
 * XR_HTC_vive_cosmos_controller_interaction
 */
enum XR_HTC_vive_cosmos_controller_interaction = 1;
enum XR_HTC_vive_cosmos_controller_interaction_SPEC_VERSION = 1;
enum XR_HTC_VIVE_COSMOS_CONTROLLER_INTERACTION_EXTENSION_NAME = "XR_HTC_vive_cosmos_controller_interaction";

/*
 * XR_HTCX_vive_tracker_interaction
 */
enum XR_HTCX_vive_tracker_interaction = 1;
enum XR_HTCX_vive_tracker_interaction_SPEC_VERSION = 1;
enum XR_HTCX_VIVE_TRACKER_INTERACTION_EXTENSION_NAME = "XR_HTCX_vive_tracker_interaction";

struct XrViveTrackerPathsHTCX
{
    XrStructureType type;
    void* next;
    XrPath persistentPath;
    XrPath rolePath;
}

struct XrEventDataViveTrackerConnectedHTCX
{
    XrStructureType type;
    const(void)* next;
    XrViveTrackerPathsHTCX* paths;
}

extern(C)
{
    alias PFN_xrEnumerateViveTrackerPathsHTCX = XrResult function(XrInstance instance, uint pathCapacityInput, uint* pathCountOutput, XrViveTrackerPathsHTCX* paths);
}

/*
 * XR_HTC_facial_tracking
 */
enum XR_HTC_facial_tracking = 1;

enum XR_FACIAL_EXPRESSION_EYE_COUNT_HTC = 14;

enum XR_FACIAL_EXPRESSION_LIP_COUNT_HTC = 37;

struct XrFacialTrackerHTC_T;
alias XrFacialTrackerHTC = XrFacialTrackerHTC_T*;
enum XR_HTC_facial_tracking_SPEC_VERSION = 1;
enum XR_HTC_FACIAL_TRACKING_EXTENSION_NAME = "XR_HTC_facial_tracking";

alias XrEyeExpressionHTC = uint;
enum: XrEyeExpressionHTC
{
    XR_EYE_EXPRESSION_LEFT_BLINK_HTC = 0,
    XR_EYE_EXPRESSION_LEFT_WIDE_HTC = 1,
    XR_EYE_EXPRESSION_RIGHT_BLINK_HTC = 2,
    XR_EYE_EXPRESSION_RIGHT_WIDE_HTC = 3,
    XR_EYE_EXPRESSION_LEFT_SQUEEZE_HTC = 4,
    XR_EYE_EXPRESSION_RIGHT_SQUEEZE_HTC = 5,
    XR_EYE_EXPRESSION_LEFT_DOWN_HTC = 6,
    XR_EYE_EXPRESSION_RIGHT_DOWN_HTC = 7,
    XR_EYE_EXPRESSION_LEFT_OUT_HTC = 8,
    XR_EYE_EXPRESSION_RIGHT_IN_HTC = 9,
    XR_EYE_EXPRESSION_LEFT_IN_HTC = 10,
    XR_EYE_EXPRESSION_RIGHT_OUT_HTC = 11,
    XR_EYE_EXPRESSION_LEFT_UP_HTC = 12,
    XR_EYE_EXPRESSION_RIGHT_UP_HTC = 13,
    XR_EYE_EXPRESSION_MAX_ENUM_HTC = 0x7FFFFFFF
}

alias XrLipExpressionHTC = uint;
enum: XrLipExpressionHTC
{
    XR_LIP_EXPRESSION_JAW_RIGHT_HTC = 0,
    XR_LIP_EXPRESSION_JAW_LEFT_HTC = 1,
    XR_LIP_EXPRESSION_JAW_FORWARD_HTC = 2,
    XR_LIP_EXPRESSION_JAW_OPEN_HTC = 3,
    XR_LIP_EXPRESSION_MOUTH_APE_SHAPE_HTC = 4,
    XR_LIP_EXPRESSION_MOUTH_UPPER_RIGHT_HTC = 5,
    XR_LIP_EXPRESSION_MOUTH_UPPER_LEFT_HTC = 6,
    XR_LIP_EXPRESSION_MOUTH_LOWER_RIGHT_HTC = 7,
    XR_LIP_EXPRESSION_MOUTH_LOWER_LEFT_HTC = 8,
    XR_LIP_EXPRESSION_MOUTH_UPPER_OVERTURN_HTC = 9,
    XR_LIP_EXPRESSION_MOUTH_LOWER_OVERTURN_HTC = 10,
    XR_LIP_EXPRESSION_MOUTH_POUT_HTC = 11,
    XR_LIP_EXPRESSION_MOUTH_SMILE_RIGHT_HTC = 12,
    XR_LIP_EXPRESSION_MOUTH_SMILE_LEFT_HTC = 13,
    XR_LIP_EXPRESSION_MOUTH_SAD_RIGHT_HTC = 14,
    XR_LIP_EXPRESSION_MOUTH_SAD_LEFT_HTC = 15,
    XR_LIP_EXPRESSION_CHEEK_PUFF_RIGHT_HTC = 16,
    XR_LIP_EXPRESSION_CHEEK_PUFF_LEFT_HTC = 17,
    XR_LIP_EXPRESSION_CHEEK_SUCK_HTC = 18,
    XR_LIP_EXPRESSION_MOUTH_UPPER_UPRIGHT_HTC = 19,
    XR_LIP_EXPRESSION_MOUTH_UPPER_UPLEFT_HTC = 20,
    XR_LIP_EXPRESSION_MOUTH_LOWER_DOWNRIGHT_HTC = 21,
    XR_LIP_EXPRESSION_MOUTH_LOWER_DOWNLEFT_HTC = 22,
    XR_LIP_EXPRESSION_MOUTH_UPPER_INSIDE_HTC = 23,
    XR_LIP_EXPRESSION_MOUTH_LOWER_INSIDE_HTC = 24,
    XR_LIP_EXPRESSION_MOUTH_LOWER_OVERLAY_HTC = 25,
    XR_LIP_EXPRESSION_TONGUE_LONGSTEP1_HTC = 26,
    XR_LIP_EXPRESSION_TONGUE_LEFT_HTC = 27,
    XR_LIP_EXPRESSION_TONGUE_RIGHT_HTC = 28,
    XR_LIP_EXPRESSION_TONGUE_UP_HTC = 29,
    XR_LIP_EXPRESSION_TONGUE_DOWN_HTC = 30,
    XR_LIP_EXPRESSION_TONGUE_ROLL_HTC = 31,
    XR_LIP_EXPRESSION_TONGUE_LONGSTEP2_HTC = 32,
    XR_LIP_EXPRESSION_TONGUE_UPRIGHT_MORPH_HTC = 33,
    XR_LIP_EXPRESSION_TONGUE_UPLEFT_MORPH_HTC = 34,
    XR_LIP_EXPRESSION_TONGUE_DOWNRIGHT_MORPH_HTC = 35,
    XR_LIP_EXPRESSION_TONGUE_DOWNLEFT_MORPH_HTC = 36,
    XR_LIP_EXPRESSION_MAX_ENUM_HTC = 0x7FFFFFFF
}

alias XrFacialTrackingTypeHTC = uint;
enum: XrFacialTrackingTypeHTC
{
    XR_FACIAL_TRACKING_TYPE_EYE_DEFAULT_HTC = 1,
    XR_FACIAL_TRACKING_TYPE_LIP_DEFAULT_HTC = 2,
    XR_FACIAL_TRACKING_TYPE_MAX_ENUM_HTC = 0x7FFFFFFF
}

// XrSystemFacialTrackingPropertiesHTC extends XrSystemProperties
struct XrSystemFacialTrackingPropertiesHTC
{
    XrStructureType type;
    void* next;
    XrBool32 supportEyeFacialTracking;
    XrBool32 supportLipFacialTracking;
}

struct XrFacialExpressionsHTC
{
    XrStructureType type;
    const(void)* next;
    XrBool32 isActive;
    XrTime sampleTime;
    uint expressionCount;
    float* expressionWeightings;
}

struct XrFacialTrackerCreateInfoHTC
{
    XrStructureType type;
    const(void)* next;
    XrFacialTrackingTypeHTC facialTrackingType;
}

extern(C)
{
    alias PFN_xrCreateFacialTrackerHTC = XrResult function(XrSession session, const(XrFacialTrackerCreateInfoHTC)* createInfo, XrFacialTrackerHTC* facialTracker);
    alias PFN_xrDestroyFacialTrackerHTC = XrResult function(XrFacialTrackerHTC facialTracker);
    alias PFN_xrGetFacialExpressionsHTC = XrResult function(XrFacialTrackerHTC facialTracker, XrFacialExpressionsHTC* facialExpressions);
}

/*
 * XR_HTC_vive_focus3_controller_interaction
 */
enum XR_HTC_vive_focus3_controller_interaction = 1;
enum XR_HTC_vive_focus3_controller_interaction_SPEC_VERSION = 1;
enum XR_HTC_VIVE_FOCUS3_CONTROLLER_INTERACTION_EXTENSION_NAME = "XR_HTC_vive_focus3_controller_interaction";

/*
 * XR_FB_color_space
 */
enum XR_FB_color_space = 1;
enum XR_FB_color_space_SPEC_VERSION = 2;
enum XR_FB_COLOR_SPACE_EXTENSION_NAME = "XR_FB_color_space";

alias XrColorSpaceFB = uint;
enum: XrColorSpaceFB
{
    XR_COLOR_SPACE_UNMANAGED_FB = 0,
    XR_COLOR_SPACE_REC2020_FB = 1,
    XR_COLOR_SPACE_REC709_FB = 2,
    XR_COLOR_SPACE_RIFT_CV1_FB = 3,
    XR_COLOR_SPACE_RIFT_S_FB = 4,
    XR_COLOR_SPACE_QUEST_FB = 5,
    XR_COLOR_SPACE_P3_FB = 6,
    XR_COLOR_SPACE_ADOBE_RGB_FB = 7,
    XR_COLOR_SPACE_MAX_ENUM_FB = 0x7FFFFFFF
}

// XrSystemColorSpacePropertiesFB extends XrSystemProperties
struct XrSystemColorSpacePropertiesFB
{
    XrStructureType type;
    void* next;
    XrColorSpaceFB colorSpace;
}

extern(C)
{
    alias PFN_xrEnumerateColorSpacesFB = XrResult function(XrSession session, uint colorSpaceCapacityInput, uint* colorSpaceCountOutput, XrColorSpaceFB* colorSpaces);
    alias PFN_xrSetColorSpaceFB = XrResult function(XrSession session, const XrColorSpaceFB colorspace);
}

/*
 * XR_FB_hand_tracking_mesh
 */
enum XR_FB_hand_tracking_mesh = 1;
enum XR_FB_hand_tracking_mesh_SPEC_VERSION = 1;
enum XR_FB_HAND_TRACKING_MESH_EXTENSION_NAME = "XR_FB_hand_tracking_mesh";

struct XrVector4sFB
{
    short x;
    short y;
    short z;
    short w;
}

struct XrHandTrackingMeshFB
{
    XrStructureType type;
    void* next;
    uint jointCapacityInput;
    uint jointCountOutput;
    XrPosef* jointBindPoses;
    float* jointRadii;
    XrHandJointEXT* jointParents;
    uint vertexCapacityInput;
    uint vertexCountOutput;
    XrVector3f* vertexPositions;
    XrVector3f* vertexNormals;
    XrVector2f* vertexUVs;
    XrVector4sFB* vertexBlendIndices;
    XrVector4f* vertexBlendWeights;
    uint indexCapacityInput;
    uint indexCountOutput;
    short* indices;
}

// XrHandTrackingScaleFB extends XrHandJointsLocateInfoEXT
struct XrHandTrackingScaleFB
{
    XrStructureType type;
    void* next;
    float sensorOutput;
    float currentOutput;
    XrBool32 overrideHandScale;
    float overrideValueInput;
}

extern(C)
{
    alias PFN_xrGetHandMeshFB = XrResult function(XrHandTrackerEXT handTracker, XrHandTrackingMeshFB* mesh);
}

/*
 * XR_FB_hand_tracking_aim
 */
enum XR_FB_hand_tracking_aim = 1;
enum XR_FB_hand_tracking_aim_SPEC_VERSION = 1;
enum XR_FB_HAND_TRACKING_AIM_EXTENSION_NAME = "XR_FB_hand_tracking_aim";

alias XrHandTrackingAimFlagsFB = XrFlags64;
enum: XrHandTrackingAimFlagsFB
{
    XR_HAND_TRACKING_AIM_COMPUTED_BIT_FB = 0x00000001,
    XR_HAND_TRACKING_AIM_VALID_BIT_FB = 0x00000002,
    XR_HAND_TRACKING_AIM_INDEX_PINCHING_BIT_FB = 0x00000004,
    XR_HAND_TRACKING_AIM_MIDDLE_PINCHING_BIT_FB = 0x00000008,
    XR_HAND_TRACKING_AIM_RING_PINCHING_BIT_FB = 0x00000010,
    XR_HAND_TRACKING_AIM_LITTLE_PINCHING_BIT_FB = 0x00000020,
    XR_HAND_TRACKING_AIM_SYSTEM_GESTURE_BIT_FB = 0x00000040,
    XR_HAND_TRACKING_AIM_DOMINANT_HAND_BIT_FB = 0x00000080,
    XR_HAND_TRACKING_AIM_MENU_PRESSED_BIT_FB = 0x00000100
}

// XrHandTrackingAimStateFB extends XrHandJointsLocateInfoEXT
struct XrHandTrackingAimStateFB
{
    XrStructureType type;
    void* next;
    XrHandTrackingAimFlagsFB status;
    XrPosef aimPose;
    float pinchStrengthIndex;
    float pinchStrengthMiddle;
    float pinchStrengthRing;
    float pinchStrengthLittle;
}

enum XR_FB_hand_tracking_capsules = 1;
enum XR_HAND_TRACKING_CAPSULE_POINT_COUNT_FB = 2;
enum XR_FB_HAND_TRACKING_CAPSULE_POINT_COUNT = XR_HAND_TRACKING_CAPSULE_POINT_COUNT_FB;
enum XR_HAND_TRACKING_CAPSULE_COUNT_FB = 19;
enum XR_FB_HAND_TRACKING_CAPSULE_COUNT = XR_HAND_TRACKING_CAPSULE_COUNT_FB;
enum XR_FB_hand_tracking_capsules_SPEC_VERSION = 2;
enum XR_FB_HAND_TRACKING_CAPSULES_EXTENSION_NAME = "XR_FB_hand_tracking_capsules";

struct XrHandCapsuleFB
{
    XrVector3f[XR_FB_HAND_TRACKING_CAPSULE_POINT_COUNT] points;
    float radius;
    XrHandJointEXT joint;
}

// XrHandTrackingCapsulesStateFB extends XrHandJointsLocateInfoEXT
struct XrHandTrackingCapsulesStateFB
{
    XrStructureType type;
    void* next;
    XrHandCapsuleFB[XR_FB_HAND_TRACKING_CAPSULE_COUNT] capsules;
}

enum XR_FB_foveation = 1;
struct XrFoveationProfileFB_T;
alias XrFoveationProfileFB = XrFoveationProfileFB_T*;
enum XR_FB_foveation_SPEC_VERSION = 1;
enum XR_FB_FOVEATION_EXTENSION_NAME = "XR_FB_foveation";

alias XrSwapchainCreateFoveationFlagsFB = XrFlags64;
enum: XrSwapchainCreateFoveationFlagsFB
{
    XR_SWAPCHAIN_CREATE_FOVEATION_SCALED_BIN_BIT_FB = 0x00000001,
    XR_SWAPCHAIN_CREATE_FOVEATION_FRAGMENT_DENSITY_MAP_BIT_FB = 0x00000002
}

alias XrSwapchainStateFoveationFlagsFB = XrFlags64;

// Flag bits for XrSwapchainStateFoveationFlagsFB

struct XrFoveationProfileCreateInfoFB
{
    XrStructureType type;
    void* next;
}

// XrSwapchainCreateInfoFoveationFB extends XrSwapchainCreateInfo
struct XrSwapchainCreateInfoFoveationFB
{
    XrStructureType type;
    void* next;
    XrSwapchainCreateFoveationFlagsFB flags;
}

struct XrSwapchainStateFoveationFB
{
    XrStructureType type;
    void* next;
    XrSwapchainStateFoveationFlagsFB flags;
    XrFoveationProfileFB profile;
}

extern(C)
{
    alias PFN_xrCreateFoveationProfileFB = XrResult function(XrSession session, const(XrFoveationProfileCreateInfoFB)* createInfo, XrFoveationProfileFB* profile);
    alias PFN_xrDestroyFoveationProfileFB = XrResult function(XrFoveationProfileFB profile);
}

/*
 * XR_FB_foveation_configuration
 */
enum XR_FB_foveation_configuration = 1;
enum XR_FB_foveation_configuration_SPEC_VERSION = 1;
enum XR_FB_FOVEATION_CONFIGURATION_EXTENSION_NAME = "XR_FB_foveation_configuration";

alias XrFoveationLevelFB = uint;
enum: XrFoveationLevelFB
{
    XR_FOVEATION_LEVEL_NONE_FB = 0,
    XR_FOVEATION_LEVEL_LOW_FB = 1,
    XR_FOVEATION_LEVEL_MEDIUM_FB = 2,
    XR_FOVEATION_LEVEL_HIGH_FB = 3,
    XR_FOVEATION_LEVEL_MAX_ENUM_FB = 0x7FFFFFFF
}

alias XrFoveationDynamicFB = uint;
enum: XrFoveationDynamicFB
{
    XR_FOVEATION_DYNAMIC_DISABLED_FB = 0,
    XR_FOVEATION_DYNAMIC_LEVEL_ENABLED_FB = 1,
    XR_FOVEATION_DYNAMIC_MAX_ENUM_FB = 0x7FFFFFFF
}

// XrFoveationLevelProfileCreateInfoFB extends XrFoveationProfileCreateInfoFB
struct XrFoveationLevelProfileCreateInfoFB
{
    XrStructureType type;
    void* next;
    XrFoveationLevelFB level;
    float verticalOffset;
    XrFoveationDynamicFB dynamic;
}

/*
 * XR_FB_keyboard_tracking
 */
enum XR_FB_keyboard_tracking = 1;
enum XR_FB_keyboard_tracking_SPEC_VERSION = 1;
enum XR_FB_KEYBOARD_TRACKING_EXTENSION_NAME = "XR_FB_keyboard_tracking";
enum XR_MAX_KEYBOARD_TRACKING_NAME_SIZE_FB = 128;

alias XrKeyboardTrackingFlagsFB = XrFlags64;
enum: XrKeyboardTrackingFlagsFB
{
    XR_KEYBOARD_TRACKING_EXISTS_BIT_FB = 0x00000001,
    XR_KEYBOARD_TRACKING_LOCAL_BIT_FB = 0x00000002,
    XR_KEYBOARD_TRACKING_REMOTE_BIT_FB = 0x00000004,
    XR_KEYBOARD_TRACKING_CONNECTED_BIT_FB = 0x00000008
}

alias XrKeyboardTrackingQueryFlagsFB = XrFlags64;
enum: XrKeyboardTrackingQueryFlagsFB
{
    XR_KEYBOARD_TRACKING_QUERY_LOCAL_BIT_FB = 0x00000002,
    XR_KEYBOARD_TRACKING_QUERY_REMOTE_BIT_FB = 0x00000004
}

// XrSystemKeyboardTrackingPropertiesFB extends XrSystemProperties
struct XrSystemKeyboardTrackingPropertiesFB
{
    XrStructureType type;
    void* next;
    XrBool32 supportsKeyboardTracking;
}

struct XrKeyboardTrackingDescriptionFB
{
    ulong trackedKeyboardId;
    XrVector3f size;
    XrKeyboardTrackingFlagsFB flags;
    char[XR_MAX_KEYBOARD_TRACKING_NAME_SIZE_FB] name;
}

struct XrKeyboardSpaceCreateInfoFB
{
    XrStructureType type;
    void* next;
    ulong trackedKeyboardId;
}

struct XrKeyboardTrackingQueryFB
{
    XrStructureType type;
    void* next;
    XrKeyboardTrackingQueryFlagsFB flags;
}

extern(C)
{
    alias PFN_xrQuerySystemTrackedKeyboardFB = XrResult function(XrSession session, const(XrKeyboardTrackingQueryFB)* queryInfo, XrKeyboardTrackingDescriptionFB* keyboard);
    alias PFN_xrCreateKeyboardSpaceFB = XrResult function(XrSession session, const(XrKeyboardSpaceCreateInfoFB)* createInfo, XrSpace* keyboardSpace);
}

/*
 * XR_FB_triangle_mesh
 */
enum XR_FB_triangle_mesh = 1;
struct XrTriangleMeshFB_T;
alias XrTriangleMeshFB = XrTriangleMeshFB_T*;
enum XR_FB_triangle_mesh_SPEC_VERSION = 1;
enum XR_FB_TRIANGLE_MESH_EXTENSION_NAME = "XR_FB_triangle_mesh";

enum XrWindingOrderFB
{
    XR_WINDING_ORDER_UNKNOWN_FB = 0,
    XR_WINDING_ORDER_CW_FB = 1,
    XR_WINDING_ORDER_CCW_FB = 2,
    XR_WINDING_ORDER_MAX_ENUM_FB = 0x7FFFFFFF
}

alias XrTriangleMeshFlagsFB = XrFlags64;
enum: XrTriangleMeshFlagsFB
{
    XR_TRIANGLE_MESH_MUTABLE_BIT_FB = 0x00000001
}

struct XrTriangleMeshCreateInfoFB
{
    XrStructureType type;
    const(void)* next;
    XrTriangleMeshFlagsFB flags;
    XrWindingOrderFB windingOrder;
    uint vertexCount;
    const(XrVector3f)* vertexBuffer;
    uint triangleCount;
    const(uint)* indexBuffer;
}

extern(C)
{
    alias PFN_xrCreateTriangleMeshFB = XrResult function(XrSession session, const(XrTriangleMeshCreateInfoFB)* createInfo, XrTriangleMeshFB* outTriangleMesh);
    alias PFN_xrDestroyTriangleMeshFB = XrResult function(XrTriangleMeshFB mesh);
    alias PFN_xrTriangleMeshGetVertexBufferFB = XrResult function(XrTriangleMeshFB mesh, XrVector3f** outVertexBuffer);
    alias PFN_xrTriangleMeshGetIndexBufferFB = XrResult function(XrTriangleMeshFB mesh, uint** outIndexBuffer);
    alias PFN_xrTriangleMeshBeginUpdateFB = XrResult function(XrTriangleMeshFB mesh);
    alias PFN_xrTriangleMeshEndUpdateFB = XrResult function(XrTriangleMeshFB mesh, uint vertexCount, uint triangleCount);
    alias PFN_xrTriangleMeshBeginVertexBufferUpdateFB = XrResult function(XrTriangleMeshFB mesh, uint* outVertexCount);
    alias PFN_xrTriangleMeshEndVertexBufferUpdateFB = XrResult function(XrTriangleMeshFB mesh);
}

enum XR_FB_passthrough = 1;
struct XrPassthroughFB_T;
alias XrPassthroughFB = XrPassthroughFB_T*;
struct XrPassthroughLayerFB_T;
alias XrPassthroughLayerFB = XrPassthroughLayerFB_T*;
struct XrGeometryInstanceFB_T;
alias XrGeometryInstanceFB = XrGeometryInstanceFB_T*;
enum XR_FB_passthrough_SPEC_VERSION = 1;
enum XR_FB_PASSTHROUGH_EXTENSION_NAME = "XR_FB_passthrough";
enum XR_PASSTHROUGH_COLOR_MAP_MONO_SIZE_FB = 256;

alias XrPassthroughLayerPurposeFB = uint;
enum: XrPassthroughLayerPurposeFB
{
    XR_PASSTHROUGH_LAYER_PURPOSE_RECONSTRUCTION_FB = 0,
    XR_PASSTHROUGH_LAYER_PURPOSE_PROJECTED_FB = 1,
    XR_PASSTHROUGH_LAYER_PURPOSE_TRACKED_KEYBOARD_HANDS_FB = 1000203001,
    XR_PASSTHROUGH_LAYER_PURPOSE_MAX_ENUM_FB = 0x7FFFFFFF
}

alias XrPassthroughFlagsFB = XrFlags64;
enum: XrPassthroughFlagsFB
{
    XR_PASSTHROUGH_IS_RUNNING_AT_CREATION_BIT_FB = 0x00000001
}

alias XrPassthroughStateChangedFlagsFB = XrFlags64;
enum: XrPassthroughFlagsFB
{
    XR_PASSTHROUGH_STATE_CHANGED_REINIT_REQUIRED_BIT_FB = 0x00000001,
    XR_PASSTHROUGH_STATE_CHANGED_NON_RECOVERABLE_ERROR_BIT_FB = 0x00000002,
    XR_PASSTHROUGH_STATE_CHANGED_RECOVERABLE_ERROR_BIT_FB = 0x00000004,
    XR_PASSTHROUGH_STATE_CHANGED_RESTORED_ERROR_BIT_FB = 0x00000008
}

// XrSystemPassthroughPropertiesFB extends XrSystemProperties
struct XrSystemPassthroughPropertiesFB
{
    XrStructureType type;
    const(void)* next;
    XrBool32 supportsPassthrough;
}

struct XrPassthroughCreateInfoFB
{
    XrStructureType type;
    const(void)* next;
    XrPassthroughFlagsFB flags;
}

struct XrPassthroughLayerCreateInfoFB
{
    XrStructureType type;
    const(void)* next;
    XrPassthroughFB passthrough;
    XrPassthroughFlagsFB flags;
    XrPassthroughLayerPurposeFB purpose;
}

// XrCompositionLayerPassthroughFB extends XrCompositionLayerBaseHeader
struct XrCompositionLayerPassthroughFB
{
    XrStructureType type;
    const(void)* next;
    XrCompositionLayerFlags flags;
    XrSpace space;
    XrPassthroughLayerFB layerHandle;
}

struct XrGeometryInstanceCreateInfoFB
{
    XrStructureType type;
    const(void)* next;
    XrPassthroughLayerFB layer;
    XrTriangleMeshFB mesh;
    XrSpace baseSpace;
    XrPosef pose;
    XrVector3f scale;
}

struct XrGeometryInstanceTransformFB
{
    XrStructureType type;
    const(void)* next;
    XrSpace baseSpace;
    XrTime time;
    XrPosef pose;
    XrVector3f scale;
}

struct XrPassthroughStyleFB
{
    XrStructureType type;
    const(void)* next;
    float textureOpacityFactor;
    XrColor4f edgeColor;
}

struct XrPassthroughColorMapMonoToRgbaFB
{
    XrStructureType type;
    const(void)* next;
    XrColor4f[XR_PASSTHROUGH_COLOR_MAP_MONO_SIZE_FB] textureColorMap;
}

struct XrPassthroughColorMapMonoToMonoFB
{
    XrStructureType type;
    const(void)* next;
    ubyte[XR_PASSTHROUGH_COLOR_MAP_MONO_SIZE_FB] textureColorMap;
}

struct XrEventDataPassthroughStateChangedFB
{
    XrStructureType type;
    const(void)* next;
    XrPassthroughStateChangedFlagsFB flags;
}

extern(C)
{
    alias PFN_xrCreatePassthroughFB = XrResult function(XrSession session, const(XrPassthroughCreateInfoFB)* createInfo, XrPassthroughFB* outPassthrough);
    alias PFN_xrDestroyPassthroughFB = XrResult function(XrPassthroughFB passthrough);
    alias PFN_xrPassthroughStartFB = XrResult function(XrPassthroughFB passthrough);
    alias PFN_xrPassthroughPauseFB = XrResult function(XrPassthroughFB passthrough);
    alias PFN_xrCreatePassthroughLayerFB = XrResult function(XrSession session, const(XrPassthroughLayerCreateInfoFB)* createInfo, XrPassthroughLayerFB* outLayer);
    alias PFN_xrDestroyPassthroughLayerFB = XrResult function(XrPassthroughLayerFB layer);
    alias PFN_xrPassthroughLayerPauseFB = XrResult function(XrPassthroughLayerFB layer);
    alias PFN_xrPassthroughLayerResumeFB = XrResult function(XrPassthroughLayerFB layer);
    alias PFN_xrPassthroughLayerSetStyleFB = XrResult function(XrPassthroughLayerFB layer, const(XrPassthroughStyleFB)* style);
    alias PFN_xrCreateGeometryInstanceFB = XrResult function(XrSession session, const(XrGeometryInstanceCreateInfoFB)* createInfo, XrGeometryInstanceFB* outGeometryInstance);
    alias PFN_xrDestroyGeometryInstanceFB = XrResult function(XrGeometryInstanceFB instance);
    alias PFN_xrGeometryInstanceSetTransformFB = XrResult function(XrGeometryInstanceFB instance, const(XrGeometryInstanceTransformFB)* transformation);
}

/*
 * XR_FB_render_model
 */
enum XR_FB_render_model = 1;

enum XR_NULL_RENDER_MODEL_KEY_FB = 0;

alias XrRenderModelKeyFB = ulong;
enum XR_FB_render_model_SPEC_VERSION = 1;
enum XR_FB_RENDER_MODEL_EXTENSION_NAME = "XR_FB_render_model";
enum XR_MAX_RENDER_MODEL_NAME_SIZE_FB = 64;
alias XrRenderModelFlagsFB = ulong;

// Flag bits for XrRenderModelFlagsFB

struct XrRenderModelPathInfoFB
{
    XrStructureType type;
    void* next;
    XrPath path;
}

struct XrRenderModelPropertiesFB
{
    XrStructureType type;
    void* next;
    uint vendorId;
    char[XR_MAX_RENDER_MODEL_NAME_SIZE_FB] modelName;
    XrRenderModelKeyFB modelKey;
    uint modelVersion;
    XrRenderModelFlagsFB flags;
}

struct XrRenderModelBufferFB
{
    XrStructureType type;
    void* next;
    uint bufferCapacityInput;
    uint bufferCountOutput;
    ubyte* buffer;
}

struct XrRenderModelLoadInfoFB
{
    XrStructureType type;
    void* next;
    XrRenderModelKeyFB modelKey;
}

// XrSystemRenderModelPropertiesFB extends XrSystemProperties
struct XrSystemRenderModelPropertiesFB
{
    XrStructureType type;
    void* next;
    XrBool32 supportsRenderModelLoading;
}

extern(C)
{
    alias PFN_xrEnumerateRenderModelPathsFB = XrResult function(XrSession session, uint pathCapacityInput, uint* pathCountOutput, XrRenderModelPathInfoFB* paths);
    alias PFN_xrGetRenderModelPropertiesFB = XrResult function(XrSession session, XrPath path, XrRenderModelPropertiesFB* properties);
    alias PFN_xrLoadRenderModelFB = XrResult function(XrSession session, const(XrRenderModelLoadInfoFB)* info, XrRenderModelBufferFB* buffer);
}

/*
 * XR_VARJO_foveated_rendering
 */
enum XR_VARJO_foveated_rendering = 1;
enum XR_VARJO_foveated_rendering_SPEC_VERSION = 2;
enum XR_VARJO_FOVEATED_RENDERING_EXTENSION_NAME = "XR_VARJO_foveated_rendering";
// XrViewLocateFoveatedRenderingVARJO extends XrViewLocateInfo
struct XrViewLocateFoveatedRenderingVARJO
{
    XrStructureType type;
    const(void)* next;
    XrBool32 foveatedRenderingActive;
}

// XrFoveatedViewConfigurationViewVARJO extends XrViewConfigurationView
struct XrFoveatedViewConfigurationViewVARJO
{
    XrStructureType type;
    void* next;
    XrBool32 foveatedRenderingActive;
}

// XrSystemFoveatedRenderingPropertiesVARJO extends XrSystemProperties
struct XrSystemFoveatedRenderingPropertiesVARJO
{
    XrStructureType type;
    void* next;
    XrBool32 supportsFoveatedRendering;
}

/*
 * XR_VARJO_composition_layer_depth_test
 */
enum XR_VARJO_composition_layer_depth_test = 1;
enum XR_VARJO_composition_layer_depth_test_SPEC_VERSION = 2;
enum XR_VARJO_COMPOSITION_LAYER_DEPTH_TEST_EXTENSION_NAME = "XR_VARJO_composition_layer_depth_test";
// XrCompositionLayerDepthTestVARJO extends XrCompositionLayerProjection
struct XrCompositionLayerDepthTestVARJO
{
    XrStructureType type;
    const(void)* next;
    float depthTestRangeNearZ;
    float depthTestRangeFarZ;
}

/*
 * XR_VARJO_environment_depth_estimation
 */
enum XR_VARJO_environment_depth_estimation = 1;
enum XR_VARJO_environment_depth_estimation_SPEC_VERSION = 1;
enum XR_VARJO_ENVIRONMENT_DEPTH_ESTIMATION_EXTENSION_NAME = "XR_VARJO_environment_depth_estimation";

extern(C)
{
    alias PFN_xrSetEnvironmentDepthEstimationVARJO = XrResult function(XrSession session, XrBool32 enabled);
}

/*
 * XR_VARJO_marker_tracking
 */
enum XR_VARJO_marker_tracking = 1;
enum XR_VARJO_marker_tracking_SPEC_VERSION = 1;
enum XR_VARJO_MARKER_TRACKING_EXTENSION_NAME = "XR_VARJO_marker_tracking";
// XrSystemMarkerTrackingPropertiesVARJO extends XrSystemProperties
struct XrSystemMarkerTrackingPropertiesVARJO
{
    XrStructureType type;
    void* next;
    XrBool32 supportsMarkerTracking;
}

struct XrEventDataMarkerTrackingUpdateVARJO
{
    XrStructureType type;
    const(void)* next;
    ulong markerId;
    XrBool32 isActive;
    XrBool32 isPredicted;
    XrTime time;
}

struct XrMarkerSpaceCreateInfoVARJO
{
    XrStructureType type;
    const(void)* next;
    ulong markerId;
    XrPosef poseInMarkerSpace;
}

extern(C)
{
    alias PFN_xrSetMarkerTrackingVARJO = XrResult function(XrSession session, XrBool32 enabled);
    alias PFN_xrSetMarkerTrackingTimeoutVARJO = XrResult function(XrSession session, ulong markerId, XrDuration timeout);
    alias PFN_xrSetMarkerTrackingPredictionVARJO = XrResult function(XrSession session, ulong markerId, XrBool32 enabled);
    alias PFN_xrGetMarkerSizeVARJO = XrResult function(XrSession session, ulong markerId, XrExtent2Df* size);
    alias PFN_xrCreateMarkerSpaceVARJO = XrResult function(XrSession session, const(XrMarkerSpaceCreateInfoVARJO)* createInfo, XrSpace* space);
}

/*
 * XR_MSFT_spatial_anchor_persistence
 */
enum XR_MSFT_spatial_anchor_persistence = 1;
struct XrSpatialAnchorStoreConnectionMSFT_T;
alias XrSpatialAnchorStoreConnectionMSFT = XrSpatialAnchorStoreConnectionMSFT_T*;
enum XR_MAX_SPATIAL_ANCHOR_NAME_SIZE_MSFT = 256;
enum XR_MSFT_spatial_anchor_persistence_SPEC_VERSION = 2;
enum XR_MSFT_SPATIAL_ANCHOR_PERSISTENCE_EXTENSION_NAME = "XR_MSFT_spatial_anchor_persistence";

struct XrSpatialAnchorPersistenceNameMSFT
{
    char[XR_MAX_SPATIAL_ANCHOR_NAME_SIZE_MSFT] name;
}

struct XrSpatialAnchorPersistenceInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    XrSpatialAnchorPersistenceNameMSFT spatialAnchorPersistenceName;
    XrSpatialAnchorMSFT spatialAnchor;
}

struct XrSpatialAnchorFromPersistedAnchorCreateInfoMSFT
{
    XrStructureType type;
    const(void)* next;
    XrSpatialAnchorStoreConnectionMSFT spatialAnchorStore;
    XrSpatialAnchorPersistenceNameMSFT spatialAnchorPersistenceName;
}

extern(C)
{
    alias PFN_xrCreateSpatialAnchorStoreConnectionMSFT = XrResult function(XrSession session, XrSpatialAnchorStoreConnectionMSFT* spatialAnchorStore);
    alias PFN_xrDestroySpatialAnchorStoreConnectionMSFT = XrResult function(XrSpatialAnchorStoreConnectionMSFT spatialAnchorStore);
    alias PFN_xrPersistSpatialAnchorMSFT = XrResult function(XrSpatialAnchorStoreConnectionMSFT spatialAnchorStore, const(XrSpatialAnchorPersistenceInfoMSFT)* spatialAnchorPersistenceInfo);
    alias PFN_xrEnumeratePersistedSpatialAnchorNamesMSFT = XrResult function(XrSpatialAnchorStoreConnectionMSFT spatialAnchorStore, uint spatialAnchorNamesCapacityInput, uint* spatialAnchorNamesCountOutput, XrSpatialAnchorPersistenceNameMSFT* persistedAnchorNames);
    alias PFN_xrCreateSpatialAnchorFromPersistedNameMSFT = XrResult function(XrSession session, const(XrSpatialAnchorFromPersistedAnchorCreateInfoMSFT)* spatialAnchorCreateInfo, XrSpatialAnchorMSFT* spatialAnchor);
    alias PFN_xrUnpersistSpatialAnchorMSFT = XrResult function(XrSpatialAnchorStoreConnectionMSFT spatialAnchorStore, const(XrSpatialAnchorPersistenceNameMSFT)* spatialAnchorPersistenceName);
    alias PFN_xrClearSpatialAnchorStoreMSFT = XrResult function(XrSpatialAnchorStoreConnectionMSFT spatialAnchorStore);
}

/*
 * XR_FB_space_warp
 */
enum XR_FB_space_warp = 1;
enum XR_FB_space_warp_SPEC_VERSION = 1;
enum XR_FB_SPACE_WARP_EXTENSION_NAME = "XR_FB_space_warp";
alias XrCompositionLayerSpaceWarpInfoFlagsFB = XrFlags64;

// Flag bits for XrCompositionLayerSpaceWarpInfoFlagsFB

// XrCompositionLayerSpaceWarpInfoFB extends XrCompositionLayerProjectionView
struct XrCompositionLayerSpaceWarpInfoFB
{
    XrStructureType type;
    const(void)* next;
    XrCompositionLayerSpaceWarpInfoFlagsFB layerFlags;
    XrSwapchainSubImage motionVectorSubImage;
    XrPosef appSpaceDeltaPose;
    XrSwapchainSubImage depthSubImage;
    float minDepth;
    float maxDepth;
    float nearZ;
    float farZ;
}

// XrSystemSpaceWarpPropertiesFB extends XrSystemProperties
struct XrSystemSpaceWarpPropertiesFB
{
    XrStructureType type;
    void* next;
    uint recommendedMotionVectorImageRectWidth;
    uint recommendedMotionVectorImageRectHeight;
}

/*
 * XR_ALMALENCE_digital_lens_control
 */
enum XR_ALMALENCE_digital_lens_control = 1;
enum XR_ALMALENCE_digital_lens_control_SPEC_VERSION = 1;
enum XR_ALMALENCE_DIGITAL_LENS_CONTROL_EXTENSION_NAME = "XR_ALMALENCE_digital_lens_control";
alias XrDigitalLensControlFlagsALMALENCE = XrFlags64;
enum: XrDigitalLensControlFlagsALMALENCE
{
    XR_DIGITAL_LENS_CONTROL_PROCESSING_DISABLE_BIT_ALMALENCE = 0x00000001
}

struct XrDigitalLensControlALMALENCE
{
    XrStructureType type;
    const(void)* next;
    XrDigitalLensControlFlagsALMALENCE flags;
}

extern(C)
{
    alias PFN_xrSetDigitalLensControlALMALENCE = XrResult function(XrSession session, const(XrDigitalLensControlALMALENCE)* digitalLensControl);
}

/*
 * XR_FB_passthrough_keyboard_hands
 */
enum XR_FB_passthrough_keyboard_hands = 1;
enum XR_FB_passthrough_keyboard_hands_SPEC_VERSION = 1;
enum XR_FB_PASSTHROUGH_KEYBOARD_HANDS_EXTENSION_NAME = "XR_FB_passthrough_keyboard_hands";

struct XrPassthroughKeyboardHandsIntensityFB
{
    XrStructureType type;
    const(void)* next;
    float leftHandIntensity;
    float rightHandIntensity;
}

extern(C)
{
    alias PFN_xrPassthroughLayerSetKeyboardHandsIntensityFB = XrResult function(XrPassthroughLayerFB layer, const(XrPassthroughKeyboardHandsIntensityFB)* intensity);
}

/*
 * XR_EXT_uuid
 */
enum XR_EXT_uuid = 1;
enum XR_EXT_uuid_SPEC_VERSION = 1;
enum XR_EXT_UUID_EXTENSION_NAME = "XR_EXT_uuid";
enum XR_UUID_SIZE_EXT = 16;

struct XrUuidEXT
{
    ubyte[XR_UUID_SIZE_EXT] data;
}

/*
 * XR_KHR_opengl_enable
 */
enum XR_KHR_opengl_enable = 1;
enum XR_KHR_opengl_enable_SPEC_VERSION = 12;
enum XR_KHR_OPENGL_ENABLE_EXTENSION_NAME = "XR_KHR_opengl_enable";
