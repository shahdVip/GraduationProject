// import { useGLTF } from "@react-three/drei";
// import { useEffect, useMemo } from "react";
// import { useConfiguratorStore } from "../store";

// export const Asset = ({ url, categoryName, skeleton }) => {
//   const { scene } = useGLTF(url);

//   const customization = useConfiguratorStore((state) => state.customization);

//   const assetColor = customization[categoryName].color;

//   const skin = useConfiguratorStore((state) => state.skin);

//   useEffect(() => {
//     scene.traverse((child) => {
//       if (child.isMesh) {
//         if (child.material?.name.includes("Color_")) {
//           child.material.color.set(assetColor);
//         }
//       }
//     });
//   }, [assetColor, scene]);

//   const attachedItems = useMemo(() => {
//     const items = [];
//     scene.traverse((child) => {
//       if (child.isMesh) {
//         console.log("Mesh Name:", child.name);
//         console.log("Geometry Attributes:", child.geometry.attributes);

//         items.push({
//           geometry: child.geometry,
//           material: child.material.name.includes("Skin_")
//             ? skin
//             : child.material,
//         });
//       }
//     });
//     return items;
//   }, [scene]);

//   return attachedItems.map((item, index) => (
//     <skinnedMesh
//       key={index}
//       geometry={item.geometry}
//       material={item.material}
//       skeleton={skeleton}
//       castShadow
//       receiveShadow
//     ></skinnedMesh>
//   ));
// };

import { useGLTF } from "@react-three/drei";
import { useEffect, useMemo } from "react";
import { useConfiguratorStore } from "../store";

export const Asset = ({ url, categoryName, position, rotation, scale }) => {
  const { scene } = useGLTF(url);

  // Get customization for the specific category
  const customization = useConfiguratorStore((state) => state.customization);
  const assetColor = customization[categoryName]?.color;

  useEffect(() => {
    scene.traverse((child) => {
      if (child.isMesh) {
        // Target a specific mesh by name
        if (child.name === "Cylinder007") {
          child.material.color.set("#549056");
        }
        if (child.name === "Cylinder007_3") {
          child.material.color.set("#F7FF06");
        }
        if (child.name === "Cylinder007_1") {
          child.material.color.set(assetColor);
        }
        if (child.name === "Kala_013") {
          child.material.color.set(assetColor);
        }
      }
    });
  }, [assetColor, scene]);

  // Prepare meshes for rendering
  const attachedItems = useMemo(() => {
    const items = [];
    scene.traverse((child) => {
      if (child.isMesh) {
        console.log(child.name); // Logs the name of each mesh

        items.push({
          geometry: child.geometry,
          material: child.material,
        });
      }
    });
    return items;
  }, [scene]);

  return attachedItems.map((item, index) => (
    <mesh
      key={index}
      geometry={item.geometry}
      material={item.material}
      position={position}
      rotation={rotation}
      scale={scale}
      castShadow
      receiveShadow
    ></mesh>
  ));
};
