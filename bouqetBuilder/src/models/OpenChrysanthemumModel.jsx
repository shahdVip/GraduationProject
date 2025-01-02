import React, { useRef } from "react";
import { useGLTF } from "@react-three/drei";
import * as THREE from "three";

export function OpenChrysanthemumModel({ color, ...props }) {
  const { nodes, materials } = useGLTF("/models/OpenChrysanthemum.glb");

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
      <group position={[-2, 2, -3.5]} rotation={[-Math.PI / 5, 0, 0]}>
        <group scale={0.055}>
          <mesh
            castShadow
            receiveShadow
            geometry={nodes.FL032_Corona21_1.geometry}
            material={otherMaterial} // Apply petal material
          />
          <mesh
            castShadow
            receiveShadow
            geometry={nodes.FL032_Corona21_2.geometry}
            material={petalMaterial} // Apply petal material
          />
          <mesh
            castShadow
            receiveShadow
            geometry={nodes.FL032_Corona21_3.geometry}
            material={otherMaterial} // Apply other material
          />
        </group>
      </group>
    </group>
  );
}

useGLTF.preload("/models/OpenChrysanthemum.glb");
