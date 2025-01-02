import React from "react";
import { useGLTF } from "@react-three/drei";
import * as THREE from "three";

export function Greenery22Model({ ...props }) {
  const { nodes, materials } = useGLTF("/models/Greenery2.glb");
  return (
    <group {...props} dispose={null}>
      <group
        position={[0, 0.7, 0]}
        rotation={[-Math.PI / 1.7, Math.PI / 20, 0]}
        scale={0.005}
      >
        <group>
          <mesh
            castShadow
            receiveShadow
            geometry={nodes.FL018_anbz31_1.geometry}
          >
            <meshPhysicalMaterial
              color={"#7E6C4E"} // Olive green color
              roughness={0.7} // Matte texture
              metalness={0} // Non-metallic surface
              clearcoat={0.15} // Subtle waxy shine
              clearcoatRoughness={0.4} // Diffused shine
              sheen={0.3} // Adds a soft glow
              sheenColor={"#728F3C"} // Slight variation in green
              transmission={0} // No transparency
              opacity={1} // Fully opaque
              thickness={0.1} // Thin but solid structure

              ///nodes.FL018_anbz31_2.geometry
            />
          </mesh>
          <mesh
            castShadow
            receiveShadow
            geometry={nodes.FL018_anbz31_2.geometry}
          >
            <meshStandardMaterial
              attach="material"
              color={"#173A1A"} // Darker green (top side)
              roughness={0.7} // Matte texture
              metalness={0} // Non-metallic
              clearcoat={0.2} // Waxy shine
              clearcoatRoughness={0.5}
              side={THREE.FrontSide} // Apply to front side only
            />
          </mesh>
          {/* Underside of the Leaf */}
          <mesh
            castShadow
            receiveShadow
            geometry={nodes.FL018_anbz31_2.geometry}
          >
            <meshStandardMaterial
              attach="material"
              color={"#A4B695"} // Lighter green (underside)
              roughness={0.8}
              metalness={0}
              clearcoat={0.15}
              clearcoatRoughness={0.6}
              side={THREE.BackSide} // Apply to back side only
            />
          </mesh>
        </group>
      </group>
    </group>
  );
}

useGLTF.preload("/models/Greenery2.glb");
