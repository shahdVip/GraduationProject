import { BouquetBuilder } from "./Avatar";

import { useThree } from "@react-three/fiber";
import { useEffect } from "react";
import { useConfiguratorStore } from "../store";

import {
  Backdrop,
  Environment,
  OrbitControls,
  SoftShadows,
} from "@react-three/drei";

import { AxesHelper } from "three";

export const Experience = () => {
  const setScreenshot = useConfiguratorStore((state) => state.setScreenshot);
  const gl = useThree((state) => state.gl);
  useEffect(() => {
    const screenshot = () => {
      const overlayCanvas = document.createElement("canvas");

      overlayCanvas.width = gl.domElement.width;
      overlayCanvas.height = gl.domElement.height;
      const overlayCtx = overlayCanvas.getContext("2d");
      if (!overlayCtx) {
        return;
      }
      // Draw the original rendered image onto the overlay canvas
      overlayCtx.drawImage(gl.domElement, 0, 0);

      // Create a link element to download the image
      const link = document.createElement("a");
      const date = new Date();
      link.setAttribute(
        "download",
        `Avatar_${
          date.toISOString().split("T")[0]
        }_${date.toLocaleTimeString()}.png`
      );
      link.setAttribute(
        "href",
        overlayCanvas
          .toDataURL("image/png")
          .replace("image/png", "image/octet-stream")
      );
      link.click();
    };
    setScreenshot(screenshot);
  }, [gl]);
  return (
    <>
      <OrbitControls
      // minPolarAngle={Math.PI / 4}
      // maxPolarAngle={Math.PI / 2}
      // minAzimuthAngle={-Math.PI / 4}
      // maxAzimuthAngle={Math.PI / 4}
      />
      <Environment preset="sunset" environmentIntensity={0.3} />

      <Backdrop scale={[50, 20, 10]} floor={1.5} receiveShadow position-z={-4}>
        <meshStandardMaterial color="#eaeaea" />
      </Backdrop>

      <SoftShadows size={52} samples={16} />

      {/* Key Light */}
      <directionalLight
        position={[5, 5, 5]}
        intensity={2.2}
        castShadow
        shadow-mapSize-width={2048}
        shadow-mapSize-height={2048}
        shadow-bias={-0.0001}
      />

      {/* <axesHelper args={[5]} /> */}

      {/* Fill Light */}
      <directionalLight position={[-5, 5, 5]} intensity={0.7} />
      {/* Back Lights */}
      <directionalLight position={[1, 0.1, -5]} intensity={1} color={"white"} />
      <directionalLight
        position={[-1, 0.1, -5]}
        intensity={2}
        color={"white"}
      />
      <BouquetBuilder />
    </>
  );
};
