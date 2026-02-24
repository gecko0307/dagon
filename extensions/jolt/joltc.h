// Copyright (c) Amer Koleci and Contributors.
// Licensed under the MIT License (MIT). See LICENSE in the repository root for more information.

#ifndef JOLT_C_H_
#define JOLT_C_H_ 1

#if defined(JPH_SHARED_LIBRARY_BUILD)
#   if defined(_MSC_VER)
#       define _JPH_EXPORT __declspec(dllexport)
#   elif defined(__GNUC__)
#       define _JPH_EXPORT __attribute__((visibility("default")))
#   else
#       define _JPH_EXPORT
#       pragma warning "Unknown dynamic link import/export semantics."
#   endif
#elif defined(JPH_SHARED_LIBRARY_INCLUDE)
#   if defined(_MSC_VER)
#       define _JPH_EXPORT __declspec(dllimport)
#   else
#       define _JPH_EXPORT
#   endif
#else
#   define _JPH_EXPORT
#endif

#ifdef __cplusplus
#	define _JPH_EXTERN extern "C"
#else
#   define _JPH_EXTERN extern
#endif

#ifdef _WIN32
#   define JPH_API_CALL __cdecl
#else
#   define JPH_API_CALL
#endif

#define JPH_CAPI _JPH_EXTERN _JPH_EXPORT

#include <stdbool.h>
#include <stdint.h>
#include <stddef.h>

#define JPH_DEFAULT_COLLISION_TOLERANCE (1.0e-4f) // float cDefaultCollisionTolerance = 1.0e-4f
#define JPH_DEFAULT_PENETRATION_TOLERANCE (1.0e-4f) // float cDefaultPenetrationTolerance = 1.0e-4f
#define JPH_DEFAULT_CONVEX_RADIUS (0.05f) // float cDefaultConvexRadius = 0.05f
#define JPH_CAPSULE_PROJECTION_SLOP (0.02f) // float cCapsuleProjectionSlop = 0.02f
#define JPH_MAX_PHYSICS_JOBS (2048) // int cMaxPhysicsJobs = 2048
#define JPH_MAX_PHYSICS_BARRIERS (8) // int cMaxPhysicsBarriers = 8
#define JPH_INVALID_COLLISION_GROUP_ID (~0U)
#define JPH_INVALID_COLLISION_SUBGROUP_ID (~0U)
#define JPH_M_PI (3.14159265358979323846f) // To avoid collision with JPH_PI

typedef uint32_t JPH_Bool;
typedef uint32_t JPH_BodyID;
typedef uint32_t JPH_SubShapeID;
typedef uint32_t JPH_ObjectLayer;
typedef uint8_t  JPH_BroadPhaseLayer;
typedef uint32_t JPH_CollisionGroupID;
typedef uint32_t JPH_CollisionSubGroupID;
typedef uint32_t JPH_CharacterID;

/* Forward declarations */
typedef struct JPH_BroadPhaseLayerInterface				JPH_BroadPhaseLayerInterface;
typedef struct JPH_ObjectVsBroadPhaseLayerFilter		JPH_ObjectVsBroadPhaseLayerFilter;
typedef struct JPH_ObjectLayerPairFilter				JPH_ObjectLayerPairFilter;

typedef struct JPH_BroadPhaseLayerFilter				JPH_BroadPhaseLayerFilter;
typedef struct JPH_ObjectLayerFilter					JPH_ObjectLayerFilter;
typedef struct JPH_BodyFilter							JPH_BodyFilter;
typedef struct JPH_ShapeFilter							JPH_ShapeFilter;

typedef struct JPH_SimShapeFilter						JPH_SimShapeFilter;

typedef struct JPH_PhysicsStepListener					JPH_PhysicsStepListener;
typedef struct JPH_PhysicsSystem						JPH_PhysicsSystem;
typedef struct JPH_PhysicsMaterial						JPH_PhysicsMaterial;

typedef struct JPH_LinearCurve							JPH_LinearCurve;

/* ShapeSettings */
typedef struct JPH_ShapeSettings						JPH_ShapeSettings;
typedef struct JPH_ConvexShapeSettings					JPH_ConvexShapeSettings;
typedef struct JPH_SphereShapeSettings					JPH_SphereShapeSettings;
typedef struct JPH_BoxShapeSettings						JPH_BoxShapeSettings;
typedef struct JPH_PlaneShapeSettings					JPH_PlaneShapeSettings;
typedef struct JPH_TriangleShapeSettings				JPH_TriangleShapeSettings;
typedef struct JPH_CapsuleShapeSettings					JPH_CapsuleShapeSettings;
typedef struct JPH_TaperedCapsuleShapeSettings			JPH_TaperedCapsuleShapeSettings;
typedef struct JPH_CylinderShapeSettings				JPH_CylinderShapeSettings;
typedef struct JPH_TaperedCylinderShapeSettings			JPH_TaperedCylinderShapeSettings;
typedef struct JPH_ConvexHullShapeSettings				JPH_ConvexHullShapeSettings;
typedef struct JPH_CompoundShapeSettings				JPH_CompoundShapeSettings;
typedef struct JPH_StaticCompoundShapeSettings			JPH_StaticCompoundShapeSettings;
typedef struct JPH_MutableCompoundShapeSettings			JPH_MutableCompoundShapeSettings;
typedef struct JPH_MeshShapeSettings					JPH_MeshShapeSettings;
typedef struct JPH_HeightFieldShapeSettings				JPH_HeightFieldShapeSettings;
typedef struct JPH_RotatedTranslatedShapeSettings		JPH_RotatedTranslatedShapeSettings;
typedef struct JPH_ScaledShapeSettings					JPH_ScaledShapeSettings;
typedef struct JPH_OffsetCenterOfMassShapeSettings		JPH_OffsetCenterOfMassShapeSettings;
typedef struct JPH_EmptyShapeSettings					JPH_EmptyShapeSettings;

/* Shape */
typedef struct JPH_Shape								JPH_Shape;
typedef struct JPH_ConvexShape							JPH_ConvexShape;
typedef struct JPH_SphereShape							JPH_SphereShape;
typedef struct JPH_BoxShape								JPH_BoxShape;
typedef struct JPH_PlaneShape							JPH_PlaneShape;
typedef struct JPH_CapsuleShape							JPH_CapsuleShape;
typedef struct JPH_CylinderShape						JPH_CylinderShape;
typedef struct JPH_TaperedCylinderShape					JPH_TaperedCylinderShape;
typedef struct JPH_TriangleShape						JPH_TriangleShape;
typedef struct JPH_TaperedCapsuleShape					JPH_TaperedCapsuleShape;
typedef struct JPH_ConvexHullShape						JPH_ConvexHullShape;
typedef struct JPH_CompoundShape						JPH_CompoundShape;
typedef struct JPH_StaticCompoundShape					JPH_StaticCompoundShape;
typedef struct JPH_MutableCompoundShape					JPH_MutableCompoundShape;
typedef struct JPH_MeshShape							JPH_MeshShape;
typedef struct JPH_HeightFieldShape						JPH_HeightFieldShape;
typedef struct JPH_DecoratedShape						JPH_DecoratedShape;
typedef struct JPH_RotatedTranslatedShape				JPH_RotatedTranslatedShape;
typedef struct JPH_ScaledShape							JPH_ScaledShape;
typedef struct JPH_OffsetCenterOfMassShape				JPH_OffsetCenterOfMassShape;
typedef struct JPH_EmptyShape							JPH_EmptyShape;

typedef struct JPH_BodyCreationSettings					JPH_BodyCreationSettings;
typedef struct JPH_SoftBodyCreationSettings				JPH_SoftBodyCreationSettings;
typedef struct JPH_BodyInterface						JPH_BodyInterface;
typedef struct JPH_BodyLockInterface					JPH_BodyLockInterface;
typedef struct JPH_BroadPhaseQuery						JPH_BroadPhaseQuery;
typedef struct JPH_NarrowPhaseQuery						JPH_NarrowPhaseQuery;
typedef struct JPH_MotionProperties						JPH_MotionProperties;
typedef struct JPH_MassProperties						JPH_MassProperties;
typedef struct JPH_Body									JPH_Body;

typedef struct JPH_CollideShapeResult					JPH_CollideShapeResult;
typedef struct JPH_ContactListener						JPH_ContactListener;
typedef struct JPH_ContactManifold						JPH_ContactManifold;

typedef struct JPH_GroupFilter							JPH_GroupFilter;
typedef struct JPH_GroupFilterTable						JPH_GroupFilterTable;  /* Inherits JPH_GroupFilter */

/* Enums */
typedef enum JPH_PhysicsUpdateError {
	JPH_PhysicsUpdateError_None = 0,
	JPH_PhysicsUpdateError_ManifoldCacheFull = 1 << 0,
	JPH_PhysicsUpdateError_BodyPairCacheFull = 1 << 1,
	JPH_PhysicsUpdateError_ContactConstraintsFull = 1 << 2,

	_JPH_PhysicsUpdateError_Count,
	_JPH_PhysicsUpdateError_Force32 = 0x7fffffff
} JPH_PhysicsUpdateError;

typedef enum JPH_BodyType {
	JPH_BodyType_Rigid = 0,
	JPH_BodyType_Soft = 1,

	_JPH_BodyType_Count,
	_JPH_BodyType_Force32 = 0x7fffffff
} JPH_BodyType;

typedef enum JPH_MotionType {
	JPH_MotionType_Static = 0,
	JPH_MotionType_Kinematic = 1,
	JPH_MotionType_Dynamic = 2,

	_JPH_MotionType_Count,
	_JPH_MotionType_Force32 = 0x7fffffff
} JPH_MotionType;

typedef enum JPH_Activation
{
	JPH_Activation_Activate = 0,
	JPH_Activation_DontActivate = 1,

	_JPH_Activation_Count,
	_JPH_Activation_Force32 = 0x7fffffff
} JPH_Activation;

typedef enum JPH_ValidateResult {
	JPH_ValidateResult_AcceptAllContactsForThisBodyPair = 0,
	JPH_ValidateResult_AcceptContact = 1,
	JPH_ValidateResult_RejectContact = 2,
	JPH_ValidateResult_RejectAllContactsForThisBodyPair = 3,

	_JPH_ValidateResult_Count,
	_JPH_ValidateResult_Force32 = 0x7fffffff
} JPH_ValidateResult;

typedef enum JPH_ShapeType {
	JPH_ShapeType_Convex = 0,
	JPH_ShapeType_Compound = 1,
	JPH_ShapeType_Decorated = 2,
	JPH_ShapeType_Mesh = 3,
	JPH_ShapeType_HeightField = 4,
	JPH_ShapeType_SoftBody = 5,

	JPH_ShapeType_User1 = 6,
	JPH_ShapeType_User2 = 7,
	JPH_ShapeType_User3 = 8,
	JPH_ShapeType_User4 = 9,

	_JPH_ShapeType_Count,
	_JPH_ShapeType_Force32 = 0x7fffffff
} JPH_ShapeType;

typedef enum JPH_ShapeSubType {
	JPH_ShapeSubType_Sphere = 0,
	JPH_ShapeSubType_Box = 1,
	JPH_ShapeSubType_Triangle = 2,
	JPH_ShapeSubType_Capsule = 3,
	JPH_ShapeSubType_TaperedCapsule = 4,
	JPH_ShapeSubType_Cylinder = 5,
	JPH_ShapeSubType_ConvexHull = 6,
	JPH_ShapeSubType_StaticCompound = 7,
	JPH_ShapeSubType_MutableCompound = 8,
	JPH_ShapeSubType_RotatedTranslated = 9,
	JPH_ShapeSubType_Scaled = 10,
	JPH_ShapeSubType_OffsetCenterOfMass = 11,
	JPH_ShapeSubType_Mesh = 12,
	JPH_ShapeSubType_HeightField = 13,
	JPH_ShapeSubType_SoftBody = 14,

	_JPH_ShapeSubType_Count,
	_JPH_ShapeSubType_Force32 = 0x7fffffff
} JPH_ShapeSubType;

typedef enum JPH_ConstraintType {
	JPH_ConstraintType_Constraint = 0,
	JPH_ConstraintType_TwoBodyConstraint = 1,

	_JPH_ConstraintType_Count,
	_JPH_ConstraintType_Force32 = 0x7fffffff
} JPH_ConstraintType;

typedef enum JPH_ConstraintSubType {
	JPH_ConstraintSubType_Fixed = 0,
	JPH_ConstraintSubType_Point = 1,
	JPH_ConstraintSubType_Hinge = 2,
	JPH_ConstraintSubType_Slider = 3,
	JPH_ConstraintSubType_Distance = 4,
	JPH_ConstraintSubType_Cone = 5,
	JPH_ConstraintSubType_SwingTwist = 6,
	JPH_ConstraintSubType_SixDOF = 7,
	JPH_ConstraintSubType_Path = 8,
	JPH_ConstraintSubType_Vehicle = 9,
	JPH_ConstraintSubType_RackAndPinion = 10,
	JPH_ConstraintSubType_Gear = 11,
	JPH_ConstraintSubType_Pulley = 12,

	JPH_ConstraintSubType_User1 = 13,
	JPH_ConstraintSubType_User2 = 14,
	JPH_ConstraintSubType_User3 = 15,
	JPH_ConstraintSubType_User4 = 16,

	_JPH_ConstraintSubType_Count,
	_JPH_ConstraintSubType_Force32 = 0x7fffffff
} JPH_ConstraintSubType;

typedef enum JPH_ConstraintSpace {
	JPH_ConstraintSpace_LocalToBodyCOM = 0,
	JPH_ConstraintSpace_WorldSpace = 1,

	_JPH_ConstraintSpace_Count,
	_JPH_ConstraintSpace_Force32 = 0x7fffffff
} JPH_ConstraintSpace;

typedef enum JPH_MotionQuality {
	JPH_MotionQuality_Discrete = 0,
	JPH_MotionQuality_LinearCast = 1,

	_JPH_MotionQuality_Count,
	_JPH_MotionQuality_Force32 = 0x7fffffff
} JPH_MotionQuality;

typedef enum JPH_OverrideMassProperties {
	JPH_OverrideMassProperties_CalculateMassAndInertia,
	JPH_OverrideMassProperties_CalculateInertia,
	JPH_OverrideMassProperties_MassAndInertiaProvided,

	_JPH_JPH_OverrideMassProperties_Count,
	_JPH_JPH_OverrideMassProperties_Force32 = 0x7FFFFFFF
} JPH_OverrideMassProperties;

typedef enum JPH_AllowedDOFs {
	JPH_AllowedDOFs_All = 0b111111,
	JPH_AllowedDOFs_TranslationX = 0b000001,
	JPH_AllowedDOFs_TranslationY = 0b000010,
	JPH_AllowedDOFs_TranslationZ = 0b000100,
	JPH_AllowedDOFs_RotationX = 0b001000,
	JPH_AllowedDOFs_RotationY = 0b010000,
	JPH_AllowedDOFs_RotationZ = 0b100000,
	JPH_AllowedDOFs_Plane2D = JPH_AllowedDOFs_TranslationX | JPH_AllowedDOFs_TranslationY | JPH_AllowedDOFs_RotationZ,

	_JPH_AllowedDOFs_Count,
	_JPH_AllowedDOFs_Force32 = 0x7FFFFFFF
} JPH_AllowedDOFs;

typedef enum JPH_GroundState {
	JPH_GroundState_OnGround = 0,
	JPH_GroundState_OnSteepGround = 1,
	JPH_GroundState_NotSupported = 2,
	JPH_GroundState_InAir = 3,

	_JPH_GroundState_Count,
	_JPH_GroundState_Force32 = 0x7FFFFFFF
} JPH_GroundState;

typedef enum JPH_BackFaceMode {
	JPH_BackFaceMode_IgnoreBackFaces,
	JPH_BackFaceMode_CollideWithBackFaces,

	_JPH_BackFaceMode_Count,
	_JPH_BackFaceMode_Force32 = 0x7FFFFFFF
} JPH_BackFaceMode;

typedef enum JPH_ActiveEdgeMode {
	JPH_ActiveEdgeMode_CollideOnlyWithActive,
	JPH_ActiveEdgeMode_CollideWithAll,

	_JPH_ActiveEdgeMode_Count,
	_JPH_ActiveEdgeMode_Force32 = 0x7FFFFFFF
} JPH_ActiveEdgeMode;

typedef enum JPH_CollectFacesMode {
	JPH_CollectFacesMode_CollectFaces,
	JPH_CollectFacesMode_NoFaces,

	_JPH_CollectFacesMode_Count,
	_JPH_CollectFacesMode_Force32 = 0x7FFFFFFF
} JPH_CollectFacesMode;

typedef enum JPH_MotorState {
	JPH_MotorState_Off = 0,
	JPH_MotorState_Velocity = 1,
	JPH_MotorState_Position = 2,

	_JPH_MotorState_Count,
	_JPH_MotorState_Force32 = 0x7FFFFFFF
} JPH_MotorState;

typedef enum JPH_CollisionCollectorType {
	JPH_CollisionCollectorType_AllHit = 0,
	JPH_CollisionCollectorType_AllHitSorted = 1,
	JPH_CollisionCollectorType_ClosestHit = 2,
	JPH_CollisionCollectorType_AnyHit = 3,

	_JPH_CollisionCollectorType_Count,
	_JPH_CollisionCollectorType_Force32 = 0x7FFFFFFF
} JPH_CollisionCollectorType;

typedef enum JPH_SwingType {
	JPH_SwingType_Cone,
	JPH_SwingType_Pyramid,

	_JPH_SwingType_Count,
	_JPH_SwingType_Force32 = 0x7FFFFFFF
} JPH_SwingType;

typedef enum JPH_SixDOFConstraintAxis {
	JPH_SixDOFConstraintAxis_TranslationX,
	JPH_SixDOFConstraintAxis_TranslationY,
	JPH_SixDOFConstraintAxis_TranslationZ,

	JPH_SixDOFConstraintAxis_RotationX,
	JPH_SixDOFConstraintAxis_RotationY,
	JPH_SixDOFConstraintAxis_RotationZ,

	_JPH_SixDOFConstraintAxis_Num,
	_JPH_SixDOFConstraintAxis_NumTranslation = JPH_SixDOFConstraintAxis_TranslationZ + 1,
	_JPH_SixDOFConstraintAxis_Force32 = 0x7FFFFFFF
} JPH_SixDOFConstraintAxis;

typedef enum JPH_SpringMode {
	JPH_SpringMode_FrequencyAndDamping = 0,
	JPH_SpringMode_StiffnessAndDamping = 1,

	_JPH_SpringMode_Count,
	_JPH_SpringMode_Force32 = 0x7FFFFFFF
} JPH_SpringMode;

/// Defines how to color soft body constraints
typedef enum JPH_SoftBodyConstraintColor
{
	JPH_SoftBodyConstraintColor_ConstraintType,				/// Draw different types of constraints in different colors
	JPH_SoftBodyConstraintColor_ConstraintGroup,			/// Draw constraints in the same group in the same color, non-parallel group will be red
	JPH_SoftBodyConstraintColor_ConstraintOrder,			/// Draw constraints in the same group in the same color, non-parallel group will be red, and order within each group will be indicated with gradient

	_JPH_SoftBodyConstraintColor_Count,
	_JPH_SoftBodyConstraintColor_Force32 = 0x7FFFFFFF
} JPH_SoftBodyConstraintColor;

typedef enum JPH_BodyManager_ShapeColor
{
	JPH_BodyManager_ShapeColor_InstanceColor,				///< Random color per instance
	JPH_BodyManager_ShapeColor_ShapeTypeColor,				///< Convex = green, scaled = yellow, compound = orange, mesh = red
	JPH_BodyManager_ShapeColor_MotionTypeColor,			///< Static = grey, keyframed = green, dynamic = random color per instance
	JPH_BodyManager_ShapeColor_SleepColor,					///< Static = grey, keyframed = green, dynamic = yellow, sleeping = red
	JPH_BodyManager_ShapeColor_IslandColor,				///< Static = grey, active = random color per island, sleeping = light grey
	JPH_BodyManager_ShapeColor_MaterialColor,				///< Color as defined by the PhysicsMaterial of the shape

	_JPH_BodyManager_ShapeColor_Count,
	_JPH_BodyManager_ShapeColor_Force32 = 0x7FFFFFFF
} JPH_BodyManager_ShapeColor;

typedef enum JPH_DebugRenderer_CastShadow {
	JPH_DebugRenderer_CastShadow_On = 0,    ///< This shape should cast a shadow
	JPH_DebugRenderer_CastShadow_Off = 1,   ///< This shape should not cast a shadow

	_JPH_DebugRenderer_CastShadow_Count,
	_JPH_DebugRenderer_CastShadow_Force32 = 0x7FFFFFFF
} JPH_DebugRenderer_CastShadow;

typedef enum JPH_DebugRenderer_DrawMode {
	JPH_DebugRenderer_DrawMode_Solid = 0,       ///< Draw as a solid shape
	JPH_DebugRenderer_DrawMode_Wireframe = 1,   ///< Draw as wireframe

	_JPH_DebugRenderer_DrawMode_Count,
	_JPH_DebugRenderer_DrawMode_Force32 = 0x7FFFFFFF
} JPH_DebugRenderer_DrawMode;

typedef enum JPH_Mesh_Shape_BuildQuality {
	JPH_Mesh_Shape_BuildQuality_FavorRuntimePerformance = 0,
	JPH_Mesh_Shape_BuildQuality_FavorBuildSpeed = 1,

	_JPH_Mesh_Shape_BuildQuality_Count,
	_JPH_Mesh_Shape_BuildQuality_Force32 = 0x7FFFFFFF
} JPH_Mesh_Shape_BuildQuality;

typedef enum JPH_TransmissionMode {
    JPH_TransmissionMode_Auto = 0,
    JPH_TransmissionMode_Manual = 1,

    _JPH_TransmissionMode_Count,
    _JPH_TransmissionMode_Force32 = 0x7FFFFFFF
} JPH_TransmissionMode;

typedef struct JPH_Vec3 {
	float x;
	float y;
	float z;
} JPH_Vec3;

typedef struct JPH_Vec4 {
	float x;
	float y;
	float z;
	float w;
} JPH_Vec4;

typedef struct JPH_Quat {
	float x;
	float y;
	float z;
	float w;
} JPH_Quat;

typedef struct JPH_Plane {
	JPH_Vec3 normal;
	float distance;
} JPH_Plane;

typedef struct JPH_Mat4 {
	JPH_Vec4 column[4];
} JPH_Mat4;

typedef struct JPH_Point {
	float x;
	float y;
} JPH_Point;

#if defined(JPH_DOUBLE_PRECISION)
typedef struct JPH_RVec3 {
	double x;
	double y;
	double z;
} JPH_RVec3;

typedef struct JPH_RMat4 {
	JPH_Vec4 column[3];
	JPH_RVec3 column3;
} JPH_RMat4;
#else
typedef JPH_Vec3 JPH_RVec3;
typedef JPH_Mat4 JPH_RMat4;
#endif

typedef uint32_t JPH_Color;

typedef struct JPH_AABox {
	JPH_Vec3 min;
	JPH_Vec3 max;
} JPH_AABox;

typedef struct JPH_Triangle {
	JPH_Vec3 v1;
	JPH_Vec3 v2;
	JPH_Vec3 v3;
	uint32_t materialIndex;
} JPH_Triangle;

typedef struct JPH_IndexedTriangleNoMaterial {
	uint32_t i1;
	uint32_t i2;
	uint32_t i3;
} JPH_IndexedTriangleNoMaterial;

typedef struct JPH_IndexedTriangle {
	uint32_t i1;
	uint32_t i2;
	uint32_t i3;
	uint32_t materialIndex;
	uint32_t userData;
} JPH_IndexedTriangle;

typedef struct JPH_MassProperties {
	float mass;
	JPH_Mat4 inertia;
} JPH_MassProperties;

typedef struct JPH_ContactSettings {
	float					combinedFriction;
	float					combinedRestitution;
	float					invMassScale1;
	float					invInertiaScale1;
	float					invMassScale2;
	float					invInertiaScale2;
	JPH_Bool				isSensor;
	JPH_Vec3				relativeLinearSurfaceVelocity;
	JPH_Vec3				relativeAngularSurfaceVelocity;
} JPH_ContactSettings;

typedef struct JPH_CollideSettingsBase {
	/// How active edges (edges that a moving object should bump into) are handled
	JPH_ActiveEdgeMode			activeEdgeMode/* = JPH_ActiveEdgeMode_CollideOnlyWithActive*/;

	/// If colliding faces should be collected or only the collision point
	JPH_CollectFacesMode		collectFacesMode/* = JPH_CollectFacesMode_NoFaces*/;

	/// If objects are closer than this distance, they are considered to be colliding (used for GJK) (unit: meter)
	float						collisionTolerance/* = JPH_DEFAULT_COLLISION_TOLERANCE*/;

	/// A factor that determines the accuracy of the penetration depth calculation. If the change of the squared distance is less than tolerance * current_penetration_depth^2 the algorithm will terminate. (unit: dimensionless)
	float						penetrationTolerance/* = JPH_DEFAULT_PENETRATION_TOLERANCE*/;

	/// When mActiveEdgeMode is CollideOnlyWithActive a movement direction can be provided. When hitting an inactive edge, the system will select the triangle normal as penetration depth only if it impedes the movement less than with the calculated penetration depth.
	JPH_Vec3					activeEdgeMovementDirection/* = Vec3::sZero()*/;
} JPH_CollideSettingsBase;

/* CollideShapeSettings */
typedef struct JPH_CollideShapeSettings {
	JPH_CollideSettingsBase     base;    /* Inherits JPH_CollideSettingsBase */
	/// When > 0 contacts in the vicinity of the query shape can be found. All nearest contacts that are not further away than this distance will be found (unit: meter)
	float						maxSeparationDistance/* = 0.0f*/;

	/// How backfacing triangles should be treated
	JPH_BackFaceMode			backFaceMode/* = JPH_BackFaceMode_IgnoreBackFaces*/;
} JPH_CollideShapeSettings;

/* ShapeCastSettings */
typedef struct JPH_ShapeCastSettings {
	JPH_CollideSettingsBase     base;    /* Inherits JPH_CollideSettingsBase */

	/// How backfacing triangles should be treated (should we report moving from back to front for triangle based shapes, e.g. for MeshShape/HeightFieldShape?)
	JPH_BackFaceMode			backFaceModeTriangles/* = JPH_BackFaceMode_IgnoreBackFaces*/;

	/// How backfacing convex objects should be treated (should we report starting inside an object and moving out?)
	JPH_BackFaceMode			backFaceModeConvex/* = JPH_BackFaceMode_IgnoreBackFaces*/;

	/// Indicates if we want to shrink the shape by the convex radius and then expand it again. This speeds up collision detection and gives a more accurate normal at the cost of a more 'rounded' shape.
	bool						useShrunkenShapeAndConvexRadius/* = false*/;

	/// When true, and the shape is intersecting at the beginning of the cast (fraction = 0) then this will calculate the deepest penetration point (costing additional CPU time)
	bool						returnDeepestPoint/* = false*/;
} JPH_ShapeCastSettings;

typedef struct JPH_RayCastSettings {
	/// How backfacing triangles should be treated (should we report back facing hits for triangle based shapes, e.g. MeshShape/HeightFieldShape?)
	JPH_BackFaceMode backFaceModeTriangles/* = JPH_BackFaceMode_IgnoreBackFaces*/;

	/// How backfacing convex objects should be treated (should we report back facing hits for convex shapes?)
	JPH_BackFaceMode backFaceModeConvex/* = JPH_BackFaceMode_IgnoreBackFaces*/;

	/// If convex shapes should be treated as solid. When true, a ray starting inside a convex shape will generate a hit at fraction 0.
	bool treatConvexAsSolid/* = true*/;
} JPH_RayCastSettings;

typedef struct JPH_SpringSettings {
	JPH_SpringMode mode;
	float frequencyOrStiffness;
	float damping;
} JPH_SpringSettings;

typedef struct JPH_MotorSettings {
	JPH_SpringSettings springSettings;
	float minForceLimit;
	float maxForceLimit;
	float minTorqueLimit;
	float maxTorqueLimit;
} JPH_MotorSettings;

typedef struct JPH_SubShapeIDPair {
	JPH_BodyID     Body1ID;
	JPH_SubShapeID subShapeID1;
	JPH_BodyID     Body2ID;
	JPH_SubShapeID subShapeID2;
} JPH_SubShapeIDPair;

typedef struct JPH_BroadPhaseCastResult {
	JPH_BodyID     bodyID;
	float          fraction;
} JPH_BroadPhaseCastResult;

typedef struct JPH_RayCastResult {
	JPH_BodyID     bodyID;
	float          fraction;
	JPH_SubShapeID subShapeID2;
} JPH_RayCastResult;

typedef struct JPH_CollidePointResult {
	JPH_BodyID bodyID;
	JPH_SubShapeID subShapeID2;
} JPH_CollidePointResult;

typedef struct JPH_CollideShapeResult {
	JPH_Vec3		contactPointOn1;
	JPH_Vec3		contactPointOn2;
	JPH_Vec3		penetrationAxis;
	float			penetrationDepth;
	JPH_SubShapeID	subShapeID1;
	JPH_SubShapeID	subShapeID2;
	JPH_BodyID		bodyID2;
	uint32_t		shape1FaceCount;
	JPH_Vec3*		shape1Faces;
	uint32_t		shape2FaceCount;
	JPH_Vec3*		shape2Faces;
} JPH_CollideShapeResult;

typedef struct JPH_ShapeCastResult {
	JPH_Vec3           contactPointOn1;
	JPH_Vec3           contactPointOn2;
	JPH_Vec3           penetrationAxis;
	float              penetrationDepth;
	JPH_SubShapeID     subShapeID1;
	JPH_SubShapeID     subShapeID2;
	JPH_BodyID         bodyID2;
	float              fraction;
	bool			   isBackFaceHit;
} JPH_ShapeCastResult;

