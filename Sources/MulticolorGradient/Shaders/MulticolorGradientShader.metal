//
//  MeshGradient.metal
//  BlobToy
//
//  Created by Arthur Guibert on 23/03/2021.
//

#include <metal_stdlib>
using namespace metal;

typedef struct {
    int32_t pointCount;
    float bias;
    float power;
    float2 points[8];
    float3 colors[8];
} Uniforms;

kernel void gradient(texture2d<float, access::write> output [[texture(4)]],
                     constant Uniforms& uniforms [[buffer(0)]],
                     uint2 gid [[thread_position_in_grid]])
{
    int width = output.get_width();
    int height = output.get_height();
    float2 uv = float2(gid) / float2(width, width);
    
    float totalContribution = 0.0;
    float contribution[8];
    
    // Compute contributions
    for (int i = 0; i < uniforms.pointCount; i++)
    {
        float2 pos = uniforms.points[i] * float2(1.0, float(height) / float(width));
        pos = uv - pos;
        float dist = length(pos);
        float c = 1.0 / (uniforms.bias + pow(dist, uniforms.power));
        contribution[i] = c;
        totalContribution += c;
    }
    
    // Contributions normalisation
    float3 col = float3(0, 0, 0);
    float inverseContribution = 1.0 / totalContribution;
    for (int i = 0; i < uniforms.pointCount; i++)
    {
        col += contribution[i] * inverseContribution * uniforms.colors[i];
    }
    
    float4 color = float4(col, 1.0);
    output.write(color, gid);
}
