import React from "react";
import { useGLTF } from "@react-three/drei";
import * as THREE from "three";

export function GreeneryModel({ ...props }) {
  const { nodes } = useGLTF("/models/Greenery1.glb");

  return (
    <group
      {...props}
      dispose={null}
      position={[-4.8, -1.5, -2]}
      rotation={[-Math.PI / 2, -Math.PI / 9, 0]}
      scale={0.003}
    >
      <group>
        <mesh castShadow receiveShadow geometry={nodes.Object006.geometry}>
          <meshPhysicalMaterial
            color={"#AB9F7B"} // Natural green color
            roughness={0.6} // Adds some matte finish
            metalness={0} // No metallic look
            clearcoat={0.3} // Adds a subtle shine like real leaves
            clearcoatRoughness={0.2} // Keeps the shine slightly diffused
            transmission={0.1} // Light passes through leaves slightly
            thickness={0.1} // Simulates the thin nature of leaves
          />
        </mesh>
      </group>
      <group>
        <mesh castShadow receiveShadow geometry={nodes.Object008.geometry}>
          <meshPhysicalMaterial
            color={"#768A6A"} // Lighter green for the front side
            roughness={0.5} // Slightly matte finish for natural look
            metalness={0} // No metallic shine
            clearcoat={0.2} // Light glossiness to mimic leaf surface
            clearcoatRoughness={0.3} // Slightly diffused gloss
            transmission={0.1} // Slight light transmission to simulate thinness
            thickness={0.05} // Thin leaf effect, but not too thin
            opacity={1} // Fully opaque for a natural leaf
            side={THREE.FrontSide} // Apply to front side only
          />
        </mesh>
      </group>

      {/* Back side of the leaf */}
      <group>
        <mesh castShadow receiveShadow geometry={nodes.Object008.geometry}>
          <meshPhysicalMaterial
            color={"#4F5C47"} // Richer green for the back side
            roughness={0.7} // More matte to replicate leaf texture
            metalness={0} // No metallic effect
            clearcoat={0.1} // Light gloss for natural appearance
            clearcoatRoughness={0.6} // More diffused gloss on the back side
            transmission={0} // No transparency for denser leaf texture
            opacity={1} // Fully opaque for realistic density
            side={THREE.BackSide} // Apply to back side only
          />
        </mesh>
      </group>
    </group>
  );
}
//4F5C47
useGLTF.preload("/models/Greenery1.glb");
