import React from "react";
import { useGLTF } from "@react-three/drei";
import * as THREE from "three";

// Component name with uppercase initial letter
export function ClosedTulipModel({ color, ...props }) {
  const { nodes } = useGLTF("/models/closeTulip.glb");

  // Materials for realistic tulip
  const petalMaterial = new THREE.MeshPhysicalMaterial({
    color: color, //Vivid red for the petals
    reflectivity: 0.5, // Moderate reflectivity for a soft sheen
    roughness: 0.6, // Slightly rough for a natural look
    clearcoat: 0.3, // Subtle glossy effect
    clearcoatRoughness: 0.4, // Enables translucency
  });

  const leafMaterial = new THREE.MeshPhysicalMaterial({
    color: "#919744", // Rich green for the leaves and stalk
    roughness: 0.6, // Matte finish for a natural look
    metalness: 0, // Non-metallic
  });

  const stalkMaterial = new THREE.MeshPhysicalMaterial({
    color: "#919744", // Slightly darker green for the stalk
    roughness: 0.7, // Matte and rough for texture
    metalness: 0, // Non-metallic
  });

  return (
    <group {...props} dispose={null}>
      {/* Tulip flower */}
      <group position={[17, -5, 3]} rotation={[-Math.PI / 2, 0, Math.PI]}>
        <group scale={0.05}>
          <mesh
            castShadow
            receiveShadow
            geometry={nodes.Object_1.geometry}
            material={petalMaterial} // Apply petal material
          />
          <mesh
            castShadow
            receiveShadow
            geometry={nodes.Object_2.geometry}
            material={petalMaterial} // Apply petal material
          />
          <mesh
            castShadow
            receiveShadow
            geometry={nodes.Object_3.geometry}
            material={leafMaterial} // Apply leaf material
          />
        </group>
      </group>
      {/* Tulip stalk */}
      <group position={[17, -5, 3]} rotation={[-Math.PI / 2, 0, Math.PI]}>
        <mesh
          castShadow
          receiveShadow
          geometry={nodes.Object002.geometry}
          material={stalkMaterial} // Apply stalk material
          scale={0.05}
        />
      </group>
    </group>
  );
}

useGLTF.preload("/models/closeTulip.glb");