typedef struct JPH_DrawSettings {
	bool						drawGetSupportFunction;				///< Draw the GetSupport() function, used for convex collision detection
	bool						drawSupportDirection;				///< When drawing the support function, also draw which direction mapped to a specific support point
	bool						drawGetSupportingFace;				///< Draw the faces that were found colliding during collision detection
	bool						drawShape;							///< Draw the shapes of all bodies
	bool						drawShapeWireframe;					///< When mDrawShape is true and this is true, the shapes will be drawn in wireframe instead of solid.
	JPH_BodyManager_ShapeColor	drawShapeColor;                     ///< Coloring scheme to use for shapes
	bool						drawBoundingBox;					///< Draw a bounding box per body
	bool						drawCenterOfMassTransform;			///< Draw the center of mass for each body
	bool						drawWorldTransform;					///< Draw the world transform (which may differ from its center of mass) of each body
	bool						drawVelocity;						///< Draw the velocity vector for each body
	bool						drawMassAndInertia;					///< Draw the mass and inertia (as the box equivalent) for each body
	bool						drawSleepStats;						///< Draw stats regarding the sleeping algorithm of each body
	bool						drawSoftBodyVertices;				///< Draw the vertices of soft bodies
	bool						drawSoftBodyVertexVelocities;		///< Draw the velocities of the vertices of soft bodies
	bool						drawSoftBodyEdgeConstraints;		///< Draw the edge constraints of soft bodies
	bool						drawSoftBodyBendConstraints;		///< Draw the bend constraints of soft bodies
	bool						drawSoftBodyVolumeConstraints;		///< Draw the volume constraints of soft bodies
	bool						drawSoftBodySkinConstraints;		///< Draw the skin constraints of soft bodies
	bool						drawSoftBodyLRAConstraints;	        ///< Draw the LRA constraints of soft bodies
	bool						drawSoftBodyPredictedBounds;		///< Draw the predicted bounds of soft bodies
	JPH_SoftBodyConstraintColor	drawSoftBodyConstraintColor;        ///< Coloring scheme to use for soft body constraints
} JPH_DrawSettings;

typedef struct JPH_SupportingFace {
    uint32_t count;
    JPH_Vec3 vertices[32];
} JPH_SupportingFace;

typedef struct JPH_CollisionGroup {
	const JPH_GroupFilter*	groupFilter;
	JPH_CollisionGroupID	groupID;
	JPH_CollisionSubGroupID	subGroupID;
} JPH_CollisionGroup;

typedef void JPH_CastRayResultCallback(void* context, const JPH_RayCastResult* result);
typedef void JPH_RayCastBodyResultCallback(void* context, const JPH_BroadPhaseCastResult* result);
typedef void JPH_CollideShapeBodyResultCallback(void* context, const JPH_BodyID result);
typedef void JPH_CollidePointResultCallback(void* context, const JPH_CollidePointResult* result);
typedef void JPH_CollideShapeResultCallback(void* context, const JPH_CollideShapeResult* result);
typedef void JPH_CastShapeResultCallback(void* context, const JPH_ShapeCastResult* result);

typedef float JPH_CastRayCollectorCallback(void* context, const JPH_RayCastResult* result);
typedef float JPH_RayCastBodyCollectorCallback(void* context, const JPH_BroadPhaseCastResult* result);
typedef float JPH_CollideShapeBodyCollectorCallback(void* context, const JPH_BodyID result);
typedef float JPH_CollidePointCollectorCallback(void* context, const JPH_CollidePointResult* result);
typedef float JPH_CollideShapeCollectorCallback(void* context, const JPH_CollideShapeResult* result);
typedef float JPH_CastShapeCollectorCallback(void* context, const JPH_ShapeCastResult* result);

typedef struct JPH_CollisionEstimationResultImpulse {
	float	contactImpulse;
	float	frictionImpulse1;
	float	frictionImpulse2;
} JPH_CollisionEstimationResultImpulse;

typedef struct JPH_CollisionEstimationResult {
	JPH_Vec3								linearVelocity1;
	JPH_Vec3								angularVelocity1;
	JPH_Vec3								linearVelocity2;
	JPH_Vec3								angularVelocity2;

	JPH_Vec3								tangent1;
	JPH_Vec3								tangent2;

	uint32_t								impulseCount;
	JPH_CollisionEstimationResultImpulse*	impulses;
} JPH_CollisionEstimationResult;

typedef struct JPH_BodyActivationListener           JPH_BodyActivationListener;
typedef struct JPH_BodyDrawFilter                   JPH_BodyDrawFilter;

typedef struct JPH_SharedMutex                      JPH_SharedMutex;

typedef struct JPH_DebugRenderer                    JPH_DebugRenderer;

/* Constraint */
typedef struct JPH_Constraint                       JPH_Constraint;
typedef struct JPH_TwoBodyConstraint                JPH_TwoBodyConstraint;
typedef struct JPH_FixedConstraint                  JPH_FixedConstraint;
typedef struct JPH_DistanceConstraint               JPH_DistanceConstraint;
typedef struct JPH_PointConstraint                  JPH_PointConstraint;
typedef struct JPH_HingeConstraint                  JPH_HingeConstraint;
typedef struct JPH_SliderConstraint                 JPH_SliderConstraint;
typedef struct JPH_ConeConstraint                   JPH_ConeConstraint;
typedef struct JPH_SwingTwistConstraint             JPH_SwingTwistConstraint;
typedef struct JPH_SixDOFConstraint				    JPH_SixDOFConstraint;
typedef struct JPH_GearConstraint				    JPH_GearConstraint;

/* Character, CharacterVirtual */
typedef struct JPH_CharacterBase					JPH_CharacterBase;
typedef struct JPH_Character						JPH_Character;  /* Inherits JPH_CharacterBase */
typedef struct JPH_CharacterVirtual                 JPH_CharacterVirtual;  /* Inherits JPH_CharacterBase */
typedef struct JPH_CharacterContactListener			JPH_CharacterContactListener;
typedef struct JPH_CharacterVsCharacterCollision	JPH_CharacterVsCharacterCollision;

/* Skeleton/Ragdoll */
typedef struct JPH_Skeleton							JPH_Skeleton;
typedef struct JPH_SkeletonPose						JPH_SkeletonPose;
typedef struct JPH_SkeletalAnimation				JPH_SkeletalAnimation;
typedef struct JPH_SkeletonMapper					JPH_SkeletonMapper;
typedef struct JPH_RagdollSettings					JPH_RagdollSettings;
typedef struct JPH_Ragdoll							JPH_Ragdoll;

typedef struct JPH_ConstraintSettings {
	bool						enabled;
	uint32_t					constraintPriority;
	uint32_t					numVelocityStepsOverride;
	uint32_t					numPositionStepsOverride;
	float						drawConstraintSize;
	uint64_t					userData;
} JPH_ConstraintSettings;

typedef struct JPH_FixedConstraintSettings {
	JPH_ConstraintSettings		base;    /* Inherits JPH_ConstraintSettings */

	JPH_ConstraintSpace			space;
	bool						autoDetectPoint;
	JPH_RVec3					point1;
	JPH_Vec3					axisX1;
	JPH_Vec3					axisY1;
	JPH_RVec3					point2;
	JPH_Vec3					axisX2;
	JPH_Vec3					axisY2;
} JPH_FixedConstraintSettings;

typedef struct JPH_DistanceConstraintSettings {
	JPH_ConstraintSettings		base;    /* Inherits JPH_ConstraintSettings */

	JPH_ConstraintSpace			space;
	JPH_RVec3					point1;
	JPH_RVec3					point2;
	float						minDistance;
	float						maxDistance;
	JPH_SpringSettings			limitsSpringSettings;
} JPH_DistanceConstraintSettings;

typedef struct JPH_PointConstraintSettings {
	JPH_ConstraintSettings		base;    /* Inherits JPH_ConstraintSettings */

	JPH_ConstraintSpace			space;
	JPH_RVec3					point1;
	JPH_RVec3					point2;
} JPH_PointConstraintSettings;

typedef struct JPH_HingeConstraintSettings {
	JPH_ConstraintSettings		base;    /* Inherits JPH_ConstraintSettings */

	JPH_ConstraintSpace			space;
	JPH_RVec3					point1;
	JPH_Vec3					hingeAxis1;
	JPH_Vec3					normalAxis1;
	JPH_RVec3					point2;
	JPH_Vec3					hingeAxis2;
	JPH_Vec3					normalAxis2;
	float						limitsMin;
	float						limitsMax;
	JPH_SpringSettings			limitsSpringSettings;
	float						maxFrictionTorque;
	JPH_MotorSettings			motorSettings;
} JPH_HingeConstraintSettings;

typedef struct JPH_SliderConstraintSettings {
	JPH_ConstraintSettings		base;    /* Inherits JPH_ConstraintSettings */

	JPH_ConstraintSpace			space;
	bool						autoDetectPoint;
	JPH_RVec3					point1;
	JPH_Vec3					sliderAxis1;
	JPH_Vec3					normalAxis1;
	JPH_RVec3					point2;
	JPH_Vec3					sliderAxis2;
	JPH_Vec3					normalAxis2;
	float						limitsMin;
	float						limitsMax;
	JPH_SpringSettings			limitsSpringSettings;
	float						maxFrictionForce;
	JPH_MotorSettings			motorSettings;
} JPH_SliderConstraintSettings;

typedef struct JPH_ConeConstraintSettings {
	JPH_ConstraintSettings		base;    /* Inherits JPH_ConstraintSettings */

	JPH_ConstraintSpace			space;
	JPH_RVec3					point1;
	JPH_Vec3					twistAxis1;
	JPH_RVec3					point2;
	JPH_Vec3					twistAxis2;
	float						halfConeAngle;
} JPH_ConeConstraintSettings;

typedef struct JPH_SwingTwistConstraintSettings {
	JPH_ConstraintSettings		base;    /* Inherits JPH_ConstraintSettings */

	JPH_ConstraintSpace			space;
	JPH_RVec3					position1;
	JPH_Vec3					twistAxis1;
	JPH_Vec3					planeAxis1;
	JPH_RVec3					position2;
	JPH_Vec3					twistAxis2;
	JPH_Vec3					planeAxis2;
	JPH_SwingType				swingType;
	float						normalHalfConeAngle;
	float						planeHalfConeAngle;
	float						twistMinAngle;
	float						twistMaxAngle;
	float						maxFrictionTorque;
	JPH_MotorSettings			swingMotorSettings;
	JPH_MotorSettings			twistMotorSettings;
} JPH_SwingTwistConstraintSettings;

typedef struct JPH_SixDOFConstraintSettings {
	JPH_ConstraintSettings		base;    /* Inherits JPH_ConstraintSettings */

	JPH_ConstraintSpace			space;
	JPH_RVec3					position1;
	JPH_Vec3					axisX1;
	JPH_Vec3					axisY1;
	JPH_RVec3					position2;
	JPH_Vec3					axisX2;
	JPH_Vec3					axisY2;
	float						maxFriction[_JPH_SixDOFConstraintAxis_Num];
	JPH_SwingType				swingType;
	float						limitMin[_JPH_SixDOFConstraintAxis_Num];
	float						limitMax[_JPH_SixDOFConstraintAxis_Num];

	JPH_SpringSettings			limitsSpringSettings[_JPH_SixDOFConstraintAxis_NumTranslation];
	JPH_MotorSettings			motorSettings[_JPH_SixDOFConstraintAxis_Num];
} JPH_SixDOFConstraintSettings;

typedef struct JPH_GearConstraintSettings {
	JPH_ConstraintSettings		base;    /* Inherits JPH_ConstraintSettings */

	JPH_ConstraintSpace			space;
	JPH_Vec3					hingeAxis1;
	JPH_Vec3					hingeAxis2;
	float						ratio;
} JPH_GearConstraintSettings;

typedef struct JPH_BodyLockRead {
	const JPH_BodyLockInterface* lockInterface;
	JPH_SharedMutex* mutex;
	const JPH_Body* body;
} JPH_BodyLockRead;

typedef struct JPH_BodyLockWrite {
	const JPH_BodyLockInterface* lockInterface;
	JPH_SharedMutex* mutex;
	JPH_Body* body;
} JPH_BodyLockWrite;

typedef struct JPH_BodyLockMultiRead JPH_BodyLockMultiRead;
typedef struct JPH_BodyLockMultiWrite JPH_BodyLockMultiWrite;

typedef struct JPH_ExtendedUpdateSettings {
	JPH_Vec3	stickToFloorStepDown;
	JPH_Vec3	walkStairsStepUp;
	float		walkStairsMinStepForward;
	float		walkStairsStepForwardTest;
	float		walkStairsCosAngleForwardContact;
	JPH_Vec3	walkStairsStepDownExtra;
} JPH_ExtendedUpdateSettings;

typedef struct JPH_CharacterBaseSettings {
	JPH_Vec3 up;
	JPH_Plane supportingVolume;
	float maxSlopeAngle;
	bool enhancedInternalEdgeRemoval;
	const JPH_Shape* shape;
} JPH_CharacterBaseSettings;

/* Character */
typedef struct JPH_CharacterSettings {
	JPH_CharacterBaseSettings       base;    /* Inherits JPH_CharacterBaseSettings */
	JPH_ObjectLayer					layer;
	float							mass;
	float							friction;
	float							gravityFactor;
	JPH_AllowedDOFs                 allowedDOFs;
} JPH_CharacterSettings;

/* CharacterVirtual */
typedef struct JPH_CharacterVirtualSettings {
	JPH_CharacterBaseSettings           base;    /* Inherits JPH_CharacterBaseSettings */
	JPH_CharacterID						ID;
	float								mass;
	float								maxStrength;
	JPH_Vec3							shapeOffset;
	JPH_BackFaceMode					backFaceMode;
	float								predictiveContactDistance;
	uint32_t							maxCollisionIterations;
	uint32_t							maxConstraintIterations;
	float								minTimeRemaining;
	float								collisionTolerance;
	float								characterPadding;
	uint32_t							maxNumHits;
	float								hitReductionCosMaxAngle;
	float								penetrationRecoverySpeed;
	const JPH_Shape*					innerBodyShape;
	JPH_BodyID							innerBodyIDOverride;
	JPH_ObjectLayer						innerBodyLayer;
} JPH_CharacterVirtualSettings;

typedef struct JPH_CharacterContactSettings {
	bool canPushCharacter;
	bool canReceiveImpulses;
} JPH_CharacterContactSettings;

typedef struct JPH_CharacterVirtualContact {
	uint64_t						hash;
	JPH_BodyID						bodyB;
	JPH_CharacterID					characterIDB;
	JPH_SubShapeID					subShapeIDB;
	JPH_RVec3						position;
	JPH_Vec3						linearVelocity;
	JPH_Vec3						contactNormal;
	JPH_Vec3						surfaceNormal;
	float							distance;
	float							fraction;
	JPH_MotionType					motionTypeB;
	bool							isSensorB;
	const JPH_CharacterVirtual*		characterB;
	uint64_t						userData;
	const JPH_PhysicsMaterial*		material;
	bool							hadCollision;
	bool							wasDiscarded;
	bool							canPushCharacter;
} JPH_CharacterVirtualContact;

typedef void(JPH_API_CALL* JPH_TraceFunc)(const char* message);
typedef bool(JPH_API_CALL* JPH_AssertFailureFunc)(const char* expression, const char* message, const char* file, uint32_t line);

typedef void JPH_JobFunction(void* arg);
typedef void JPH_QueueJobCallback(void* context, JPH_JobFunction* job, void* arg);
typedef void JPH_QueueJobsCallback(void* context, JPH_JobFunction* job, void** args, uint32_t count);

typedef struct JobSystemThreadPoolConfig {
	uint32_t maxJobs;
	uint32_t maxBarriers;
	int32_t numThreads;
} JobSystemThreadPoolConfig;

typedef struct JPH_JobSystemConfig {
	void* context;
	JPH_QueueJobCallback* queueJob;
	JPH_QueueJobsCallback* queueJobs;
	uint32_t maxConcurrency;
	uint32_t maxBarriers;
} JPH_JobSystemConfig;

typedef struct JPH_JobSystem JPH_JobSystem;

/* Calculate max tire impulses by combining friction, slip, and suspension impulse. Note that the actual applied impulse may be lower (e.g. when the vehicle is stationary on a horizontal surface the actual impulse applied will be 0) */
typedef void (JPH_API_CALL* JPH_TireMaxImpulseCallback)(
	void* userData,
	uint32_t wheelIndex, 
	float* outLongitudinalImpulse,
	float* outLateralImpulse, 
	float suspensionImpulse,
	float longitudinalFriction,
	float lateralFriction,
	float longitudinalSlip,
	float lateralSlip,
	float deltaTime);

JPH_CAPI JPH_JobSystem* JPH_JobSystemThreadPool_Create(const JobSystemThreadPoolConfig* config);
JPH_CAPI JPH_JobSystem* JPH_JobSystemCallback_Create(const JPH_JobSystemConfig* config);
JPH_CAPI void JPH_JobSystem_Destroy(JPH_JobSystem* jobSystem);

JPH_CAPI bool JPH_Init(void);
JPH_CAPI void JPH_Shutdown(void);
JPH_CAPI void JPH_SetTraceHandler(JPH_TraceFunc handler);
JPH_CAPI void JPH_SetAssertFailureHandler(JPH_AssertFailureFunc handler);

/* Structs free members */
JPH_CAPI void JPH_CollideShapeResult_FreeMembers(JPH_CollideShapeResult* result);
JPH_CAPI void JPH_CollisionEstimationResult_FreeMembers(JPH_CollisionEstimationResult* result);

/* JPH_BroadPhaseLayerInterface */
JPH_CAPI JPH_BroadPhaseLayerInterface* JPH_BroadPhaseLayerInterfaceMask_Create(uint32_t numBroadPhaseLayers);
JPH_CAPI void JPH_BroadPhaseLayerInterfaceMask_ConfigureLayer(JPH_BroadPhaseLayerInterface* bpInterface, JPH_BroadPhaseLayer broadPhaseLayer, uint32_t groupsToInclude, uint32_t groupsToExclude);

JPH_CAPI JPH_BroadPhaseLayerInterface* JPH_BroadPhaseLayerInterfaceTable_Create(uint32_t numObjectLayers, uint32_t numBroadPhaseLayers);
JPH_CAPI void JPH_BroadPhaseLayerInterfaceTable_MapObjectToBroadPhaseLayer(JPH_BroadPhaseLayerInterface* bpInterface, JPH_ObjectLayer objectLayer, JPH_BroadPhaseLayer broadPhaseLayer);

/* JPH_ObjectLayerPairFilter */
JPH_CAPI JPH_ObjectLayerPairFilter* JPH_ObjectLayerPairFilterMask_Create(void);
JPH_CAPI JPH_ObjectLayer JPH_ObjectLayerPairFilterMask_GetObjectLayer(uint32_t group, uint32_t mask);
JPH_CAPI uint32_t JPH_ObjectLayerPairFilterMask_GetGroup(JPH_ObjectLayer layer);
JPH_CAPI uint32_t JPH_ObjectLayerPairFilterMask_GetMask(JPH_ObjectLayer layer);

JPH_CAPI JPH_ObjectLayerPairFilter* JPH_ObjectLayerPairFilterTable_Create(uint32_t numObjectLayers);
JPH_CAPI void JPH_ObjectLayerPairFilterTable_DisableCollision(JPH_ObjectLayerPairFilter* objectFilter, JPH_ObjectLayer layer1, JPH_ObjectLayer layer2);
JPH_CAPI void JPH_ObjectLayerPairFilterTable_EnableCollision(JPH_ObjectLayerPairFilter* objectFilter, JPH_ObjectLayer layer1, JPH_ObjectLayer layer2);
JPH_CAPI bool JPH_ObjectLayerPairFilterTable_ShouldCollide(JPH_ObjectLayerPairFilter* objectFilter, JPH_ObjectLayer layer1, JPH_ObjectLayer layer2);

/* JPH_ObjectVsBroadPhaseLayerFilter */
JPH_CAPI JPH_ObjectVsBroadPhaseLayerFilter* JPH_ObjectVsBroadPhaseLayerFilterMask_Create(const JPH_BroadPhaseLayerInterface* broadPhaseLayerInterface);

JPH_CAPI JPH_ObjectVsBroadPhaseLayerFilter* JPH_ObjectVsBroadPhaseLayerFilterTable_Create(
	JPH_BroadPhaseLayerInterface* broadPhaseLayerInterface, uint32_t numBroadPhaseLayers,
	JPH_ObjectLayerPairFilter* objectLayerPairFilter, uint32_t numObjectLayers);

JPH_CAPI void JPH_DrawSettings_InitDefault(JPH_DrawSettings* settings);

/* JPH_PhysicsSystem */
typedef struct JPH_PhysicsSystemSettings {
	uint32_t maxBodies; /* 10240 */
	uint32_t numBodyMutexes; /* 0 */
	uint32_t maxBodyPairs; /* 65536 */
	uint32_t maxContactConstraints; /* 10240 */
	uint32_t _padding;
	JPH_BroadPhaseLayerInterface* broadPhaseLayerInterface;
	JPH_ObjectLayerPairFilter* objectLayerPairFilter;
	JPH_ObjectVsBroadPhaseLayerFilter* objectVsBroadPhaseLayerFilter;
} JPH_PhysicsSystemSettings;

typedef struct JPH_PhysicsSettings {
	int maxInFlightBodyPairs;
	int stepListenersBatchSize;
	int stepListenerBatchesPerJob;
	float baumgarte;
	float speculativeContactDistance;
	float penetrationSlop;
	float linearCastThreshold;
	float linearCastMaxPenetration;
	float manifoldTolerance;
	float maxPenetrationDistance;
	float bodyPairCacheMaxDeltaPositionSq;
	float bodyPairCacheCosMaxDeltaRotationDiv2;
	float contactNormalCosMaxDeltaRotation;
	float contactPointPreserveLambdaMaxDistSq;
	uint32_t numVelocitySteps;
	uint32_t numPositionSteps;
	float minVelocityForRestitution;
	float timeBeforeSleep;
	float pointVelocitySleepThreshold;
	bool deterministicSimulation;
	bool constraintWarmStart;
	bool useBodyPairContactCache;
	bool useManifoldReduction;
	bool useLargeIslandSplitter;
	bool allowSleeping;
	bool checkActiveEdges;
} JPH_PhysicsSettings;

JPH_CAPI JPH_PhysicsSystem* JPH_PhysicsSystem_Create(const JPH_PhysicsSystemSettings* settings);
JPH_CAPI void JPH_PhysicsSystem_Destroy(JPH_PhysicsSystem* system);

JPH_CAPI void JPH_PhysicsSystem_SetPhysicsSettings(JPH_PhysicsSystem* system, JPH_PhysicsSettings* settings);
JPH_CAPI void JPH_PhysicsSystem_GetPhysicsSettings(JPH_PhysicsSystem* system, JPH_PhysicsSettings* result);

JPH_CAPI void JPH_PhysicsSystem_OptimizeBroadPhase(JPH_PhysicsSystem* system);
JPH_CAPI JPH_PhysicsUpdateError JPH_PhysicsSystem_Update(JPH_PhysicsSystem* system, float deltaTime, int collisionSteps, JPH_JobSystem* jobSystem);

JPH_CAPI JPH_BodyInterface* JPH_PhysicsSystem_GetBodyInterface(JPH_PhysicsSystem* system);
JPH_CAPI JPH_BodyInterface* JPH_PhysicsSystem_GetBodyInterfaceNoLock(JPH_PhysicsSystem* system);

JPH_CAPI const JPH_BodyLockInterface* JPH_PhysicsSystem_GetBodyLockInterface(const JPH_PhysicsSystem* system);
JPH_CAPI const JPH_BodyLockInterface* JPH_PhysicsSystem_GetBodyLockInterfaceNoLock(const JPH_PhysicsSystem* system);

JPH_CAPI const JPH_BroadPhaseQuery* JPH_PhysicsSystem_GetBroadPhaseQuery(const JPH_PhysicsSystem* system);

JPH_CAPI const JPH_NarrowPhaseQuery* JPH_PhysicsSystem_GetNarrowPhaseQuery(const JPH_PhysicsSystem* system);
JPH_CAPI const JPH_NarrowPhaseQuery* JPH_PhysicsSystem_GetNarrowPhaseQueryNoLock(const JPH_PhysicsSystem* system);

JPH_CAPI void JPH_PhysicsSystem_SetContactListener(JPH_PhysicsSystem* system, JPH_ContactListener* listener);
JPH_CAPI void JPH_PhysicsSystem_SetBodyActivationListener(JPH_PhysicsSystem* system, JPH_BodyActivationListener* listener);
JPH_CAPI void JPH_PhysicsSystem_SetSimShapeFilter(JPH_PhysicsSystem* system, const JPH_SimShapeFilter* filter);

JPH_CAPI bool JPH_PhysicsSystem_WereBodiesInContact(const JPH_PhysicsSystem* system, JPH_BodyID body1, JPH_BodyID body2);

JPH_CAPI uint32_t JPH_PhysicsSystem_GetNumBodies(const JPH_PhysicsSystem* system);
JPH_CAPI uint32_t JPH_PhysicsSystem_GetNumActiveBodies(const JPH_PhysicsSystem* system, JPH_BodyType type);
JPH_CAPI uint32_t JPH_PhysicsSystem_GetMaxBodies(const JPH_PhysicsSystem* system);
JPH_CAPI uint32_t JPH_PhysicsSystem_GetNumConstraints(const JPH_PhysicsSystem* system);

JPH_CAPI void JPH_PhysicsSystem_SetGravity(JPH_PhysicsSystem* system, const JPH_Vec3* value);
JPH_CAPI void JPH_PhysicsSystem_GetGravity(JPH_PhysicsSystem* system, JPH_Vec3* result);

JPH_CAPI void JPH_PhysicsSystem_AddConstraint(JPH_PhysicsSystem* system, JPH_Constraint* constraint);
JPH_CAPI void JPH_PhysicsSystem_RemoveConstraint(JPH_PhysicsSystem* system, JPH_Constraint* constraint);

JPH_CAPI void JPH_PhysicsSystem_AddConstraints(JPH_PhysicsSystem* system, JPH_Constraint** constraints, uint32_t count);
JPH_CAPI void JPH_PhysicsSystem_RemoveConstraints(JPH_PhysicsSystem* system, JPH_Constraint** constraints, uint32_t count);

JPH_CAPI void JPH_PhysicsSystem_AddStepListener(JPH_PhysicsSystem* system, JPH_PhysicsStepListener* listener);
JPH_CAPI void JPH_PhysicsSystem_RemoveStepListener(JPH_PhysicsSystem* system, JPH_PhysicsStepListener* listener);

JPH_CAPI void JPH_PhysicsSystem_GetBodies(const JPH_PhysicsSystem* system, JPH_BodyID* ids, uint32_t count);
JPH_CAPI void JPH_PhysicsSystem_GetConstraints(const JPH_PhysicsSystem* system, const JPH_Constraint** constraints, uint32_t count);

JPH_CAPI void JPH_PhysicsSystem_ActivateBodiesInAABox(JPH_PhysicsSystem* system, const JPH_AABox* box, JPH_ObjectLayer layer);

JPH_CAPI void JPH_PhysicsSystem_DrawBodies(JPH_PhysicsSystem* system, const JPH_DrawSettings* settings, JPH_DebugRenderer* renderer, const JPH_BodyDrawFilter* bodyFilter /* = nullptr */);
JPH_CAPI void JPH_PhysicsSystem_DrawConstraints(JPH_PhysicsSystem* system, JPH_DebugRenderer* renderer);
JPH_CAPI void JPH_PhysicsSystem_DrawConstraintLimits(JPH_PhysicsSystem* system, JPH_DebugRenderer* renderer);
JPH_CAPI void JPH_PhysicsSystem_DrawConstraintReferenceFrame(JPH_PhysicsSystem* system, JPH_DebugRenderer* renderer);

/* PhysicsStepListener */
typedef struct JPH_PhysicsStepListenerContext {
	float					deltaTime;
	JPH_Bool				isFirstStep;
	JPH_Bool				isLastStep;
	JPH_PhysicsSystem*		physicsSystem;
} JPH_PhysicsStepListenerContext;


typedef struct JPH_PhysicsStepListener_Procs {
	void(JPH_API_CALL* OnStep)(void* userData, const JPH_PhysicsStepListenerContext* context);
} JPH_PhysicsStepListener_Procs;

JPH_CAPI void JPH_PhysicsStepListener_SetProcs(const JPH_PhysicsStepListener_Procs* procs);
JPH_CAPI JPH_PhysicsStepListener* JPH_PhysicsStepListener_Create(void* userData);
JPH_CAPI void JPH_PhysicsStepListener_Destroy(JPH_PhysicsStepListener* listener);

/* Math */
JPH_CAPI float JPH_Math_Sin(float value);
JPH_CAPI float JPH_Math_Cos(float value);

JPH_CAPI void JPH_Quat_FromTo(const JPH_Vec3* from, const JPH_Vec3* to, JPH_Quat* quat);
JPH_CAPI void JPH_Quat_GetAxisAngle(const JPH_Quat* quat, JPH_Vec3* outAxis, float* outAngle);
JPH_CAPI void JPH_Quat_GetEulerAngles(const JPH_Quat* quat, JPH_Vec3* result);
JPH_CAPI void JPH_Quat_RotateAxisX(const JPH_Quat* quat, JPH_Vec3* result);
JPH_CAPI void JPH_Quat_RotateAxisY(const JPH_Quat* quat, JPH_Vec3* result);
JPH_CAPI void JPH_Quat_RotateAxisZ(const JPH_Quat* quat, JPH_Vec3* result);
JPH_CAPI void JPH_Quat_Inversed(const JPH_Quat* quat, JPH_Quat* result);
JPH_CAPI void JPH_Quat_GetPerpendicular(const JPH_Quat* quat, JPH_Quat* result);
JPH_CAPI float JPH_Quat_GetRotationAngle(const JPH_Quat* quat, const JPH_Vec3* axis);
JPH_CAPI void JPH_Quat_FromEulerAngles(const JPH_Vec3* angles, JPH_Quat* result);

