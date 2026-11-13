/*
 * Copyright (c) 2017-2022, The Khronos Group Inc.
 *
 * SPDX-License-Identifier: Apache-2.0 OR MIT
 */

/**
 * OpenXR type definitions.
 * Based on the reworked OpenXR-D project
 * https://github.com/infinityplusb/OpenXR-D
 */
module bindbc.openxr.types;

import dlib.math.vector;
import dlib.math.quaternion;
import dlib.image.color;

enum XR_VERSION_1_0 = 1;

auto XR_MAKE_VERSION(T0, T1, T2)(auto ref T0 major, auto ref T1 minor, auto ref T2 patch)
{
    return ((cast(ulong)major & 0xFFFFUL) << 48) | 
           ((cast(ulong)minor & 0xFFFFUL) << 32) | 
            (cast(ulong)patch & 0xFFFFFFFFUL);
}

enum ulong XR_CURRENT_API_VERSION = XR_MAKE_VERSION(1, 0, 22);

auto XR_VERSION_MAJOR(T)(auto ref T _version)
{
    return cast(ushort)((_version >> 48) & 0xFFFF);
}

auto XR_VERSION_MINOR(T)(auto ref T _version)
{
    return cast(ushort)((_version >> 32) & 0xFFFF);
}

 auto XR_VERSION_PATCH(T)(auto ref T _version)
{
    return cast(uint)(_version & 0xFFFFFFFF);
}

enum XR_NULL_HANDLE = 0;
enum XR_NULL_SYSTEM_ID = 0;
enum XR_NULL_PATH = 0;

auto XR_SUCCEEDED(T)(auto ref T result)
{
    return result >= 0;
}

auto XR_FAILED(T)(auto ref T result)
{
    return result < 0;
}

auto XR_UNQUALIFIED_SUCCESS(T)(auto ref T result)
{
    return result == 0;
}

enum XR_NO_DURATION = 0;
enum XR_INFINITE_DURATION = 1_000_000_000_000_000; // 0x7fffffffffffffffLL;
enum XR_MIN_HAPTIC_DURATION = -1;
enum XR_FREQUENCY_UNSPECIFIED = 0;
enum XR_MAX_EVENT_DATA_SIZE = XrEventDataBuffer.sizeof;

alias XrVersion = ulong;
alias XrFlags64 = ulong;
alias XrSystemId = ulong;
alias XrBool32 = uint;
alias XrPath = ulong;
alias XrTime = long;
alias XrDuration = long;
struct XrInstance_T;
alias XrInstance = XrInstance_T*;
struct XrSession_T;
alias XrSession = XrSession_T*;
struct XrSpace_T;
alias XrSpace = XrSpace_T*;
struct XrAction_T;
alias XrAction = XrAction_T*;
struct XrSwapchain_T;
alias XrSwapchain = XrSwapchain_T*;
struct XrActionSet_T;
alias XrActionSet = XrActionSet_T*;

enum XR_TRUE = 1;
enum XR_FALSE = 0;

enum XR_MAX_EXTENSION_NAME_SIZE = 128;
enum XR_MAX_API_LAYER_NAME_SIZE = 256;
enum XR_MAX_API_LAYER_DESCRIPTION_SIZE = 256;
enum XR_MAX_SYSTEM_NAME_SIZE = 256;
enum XR_MAX_APPLICATION_NAME_SIZE = 128;
enum XR_MAX_ENGINE_NAME_SIZE = 128;
enum XR_MAX_RUNTIME_NAME_SIZE = 128;
enum XR_MAX_PATH_LENGTH = 256;
enum XR_MAX_STRUCTURE_NAME_SIZE = 64;
enum XR_MAX_RESULT_STRING_SIZE = 64;
enum XR_MIN_COMPOSITION_LAYERS_SUPPORTED = 16;
enum XR_MAX_ACTION_SET_NAME_SIZE = 64;
enum XR_MAX_LOCALIZED_ACTION_SET_NAME_SIZE = 128;
enum XR_MAX_ACTION_NAME_SIZE = 64;
enum XR_MAX_LOCALIZED_ACTION_NAME_SIZE = 128;

alias XrResult = int;
enum: XrResult
{
    XR_SUCCESS = 0,
    XR_TIMEOUT_EXPIRED = 1,
    XR_SESSION_LOSS_PENDING = 3,
    XR_EVENT_UNAVAILABLE = 4,
    XR_SPACE_BOUNDS_UNAVAILABLE = 7,
    XR_SESSION_NOT_FOCUSED = 8,
    XR_FRAME_DISCARDED = 9,
    XR_ERROR_VALIDATION_FAILURE = -1,
    XR_ERROR_RUNTIME_FAILURE = -2,
    XR_ERROR_OUT_OF_MEMORY = -3,
    XR_ERROR_API_VERSION_UNSUPPORTED = -4,
    XR_ERROR_INITIALIZATION_FAILED = -6,
    XR_ERROR_FUNCTION_UNSUPPORTED = -7,
    XR_ERROR_FEATURE_UNSUPPORTED = -8,
    XR_ERROR_EXTENSION_NOT_PRESENT = -9,
    XR_ERROR_LIMIT_REACHED = -10,
    XR_ERROR_SIZE_INSUFFICIENT = -11,
    XR_ERROR_HANDLE_INVALID = -12,
    XR_ERROR_INSTANCE_LOST = -13,
    XR_ERROR_SESSION_RUNNING = -14,
    XR_ERROR_SESSION_NOT_RUNNING = -16,
    XR_ERROR_SESSION_LOST = -17,
    XR_ERROR_SYSTEM_INVALID = -18,
    XR_ERROR_PATH_INVALID = -19,
    XR_ERROR_PATH_COUNT_EXCEEDED = -20,
    XR_ERROR_PATH_FORMAT_INVALID = -21,
    XR_ERROR_PATH_UNSUPPORTED = -22,
    XR_ERROR_LAYER_INVALID = -23,
    XR_ERROR_LAYER_LIMIT_EXCEEDED = -24,
    XR_ERROR_SWAPCHAIN_RECT_INVALID = -25,
    XR_ERROR_SWAPCHAIN_FORMAT_UNSUPPORTED = -26,
    XR_ERROR_ACTION_TYPE_MISMATCH = -27,
    XR_ERROR_SESSION_NOT_READY = -28,
    XR_ERROR_SESSION_NOT_STOPPING = -29,
    XR_ERROR_TIME_INVALID = -30,
    XR_ERROR_REFERENCE_SPACE_UNSUPPORTED = -31,
    XR_ERROR_FILE_ACCESS_ERROR = -32,
    XR_ERROR_FILE_CONTENTS_INVALID = -33,
    XR_ERROR_FORM_FACTOR_UNSUPPORTED = -34,
    XR_ERROR_FORM_FACTOR_UNAVAILABLE = -35,
    XR_ERROR_API_LAYER_NOT_PRESENT = -36,
    XR_ERROR_CALL_ORDER_INVALID = -37,
    XR_ERROR_GRAPHICS_DEVICE_INVALID = -38,
    XR_ERROR_POSE_INVALID = -39,
    XR_ERROR_INDEX_OUT_OF_RANGE = -40,
    XR_ERROR_VIEW_CONFIGURATION_TYPE_UNSUPPORTED = -41,
    XR_ERROR_ENVIRONMENT_BLEND_MODE_UNSUPPORTED = -42,
    XR_ERROR_NAME_DUPLICATED = -44,
    XR_ERROR_NAME_INVALID = -45,
    XR_ERROR_ACTIONSET_NOT_ATTACHED = -46,
    XR_ERROR_ACTIONSETS_ALREADY_ATTACHED = -47,
    XR_ERROR_LOCALIZED_NAME_DUPLICATED = -48,
    XR_ERROR_LOCALIZED_NAME_INVALID = -49,
    XR_ERROR_GRAPHICS_REQUIREMENTS_CALL_MISSING = -50,
    XR_ERROR_RUNTIME_UNAVAILABLE = -51,
    XR_ERROR_ANDROID_THREAD_SETTINGS_ID_INVALID_KHR = -1000003000,
    XR_ERROR_ANDROID_THREAD_SETTINGS_FAILURE_KHR = -1000003001,
    XR_ERROR_CREATE_SPATIAL_ANCHOR_FAILED_MSFT = -1000039001,
    XR_ERROR_SECONDARY_VIEW_CONFIGURATION_TYPE_NOT_ENABLED_MSFT = -1000053000,
    XR_ERROR_CONTROLLER_MODEL_KEY_INVALID_MSFT = -1000055000,
    XR_ERROR_REPROJECTION_MODE_UNSUPPORTED_MSFT = -1000066000,
    XR_ERROR_COMPUTE_NEW_SCENE_NOT_COMPLETED_MSFT = -1000097000,
    XR_ERROR_SCENE_COMPONENT_ID_INVALID_MSFT = -1000097001,
    XR_ERROR_SCENE_COMPONENT_TYPE_MISMATCH_MSFT = -1000097002,
    XR_ERROR_SCENE_MESH_BUFFER_ID_INVALID_MSFT = -1000097003,
    XR_ERROR_SCENE_COMPUTE_FEATURE_INCOMPATIBLE_MSFT = -1000097004,
    XR_ERROR_SCENE_COMPUTE_CONSISTENCY_MISMATCH_MSFT = -1000097005,
    XR_ERROR_DISPLAY_REFRESH_RATE_UNSUPPORTED_FB = -1000101000,
    XR_ERROR_COLOR_SPACE_UNSUPPORTED_FB = -1000108000,
    XR_ERROR_UNEXPECTED_STATE_PASSTHROUGH_FB = -1000118000,
    XR_ERROR_FEATURE_ALREADY_CREATED_PASSTHROUGH_FB = -1000118001,
    XR_ERROR_FEATURE_REQUIRED_PASSTHROUGH_FB = -1000118002,
    XR_ERROR_NOT_PERMITTED_PASSTHROUGH_FB = -1000118003,
    XR_ERROR_INSUFFICIENT_RESOURCES_PASSTHROUGH_FB = -1000118004,
    XR_ERROR_UNKNOWN_PASSTHROUGH_FB = -1000118050,
    XR_ERROR_RENDER_MODEL_KEY_INVALID_FB = -1000119000,
    XR_RENDER_MODEL_UNAVAILABLE_FB = 1000119020,
    XR_ERROR_MARKER_NOT_TRACKED_VARJO = -1000124000,
    XR_ERROR_MARKER_ID_INVALID_VARJO = -1000124001,
    XR_ERROR_SPATIAL_ANCHOR_NAME_NOT_FOUND_MSFT = -1000142001,
    XR_ERROR_SPATIAL_ANCHOR_NAME_INVALID_MSFT = -1000142002,
    XR_RESULT_MAX_ENUM = 0x7FFFFFFF
}

