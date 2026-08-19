Shader "Doppels shaders/Models shaders/MetallicFX 6.0.1"
{
    Properties
    {
		_MetallicTexture("Metallic Texture (RGB)", 2D) = "white" {}
        _MetallicMask("Metallic Mask (R)", 2D) = "white" {}
        _MetMul("Metallic Replace", range(0, 1)) = 1.0
        _MetAdd("Metallic Add", range(0, 1)) = 0.0
        _MetEmission("Metallic Emission", range(0, 1)) = 0.0
		[HDR]_mColor1("Metallic Color 1", Color) = (1,1,1,1)
		[HDR]_mColor2("Metallic Color 2", Color) = (1,1,1,1)
		[HDR]_mColor3("Metallic Color 3", Color) = (1,1,1,1)
		_Contrast("Contrast", range(0, 1)) = 0.1
		_RadialDistortion("Radial Distortion", range(0, 1)) = 0.7
		_ShineSpeed("Shine Speed", range(0, 1)) = 0.1
		_MainTex("Main Texture", 2D) = "white" {}
		_Color("Main tint", Color) = (1,1,1,1)
		_EmissionMap("Emission Map", 2D) = "white" {}
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,1)
        _BumpMap("Normal Map", 2D) = "bump" {}
        _BumpScale("Normal Scale", range(0, 10)) = 1.0
        [Enum(Off, 0, On, 1)]DS("Direct Specular", int) = 1

		[Enum(UnityEngine.Rendering.CullMode)]_Cull("Cull", float) = 2
        [IntRange]_Stencil("Stencil ID [0;255]", Range(0,255)) = 0
        _ReadMask("ReadMask [0;255]", Int) = 255
        _WriteMask("WriteMask [0;255]", Int) = 255
        [Enum(UnityEngine.Rendering.CompareFunction)]_StencilComp("Stencil Comparison", Int) = 0
        [Enum(UnityEngine.Rendering.StencilOp)]_StencilOp("Stencil Operation", Int) = 0
        [Enum(UnityEngine.Rendering.StencilOp)]_StencilFail("Stencil Fail", Int) = 0
        [Enum(UnityEngine.Rendering.StencilOp)]_StencilZFail("Stencil ZFail", Int) = 0

		[Enum(Off, 0, On, 1)]_UseCustomQueue("Use Custom Render Queue", int) = 0
        _Queue("Material Render Queue", int) = 2000

        _MainGUI("", int) = 0
        _MetallicGUI("", int) = 0
        _RendererGUI("", int) = 0
    }
    CustomEditor "MetallicFX601GUI"
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }
        Cull [_Cull]
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_ReadMask]
			WriteMask [_WriteMask]
			Comp [_StencilComp]
			Pass [_StencilOp]
			Fail [_StencilFail]
			ZFail [_StencilZFail]
		}
        Pass
        {
            Name "FORWARD"
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM
            #pragma target 5.0
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _ VERTEXLIGHT_ON
            #pragma multi_compile_fog
            #pragma multi_compile_fwdbase
            #pragma multi_compile_instancing

            #ifndef UNITY_PASS_FORWARDBASE
                #define UNITY_PASS_FORWARDBASE
            #endif

            #include "../Includes/Defines.cginc"
            #include "../Includes/HelperFunctions.cginc"
            #include "../Includes/Vert.cginc"
            #include "../Includes/Frag.cginc"
            ENDCG
        }
        Pass
        {
            Name "FWDADD"
            Tags { "LightMode" = "ForwardAdd" }
            Blend One One
            ZWrite Off
            ZTest LEqual
            Fog { Color (0,0,0,0) }
            CGPROGRAM
            #pragma target 5.0
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #pragma multi_compile_fwdadd_fullshadows

            #ifndef UNITY_PASS_FORWARDADD
                 #define UNITY_PASS_FORWARDADD
            #endif

            #include "../Includes/Defines.cginc"
            #include "../Includes/HelperFunctions.cginc"
            #include "../Includes/Vert.cginc"
            #include "../Includes/Frag.cginc"
            ENDCG
        }
        Pass
        {
            Name "ShadowCaster"
            Tags{ "LightMode" = "ShadowCaster" }
            ZWrite On ZTest LEqual
            CGPROGRAM
            #pragma target 5.0
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_instancing
            #pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2

            #ifndef UNITY_PASS_SHADOWCASTER
                #define UNITY_PASS_SHADOWCASTER
            #endif

            #include "../Includes/Defines.cginc"
            #include "../Includes/HelperFunctions.cginc"
            #include "../Includes/Vert.cginc"
            #include "../Includes/Frag.cginc"
            ENDCG
        }
    }
}