JPH_CAPI void JPH_Quat_Add(const JPH_Quat* q1, const JPH_Quat* q2, JPH_Quat* result);
JPH_CAPI void JPH_Quat_Subtract(const JPH_Quat* q1, const JPH_Quat* q2, JPH_Quat* result);
JPH_CAPI void JPH_Quat_Multiply(const JPH_Quat* q1, const JPH_Quat* q2, JPH_Quat* result);
JPH_CAPI void JPH_Quat_MultiplyScalar(const JPH_Quat* q, float scalar, JPH_Quat* result);
JPH_CAPI void JPH_Quat_DivideScalar(const JPH_Quat* q, float scalar, JPH_Quat* result);
JPH_CAPI void JPH_Quat_Dot(const JPH_Quat* q1, const JPH_Quat* q2, float* result);

JPH_CAPI void JPH_Quat_Conjugated(const JPH_Quat* quat, JPH_Quat* result);
JPH_CAPI void JPH_Quat_GetTwist(const JPH_Quat* quat, const JPH_Vec3* axis, JPH_Quat* result);
JPH_CAPI void JPH_Quat_GetSwingTwist(const JPH_Quat* quat, JPH_Quat* outSwing, JPH_Quat* outTwist);
JPH_CAPI void JPH_Quat_Lerp(const JPH_Quat* from, const JPH_Quat* to, float fraction, JPH_Quat* result);
JPH_CAPI void JPH_Quat_Slerp(const JPH_Quat* from, const JPH_Quat* to, float fraction, JPH_Quat* result);
JPH_CAPI void JPH_Quat_Rotate(const JPH_Quat* quat, const JPH_Vec3* vec, JPH_Vec3* result);
JPH_CAPI void JPH_Quat_InverseRotate(const JPH_Quat* quat, const JPH_Vec3* vec, JPH_Vec3* result);

JPH_CAPI void JPH_Vec3_AxisX(JPH_Vec3* result);
JPH_CAPI void JPH_Vec3_AxisY(JPH_Vec3* result);
JPH_CAPI void JPH_Vec3_AxisZ(JPH_Vec3* result);
JPH_CAPI bool JPH_Vec3_IsClose(const JPH_Vec3* v1, const JPH_Vec3* v2, float maxDistSq);
JPH_CAPI bool JPH_Vec3_IsNearZero(const JPH_Vec3* v, float maxDistSq);
JPH_CAPI bool JPH_Vec3_IsNormalized(const JPH_Vec3* v, float tolerance);
JPH_CAPI bool JPH_Vec3_IsNaN(const JPH_Vec3* v);

JPH_CAPI void JPH_Vec3_Negate(const JPH_Vec3* v, JPH_Vec3* result);
JPH_CAPI void JPH_Vec3_Normalized(const JPH_Vec3* v, JPH_Vec3* result);
JPH_CAPI void JPH_Vec3_Cross(const JPH_Vec3* v1, const JPH_Vec3* v2, JPH_Vec3* result);
JPH_CAPI void JPH_Vec3_Abs(const JPH_Vec3* v, JPH_Vec3* result);

JPH_CAPI float JPH_Vec3_Length(const JPH_Vec3* v);
JPH_CAPI float JPH_Vec3_LengthSquared(const JPH_Vec3* v);

JPH_CAPI void JPH_Vec3_DotProduct(const JPH_Vec3* v1, const JPH_Vec3* v2, float* result);
JPH_CAPI void JPH_Vec3_Normalize(const JPH_Vec3* v, JPH_Vec3* result);

JPH_CAPI void JPH_Vec3_Add(const JPH_Vec3* v1, const JPH_Vec3* v2, JPH_Vec3* result);
JPH_CAPI void JPH_Vec3_Subtract(const JPH_Vec3* v1, const JPH_Vec3* v2, JPH_Vec3* result);
JPH_CAPI void JPH_Vec3_Multiply(const JPH_Vec3* v1, const JPH_Vec3* v2, JPH_Vec3* result);
JPH_CAPI void JPH_Vec3_MultiplyScalar(const JPH_Vec3* v, float scalar, JPH_Vec3* result);
JPH_CAPI void JPH_Vec3_MultiplyMatrix(const JPH_Mat4* left, const JPH_Vec3* right, JPH_Vec3* result);

JPH_CAPI void JPH_Vec3_Divide(const JPH_Vec3* v1, const JPH_Vec3* v2, JPH_Vec3* result);
JPH_CAPI void JPH_Vec3_DivideScalar(const JPH_Vec3* v, float scalar, JPH_Vec3* result);

JPH_CAPI void JPH_Mat4_Add(const JPH_Mat4* m1, const JPH_Mat4* m2, JPH_Mat4* result);
JPH_CAPI void JPH_Mat4_Subtract(const JPH_Mat4* m1, const JPH_Mat4* m2, JPH_Mat4* result);
JPH_CAPI void JPH_Mat4_Multiply(const JPH_Mat4* m1, const JPH_Mat4* m2, JPH_Mat4* result);
JPH_CAPI void JPH_Mat4_MultiplyScalar(const JPH_Mat4* m, float scalar, JPH_Mat4* result);

JPH_CAPI void JPH_Mat4_Zero(JPH_Mat4* result);
JPH_CAPI void JPH_Mat4_Identity(JPH_Mat4* result);
JPH_CAPI void JPH_Mat4_Rotation(JPH_Mat4* result, const JPH_Quat* rotation);
JPH_CAPI void JPH_Mat4_Rotation2(JPH_Mat4* result, const JPH_Vec3* axis, float angle);
JPH_CAPI void JPH_Mat4_Translation(JPH_Mat4* result, const JPH_Vec3* translation);
JPH_CAPI void JPH_Mat4_RotationTranslation(JPH_Mat4* result, const JPH_Quat* rotation, const JPH_Vec3* translation);
JPH_CAPI void JPH_Mat4_InverseRotationTranslation(JPH_Mat4* result, const JPH_Quat* rotation, const JPH_Vec3* translation);
JPH_CAPI void JPH_Mat4_Scale(JPH_Mat4* result, const JPH_Vec3* scale);
JPH_CAPI void JPH_Mat4_Transposed(const JPH_Mat4* m, JPH_Mat4* result);
JPH_CAPI void JPH_Mat4_Inversed(const JPH_Mat4* matrix, JPH_Mat4* result);

JPH_CAPI void JPH_Mat4_GetAxisX(const JPH_Mat4* matrix, JPH_Vec3* result);
JPH_CAPI void JPH_Mat4_GetAxisY(const JPH_Mat4* matrix, JPH_Vec3* result);
JPH_CAPI void JPH_Mat4_GetAxisZ(const JPH_Mat4* matrix, JPH_Vec3* result);
JPH_CAPI void JPH_Mat4_GetTranslation(const JPH_Mat4* matrix, JPH_Vec3* result);
JPH_CAPI void JPH_Mat4_GetQuaternion(const JPH_Mat4* matrix, JPH_Quat* result);

#if defined(JPH_DOUBLE_PRECISION)
JPH_CAPI void JPH_RMat4_Zero(JPH_RMat4* result);
JPH_CAPI void JPH_RMat4_Identity(JPH_RMat4* result);
JPH_CAPI void JPH_RMat4_Rotation(JPH_RMat4* result, const JPH_Quat* rotation);
JPH_CAPI void JPH_RMat4_Translation(JPH_RMat4* result, const JPH_RVec3* translation);
JPH_CAPI void JPH_RMat4_RotationTranslation(JPH_RMat4* result, const JPH_Quat* rotation, const JPH_RVec3* translation);
JPH_CAPI void JPH_RMat4_InverseRotationTranslation(JPH_RMat4* result, const JPH_Quat* rotation, const JPH_RVec3* translation);
JPH_CAPI void JPH_RMat4_Scale(JPH_RMat4* result, const JPH_Vec3* scale);
JPH_CAPI void JPH_RMat4_Inversed(const JPH_RMat4* m, JPH_RMat4* result);
#endif /* defined(JPH_DOUBLE_PRECISION) */

/* Material */
JPH_CAPI JPH_PhysicsMaterial* JPH_PhysicsMaterial_Create(const char* name, uint32_t color);
JPH_CAPI void JPH_PhysicsMaterial_Destroy(JPH_PhysicsMaterial* material);
JPH_CAPI const char* JPH_PhysicsMaterial_GetDebugName(const JPH_PhysicsMaterial* material);
JPH_CAPI uint32_t JPH_PhysicsMaterial_GetDebugColor(const JPH_PhysicsMaterial* material);

/* GroupFilter/GroupFilterTable */
JPH_CAPI void JPH_GroupFilter_Destroy(JPH_GroupFilter* groupFilter);
JPH_CAPI bool JPH_GroupFilter_CanCollide(JPH_GroupFilter* groupFilter, const JPH_CollisionGroup* group1, const JPH_CollisionGroup* group2);

JPH_CAPI JPH_GroupFilterTable* JPH_GroupFilterTable_Create(uint32_t numSubGroups/* = 0*/);
JPH_CAPI void JPH_GroupFilterTable_DisableCollision(JPH_GroupFilterTable* table, JPH_CollisionSubGroupID subGroup1, JPH_CollisionSubGroupID subGroup2);
JPH_CAPI void JPH_GroupFilterTable_EnableCollision(JPH_GroupFilterTable* table, JPH_CollisionSubGroupID subGroup1, JPH_CollisionSubGroupID subGroup2);
JPH_CAPI bool JPH_GroupFilterTable_IsCollisionEnabled(JPH_GroupFilterTable* table, JPH_CollisionSubGroupID subGroup1, JPH_CollisionSubGroupID subGroup2);

/* ShapeSettings */
JPH_CAPI void JPH_ShapeSettings_Destroy(JPH_ShapeSettings* settings);
JPH_CAPI uint64_t JPH_ShapeSettings_GetUserData(const JPH_ShapeSettings* settings);
JPH_CAPI void JPH_ShapeSettings_SetUserData(JPH_ShapeSettings* settings, uint64_t userData);

/* Shape */
JPH_CAPI void JPH_Shape_Draw(const JPH_Shape* shape, JPH_DebugRenderer* renderer, const JPH_RMat4* centerOfMassTransform, const JPH_Vec3* scale, JPH_Color color, bool useMaterialColors, bool drawWireframe);
JPH_CAPI void JPH_Shape_Destroy(JPH_Shape* shape);
JPH_CAPI JPH_ShapeType JPH_Shape_GetType(const JPH_Shape* shape);
JPH_CAPI JPH_ShapeSubType JPH_Shape_GetSubType(const JPH_Shape* shape);
JPH_CAPI uint64_t JPH_Shape_GetUserData(const JPH_Shape* shape);
JPH_CAPI void JPH_Shape_SetUserData(JPH_Shape* shape, uint64_t userData);
JPH_CAPI bool JPH_Shape_MustBeStatic(const JPH_Shape* shape);
JPH_CAPI void JPH_Shape_GetCenterOfMass(const JPH_Shape* shape, JPH_Vec3* result);
JPH_CAPI void JPH_Shape_GetLocalBounds(const JPH_Shape* shape, JPH_AABox* result);
JPH_CAPI uint32_t JPH_Shape_GetSubShapeIDBitsRecursive(const JPH_Shape* shape);
JPH_CAPI void JPH_Shape_GetWorldSpaceBounds(const JPH_Shape* shape, JPH_RMat4* centerOfMassTransform, JPH_Vec3* scale, JPH_AABox* result);
JPH_CAPI float JPH_Shape_GetInnerRadius(const JPH_Shape* shape);
JPH_CAPI void JPH_Shape_GetMassProperties(const JPH_Shape* shape, JPH_MassProperties* result);
JPH_CAPI const JPH_Shape* JPH_Shape_GetLeafShape(const JPH_Shape* shape, JPH_SubShapeID subShapeID, JPH_SubShapeID* remainder);
JPH_CAPI const JPH_PhysicsMaterial* JPH_Shape_GetMaterial(const JPH_Shape* shape, JPH_SubShapeID subShapeID);
JPH_CAPI void JPH_Shape_GetSurfaceNormal(const JPH_Shape* shape, JPH_SubShapeID subShapeID, JPH_Vec3* localPosition, JPH_Vec3* normal);
JPH_CAPI void JPH_Shape_GetSupportingFace(const JPH_Shape* shape, const JPH_SubShapeID subShapeID, const JPH_Vec3* direction, const JPH_Vec3* scale, const JPH_Mat4* centerOfMassTransform, JPH_SupportingFace* outVertices);
JPH_CAPI float JPH_Shape_GetVolume(const JPH_Shape* shape);
JPH_CAPI bool JPH_Shape_IsValidScale(const JPH_Shape* shape, const JPH_Vec3* scale);
JPH_CAPI void JPH_Shape_MakeScaleValid(const JPH_Shape* shape, const JPH_Vec3* scale, JPH_Vec3* result);
JPH_CAPI JPH_Shape* JPH_Shape_ScaleShape(const JPH_Shape* shape, const JPH_Vec3* scale);
JPH_CAPI bool JPH_Shape_CastRay(const JPH_Shape* shape, const JPH_Vec3* origin, const JPH_Vec3* direction, JPH_RayCastResult* hit);
JPH_CAPI bool JPH_Shape_CastRay2(const JPH_Shape* shape, const JPH_Vec3* origin, const JPH_Vec3* direction, const JPH_RayCastSettings* rayCastSettings, JPH_CollisionCollectorType collectorType, JPH_CastRayResultCallback* callback, void* userData, const JPH_ShapeFilter* shapeFilter);
JPH_CAPI bool JPH_Shape_CollidePoint(const JPH_Shape* shape, const JPH_Vec3* point, const JPH_ShapeFilter* shapeFilter);
JPH_CAPI bool JPH_Shape_CollidePoint2(const JPH_Shape* shape, const JPH_Vec3* point, JPH_CollisionCollectorType collectorType, JPH_CollidePointResultCallback* callback, void* userData, const JPH_ShapeFilter* shapeFilter);

/* JPH_ConvexShape */
JPH_CAPI float JPH_ConvexShapeSettings_GetDensity(const JPH_ConvexShapeSettings* shape);
JPH_CAPI void JPH_ConvexShapeSettings_SetDensity(JPH_ConvexShapeSettings* shape, float value);
JPH_CAPI float JPH_ConvexShape_GetDensity(const JPH_ConvexShape* shape);
JPH_CAPI void JPH_ConvexShape_SetDensity(JPH_ConvexShape* shape, float inDensity);

/* BoxShape */
JPH_CAPI JPH_BoxShapeSettings* JPH_BoxShapeSettings_Create(const JPH_Vec3* halfExtent, float convexRadius);
JPH_CAPI JPH_BoxShape* JPH_BoxShapeSettings_CreateShape(const JPH_BoxShapeSettings* settings);

JPH_CAPI JPH_BoxShape* JPH_BoxShape_Create(const JPH_Vec3* halfExtent, float convexRadius);
JPH_CAPI void JPH_BoxShape_GetHalfExtent(const JPH_BoxShape* shape, JPH_Vec3* halfExtent);
JPH_CAPI float JPH_BoxShape_GetConvexRadius(const JPH_BoxShape* shape);

/* SphereShape */
JPH_CAPI JPH_SphereShapeSettings* JPH_SphereShapeSettings_Create(float radius);
JPH_CAPI JPH_SphereShape* JPH_SphereShapeSettings_CreateShape(const JPH_SphereShapeSettings* settings);

JPH_CAPI float JPH_SphereShapeSettings_GetRadius(const JPH_SphereShapeSettings* settings);
JPH_CAPI void JPH_SphereShapeSettings_SetRadius(JPH_SphereShapeSettings* settings, float radius);
JPH_CAPI JPH_SphereShape* JPH_SphereShape_Create(float radius);
JPH_CAPI float JPH_SphereShape_GetRadius(const JPH_SphereShape* shape);

/* PlaneShape */
JPH_CAPI JPH_PlaneShapeSettings* JPH_PlaneShapeSettings_Create(const JPH_Plane* plane, const JPH_PhysicsMaterial* material, float halfExtent);
JPH_CAPI JPH_PlaneShape* JPH_PlaneShapeSettings_CreateShape(const JPH_PlaneShapeSettings* settings);
JPH_CAPI JPH_PlaneShape* JPH_PlaneShape_Create(const JPH_Plane* plane, const JPH_PhysicsMaterial* material, float halfExtent);
JPH_CAPI void JPH_PlaneShape_GetPlane(const JPH_PlaneShape* shape, JPH_Plane* result);
JPH_CAPI float JPH_PlaneShape_GetHalfExtent(const JPH_PlaneShape* shape);

/* TriangleShape */
JPH_CAPI JPH_TriangleShapeSettings* JPH_TriangleShapeSettings_Create(const JPH_Vec3* v1, const JPH_Vec3* v2, const JPH_Vec3* v3, float convexRadius);
JPH_CAPI JPH_TriangleShape* JPH_TriangleShapeSettings_CreateShape(const JPH_TriangleShapeSettings* settings);

JPH_CAPI JPH_TriangleShape* JPH_TriangleShape_Create(const JPH_Vec3* v1, const JPH_Vec3* v2, const JPH_Vec3* v3, float convexRadius);
JPH_CAPI float JPH_TriangleShape_GetConvexRadius(const JPH_TriangleShape* shape);
JPH_CAPI void JPH_TriangleShape_GetVertex1(const JPH_TriangleShape* shape, JPH_Vec3* result);
JPH_CAPI void JPH_TriangleShape_GetVertex2(const JPH_TriangleShape* shape, JPH_Vec3* result);
JPH_CAPI void JPH_TriangleShape_GetVertex3(const JPH_TriangleShape* shape, JPH_Vec3* result);

/* CapsuleShape */
JPH_CAPI JPH_CapsuleShapeSettings* JPH_CapsuleShapeSettings_Create(float halfHeightOfCylinder, float radius);
JPH_CAPI JPH_CapsuleShape* JPH_CapsuleShapeSettings_CreateShape(const JPH_CapsuleShapeSettings* settings);
JPH_CAPI JPH_CapsuleShape* JPH_CapsuleShape_Create(float halfHeightOfCylinder, float radius);
JPH_CAPI float JPH_CapsuleShape_GetRadius(const JPH_CapsuleShape* shape);
JPH_CAPI float JPH_CapsuleShape_GetHalfHeightOfCylinder(const JPH_CapsuleShape* shape);

/* CylinderShape */
JPH_CAPI JPH_CylinderShapeSettings* JPH_CylinderShapeSettings_Create(float halfHeight, float radius, float convexRadius);
JPH_CAPI JPH_CylinderShape* JPH_CylinderShapeSettings_CreateShape(const JPH_CylinderShapeSettings* settings);

JPH_CAPI JPH_CylinderShape* JPH_CylinderShape_Create(float halfHeight, float radius);
JPH_CAPI float JPH_CylinderShape_GetRadius(const JPH_CylinderShape* shape);
JPH_CAPI float JPH_CylinderShape_GetHalfHeight(const JPH_CylinderShape* shape);

/* TaperedCylinderShape */
JPH_CAPI JPH_TaperedCylinderShapeSettings* JPH_TaperedCylinderShapeSettings_Create(float halfHeightOfTaperedCylinder, float topRadius, float bottomRadius, float convexRadius/* = cDefaultConvexRadius*/, const JPH_PhysicsMaterial* material /* = NULL*/);
JPH_CAPI JPH_TaperedCylinderShape* JPH_TaperedCylinderShapeSettings_CreateShape(const JPH_TaperedCylinderShapeSettings* settings);
JPH_CAPI float JPH_TaperedCylinderShape_GetTopRadius(const JPH_TaperedCylinderShape* shape);
JPH_CAPI float JPH_TaperedCylinderShape_GetBottomRadius(const JPH_TaperedCylinderShape* shape);
JPH_CAPI float JPH_TaperedCylinderShape_GetConvexRadius(const JPH_TaperedCylinderShape* shape);
JPH_CAPI float JPH_TaperedCylinderShape_GetHalfHeight(const JPH_TaperedCylinderShape* shape);

/* ConvexHullShape */
JPH_CAPI JPH_ConvexHullShapeSettings* JPH_ConvexHullShapeSettings_Create(const JPH_Vec3* points, uint32_t pointsCount, float maxConvexRadius);
JPH_CAPI JPH_ConvexHullShape* JPH_ConvexHullShapeSettings_CreateShape(const JPH_ConvexHullShapeSettings* settings);
JPH_CAPI uint32_t JPH_ConvexHullShape_GetNumPoints(const JPH_ConvexHullShape* shape);
JPH_CAPI void JPH_ConvexHullShape_GetPoint(const JPH_ConvexHullShape* shape, uint32_t index, JPH_Vec3* result);
JPH_CAPI uint32_t JPH_ConvexHullShape_GetNumFaces(const JPH_ConvexHullShape* shape);
JPH_CAPI uint32_t JPH_ConvexHullShape_GetNumVerticesInFace(const JPH_ConvexHullShape* shape, uint32_t faceIndex);
JPH_CAPI uint32_t JPH_ConvexHullShape_GetFaceVertices(const JPH_ConvexHullShape* shape, uint32_t faceIndex, uint32_t maxVertices, uint32_t* vertices);

/* MeshShape */
JPH_CAPI JPH_MeshShapeSettings* JPH_MeshShapeSettings_Create(const JPH_Triangle* triangles, uint32_t triangleCount);
JPH_CAPI JPH_MeshShapeSettings* JPH_MeshShapeSettings_Create2(const JPH_Vec3* vertices, uint32_t verticesCount, const JPH_IndexedTriangle* triangles, uint32_t triangleCount);
JPH_CAPI uint32_t JPH_MeshShapeSettings_GetMaxTrianglesPerLeaf(const JPH_MeshShapeSettings* settings);
JPH_CAPI void JPH_MeshShapeSettings_SetMaxTrianglesPerLeaf(JPH_MeshShapeSettings* settings, uint32_t value);
JPH_CAPI float JPH_MeshShapeSettings_GetActiveEdgeCosThresholdAngle(const JPH_MeshShapeSettings* settings);
JPH_CAPI void JPH_MeshShapeSettings_SetActiveEdgeCosThresholdAngle(JPH_MeshShapeSettings* settings, float value);
JPH_CAPI bool JPH_MeshShapeSettings_GetPerTriangleUserData(const JPH_MeshShapeSettings* settings);
JPH_CAPI void JPH_MeshShapeSettings_SetPerTriangleUserData(JPH_MeshShapeSettings* settings, bool value);
JPH_CAPI JPH_Mesh_Shape_BuildQuality JPH_MeshShapeSettings_GetBuildQuality(const JPH_MeshShapeSettings* settings);
JPH_CAPI void JPH_MeshShapeSettings_SetBuildQuality(JPH_MeshShapeSettings* settings, JPH_Mesh_Shape_BuildQuality value);

JPH_CAPI void JPH_MeshShapeSettings_Sanitize(JPH_MeshShapeSettings* settings);
JPH_CAPI JPH_MeshShape* JPH_MeshShapeSettings_CreateShape(const JPH_MeshShapeSettings* settings);
JPH_CAPI uint32_t JPH_MeshShape_GetTriangleUserData(const JPH_MeshShape* shape, JPH_SubShapeID id);

/* HeightFieldShape */
JPH_CAPI JPH_HeightFieldShapeSettings* JPH_HeightFieldShapeSettings_Create(const float* samples, const JPH_Vec3* offset, const JPH_Vec3* scale, uint32_t sampleCount, const uint8_t* materialIndices);
JPH_CAPI void JPH_HeightFieldShapeSettings_DetermineMinAndMaxSample(const JPH_HeightFieldShapeSettings* settings, float* pOutMinValue, float* pOutMaxValue, float* pOutQuantizationScale);
JPH_CAPI uint32_t JPH_HeightFieldShapeSettings_CalculateBitsPerSampleForError(const JPH_HeightFieldShapeSettings* settings, float maxError);
JPH_CAPI void JPH_HeightFieldShapeSettings_GetOffset(const JPH_HeightFieldShapeSettings* shape, JPH_Vec3* result);
JPH_CAPI void JPH_HeightFieldShapeSettings_SetOffset(JPH_HeightFieldShapeSettings* settings, const JPH_Vec3* value);
JPH_CAPI void JPH_HeightFieldShapeSettings_GetScale(const JPH_HeightFieldShapeSettings* shape, JPH_Vec3* result);
JPH_CAPI void JPH_HeightFieldShapeSettings_SetScale(JPH_HeightFieldShapeSettings* settings, const JPH_Vec3* value);
JPH_CAPI uint32_t JPH_HeightFieldShapeSettings_GetSampleCount(const JPH_HeightFieldShapeSettings* settings);
JPH_CAPI void JPH_HeightFieldShapeSettings_SetSampleCount(JPH_HeightFieldShapeSettings* settings, uint32_t value);
JPH_CAPI float JPH_HeightFieldShapeSettings_GetMinHeightValue(const JPH_HeightFieldShapeSettings* settings);
JPH_CAPI void JPH_HeightFieldShapeSettings_SetMinHeightValue(JPH_HeightFieldShapeSettings* settings, float value);
JPH_CAPI float JPH_HeightFieldShapeSettings_GetMaxHeightValue(const JPH_HeightFieldShapeSettings* settings);
JPH_CAPI void JPH_HeightFieldShapeSettings_SetMaxHeightValue(JPH_HeightFieldShapeSettings* settings, float value);
JPH_CAPI uint32_t JPH_HeightFieldShapeSettings_GetBlockSize(const JPH_HeightFieldShapeSettings* settings);
JPH_CAPI void JPH_HeightFieldShapeSettings_SetBlockSize(JPH_HeightFieldShapeSettings* settings, uint32_t value);
JPH_CAPI uint32_t JPH_HeightFieldShapeSettings_GetBitsPerSample(const JPH_HeightFieldShapeSettings* settings);
JPH_CAPI void JPH_HeightFieldShapeSettings_SetBitsPerSample(JPH_HeightFieldShapeSettings* settings, uint32_t value);
JPH_CAPI float JPH_HeightFieldShapeSettings_GetActiveEdgeCosThresholdAngle(const JPH_HeightFieldShapeSettings* settings);
JPH_CAPI void JPH_HeightFieldShapeSettings_SetActiveEdgeCosThresholdAngle(JPH_HeightFieldShapeSettings* settings, float value);
JPH_CAPI JPH_HeightFieldShape* JPH_HeightFieldShapeSettings_CreateShape(JPH_HeightFieldShapeSettings* settings);

JPH_CAPI uint32_t JPH_HeightFieldShape_GetSampleCount(const JPH_HeightFieldShape* shape);
JPH_CAPI uint32_t JPH_HeightFieldShape_GetBlockSize(const JPH_HeightFieldShape* shape);
JPH_CAPI const JPH_PhysicsMaterial* JPH_HeightFieldShape_GetMaterial(const JPH_HeightFieldShape* shape, uint32_t x, uint32_t y);
JPH_CAPI void JPH_HeightFieldShape_GetPosition(const JPH_HeightFieldShape* shape, uint32_t x, uint32_t y, JPH_Vec3* result);
JPH_CAPI bool JPH_HeightFieldShape_IsNoCollision(const JPH_HeightFieldShape* shape, uint32_t x, uint32_t y);
JPH_CAPI bool JPH_HeightFieldShape_ProjectOntoSurface(const JPH_HeightFieldShape* shape, const JPH_Vec3* localPosition, JPH_Vec3* outSurfacePosition, JPH_SubShapeID* outSubShapeID);
JPH_CAPI float JPH_HeightFieldShape_GetMinHeightValue(const JPH_HeightFieldShape* shape);
JPH_CAPI float JPH_HeightFieldShape_GetMaxHeightValue(const JPH_HeightFieldShape* shape);

/* TaperedCapsuleShape */
JPH_CAPI JPH_TaperedCapsuleShapeSettings* JPH_TaperedCapsuleShapeSettings_Create(float halfHeightOfTaperedCylinder, float topRadius, float bottomRadius);
JPH_CAPI JPH_TaperedCapsuleShape* JPH_TaperedCapsuleShapeSettings_CreateShape(JPH_TaperedCapsuleShapeSettings* settings);

JPH_CAPI float JPH_TaperedCapsuleShape_GetTopRadius(const JPH_TaperedCapsuleShape* shape);
JPH_CAPI float JPH_TaperedCapsuleShape_GetBottomRadius(const JPH_TaperedCapsuleShape* shape);
JPH_CAPI float JPH_TaperedCapsuleShape_GetHalfHeight(const JPH_TaperedCapsuleShape* shape);

/* CompoundShape */
JPH_CAPI void JPH_CompoundShapeSettings_AddShape(JPH_CompoundShapeSettings* settings, const JPH_Vec3* position, const JPH_Quat* rotation, const JPH_ShapeSettings* shapeSettings, uint32_t userData);
JPH_CAPI void JPH_CompoundShapeSettings_AddShape2(JPH_CompoundShapeSettings* settings, const JPH_Vec3* position, const JPH_Quat* rotation, const JPH_Shape* shape, uint32_t userData);
JPH_CAPI uint32_t JPH_CompoundShape_GetNumSubShapes(const JPH_CompoundShape* shape);
JPH_CAPI void JPH_CompoundShape_GetSubShape(const JPH_CompoundShape* shape, uint32_t index, const JPH_Shape** subShape, JPH_Vec3* positionCOM, JPH_Quat* rotation, uint32_t* userData);
JPH_CAPI uint32_t JPH_CompoundShape_GetSubShapeIndexFromID(const JPH_CompoundShape* shape, JPH_SubShapeID id, JPH_SubShapeID* remainder);

/* StaticCompoundShape */
JPH_CAPI JPH_StaticCompoundShapeSettings* JPH_StaticCompoundShapeSettings_Create(void);
JPH_CAPI JPH_StaticCompoundShape* JPH_StaticCompoundShape_Create(const JPH_StaticCompoundShapeSettings* settings);

/* MutableCompoundShape */
JPH_CAPI JPH_MutableCompoundShapeSettings* JPH_MutableCompoundShapeSettings_Create(void);
JPH_CAPI JPH_MutableCompoundShape* JPH_MutableCompoundShape_Create(const JPH_MutableCompoundShapeSettings* settings);