alias XrStructureType = uint;
enum: XrStructureType
{
    XR_TYPE_UNKNOWN = 0,
    XR_TYPE_API_LAYER_PROPERTIES = 1,
    XR_TYPE_EXTENSION_PROPERTIES = 2,
    XR_TYPE_INSTANCE_CREATE_INFO = 3,
    XR_TYPE_SYSTEM_GET_INFO = 4,
    XR_TYPE_SYSTEM_PROPERTIES = 5,
    XR_TYPE_VIEW_LOCATE_INFO = 6,
    XR_TYPE_VIEW = 7,
    XR_TYPE_SESSION_CREATE_INFO = 8,
    XR_TYPE_SWAPCHAIN_CREATE_INFO = 9,
    XR_TYPE_SESSION_BEGIN_INFO = 10,
    XR_TYPE_VIEW_STATE = 11,
    XR_TYPE_FRAME_END_INFO = 12,
    XR_TYPE_HAPTIC_VIBRATION = 13,
    XR_TYPE_EVENT_DATA_BUFFER = 16,
    XR_TYPE_EVENT_DATA_INSTANCE_LOSS_PENDING = 17,
    XR_TYPE_EVENT_DATA_SESSION_STATE_CHANGED = 18,
    XR_TYPE_ACTION_STATE_BOOLEAN = 23,
    XR_TYPE_ACTION_STATE_FLOAT = 24,
    XR_TYPE_ACTION_STATE_VECTOR2F = 25,
    XR_TYPE_ACTION_STATE_POSE = 27,
    XR_TYPE_ACTION_SET_CREATE_INFO = 28,
    XR_TYPE_ACTION_CREATE_INFO = 29,
    XR_TYPE_INSTANCE_PROPERTIES = 32,
    XR_TYPE_FRAME_WAIT_INFO = 33,
    XR_TYPE_COMPOSITION_LAYER_PROJECTION = 35,
    XR_TYPE_COMPOSITION_LAYER_QUAD = 36,
    XR_TYPE_REFERENCE_SPACE_CREATE_INFO = 37,
    XR_TYPE_ACTION_SPACE_CREATE_INFO = 38,
    XR_TYPE_EVENT_DATA_REFERENCE_SPACE_CHANGE_PENDING = 40,
    XR_TYPE_VIEW_CONFIGURATION_VIEW = 41,
    XR_TYPE_SPACE_LOCATION = 42,
    XR_TYPE_SPACE_VELOCITY = 43,
    XR_TYPE_FRAME_STATE = 44,
    XR_TYPE_VIEW_CONFIGURATION_PROPERTIES = 45,
    XR_TYPE_FRAME_BEGIN_INFO = 46,
    XR_TYPE_COMPOSITION_LAYER_PROJECTION_VIEW = 48,
    XR_TYPE_EVENT_DATA_EVENTS_LOST = 49,
    XR_TYPE_INTERACTION_PROFILE_SUGGESTED_BINDING = 51,
    XR_TYPE_EVENT_DATA_INTERACTION_PROFILE_CHANGED = 52,
    XR_TYPE_INTERACTION_PROFILE_STATE = 53,
    XR_TYPE_SWAPCHAIN_IMAGE_ACQUIRE_INFO = 55,
    XR_TYPE_SWAPCHAIN_IMAGE_WAIT_INFO = 56,
    XR_TYPE_SWAPCHAIN_IMAGE_RELEASE_INFO = 57,
    XR_TYPE_ACTION_STATE_GET_INFO = 58,
    XR_TYPE_HAPTIC_ACTION_INFO = 59,
    XR_TYPE_SESSION_ACTION_SETS_ATTACH_INFO = 60,
    XR_TYPE_ACTIONS_SYNC_INFO = 61,
    XR_TYPE_BOUND_SOURCES_FOR_ACTION_ENUMERATE_INFO = 62,
    XR_TYPE_INPUT_SOURCE_LOCALIZED_NAME_GET_INFO = 63,
    XR_TYPE_COMPOSITION_LAYER_CUBE_KHR = 1000006000,
    XR_TYPE_INSTANCE_CREATE_INFO_ANDROID_KHR = 1000008000,
    XR_TYPE_COMPOSITION_LAYER_DEPTH_INFO_KHR = 1000010000,
    XR_TYPE_VULKAN_SWAPCHAIN_FORMAT_LIST_CREATE_INFO_KHR = 1000014000,
    XR_TYPE_EVENT_DATA_PERF_SETTINGS_EXT = 1000015000,
    XR_TYPE_COMPOSITION_LAYER_CYLINDER_KHR = 1000017000,
    XR_TYPE_COMPOSITION_LAYER_EQUIRECT_KHR = 1000018000,
    XR_TYPE_DEBUG_UTILS_OBJECT_NAME_INFO_EXT = 1000019000,
    XR_TYPE_DEBUG_UTILS_MESSENGER_CALLBACK_DATA_EXT = 1000019001,
    XR_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT = 1000019002,
    XR_TYPE_DEBUG_UTILS_LABEL_EXT = 1000019003,
    XR_TYPE_GRAPHICS_BINDING_OPENGL_WIN32_KHR = 1000023000,
    XR_TYPE_GRAPHICS_BINDING_OPENGL_XLIB_KHR = 1000023001,
    XR_TYPE_GRAPHICS_BINDING_OPENGL_XCB_KHR = 1000023002,
    XR_TYPE_GRAPHICS_BINDING_OPENGL_WAYLAND_KHR = 1000023003,
    XR_TYPE_SWAPCHAIN_IMAGE_OPENGL_KHR = 1000023004,
    XR_TYPE_GRAPHICS_REQUIREMENTS_OPENGL_KHR = 1000023005,
    XR_TYPE_GRAPHICS_BINDING_OPENGL_ES_ANDROID_KHR = 1000024001,
    XR_TYPE_SWAPCHAIN_IMAGE_OPENGL_ES_KHR = 1000024002,
    XR_TYPE_GRAPHICS_REQUIREMENTS_OPENGL_ES_KHR = 1000024003,
    XR_TYPE_GRAPHICS_BINDING_VULKAN_KHR = 1000025000,
    XR_TYPE_SWAPCHAIN_IMAGE_VULKAN_KHR = 1000025001,
    XR_TYPE_GRAPHICS_REQUIREMENTS_VULKAN_KHR = 1000025002,
    XR_TYPE_GRAPHICS_BINDING_D3D11_KHR = 1000027000,
    XR_TYPE_SWAPCHAIN_IMAGE_D3D11_KHR = 1000027001,
    XR_TYPE_GRAPHICS_REQUIREMENTS_D3D11_KHR = 1000027002,
    XR_TYPE_GRAPHICS_BINDING_D3D12_KHR = 1000028000,
    XR_TYPE_SWAPCHAIN_IMAGE_D3D12_KHR = 1000028001,
    XR_TYPE_GRAPHICS_REQUIREMENTS_D3D12_KHR = 1000028002,
    XR_TYPE_SYSTEM_EYE_GAZE_INTERACTION_PROPERTIES_EXT = 1000030000,
    XR_TYPE_EYE_GAZE_SAMPLE_TIME_EXT = 1000030001,
    XR_TYPE_VISIBILITY_MASK_KHR = 1000031000,
    XR_TYPE_EVENT_DATA_VISIBILITY_MASK_CHANGED_KHR = 1000031001,
    XR_TYPE_SESSION_CREATE_INFO_OVERLAY_EXTX = 1000033000,
    XR_TYPE_EVENT_DATA_MAIN_SESSION_VISIBILITY_CHANGED_EXTX = 1000033003,
    XR_TYPE_COMPOSITION_LAYER_COLOR_SCALE_BIAS_KHR = 1000034000,
    XR_TYPE_SPATIAL_ANCHOR_CREATE_INFO_MSFT = 1000039000,
    XR_TYPE_SPATIAL_ANCHOR_SPACE_CREATE_INFO_MSFT = 1000039001,
    XR_TYPE_COMPOSITION_LAYER_IMAGE_LAYOUT_FB = 1000040000,
    XR_TYPE_COMPOSITION_LAYER_ALPHA_BLEND_FB = 1000041001,
    XR_TYPE_VIEW_CONFIGURATION_DEPTH_RANGE_EXT = 1000046000,
    XR_TYPE_GRAPHICS_BINDING_EGL_MNDX = 1000048004,
    XR_TYPE_SPATIAL_GRAPH_NODE_SPACE_CREATE_INFO_MSFT = 1000049000,
    XR_TYPE_SYSTEM_HAND_TRACKING_PROPERTIES_EXT = 1000051000,
    XR_TYPE_HAND_TRACKER_CREATE_INFO_EXT = 1000051001,
    XR_TYPE_HAND_JOINTS_LOCATE_INFO_EXT = 1000051002,
    XR_TYPE_HAND_JOINT_LOCATIONS_EXT = 1000051003,
    XR_TYPE_HAND_JOINT_VELOCITIES_EXT = 1000051004,
    XR_TYPE_SYSTEM_HAND_TRACKING_MESH_PROPERTIES_MSFT = 1000052000,
    XR_TYPE_HAND_MESH_SPACE_CREATE_INFO_MSFT = 1000052001,
    XR_TYPE_HAND_MESH_UPDATE_INFO_MSFT = 1000052002,
    XR_TYPE_HAND_MESH_MSFT = 1000052003,
    XR_TYPE_HAND_POSE_TYPE_INFO_MSFT = 1000052004,
    XR_TYPE_SECONDARY_VIEW_CONFIGURATION_SESSION_BEGIN_INFO_MSFT = 1000053000,
    XR_TYPE_SECONDARY_VIEW_CONFIGURATION_STATE_MSFT = 1000053001,
    XR_TYPE_SECONDARY_VIEW_CONFIGURATION_FRAME_STATE_MSFT = 1000053002,
    XR_TYPE_SECONDARY_VIEW_CONFIGURATION_FRAME_END_INFO_MSFT = 1000053003,
    XR_TYPE_SECONDARY_VIEW_CONFIGURATION_LAYER_INFO_MSFT = 1000053004,
    XR_TYPE_SECONDARY_VIEW_CONFIGURATION_SWAPCHAIN_CREATE_INFO_MSFT = 1000053005,
    XR_TYPE_CONTROLLER_MODEL_KEY_STATE_MSFT = 1000055000,
    XR_TYPE_CONTROLLER_MODEL_NODE_PROPERTIES_MSFT = 1000055001,
    XR_TYPE_CONTROLLER_MODEL_PROPERTIES_MSFT = 1000055002,
    XR_TYPE_CONTROLLER_MODEL_NODE_STATE_MSFT = 1000055003,
    XR_TYPE_CONTROLLER_MODEL_STATE_MSFT = 1000055004,
    XR_TYPE_VIEW_CONFIGURATION_VIEW_FOV_EPIC = 1000059000,
    XR_TYPE_HOLOGRAPHIC_WINDOW_ATTACHMENT_MSFT = 1000063000,
    XR_TYPE_COMPOSITION_LAYER_REPROJECTION_INFO_MSFT = 1000066000,
    XR_TYPE_COMPOSITION_LAYER_REPROJECTION_PLANE_OVERRIDE_MSFT = 1000066001,
    XR_TYPE_ANDROID_SURFACE_SWAPCHAIN_CREATE_INFO_FB = 1000070000,
    XR_TYPE_COMPOSITION_LAYER_SECURE_CONTENT_FB = 1000072000,
    XR_TYPE_INTERACTION_PROFILE_ANALOG_THRESHOLD_VALVE = 1000079000,
    XR_TYPE_HAND_JOINTS_MOTION_RANGE_INFO_EXT = 1000080000,
    XR_TYPE_LOADER_INIT_INFO_ANDROID_KHR = 1000089000,
    XR_TYPE_VULKAN_INSTANCE_CREATE_INFO_KHR = 1000090000,
    XR_TYPE_VULKAN_DEVICE_CREATE_INFO_KHR = 1000090001,
    XR_TYPE_VULKAN_GRAPHICS_DEVICE_GET_INFO_KHR = 1000090003,
    XR_TYPE_COMPOSITION_LAYER_EQUIRECT2_KHR = 1000091000,
    XR_TYPE_SCENE_OBSERVER_CREATE_INFO_MSFT = 1000097000,
    XR_TYPE_SCENE_CREATE_INFO_MSFT = 1000097001,
    XR_TYPE_NEW_SCENE_COMPUTE_INFO_MSFT = 1000097002,
    XR_TYPE_VISUAL_MESH_COMPUTE_LOD_INFO_MSFT = 1000097003,
    XR_TYPE_SCENE_COMPONENTS_MSFT = 1000097004,
    XR_TYPE_SCENE_COMPONENTS_GET_INFO_MSFT = 1000097005,
    XR_TYPE_SCENE_COMPONENT_LOCATIONS_MSFT = 1000097006,
    XR_TYPE_SCENE_COMPONENTS_LOCATE_INFO_MSFT = 1000097007,
    XR_TYPE_SCENE_OBJECTS_MSFT = 1000097008,
    XR_TYPE_SCENE_COMPONENT_PARENT_FILTER_INFO_MSFT = 1000097009,
    XR_TYPE_SCENE_OBJECT_TYPES_FILTER_INFO_MSFT = 1000097010,
    XR_TYPE_SCENE_PLANES_MSFT = 1000097011,
    XR_TYPE_SCENE_PLANE_ALIGNMENT_FILTER_INFO_MSFT = 1000097012,
    XR_TYPE_SCENE_MESHES_MSFT = 1000097013,
    XR_TYPE_SCENE_MESH_BUFFERS_GET_INFO_MSFT = 1000097014,
    XR_TYPE_SCENE_MESH_BUFFERS_MSFT = 1000097015,
    XR_TYPE_SCENE_MESH_VERTEX_BUFFER_MSFT = 1000097016,
    XR_TYPE_SCENE_MESH_INDICES_UINT32_MSFT = 1000097017,
    XR_TYPE_SCENE_MESH_INDICES_UINT16_MSFT = 1000097018,
    XR_TYPE_SERIALIZED_SCENE_FRAGMENT_DATA_GET_INFO_MSFT = 1000098000,
    XR_TYPE_SCENE_DESERIALIZE_INFO_MSFT = 1000098001,
    XR_TYPE_EVENT_DATA_DISPLAY_REFRESH_RATE_CHANGED_FB = 1000101000,
    XR_TYPE_VIVE_TRACKER_PATHS_HTCX = 1000103000,
    XR_TYPE_EVENT_DATA_VIVE_TRACKER_CONNECTED_HTCX = 1000103001,
    XR_TYPE_SYSTEM_FACIAL_TRACKING_PROPERTIES_HTC = 1000104000,
    XR_TYPE_FACIAL_TRACKER_CREATE_INFO_HTC = 1000104001,
    XR_TYPE_FACIAL_EXPRESSIONS_HTC = 1000104002,
    XR_TYPE_SYSTEM_COLOR_SPACE_PROPERTIES_FB = 1000108000,
    XR_TYPE_HAND_TRACKING_MESH_FB = 1000110001,
    XR_TYPE_HAND_TRACKING_SCALE_FB = 1000110003,
    XR_TYPE_HAND_TRACKING_AIM_STATE_FB = 1000111001,
    XR_TYPE_HAND_TRACKING_CAPSULES_STATE_FB = 1000112000,
    XR_TYPE_FOVEATION_PROFILE_CREATE_INFO_FB = 1000114000,
    XR_TYPE_SWAPCHAIN_CREATE_INFO_FOVEATION_FB = 1000114001,
    XR_TYPE_SWAPCHAIN_STATE_FOVEATION_FB = 1000114002,
    XR_TYPE_FOVEATION_LEVEL_PROFILE_CREATE_INFO_FB = 1000115000,
    XR_TYPE_KEYBOARD_SPACE_CREATE_INFO_FB = 1000116009,
    XR_TYPE_KEYBOARD_TRACKING_QUERY_FB = 1000116004,
    XR_TYPE_SYSTEM_KEYBOARD_TRACKING_PROPERTIES_FB = 1000116002,
    XR_TYPE_TRIANGLE_MESH_CREATE_INFO_FB = 1000117001,
    XR_TYPE_SYSTEM_PASSTHROUGH_PROPERTIES_FB = 1000118000,
    XR_TYPE_PASSTHROUGH_CREATE_INFO_FB = 1000118001,
    XR_TYPE_PASSTHROUGH_LAYER_CREATE_INFO_FB = 1000118002,
    XR_TYPE_COMPOSITION_LAYER_PASSTHROUGH_FB = 1000118003,
    XR_TYPE_GEOMETRY_INSTANCE_CREATE_INFO_FB = 1000118004,
    XR_TYPE_GEOMETRY_INSTANCE_TRANSFORM_FB = 1000118005,
    XR_TYPE_PASSTHROUGH_STYLE_FB = 1000118020,
    XR_TYPE_PASSTHROUGH_COLOR_MAP_MONO_TO_RGBA_FB = 1000118021,
    XR_TYPE_PASSTHROUGH_COLOR_MAP_MONO_TO_MONO_FB = 1000118022,
    XR_TYPE_EVENT_DATA_PASSTHROUGH_STATE_CHANGED_FB = 1000118030,
    XR_TYPE_RENDER_MODEL_PATH_INFO_FB = 1000119000,
    XR_TYPE_RENDER_MODEL_PROPERTIES_FB = 1000119001,
    XR_TYPE_RENDER_MODEL_BUFFER_FB = 1000119002,
    XR_TYPE_RENDER_MODEL_LOAD_INFO_FB = 1000119003,
    XR_TYPE_SYSTEM_RENDER_MODEL_PROPERTIES_FB = 1000119004,
    XR_TYPE_BINDING_MODIFICATIONS_KHR = 1000120000,
    XR_TYPE_VIEW_LOCATE_FOVEATED_RENDERING_VARJO = 1000121000,
    XR_TYPE_FOVEATED_VIEW_CONFIGURATION_VIEW_VARJO = 1000121001,
    XR_TYPE_SYSTEM_FOVEATED_RENDERING_PROPERTIES_VARJO = 1000121002,
    XR_TYPE_COMPOSITION_LAYER_DEPTH_TEST_VARJO = 1000122000,
    XR_TYPE_SYSTEM_MARKER_TRACKING_PROPERTIES_VARJO = 1000124000,
    XR_TYPE_EVENT_DATA_MARKER_TRACKING_UPDATE_VARJO = 1000124001,
    XR_TYPE_MARKER_SPACE_CREATE_INFO_VARJO = 1000124002,
    XR_TYPE_SPATIAL_ANCHOR_PERSISTENCE_INFO_MSFT = 1000142000,
    XR_TYPE_SPATIAL_ANCHOR_FROM_PERSISTED_ANCHOR_CREATE_INFO_MSFT = 1000142001,
    XR_TYPE_SWAPCHAIN_IMAGE_FOVEATION_VULKAN_FB = 1000160000,
    XR_TYPE_SWAPCHAIN_STATE_ANDROID_SURFACE_DIMENSIONS_FB = 1000161000,
    XR_TYPE_SWAPCHAIN_STATE_SAMPLER_OPENGL_ES_FB = 1000162000,
    XR_TYPE_SWAPCHAIN_STATE_SAMPLER_VULKAN_FB = 1000163000,
    XR_TYPE_COMPOSITION_LAYER_SPACE_WARP_INFO_FB = 1000171000,
    XR_TYPE_SYSTEM_SPACE_WARP_PROPERTIES_FB = 1000171001,
    XR_TYPE_DIGITAL_LENS_CONTROL_ALMALENCE = 1000196000,
    XR_TYPE_PASSTHROUGH_KEYBOARD_HANDS_INTENSITY_FB = 1000203002,
    XR_TYPE_GRAPHICS_BINDING_VULKAN2_KHR = XR_TYPE_GRAPHICS_BINDING_VULKAN_KHR,
    XR_TYPE_SWAPCHAIN_IMAGE_VULKAN2_KHR = XR_TYPE_SWAPCHAIN_IMAGE_VULKAN_KHR,
    XR_TYPE_GRAPHICS_REQUIREMENTS_VULKAN2_KHR = XR_TYPE_GRAPHICS_REQUIREMENTS_VULKAN_KHR,
    XR_STRUCTURE_TYPE_MAX_ENUM = 0x7FFFFFFF
}

