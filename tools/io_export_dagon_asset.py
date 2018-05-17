bl_info = {
    "name": "Dagon Asset Export",
    "author": "Timur Gafarov",
    "version": (1, 0),
    "blender": (2, 6, 4),
    "location": "File > Export > Dagon Asset (.asset)",
    "description": "Export Dagon engine asset file",
    "warning": "",
    "wiki_url": "",
    "tracker_url": "",
    "category": "Import-Export"}

import os
import shutil
import struct
from pathlib import Path
from math import pi
import bpy
from bpy.props import StringProperty
from bpy_extras.io_utils import ExportHelper
import mathutils

def packVector4f(v):
    return struct.pack('<ffff', v[0], v[1], v[2], v[3])

def packVector3f(v):
    return struct.pack('<fff', v[0], v[1], v[2])

def packVector2f(v):
    return struct.pack('<ff', v[0], v[1])

def doExport(context, filepath = ""):

    scene = context.scene

    dirName = Path(filepath).stem
    dirParent = os.path.dirname(filepath)
    directory = dirParent + "/" + dirName + "_root"

    #directory = filepath + "_root"
    if os.path.exists(directory):
        shutil.rmtree(directory)
    os.makedirs(directory)

    dirLocal = dirName + "/"

    filenames = []
    absFilenames = []

    rotX = mathutils.Matrix.Rotation(-pi/2, 4, 'X')

    for ob in scene.objects:
        if ob.type == 'MESH':
            localPath = dirLocal + ob.name + ".obj"
            absPath = directory + "/" + ob.name + ".obj"
            filenames.append(localPath)
            absFilenames.append(absPath)

            parentTrans = ob.matrix_world * ob.matrix_local.inverted()

            locTrans = ob.matrix_local.copy()
            absTrans = parentTrans.inverted()

            objPosition = ob.location.copy() # rotX * 
            objRotation = ob.rotation_quaternion.copy()
            objScale = ob.scale.copy()

            ob.location = absTrans.to_translation()
            ob.rotation_euler = absTrans.to_euler()
            ob.rotation_quaternion = absTrans.to_quaternion()
            ob.scale = absTrans.to_scale()

            scene.update()

            bpy.ops.object.select_pattern(pattern = ob.name)
            bpy.ops.export_scene.obj(
              filepath = absPath, 
              use_selection = True, 
              use_materials = False,
              use_triangles = True,
              use_uvs = True,
              use_mesh_modifiers = True)

            ob.location = locTrans.to_translation()
            ob.rotation_euler = locTrans.to_euler()
            ob.rotation_quaternion = locTrans.to_quaternion()
            ob.scale = locTrans.to_scale()

            scene.update()

            entityFileLocalPath = dirLocal + ob.name + ".entity"
            entityFileAbsPath = directory + "/" + ob.name + ".entity"
            filenames.append(entityFileLocalPath)
            absFilenames.append(entityFileAbsPath)

            f = open(entityFileAbsPath, 'wb')
            name = 'name=\"%s\"\n' % (ob.name)
            f.write(bytearray(name.encode('ascii')))
            pos = 'position=(%s,%s,%s)\n' % (objPosition.x, objPosition.z, objPosition.y)
            f.write(bytearray(pos.encode('ascii')))
            rot = 'rotation=(%s,%s,%s,%s)\n' % (objRotation.x, objRotation.z, objRotation.y, objRotation.w)
            f.write(bytearray(rot.encode('ascii')))
            scale = 'scale=(%s,%s,%s)\n' % (objScale.x, objScale.z, objScale.y)
            f.write(bytearray(scale.encode('ascii')))
            mesh = 'mesh=\"%s\"\n' % (localPath)
            f.write(bytearray(mesh.encode('ascii')))
            if len(ob.data.materials) > 0:
                mat = ob.data.materials[0]
                materialName = mat.name
                localMatPath = dirLocal + mat.name + ".material"
                materialStr = 'material=\"%s\"\n' % (localMatPath)
                f.write(bytearray(materialStr.encode('ascii')))
            f.close()

    fileDataOffset = 12; #initial offset
    for i, filename in enumerate(filenames):
        fileDataOffset = fileDataOffset + 4; # filename size
        fileDataOffset = fileDataOffset + len(filename.encode('ascii'))
        fileDataOffset = fileDataOffset + 8 # data offset
        fileDataOffset = fileDataOffset + 8 # data size

    f = open(filepath, 'wb')
    f.write(bytearray('BOXF'.encode('ascii')))
    f.write(struct.pack('<Q', len(filenames)))

    for i, filename in enumerate(filenames):
        filenameData = bytearray(filename.encode('ascii'))
        filePathSize = len(filenameData)
        fileDataSize = os.path.getsize(absFilenames[i])
        f.write(struct.pack('<I', filePathSize))
        f.write(filenameData)
        f.write(struct.pack('<Q', fileDataOffset))
        f.write(struct.pack('<Q', fileDataSize))
        fileDataOffset = fileDataOffset + fileDataSize

    for i, filename in enumerate(absFilenames):
        f2 = open(filename, 'rb')
        fileData = bytearray(f2.read())
        f.write(fileData)
        f2.close()

    f.close()

    return {'FINISHED'}

class ExportDagonAsset(bpy.types.Operator, ExportHelper):
    bl_idname = "scene.asset"
    bl_label = "Export Dagon Asset"
    filename_ext = ".asset"

    filter_glob = StringProperty(default = "unknown.asset", options = {"HIDDEN"})

    @classmethod
    def poll(cls, context):
        return True

    def execute(self, context):
        filepath = self.filepath
        filepath = bpy.path.ensure_ext(filepath, self.filename_ext)           
        return doExport(context, filepath)

    def invoke(self, context, event):
        wm = context.window_manager
        if True:
            wm.fileselect_add(self)
            return {"RUNNING_MODAL"}
        elif True:
            wm.invoke_search_popup(self)
            return {"RUNNING_MODAL"}
        elif False:
            return wm.invoke_props_popup(self, event)
        elif False:
            return self.execute(context)

def menu_func_export_dagon_asset(self, context):
    self.layout.operator(ExportDagonAsset.bl_idname, text = "Dagon Asset (.asset)")

def register():
    bpy.utils.register_module(__name__)
    bpy.types.INFO_MT_file_export.append(menu_func_export_dagon_asset)

def unregister():
    bpy.types.INFO_MT_file_export.remove(menu_func_export_dagon_asset)
    bpy.utils.unregister_module(__name__)

if __name__ == "__main__":
    register()

