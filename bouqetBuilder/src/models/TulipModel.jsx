import React, { useRef } from "react";
import { useGLTF } from "@react-three/drei";

export function TulipModel({ color, ...props }) {
  const { nodes, materials } = useGLTF("/models/openTulip.glb"); // Adjust path

  return (
    <group {...props} dispose={null}>
      <group position={[33, -5, 4]} rotation={[-Math.PI / 2, 0, Math.PI]}>
        <group scale={0.05}>
          {/* Tulip Petals */}
          <mesh castShadow receiveShadow geometry={nodes.Object004_1.geometry}>
            <meshPhysicalMaterial
              color={color || "#ffffff"} // Vivid red for the petals
              reflectivity={0.5} // Moderate reflectivity for a soft sheen
              roughness={0.6} // Slightly rough for a natural look
              clearcoat={0.3} // Subtle glossy effect
              clearcoatRoughness={0.4} // Controls glossiness smoothness
            />
          </mesh>

          {/* Tulip Stamens */}
          <mesh castShadow receiveShadow geometry={nodes.Object004_2.geometry}>
            <meshPhysicalMaterial
              color={"#ffd700"} // Golden yellow for stamens
              reflectivity={0.3} // Lower reflectivity for a matte look
              roughness={0.8} // Less glossy
            />
          </mesh>

          {/* More Petals */}
          <mesh castShadow receiveShadow geometry={nodes.Object004_3.geometry}>
            <meshPhysicalMaterial
              color={"#ffd700"} // Matching petal color
              reflectivity={0.5}
              roughness={0.6}
              clearcoat={0.3}
              clearcoatRoughness={0.4}
            />
          </mesh>

          {/* Leaves */}
          <mesh castShadow receiveShadow geometry={nodes.Object004_4.geometry}>
            <meshPhysicalMaterial
              color={"#919744"} // Rich green for the leaves
              reflectivity={0.4} // Moderate reflectivity
              roughness={0.5} // Slightly rough for realism
              clearcoat={0.2} // Adds a waxy leaf-like effect
            />
          </mesh>
        </group>
      </group>

      <group position={[33.7, -5, 4.5]} rotation={[-Math.PI / 2, 0, Math.PI]}>
        <mesh
          castShadow
          receiveShadow
          geometry={nodes.Object006.geometry}
          scale={0.05} // Increased scale for consistency
        >
          {/* Apply assetColor to the fifth mesh */}
          <meshStandardMaterial color={"#919744"} />
        </mesh>
      </group>
    </group>
  );
}

useGLTF.preload("/models/openTulip.glb"); // Adjust path