alias XrFormFactor = uint;
enum: XrFormFactor
{
    XR_FORM_FACTOR_HEAD_MOUNTED_DISPLAY = 1,
    XR_FORM_FACTOR_HANDHELD_DISPLAY = 2,
    XR_FORM_FACTOR_MAX_ENUM = 0x7FFFFFFF
}

alias XrViewConfigurationType = uint;
enum: XrViewConfigurationType
{
    XR_VIEW_CONFIGURATION_TYPE_PRIMARY_MONO = 1,
    XR_VIEW_CONFIGURATION_TYPE_PRIMARY_STEREO = 2,
    XR_VIEW_CONFIGURATION_TYPE_PRIMARY_QUAD_VARJO = 1000037000,
    XR_VIEW_CONFIGURATION_TYPE_SECONDARY_MONO_FIRST_PERSON_OBSERVER_MSFT = 1000054000,
    XR_VIEW_CONFIGURATION_TYPE_MAX_ENUM = 0x7FFFFFFF
}

alias XrEnvironmentBlendMode = uint;
enum: XrEnvironmentBlendMode
{
    XR_ENVIRONMENT_BLEND_MODE_OPAQUE = 1,
    XR_ENVIRONMENT_BLEND_MODE_ADDITIVE = 2,
    XR_ENVIRONMENT_BLEND_MODE_ALPHA_BLEND = 3,
    XR_ENVIRONMENT_BLEND_MODE_MAX_ENUM = 0x7FFFFFFF
}

