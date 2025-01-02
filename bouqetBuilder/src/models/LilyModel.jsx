import React, { useRef } from "react";
import { useGLTF } from "@react-three/drei";
import * as THREE from "three";

// LilyModel component
export function LilyModel({ color, scale, ...props }) {
  const { nodes, materials } = useGLTF("/models/lily.glb"); // Adjust the path if necessary

  // Use proper hex color codes with a '#' prefix
  materials["pistils 2"].color.set("#F7FF06"); // Modify pistils 2 material color
  materials["pistils 1"].color.set("#F7FF06"); // Modify pistils 1 material color
  materials["stalk "].color.set("#549056"); // Modify stalk material color

  // Modify the color of existing materials if a color is provided
  if (color) {
    materials.petals.color.set(color); // Modify petals material color
  }

  return (
    <group {...props} dispose={null}>
      <group
        position={[-0.111, 10, -0.26]}
        rotation={[Math.PI, 0.649, -2.771]}
        scale={0.7}
      >
        {/* Render the meshes using the updated materials */}
        <mesh
          castShadow
          receiveShadow
          geometry={nodes.Cylinder007.geometry}
          material={materials["stalk "]}
        />
        <mesh
          castShadow
          receiveShadow
          geometry={nodes.Cylinder007_1.geometry}
          material={materials.petals}
        />
        <mesh
          castShadow
          receiveShadow
          geometry={nodes.Cylinder007_2.geometry}
          material={materials["pistils 2"]}
        />
        <mesh
          castShadow
          receiveShadow
          geometry={nodes.Cylinder007_3.geometry}
          material={materials["pistils 1"]}
        />
      </group>
    </group>
  );
}

useGLTF.preload("/models/lily.glb"); // Adjust the path if necessary
