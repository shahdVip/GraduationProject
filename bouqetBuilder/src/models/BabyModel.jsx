import React, { Suspense } from "react";
import { useGLTF } from "@react-three/drei";
import { MeshPhysicalMaterial, TextureLoader } from "three";

export function BabyModel({ color, ...props }) {
  const { nodes, materials } = useGLTF("/models/baby.glb");

  // Load a texture (diffuse, bump, or normal map) for more realistic detail
  const texture = new TextureLoader().load(
    "/textures/flower-balls-texture.jpg"
  );

  return (
    <group {...props} dispose={null}>
      <group position={[0, -0.5, 0]} rotation={[-Math.PI / 2, 0, 0]}>
        <group scale={0.009}>
          <mesh
            castShadow
            receiveShadow
            geometry={nodes.Bouquet_Dried_flower_03_004_1.geometry}
          >
            <meshPhysicalMaterial
              color={color || "#ffffff"} // Balls color
              roughness={0.3} // Smooth, glossy surface
              metalness={0.2} // Slightly metallic to simulate a slight shine
              clearcoat={0.5} // Enhanced glossiness for more sheen
              clearcoatRoughness={0.1} // Less roughness for a smoother surface
              sheen={0.5} // Increased sheen for a soft glimmer
              sheenColor={"#F2F2F2"} // Light, subtle sheen color
              opacity={0.95} // Slightly more transparency for delicate appearance
              transparent={true} // Enable transparency for a more natural look
              transmission={0.2} // Slight transmission for realistic light diffusion
              map={texture} // Apply texture to the balls
            />
          </mesh>
          <mesh
            castShadow
            receiveShadow
            geometry={nodes.Bouquet_Dried_flower_03_004_2.geometry}
          >
            <meshPhysicalMaterial
              color={"#797953"} // Color for the other balls
              roughness={0.3} // Slightly matte for a more natural feel
              metalness={0.2} // Light metallic effect
              clearcoat={0.5}
              clearcoatRoughness={0.1}
              sheen={0.5}
              sheenColor={"#F2F2F2"}
              opacity={0.95}
              transparent={true}
              transmission={0.2}
              map={texture} // Use the same texture or another one
            />
          </mesh>
        </group>
      </group>
    </group>
  );
}

useGLTF.preload("/models/baby.glb");