alias XrReferenceSpaceType = uint;
enum: XrReferenceSpaceType
{
    XR_REFERENCE_SPACE_TYPE_VIEW = 1,
    XR_REFERENCE_SPACE_TYPE_LOCAL = 2,
    XR_REFERENCE_SPACE_TYPE_STAGE = 3,
    XR_REFERENCE_SPACE_TYPE_UNBOUNDED_MSFT = 1000038000,
    XR_REFERENCE_SPACE_TYPE_COMBINED_EYE_VARJO = 1000121000,
    XR_REFERENCE_SPACE_TYPE_MAX_ENUM = 0x7FFFFFFF
}

alias XrActionType = uint;
enum: XrActionType
{
    XR_ACTION_TYPE_BOOLEAN_INPUT = 1,
    XR_ACTION_TYPE_FLOAT_INPUT = 2,
    XR_ACTION_TYPE_VECTOR2F_INPUT = 3,
    XR_ACTION_TYPE_POSE_INPUT = 4,
    XR_ACTION_TYPE_VIBRATION_OUTPUT = 100,
    XR_ACTION_TYPE_MAX_ENUM = 0x7FFFFFFF
}

alias XrEyeVisibility = uint;
enum: XrEyeVisibility
{
    XR_EYE_VISIBILITY_BOTH = 0,
    XR_EYE_VISIBILITY_LEFT = 1,
    XR_EYE_VISIBILITY_RIGHT = 2,
    XR_EYE_VISIBILITY_MAX_ENUM = 0x7FFFFFFF
}

