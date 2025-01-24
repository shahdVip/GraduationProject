import { useRef, useEffect, Suspense } from "react";
import { useGLTF } from "@react-three/drei";
import { useConfiguratorStore } from "../store";
import { TulipModel } from "../models/TulipModel"; // Reuse or modify Asset component if necessary
import { ClosedTulipModel } from "../models/closedTulipModel"; // Reuse or modify Asset component if necessary
import { ChrysanthemumModel } from "../models/ChrysanthemumModel";
import { OpenChrysanthemumModel } from "../models/OpenChrysanthemumModel";
import { CurvedVaseModel } from "../models/CurvedVaseModel";

import { GLTFExporter } from "three/examples/jsm/exporters/GLTFExporter";
import { TwoPartsVaseModel } from "./../models/TwoPartsVaseModel";
import { OrchidModel } from "../models/OrchidModel";
import { Orchid2Model } from "../models/Orchid2Model";
import { GreeneryModel } from "../models/GreeneryModel";
import { Greenery2Model } from "../models/Greenery2Model";
import { Greenery22Model } from "../models/Greenery22Model";
import { BabyModel } from "../models/BabyModel";
import axios from "axios";

export const BouquetBuilder = ({ ...props }) => {
  const group = useRef(); // Reference to the whole bouquet
  const { nodes, materials } = useGLTF("models/Vase 1.glb"); // Load vase model
  const customization = useConfiguratorStore((state) => state.customization); // Access customization options
  const setDownload = useConfiguratorStore((state) => state.setDownload); // Setter for download function
  const placeOrder = useConfiguratorStore((state) => state.placeOrder); // Setter for download function

  const vaseHeight = 1; // Approximate vase height for positioning flowers
  const defaultFlowerScale = [0.12, 0.12, 0.12]; // Default flower scale

  // Export functionality
  // useEffect(() => {
  //   function download() {
  //     const exporter = new GLTFExporter();
  //     exporter.parse(
  //       group.current,
  //       function (result) {
  //         save(
  //           new Blob([result], { type: "application/octet-stream" }),
  //           `bouquet_${+new Date()}.glb`
  //         );
  //       },
  //       function (error) {
  //         console.error(error);
  //       },
  //       { binary: true }
  //     );
  //   }

  //   const link = document.createElement("a");
  //   link.style.display = "none";
  //   document.body.appendChild(link);

  //   function save(blob, filename) {
  //     link.href = URL.createObjectURL(blob);
  //     link.download = filename;
  //     link.click();
  //   }
  //   setDownload(download);
  // }, [setDownload]);

  useEffect(() => {
    async function uploadFileToAPI(blob, filename) {
      try {
        const { selectedAssets, flowerCount } = placeOrder(); // Call the placeOrder function

        const formData = new FormData();
        formData.append("file", blob, filename); // Append the file blob
        formData.append("flowerCount", flowerCount); // Example field
        formData.append("selectedAssets", JSON.stringify(selectedAssets)); // Example selected assets

        const response = await axios.post(

          "http://192.168.1.6:3000/specialOrder/save", // Replace with your API endpoint

          formData,
          {
            headers: {
              "Content-Type": "multipart/form-data",
            },
          }
        );

        console.log("File uploaded successfully:", response.data);
        alert(`Special order saved successfully`);
      } catch (error) {
        console.error("Error uploading file:", error);
        alert("Failed to upload file");
      }
    }

    function uploadToAPI() {
      const exporter = new GLTFExporter();

      exporter.parse(
        group.current, // Your 3D model group reference
        async function (result) {
          const blob = new Blob([result], { type: "application/octet-stream" });
          const filename = `Bouquet_${Date.now()}.glb`;

          // Call the API upload function
          await uploadFileToAPI(blob, filename);
        },
        function (error) {
          console.error("Error exporting model:", error);
        },
        { binary: true }
      );
    }

    setDownload(uploadToAPI);
  }, [setDownload]);

  return (
    <group ref={group} {...props} dispose={null}>
      {/* Customizations */}
      {Object.keys(customization).map((key) => {
        const asset = customization[key]?.asset;
        const flowerCount = customization[key]?.flowerCount || 1; // Get flower count (defaults to 1)

        if (asset?.url) {
          const positionOffset = [0, vaseHeight, 0]; // Lowered to fit inside vase
          const scale = customization[key].scale || defaultFlowerScale; // Adjusted scale
          const assetColor = customization[key]?.color || "#ffffff"; // Default color if none specified

          console.log(asset.name);
          if (asset.name === "GlassVase") {
            // Apply specific properties for the "Kala_013" mesh
            return (
              <Suspense key={asset.id}>
                <group
                  position={[0, 0, 0]} // Adjust the vase position
                  scale={[5, 5, 5]} // Adjust scale as needed
                  rotation={[-Math.PI / 2, 0, 0]}
                  dispose={null}
                >
                  <mesh
                    castShadow
                    receiveShadow
                    geometry={nodes.Kala_013.geometry}
                    scale={0.01} // Adjust vase scale here
                  >
                    <meshPhysicalMaterial
                      color={assetColor} // Base color for the glass
                      transparent={true} // Enable transparency
                      opacity={0.5} // Adjust transparency
                      roughness={0.1} // Smoothness of the surface
                      metalness={0} // Minimal metallic effect
                      transmission={0.1} // High transmission for glass effect
                      ior={3} // Index of refraction (glass-like)
                      thickness={0.2} // Physical thickness for refraction
                      clearcoat={1} // Reflective coating
                      clearcoatRoughness={0} // Smooth clearcoat
                    />
                  </mesh>
                </group>
              </Suspense>
            );
          }
          if (asset.name === "CurvedVase") {
            const selectedColor = customization[key]?.color || "#ffffff";

            return (
              <Suspense key={asset.id}>
                <CurvedVaseModel color={selectedColor} />
              </Suspense>
            );
          }
          if (asset.name === "TwoPartsVase") {
            const selectedColor = customization[key]?.color;

            return (
              <Suspense key={asset.id}>
                <TwoPartsVaseModel color={selectedColor} />
              </Suspense>
            );
          }

          if (asset.name === "Tulip") {
            const selectedColor = customization[key]?.color || "#ffffff";

            // Render TulipModel or ClosedTulipModel based on the index
            return Array.from({ length: flowerCount }).map((_, index) => {
              const rotationY = (index / flowerCount) * (Math.PI * 2); // Rotate each flower based on its index

              return (
                <Suspense key={index}>
                  <group
                    position={
                      customization[key].position
                        ? customization[key].position.map(
                            (val, idx) => val + positionOffset[idx]
                          )
                        : positionOffset
                    }
                    rotation={[0, rotationY, 0]}
                    scale={scale}
                  >
                    {index % 2 === 0 ? (
                      <TulipModel color={selectedColor} />
                    ) : (
                      <ClosedTulipModel color={selectedColor} />
                    )}
                  </group>
                </Suspense>
              );
            });
          }
          if (asset.name === "Orchid") {
            const selectedColor = customization[key]?.color || "#ffffff";

            return Array.from({ length: flowerCount }).map((_, index) => {
              const rotationY = (index / flowerCount) * (Math.PI * 2); // Rotate each flower based on its index

              // Define a tiny radius for the circular pattern
              const radius = 1; // Adjust the radius as needed for the size of the circle

              // Calculate the x and z positions based on the circular pattern
              const xPosition =
                Math.cos((index / flowerCount) * (Math.PI * 2)) * radius;
              const zPosition =
                Math.sin((index / flowerCount) * (Math.PI * 2)) * radius;

              return Array.from({ length: flowerCount }).map((_, index) => {
                const rotationY = (index / flowerCount) * (Math.PI * 2); // Rotate each flower based on its index
                const radius = 0.5; // Adjust the radius

                const xPosition =
                  Math.cos((index / flowerCount) * (Math.PI * 2)) * radius;
                const zPosition =
                  Math.sin((index / flowerCount) * (Math.PI * 2)) * radius;

                return (
                  <Suspense key={index}>
                    <group
                      position={
                        customization[key]?.position
                          ? customization[key].position.map(
                              (val, idx) => val + positionOffset[idx]
                            )
                          : positionOffset
                      }
                      rotation={[0, rotationY, 0]}
                      scale={scale}
                    >
                      <group position={[xPosition, 0, zPosition]}>
                        {index % 2 === 0 ? (
                          <OrchidModel color={selectedColor} />
                        ) : (
                          <Orchid2Model color={selectedColor} />
                        )}
                      </group>
                    </group>
                  </Suspense>
                );
              });
            });
          }

          if (asset.name === "Chrysanthemum") {
            const selectedColor = customization[key]?.color || "#ffffff";

            // Render CuteOneModel based on the index
            return Array.from({ length: flowerCount }).map((_, index) => {
              const rotationY = (index / flowerCount) * (Math.PI * 2); // Rotate each flower evenly around a circle

              return (
                <Suspense key={index}>
                  <group
                    position={
                      customization[key].position
                        ? customization[key].position.map(
                            (val, idx) => val + positionOffset[idx]
                          )
                        : positionOffset
                    }
                    rotation={[0, rotationY, 0]}
                    scale={scale}
                  >
                    {index % 2 === 0 ? (
                      <ChrysanthemumModel color={selectedColor} />
                    ) : (
                      <OpenChrysanthemumModel color={selectedColor} />
                    )}
                  </group>
                </Suspense>
              );
            });
          }

          if (asset.name === "Eucalyptus") {
            // Render CuteOneModel based on the index

            // Render CuteOneModel based on the index
            return Array.from({ length: flowerCount }).map((_, index) => {
              const rotationY = (index / flowerCount) * (Math.PI * 2); // Rotate each flower evenly around a circle

              return (
                <Suspense key={index}>
                  <group rotation={[0, rotationY, 0]}>
                    {index % 2 === 0 ? <GreeneryModel /> : <Greenery2Model />}
                  </group>
                </Suspense>
              );
            });
          }
          if (asset.name === "Olive") {
            return Array.from({ length: flowerCount }).map((_, index) => {
              const rotationY = (index / flowerCount) * (Math.PI * 2); // Rotate each flower evenly around a circle

              return (
                <Suspense key={index}>
                  <group rotation={[0, rotationY, 0]}>
                    <Greenery22Model />
                  </group>
                </Suspense>
              );
            });
          }
          if (asset.name === "BabyFlower") {
            const selectedColor = customization[key]?.color || "#ffffff";

            return Array.from({ length: flowerCount }).map((_, index) => {
              const rotationY = (index / flowerCount) * (Math.PI * 2); // Rotate each flower evenly around a circle

              return (
                <Suspense key={index}>
                  <group rotation={[0, rotationY, 0]}>
                    <BabyModel color={selectedColor} />
                  </group>
                </Suspense>
              );
            });
          }
        }

        return null;
      })}
    </group>
  );
};
