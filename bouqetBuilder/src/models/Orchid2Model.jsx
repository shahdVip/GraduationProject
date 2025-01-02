import React, { useRef } from "react";
import { useGLTF } from "@react-three/drei";

export function Orchid2Model({ color, ...props }) {
  const { nodes, materials } = useGLTF("/models/Orchid2.glb");
  return (
    <group {...props} dispose={null}>
      <group position={[0, -7, 0]} rotation={[-Math.PI / 2, 0, 0]} scale={0.04}>
        <group>
          <mesh
            castShadow
            receiveShadow
            geometry={nodes["Fl-009_anbz03_1"].geometry}
          >
            <meshPhysicalMaterial
              color={"#63653E"} // Subtle pink or user-defined
              roughness={0.4} // Slight texture on petals
              clearcoat={0.8} // Glossy top layer
              clearcoatRoughness={0.2} // Slight roughness on gloss
              transmission={0.5} // Light passes through for translucency
              thickness={0.1} // Thin material for realistic light interaction
            />
          </mesh>
          <mesh
            castShadow
            receiveShadow
            geometry={nodes["Fl-009_anbz03_2"].geometry}
          >
            <meshPhysicalMaterial
              color="#191814" // Deeper pink or red for accents
              roughness={0.3}
              clearcoat={0.9}
            />
          </mesh>
          <mesh
            castShadow
            receiveShadow
            geometry={nodes["Fl-009_anbz03_3"].geometry}
          >
            <meshPhysicalMaterial
              color="#CBA27C" // Vibrant green for leaves
              roughness={0.5} // Matte texture for natural look
              metalness={0.2} // Slight metallic for sheen
            />
          </mesh>
          <mesh
            castShadow
            receiveShadow
            geometry={nodes["Fl-009_anbz03_4"].geometry}
          >
            <meshPhysicalMaterial
              color={color || "#ffffff"} // Darker green for stems
              roughness={0.6} // Coarser texture for stems
            />
          </mesh>
          <mesh
            castShadow
            receiveShadow
            geometry={nodes["Fl-009_anbz03_5"].geometry}
          >
            <meshPhysicalMaterial
              color="#191814" // Subtle beige or pastel accent
              roughness={0.4}
              clearcoat={0.7}
            />
          </mesh>
        </group>
      </group>
    </group>
  );
}

useGLTF.preload("/models/Orchid2.glb");