alias XrSessionState = uint;
enum: XrSessionState
{
    XR_SESSION_STATE_UNKNOWN = 0,
    XR_SESSION_STATE_IDLE = 1,
    XR_SESSION_STATE_READY = 2,
    XR_SESSION_STATE_SYNCHRONIZED = 3,
    XR_SESSION_STATE_VISIBLE = 4,
    XR_SESSION_STATE_FOCUSED = 5,
    XR_SESSION_STATE_STOPPING = 6,
    XR_SESSION_STATE_LOSS_PENDING = 7,
    XR_SESSION_STATE_EXITING = 8,
    XR_SESSION_STATE_MAX_ENUM = 0x7FFFFFFF
}

alias XrObjectType = uint;
enum: XrObjectType
{
    XR_OBJECT_TYPE_UNKNOWN = 0,
    XR_OBJECT_TYPE_INSTANCE = 1,
    XR_OBJECT_TYPE_SESSION = 2,
    XR_OBJECT_TYPE_SWAPCHAIN = 3,
    XR_OBJECT_TYPE_SPACE = 4,
    XR_OBJECT_TYPE_ACTION_SET = 5,
    XR_OBJECT_TYPE_ACTION = 6,
    XR_OBJECT_TYPE_DEBUG_UTILS_MESSENGER_EXT = 1000019000,
    XR_OBJECT_TYPE_SPATIAL_ANCHOR_MSFT = 1000039000,
    XR_OBJECT_TYPE_HAND_TRACKER_EXT = 1000051000,
    XR_OBJECT_TYPE_SCENE_OBSERVER_MSFT = 1000097000,
    XR_OBJECT_TYPE_SCENE_MSFT = 1000097001,
    XR_OBJECT_TYPE_FACIAL_TRACKER_HTC = 1000104000,
    XR_OBJECT_TYPE_FOVEATION_PROFILE_FB = 1000114000,
    XR_OBJECT_TYPE_TRIANGLE_MESH_FB = 1000117000,
    XR_OBJECT_TYPE_PASSTHROUGH_FB = 1000118000,
    XR_OBJECT_TYPE_PASSTHROUGH_LAYER_FB = 1000118002,
    XR_OBJECT_TYPE_GEOMETRY_INSTANCE_FB = 1000118004,
    XR_OBJECT_TYPE_SPATIAL_ANCHOR_STORE_CONNECTION_MSFT = 1000142000,
    XR_OBJECT_TYPE_MAX_ENUM = 0x7FFFFFFF
}

alias XrInstanceCreateFlags = XrFlags64;

alias XrSessionCreateFlags = XrFlags64;

alias XrSpaceVelocityFlags = XrFlags64;
enum: XrSpaceVelocityFlags
{
    XR_SPACE_VELOCITY_LINEAR_VALID_BIT = 0x00000001,
    XR_SPACE_VELOCITY_ANGULAR_VALID_BIT = 0x00000002
}

alias XrSpaceLocationFlags = XrFlags64;
enum: XrSpaceLocationFlags
{
    XR_SPACE_LOCATION_ORIENTATION_VALID_BIT   = 0x00000001,
    XR_SPACE_LOCATION_POSITION_VALID_BIT      = 0x00000002,
    XR_SPACE_LOCATION_ORIENTATION_TRACKED_BIT = 0x00000004,
    XR_SPACE_LOCATION_POSITION_TRACKED_BIT    = 0x00000008
}

alias XrSwapchainCreateFlags = XrFlags64;
enum: XrSwapchainCreateFlags
{
    XR_SWAPCHAIN_CREATE_PROTECTED_CONTENT_BIT = 0x00000001,
    XR_SWAPCHAIN_CREATE_STATIC_IMAGE_BIT      = 0x00000002
}

alias XrSwapchainUsageFlags = XrFlags64;
enum: XrSwapchainUsageFlags
{
    XR_SWAPCHAIN_USAGE_COLOR_ATTACHMENT_BIT         = 0x00000001,
    XR_SWAPCHAIN_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT = 0x00000002,
    XR_SWAPCHAIN_USAGE_UNORDERED_ACCESS_BIT         = 0x00000004,
    XR_SWAPCHAIN_USAGE_TRANSFER_SRC_BIT             = 0x00000008,
    XR_SWAPCHAIN_USAGE_TRANSFER_DST_BIT             = 0x00000010,
    XR_SWAPCHAIN_USAGE_SAMPLED_BIT                  = 0x00000020,
    XR_SWAPCHAIN_USAGE_MUTABLE_FORMAT_BIT           = 0x00000040,
    XR_SWAPCHAIN_USAGE_INPUT_ATTACHMENT_BIT_MND     = 0x00000080,
    XR_SWAPCHAIN_USAGE_INPUT_ATTACHMENT_BIT_KHR     = 0x00000080 // alias of XR_SWAPCHAIN_USAGE_INPUT_ATTACHMENT_BIT_MND
}

alias XrCompositionLayerFlags = XrFlags64;
enum: XrCompositionLayerFlags
{
    XR_COMPOSITION_LAYER_CORRECT_CHROMATIC_ABERRATION_BIT = 0x00000001,
    XR_COMPOSITION_LAYER_BLEND_TEXTURE_SOURCE_ALPHA_BIT   = 0x00000002,
    XR_COMPOSITION_LAYER_UNPREMULTIPLIED_ALPHA_BIT        = 0x00000004
}