JPH_CAPI uint32_t JPH_MutableCompoundShape_AddShape(JPH_MutableCompoundShape* shape, const JPH_Vec3* position, const JPH_Quat* rotation, const JPH_Shape* child, uint32_t userData /* = 0 */, uint32_t index /* = UINT32_MAX */);
JPH_CAPI void JPH_MutableCompoundShape_RemoveShape(JPH_MutableCompoundShape* shape, uint32_t index);
JPH_CAPI void JPH_MutableCompoundShape_ModifyShape(JPH_MutableCompoundShape* shape, uint32_t index, const JPH_Vec3* position, const JPH_Quat* rotation);
JPH_CAPI void JPH_MutableCompoundShape_ModifyShape2(JPH_MutableCompoundShape* shape, uint32_t index, const JPH_Vec3* position, const JPH_Quat* rotation, const JPH_Shape* newShape);
JPH_CAPI void JPH_MutableCompoundShape_AdjustCenterOfMass(JPH_MutableCompoundShape* shape);

/* DecoratedShape */
JPH_CAPI const JPH_Shape* JPH_DecoratedShape_GetInnerShape(const JPH_DecoratedShape* shape);

/* RotatedTranslatedShape */
JPH_CAPI JPH_RotatedTranslatedShapeSettings* JPH_RotatedTranslatedShapeSettings_Create(const JPH_Vec3* position, const JPH_Quat* rotation, const JPH_ShapeSettings* shapeSettings);
JPH_CAPI JPH_RotatedTranslatedShapeSettings* JPH_RotatedTranslatedShapeSettings_Create2(const JPH_Vec3* position, const JPH_Quat* rotation, const JPH_Shape* shape);
JPH_CAPI JPH_RotatedTranslatedShape* JPH_RotatedTranslatedShapeSettings_CreateShape(const JPH_RotatedTranslatedShapeSettings* settings);
JPH_CAPI JPH_RotatedTranslatedShape* JPH_RotatedTranslatedShape_Create(const JPH_Vec3* position, const JPH_Quat* rotation, const JPH_Shape* shape);
JPH_CAPI void JPH_RotatedTranslatedShape_GetPosition(const JPH_RotatedTranslatedShape* shape, JPH_Vec3* position);
JPH_CAPI void JPH_RotatedTranslatedShape_GetRotation(const JPH_RotatedTranslatedShape* shape, JPH_Quat* rotation);

/* ScaledShape */
JPH_CAPI JPH_ScaledShapeSettings* JPH_ScaledShapeSettings_Create(const JPH_ShapeSettings* shapeSettings, const JPH_Vec3* scale);
JPH_CAPI JPH_ScaledShapeSettings* JPH_ScaledShapeSettings_Create2(const JPH_Shape* shape, const JPH_Vec3* scale);
JPH_CAPI JPH_ScaledShape* JPH_ScaledShapeSettings_CreateShape(const JPH_ScaledShapeSettings* settings);
JPH_CAPI JPH_ScaledShape* JPH_ScaledShape_Create(const JPH_Shape* shape, const JPH_Vec3* scale);
JPH_CAPI void JPH_ScaledShape_GetScale(const JPH_ScaledShape* shape, JPH_Vec3* result);

/* OffsetCenterOfMassShape */
JPH_CAPI JPH_OffsetCenterOfMassShapeSettings* JPH_OffsetCenterOfMassShapeSettings_Create(const JPH_Vec3* offset, const JPH_ShapeSettings* shapeSettings);
JPH_CAPI JPH_OffsetCenterOfMassShapeSettings* JPH_OffsetCenterOfMassShapeSettings_Create2(const JPH_Vec3* offset, const JPH_Shape* shape);
JPH_CAPI JPH_OffsetCenterOfMassShape* JPH_OffsetCenterOfMassShapeSettings_CreateShape(const JPH_OffsetCenterOfMassShapeSettings* settings);

JPH_CAPI JPH_OffsetCenterOfMassShape* JPH_OffsetCenterOfMassShape_Create(const JPH_Vec3* offset, const JPH_Shape* shape);
JPH_CAPI void JPH_OffsetCenterOfMassShape_GetOffset(const JPH_OffsetCenterOfMassShape* shape, JPH_Vec3* result);

/* EmptyShape */
JPH_CAPI JPH_EmptyShapeSettings* JPH_EmptyShapeSettings_Create(const JPH_Vec3* centerOfMass);
JPH_CAPI JPH_EmptyShape* JPH_EmptyShapeSettings_CreateShape(const JPH_EmptyShapeSettings* settings);

/* JPH_BodyCreationSettings */
JPH_CAPI JPH_BodyCreationSettings* JPH_BodyCreationSettings_Create(void);
JPH_CAPI JPH_BodyCreationSettings* JPH_BodyCreationSettings_Create2(const JPH_ShapeSettings* settings,
	const JPH_RVec3* position,
	const JPH_Quat* rotation,
	JPH_MotionType motionType,
	JPH_ObjectLayer objectLayer);
JPH_CAPI JPH_BodyCreationSettings* JPH_BodyCreationSettings_Create3(const JPH_Shape* shape,
	const JPH_RVec3* position,
	const JPH_Quat* rotation,
	JPH_MotionType motionType,
	JPH_ObjectLayer objectLayer);
JPH_CAPI void JPH_BodyCreationSettings_Destroy(JPH_BodyCreationSettings* settings);

JPH_CAPI void JPH_BodyCreationSettings_GetPosition(JPH_BodyCreationSettings* settings, JPH_RVec3* result);
JPH_CAPI void JPH_BodyCreationSettings_SetPosition(JPH_BodyCreationSettings* settings, const JPH_RVec3* value);

JPH_CAPI void JPH_BodyCreationSettings_GetRotation(JPH_BodyCreationSettings* settings, JPH_Quat* result);
JPH_CAPI void JPH_BodyCreationSettings_SetRotation(JPH_BodyCreationSettings* settings, const JPH_Quat* value);

JPH_CAPI void JPH_BodyCreationSettings_GetLinearVelocity(JPH_BodyCreationSettings* settings, JPH_Vec3* velocity);
JPH_CAPI void JPH_BodyCreationSettings_SetLinearVelocity(JPH_BodyCreationSettings* settings, const JPH_Vec3* velocity);

JPH_CAPI void JPH_BodyCreationSettings_GetAngularVelocity(JPH_BodyCreationSettings* settings, JPH_Vec3* velocity);
JPH_CAPI void JPH_BodyCreationSettings_SetAngularVelocity(JPH_BodyCreationSettings* settings, const JPH_Vec3* velocity);

