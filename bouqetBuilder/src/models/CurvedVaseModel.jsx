import React from "react";
import { useGLTF } from "@react-three/drei";
import * as THREE from "three";

export function CurvedVaseModel({ color, ...props }) {
  const { nodes } = useGLTF("/models/CurvedVase.glb");

  // Define a ceramic material
  const ceramicMaterial = new THREE.MeshPhysicalMaterial({
    color: color, // Default white ceramic color
    roughness: 0.3, // Slightly smooth surface
    clearcoat: 0, // Adds a shiny ceramic-like coating
    clearcoatRoughness: 0.1, // Fine polish for clearcoat

    transmission: 0.2, // Adds slight translucency
    metalness: 0.0, // No metallic properties
  });

  return (
    <group {...props} dispose={null}>
      <group position={[0, 0, 0]} rotation={[-Math.PI / 2, 0, 0]}>
        <mesh
          castShadow
          receiveShadow
          geometry={nodes.collapse_vase_large.geometry}
          material={ceramicMaterial} // Use the ceramic material
          scale={0.005}
        />
      </group>
    </group>
  );
}

useGLTF.preload("/models/CurvedVase.glb");