alias XrViewStateFlags = XrFlags64;
enum: XrViewStateFlags
{
    XR_VIEW_STATE_ORIENTATION_VALID_BIT   = 0x00000001,
    XR_VIEW_STATE_POSITION_VALID_BIT      = 0x00000002,
    XR_VIEW_STATE_ORIENTATION_TRACKED_BIT = 0x00000004,
    XR_VIEW_STATE_POSITION_TRACKED_BIT    = 0x00000008
}

alias XrInputSourceLocalizedNameFlags = XrFlags64;
enum: XrInputSourceLocalizedNameFlags
{
    XR_INPUT_SOURCE_LOCALIZED_NAME_USER_PATH_BIT           = 0x00000001,
    XR_INPUT_SOURCE_LOCALIZED_NAME_INTERACTION_PROFILE_BIT = 0x00000002,
    XR_INPUT_SOURCE_LOCALIZED_NAME_COMPONENT_BIT           = 0x00000004
}

extern(C)
{
    alias PFN_xrVoidFunction = void function();
}

struct XrApiLayerProperties
{
    XrStructureType type;
    void* next;
    char[XR_MAX_API_LAYER_NAME_SIZE] layerName;
    XrVersion specVersion;
    uint layerVersion;
    char[XR_MAX_API_LAYER_DESCRIPTION_SIZE] description;
}

struct XrExtensionProperties
{
    XrStructureType type;
    void* next;
    char[XR_MAX_EXTENSION_NAME_SIZE] extensionName;
    uint extensionVersion;
}

struct XrApplicationInfo
{
    char[XR_MAX_APPLICATION_NAME_SIZE] applicationName;
    uint applicationVersion;
    char[XR_MAX_ENGINE_NAME_SIZE] engineName;
    uint engineVersion;
    XrVersion apiVersion;
}

struct XrInstanceCreateInfo
{
    XrStructureType type;
    const(void)* next;
    XrInstanceCreateFlags createFlags;
    XrApplicationInfo applicationInfo;
    uint enabledApiLayerCount;
    const(char*)* enabledApiLayerNames;
    uint enabledExtensionCount;
    const(char*)* enabledExtensionNames;
}

struct XrInstanceProperties
{
    XrStructureType type;
    void* next;
    XrVersion runtimeVersion;
    char[XR_MAX_RUNTIME_NAME_SIZE] runtimeName;
}

struct XrEventDataBuffer
{
    XrStructureType type;
    const(void)* next;
    ubyte[4000] varying;
}

struct XrSystemGetInfo
{
    XrStructureType type;
    const(void)* next;
    XrFormFactor formFactor;
}

struct XrSystemGraphicsProperties
{
    uint maxSwapchainImageHeight;
    uint maxSwapchainImageWidth;
    uint maxLayerCount;
}

struct XrSystemTrackingProperties
{
    XrBool32 orientationTracking;
    XrBool32 positionTracking;
}

struct XrSystemProperties
{
    XrStructureType type;
    void* next;
    XrSystemId systemId;
    uint vendorId;
    char[XR_MAX_SYSTEM_NAME_SIZE] systemName;
    XrSystemGraphicsProperties graphicsProperties;
    XrSystemTrackingProperties trackingProperties;
}

struct XrSessionCreateInfo
{
    XrStructureType type;
    const(void)* next;
    XrSessionCreateFlags createFlags;
    XrSystemId systemId;
}

alias XrVector3f = Vector3f;
/*
struct XrVector3f
{
    float x;
    float y;
    float z;
}
*/

// XrSpaceVelocity extends XrSpaceLocation
struct XrSpaceVelocity
{
    XrStructureType type;
    void* next;
    XrSpaceVelocityFlags velocityFlags;
    XrVector3f linearVelocity;
    XrVector3f angularVelocity;
}

alias XrQuaternionf = Quaternionf;
/*
struct XrQuaternionf
{
    float x;
    float y;
    float z;
    float w;
}
*/

struct XrPosef
{
    XrQuaternionf orientation;
    XrVector3f position;
}

struct XrReferenceSpaceCreateInfo
{
    XrStructureType type;
    const(void)* next;
    XrReferenceSpaceType referenceSpaceType;
    XrPosef poseInReferenceSpace;
}

struct XrExtent2Df
{
    float width;
    float height;
}

struct XrActionSpaceCreateInfo
{
    XrStructureType type;
    const(void)* next;
    XrAction action;
    XrPath subactionPath;
    XrPosef poseInActionSpace;
}

struct XrSpaceLocation
{
    XrStructureType type;
    void* next;
    XrSpaceLocationFlags locationFlags;
    XrPosef pose;
}

struct XrViewConfigurationProperties
{
    XrStructureType type;
    void* next;
    XrViewConfigurationType viewConfigurationType;
    XrBool32 fovMutable;
}

struct XrViewConfigurationView
{
    XrStructureType type;
    void* next;
    uint recommendedImageRectWidth;
    uint maxImageRectWidth;
    uint recommendedImageRectHeight;
    uint maxImageRectHeight;
    uint recommendedSwapchainSampleCount;
    uint maxSwapchainSampleCount;
}

struct XrSwapchainCreateInfo
{
    XrStructureType type;
    const(void)* next;
    XrSwapchainCreateFlags createFlags;
    XrSwapchainUsageFlags usageFlags;
    long format;
    uint sampleCount;
    uint width;
    uint height;
    uint faceCount;
    uint arraySize;
    uint mipCount;
}

struct XrSwapchainImageBaseHeader
{
    XrStructureType type;
    void* next;
}

// XR_KHR_opengl_enable graphics bindings.
// Platform handles are represented as opaque pointers / ABI-sized integers so
// this module does not need to import Win32, Xlib, XCB or Wayland headers.
struct XrGraphicsBindingOpenGLWin32KHR
{
    XrStructureType type;
    const(void)* next;
    void* hDC;       // HDC
    void* hGLRC;     // HGLRC
}

struct XrGraphicsBindingOpenGLXlibKHR
{
    XrStructureType type;
    const(void)* next;
    void* xDisplay;  // Display*
    uint visualid;
    void* glxFBConfig; // GLXFBConfig
    ulong glxDrawable; // GLXDrawable / XID
    void* glxContext;  // GLXContext
}

struct XrGraphicsBindingOpenGLXcbKHR
{
    XrStructureType type;
    const(void)* next;
    void* connection; // xcb_connection_t*
    uint screenNumber;
    uint fbconfigid;  // xcb_glx_fbconfig_t
    uint visualid;    // xcb_visualid_t
    uint glxDrawable; // xcb_glx_drawable_t
    uint glxContext;  // xcb_glx_context_t
}

struct XrGraphicsBindingOpenGLWaylandKHR
{
    XrStructureType type;
    const(void)* next;
    void* display; // wl_display*
}

struct XrSwapchainImageOpenGLKHR
{
    XrStructureType type;
    void* next;
    uint image; // GLuint
}

struct XrGraphicsRequirementsOpenGLKHR
{
    XrStructureType type;
    void* next;
    XrVersion minApiVersionSupported;
    XrVersion maxApiVersionSupported;
}

struct XrSwapchainImageAcquireInfo
{
    XrStructureType type;
    const(void)* next;
}

struct XrSwapchainImageWaitInfo
{
    XrStructureType type;
    const(void)* next;
    XrDuration timeout;
}

struct XrSwapchainImageReleaseInfo
{
    XrStructureType type;
    const(void)* next;
}

struct XrSessionBeginInfo
{
    XrStructureType type;
    const(void)* next;
    XrViewConfigurationType primaryViewConfigurationType;
}

struct XrFrameWaitInfo
{
    XrStructureType type;
    const(void)* next;
}

struct XrFrameState
{
    XrStructureType type;
    void* next;
    XrTime predictedDisplayTime;
    XrDuration predictedDisplayPeriod;
    XrBool32 shouldRender;
}

