import React from "react";
import { useGLTF } from "@react-three/drei";

export function TwoPartsVaseModel({ color, ...props }) {
  const { nodes } = useGLTF("/models/TwoPartsVase.glb");

  return (
    <group {...props} dispose={null}>
      {/* Golden Metallic Part */}
      <group position={[0, 0, 0]} rotation={[-Math.PI / 2, 0, 0]} scale={0.005}>
        <mesh castShadow receiveShadow geometry={nodes.Gold_vase.geometry}>
          <meshPhysicalMaterial
            color={"#FFFFFF"} // White for glass appearance
            transparent={true} // Enable transparency
            opacity={0.4} // Adjust transparency
            roughness={0.1} // Smoothness of the surface
            metalness={0} // Minimal metallic effect
            transmission={0.1} // High transmission for glass effect
            ior={3} // Index of refraction (glass-like)
            thickness={0.2} // Physical thickness for refraction
            clearcoat={1} // Reflective coating
            clearcoatRoughness={0} // Smooth clearcoat
          />
        </mesh>
      </group>

      {/* Transparent Glass Part */}
      <group position={[0, 0, 0]} rotation={[-Math.PI / 2, 0, 0]} scale={0.005}>
        <mesh castShadow receiveShadow geometry={nodes.Object.geometry}>
          <meshPhysicalMaterial
            color={color || "#BC9C72"} // Gold color
            roughness={0.1} // Smooth metallic surface
            metalness={0.7} // Fully metallic
            clearcoat={0.1} // Adds reflective coating
            clearcoatRoughness={0.2} // Slight roughness on the clear coat
          />
        </mesh>
      </group>
    </group>
  );
}

useGLTF.preload("/models/TwoPartsVase.glb");
