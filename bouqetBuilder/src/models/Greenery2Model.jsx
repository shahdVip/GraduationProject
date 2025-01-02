import React, { useRef } from "react";
import { useGLTF } from "@react-three/drei";

export function Greenery2Model({ ...props }) {
  const { nodes, materials } = useGLTF("/models/Greenery11.glb");
  return (
    <group
      {...props}
      dispose={null}
      position={[-2.7, 5.5, -1.3]}
      rotation={[0, 0, -Math.PI / 4]}
      scale={0.003}
    >
      <group>
        <mesh castShadow receiveShadow geometry={nodes.Object010.geometry}>
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
        <mesh castShadow receiveShadow geometry={nodes.Object012.geometry}>
          <meshStandardMaterial
            color={"#4F5C47"} // A richer, natural green tone
            roughness={0.7} // Reduced roughness to allow for a subtle shine
            metalness={0} // No metallic effect
            sheen={0.5} // Simulates the soft glow seen in real leaves
            clearcoat={0.1} // Adds a light, natural gloss
            clearcoatRoughness={0.5} // Keeps the gloss diffused
            transmission={0} // Remove transparency for denser leaves
            opacity={1} // Fully opaque for natural density
          />
        </mesh>
      </group>
    </group>
  );
}

useGLTF.preload("/models/Greenery11.glb");