struct XrFrameBeginInfo
{
    XrStructureType type;
    const(void)* next;
}

struct XrCompositionLayerBaseHeader
{
    XrStructureType type;
    const(void)* next;
    XrCompositionLayerFlags layerFlags;
    XrSpace space;
}

struct XrFrameEndInfo
{
    XrStructureType type;
    const(void)* next;
    XrTime displayTime;
    XrEnvironmentBlendMode environmentBlendMode;
    uint layerCount;
    const(XrCompositionLayerBaseHeader*)* layers;
}

struct XrViewLocateInfo
{
    XrStructureType type;
    const(void)* next;
    XrViewConfigurationType viewConfigurationType;
    XrTime displayTime;
    XrSpace space;
}

struct XrViewState
{
    XrStructureType type;
    void* next;
    XrViewStateFlags viewStateFlags;
}

struct XrFovf
{
    float angleLeft;
    float angleRight;
    float angleUp;
    float angleDown;
}

struct XrView
{
    XrStructureType type;
    void* next;
    XrPosef pose;
    XrFovf fov;
}

struct XrActionSetCreateInfo
{
    XrStructureType type;
    const(void)* next;
    char[XR_MAX_ACTION_SET_NAME_SIZE] actionSetName;
    char[XR_MAX_LOCALIZED_ACTION_SET_NAME_SIZE] localizedActionSetName;
    uint priority;
}

struct XrActionCreateInfo
{
    XrStructureType type;
    const(void)* next;
    char[XR_MAX_ACTION_NAME_SIZE] actionName;
    XrActionType actionType;
    uint countSubactionPaths;
    const(XrPath)* subactionPaths;
    char[XR_MAX_LOCALIZED_ACTION_NAME_SIZE] localizedActionName;
}

struct XrActionSuggestedBinding
{
    XrAction action;
    XrPath binding;
}

struct XrInteractionProfileSuggestedBinding
{
    XrStructureType type;
    const(void)* next;
    XrPath interactionProfile;
    uint countSuggestedBindings;
    const(XrActionSuggestedBinding)* suggestedBindings;
}

struct XrSessionActionSetsAttachInfo
{
    XrStructureType type;
    const(void)* next;
    uint countActionSets;
    const(XrActionSet)* actionSets;
}

struct XrInteractionProfileState
{
    XrStructureType type;
    void* next;
    XrPath interactionProfile;
}

struct XrActionStateGetInfo
{
    XrStructureType type;
    const(void)* next;
    XrAction action;
    XrPath subactionPath;
}

struct XrActionStateBoolean
{
    XrStructureType type;
    void* next;
    XrBool32 currentState;
    XrBool32 changedSinceLastSync;
    XrTime lastChangeTime;
    XrBool32 isActive;
}

struct XrActionStateFloat
{
    XrStructureType type;
    void* next;
    float currentState;
    XrBool32 changedSinceLastSync;
    XrTime lastChangeTime;
    XrBool32 isActive;
}

/*
struct XrVector2f
{
    float x;
    float y;
}
*/

alias XrVector2f = Vector2f;

struct XrActionStateVector2f
{
    XrStructureType type;
    void* next;
    XrVector2f currentState;
    XrBool32 changedSinceLastSync;
    XrTime lastChangeTime;
    XrBool32 isActive;
}

struct XrActionStatePose
{
    XrStructureType type;
    void* next;
    XrBool32 isActive;
}

struct XrActiveActionSet
{
    XrActionSet actionSet;
    XrPath subactionPath;
}

struct XrActionsSyncInfo
{
    XrStructureType type;
    const(void)* next;
    uint countActiveActionSets;
    const(XrActiveActionSet)* activeActionSets;
}

struct XrBoundSourcesForActionEnumerateInfo
{
    XrStructureType type;
    const(void)* next;
    XrAction action;
}

struct XrInputSourceLocalizedNameGetInfo
{
    XrStructureType type;
    const(void)* next;
    XrPath sourcePath;
    XrInputSourceLocalizedNameFlags whichComponents;
}

struct XrHapticActionInfo
{
    XrStructureType type;
    const(void)* next;
    XrAction action;
    XrPath subactionPath;
}

struct XrHapticBaseHeader
{
    XrStructureType type;
    const(void)* next;
}

struct XrBaseInStructure
{
    XrStructureType type;
    const(XrBaseInStructure)* next;
}

struct XrBaseOutStructure
{
    XrStructureType type;
    XrBaseOutStructure* next;
}

struct XrOffset2Di
{
    int x;
    int y;
}

struct XrExtent2Di
{
    int width;
    int height;
}

struct XrRect2Di
{
    XrOffset2Di offset;
    XrExtent2Di extent;
}

struct XrSwapchainSubImage
{
    XrSwapchain swapchain;
    XrRect2Di imageRect;
    uint imageArrayIndex;
}

struct XrCompositionLayerProjectionView
{
    XrStructureType type;
    const(void)* next;
    XrPosef pose;
    XrFovf fov;
    XrSwapchainSubImage subImage;
}

struct XrCompositionLayerProjection
{
    XrStructureType type;
    const(void)* next;
    XrCompositionLayerFlags layerFlags;
    XrSpace space;
    uint viewCount;
    const(XrCompositionLayerProjectionView)* views;
}

struct XrCompositionLayerQuad
{
    XrStructureType type;
    const(void)* next;
    XrCompositionLayerFlags layerFlags;
    XrSpace space;
    XrEyeVisibility eyeVisibility;
    XrSwapchainSubImage subImage;
    XrPosef pose;
    XrExtent2Df size;
}

struct XrEventDataBaseHeader
{
    XrStructureType type;
    const(void)* next;
}

struct XrEventDataEventsLost
{
    XrStructureType type;
    const(void)* next;
    uint lostEventCount;
}

struct XrEventDataInstanceLossPending
{
    XrStructureType type;
    const(void)* next;
    XrTime lossTime;
}

struct XrEventDataSessionStateChanged
{
    XrStructureType type;
    const(void)* next;
    XrSession session;
    XrSessionState state;
    XrTime time;
}

struct XrEventDataReferenceSpaceChangePending
{
    XrStructureType type;
    const(void)* next;
    XrSession session;
    XrReferenceSpaceType referenceSpaceType;
    XrTime changeTime;
    XrBool32 poseValid;
    XrPosef poseInPreviousSpace;
}

struct XrEventDataInteractionProfileChanged
{
    XrStructureType type;
    const(void)* next;
    XrSession session;
}

struct XrHapticVibration
{
    XrStructureType type;
    const(void)* next;
    XrDuration duration;
    float frequency;
    float amplitude;
}

struct XrOffset2Df
{
    float x;
    float y;
}

struct XrRect2Df
{
    XrOffset2Df offset;
    XrExtent2Df extent;
}

alias XrVector4f = Vector4f;
/*
struct XrVector4f
{
    float x;
    float y;
    float z;
    float w;
}
*/

alias XrColor4f = Color4f;
/*
struct XrColor4f
{
    float r;
    float g;
    float b;
    float a;
}
*/

