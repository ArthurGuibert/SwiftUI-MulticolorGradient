//
//  MulticolorGradientViewController.swift
//  
//
//  Created by Arthur Guibert on 31/10/2022.
//

import UIKit
import MetalKit
import SwiftUI

struct CompilerErrorMessage {
    let lineNumber: Int
    let columnNumber: Int
    let error: String
    let message: String
}

struct Uniforms {
    let pointCount: simd_int1
    
    let bias: simd_float1
    let power: simd_float1
    
    let point0: simd_float2
    let point1: simd_float2
    let point2: simd_float2
    let point3: simd_float2
    let point4: simd_float2
    let point5: simd_float2
    let point6: simd_float2
    let point7: simd_float2
    
    let color0: simd_float3
    let color1: simd_float3
    let color2: simd_float3
    let color3: simd_float3
    let color4: simd_float3
    let color5: simd_float3
    let color6: simd_float3
    let color7: simd_float3
}

public class MulticolorGradientViewController: UIViewController, MTKViewDelegate {
    var mtkView: MTKView!
    var computePipelineState: MTLComputePipelineState?
    var commandQueue: MTLCommandQueue! = nil

    var points: [MulticolorGradientPoint] = []
    var bias: Float = 0.001
    var power: Float = 2
    
    var finishedCompiling: ((Bool, [CompilerErrorMessage]?) -> ())?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let mtkView = MTKView()
        view.addSubview(mtkView)
        mtkView.frame = view.bounds
        mtkView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Select the device to render with.  We choose the default device
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            print("Metal is not supported on this device")
            return
        }
        
        mtkView.device = defaultDevice
        mtkView.delegate = self
        mtkView.preferredFramesPerSecond = 60
        mtkView.device = defaultDevice
        mtkView.framebufferOnly = false
        
        //start paused
        mtkView.isPaused = false
        
        if setComputePipeline(device: defaultDevice) == nil {
            fatalError("Default fragment shader has problem compiling")
        }
        
        commandQueue = defaultDevice.makeCommandQueue()
    }
    
    public func setComputePipeline(device: MTLDevice) -> MTLComputePipelineState? {
        if let computeProgram = loadShaders(device: device) {
            computePipelineState = try? device.makeComputePipelineState(function: computeProgram)
            
            return computePipelineState
        }
        
        return nil
    }
    
    fileprivate func loadShaders(device: MTLDevice) -> MTLFunction? {
        guard let library = try? device.makeDefaultLibrary(bundle: Bundle.module)
              else { fatalError("Unable to create default library") }
        let computeProgram = library.makeFunction(name: "gradient")
        
        if let onCompilerResult = finishedCompiling {
            onCompilerResult(true, nil)
        }
        
        return computeProgram
    }
    
    public func mtkView(_ view: MTKView,
                 drawableSizeWillChange size: CGSize) {
        
    }
    
    public func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else { return }
        
        var shaderPoints: [(simd_float2, simd_float3)] = Array(repeating: (simd_float2(0.0, 0.0), simd_float3(0.0, 0.0, 0.0)),
                                                               count: 8)
        
        for i in 0..<points.count {
            let point = points[i]
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            
            guard UIColor(point.color).getRed(&r, green: &g, blue: &b, alpha: nil) else {
                continue
            }
            
            shaderPoints[i] = (simd_float2(Float(point.position.x), Float(point.position.y)), simd_float3(Float(r), Float(g), Float(b)))
        }
        
        var uniforms = Uniforms(pointCount: simd_int1(points.count),
                                bias: bias,
                                power: power,
                                point0: shaderPoints[0].0,
                                point1: shaderPoints[1].0,
                                point2: shaderPoints[2].0,
                                point3: shaderPoints[3].0,
                                point4: shaderPoints[4].0,
                                point5: shaderPoints[5].0,
                                point6: shaderPoints[6].0,
                                point7: shaderPoints[7].0,
                                color0: shaderPoints[0].1,
                                color1: shaderPoints[1].1,
                                color2: shaderPoints[2].1,
                                color3: shaderPoints[3].1,
                                color4: shaderPoints[4].1,
                                color5: shaderPoints[5].1,
                                color6: shaderPoints[6].1,
                                color7: shaderPoints[7].1)
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let computeEncoder = commandBuffer?.makeComputeCommandEncoder()
        computeEncoder?.setComputePipelineState(computePipelineState!)
        computeEncoder?.setBytes(&uniforms, length: MemoryLayout<Uniforms>.size, index: 0)
        computeEncoder?.setTexture(drawable.texture, index: 4)
        
        let threadGroupCount = MTLSizeMake(8, 8, 1)
        let threadGroups = MTLSizeMake(drawable.texture.width / threadGroupCount.width,
                                       drawable.texture.height / threadGroupCount.height,
                                       1)
        
        computeEncoder?.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupCount)
        computeEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    func parseCompilerOutput(_ compilerOutput: String) -> [CompilerErrorMessage] {
        let components = compilerOutput.components(separatedBy: "program_source")
        var outMessages = [CompilerErrorMessage]()
        
        for index in components.indices.dropFirst() {
            let splitted = components[index].split(separator: ":")
            
            if splitted.count < 4 {
                return outMessages
            }
            
            if let line: Int = Int(splitted[0]),
               let column: Int = Int(splitted[1]) {
                let compilerMessage = CompilerErrorMessage(lineNumber: line, columnNumber: column, error: String(splitted[2]), message: String(splitted[3]))
                
                outMessages.append(compilerMessage)
            }
        }
        
        return outMessages
    }
}
