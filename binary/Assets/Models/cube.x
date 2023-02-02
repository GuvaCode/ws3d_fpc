xof 0303txt 0032

// DirectX File - exported from Blender version 241 using DirectX8ExporterMod.py - mod version 1.3.2

template VertexDuplicationIndices { 
   <b8d65549-d7c9-4995-89cf-53a9a8b031e3>
   DWORD nIndices;
   DWORD nOriginalVertices;
   array DWORD indices[nIndices];
 }
 template XSkinMeshHeader {
   <3cf169ce-ff7c-44ab-93c0-f78f62d172e2>
   WORD nMaxSkinWeightsPerVertex;
   WORD nMaxSkinWeightsPerFace;
   WORD nBones;
 }
 template SkinWeights {
   <6f0d123b-bad2-4167-a0d0-80224f25fabb>
   STRING transformNodeName;
   DWORD nWeights;
   array DWORD vertexIndices[nWeights];
   array float weights[nWeights];
   Matrix4x4 matrixOffset;
 }

Frame body {

  FrameTransformMatrix {
    1.000000,0.000000,0.000000,0.000000,
    0.000000,1.000000,0.000000,0.000000,
    0.000000,0.000000,1.000000,0.000000,
    0.000000,0.000000,0.000000,1.000000;;
  }
  Mesh object {
    8;
    1.000000;-1.000000;1.000000;,
    1.000000;-1.000000;-1.000000;,
    -1.000000;-1.000000;-1.000000;,
    -1.000000;-1.000000;1.000000;,
    1.000000;1.000000;0.999999;,
    0.999999;1.000000;-1.000001;,
    -1.000000;1.000000;-1.000000;,
    -1.000000;1.000000;1.000000;;
    6;
    4;3,2,1,0;,
    4;5,6,7,4;,
    4;1,5,4,0;,
    4;2,6,5,1;,
    4;3,7,6,2;,
    4;7,3,0,4;;

    MeshNormals {
      8;
      0.577349;-0.577349;0.577349;,
      0.577349;-0.577349;-0.577349;,
      -0.577349;-0.577349;-0.577349;,
      -0.577349;-0.577349;0.577349;,
      0.577349;0.577349;0.577349;,
      0.577349;0.577349;-0.577349;,
      -0.577349;0.577349;-0.577349;,
      -0.577349;0.577349;0.577349;;
      6;
      4;3,2,1,0;,
      4;5,6,7,4;,
      4;1,5,4,0;,
      4;2,6,5,1;,
      4;3,7,6,2;,
      4;7,3,0,4;;
    }
    MeshMaterialList {
      1;
      6;
      0,
      0,
      0,
      0,
      0,
      0;
      Material Material {
        0.800000; 0.800000; 0.800000;1.000000;;
        0.500000;
        1.000000; 1.000000; 1.000000;;
        0.0; 0.0; 0.0;;
      }
    }
  }
}
