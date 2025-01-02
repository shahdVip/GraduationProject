//ChrysanthemumModel
import React, { useRef } from "react";
import { useGLTF } from "@react-three/drei";
import { MeshStandardMaterial } from "three";
import * as THREE from "three";

export function ChrysanthemumModel({ color, ...props }) {
  const { nodes } = useGLTF("/models/Chrysanthemum.glb");

  // Define materials for the flower
  const petalMaterial = new THREE.MeshPhysicalMaterial({
    color: color || "#ffffff", // Use passed color or default
    roughness: 0.4,
    clearcoat: 0.5,
    clearcoatRoughness: 0.3,
    transmission: 0.5,
    transparent: true,
  });

  const otherMaterial = new THREE.MeshPhysicalMaterial({
    color: "#465A14", // Default green color for other parts
    roughness: 0.6,
  });

  return (
    <group {...props} dispose={null}>
      <group position={[0, 2, 0]} rotation={[-Math.PI / 2, 0, 0]}>
        <group scale={0.055}>
          <mesh
            rotation={[Math.PI / 15, 0, 0]}
            castShadow
            receiveShadow
            geometry={nodes.FL032_Corona17_1.geometry}
            material={otherMaterial} // Apply petal material
          />
          <group rotation={[Math.PI / 15, 0, 0]}>
            <mesh
              castShadow
              receiveShadow
              geometry={nodes.FL032_Corona17_2.geometry}
              material={petalMaterial} // Apply petal material
            />
            <mesh
              castShadow
              receiveShadow
              geometry={nodes.FL032_Corona17_3.geometry}
              material={otherMaterial} // Apply other material
            />
          </group>
        </group>
      </group>
    </group>
  );
}

useGLTF.preload("/models/Chrysanthemum.glb");