JPH_CAPI uint64_t JPH_BodyCreationSettings_GetUserData(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetUserData(JPH_BodyCreationSettings* settings, uint64_t value);

JPH_CAPI JPH_ObjectLayer JPH_BodyCreationSettings_GetObjectLayer(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetObjectLayer(JPH_BodyCreationSettings* settings, JPH_ObjectLayer value);

JPH_CAPI void JPH_BodyCreationSettings_GetCollisionGroup(const JPH_BodyCreationSettings* settings, JPH_CollisionGroup* result);
JPH_CAPI void JPH_BodyCreationSettings_SetCollisionGroup(JPH_BodyCreationSettings* settings, const JPH_CollisionGroup* value);

JPH_CAPI JPH_MotionType JPH_BodyCreationSettings_GetMotionType(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetMotionType(JPH_BodyCreationSettings* settings, JPH_MotionType value);

JPH_CAPI JPH_AllowedDOFs JPH_BodyCreationSettings_GetAllowedDOFs(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetAllowedDOFs(JPH_BodyCreationSettings* settings, JPH_AllowedDOFs value);

JPH_CAPI bool JPH_BodyCreationSettings_GetAllowDynamicOrKinematic(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetAllowDynamicOrKinematic(JPH_BodyCreationSettings* settings, bool value);

JPH_CAPI bool JPH_BodyCreationSettings_GetIsSensor(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetIsSensor(JPH_BodyCreationSettings* settings, bool value);

JPH_CAPI bool JPH_BodyCreationSettings_GetCollideKinematicVsNonDynamic(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetCollideKinematicVsNonDynamic(JPH_BodyCreationSettings* settings, bool value);

JPH_CAPI bool JPH_BodyCreationSettings_GetUseManifoldReduction(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetUseManifoldReduction(JPH_BodyCreationSettings* settings, bool value);

JPH_CAPI bool JPH_BodyCreationSettings_GetApplyGyroscopicForce(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetApplyGyroscopicForce(JPH_BodyCreationSettings* settings, bool value);

JPH_CAPI JPH_MotionQuality JPH_BodyCreationSettings_GetMotionQuality(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetMotionQuality(JPH_BodyCreationSettings* settings, JPH_MotionQuality value);

JPH_CAPI bool JPH_BodyCreationSettings_GetEnhancedInternalEdgeRemoval(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetEnhancedInternalEdgeRemoval(JPH_BodyCreationSettings* settings, bool value);

JPH_CAPI bool JPH_BodyCreationSettings_GetAllowSleeping(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetAllowSleeping(JPH_BodyCreationSettings* settings, bool value);

JPH_CAPI float JPH_BodyCreationSettings_GetFriction(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetFriction(JPH_BodyCreationSettings* settings, float value);

JPH_CAPI float JPH_BodyCreationSettings_GetRestitution(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetRestitution(JPH_BodyCreationSettings* settings, float value);

JPH_CAPI float JPH_BodyCreationSettings_GetLinearDamping(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetLinearDamping(JPH_BodyCreationSettings* settings, float value);

JPH_CAPI float JPH_BodyCreationSettings_GetAngularDamping(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetAngularDamping(JPH_BodyCreationSettings* settings, float value);

JPH_CAPI float JPH_BodyCreationSettings_GetMaxLinearVelocity(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetMaxLinearVelocity(JPH_BodyCreationSettings* settings, float value);

JPH_CAPI float JPH_BodyCreationSettings_GetMaxAngularVelocity(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetMaxAngularVelocity(JPH_BodyCreationSettings* settings, float value);

JPH_CAPI float JPH_BodyCreationSettings_GetGravityFactor(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetGravityFactor(JPH_BodyCreationSettings* settings, float value);

JPH_CAPI uint32_t JPH_BodyCreationSettings_GetNumVelocityStepsOverride(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetNumVelocityStepsOverride(JPH_BodyCreationSettings* settings, uint32_t value);

JPH_CAPI uint32_t JPH_BodyCreationSettings_GetNumPositionStepsOverride(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetNumPositionStepsOverride(JPH_BodyCreationSettings* settings, uint32_t value);

JPH_CAPI JPH_OverrideMassProperties JPH_BodyCreationSettings_GetOverrideMassProperties(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetOverrideMassProperties(JPH_BodyCreationSettings* settings, JPH_OverrideMassProperties value);

JPH_CAPI float JPH_BodyCreationSettings_GetInertiaMultiplier(const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyCreationSettings_SetInertiaMultiplier(JPH_BodyCreationSettings* settings, float value);

JPH_CAPI void JPH_BodyCreationSettings_GetMassPropertiesOverride(const JPH_BodyCreationSettings* settings, JPH_MassProperties* result);
JPH_CAPI void JPH_BodyCreationSettings_SetMassPropertiesOverride(JPH_BodyCreationSettings* settings, const JPH_MassProperties* massProperties);

/* JPH_SoftBodyCreationSettings */
JPH_CAPI JPH_SoftBodyCreationSettings* JPH_SoftBodyCreationSettings_Create(void);
JPH_CAPI void JPH_SoftBodyCreationSettings_Destroy(JPH_SoftBodyCreationSettings* settings);

/* JPH_Constraint */
JPH_CAPI void JPH_Constraint_Destroy(JPH_Constraint* constraint);
JPH_CAPI JPH_ConstraintType JPH_Constraint_GetType(const JPH_Constraint* constraint);
JPH_CAPI JPH_ConstraintSubType JPH_Constraint_GetSubType(const JPH_Constraint* constraint);
JPH_CAPI uint32_t JPH_Constraint_GetConstraintPriority(const JPH_Constraint* constraint);
JPH_CAPI void JPH_Constraint_SetConstraintPriority(JPH_Constraint* constraint, uint32_t priority);
JPH_CAPI uint32_t JPH_Constraint_GetNumVelocityStepsOverride(const JPH_Constraint* constraint);
JPH_CAPI void JPH_Constraint_SetNumVelocityStepsOverride(JPH_Constraint* constraint, uint32_t value);
JPH_CAPI uint32_t JPH_Constraint_GetNumPositionStepsOverride(const JPH_Constraint* constraint);
JPH_CAPI void JPH_Constraint_SetNumPositionStepsOverride(JPH_Constraint* constraint, uint32_t value);
JPH_CAPI bool JPH_Constraint_GetEnabled(const JPH_Constraint* constraint);
JPH_CAPI void JPH_Constraint_SetEnabled(JPH_Constraint* constraint, bool enabled);
JPH_CAPI uint64_t JPH_Constraint_GetUserData(const JPH_Constraint* constraint);
JPH_CAPI void JPH_Constraint_SetUserData(JPH_Constraint* constraint, uint64_t userData);
JPH_CAPI void JPH_Constraint_NotifyShapeChanged(JPH_Constraint* constraint, JPH_BodyID bodyID, JPH_Vec3* deltaCOM);
JPH_CAPI void JPH_Constraint_ResetWarmStart(JPH_Constraint* constraint);
JPH_CAPI bool JPH_Constraint_IsActive(const JPH_Constraint* constraint);
JPH_CAPI void JPH_Constraint_SetupVelocityConstraint(JPH_Constraint* constraint, float deltaTime);
JPH_CAPI void JPH_Constraint_WarmStartVelocityConstraint(JPH_Constraint* constraint, float warmStartImpulseRatio);
JPH_CAPI bool JPH_Constraint_SolveVelocityConstraint(JPH_Constraint* constraint, float deltaTime);
JPH_CAPI bool JPH_Constraint_SolvePositionConstraint(JPH_Constraint* constraint, float deltaTime, float baumgarte);

/* JPH_TwoBodyConstraint */
JPH_CAPI JPH_Body* JPH_TwoBodyConstraint_GetBody1(const JPH_TwoBodyConstraint* constraint);
JPH_CAPI JPH_Body* JPH_TwoBodyConstraint_GetBody2(const JPH_TwoBodyConstraint* constraint);
JPH_CAPI void JPH_TwoBodyConstraint_GetConstraintToBody1Matrix(const JPH_TwoBodyConstraint* constraint, JPH_Mat4* result);
JPH_CAPI void JPH_TwoBodyConstraint_GetConstraintToBody2Matrix(const JPH_TwoBodyConstraint* constraint, JPH_Mat4* result);

/* JPH_FixedConstraint */
JPH_CAPI void JPH_FixedConstraintSettings_Init(JPH_FixedConstraintSettings* settings);
JPH_CAPI JPH_FixedConstraint* JPH_FixedConstraint_Create(const JPH_FixedConstraintSettings* settings, JPH_Body* body1, JPH_Body* body2);
JPH_CAPI void JPH_FixedConstraint_GetSettings(const JPH_FixedConstraint* constraint, JPH_FixedConstraintSettings* settings);
JPH_CAPI void JPH_FixedConstraint_GetTotalLambdaPosition(const JPH_FixedConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_FixedConstraint_GetTotalLambdaRotation(const JPH_FixedConstraint* constraint, JPH_Vec3* result);

/* JPH_DistanceConstraint */
JPH_CAPI void JPH_DistanceConstraintSettings_Init(JPH_DistanceConstraintSettings* settings);
JPH_CAPI JPH_DistanceConstraint* JPH_DistanceConstraint_Create(const JPH_DistanceConstraintSettings* settings, JPH_Body* body1, JPH_Body* body2);
JPH_CAPI void JPH_DistanceConstraint_GetSettings(const JPH_DistanceConstraint* constraint, JPH_DistanceConstraintSettings* settings);
JPH_CAPI void JPH_DistanceConstraint_SetDistance(JPH_DistanceConstraint* constraint, float minDistance, float maxDistance);
JPH_CAPI float JPH_DistanceConstraint_GetMinDistance(JPH_DistanceConstraint* constraint);
JPH_CAPI float JPH_DistanceConstraint_GetMaxDistance(JPH_DistanceConstraint* constraint);
JPH_CAPI void JPH_DistanceConstraint_GetLimitsSpringSettings(JPH_DistanceConstraint* constraint, JPH_SpringSettings* result);
JPH_CAPI void JPH_DistanceConstraint_SetLimitsSpringSettings(JPH_DistanceConstraint* constraint, JPH_SpringSettings* settings);
JPH_CAPI float JPH_DistanceConstraint_GetTotalLambdaPosition(const JPH_DistanceConstraint* constraint);

/* JPH_PointConstraint */
JPH_CAPI void JPH_PointConstraintSettings_Init(JPH_PointConstraintSettings* settings);
JPH_CAPI JPH_PointConstraint* JPH_PointConstraint_Create(const JPH_PointConstraintSettings* settings, JPH_Body* body1, JPH_Body* body2);
JPH_CAPI void JPH_PointConstraint_GetSettings(const JPH_PointConstraint* constraint, JPH_PointConstraintSettings* settings);
JPH_CAPI void JPH_PointConstraint_SetPoint1(JPH_PointConstraint* constraint, JPH_ConstraintSpace space, JPH_RVec3* value);
JPH_CAPI void JPH_PointConstraint_SetPoint2(JPH_PointConstraint* constraint, JPH_ConstraintSpace space, JPH_RVec3* value);
JPH_CAPI void JPH_PointConstraint_GetLocalSpacePoint1(const JPH_PointConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_PointConstraint_GetLocalSpacePoint2(const JPH_PointConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_PointConstraint_GetTotalLambdaPosition(const JPH_PointConstraint* constraint, JPH_Vec3* result);

/* JPH_HingeConstraint */
JPH_CAPI void JPH_HingeConstraintSettings_Init(JPH_HingeConstraintSettings* settings);
JPH_CAPI JPH_HingeConstraint* JPH_HingeConstraint_Create(const JPH_HingeConstraintSettings* settings, JPH_Body* body1, JPH_Body* body2);
JPH_CAPI void JPH_HingeConstraint_GetSettings(JPH_HingeConstraint* constraint, JPH_HingeConstraintSettings* settings);
JPH_CAPI void JPH_HingeConstraint_GetLocalSpacePoint1(const JPH_HingeConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_HingeConstraint_GetLocalSpacePoint2(const JPH_HingeConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_HingeConstraint_GetLocalSpaceHingeAxis1(const JPH_HingeConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_HingeConstraint_GetLocalSpaceHingeAxis2(const JPH_HingeConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_HingeConstraint_GetLocalSpaceNormalAxis1(const JPH_HingeConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_HingeConstraint_GetLocalSpaceNormalAxis2(const JPH_HingeConstraint* constraint, JPH_Vec3* result);
JPH_CAPI float JPH_HingeConstraint_GetCurrentAngle(JPH_HingeConstraint* constraint);
JPH_CAPI void JPH_HingeConstraint_SetMaxFrictionTorque(JPH_HingeConstraint* constraint, float frictionTorque);
JPH_CAPI float JPH_HingeConstraint_GetMaxFrictionTorque(JPH_HingeConstraint* constraint);
JPH_CAPI void JPH_HingeConstraint_SetMotorSettings(JPH_HingeConstraint* constraint, JPH_MotorSettings* settings);
JPH_CAPI void JPH_HingeConstraint_GetMotorSettings(JPH_HingeConstraint* constraint, JPH_MotorSettings* result);
JPH_CAPI void JPH_HingeConstraint_SetMotorState(JPH_HingeConstraint* constraint, JPH_MotorState state);
JPH_CAPI JPH_MotorState JPH_HingeConstraint_GetMotorState(JPH_HingeConstraint* constraint);
JPH_CAPI void JPH_HingeConstraint_SetTargetAngularVelocity(JPH_HingeConstraint* constraint, float angularVelocity);
JPH_CAPI float JPH_HingeConstraint_GetTargetAngularVelocity(JPH_HingeConstraint* constraint);
JPH_CAPI void JPH_HingeConstraint_SetTargetAngle(JPH_HingeConstraint* constraint, float angle);
JPH_CAPI float JPH_HingeConstraint_GetTargetAngle(JPH_HingeConstraint* constraint);
JPH_CAPI void JPH_HingeConstraint_SetLimits(JPH_HingeConstraint* constraint, float inLimitsMin, float inLimitsMax);
JPH_CAPI float JPH_HingeConstraint_GetLimitsMin(JPH_HingeConstraint* constraint);
JPH_CAPI float JPH_HingeConstraint_GetLimitsMax(JPH_HingeConstraint* constraint);
JPH_CAPI bool JPH_HingeConstraint_HasLimits(JPH_HingeConstraint* constraint);
JPH_CAPI void JPH_HingeConstraint_GetLimitsSpringSettings(JPH_HingeConstraint* constraint, JPH_SpringSettings* result);
JPH_CAPI void JPH_HingeConstraint_SetLimitsSpringSettings(JPH_HingeConstraint* constraint, JPH_SpringSettings* settings);
JPH_CAPI void JPH_HingeConstraint_GetTotalLambdaPosition(const JPH_HingeConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_HingeConstraint_GetTotalLambdaRotation(const JPH_HingeConstraint* constraint, float rotation[2]);
JPH_CAPI float JPH_HingeConstraint_GetTotalLambdaRotationLimits(const JPH_HingeConstraint* constraint);
JPH_CAPI float JPH_HingeConstraint_GetTotalLambdaMotor(const JPH_HingeConstraint* constraint);

/* JPH_SliderConstraint */
JPH_CAPI void JPH_SliderConstraintSettings_Init(JPH_SliderConstraintSettings* settings);
JPH_CAPI void JPH_SliderConstraintSettings_SetSliderAxis(JPH_SliderConstraintSettings* settings, const JPH_Vec3* axis);

JPH_CAPI JPH_SliderConstraint* JPH_SliderConstraint_Create(const JPH_SliderConstraintSettings* settings, JPH_Body* body1, JPH_Body* body2);
JPH_CAPI void JPH_SliderConstraint_GetSettings(JPH_SliderConstraint* constraint, JPH_SliderConstraintSettings* settings);
JPH_CAPI float JPH_SliderConstraint_GetCurrentPosition(JPH_SliderConstraint* constraint);
JPH_CAPI void JPH_SliderConstraint_SetMaxFrictionForce(JPH_SliderConstraint* constraint, float frictionForce);
JPH_CAPI float JPH_SliderConstraint_GetMaxFrictionForce(JPH_SliderConstraint* constraint);
JPH_CAPI void JPH_SliderConstraint_SetMotorSettings(JPH_SliderConstraint* constraint, JPH_MotorSettings* settings);
JPH_CAPI void JPH_SliderConstraint_GetMotorSettings(const JPH_SliderConstraint* constraint, JPH_MotorSettings* result);
JPH_CAPI void JPH_SliderConstraint_SetMotorState(JPH_SliderConstraint* constraint, JPH_MotorState state);
JPH_CAPI JPH_MotorState JPH_SliderConstraint_GetMotorState(JPH_SliderConstraint* constraint);
JPH_CAPI void JPH_SliderConstraint_SetTargetVelocity(JPH_SliderConstraint* constraint, float velocity);
JPH_CAPI float JPH_SliderConstraint_GetTargetVelocity(JPH_SliderConstraint* constraint);
JPH_CAPI void JPH_SliderConstraint_SetTargetPosition(JPH_SliderConstraint* constraint, float position);
JPH_CAPI float JPH_SliderConstraint_GetTargetPosition(JPH_SliderConstraint* constraint);
JPH_CAPI void JPH_SliderConstraint_SetLimits(JPH_SliderConstraint* constraint, float inLimitsMin, float inLimitsMax);
JPH_CAPI float JPH_SliderConstraint_GetLimitsMin(JPH_SliderConstraint* constraint);
JPH_CAPI float JPH_SliderConstraint_GetLimitsMax(JPH_SliderConstraint* constraint);
JPH_CAPI bool JPH_SliderConstraint_HasLimits(JPH_SliderConstraint* constraint);
JPH_CAPI void JPH_SliderConstraint_GetLimitsSpringSettings(JPH_SliderConstraint* constraint, JPH_SpringSettings* result);
JPH_CAPI void JPH_SliderConstraint_SetLimitsSpringSettings(JPH_SliderConstraint* constraint, JPH_SpringSettings* settings);
JPH_CAPI void JPH_SliderConstraint_GetTotalLambdaPosition(const JPH_SliderConstraint* constraint, float position[2]);
JPH_CAPI float JPH_SliderConstraint_GetTotalLambdaPositionLimits(const JPH_SliderConstraint* constraint);
JPH_CAPI void JPH_SliderConstraint_GetTotalLambdaRotation(const JPH_SliderConstraint* constraint, JPH_Vec3* result);
JPH_CAPI float JPH_SliderConstraint_GetTotalLambdaMotor(const JPH_SliderConstraint* constraint);

/* JPH_ConeConstraint */
JPH_CAPI void JPH_ConeConstraintSettings_Init(JPH_ConeConstraintSettings* settings);
JPH_CAPI JPH_ConeConstraint* JPH_ConeConstraint_Create(const JPH_ConeConstraintSettings* settings, JPH_Body* body1, JPH_Body* body2);
JPH_CAPI void JPH_ConeConstraint_GetSettings(JPH_ConeConstraint* constraint, JPH_ConeConstraintSettings* settings);
JPH_CAPI void JPH_ConeConstraint_SetHalfConeAngle(JPH_ConeConstraint* constraint, float halfConeAngle);
JPH_CAPI float JPH_ConeConstraint_GetCosHalfConeAngle(const JPH_ConeConstraint* constraint);
JPH_CAPI void JPH_ConeConstraint_GetTotalLambdaPosition(const JPH_ConeConstraint* constraint, JPH_Vec3* result);
JPH_CAPI float JPH_ConeConstraint_GetTotalLambdaRotation(const JPH_ConeConstraint* constraint);

/* JPH_SwingTwistConstraint */
JPH_CAPI void JPH_SwingTwistConstraintSettings_Init(JPH_SwingTwistConstraintSettings* settings);
JPH_CAPI JPH_SwingTwistConstraint* JPH_SwingTwistConstraint_Create(const JPH_SwingTwistConstraintSettings* settings, JPH_Body* body1, JPH_Body* body2);
JPH_CAPI void JPH_SwingTwistConstraint_GetSettings(JPH_SwingTwistConstraint* constraint, JPH_SwingTwistConstraintSettings* settings);
JPH_CAPI float JPH_SwingTwistConstraint_GetNormalHalfConeAngle(JPH_SwingTwistConstraint* constraint);
JPH_CAPI void JPH_SwingTwistConstraint_GetTotalLambdaPosition(const JPH_SwingTwistConstraint* constraint, JPH_Vec3* result);
JPH_CAPI float JPH_SwingTwistConstraint_GetTotalLambdaTwist(const JPH_SwingTwistConstraint* constraint);
JPH_CAPI float JPH_SwingTwistConstraint_GetTotalLambdaSwingY(const JPH_SwingTwistConstraint* constraint);
JPH_CAPI float JPH_SwingTwistConstraint_GetTotalLambdaSwingZ(const JPH_SwingTwistConstraint* constraint);
JPH_CAPI void JPH_SwingTwistConstraint_GetTotalLambdaMotor(const JPH_SwingTwistConstraint* constraint, JPH_Vec3* result);

/* JPH_SixDOFConstraint */
JPH_CAPI void JPH_SixDOFConstraintSettings_Init(JPH_SixDOFConstraintSettings* settings);
JPH_CAPI void JPH_SixDOFConstraintSettings_MakeFreeAxis(JPH_SixDOFConstraintSettings* settings, JPH_SixDOFConstraintAxis axis);
JPH_CAPI bool JPH_SixDOFConstraintSettings_IsFreeAxis(const JPH_SixDOFConstraintSettings* settings, JPH_SixDOFConstraintAxis axis);
JPH_CAPI void JPH_SixDOFConstraintSettings_MakeFixedAxis(JPH_SixDOFConstraintSettings* settings, JPH_SixDOFConstraintAxis axis);
JPH_CAPI bool JPH_SixDOFConstraintSettings_IsFixedAxis(const JPH_SixDOFConstraintSettings* settings, JPH_SixDOFConstraintAxis axis);
JPH_CAPI void JPH_SixDOFConstraintSettings_SetLimitedAxis(JPH_SixDOFConstraintSettings* settings, JPH_SixDOFConstraintAxis axis, float min, float max);

JPH_CAPI JPH_SixDOFConstraint* JPH_SixDOFConstraint_Create(const JPH_SixDOFConstraintSettings* settings, JPH_Body* body1, JPH_Body* body2);
JPH_CAPI void JPH_SixDOFConstraint_GetSettings(JPH_SixDOFConstraint* constraint, JPH_SixDOFConstraintSettings* settings);
JPH_CAPI float JPH_SixDOFConstraint_GetLimitsMin(JPH_SixDOFConstraint* constraint, JPH_SixDOFConstraintAxis axis);
JPH_CAPI float JPH_SixDOFConstraint_GetLimitsMax(JPH_SixDOFConstraint* constraint, JPH_SixDOFConstraintAxis axis);
JPH_CAPI void JPH_SixDOFConstraint_GetTotalLambdaPosition(const JPH_SixDOFConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_SixDOFConstraint_GetTotalLambdaRotation(const JPH_SixDOFConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_SixDOFConstraint_GetTotalLambdaMotorTranslation(const JPH_SixDOFConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_SixDOFConstraint_GetTotalLambdaMotorRotation(const JPH_SixDOFConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_SixDOFConstraint_GetTranslationLimitsMin(const JPH_SixDOFConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_SixDOFConstraint_GetTranslationLimitsMax(const JPH_SixDOFConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_SixDOFConstraint_GetRotationLimitsMin(const JPH_SixDOFConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_SixDOFConstraint_GetRotationLimitsMax(const JPH_SixDOFConstraint* constraint, JPH_Vec3* result);
JPH_CAPI bool JPH_SixDOFConstraint_IsFixedAxis(const JPH_SixDOFConstraint* constraint, JPH_SixDOFConstraintAxis axis);
JPH_CAPI bool JPH_SixDOFConstraint_IsFreeAxis(const JPH_SixDOFConstraint* constraint, JPH_SixDOFConstraintAxis axis);
JPH_CAPI void JPH_SixDOFConstraint_GetLimitsSpringSettings(JPH_SixDOFConstraint* constraint, JPH_SpringSettings* result, JPH_SixDOFConstraintAxis axis);
JPH_CAPI void JPH_SixDOFConstraint_SetLimitsSpringSettings(JPH_SixDOFConstraint* constraint, JPH_SpringSettings* settings, JPH_SixDOFConstraintAxis axis);
JPH_CAPI void JPH_SixDOFConstraint_SetMaxFriction(JPH_SixDOFConstraint* constraint, JPH_SixDOFConstraintAxis axis, float inFriction);
JPH_CAPI float JPH_SixDOFConstraint_GetMaxFriction(JPH_SixDOFConstraint* constraint, JPH_SixDOFConstraintAxis axis);
JPH_CAPI void JPH_SixDOFConstraint_GetRotationInConstraintSpace(JPH_SixDOFConstraint* constraint, JPH_Quat* result);
JPH_CAPI void JPH_SixDOFConstraint_GetMotorSettings(JPH_SixDOFConstraint* constraint, JPH_SixDOFConstraintAxis axis, JPH_MotorSettings* settings);
JPH_CAPI void JPH_SixDOFConstraint_SetMotorState(JPH_SixDOFConstraint* constraint, JPH_SixDOFConstraintAxis axis, JPH_MotorState state);
JPH_CAPI JPH_MotorState JPH_SixDOFConstraint_GetMotorState(JPH_SixDOFConstraint* constraint, JPH_SixDOFConstraintAxis axis);
JPH_CAPI void JPH_SixDOFConstraint_SetTargetVelocityCS(JPH_SixDOFConstraint* constraint, JPH_Vec3* inVelocity);
JPH_CAPI void JPH_SixDOFConstraint_GetTargetVelocityCS(JPH_SixDOFConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_SixDOFConstraint_SetTargetAngularVelocityCS(JPH_SixDOFConstraint* constraint, JPH_Vec3* inAngularVelocity);
JPH_CAPI void JPH_SixDOFConstraint_GetTargetAngularVelocityCS(JPH_SixDOFConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_SixDOFConstraint_SetTargetPositionCS(JPH_SixDOFConstraint* constraint, JPH_Vec3* inPosition);
JPH_CAPI void JPH_SixDOFConstraint_GetTargetPositionCS(JPH_SixDOFConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_SixDOFConstraint_SetTargetOrientationCS(JPH_SixDOFConstraint* constraint, JPH_Quat* inOrientation);
JPH_CAPI void JPH_SixDOFConstraint_GetTargetOrientationCS(JPH_SixDOFConstraint* constraint, JPH_Quat* result);
JPH_CAPI void JPH_SixDOFConstraint_SetTargetOrientationBS(JPH_SixDOFConstraint* constraint, JPH_Quat* inOrientation);

/* JPH_GearConstraint */
JPH_CAPI void JPH_GearConstraintSettings_Init(JPH_GearConstraintSettings* settings);
JPH_CAPI JPH_GearConstraint* JPH_GearConstraint_Create(const JPH_GearConstraintSettings* settings, JPH_Body* body1, JPH_Body* body2);
JPH_CAPI void JPH_GearConstraint_GetSettings(JPH_GearConstraint* constraint, JPH_GearConstraintSettings* settings);
JPH_CAPI void JPH_GearConstraint_SetConstraints(JPH_GearConstraint* constraint, const JPH_Constraint* gear1, const JPH_Constraint* gear2);
JPH_CAPI float JPH_GearConstraint_GetTotalLambda(const JPH_GearConstraint* constraint);

/* BodyInterface */
JPH_CAPI void JPH_BodyInterface_DestroyBody(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyID);
JPH_CAPI JPH_BodyID JPH_BodyInterface_CreateAndAddBody(JPH_BodyInterface* bodyInterface, const JPH_BodyCreationSettings* settings, JPH_Activation activationMode);
JPH_CAPI JPH_Body* JPH_BodyInterface_CreateBody(JPH_BodyInterface* bodyInterface, const JPH_BodyCreationSettings* settings);
JPH_CAPI JPH_Body* JPH_BodyInterface_CreateBodyWithID(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyID, const JPH_BodyCreationSettings* settings);
JPH_CAPI JPH_Body* JPH_BodyInterface_CreateBodyWithoutID(JPH_BodyInterface* bodyInterface, const JPH_BodyCreationSettings* settings);
JPH_CAPI void JPH_BodyInterface_DestroyBodyWithoutID(JPH_BodyInterface* bodyInterface, JPH_Body* body);
JPH_CAPI bool JPH_BodyInterface_AssignBodyID(JPH_BodyInterface* bodyInterface, JPH_Body* body);
JPH_CAPI bool JPH_BodyInterface_AssignBodyID2(JPH_BodyInterface* bodyInterface, JPH_Body* body, JPH_BodyID bodyID);
JPH_CAPI JPH_Body* JPH_BodyInterface_UnassignBodyID(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyID);

JPH_CAPI JPH_Body* JPH_BodyInterface_CreateSoftBody(JPH_BodyInterface* bodyInterface, const JPH_SoftBodyCreationSettings* settings);
JPH_CAPI JPH_Body* JPH_BodyInterface_CreateSoftBodyWithID(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyID, const JPH_SoftBodyCreationSettings* settings);
JPH_CAPI JPH_Body* JPH_BodyInterface_CreateSoftBodyWithoutID(JPH_BodyInterface* bodyInterface, const JPH_SoftBodyCreationSettings* settings);
JPH_CAPI JPH_BodyID JPH_BodyInterface_CreateAndAddSoftBody(JPH_BodyInterface* bodyInterface, const JPH_SoftBodyCreationSettings* settings, JPH_Activation activationMode);

JPH_CAPI void JPH_BodyInterface_AddBody(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyID, JPH_Activation activationMode);
JPH_CAPI void JPH_BodyInterface_RemoveBody(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyID);
JPH_CAPI void JPH_BodyInterface_RemoveAndDestroyBody(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyID);
JPH_CAPI bool JPH_BodyInterface_IsAdded(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyID);
JPH_CAPI JPH_BodyType JPH_BodyInterface_GetBodyType(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyID);

JPH_CAPI void JPH_BodyInterface_SetLinearVelocity(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyID, const JPH_Vec3* velocity);
JPH_CAPI void JPH_BodyInterface_GetLinearVelocity(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyID, JPH_Vec3* velocity);
JPH_CAPI void JPH_BodyInterface_GetCenterOfMassPosition(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyID, JPH_RVec3* position);

JPH_CAPI JPH_MotionType JPH_BodyInterface_GetMotionType(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyID);
JPH_CAPI void JPH_BodyInterface_SetMotionType(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyID, JPH_MotionType motionType, JPH_Activation activationMode);

JPH_CAPI float JPH_BodyInterface_GetRestitution(const JPH_BodyInterface* bodyInterface, JPH_BodyID bodyID);
JPH_CAPI void JPH_BodyInterface_SetRestitution(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyID, float restitution);

JPH_CAPI float JPH_BodyInterface_GetFriction(const JPH_BodyInterface* bodyInterface, JPH_BodyID bodyID);
JPH_CAPI void JPH_BodyInterface_SetFriction(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyID, float friction);

JPH_CAPI void JPH_BodyInterface_SetPosition(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_RVec3* position, JPH_Activation activationMode);
JPH_CAPI void JPH_BodyInterface_GetPosition(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_RVec3* result);

JPH_CAPI void JPH_BodyInterface_SetRotation(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_Quat* rotation, JPH_Activation activationMode);
JPH_CAPI void JPH_BodyInterface_GetRotation(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_Quat* result);

JPH_CAPI void JPH_BodyInterface_SetPositionAndRotation(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, const JPH_RVec3* position, const JPH_Quat* rotation, JPH_Activation activationMode);
JPH_CAPI void JPH_BodyInterface_SetPositionAndRotationWhenChanged(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, const JPH_RVec3* position, const JPH_Quat* rotation, JPH_Activation activationMode);
JPH_CAPI void JPH_BodyInterface_GetPositionAndRotation(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_RVec3* position, JPH_Quat* rotation);
JPH_CAPI void JPH_BodyInterface_SetPositionRotationAndVelocity(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_RVec3* position, JPH_Quat* rotation, JPH_Vec3* linearVelocity, JPH_Vec3* angularVelocity);

JPH_CAPI void JPH_BodyInterface_GetCollisionGroup(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_CollisionGroup* result);
JPH_CAPI void JPH_BodyInterface_SetCollisionGroup(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, const JPH_CollisionGroup* group);

JPH_CAPI const JPH_Shape* JPH_BodyInterface_GetShape(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId);
JPH_CAPI void JPH_BodyInterface_SetShape(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, const JPH_Shape* shape, bool updateMassProperties, JPH_Activation activationMode);
JPH_CAPI void JPH_BodyInterface_NotifyShapeChanged(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_Vec3* previousCenterOfMass, bool updateMassProperties, JPH_Activation activationMode);

JPH_CAPI void JPH_BodyInterface_ActivateBody(JPH_BodyInterface* bodyInterface, const JPH_BodyID bodyId);
JPH_CAPI void JPH_BodyInterface_ActivateBodies(JPH_BodyInterface* bodyInterface, const JPH_BodyID* bodyIDs, uint32_t count);
JPH_CAPI void JPH_BodyInterface_ActivateBodiesInAABox(JPH_BodyInterface* bodyInterface, const JPH_AABox* box, const JPH_BroadPhaseLayerFilter* broadPhaseLayerFilter, const JPH_ObjectLayerFilter* objectLayerFilter);
JPH_CAPI void JPH_BodyInterface_DeactivateBody(JPH_BodyInterface* bodyInterface, const JPH_BodyID bodyId);
JPH_CAPI void JPH_BodyInterface_DeactivateBodies(JPH_BodyInterface* bodyInterface, const JPH_BodyID* bodyIDs, uint32_t count);
JPH_CAPI bool JPH_BodyInterface_IsActive(const JPH_BodyInterface* bodyInterface, const JPH_BodyID bodyID);
JPH_CAPI void JPH_BodyInterface_ResetSleepTimer(JPH_BodyInterface* bodyInterface, const JPH_BodyID bodyID);

JPH_CAPI JPH_ObjectLayer JPH_BodyInterface_GetObjectLayer(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId);
JPH_CAPI void JPH_BodyInterface_SetObjectLayer(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_ObjectLayer layer);

JPH_CAPI void JPH_BodyInterface_GetWorldTransform(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_RMat4* result);
JPH_CAPI void JPH_BodyInterface_GetCenterOfMassTransform(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_RMat4* result);

JPH_CAPI void JPH_BodyInterface_MoveKinematic(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_RVec3* targetPosition, JPH_Quat* targetRotation, float deltaTime);
JPH_CAPI bool JPH_BodyInterface_ApplyBuoyancyImpulse(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, const JPH_RVec3* surfacePosition, const JPH_Vec3* surfaceNormal, float buoyancy, float linearDrag, float angularDrag, const JPH_Vec3* fluidVelocity, const JPH_Vec3* gravity, float deltaTime);

JPH_CAPI void JPH_BodyInterface_SetLinearAndAngularVelocity(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_Vec3* linearVelocity, JPH_Vec3* angularVelocity);
JPH_CAPI void JPH_BodyInterface_GetLinearAndAngularVelocity(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_Vec3* linearVelocity, JPH_Vec3* angularVelocity);

JPH_CAPI void JPH_BodyInterface_AddLinearVelocity(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_Vec3* linearVelocity);
JPH_CAPI void JPH_BodyInterface_AddLinearAndAngularVelocity(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_Vec3* linearVelocity, JPH_Vec3* angularVelocity);

JPH_CAPI void JPH_BodyInterface_SetAngularVelocity(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_Vec3* angularVelocity);
JPH_CAPI void JPH_BodyInterface_GetAngularVelocity(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_Vec3* angularVelocity);

JPH_CAPI void JPH_BodyInterface_GetPointVelocity(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_RVec3* point, JPH_Vec3* velocity);

JPH_CAPI void JPH_BodyInterface_AddForce(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_Vec3* force);
JPH_CAPI void JPH_BodyInterface_AddForce2(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_Vec3* force, JPH_RVec3* point);
JPH_CAPI void JPH_BodyInterface_AddTorque(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_Vec3* torque);
JPH_CAPI void JPH_BodyInterface_AddForceAndTorque(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_Vec3* force, JPH_Vec3* torque);

JPH_CAPI void JPH_BodyInterface_AddImpulse(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_Vec3* impulse);
JPH_CAPI void JPH_BodyInterface_AddImpulse2(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_Vec3* impulse, JPH_RVec3* point);
JPH_CAPI void JPH_BodyInterface_AddAngularImpulse(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_Vec3* angularImpulse);

JPH_CAPI void JPH_BodyInterface_SetMotionQuality(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_MotionQuality quality);
JPH_CAPI JPH_MotionQuality JPH_BodyInterface_GetMotionQuality(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId);

JPH_CAPI void JPH_BodyInterface_GetInverseInertia(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_Mat4* result);

JPH_CAPI void JPH_BodyInterface_SetGravityFactor(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, float value);
JPH_CAPI float JPH_BodyInterface_GetGravityFactor(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId);

JPH_CAPI void JPH_BodyInterface_SetUseManifoldReduction(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, bool value);
JPH_CAPI bool JPH_BodyInterface_GetUseManifoldReduction(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId);

JPH_CAPI void JPH_BodyInterface_SetUserData(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, uint64_t inUserData);
JPH_CAPI uint64_t JPH_BodyInterface_GetUserData(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId);

JPH_CAPI void JPH_BodyInterface_SetIsSensor(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, bool value);
JPH_CAPI bool JPH_BodyInterface_IsSensor(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId);

JPH_CAPI const JPH_PhysicsMaterial* JPH_BodyInterface_GetMaterial(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId, JPH_SubShapeID subShapeID);

JPH_CAPI void JPH_BodyInterface_InvalidateContactCache(JPH_BodyInterface* bodyInterface, JPH_BodyID bodyId);

//--------------------------------------------------------------------------------------------------
// JPH_BodyLockInterface
//--------------------------------------------------------------------------------------------------
JPH_CAPI void JPH_BodyLockInterface_LockRead(const JPH_BodyLockInterface* lockInterface, JPH_BodyID bodyID, JPH_BodyLockRead* outLock);
JPH_CAPI void JPH_BodyLockInterface_UnlockRead(const JPH_BodyLockInterface* lockInterface, JPH_BodyLockRead* ioLock);

JPH_CAPI void JPH_BodyLockInterface_LockWrite(const JPH_BodyLockInterface* lockInterface, JPH_BodyID bodyID, JPH_BodyLockWrite* outLock);
JPH_CAPI void JPH_BodyLockInterface_UnlockWrite(const JPH_BodyLockInterface* lockInterface, JPH_BodyLockWrite* ioLock);

JPH_CAPI JPH_BodyLockMultiRead* JPH_BodyLockInterface_LockMultiRead(const JPH_BodyLockInterface* lockInterface, const JPH_BodyID* bodyIDs, uint32_t count);
JPH_CAPI void JPH_BodyLockMultiRead_Destroy(JPH_BodyLockMultiRead* ioLock);
JPH_CAPI const JPH_Body* JPH_BodyLockMultiRead_GetBody(JPH_BodyLockMultiRead* ioLock, uint32_t bodyIndex);

JPH_CAPI JPH_BodyLockMultiWrite* JPH_BodyLockInterface_LockMultiWrite(const JPH_BodyLockInterface* lockInterface, const JPH_BodyID* bodyIDs, uint32_t count);
JPH_CAPI void JPH_BodyLockMultiWrite_Destroy(JPH_BodyLockMultiWrite* ioLock);
JPH_CAPI JPH_Body* JPH_BodyLockMultiWrite_GetBody(JPH_BodyLockMultiWrite* ioLock, uint32_t bodyIndex);

//--------------------------------------------------------------------------------------------------
// JPH_MotionProperties
//--------------------------------------------------------------------------------------------------
JPH_CAPI JPH_AllowedDOFs JPH_MotionProperties_GetAllowedDOFs(const JPH_MotionProperties* properties);
JPH_CAPI void JPH_MotionProperties_SetLinearDamping(JPH_MotionProperties* properties, float damping);
JPH_CAPI float JPH_MotionProperties_GetLinearDamping(const JPH_MotionProperties* properties);
JPH_CAPI void JPH_MotionProperties_SetAngularDamping(JPH_MotionProperties* properties, float damping);
JPH_CAPI float JPH_MotionProperties_GetAngularDamping(const JPH_MotionProperties* properties);
JPH_CAPI void JPH_MotionProperties_SetMassProperties(JPH_MotionProperties* properties, JPH_AllowedDOFs allowedDOFs, const JPH_MassProperties* massProperties);
JPH_CAPI float JPH_MotionProperties_GetInverseMassUnchecked(JPH_MotionProperties* properties);
JPH_CAPI void JPH_MotionProperties_SetInverseMass(JPH_MotionProperties* properties, float inverseMass);
JPH_CAPI void JPH_MotionProperties_GetInverseInertiaDiagonal(JPH_MotionProperties* properties, JPH_Vec3* result);
JPH_CAPI void JPH_MotionProperties_GetInertiaRotation(JPH_MotionProperties* properties, JPH_Quat* result);
JPH_CAPI void JPH_MotionProperties_SetInverseInertia(JPH_MotionProperties* properties, JPH_Vec3* diagonal, JPH_Quat* rot);
JPH_CAPI void JPH_MotionProperties_ScaleToMass(JPH_MotionProperties* properties, float mass);

//--------------------------------------------------------------------------------------------------
// JPH_RayCast
//--------------------------------------------------------------------------------------------------
JPH_CAPI void JPH_RayCast_GetPointOnRay(const JPH_Vec3* origin, const JPH_Vec3* direction, float fraction, JPH_Vec3* result);
JPH_CAPI void JPH_RRayCast_GetPointOnRay(const JPH_RVec3* origin, const JPH_Vec3* direction, float fraction, JPH_RVec3* result);

//--------------------------------------------------------------------------------------------------
// JPH_MassProperties
//--------------------------------------------------------------------------------------------------
JPH_CAPI void JPH_MassProperties_DecomposePrincipalMomentsOfInertia(JPH_MassProperties* properties, JPH_Mat4* rotation, JPH_Vec3* diagonal);
JPH_CAPI void JPH_MassProperties_ScaleToMass(JPH_MassProperties* properties, float mass);
JPH_CAPI void JPH_MassProperties_GetEquivalentSolidBoxSize(float mass, const JPH_Vec3* inertiaDiagonal, JPH_Vec3* result);

//--------------------------------------------------------------------------------------------------
// JPH_CollideShapeSettings
//--------------------------------------------------------------------------------------------------
JPH_CAPI void JPH_CollideShapeSettings_Init(JPH_CollideShapeSettings* settings);

//--------------------------------------------------------------------------------------------------
// JPH_ShapeCastSettings
//--------------------------------------------------------------------------------------------------
JPH_CAPI void JPH_ShapeCastSettings_Init(JPH_ShapeCastSettings* settings);

//--------------------------------------------------------------------------------------------------
// JPH_BroadPhaseQuery
//--------------------------------------------------------------------------------------------------
JPH_CAPI bool JPH_BroadPhaseQuery_CastRay(const JPH_BroadPhaseQuery* query,
	const JPH_Vec3* origin, const JPH_Vec3* direction,
	JPH_RayCastBodyCollectorCallback* callback, void* userData,
	const JPH_BroadPhaseLayerFilter* broadPhaseLayerFilter,
	const JPH_ObjectLayerFilter* objectLayerFilter);

JPH_CAPI bool JPH_BroadPhaseQuery_CastRay2(const JPH_BroadPhaseQuery* query,
	const JPH_Vec3* origin, const JPH_Vec3* direction,
	JPH_CollisionCollectorType collectorType,
	JPH_RayCastBodyResultCallback* callback, void* userData,
	const JPH_BroadPhaseLayerFilter* broadPhaseLayerFilter,
	const JPH_ObjectLayerFilter* objectLayerFilter);

JPH_CAPI bool JPH_BroadPhaseQuery_CollideAABox(const JPH_BroadPhaseQuery* query,
	const JPH_AABox* box, JPH_CollideShapeBodyCollectorCallback* callback, void* userData,
	const JPH_BroadPhaseLayerFilter* broadPhaseLayerFilter,
	const JPH_ObjectLayerFilter* objectLayerFilter);

JPH_CAPI bool JPH_BroadPhaseQuery_CollideSphere(const JPH_BroadPhaseQuery* query,
	const JPH_Vec3* center, float radius, JPH_CollideShapeBodyCollectorCallback* callback, void* userData,
	const JPH_BroadPhaseLayerFilter* broadPhaseLayerFilter,
	const JPH_ObjectLayerFilter* objectLayerFilter);

JPH_CAPI bool JPH_BroadPhaseQuery_CollidePoint(const JPH_BroadPhaseQuery* query,
	const JPH_Vec3* point, JPH_CollideShapeBodyCollectorCallback* callback, void* userData,
	const JPH_BroadPhaseLayerFilter* broadPhaseLayerFilter,
	const JPH_ObjectLayerFilter* objectLayerFilter);

//--------------------------------------------------------------------------------------------------
// JPH_NarrowPhaseQuery
//--------------------------------------------------------------------------------------------------
JPH_CAPI bool JPH_NarrowPhaseQuery_CastRay(const JPH_NarrowPhaseQuery* query,
	const JPH_RVec3* origin, const JPH_Vec3* direction,
	JPH_RayCastResult* hit,
	const JPH_BroadPhaseLayerFilter* broadPhaseLayerFilter,
	const JPH_ObjectLayerFilter* objectLayerFilter,
	const JPH_BodyFilter* bodyFilter);

JPH_CAPI bool JPH_NarrowPhaseQuery_CastRay2(const JPH_NarrowPhaseQuery* query,
	const JPH_RVec3* origin, const JPH_Vec3* direction,
	const JPH_RayCastSettings* rayCastSettings,
	JPH_CastRayCollectorCallback* callback, void* userData,
	const JPH_BroadPhaseLayerFilter* broadPhaseLayerFilter,
	const JPH_ObjectLayerFilter* objectLayerFilter,
	const JPH_BodyFilter* bodyFilter,
	const JPH_ShapeFilter* shapeFilter);

JPH_CAPI bool JPH_NarrowPhaseQuery_CastRay3(const JPH_NarrowPhaseQuery* query,
	const JPH_RVec3* origin, const JPH_Vec3* direction,
	const JPH_RayCastSettings* rayCastSettings,
	JPH_CollisionCollectorType collectorType,
	JPH_CastRayResultCallback* callback, void* userData,
	const JPH_BroadPhaseLayerFilter* broadPhaseLayerFilter,
	const JPH_ObjectLayerFilter* objectLayerFilter,
	const JPH_BodyFilter* bodyFilter,
	const JPH_ShapeFilter* shapeFilter);

JPH_CAPI bool JPH_NarrowPhaseQuery_CollidePoint(const JPH_NarrowPhaseQuery* query,
	const JPH_RVec3* point,
	JPH_CollidePointCollectorCallback* callback, void* userData,
	const JPH_BroadPhaseLayerFilter* broadPhaseLayerFilter,
	const JPH_ObjectLayerFilter* objectLayerFilter,
	const JPH_BodyFilter* bodyFilter,
	const JPH_ShapeFilter* shapeFilter);

JPH_CAPI bool JPH_NarrowPhaseQuery_CollidePoint2(const JPH_NarrowPhaseQuery* query,
	const JPH_RVec3* point,
	JPH_CollisionCollectorType collectorType,
	JPH_CollidePointResultCallback* callback, void* userData,
	const JPH_BroadPhaseLayerFilter* broadPhaseLayerFilter,
	const JPH_ObjectLayerFilter* objectLayerFilter,
	const JPH_BodyFilter* bodyFilter,
	const JPH_ShapeFilter* shapeFilter);

JPH_CAPI bool JPH_NarrowPhaseQuery_CollideShape(const JPH_NarrowPhaseQuery* query,
	const JPH_Shape* shape, const JPH_Vec3* scale, const JPH_RMat4* centerOfMassTransform,
	const JPH_CollideShapeSettings* settings,
	JPH_RVec3* baseOffset,
	JPH_CollideShapeCollectorCallback* callback, void* userData,
	const JPH_BroadPhaseLayerFilter* broadPhaseLayerFilter,
	const JPH_ObjectLayerFilter* objectLayerFilter,
	const JPH_BodyFilter* bodyFilter,
	const JPH_ShapeFilter* shapeFilter);

JPH_CAPI bool JPH_NarrowPhaseQuery_CollideShape2(const JPH_NarrowPhaseQuery* query,
	const JPH_Shape* shape, const JPH_Vec3* scale, const JPH_RMat4* centerOfMassTransform,
	const JPH_CollideShapeSettings* settings,
	JPH_RVec3* baseOffset,
	JPH_CollisionCollectorType collectorType,
	JPH_CollideShapeResultCallback* callback, void* userData,
	const JPH_BroadPhaseLayerFilter* broadPhaseLayerFilter,
	const JPH_ObjectLayerFilter* objectLayerFilter,
	const JPH_BodyFilter* bodyFilter,
	const JPH_ShapeFilter* shapeFilter);

JPH_CAPI bool JPH_NarrowPhaseQuery_CastShape(const JPH_NarrowPhaseQuery* query,
	const JPH_Shape* shape,
	const JPH_RMat4* worldTransform, const JPH_Vec3* direction,
	const JPH_ShapeCastSettings* settings,
	JPH_RVec3* baseOffset,
	JPH_CastShapeCollectorCallback* callback, void* userData,
	const JPH_BroadPhaseLayerFilter* broadPhaseLayerFilter,
	const JPH_ObjectLayerFilter* objectLayerFilter,
	const JPH_BodyFilter* bodyFilter,
	const JPH_ShapeFilter* shapeFilter);

JPH_CAPI bool JPH_NarrowPhaseQuery_CastShape2(const JPH_NarrowPhaseQuery* query,
	const JPH_Shape* shape,
	const JPH_RMat4* worldTransform, const JPH_Vec3* direction,
	const JPH_ShapeCastSettings* settings,
	JPH_RVec3* baseOffset,
	JPH_CollisionCollectorType collectorType,
	JPH_CastShapeResultCallback* callback, void* userData,
	const JPH_BroadPhaseLayerFilter* broadPhaseLayerFilter,
	const JPH_ObjectLayerFilter* objectLayerFilter,
	const JPH_BodyFilter* bodyFilter,
	const JPH_ShapeFilter* shapeFilter);

//--------------------------------------------------------------------------------------------------
// JPH_Body
//--------------------------------------------------------------------------------------------------
JPH_CAPI JPH_BodyID JPH_Body_GetID(const JPH_Body* body);
JPH_CAPI JPH_BodyType JPH_Body_GetBodyType(const JPH_Body* body);
JPH_CAPI bool JPH_Body_IsRigidBody(const JPH_Body* body);
JPH_CAPI bool JPH_Body_IsSoftBody(const JPH_Body* body);
JPH_CAPI bool JPH_Body_IsActive(const JPH_Body* body);
JPH_CAPI bool JPH_Body_IsStatic(const JPH_Body* body);
JPH_CAPI bool JPH_Body_IsKinematic(const JPH_Body* body);
JPH_CAPI bool JPH_Body_IsDynamic(const JPH_Body* body);
JPH_CAPI bool JPH_Body_CanBeKinematicOrDynamic(const JPH_Body* body);

JPH_CAPI void JPH_Body_SetIsSensor(JPH_Body* body, bool value);
JPH_CAPI bool JPH_Body_IsSensor(const JPH_Body* body);

JPH_CAPI void JPH_Body_SetCollideKinematicVsNonDynamic(JPH_Body* body, bool value);
JPH_CAPI bool JPH_Body_GetCollideKinematicVsNonDynamic(const JPH_Body* body);

JPH_CAPI void JPH_Body_SetUseManifoldReduction(JPH_Body* body, bool value);
JPH_CAPI bool JPH_Body_GetUseManifoldReduction(const JPH_Body* body);
JPH_CAPI bool JPH_Body_GetUseManifoldReductionWithBody(const JPH_Body* body, const JPH_Body* other);

JPH_CAPI void JPH_Body_SetApplyGyroscopicForce(JPH_Body* body, bool value);
JPH_CAPI bool JPH_Body_GetApplyGyroscopicForce(const JPH_Body* body);

JPH_CAPI void JPH_Body_SetEnhancedInternalEdgeRemoval(JPH_Body* body, bool value);
JPH_CAPI bool JPH_Body_GetEnhancedInternalEdgeRemoval(const JPH_Body* body);
JPH_CAPI bool JPH_Body_GetEnhancedInternalEdgeRemovalWithBody(const JPH_Body* body, const JPH_Body* other);

JPH_CAPI JPH_MotionType JPH_Body_GetMotionType(const JPH_Body* body);
JPH_CAPI void JPH_Body_SetMotionType(JPH_Body* body, JPH_MotionType motionType);

JPH_CAPI JPH_BroadPhaseLayer JPH_Body_GetBroadPhaseLayer(const JPH_Body* body);
JPH_CAPI JPH_ObjectLayer JPH_Body_GetObjectLayer(const JPH_Body* body);

JPH_CAPI void JPH_Body_GetCollisionGroup(const JPH_Body* body, JPH_CollisionGroup* result);
JPH_CAPI void JPH_Body_SetCollisionGroup(JPH_Body* body, const JPH_CollisionGroup* value);

JPH_CAPI bool JPH_Body_GetAllowSleeping(JPH_Body* body);
JPH_CAPI void JPH_Body_SetAllowSleeping(JPH_Body* body, bool allowSleeping);
JPH_CAPI void JPH_Body_ResetSleepTimer(JPH_Body* body);

JPH_CAPI float JPH_Body_GetFriction(const JPH_Body* body);
JPH_CAPI void JPH_Body_SetFriction(JPH_Body* body, float friction);
JPH_CAPI float JPH_Body_GetRestitution(const JPH_Body* body);
JPH_CAPI void JPH_Body_SetRestitution(JPH_Body* body, float restitution);
JPH_CAPI void JPH_Body_GetLinearVelocity(JPH_Body* body, JPH_Vec3* velocity);
JPH_CAPI void JPH_Body_SetLinearVelocity(JPH_Body* body, const JPH_Vec3* velocity);
JPH_CAPI void JPH_Body_SetLinearVelocityClamped(JPH_Body* body, const JPH_Vec3* velocity);
JPH_CAPI void JPH_Body_GetAngularVelocity(JPH_Body* body, JPH_Vec3* velocity);
JPH_CAPI void JPH_Body_SetAngularVelocity(JPH_Body* body, const JPH_Vec3* velocity);
JPH_CAPI void JPH_Body_SetAngularVelocityClamped(JPH_Body* body, const JPH_Vec3* velocity);

JPH_CAPI void JPH_Body_GetPointVelocityCOM(JPH_Body* body, const JPH_Vec3* pointRelativeToCOM, JPH_Vec3* velocity);
JPH_CAPI void JPH_Body_GetPointVelocity(JPH_Body* body, const JPH_RVec3* point, JPH_Vec3* velocity);

JPH_CAPI void JPH_Body_AddForce(JPH_Body* body, const JPH_Vec3* force);
JPH_CAPI void JPH_Body_AddForceAtPosition(JPH_Body* body, const JPH_Vec3* force, const JPH_RVec3* position);
JPH_CAPI void JPH_Body_AddTorque(JPH_Body* body, const JPH_Vec3* force);
JPH_CAPI void JPH_Body_GetAccumulatedForce(JPH_Body* body, JPH_Vec3* force);
JPH_CAPI void JPH_Body_GetAccumulatedTorque(JPH_Body* body, JPH_Vec3* force);
JPH_CAPI void JPH_Body_ResetForce(JPH_Body* body);
JPH_CAPI void JPH_Body_ResetTorque(JPH_Body* body);
JPH_CAPI void JPH_Body_ResetMotion(JPH_Body* body);

JPH_CAPI void JPH_Body_GetInverseInertia(JPH_Body* body, JPH_Mat4* result);

JPH_CAPI void JPH_Body_AddImpulse(JPH_Body* body, const JPH_Vec3* impulse);
JPH_CAPI void JPH_Body_AddImpulseAtPosition(JPH_Body* body, const JPH_Vec3* impulse, const JPH_RVec3* position);
JPH_CAPI void JPH_Body_AddAngularImpulse(JPH_Body* body, const JPH_Vec3* angularImpulse);
JPH_CAPI void JPH_Body_MoveKinematic(JPH_Body* body, JPH_RVec3* targetPosition, JPH_Quat* targetRotation, float deltaTime);
JPH_CAPI bool JPH_Body_ApplyBuoyancyImpulse(JPH_Body* body, const JPH_RVec3* surfacePosition, const JPH_Vec3* surfaceNormal, float buoyancy, float linearDrag, float angularDrag, const JPH_Vec3* fluidVelocity, const JPH_Vec3* gravity, float deltaTime);

JPH_CAPI bool JPH_Body_IsInBroadPhase(JPH_Body* body);
JPH_CAPI bool JPH_Body_IsCollisionCacheInvalid(JPH_Body* body);

JPH_CAPI const JPH_Shape* JPH_Body_GetShape(JPH_Body* body);

JPH_CAPI void JPH_Body_GetPosition(const JPH_Body* body, JPH_RVec3* result);
JPH_CAPI void JPH_Body_GetRotation(const JPH_Body* body, JPH_Quat* result);
JPH_CAPI void JPH_Body_GetWorldTransform(const JPH_Body* body, JPH_RMat4* result);
JPH_CAPI void JPH_Body_GetCenterOfMassPosition(const JPH_Body* body, JPH_RVec3* result);
JPH_CAPI void JPH_Body_GetCenterOfMassTransform(const JPH_Body* body, JPH_RMat4* result);
JPH_CAPI void JPH_Body_GetInverseCenterOfMassTransform(const JPH_Body* body, JPH_RMat4* result);

JPH_CAPI void JPH_Body_GetWorldSpaceBounds(const JPH_Body* body, JPH_AABox* result);
JPH_CAPI void JPH_Body_GetWorldSpaceSurfaceNormal(const JPH_Body* body, JPH_SubShapeID subShapeID, const JPH_RVec3* position, JPH_Vec3* normal);

JPH_CAPI JPH_MotionProperties* JPH_Body_GetMotionProperties(JPH_Body* body);
JPH_CAPI JPH_MotionProperties* JPH_Body_GetMotionPropertiesUnchecked(JPH_Body* body);

JPH_CAPI void JPH_Body_SetUserData(JPH_Body* body, uint64_t userData);
JPH_CAPI uint64_t JPH_Body_GetUserData(JPH_Body* body);

JPH_CAPI JPH_Body* JPH_Body_GetFixedToWorldBody(void);

/* JPH_BroadPhaseLayerFilter_Procs */
typedef struct JPH_BroadPhaseLayerFilter_Procs {
	bool(JPH_API_CALL* ShouldCollide)(void* userData, JPH_BroadPhaseLayer layer);
} JPH_BroadPhaseLayerFilter_Procs;

JPH_CAPI void JPH_BroadPhaseLayerFilter_SetProcs(const JPH_BroadPhaseLayerFilter_Procs* procs);
JPH_CAPI JPH_BroadPhaseLayerFilter* JPH_BroadPhaseLayerFilter_Create(void* userData);
JPH_CAPI void JPH_BroadPhaseLayerFilter_Destroy(JPH_BroadPhaseLayerFilter* filter);

/* JPH_ObjectLayerFilter */
typedef struct JPH_ObjectLayerFilter_Procs {
	bool(JPH_API_CALL* ShouldCollide)(void* userData, JPH_ObjectLayer layer);
} JPH_ObjectLayerFilter_Procs;

JPH_CAPI void JPH_ObjectLayerFilter_SetProcs(const JPH_ObjectLayerFilter_Procs* procs);
JPH_CAPI JPH_ObjectLayerFilter* JPH_ObjectLayerFilter_Create(void* userData);
JPH_CAPI void JPH_ObjectLayerFilter_Destroy(JPH_ObjectLayerFilter* filter);

/* JPH_BodyFilter */
typedef struct JPH_BodyFilter_Procs {
	bool(JPH_API_CALL* ShouldCollide)(void* userData, JPH_BodyID bodyID);
	bool(JPH_API_CALL* ShouldCollideLocked)(void* userData, const JPH_Body* bodyID);
} JPH_BodyFilter_Procs;

JPH_CAPI void JPH_BodyFilter_SetProcs(const JPH_BodyFilter_Procs* procs);
JPH_CAPI JPH_BodyFilter* JPH_BodyFilter_Create(void* userData);
JPH_CAPI void JPH_BodyFilter_Destroy(JPH_BodyFilter* filter);

/* JPH_ShapeFilter */
typedef struct JPH_ShapeFilter_Procs {
	bool(JPH_API_CALL* ShouldCollide)(void* userData, const JPH_Shape* shape2, const JPH_SubShapeID* subShapeIDOfShape2);
	bool(JPH_API_CALL* ShouldCollide2)(void* userData, const JPH_Shape* shape1, const JPH_SubShapeID* subShapeIDOfShape1, const JPH_Shape* shape2, const JPH_SubShapeID* subShapeIDOfShape2);
} JPH_ShapeFilter_Procs;

JPH_CAPI void JPH_ShapeFilter_SetProcs(const JPH_ShapeFilter_Procs* procs);
JPH_CAPI JPH_ShapeFilter* JPH_ShapeFilter_Create(void* userData);
JPH_CAPI void JPH_ShapeFilter_Destroy(JPH_ShapeFilter* filter);
JPH_CAPI JPH_BodyID JPH_ShapeFilter_GetBodyID2(JPH_ShapeFilter* filter);
JPH_CAPI void JPH_ShapeFilter_SetBodyID2(JPH_ShapeFilter* filter, JPH_BodyID id);

/* JPH_SimShapeFilter */
typedef struct JPH_SimShapeFilter_Procs {
	bool(JPH_API_CALL* ShouldCollide)(void* userData, 
		const JPH_Body* body1, 
		const JPH_Shape* shape1, 
		const JPH_SubShapeID* subShapeIDOfShape1,
		const JPH_Body* body2,
		const JPH_Shape* shape2, 
		const JPH_SubShapeID* subShapeIDOfShape2
		);
} JPH_SimShapeFilter_Procs;

JPH_CAPI void JPH_SimShapeFilter_SetProcs(const JPH_SimShapeFilter_Procs* procs);
JPH_CAPI JPH_SimShapeFilter* JPH_SimShapeFilter_Create(void* userData);
JPH_CAPI void JPH_SimShapeFilter_Destroy(JPH_SimShapeFilter* filter);

/* Contact listener */
typedef struct JPH_ContactListener_Procs {
	JPH_ValidateResult(JPH_API_CALL* OnContactValidate)(void* userData,
		const JPH_Body* body1,
		const JPH_Body* body2,
		const JPH_RVec3* baseOffset,
		const JPH_CollideShapeResult* collisionResult);

	void(JPH_API_CALL* OnContactAdded)(void* userData,
		const JPH_Body* body1,
		const JPH_Body* body2,
		const JPH_ContactManifold* manifold,
		JPH_ContactSettings* settings);

	void(JPH_API_CALL* OnContactPersisted)(void* userData,
		const JPH_Body* body1,
		const JPH_Body* body2,
		const JPH_ContactManifold* manifold,
		JPH_ContactSettings* settings);

	void(JPH_API_CALL* OnContactRemoved)(void* userData,
		const JPH_SubShapeIDPair* subShapePair
		);
} JPH_ContactListener_Procs;

JPH_CAPI void JPH_ContactListener_SetProcs(const JPH_ContactListener_Procs* procs);
JPH_CAPI JPH_ContactListener* JPH_ContactListener_Create(void* userData);
JPH_CAPI void JPH_ContactListener_Destroy(JPH_ContactListener* listener);

/* BodyActivationListener */
typedef struct JPH_BodyActivationListener_Procs {
	void(JPH_API_CALL* OnBodyActivated)(void* userData, JPH_BodyID bodyID, uint64_t bodyUserData);
	void(JPH_API_CALL* OnBodyDeactivated)(void* userData, JPH_BodyID bodyID, uint64_t bodyUserData);
} JPH_BodyActivationListener_Procs;

JPH_CAPI void JPH_BodyActivationListener_SetProcs(const JPH_BodyActivationListener_Procs* procs);
JPH_CAPI JPH_BodyActivationListener* JPH_BodyActivationListener_Create(void* userData);
JPH_CAPI void JPH_BodyActivationListener_Destroy(JPH_BodyActivationListener* listener);

/* JPH_BodyDrawFilter */
typedef struct JPH_BodyDrawFilter_Procs {
	bool(JPH_API_CALL* ShouldDraw)(void* userData, const JPH_Body* body);
} JPH_BodyDrawFilter_Procs;

JPH_CAPI void JPH_BodyDrawFilter_SetProcs(const JPH_BodyDrawFilter_Procs* procs);
JPH_CAPI JPH_BodyDrawFilter* JPH_BodyDrawFilter_Create(void* userData);
JPH_CAPI void JPH_BodyDrawFilter_Destroy(JPH_BodyDrawFilter* filter);

/* ContactManifold */
JPH_CAPI void JPH_ContactManifold_GetWorldSpaceNormal(const JPH_ContactManifold* manifold, JPH_Vec3* result);
JPH_CAPI float JPH_ContactManifold_GetPenetrationDepth(const JPH_ContactManifold* manifold);
JPH_CAPI JPH_SubShapeID JPH_ContactManifold_GetSubShapeID1(const JPH_ContactManifold* manifold);
JPH_CAPI JPH_SubShapeID JPH_ContactManifold_GetSubShapeID2(const JPH_ContactManifold* manifold);
JPH_CAPI uint32_t JPH_ContactManifold_GetPointCount(const JPH_ContactManifold* manifold);
JPH_CAPI void JPH_ContactManifold_GetWorldSpaceContactPointOn1(const JPH_ContactManifold* manifold, uint32_t index, JPH_RVec3* result);
JPH_CAPI void JPH_ContactManifold_GetWorldSpaceContactPointOn2(const JPH_ContactManifold* manifold, uint32_t index, JPH_RVec3* result);

/* CharacterBase */
JPH_CAPI void JPH_CharacterBase_Destroy(JPH_CharacterBase* character);
JPH_CAPI float JPH_CharacterBase_GetCosMaxSlopeAngle(JPH_CharacterBase* character);
JPH_CAPI void JPH_CharacterBase_SetMaxSlopeAngle(JPH_CharacterBase* character, float maxSlopeAngle);
JPH_CAPI void JPH_CharacterBase_GetUp(JPH_CharacterBase* character, JPH_Vec3* result);
JPH_CAPI void JPH_CharacterBase_SetUp(JPH_CharacterBase* character, const JPH_Vec3* value);
JPH_CAPI bool JPH_CharacterBase_IsSlopeTooSteep(JPH_CharacterBase* character, const JPH_Vec3* value);
JPH_CAPI const JPH_Shape* JPH_CharacterBase_GetShape(JPH_CharacterBase* character);

JPH_CAPI JPH_GroundState JPH_CharacterBase_GetGroundState(JPH_CharacterBase* character);
JPH_CAPI bool JPH_CharacterBase_IsSupported(JPH_CharacterBase* character);
JPH_CAPI void JPH_CharacterBase_GetGroundPosition(JPH_CharacterBase* character, JPH_RVec3* position);
JPH_CAPI void JPH_CharacterBase_GetGroundNormal(JPH_CharacterBase* character, JPH_Vec3* normal);
JPH_CAPI void JPH_CharacterBase_GetGroundVelocity(JPH_CharacterBase* character, JPH_Vec3* velocity);
JPH_CAPI const JPH_PhysicsMaterial* JPH_CharacterBase_GetGroundMaterial(JPH_CharacterBase* character);
JPH_CAPI JPH_BodyID JPH_CharacterBase_GetGroundBodyId(JPH_CharacterBase* character);
JPH_CAPI JPH_SubShapeID JPH_CharacterBase_GetGroundSubShapeId(JPH_CharacterBase* character);
JPH_CAPI uint64_t JPH_CharacterBase_GetGroundUserData(JPH_CharacterBase* character);

/* CharacterSettings */
JPH_CAPI void JPH_CharacterSettings_Init(JPH_CharacterSettings* settings);

/* Character */
JPH_CAPI JPH_Character* JPH_Character_Create(const JPH_CharacterSettings* settings,
	const JPH_RVec3* position,
	const JPH_Quat* rotation,
	uint64_t userData,
	JPH_PhysicsSystem* system);

JPH_CAPI void JPH_Character_AddToPhysicsSystem(JPH_Character* character, JPH_Activation activationMode /*= JPH_ActivationActivate */, bool lockBodies /* = true */);
JPH_CAPI void JPH_Character_RemoveFromPhysicsSystem(JPH_Character* character, bool lockBodies /* = true */);
JPH_CAPI void JPH_Character_Activate(JPH_Character* character, bool lockBodies /* = true */);
JPH_CAPI void JPH_Character_PostSimulation(JPH_Character* character, float maxSeparationDistance, bool lockBodies /* = true */);
JPH_CAPI void JPH_Character_SetLinearAndAngularVelocity(JPH_Character* character, JPH_Vec3* linearVelocity, JPH_Vec3* angularVelocity, bool lockBodies /* = true */);
JPH_CAPI void JPH_Character_GetLinearVelocity(JPH_Character* character, JPH_Vec3* result);
JPH_CAPI void JPH_Character_SetLinearVelocity(JPH_Character* character, const JPH_Vec3* value, bool lockBodies /* = true */);
JPH_CAPI void JPH_Character_AddLinearVelocity(JPH_Character* character, const JPH_Vec3* value, bool lockBodies /* = true */);
JPH_CAPI void JPH_Character_AddImpulse(JPH_Character* character, const JPH_Vec3* value, bool lockBodies /* = true */);
JPH_CAPI JPH_BodyID JPH_Character_GetBodyID(const JPH_Character* character);

JPH_CAPI void JPH_Character_GetPositionAndRotation(JPH_Character* character, JPH_RVec3* position, JPH_Quat* rotation, bool lockBodies /* = true */);
JPH_CAPI void JPH_Character_SetPositionAndRotation(JPH_Character* character, const JPH_RVec3* position, const JPH_Quat* rotation, JPH_Activation activationMode, bool lockBodies /* = true */);
JPH_CAPI void JPH_Character_GetPosition(JPH_Character* character, JPH_RVec3* position, bool lockBodies /* = true */);
JPH_CAPI void JPH_Character_SetPosition(JPH_Character* character, const JPH_RVec3* position, JPH_Activation activationMode, bool lockBodies /* = true */);
JPH_CAPI void JPH_Character_GetRotation(JPH_Character* character, JPH_Quat* rotation, bool lockBodies /* = true */);
JPH_CAPI void JPH_Character_SetRotation(JPH_Character* character, const JPH_Quat* rotation, JPH_Activation activationMode, bool lockBodies /* = true */);
JPH_CAPI void JPH_Character_GetCenterOfMassPosition(JPH_Character* character, JPH_RVec3* result, bool lockBodies /* = true */);
JPH_CAPI void JPH_Character_GetWorldTransform(JPH_Character* character, JPH_RMat4* result, bool lockBodies /* = true */);
JPH_CAPI JPH_ObjectLayer JPH_Character_GetLayer(const JPH_Character* character);
JPH_CAPI void JPH_Character_SetLayer(JPH_Character* character, JPH_ObjectLayer value, bool lockBodies /*= true*/);
JPH_CAPI void JPH_Character_SetShape(JPH_Character* character, const JPH_Shape* shape, float maxPenetrationDepth, bool lockBodies /*= true*/);

/* CharacterVirtualSettings */
JPH_CAPI void JPH_CharacterVirtualSettings_Init(JPH_CharacterVirtualSettings* settings);

/* CharacterVirtual */
JPH_CAPI JPH_CharacterVirtual* JPH_CharacterVirtual_Create(const JPH_CharacterVirtualSettings* settings,
	const JPH_RVec3* position,
	const JPH_Quat* rotation,
	uint64_t userData,
	JPH_PhysicsSystem* system);

JPH_CAPI JPH_CharacterID JPH_CharacterVirtual_GetID(const JPH_CharacterVirtual* character);
JPH_CAPI void JPH_CharacterVirtual_SetListener(JPH_CharacterVirtual* character, JPH_CharacterContactListener* listener);
JPH_CAPI void JPH_CharacterVirtual_SetCharacterVsCharacterCollision(JPH_CharacterVirtual* character, JPH_CharacterVsCharacterCollision* characterVsCharacterCollision);

JPH_CAPI void JPH_CharacterVirtual_GetLinearVelocity(JPH_CharacterVirtual* character, JPH_Vec3* velocity);
JPH_CAPI void JPH_CharacterVirtual_SetLinearVelocity(JPH_CharacterVirtual* character, const JPH_Vec3* velocity);
JPH_CAPI void JPH_CharacterVirtual_GetPosition(JPH_CharacterVirtual* character, JPH_RVec3* position);
JPH_CAPI void JPH_CharacterVirtual_SetPosition(JPH_CharacterVirtual* character, const JPH_RVec3* position);
JPH_CAPI void JPH_CharacterVirtual_GetRotation(JPH_CharacterVirtual* character, JPH_Quat* rotation);
JPH_CAPI void JPH_CharacterVirtual_SetRotation(JPH_CharacterVirtual* character, const JPH_Quat* rotation);
JPH_CAPI void JPH_CharacterVirtual_GetWorldTransform(JPH_CharacterVirtual* character, JPH_RMat4* result);
JPH_CAPI void JPH_CharacterVirtual_GetCenterOfMassTransform(JPH_CharacterVirtual* character, JPH_RMat4* result);
JPH_CAPI float JPH_CharacterVirtual_GetMass(JPH_CharacterVirtual* character);
JPH_CAPI void JPH_CharacterVirtual_SetMass(JPH_CharacterVirtual* character, float value);
JPH_CAPI float JPH_CharacterVirtual_GetMaxStrength(JPH_CharacterVirtual* character);
JPH_CAPI void JPH_CharacterVirtual_SetMaxStrength(JPH_CharacterVirtual* character, float value);

JPH_CAPI float JPH_CharacterVirtual_GetPenetrationRecoverySpeed(JPH_CharacterVirtual* character);
JPH_CAPI void JPH_CharacterVirtual_SetPenetrationRecoverySpeed(JPH_CharacterVirtual* character, float value);
JPH_CAPI bool	JPH_CharacterVirtual_GetEnhancedInternalEdgeRemoval(JPH_CharacterVirtual* character);
JPH_CAPI void JPH_CharacterVirtual_SetEnhancedInternalEdgeRemoval(JPH_CharacterVirtual* character, bool value);
JPH_CAPI float JPH_CharacterVirtual_GetCharacterPadding(JPH_CharacterVirtual* character);
JPH_CAPI uint32_t JPH_CharacterVirtual_GetMaxNumHits(JPH_CharacterVirtual* character);
JPH_CAPI void JPH_CharacterVirtual_SetMaxNumHits(JPH_CharacterVirtual* character, uint32_t value);
JPH_CAPI float JPH_CharacterVirtual_GetHitReductionCosMaxAngle(JPH_CharacterVirtual* character);
JPH_CAPI void JPH_CharacterVirtual_SetHitReductionCosMaxAngle(JPH_CharacterVirtual* character, float value);
JPH_CAPI bool JPH_CharacterVirtual_GetMaxHitsExceeded(JPH_CharacterVirtual* character);
JPH_CAPI void JPH_CharacterVirtual_GetShapeOffset(JPH_CharacterVirtual* character, JPH_Vec3* result);
JPH_CAPI void JPH_CharacterVirtual_SetShapeOffset(JPH_CharacterVirtual* character, const JPH_Vec3* value);
JPH_CAPI uint64_t JPH_CharacterVirtual_GetUserData(const JPH_CharacterVirtual* character);
JPH_CAPI void JPH_CharacterVirtual_SetUserData(JPH_CharacterVirtual* character, uint64_t value);
JPH_CAPI JPH_BodyID JPH_CharacterVirtual_GetInnerBodyID(const JPH_CharacterVirtual* character);

JPH_CAPI void JPH_CharacterVirtual_CancelVelocityTowardsSteepSlopes(JPH_CharacterVirtual* character, const JPH_Vec3* desiredVelocity, JPH_Vec3* velocity);
JPH_CAPI void JPH_CharacterVirtual_StartTrackingContactChanges(JPH_CharacterVirtual* character);
JPH_CAPI void JPH_CharacterVirtual_FinishTrackingContactChanges(JPH_CharacterVirtual* character);
JPH_CAPI void JPH_CharacterVirtual_Update(JPH_CharacterVirtual* character, float deltaTime, JPH_ObjectLayer layer, JPH_PhysicsSystem* system, const JPH_BodyFilter* bodyFilter, const JPH_ShapeFilter* shapeFilter);

JPH_CAPI void JPH_CharacterVirtual_ExtendedUpdate(JPH_CharacterVirtual* character, float deltaTime,
	const JPH_ExtendedUpdateSettings* settings, JPH_ObjectLayer layer, JPH_PhysicsSystem* system, const JPH_BodyFilter* bodyFilter, const JPH_ShapeFilter* shapeFilter);
JPH_CAPI void JPH_CharacterVirtual_RefreshContacts(JPH_CharacterVirtual* character, JPH_ObjectLayer layer, JPH_PhysicsSystem* system, const JPH_BodyFilter* bodyFilter, const JPH_ShapeFilter* shapeFilter);

JPH_CAPI bool JPH_CharacterVirtual_CanWalkStairs(JPH_CharacterVirtual* character, const JPH_Vec3* linearVelocity);
JPH_CAPI bool JPH_CharacterVirtual_WalkStairs(JPH_CharacterVirtual* character, float deltaTime,
	const JPH_Vec3* stepUp, const JPH_Vec3* stepForward, const JPH_Vec3* stepForwardTest, const JPH_Vec3* stepDownExtra,
	JPH_ObjectLayer layer, JPH_PhysicsSystem* system,
	const JPH_BodyFilter* bodyFilter, const JPH_ShapeFilter* shapeFilter);

JPH_CAPI bool JPH_CharacterVirtual_StickToFloor(JPH_CharacterVirtual* character, const JPH_Vec3* stepDown,
	JPH_ObjectLayer layer, JPH_PhysicsSystem* system,
	const JPH_BodyFilter* bodyFilter, const JPH_ShapeFilter* shapeFilter);

JPH_CAPI void JPH_CharacterVirtual_UpdateGroundVelocity(JPH_CharacterVirtual* character);
JPH_CAPI bool JPH_CharacterVirtual_SetShape(JPH_CharacterVirtual* character, const JPH_Shape* shape, float maxPenetrationDepth, JPH_ObjectLayer layer, JPH_PhysicsSystem* system, const JPH_BodyFilter* bodyFilter, const JPH_ShapeFilter* shapeFilter);
JPH_CAPI void JPH_CharacterVirtual_SetInnerBodyShape(JPH_CharacterVirtual* character, const JPH_Shape* shape);

JPH_CAPI uint32_t JPH_CharacterVirtual_GetNumActiveContacts(JPH_CharacterVirtual* character);
JPH_CAPI void JPH_CharacterVirtual_GetActiveContact(JPH_CharacterVirtual* character, uint32_t index, JPH_CharacterVirtualContact* result);

JPH_CAPI bool JPH_CharacterVirtual_HasCollidedWithBody(JPH_CharacterVirtual* character, const JPH_BodyID body);
JPH_CAPI bool JPH_CharacterVirtual_HasCollidedWith(JPH_CharacterVirtual* character, const JPH_CharacterID other);
JPH_CAPI bool JPH_CharacterVirtual_HasCollidedWithCharacter(JPH_CharacterVirtual* character, const JPH_CharacterVirtual* other);

/* CharacterContactListener */
typedef struct JPH_CharacterContactListener_Procs {
	void (JPH_API_CALL* OnAdjustBodyVelocity)(void* userData,
		const JPH_CharacterVirtual* character,
		const JPH_Body* body2,
		JPH_Vec3* ioLinearVelocity,
		JPH_Vec3* ioAngularVelocity);

	bool(JPH_API_CALL* OnContactValidate)(void* userData,
		const JPH_CharacterVirtual* character,
		const JPH_BodyID bodyID2,
		const JPH_SubShapeID subShapeID2);

	bool(JPH_API_CALL* OnCharacterContactValidate)(void* userData,
		const JPH_CharacterVirtual* character,
		const JPH_CharacterVirtual* otherCharacter,
		const JPH_SubShapeID subShapeID2);

	void(JPH_API_CALL* OnContactAdded)(void* userData,
		const JPH_CharacterVirtual* character,
		const JPH_BodyID bodyID2,
		const JPH_SubShapeID subShapeID2,
		const JPH_RVec3* contactPosition,
		const JPH_Vec3* contactNormal,
		JPH_CharacterContactSettings* ioSettings);

	void(JPH_API_CALL* OnContactPersisted)(void* userData,
		const JPH_CharacterVirtual* character,
		const JPH_BodyID bodyID2,
		const JPH_SubShapeID subShapeID2,
		const JPH_RVec3* contactPosition,
		const JPH_Vec3* contactNormal,
		JPH_CharacterContactSettings* ioSettings);

	void(JPH_API_CALL* OnContactRemoved)(void* userData,
		const JPH_CharacterVirtual* character,
		const JPH_BodyID bodyID2,
		const JPH_SubShapeID subShapeID2);

	void(JPH_API_CALL* OnCharacterContactAdded)(void* userData,
		const JPH_CharacterVirtual* character,
		const JPH_CharacterVirtual* otherCharacter,
		const JPH_SubShapeID subShapeID2,
		const JPH_RVec3* contactPosition,
		const JPH_Vec3* contactNormal,
		JPH_CharacterContactSettings* ioSettings);

	void(JPH_API_CALL* OnCharacterContactPersisted)(void* userData,
		const JPH_CharacterVirtual* character,
		const JPH_CharacterVirtual* otherCharacter,
		const JPH_SubShapeID subShapeID2,
		const JPH_RVec3* contactPosition,
		const JPH_Vec3* contactNormal,
		JPH_CharacterContactSettings* ioSettings);

	void(JPH_API_CALL* OnCharacterContactRemoved)(void* userData,
		const JPH_CharacterVirtual* character,
		const JPH_CharacterID otherCharacterID,
		const JPH_SubShapeID subShapeID2);

	void(JPH_API_CALL* OnContactSolve)(void* userData,
		const JPH_CharacterVirtual* character,
		const JPH_BodyID bodyID2,
		const JPH_SubShapeID subShapeID2,
		const JPH_RVec3* contactPosition,
		const JPH_Vec3* contactNormal,
		const JPH_Vec3* contactVelocity,
		const JPH_PhysicsMaterial* contactMaterial,
		const JPH_Vec3* characterVelocity,
		JPH_Vec3* newCharacterVelocity
		);

	void(JPH_API_CALL* OnCharacterContactSolve)(void* userData,
		const JPH_CharacterVirtual* character,
		const JPH_CharacterVirtual* otherCharacter,
		const JPH_SubShapeID subShapeID2,
		const JPH_RVec3* contactPosition,
		const JPH_Vec3* contactNormal,
		const JPH_Vec3* contactVelocity,
		const JPH_PhysicsMaterial* contactMaterial,
		const JPH_Vec3* characterVelocity,
		JPH_Vec3* newCharacterVelocity
		);
} JPH_CharacterContactListener_Procs;

JPH_CAPI void JPH_CharacterContactListener_SetProcs(const JPH_CharacterContactListener_Procs* procs);
JPH_CAPI JPH_CharacterContactListener* JPH_CharacterContactListener_Create(void* userData);
JPH_CAPI void JPH_CharacterContactListener_Destroy(JPH_CharacterContactListener* listener);

/* JPH_CharacterVsCharacterCollision */
typedef struct JPH_CharacterVsCharacterCollision_Procs {
	void (JPH_API_CALL* CollideCharacter)(void* userData,
		const JPH_CharacterVirtual* character,
		const JPH_RMat4* centerOfMassTransform,
		const JPH_CollideShapeSettings* collideShapeSettings,
		const JPH_RVec3* baseOffset
		);

	void (JPH_API_CALL* CastCharacter)(void* userData,
		const JPH_CharacterVirtual* character,
		const JPH_RMat4* centerOfMassTransform,
		const JPH_Vec3* direction,
		const JPH_ShapeCastSettings* shapeCastSettings,
		const JPH_RVec3* baseOffset
		);
} JPH_CharacterVsCharacterCollision_Procs;

JPH_CAPI void JPH_CharacterVsCharacterCollision_SetProcs(const JPH_CharacterVsCharacterCollision_Procs* procs);
JPH_CAPI JPH_CharacterVsCharacterCollision* JPH_CharacterVsCharacterCollision_Create(void* userData);
JPH_CAPI JPH_CharacterVsCharacterCollision* JPH_CharacterVsCharacterCollision_CreateSimple(void);
JPH_CAPI void JPH_CharacterVsCharacterCollisionSimple_AddCharacter(JPH_CharacterVsCharacterCollision* characterVsCharacter, JPH_CharacterVirtual* character);
JPH_CAPI void JPH_CharacterVsCharacterCollisionSimple_RemoveCharacter(JPH_CharacterVsCharacterCollision* characterVsCharacter, JPH_CharacterVirtual* character);
JPH_CAPI void JPH_CharacterVsCharacterCollision_Destroy(JPH_CharacterVsCharacterCollision* listener);

/* CollisionDispatch */
JPH_CAPI bool JPH_CollisionDispatch_CollideShapeVsShape(
	const JPH_Shape* shape1, const JPH_Shape* shape2,
	const JPH_Vec3* scale1, const JPH_Vec3* scale2,
	const JPH_Mat4* centerOfMassTransform1, const JPH_Mat4* centerOfMassTransform2,
	const JPH_CollideShapeSettings* collideShapeSettings,
	JPH_CollideShapeCollectorCallback* callback, void* userData, const JPH_ShapeFilter* shapeFilter);

JPH_CAPI bool JPH_CollisionDispatch_CastShapeVsShapeLocalSpace(
	const JPH_Vec3* direction, const JPH_Shape* shape1, const JPH_Shape* shape2,
	const JPH_Vec3* scale1InShape2LocalSpace, const JPH_Vec3* scale2,
	JPH_Mat4* centerOfMassTransform1InShape2LocalSpace, JPH_Mat4* centerOfMassWorldTransform2,
	const JPH_ShapeCastSettings* shapeCastSettings,
	JPH_CastShapeCollectorCallback* callback, void* userData,
	const JPH_ShapeFilter* shapeFilter);

JPH_CAPI bool JPH_CollisionDispatch_CastShapeVsShapeWorldSpace(
	const JPH_Vec3* direction, const JPH_Shape* shape1, const JPH_Shape* shape2,
	const JPH_Vec3* scale1, const JPH_Vec3* inScale2,
	const JPH_Mat4* centerOfMassWorldTransform1, const JPH_Mat4* centerOfMassWorldTransform2,
	const JPH_ShapeCastSettings* shapeCastSettings,
	JPH_CastShapeCollectorCallback* callback, void* userData,
	const JPH_ShapeFilter* shapeFilter);

/* DebugRenderer */
typedef struct JPH_DebugRenderer_Procs {
	void (JPH_API_CALL* DrawLine)(void* userData, const JPH_RVec3* from, const JPH_RVec3* to, JPH_Color color);
	void (JPH_API_CALL* DrawTriangle)(void* userData, const JPH_RVec3* v1, const JPH_RVec3* v2, const JPH_RVec3* v3, JPH_Color color, JPH_DebugRenderer_CastShadow castShadow);
	void (JPH_API_CALL* DrawText3D)(void* userData, const JPH_RVec3* position, const char* str, JPH_Color color, float height);
} JPH_DebugRenderer_Procs;

JPH_CAPI void JPH_DebugRenderer_SetProcs(const JPH_DebugRenderer_Procs* procs);
JPH_CAPI JPH_DebugRenderer* JPH_DebugRenderer_Create(void* userData);
JPH_CAPI void JPH_DebugRenderer_Destroy(JPH_DebugRenderer* renderer);
JPH_CAPI void JPH_DebugRenderer_NextFrame(JPH_DebugRenderer* renderer);
JPH_CAPI void JPH_DebugRenderer_SetCameraPos(JPH_DebugRenderer* renderer, const JPH_RVec3* position);

JPH_CAPI void JPH_DebugRenderer_DrawLine(JPH_DebugRenderer* renderer, const JPH_RVec3* from, const JPH_RVec3* to, JPH_Color color);
JPH_CAPI void JPH_DebugRenderer_DrawWireBox(JPH_DebugRenderer* renderer, const JPH_AABox* box, JPH_Color color);
JPH_CAPI void JPH_DebugRenderer_DrawWireBox2(JPH_DebugRenderer* renderer, const JPH_RMat4* matrix, const JPH_AABox* box, JPH_Color color);
JPH_CAPI void JPH_DebugRenderer_DrawMarker(JPH_DebugRenderer* renderer, const JPH_RVec3* position, JPH_Color color, float size);
JPH_CAPI void JPH_DebugRenderer_DrawArrow(JPH_DebugRenderer* renderer, const JPH_RVec3* from, const JPH_RVec3* to, JPH_Color color, float size);
JPH_CAPI void JPH_DebugRenderer_DrawCoordinateSystem(JPH_DebugRenderer* renderer, const JPH_RMat4* matrix, float size);
JPH_CAPI void JPH_DebugRenderer_DrawPlane(JPH_DebugRenderer* renderer, const JPH_RVec3* point, const JPH_Vec3* normal, JPH_Color color, float size);
JPH_CAPI void JPH_DebugRenderer_DrawWireTriangle(JPH_DebugRenderer* renderer, const JPH_RVec3* v1, const JPH_RVec3* v2, const JPH_RVec3* v3, JPH_Color color);
JPH_CAPI void JPH_DebugRenderer_DrawWireSphere(JPH_DebugRenderer* renderer, const JPH_RVec3* center, float radius, JPH_Color color, int level);
JPH_CAPI void JPH_DebugRenderer_DrawWireUnitSphere(JPH_DebugRenderer* renderer, const JPH_RMat4* matrix, JPH_Color color, int level);
JPH_CAPI void JPH_DebugRenderer_DrawTriangle(JPH_DebugRenderer* renderer, const JPH_RVec3* v1, const JPH_RVec3* v2, const JPH_RVec3* v3, JPH_Color color, JPH_DebugRenderer_CastShadow castShadow);
JPH_CAPI void JPH_DebugRenderer_DrawBox(JPH_DebugRenderer* renderer, const JPH_AABox* box, JPH_Color color, JPH_DebugRenderer_CastShadow castShadow, JPH_DebugRenderer_DrawMode drawMode);
JPH_CAPI void JPH_DebugRenderer_DrawBox2(JPH_DebugRenderer* renderer, const JPH_RMat4* matrix, const JPH_AABox* box, JPH_Color color, JPH_DebugRenderer_CastShadow castShadow, JPH_DebugRenderer_DrawMode drawMode);
JPH_CAPI void JPH_DebugRenderer_DrawSphere(JPH_DebugRenderer* renderer, const JPH_RVec3* center, float radius, JPH_Color color, JPH_DebugRenderer_CastShadow castShadow, JPH_DebugRenderer_DrawMode drawMode);
JPH_CAPI void JPH_DebugRenderer_DrawUnitSphere(JPH_DebugRenderer* renderer, JPH_RMat4 matrix, JPH_Color color, JPH_DebugRenderer_CastShadow castShadow, JPH_DebugRenderer_DrawMode drawMode);
JPH_CAPI void JPH_DebugRenderer_DrawCapsule(JPH_DebugRenderer* renderer, const JPH_RMat4* matrix, float halfHeightOfCylinder, float radius, JPH_Color color, JPH_DebugRenderer_CastShadow castShadow, JPH_DebugRenderer_DrawMode drawMode);
JPH_CAPI void JPH_DebugRenderer_DrawCylinder(JPH_DebugRenderer* renderer, const JPH_RMat4* matrix, float halfHeight, float radius, JPH_Color color, JPH_DebugRenderer_CastShadow castShadow, JPH_DebugRenderer_DrawMode drawMode);
JPH_CAPI void JPH_DebugRenderer_DrawOpenCone(JPH_DebugRenderer* renderer, const JPH_RVec3* top, const JPH_Vec3* axis, const JPH_Vec3* perpendicular, float halfAngle, float length, JPH_Color color, JPH_DebugRenderer_CastShadow castShadow, JPH_DebugRenderer_DrawMode drawMode);
JPH_CAPI void JPH_DebugRenderer_DrawSwingConeLimits(JPH_DebugRenderer* renderer, const JPH_RMat4* matrix, float swingYHalfAngle, float swingZHalfAngle, float edgeLength, JPH_Color color, JPH_DebugRenderer_CastShadow castShadow, JPH_DebugRenderer_DrawMode drawMode);
JPH_CAPI void JPH_DebugRenderer_DrawSwingPyramidLimits(JPH_DebugRenderer* renderer, const JPH_RMat4* matrix, float minSwingYAngle, float maxSwingYAngle, float minSwingZAngle, float maxSwingZAngle, float edgeLength, JPH_Color color, JPH_DebugRenderer_CastShadow castShadow, JPH_DebugRenderer_DrawMode drawMode);
JPH_CAPI void JPH_DebugRenderer_DrawPie(JPH_DebugRenderer* renderer, const JPH_RVec3* center, float radius, const JPH_Vec3* normal, const JPH_Vec3* axis, float minAngle, float maxAngle, JPH_Color color, JPH_DebugRenderer_CastShadow castShadow, JPH_DebugRenderer_DrawMode drawMode);
JPH_CAPI void JPH_DebugRenderer_DrawTaperedCylinder(JPH_DebugRenderer* renderer, const JPH_RMat4* inMatrix, float top, float bottom, float topRadius, float bottomRadius, JPH_Color color, JPH_DebugRenderer_CastShadow castShadow, JPH_DebugRenderer_DrawMode drawMode);


/* Skeleton */
typedef struct JPH_SkeletonJoint {
	const char*		name;
	const char*		parentName;
	int				parentJointIndex;
} JPH_SkeletonJoint;

JPH_CAPI JPH_Skeleton* JPH_Skeleton_Create(void);
JPH_CAPI void JPH_Skeleton_Destroy(JPH_Skeleton* skeleton);

JPH_CAPI uint32_t JPH_Skeleton_AddJoint(JPH_Skeleton* skeleton, const char* name);
JPH_CAPI uint32_t JPH_Skeleton_AddJoint2(JPH_Skeleton* skeleton, const char* name, int parentIndex);
JPH_CAPI uint32_t JPH_Skeleton_AddJoint3(JPH_Skeleton* skeleton, const char* name, const char* parentName);
JPH_CAPI int JPH_Skeleton_GetJointCount(const JPH_Skeleton* skeleton);
JPH_CAPI void JPH_Skeleton_GetJoint(const JPH_Skeleton* skeleton, int index, JPH_SkeletonJoint* joint);
JPH_CAPI int JPH_Skeleton_GetJointIndex(const JPH_Skeleton* skeleton, const char* name);
JPH_CAPI void JPH_Skeleton_CalculateParentJointIndices(JPH_Skeleton* skeleton);
JPH_CAPI bool JPH_Skeleton_AreJointsCorrectlyOrdered(const JPH_Skeleton* skeleton);

/* SkeletonPose */
JPH_CAPI JPH_SkeletonPose* JPH_SkeletonPose_Create(void);
JPH_CAPI void JPH_SkeletonPose_Destroy(JPH_SkeletonPose* pose);
JPH_CAPI void JPH_SkeletonPose_SetSkeleton(JPH_SkeletonPose* pose, const JPH_Skeleton* skeleton);
JPH_CAPI const JPH_Skeleton* JPH_SkeletonPose_GetSkeleton(const JPH_SkeletonPose* pose);
JPH_CAPI void JPH_SkeletonPose_SetRootOffset(JPH_SkeletonPose* pose, const JPH_RVec3* offset);
JPH_CAPI void JPH_SkeletonPose_GetRootOffset(const JPH_SkeletonPose* pose, JPH_RVec3* result);
JPH_CAPI int JPH_SkeletonPose_GetJointCount(const JPH_SkeletonPose* pose);
JPH_CAPI void JPH_SkeletonPose_GetJointState(const JPH_SkeletonPose* pose, int index, JPH_Vec3* outTranslation, JPH_Quat* outRotation);
JPH_CAPI void JPH_SkeletonPose_SetJointState(JPH_SkeletonPose* pose, int index, const JPH_Vec3* translation, const JPH_Quat* rotation);
JPH_CAPI void JPH_SkeletonPose_GetJointMatrix(const JPH_SkeletonPose* pose, int index, JPH_Mat4* result);
JPH_CAPI void JPH_SkeletonPose_SetJointMatrix(JPH_SkeletonPose* pose, int index, const JPH_Mat4* matrix);
JPH_CAPI void JPH_SkeletonPose_GetJointMatrices(const JPH_SkeletonPose* pose, JPH_Mat4* outMatrices, int count);
JPH_CAPI void JPH_SkeletonPose_SetJointMatrices(JPH_SkeletonPose* pose, const JPH_Mat4* matrices, int count);
JPH_CAPI void JPH_SkeletonPose_CalculateJointMatrices(JPH_SkeletonPose* pose);
JPH_CAPI void JPH_SkeletonPose_CalculateJointStates(JPH_SkeletonPose* pose);
JPH_CAPI void JPH_SkeletonPose_CalculateLocalSpaceJointMatrices(const JPH_SkeletonPose* pose, JPH_Mat4* outMatrices);

/* SkeletalAnimation */
JPH_CAPI JPH_SkeletalAnimation* JPH_SkeletalAnimation_Create(void);
JPH_CAPI void JPH_SkeletalAnimation_Destroy(JPH_SkeletalAnimation* animation);
JPH_CAPI float JPH_SkeletalAnimation_GetDuration(const JPH_SkeletalAnimation* animation);
JPH_CAPI bool JPH_SkeletalAnimation_IsLooping(const JPH_SkeletalAnimation* animation);
JPH_CAPI void JPH_SkeletalAnimation_SetIsLooping(JPH_SkeletalAnimation* animation, bool looping);
JPH_CAPI void JPH_SkeletalAnimation_ScaleJoints(JPH_SkeletalAnimation* animation, float scale);
JPH_CAPI void JPH_SkeletalAnimation_Sample(const JPH_SkeletalAnimation* animation, float time, JPH_SkeletonPose* pose);
JPH_CAPI int JPH_SkeletalAnimation_GetAnimatedJointCount(const JPH_SkeletalAnimation* animation);
JPH_CAPI void JPH_SkeletalAnimation_AddAnimatedJoint(JPH_SkeletalAnimation* animation, const char* jointName);
JPH_CAPI void JPH_SkeletalAnimation_AddKeyframe(JPH_SkeletalAnimation* animation, int jointIndex, float time, const JPH_Vec3* translation, const JPH_Quat* rotation);

/* SkeletonMapper */
JPH_CAPI JPH_SkeletonMapper* JPH_SkeletonMapper_Create(void);
JPH_CAPI void JPH_SkeletonMapper_Destroy(JPH_SkeletonMapper* mapper);
JPH_CAPI void JPH_SkeletonMapper_Initialize(JPH_SkeletonMapper* mapper, const JPH_Skeleton* skeleton1, const JPH_Mat4* neutralPose1, const JPH_Skeleton* skeleton2, const JPH_Mat4* neutralPose2);
JPH_CAPI void JPH_SkeletonMapper_LockAllTranslations(JPH_SkeletonMapper* mapper, const JPH_Skeleton* skeleton2, const JPH_Mat4* neutralPose2);
JPH_CAPI void JPH_SkeletonMapper_LockTranslations(JPH_SkeletonMapper* mapper, const JPH_Skeleton* skeleton2, const bool* lockedTranslations, const JPH_Mat4* neutralPose2);
JPH_CAPI void JPH_SkeletonMapper_Map(const JPH_SkeletonMapper* mapper, const JPH_Mat4* pose1ModelSpace, const JPH_Mat4* pose2LocalSpace, JPH_Mat4* outPose2ModelSpace);
JPH_CAPI void JPH_SkeletonMapper_MapReverse(const JPH_SkeletonMapper* mapper, const JPH_Mat4* pose2ModelSpace, JPH_Mat4* outPose1ModelSpace);
JPH_CAPI int JPH_SkeletonMapper_GetMappedJointIndex(const JPH_SkeletonMapper* mapper, int joint1Index);
JPH_CAPI bool JPH_SkeletonMapper_IsJointTranslationLocked(const JPH_SkeletonMapper* mapper, int joint2Index);

/* RagdollSettings */
JPH_CAPI JPH_RagdollSettings* JPH_RagdollSettings_Create(void);
JPH_CAPI void JPH_RagdollSettings_Destroy(JPH_RagdollSettings* settings);

JPH_CAPI const JPH_Skeleton* JPH_RagdollSettings_GetSkeleton(const JPH_RagdollSettings* character);
JPH_CAPI void JPH_RagdollSettings_SetSkeleton(JPH_RagdollSettings* character, JPH_Skeleton* skeleton);
JPH_CAPI bool JPH_RagdollSettings_Stabilize(JPH_RagdollSettings* settings);
JPH_CAPI void JPH_RagdollSettings_DisableParentChildCollisions(JPH_RagdollSettings* settings, const JPH_Mat4* jointMatrices /*=nullptr*/, float minSeparationDistance/* = 0.0f*/);
JPH_CAPI void JPH_RagdollSettings_CalculateBodyIndexToConstraintIndex(JPH_RagdollSettings* settings);
JPH_CAPI int JPH_RagdollSettings_GetConstraintIndexForBodyIndex(JPH_RagdollSettings* settings, int bodyIndex);
JPH_CAPI void JPH_RagdollSettings_CalculateConstraintIndexToBodyIdxPair(JPH_RagdollSettings* settings);

JPH_CAPI void JPH_RagdollSettings_ResizeParts(JPH_RagdollSettings* settings, int count);
JPH_CAPI int JPH_RagdollSettings_GetPartCount(const JPH_RagdollSettings* settings);
JPH_CAPI void JPH_RagdollSettings_SetPartShape(JPH_RagdollSettings* settings, int partIndex, const JPH_Shape* shape);
JPH_CAPI void JPH_RagdollSettings_SetPartPosition(JPH_RagdollSettings* settings, int partIndex, const JPH_RVec3* position);
JPH_CAPI void JPH_RagdollSettings_SetPartRotation(JPH_RagdollSettings* settings, int partIndex, const JPH_Quat* rotation);
JPH_CAPI void JPH_RagdollSettings_SetPartMotionType(JPH_RagdollSettings* settings, int partIndex, JPH_MotionType motionType);
JPH_CAPI void JPH_RagdollSettings_SetPartObjectLayer(JPH_RagdollSettings* settings, int partIndex, JPH_ObjectLayer layer);
JPH_CAPI void JPH_RagdollSettings_SetPartMassProperties(JPH_RagdollSettings* settings, int partIndex, float mass);
JPH_CAPI void JPH_RagdollSettings_SetPartToParent(JPH_RagdollSettings* settings, int partIndex, const JPH_SwingTwistConstraintSettings* constraintSettings);

JPH_CAPI JPH_Ragdoll* JPH_RagdollSettings_CreateRagdoll(JPH_RagdollSettings* settings, JPH_PhysicsSystem* system, JPH_CollisionGroupID collisionGroup /*=0*/, uint64_t userData/* = 0*/);

/* Ragdoll */
JPH_CAPI void JPH_Ragdoll_Destroy(JPH_Ragdoll* ragdoll);
JPH_CAPI void JPH_Ragdoll_AddToPhysicsSystem(JPH_Ragdoll* ragdoll, JPH_Activation activationMode /*= JPH_ActivationActivate */, bool lockBodies /* = true */);
JPH_CAPI void JPH_Ragdoll_RemoveFromPhysicsSystem(JPH_Ragdoll* ragdoll, bool lockBodies /* = true */);
JPH_CAPI void JPH_Ragdoll_Activate(JPH_Ragdoll* ragdoll, bool lockBodies /* = true */);
JPH_CAPI bool JPH_Ragdoll_IsActive(const JPH_Ragdoll* ragdoll, bool lockBodies /* = true */);
JPH_CAPI void JPH_Ragdoll_ResetWarmStart(JPH_Ragdoll* ragdoll);
JPH_CAPI void JPH_Ragdoll_SetPose(JPH_Ragdoll* ragdoll, const JPH_SkeletonPose* pose, bool lockBodies /* = true */);
JPH_CAPI void JPH_Ragdoll_SetPose2(JPH_Ragdoll* ragdoll, const JPH_RVec3* rootOffset, const JPH_Mat4* jointMatrices, bool lockBodies /* = true */);
JPH_CAPI void JPH_Ragdoll_GetPose(const JPH_Ragdoll* ragdoll, JPH_SkeletonPose* outPose, bool lockBodies /* = true */);
JPH_CAPI void JPH_Ragdoll_GetPose2(const JPH_Ragdoll* ragdoll, JPH_RVec3* outRootOffset, JPH_Mat4* outJointMatrices, bool lockBodies /* = true */);
JPH_CAPI void JPH_Ragdoll_DriveToPoseUsingMotors(JPH_Ragdoll* ragdoll, const JPH_SkeletonPose* pose);
JPH_CAPI void JPH_Ragdoll_DriveToPoseUsingKinematics(JPH_Ragdoll* ragdoll, const JPH_SkeletonPose* pose, float deltaTime, bool lockBodies /* = true */);
JPH_CAPI int JPH_Ragdoll_GetBodyCount(const JPH_Ragdoll* ragdoll);
JPH_CAPI JPH_BodyID JPH_Ragdoll_GetBodyID(const JPH_Ragdoll* ragdoll, int bodyIndex);
JPH_CAPI int JPH_Ragdoll_GetConstraintCount(const JPH_Ragdoll* ragdoll);
JPH_CAPI JPH_TwoBodyConstraint* JPH_Ragdoll_GetConstraint(JPH_Ragdoll* ragdoll, int constraintIndex);
JPH_CAPI void JPH_Ragdoll_GetRootTransform(const JPH_Ragdoll* ragdoll, JPH_RVec3* outPosition, JPH_Quat* outRotation, bool lockBodies /* = true */);
JPH_CAPI const JPH_RagdollSettings* JPH_Ragdoll_GetRagdollSettings(const JPH_Ragdoll* ragdoll);

/* JPH_EstimateCollisionResponse */
JPH_CAPI void JPH_EstimateCollisionResponse(const JPH_Body* body1, const JPH_Body* body2, const JPH_ContactManifold* manifold, float combinedFriction, float combinedRestitution, float minVelocityForRestitution, uint32_t numIterations, JPH_CollisionEstimationResult* result);

/* Vehicle */
typedef struct JPH_WheelSettings						JPH_WheelSettings;
typedef struct JPH_WheelSettingsWV						JPH_WheelSettingsWV;	/* Inherits JPH_WheelSettings */
typedef struct JPH_WheelSettingsTV						JPH_WheelSettingsTV;	/* Inherits JPH_WheelSettings */

typedef struct JPH_Wheel								JPH_Wheel;
typedef struct JPH_WheelWV								JPH_WheelWV;			/* Inherits JPH_Wheel */
typedef struct JPH_WheelTV								JPH_WheelTV;			/* Inherits JPH_Wheel */

typedef struct JPH_VehicleEngine						JPH_VehicleEngine;
typedef struct JPH_VehicleTransmission					JPH_VehicleTransmission;
typedef struct JPH_VehicleTransmissionSettings			JPH_VehicleTransmissionSettings;
typedef struct JPH_VehicleCollisionTester				JPH_VehicleCollisionTester;
typedef struct JPH_VehicleCollisionTesterRay			JPH_VehicleCollisionTesterRay;			/* Inherits JPH_VehicleCollisionTester */
typedef struct JPH_VehicleCollisionTesterCastSphere		JPH_VehicleCollisionTesterCastSphere;	/* Inherits JPH_VehicleCollisionTester */
typedef struct JPH_VehicleCollisionTesterCastCylinder	JPH_VehicleCollisionTesterCastCylinder;	/* Inherits JPH_VehicleCollisionTester */
typedef struct JPH_VehicleConstraint					JPH_VehicleConstraint;					/* Inherits JPH_Constraint */

typedef struct JPH_VehicleControllerSettings			JPH_VehicleControllerSettings;
typedef struct JPH_WheeledVehicleControllerSettings		JPH_WheeledVehicleControllerSettings;	/* Inherits JPH_VehicleControllerSettings */
typedef struct JPH_MotorcycleControllerSettings			JPH_MotorcycleControllerSettings;		/* Inherits JPH_WheeledVehicleControllerSettings */
typedef struct JPH_TrackedVehicleControllerSettings		JPH_TrackedVehicleControllerSettings;	/* Inherits JPH_VehicleControllerSettings */

typedef struct JPH_WheeledVehicleController				JPH_WheeledVehicleController;	/* Inherits JPH_VehicleController */
typedef struct JPH_MotorcycleController					JPH_MotorcycleController;		/* Inherits JPH_WheeledVehicleController */
typedef struct JPH_TrackedVehicleController				JPH_TrackedVehicleController;	/* Inherits JPH_VehicleController */

typedef struct JPH_VehicleController					JPH_VehicleController;

typedef struct JPH_VehicleAntiRollBar {
	int						leftWheel;
	int						rightWheel;
	float					stiffness;
} JPH_VehicleAntiRollBar;

typedef struct JPH_VehicleConstraintSettings {
	JPH_ConstraintSettings			base;    /* Inherits JPH_ConstraintSettings */

	JPH_Vec3						up;
	JPH_Vec3						forward;
	float							maxPitchRollAngle;
	uint32_t						wheelsCount;
	JPH_WheelSettings**				wheels;
	uint32_t						antiRollBarsCount;
	const JPH_VehicleAntiRollBar*	antiRollBars;
	JPH_VehicleControllerSettings*	controller;
} JPH_VehicleConstraintSettings;

typedef struct JPH_VehicleEngineSettings {
	float					maxTorque;
	float					minRPM;
	float					maxRPM;
	const JPH_LinearCurve*	normalizedTorque;
	float					inertia;
	float					angularDamping;
} JPH_VehicleEngineSettings;

typedef struct JPH_VehicleDifferentialSettings {
	int		leftWheel;
	int		rightWheel;
	float	differentialRatio;
	float	leftRightSplit;
	float	limitedSlipRatio;
	float	engineTorqueRatio;
} JPH_VehicleDifferentialSettings;

JPH_CAPI void JPH_VehicleConstraintSettings_Init(JPH_VehicleConstraintSettings* settings);

JPH_CAPI JPH_VehicleConstraint* JPH_VehicleConstraint_Create(JPH_Body* body, const JPH_VehicleConstraintSettings* settings);
JPH_CAPI JPH_PhysicsStepListener* JPH_VehicleConstraint_AsPhysicsStepListener(JPH_VehicleConstraint* constraint);

JPH_CAPI void JPH_VehicleConstraint_SetMaxPitchRollAngle(JPH_VehicleConstraint* constraint, float maxPitchRollAngle);
JPH_CAPI void JPH_VehicleConstraint_SetVehicleCollisionTester(JPH_VehicleConstraint* constraint, const JPH_VehicleCollisionTester* tester);

JPH_CAPI void JPH_VehicleConstraint_OverrideGravity(JPH_VehicleConstraint* constraint, const JPH_Vec3* value);
JPH_CAPI bool JPH_VehicleConstraint_IsGravityOverridden(const JPH_VehicleConstraint* constraint);
JPH_CAPI void JPH_VehicleConstraint_GetGravityOverride(const JPH_VehicleConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_VehicleConstraint_ResetGravityOverride(JPH_VehicleConstraint* constraint);

JPH_CAPI void JPH_VehicleConstraint_GetLocalForward(const JPH_VehicleConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_VehicleConstraint_GetLocalUp(const JPH_VehicleConstraint* constraint, JPH_Vec3* result);
JPH_CAPI void JPH_VehicleConstraint_GetWorldUp(const JPH_VehicleConstraint* constraint, JPH_Vec3* result);

JPH_CAPI const JPH_Body* JPH_VehicleConstraint_GetVehicleBody(const JPH_VehicleConstraint* constraint);
JPH_CAPI JPH_VehicleController* JPH_VehicleConstraint_GetController(JPH_VehicleConstraint* constraint);
JPH_CAPI uint32_t JPH_VehicleConstraint_GetWheelsCount(JPH_VehicleConstraint* constraint);
JPH_CAPI JPH_Wheel* JPH_VehicleConstraint_GetWheel(JPH_VehicleConstraint* constraint, uint32_t index);
JPH_CAPI void JPH_VehicleConstraint_GetWheelLocalBasis(JPH_VehicleConstraint* constraint, const JPH_Wheel* wheel, JPH_Vec3* outForward, JPH_Vec3* outUp, JPH_Vec3* outRight);
JPH_CAPI void JPH_VehicleConstraint_GetWheelLocalTransform(JPH_VehicleConstraint* constraint, uint32_t wheelIndex, const JPH_Vec3* wheelRight, const JPH_Vec3* wheelUp, JPH_Mat4* result);
JPH_CAPI void JPH_VehicleConstraint_GetWheelWorldTransform(JPH_VehicleConstraint* constraint, uint32_t wheelIndex, const JPH_Vec3* wheelRight, const JPH_Vec3* wheelUp, JPH_RMat4* result);

/* Wheel */
JPH_CAPI JPH_WheelSettings* JPH_WheelSettings_Create(void);
JPH_CAPI void JPH_WheelSettings_Destroy(JPH_WheelSettings* settings);
JPH_CAPI void JPH_WheelSettings_GetPosition(const JPH_WheelSettings* settings, JPH_Vec3* result);
JPH_CAPI void JPH_WheelSettings_SetPosition(JPH_WheelSettings* settings, const JPH_Vec3* value);
JPH_CAPI void JPH_WheelSettings_GetSuspensionForcePoint(const JPH_WheelSettings* settings, JPH_Vec3* result);
JPH_CAPI void JPH_WheelSettings_SetSuspensionForcePoint(JPH_WheelSettings* settings, const JPH_Vec3* value);
JPH_CAPI void JPH_WheelSettings_GetSuspensionDirection(const JPH_WheelSettings* settings, JPH_Vec3* result);
JPH_CAPI void JPH_WheelSettings_SetSuspensionDirection(JPH_WheelSettings* settings, const JPH_Vec3* value);
JPH_CAPI void JPH_WheelSettings_GetSteeringAxis(const JPH_WheelSettings* settings, JPH_Vec3* result);
JPH_CAPI void JPH_WheelSettings_SetSteeringAxis(JPH_WheelSettings* settings, const JPH_Vec3* value);
JPH_CAPI void JPH_WheelSettings_GetWheelUp(const JPH_WheelSettings* settings, JPH_Vec3* result);
JPH_CAPI void JPH_WheelSettings_SetWheelUp(JPH_WheelSettings* settings, const JPH_Vec3* value);
JPH_CAPI void JPH_WheelSettings_GetWheelForward(const JPH_WheelSettings* settings, JPH_Vec3* result);
JPH_CAPI void JPH_WheelSettings_SetWheelForward(JPH_WheelSettings* settings, const JPH_Vec3* value);
JPH_CAPI float JPH_WheelSettings_GetSuspensionMinLength(const JPH_WheelSettings* settings);
JPH_CAPI void JPH_WheelSettings_SetSuspensionMinLength(JPH_WheelSettings* settings, float value);
JPH_CAPI float JPH_WheelSettings_GetSuspensionMaxLength(const JPH_WheelSettings* settings);
JPH_CAPI void JPH_WheelSettings_SetSuspensionMaxLength(JPH_WheelSettings* settings, float value);
JPH_CAPI float JPH_WheelSettings_GetSuspensionPreloadLength(const JPH_WheelSettings* settings);
JPH_CAPI void JPH_WheelSettings_SetSuspensionPreloadLength(JPH_WheelSettings* settings, float value);
JPH_CAPI void JPH_WheelSettings_GetSuspensionSpring(const JPH_WheelSettings* settings, JPH_SpringSettings* result);
JPH_CAPI void JPH_WheelSettings_SetSuspensionSpring(JPH_WheelSettings* settings, JPH_SpringSettings* springSettings);
JPH_CAPI float JPH_WheelSettings_GetRadius(const JPH_WheelSettings* settings);
JPH_CAPI void JPH_WheelSettings_SetRadius(JPH_WheelSettings* settings, float value);
JPH_CAPI float JPH_WheelSettings_GetWidth(const JPH_WheelSettings* settings);
JPH_CAPI void JPH_WheelSettings_SetWidth(JPH_WheelSettings* settings, float value);
JPH_CAPI bool JPH_WheelSettings_GetEnableSuspensionForcePoint(const JPH_WheelSettings* settings);
JPH_CAPI void JPH_WheelSettings_SetEnableSuspensionForcePoint(JPH_WheelSettings* settings, bool value);

JPH_CAPI JPH_Wheel* JPH_Wheel_Create(const JPH_WheelSettings* settings);
JPH_CAPI void JPH_Wheel_Destroy(JPH_Wheel* wheel);
JPH_CAPI const JPH_WheelSettings* JPH_Wheel_GetSettings(const JPH_Wheel* wheel);
JPH_CAPI float JPH_Wheel_GetAngularVelocity(const JPH_Wheel* wheel);
JPH_CAPI void JPH_Wheel_SetAngularVelocity(JPH_Wheel* wheel, float value);
JPH_CAPI float JPH_Wheel_GetRotationAngle(const JPH_Wheel* wheel);
JPH_CAPI void JPH_Wheel_SetRotationAngle(JPH_Wheel* wheel, float value);
JPH_CAPI float JPH_Wheel_GetSteerAngle(const JPH_Wheel* wheel);
JPH_CAPI void JPH_Wheel_SetSteerAngle(JPH_Wheel* wheel, float value);
JPH_CAPI bool JPH_Wheel_HasContact(const JPH_Wheel* wheel);
JPH_CAPI JPH_BodyID JPH_Wheel_GetContactBodyID(const JPH_Wheel* wheel);
JPH_CAPI JPH_SubShapeID JPH_Wheel_GetContactSubShapeID(const JPH_Wheel* wheel);
JPH_CAPI void JPH_Wheel_GetContactPosition(const JPH_Wheel* wheel, JPH_RVec3* result);
JPH_CAPI void JPH_Wheel_GetContactPointVelocity(const JPH_Wheel* wheel, JPH_Vec3* result);
JPH_CAPI void JPH_Wheel_GetContactNormal(const JPH_Wheel* wheel, JPH_Vec3* result);
JPH_CAPI void JPH_Wheel_GetContactLongitudinal(const JPH_Wheel* wheel, JPH_Vec3* result);
JPH_CAPI void JPH_Wheel_GetContactLateral(const JPH_Wheel* wheel, JPH_Vec3* result);
JPH_CAPI float JPH_Wheel_GetSuspensionLength(const JPH_Wheel* wheel);
JPH_CAPI float JPH_Wheel_GetSuspensionLambda(const JPH_Wheel* wheel);
JPH_CAPI float JPH_Wheel_GetLongitudinalLambda(const JPH_Wheel* wheel);
JPH_CAPI float JPH_Wheel_GetLateralLambda(const JPH_Wheel* wheel);
JPH_CAPI bool JPH_Wheel_HasHitHardPoint(const JPH_Wheel* wheel);

/* VehicleAntiRollBar */
JPH_CAPI void JPH_VehicleAntiRollBar_Init(JPH_VehicleAntiRollBar* antiRollBar);

/* VehicleEngineSettings */
JPH_CAPI void JPH_VehicleEngineSettings_Init(JPH_VehicleEngineSettings* settings);

/* VehicleEngine */
JPH_CAPI void JPH_VehicleEngine_ClampRPM(JPH_VehicleEngine* engine);
JPH_CAPI float JPH_VehicleEngine_GetCurrentRPM(const JPH_VehicleEngine* engine);
JPH_CAPI void JPH_VehicleEngine_SetCurrentRPM(JPH_VehicleEngine* engine, float rpm);
JPH_CAPI float JPH_VehicleEngine_GetAngularVelocity(const JPH_VehicleEngine* engine);
JPH_CAPI float JPH_VehicleEngine_GetTorque(const JPH_VehicleEngine* engine, float acceleration);
JPH_CAPI void JPH_VehicleEngine_ApplyTorque(JPH_VehicleEngine* engine, float torque, float deltaTime);
JPH_CAPI void JPH_VehicleEngine_ApplyDamping(JPH_VehicleEngine* engine, float deltaTime);
JPH_CAPI bool JPH_VehicleEngine_AllowSleep(const JPH_VehicleEngine* engine);

/* VehicleDifferentialSettings */
JPH_CAPI void JPH_VehicleDifferentialSettings_Init(JPH_VehicleDifferentialSettings* settings);

/* VehicleTransmissionSettings */
JPH_CAPI JPH_VehicleTransmissionSettings* JPH_VehicleTransmissionSettings_Create(void);
JPH_CAPI void JPH_VehicleTransmissionSettings_Destroy(JPH_VehicleTransmissionSettings* settings);

JPH_CAPI JPH_TransmissionMode JPH_VehicleTransmissionSettings_GetMode(const JPH_VehicleTransmissionSettings* settings);
JPH_CAPI void JPH_VehicleTransmissionSettings_SetMode(JPH_VehicleTransmissionSettings* settings, JPH_TransmissionMode value);

JPH_CAPI uint32_t JPH_VehicleTransmissionSettings_GetGearRatioCount(const JPH_VehicleTransmissionSettings* settings);
JPH_CAPI float JPH_VehicleTransmissionSettings_GetGearRatio(const JPH_VehicleTransmissionSettings* settings, uint32_t index);
JPH_CAPI void JPH_VehicleTransmissionSettings_SetGearRatio(JPH_VehicleTransmissionSettings* settings, uint32_t index, float value);
JPH_CAPI const float* JPH_VehicleTransmissionSettings_GetGearRatios(const JPH_VehicleTransmissionSettings* settings);
JPH_CAPI void JPH_VehicleTransmissionSettings_SetGearRatios(JPH_VehicleTransmissionSettings* settings, const float* values, uint32_t count);

JPH_CAPI uint32_t JPH_VehicleTransmissionSettings_GetReverseGearRatioCount(const JPH_VehicleTransmissionSettings* settings);
JPH_CAPI float JPH_VehicleTransmissionSettings_GetReverseGearRatio(const JPH_VehicleTransmissionSettings* settings, uint32_t index);
JPH_CAPI void JPH_VehicleTransmissionSettings_SetReverseGearRatio(JPH_VehicleTransmissionSettings* settings, uint32_t index, float value);
JPH_CAPI const float* JPH_VehicleTransmissionSettings_GetReverseGearRatios(const JPH_VehicleTransmissionSettings* settings);
JPH_CAPI void JPH_VehicleTransmissionSettings_SetReverseGearRatios(JPH_VehicleTransmissionSettings* settings, const float* values, uint32_t count);

JPH_CAPI float JPH_VehicleTransmissionSettings_GetSwitchTime(const JPH_VehicleTransmissionSettings* settings);
JPH_CAPI void JPH_VehicleTransmissionSettings_SetSwitchTime(JPH_VehicleTransmissionSettings* settings, float value);
JPH_CAPI float JPH_VehicleTransmissionSettings_GetClutchReleaseTime(const JPH_VehicleTransmissionSettings* settings);
JPH_CAPI void JPH_VehicleTransmissionSettings_SetClutchReleaseTime(JPH_VehicleTransmissionSettings* settings, float value);
JPH_CAPI float JPH_VehicleTransmissionSettings_GetSwitchLatency(const JPH_VehicleTransmissionSettings* settings);
JPH_CAPI void JPH_VehicleTransmissionSettings_SetSwitchLatency(JPH_VehicleTransmissionSettings* settings, float value);
JPH_CAPI float JPH_VehicleTransmissionSettings_GetShiftUpRPM(const JPH_VehicleTransmissionSettings* settings);
JPH_CAPI void JPH_VehicleTransmissionSettings_SetShiftUpRPM(JPH_VehicleTransmissionSettings* settings, float value);
JPH_CAPI float JPH_VehicleTransmissionSettings_GetShiftDownRPM(const JPH_VehicleTransmissionSettings* settings);
JPH_CAPI void JPH_VehicleTransmissionSettings_SetShiftDownRPM(JPH_VehicleTransmissionSettings* settings, float value);
JPH_CAPI float JPH_VehicleTransmissionSettings_GetClutchStrength(const JPH_VehicleTransmissionSettings* settings);
JPH_CAPI void JPH_VehicleTransmissionSettings_SetClutchStrength(JPH_VehicleTransmissionSettings* settings, float value);

/* VehicleTransmission */
JPH_CAPI void JPH_VehicleTransmission_Set(JPH_VehicleTransmission* transmission, int currentGear, float clutchFriction);
JPH_CAPI void JPH_VehicleTransmission_Update(JPH_VehicleTransmission* transmission, float deltaTime, float currentRPM, float forwardInput, bool canShiftUp);
JPH_CAPI int JPH_VehicleTransmission_GetCurrentGear(const JPH_VehicleTransmission* transmission);
JPH_CAPI float JPH_VehicleTransmission_GetClutchFriction(const JPH_VehicleTransmission* transmission);
JPH_CAPI bool JPH_VehicleTransmission_IsSwitchingGear(const JPH_VehicleTransmission* transmission);
JPH_CAPI float JPH_VehicleTransmission_GetCurrentRatio(const JPH_VehicleTransmission* transmission);
JPH_CAPI bool JPH_VehicleTransmission_AllowSleep(const JPH_VehicleTransmission* transmission);

/* VehicleCollisionTester */
JPH_CAPI void JPH_VehicleCollisionTester_Destroy(JPH_VehicleCollisionTester* tester);
JPH_CAPI JPH_ObjectLayer JPH_VehicleCollisionTester_GetObjectLayer(const JPH_VehicleCollisionTester* tester);
JPH_CAPI void JPH_VehicleCollisionTester_SetObjectLayer(JPH_VehicleCollisionTester* tester, JPH_ObjectLayer value);

JPH_CAPI JPH_VehicleCollisionTesterRay* JPH_VehicleCollisionTesterRay_Create(JPH_ObjectLayer layer, const JPH_Vec3* up, float maxSlopeAngle);
JPH_CAPI JPH_VehicleCollisionTesterCastSphere* JPH_VehicleCollisionTesterCastSphere_Create(JPH_ObjectLayer layer, float radius, const JPH_Vec3* up, float maxSlopeAngle);
JPH_CAPI JPH_VehicleCollisionTesterCastCylinder* JPH_VehicleCollisionTesterCastCylinder_Create(JPH_ObjectLayer layer, float convexRadiusFraction);

/* VehicleControllerSettings/VehicleController */
JPH_CAPI void JPH_VehicleControllerSettings_Destroy(JPH_VehicleControllerSettings* settings);
JPH_CAPI const JPH_VehicleConstraint* JPH_VehicleController_GetConstraint(JPH_VehicleController* controller);

/* ---- WheelSettingsWV - WheelWV - WheeledVehicleController ---- */

JPH_CAPI JPH_WheelSettingsWV* JPH_WheelSettingsWV_Create(void);
JPH_CAPI float JPH_WheelSettingsWV_GetInertia(const JPH_WheelSettingsWV* settings);
JPH_CAPI void JPH_WheelSettingsWV_SetInertia(JPH_WheelSettingsWV* settings, float value);
JPH_CAPI float JPH_WheelSettingsWV_GetAngularDamping(const JPH_WheelSettingsWV* settings);
JPH_CAPI void JPH_WheelSettingsWV_SetAngularDamping(JPH_WheelSettingsWV* settings, float value);
JPH_CAPI float JPH_WheelSettingsWV_GetMaxSteerAngle(const JPH_WheelSettingsWV* settings);
JPH_CAPI void JPH_WheelSettingsWV_SetMaxSteerAngle(JPH_WheelSettingsWV* settings, float value);
JPH_CAPI const JPH_LinearCurve* JPH_WheelSettingsWV_GetLongitudinalFriction(const JPH_WheelSettingsWV* settings);
JPH_CAPI void JPH_WheelSettingsWV_SetLongitudinalFriction(JPH_WheelSettingsWV* settings, const JPH_LinearCurve* value);
JPH_CAPI const JPH_LinearCurve* JPH_WheelSettingsWV_GetLateralFriction(const JPH_WheelSettingsWV* settings);
JPH_CAPI void JPH_WheelSettingsWV_SetLateralFriction(JPH_WheelSettingsWV* settings, const JPH_LinearCurve* value);
JPH_CAPI float JPH_WheelSettingsWV_GetMaxBrakeTorque(const JPH_WheelSettingsWV* settings);
JPH_CAPI void JPH_WheelSettingsWV_SetMaxBrakeTorque(JPH_WheelSettingsWV* settings, float value);
JPH_CAPI float JPH_WheelSettingsWV_GetMaxHandBrakeTorque(const JPH_WheelSettingsWV* settings);
JPH_CAPI void JPH_WheelSettingsWV_SetMaxHandBrakeTorque(JPH_WheelSettingsWV* settings, float value);

JPH_CAPI JPH_WheelWV* JPH_WheelWV_Create(const JPH_WheelSettingsWV* settings);
JPH_CAPI const JPH_WheelSettingsWV* JPH_WheelWV_GetSettings(const JPH_WheelWV* wheel);
JPH_CAPI void JPH_WheelWV_ApplyTorque(JPH_WheelWV* wheel, float torque, float deltaTime);

JPH_CAPI JPH_WheeledVehicleControllerSettings* JPH_WheeledVehicleControllerSettings_Create(void);

JPH_CAPI void JPH_WheeledVehicleControllerSettings_GetEngine(const JPH_WheeledVehicleControllerSettings* settings, JPH_VehicleEngineSettings* result);
JPH_CAPI void JPH_WheeledVehicleControllerSettings_SetEngine(JPH_WheeledVehicleControllerSettings* settings, const JPH_VehicleEngineSettings* value);
JPH_CAPI const JPH_VehicleTransmissionSettings* JPH_WheeledVehicleControllerSettings_GetTransmission(const JPH_WheeledVehicleControllerSettings* settings);
JPH_CAPI void JPH_WheeledVehicleControllerSettings_SetTransmission(JPH_WheeledVehicleControllerSettings* settings, const JPH_VehicleTransmissionSettings* value);

JPH_CAPI uint32_t JPH_WheeledVehicleControllerSettings_GetDifferentialsCount(const JPH_WheeledVehicleControllerSettings* settings);
JPH_CAPI void JPH_WheeledVehicleControllerSettings_SetDifferentialsCount(JPH_WheeledVehicleControllerSettings* settings, uint32_t count);
JPH_CAPI void JPH_WheeledVehicleControllerSettings_GetDifferential(const JPH_WheeledVehicleControllerSettings* settings, uint32_t index, JPH_VehicleDifferentialSettings* result);
JPH_CAPI void JPH_WheeledVehicleControllerSettings_SetDifferential(JPH_WheeledVehicleControllerSettings* settings, uint32_t index, const JPH_VehicleDifferentialSettings* value);
JPH_CAPI void JPH_WheeledVehicleControllerSettings_SetDifferentials(JPH_WheeledVehicleControllerSettings* settings, const JPH_VehicleDifferentialSettings* values, uint32_t count);

JPH_CAPI float JPH_WheeledVehicleControllerSettings_GetDifferentialLimitedSlipRatio(const JPH_WheeledVehicleControllerSettings* settings);
JPH_CAPI void JPH_WheeledVehicleControllerSettings_SetDifferentialLimitedSlipRatio(JPH_WheeledVehicleControllerSettings* settings, float value);

JPH_CAPI void JPH_WheeledVehicleController_SetDriverInput(JPH_WheeledVehicleController* controller, float forward, float right, float brake, float handBrake);
JPH_CAPI void JPH_WheeledVehicleController_SetForwardInput(JPH_WheeledVehicleController* controller, float forward);
JPH_CAPI float JPH_WheeledVehicleController_GetForwardInput(const JPH_WheeledVehicleController* controller);
JPH_CAPI void JPH_WheeledVehicleController_SetRightInput(JPH_WheeledVehicleController* controller, float rightRatio);
JPH_CAPI float JPH_WheeledVehicleController_GetRightInput(const JPH_WheeledVehicleController* controller);
JPH_CAPI void JPH_WheeledVehicleController_SetBrakeInput(JPH_WheeledVehicleController* controller, float brakeInput);
JPH_CAPI float JPH_WheeledVehicleController_GetBrakeInput(const JPH_WheeledVehicleController* controller);
JPH_CAPI void JPH_WheeledVehicleController_SetHandBrakeInput(JPH_WheeledVehicleController* controller, float handBrakeInput);
JPH_CAPI float JPH_WheeledVehicleController_GetHandBrakeInput(const JPH_WheeledVehicleController* controller);
JPH_CAPI float JPH_WheeledVehicleController_GetWheelSpeedAtClutch(const JPH_WheeledVehicleController* controller);
JPH_CAPI void JPH_WheeledVehicleController_SetTireMaxImpulseCallback(JPH_WheeledVehicleController* controller, JPH_TireMaxImpulseCallback tireMaxImpulseCallback, void* userData);
JPH_CAPI const JPH_VehicleEngine* JPH_WheeledVehicleController_GetEngine(const JPH_WheeledVehicleController* controller);
JPH_CAPI const JPH_VehicleTransmission* JPH_WheeledVehicleController_GetTransmission(const JPH_WheeledVehicleController* controller);

/* WheelSettingsTV - WheelTV - TrackedVehicleController */
/* WheelSettingsTV - WheelTV - TrackedVehicleController */

/* VehicleTrack */
typedef struct JPH_VehicleTrackSettings JPH_VehicleTrackSettings;
typedef struct JPH_VehicleTrack JPH_VehicleTrack;

typedef enum JPH_TrackSide {
	JPH_TrackSide_Left = 0,
	JPH_TrackSide_Right = 1,
} JPH_TrackSide;

typedef struct JPH_VehicleTrackSettings {
	uint32_t					drivenWheel;
	const uint32_t*				wheels;
	uint32_t					wheelsCount;
	float						inertia;
	float						angularDamping;
	float						maxBrakeTorque;
	float						differentialRatio;
} JPH_VehicleTrackSettings;

JPH_CAPI void JPH_VehicleTrackSettings_Init(JPH_VehicleTrackSettings* settings);

JPH_CAPI float JPH_VehicleTrack_GetAngularVelocity(const JPH_VehicleTrack* track);
JPH_CAPI void JPH_VehicleTrack_SetAngularVelocity(JPH_VehicleTrack* track, float velocity);
JPH_CAPI uint32_t JPH_VehicleTrack_GetDrivenWheel(const JPH_VehicleTrack* track);
JPH_CAPI float JPH_VehicleTrack_GetInertia(const JPH_VehicleTrack* track);
JPH_CAPI float JPH_VehicleTrack_GetAngularDamping(const JPH_VehicleTrack* track);
JPH_CAPI float JPH_VehicleTrack_GetMaxBrakeTorque(const JPH_VehicleTrack* track);
JPH_CAPI float JPH_VehicleTrack_GetDifferentialRatio(const JPH_VehicleTrack* track);

JPH_CAPI const JPH_VehicleTrack* JPH_TrackedVehicleController_GetTrack(const JPH_TrackedVehicleController* controller, JPH_TrackSide side);

/* WheelSettingsTV */
JPH_CAPI JPH_WheelSettingsTV* JPH_WheelSettingsTV_Create(void);
JPH_CAPI float JPH_WheelSettingsTV_GetLongitudinalFriction(const JPH_WheelSettingsTV* settings);
JPH_CAPI void JPH_WheelSettingsTV_SetLongitudinalFriction(JPH_WheelSettingsTV* settings, float value);
JPH_CAPI float JPH_WheelSettingsTV_GetLateralFriction(const JPH_WheelSettingsTV* settings);
JPH_CAPI void JPH_WheelSettingsTV_SetLateralFriction(JPH_WheelSettingsTV* settings, float value);

JPH_CAPI JPH_WheelTV* JPH_WheelTV_Create(const JPH_WheelSettingsTV* settings);
JPH_CAPI const JPH_WheelSettingsTV* JPH_WheelTV_GetSettings(const JPH_WheelTV* wheel);

JPH_CAPI JPH_TrackedVehicleControllerSettings* JPH_TrackedVehicleControllerSettings_Create(void);

JPH_CAPI void JPH_TrackedVehicleControllerSettings_GetEngine(const JPH_TrackedVehicleControllerSettings* settings, JPH_VehicleEngineSettings* result);
JPH_CAPI void JPH_TrackedVehicleControllerSettings_SetEngine(JPH_TrackedVehicleControllerSettings* settings, const JPH_VehicleEngineSettings* value);
JPH_CAPI const JPH_VehicleTransmissionSettings* JPH_TrackedVehicleControllerSettings_GetTransmission(const JPH_TrackedVehicleControllerSettings* settings);
JPH_CAPI void JPH_TrackedVehicleControllerSettings_SetTransmission(JPH_TrackedVehicleControllerSettings* settings, const JPH_VehicleTransmissionSettings* value);

JPH_CAPI void JPH_TrackedVehicleController_SetDriverInput(JPH_TrackedVehicleController* controller, float forward, float leftRatio, float rightRatio, float brake);
JPH_CAPI float JPH_TrackedVehicleController_GetForwardInput(const JPH_TrackedVehicleController* controller);
JPH_CAPI void JPH_TrackedVehicleController_SetForwardInput(JPH_TrackedVehicleController* controller, float value);
JPH_CAPI float JPH_TrackedVehicleController_GetLeftRatio(const JPH_TrackedVehicleController* controller);
JPH_CAPI void JPH_TrackedVehicleController_SetLeftRatio(JPH_TrackedVehicleController* controller, float value);
JPH_CAPI float JPH_TrackedVehicleController_GetRightRatio(const JPH_TrackedVehicleController* controller);
JPH_CAPI void JPH_TrackedVehicleController_SetRightRatio(JPH_TrackedVehicleController* controller, float value);
JPH_CAPI float JPH_TrackedVehicleController_GetBrakeInput(const JPH_TrackedVehicleController* controller);
JPH_CAPI void JPH_TrackedVehicleController_SetBrakeInput(JPH_TrackedVehicleController* controller, float value);
JPH_CAPI const JPH_VehicleEngine* JPH_TrackedVehicleController_GetEngine(const JPH_TrackedVehicleController* controller);
JPH_CAPI const JPH_VehicleTransmission* JPH_TrackedVehicleController_GetTransmission(const JPH_TrackedVehicleController* controller);

/* MotorcycleController */
JPH_CAPI JPH_MotorcycleControllerSettings* JPH_MotorcycleControllerSettings_Create(void);
JPH_CAPI float JPH_MotorcycleControllerSettings_GetMaxLeanAngle(const JPH_MotorcycleControllerSettings* settings);
JPH_CAPI void JPH_MotorcycleControllerSettings_SetMaxLeanAngle(JPH_MotorcycleControllerSettings* settings, float value);
JPH_CAPI float JPH_MotorcycleControllerSettings_GetLeanSpringConstant(const JPH_MotorcycleControllerSettings* settings);
JPH_CAPI void JPH_MotorcycleControllerSettings_SetLeanSpringConstant(JPH_MotorcycleControllerSettings* settings, float value);
JPH_CAPI float JPH_MotorcycleControllerSettings_GetLeanSpringDamping(const JPH_MotorcycleControllerSettings* settings);
JPH_CAPI void JPH_MotorcycleControllerSettings_SetLeanSpringDamping(JPH_MotorcycleControllerSettings* settings, float value);
JPH_CAPI float JPH_MotorcycleControllerSettings_GetLeanSpringIntegrationCoefficient(const JPH_MotorcycleControllerSettings* settings);
JPH_CAPI void JPH_MotorcycleControllerSettings_SetLeanSpringIntegrationCoefficient(JPH_MotorcycleControllerSettings* settings, float value);
JPH_CAPI float JPH_MotorcycleControllerSettings_GetLeanSpringIntegrationCoefficientDecay(const JPH_MotorcycleControllerSettings* settings);
JPH_CAPI void JPH_MotorcycleControllerSettings_SetLeanSpringIntegrationCoefficientDecay(JPH_MotorcycleControllerSettings* settings, float value);
JPH_CAPI float JPH_MotorcycleControllerSettings_GetLeanSmoothingFactor(const JPH_MotorcycleControllerSettings* settings);
JPH_CAPI void JPH_MotorcycleControllerSettings_SetLeanSmoothingFactor(JPH_MotorcycleControllerSettings* settings, float value);

JPH_CAPI float JPH_MotorcycleController_GetWheelBase(const JPH_MotorcycleController* controller);
JPH_CAPI bool JPH_MotorcycleController_IsLeanControllerEnabled(const JPH_MotorcycleController* controller);
JPH_CAPI void JPH_MotorcycleController_EnableLeanController(JPH_MotorcycleController* controller, bool value);
JPH_CAPI bool JPH_MotorcycleController_IsLeanSteeringLimitEnabled(const JPH_MotorcycleController* controller);
JPH_CAPI void JPH_MotorcycleController_EnableLeanSteeringLimit(JPH_MotorcycleController* controller, bool value);
JPH_CAPI float JPH_MotorcycleController_GetLeanSpringConstant(const JPH_MotorcycleController* controller);
JPH_CAPI void JPH_MotorcycleController_SetLeanSpringConstant(JPH_MotorcycleController* controller, float value);
JPH_CAPI float JPH_MotorcycleController_GetLeanSpringDamping(const JPH_MotorcycleController* controller);
JPH_CAPI void JPH_MotorcycleController_SetLeanSpringDamping(JPH_MotorcycleController* controller, float value);
JPH_CAPI float JPH_MotorcycleController_GetLeanSpringIntegrationCoefficient(const JPH_MotorcycleController* controller);
JPH_CAPI void JPH_MotorcycleController_SetLeanSpringIntegrationCoefficient(JPH_MotorcycleController* controller, float value);
JPH_CAPI float JPH_MotorcycleController_GetLeanSpringIntegrationCoefficientDecay(const JPH_MotorcycleController* controller);
JPH_CAPI void JPH_MotorcycleController_SetLeanSpringIntegrationCoefficientDecay(JPH_MotorcycleController* controller, float value);
JPH_CAPI float JPH_MotorcycleController_GetLeanSmoothingFactor(const JPH_MotorcycleController* controller);
JPH_CAPI void JPH_MotorcycleController_SetLeanSmoothingFactor(JPH_MotorcycleController* controller, float value);

/* LinearCurve */
JPH_CAPI JPH_LinearCurve* JPH_LinearCurve_Create(void);
JPH_CAPI void JPH_LinearCurve_Destroy(JPH_LinearCurve* curve);
JPH_CAPI void JPH_LinearCurve_Clear(JPH_LinearCurve* curve);
JPH_CAPI void JPH_LinearCurve_Reserve(JPH_LinearCurve* curve, uint32_t numPoints);
JPH_CAPI void JPH_LinearCurve_AddPoint(JPH_LinearCurve* curve, float x, float y);
JPH_CAPI void JPH_LinearCurve_Sort(JPH_LinearCurve* curve);
JPH_CAPI float JPH_LinearCurve_GetMinX(const JPH_LinearCurve* curve);
JPH_CAPI float JPH_LinearCurve_GetMaxX(const JPH_LinearCurve* curve);
JPH_CAPI float JPH_LinearCurve_GetValue(const JPH_LinearCurve* curve, float x);
JPH_CAPI uint32_t JPH_LinearCurve_GetPointCount(const JPH_LinearCurve* curve);
JPH_CAPI void JPH_LinearCurve_GetPoint(const JPH_LinearCurve* curve, uint32_t index, JPH_Point* result);
JPH_CAPI void JPH_LinearCurve_GetPoints(const JPH_LinearCurve* curve, JPH_Point* points, uint32_t* count);

#endif /* JOLT_C_H_ */