extern(C)
{
    alias PFN_xrGetOpenGLGraphicsRequirementsKHR = XrResult function (XrInstance instance, XrSystemId systemId, XrGraphicsRequirementsOpenGLKHR* graphicsRequirements);
    alias PFN_xrGetInstanceProcAddr = XrResult function (XrInstance instance, const(char)* name, PFN_xrVoidFunction* function_);
    alias PFN_xrEnumerateApiLayerProperties = XrResult function (uint propertyCapacityInput, uint* propertyCountOutput, XrApiLayerProperties* properties);
    alias PFN_xrEnumerateInstanceExtensionProperties = XrResult function (const(char)* layerName, uint propertyCapacityInput, uint* propertyCountOutput, XrExtensionProperties* properties);
    alias PFN_xrCreateInstance = XrResult function (const(XrInstanceCreateInfo)* createInfo, XrInstance* instance);
    alias PFN_xrDestroyInstance = XrResult function (XrInstance instance);
    alias PFN_xrGetInstanceProperties = XrResult function (XrInstance instance, XrInstanceProperties* instanceProperties);
    alias PFN_xrPollEvent = XrResult function (XrInstance instance, XrEventDataBuffer* eventData);
    alias PFN_xrResultToString = XrResult function (XrInstance instance, XrResult value, char[XR_MAX_RESULT_STRING_SIZE] buffer);
    alias PFN_xrStructureTypeToString = XrResult function (XrInstance instance, XrStructureType value, char[XR_MAX_STRUCTURE_NAME_SIZE] buffer);
    alias PFN_xrGetSystem = XrResult function (XrInstance instance, const(XrSystemGetInfo)* getInfo, XrSystemId* systemId);
    alias PFN_xrGetSystemProperties = XrResult function (XrInstance instance, XrSystemId systemId, XrSystemProperties* properties);
    alias PFN_xrEnumerateEnvironmentBlendModes = XrResult function (XrInstance instance, XrSystemId systemId, XrViewConfigurationType viewConfigurationType, uint environmentBlendModeCapacityInput, uint* environmentBlendModeCountOutput, XrEnvironmentBlendMode* environmentBlendModes);
    alias PFN_xrCreateSession = XrResult function (XrInstance instance, const(XrSessionCreateInfo)* createInfo, XrSession* session);
    alias PFN_xrDestroySession = XrResult function (XrSession session);
    alias PFN_xrEnumerateReferenceSpaces = XrResult function (XrSession session, uint spaceCapacityInput, uint* spaceCountOutput, XrReferenceSpaceType* spaces);
    alias PFN_xrCreateReferenceSpace = XrResult function (XrSession session, const(XrReferenceSpaceCreateInfo)* createInfo, XrSpace* space);
    alias PFN_xrGetReferenceSpaceBoundsRect = XrResult function (XrSession session, XrReferenceSpaceType referenceSpaceType, XrExtent2Df* bounds);
    alias PFN_xrCreateActionSpace = XrResult function (XrSession session, const(XrActionSpaceCreateInfo)* createInfo, XrSpace* space);
    alias PFN_xrLocateSpace = XrResult function (XrSpace space, XrSpace baseSpace, XrTime time, XrSpaceLocation* location);
    alias PFN_xrDestroySpace = XrResult function (XrSpace space);
    alias PFN_xrEnumerateViewConfigurations = XrResult function (XrInstance instance, XrSystemId systemId, uint viewConfigurationTypeCapacityInput, uint* viewConfigurationTypeCountOutput, XrViewConfigurationType* viewConfigurationTypes);
    alias PFN_xrGetViewConfigurationProperties = XrResult function (XrInstance instance, XrSystemId systemId, XrViewConfigurationType viewConfigurationType, XrViewConfigurationProperties* configurationProperties);
    alias PFN_xrEnumerateViewConfigurationViews = XrResult function (XrInstance instance, XrSystemId systemId, XrViewConfigurationType viewConfigurationType, uint viewCapacityInput, uint* viewCountOutput, XrViewConfigurationView* views);
    alias PFN_xrEnumerateSwapchainFormats = XrResult function (XrSession session, uint formatCapacityInput, uint* formatCountOutput, long* formats);
    alias PFN_xrCreateSwapchain = XrResult function (XrSession session, const(XrSwapchainCreateInfo)* createInfo, XrSwapchain* swapchain);
    alias PFN_xrDestroySwapchain = XrResult function (XrSwapchain swapchain);
    alias PFN_xrEnumerateSwapchainImages = XrResult function (XrSwapchain swapchain, uint imageCapacityInput, uint* imageCountOutput, XrSwapchainImageBaseHeader* images);
    alias PFN_xrAcquireSwapchainImage = XrResult function (XrSwapchain swapchain, const(XrSwapchainImageAcquireInfo)* acquireInfo, uint* index);
    alias PFN_xrWaitSwapchainImage = XrResult function (XrSwapchain swapchain, const(XrSwapchainImageWaitInfo)* waitInfo);
    alias PFN_xrReleaseSwapchainImage = XrResult function (XrSwapchain swapchain, const(XrSwapchainImageReleaseInfo)* releaseInfo);
    alias PFN_xrBeginSession = XrResult function (XrSession session, const(XrSessionBeginInfo)* beginInfo);
    alias PFN_xrEndSession = XrResult function (XrSession session);
    alias PFN_xrRequestExitSession = XrResult function (XrSession session);
    alias PFN_xrWaitFrame = XrResult function (XrSession session, const(XrFrameWaitInfo)* frameWaitInfo, XrFrameState* frameState);
    alias PFN_xrBeginFrame = XrResult function (XrSession session, const(XrFrameBeginInfo)* frameBeginInfo);
    alias PFN_xrEndFrame = XrResult function (XrSession session, const(XrFrameEndInfo)* frameEndInfo);
    alias PFN_xrLocateViews = XrResult function (XrSession session, const(XrViewLocateInfo)* viewLocateInfo, XrViewState* viewState, uint viewCapacityInput, uint* viewCountOutput, XrView* views);
    alias PFN_xrStringToPath = XrResult function (XrInstance instance, const(char)* pathString, XrPath* path);
    alias PFN_xrPathToString = XrResult function (XrInstance instance, XrPath path, uint bufferCapacityInput, uint* bufferCountOutput, char* buffer);
    alias PFN_xrCreateActionSet = XrResult function (XrInstance instance, const(XrActionSetCreateInfo)* createInfo, XrActionSet* actionSet);
    alias PFN_xrDestroyActionSet = XrResult function (XrActionSet actionSet);
    alias PFN_xrCreateAction = XrResult function (XrActionSet actionSet, const(XrActionCreateInfo)* createInfo, XrAction* action);
    alias PFN_xrDestroyAction = XrResult function (XrAction action);
    alias PFN_xrSuggestInteractionProfileBindings = XrResult function (XrInstance instance, const(XrInteractionProfileSuggestedBinding)* suggestedBindings);
    alias PFN_xrAttachSessionActionSets = XrResult function (XrSession session, const(XrSessionActionSetsAttachInfo)* attachInfo);
    alias PFN_xrGetCurrentInteractionProfile = XrResult function (XrSession session, XrPath topLevelUserPath, XrInteractionProfileState* interactionProfile);
    alias PFN_xrGetActionStateBoolean = XrResult function (XrSession session, const(XrActionStateGetInfo)* getInfo, XrActionStateBoolean* state);
    alias PFN_xrGetActionStateFloat = XrResult function (XrSession session, const(XrActionStateGetInfo)* getInfo, XrActionStateFloat* state);
    alias PFN_xrGetActionStateVector2f = XrResult function (XrSession session, const(XrActionStateGetInfo)* getInfo, XrActionStateVector2f* state);
    alias PFN_xrGetActionStatePose = XrResult function (XrSession session, const(XrActionStateGetInfo)* getInfo, XrActionStatePose* state);
    alias PFN_xrSyncActions = XrResult function (XrSession session, const(XrActionsSyncInfo)* syncInfo);
    alias PFN_xrEnumerateBoundSourcesForAction = XrResult function (XrSession session, const(XrBoundSourcesForActionEnumerateInfo)* enumerateInfo, uint sourceCapacityInput, uint* sourceCountOutput, XrPath* sources);
    alias PFN_xrGetInputSourceLocalizedName = XrResult function (XrSession session, const(XrInputSourceLocalizedNameGetInfo)* getInfo, uint bufferCapacityInput, uint* bufferCountOutput, char* buffer);
    alias PFN_xrApplyHapticFeedback = XrResult function (XrSession session, const(XrHapticActionInfo)* hapticActionInfo, const(XrHapticBaseHeader)* hapticFeedback);
    alias PFN_xrStopHapticFeedback = XrResult function (XrSession session, const(XrHapticActionInfo)* hapticActionInfo);
}
